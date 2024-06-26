#!/bin/bash

# Tailscale heartbeat script for Nagios NRDP
# Uses send_nrdp.sh to report Tailscale connectivity status to Nagios

token="$1"
host="$3"
nrdp_endpoint="http://$2/nrdp/"

if [[ $1 == "" || $2 == "" || $3 == "" ]]; then
    echo "Missing arguments, exitting."
    exit 1
fi

echo "$(pwd)/send_nrdp.sh"

# Check if send_nrdp.sh exists. If not we're screwed!
if ! test -f "$(pwd)/send_nrdp.sh"; then
  echo "send_nrdp.sh missing! Exitting."
  exit 1
fi

# Check status of tailscaled systemd service. Should return "running", if anything else, we have an issue.
systemd_status=$(systemctl show -p SubState --value tailscaled)
printf "tailscaled.service status: $systemd_status\n"

# Compare status to what we expect
if [[ "$systemd_status" != "running" ]]; then
    # Service isn't running! bad bad bad
    ./send_nrdp.sh -u $nrdp_endpoint -t $token -H $host -s "Tailscale Systemd Service" -S 2 -o "tailscaled.service is not running. Current state: $systemd_status"
else
    # Service is running, we're good.
    ./send_nrdp.sh -u $nrdp_endpoint -t $token -H $host -s "Tailscale Systemd Service" -S 0 -o "tailscaled.service is running."
fi

# Check status text of tailscaled. If the connection is down, we'll see "Stopped; run 'tailscale up' to log in" and that's an issue. 
# If it's anything else, we will report that string to nrdp as our current status
systemd_statustext=$(systemctl show -p StatusText --value tailscaled)
printf "tailscaled.service statustext: $systemd_statustext\n"

# Compare statustext
if [[ "$systemd_statustext" == "Stopped; run 'tailscale up' to log in" ]]; then
    # Tailscale isn't connected!
    ./send_nrdp.sh -u $nrdp_endpoint -t $token -H $host -s "Tailscale Connection" -S 1 -o "tailscale is not connected! Status text: $systemd_statustext"
else
    ./send_nrdp.sh -u $nrdp_endpoint -t $token -H $host -s "Tailscale Connection" -S 0 -o "Tailscale is connected. Status text: $systemd_statustext"
fi