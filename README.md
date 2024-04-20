# Tailscale status monitoring with Nagios

This repo consists of a simple Ansible playbook which deploys a bash script to your Tailscale endpoints, and some sample Nagios config files for your Tailscale endpoints. I use it for monitoring my subnet routers, but you could use it for making sure any device's Tailscale connection is up. My network is set up in such a way that the Nagios host and the subnet routers are on the same LAN and should always be able to communicate regardless of the Tailscale connection's status, if you're trying to use this with devices on a remote network that normally communicate over Tailscale, you will run into issues if the connection goes down.

# Setup

1. Copy `tailscale-heartbeat.sh` to `/usr/local/tailscale-heartbeat.sh` (Or whatever directory your distro prefers)
2. `chmod +x` tailscale-heartbeat.sh to ensure it's executable
3. Copy `send-nrdp.sh` from your NRDP install's clients folder to `/usr/local/send-nrdp.sh` (Or wherever else you want, you'll need to update the script manually if you put it elsewhere)
4. `chmod +x` send-nrdp.sh as well
5. Create a cron job to run `tailscale-heartbeat.sh`. I chose to run it every 5 minutes.
6. Copy tailscale-endpoint.cfg to `/usr/local/nagios/etc/objects/tailscale-endpoint.cfg` and add it to `nagios.cfg`
7. Restart the Nagios systemd service

You should see your Tailscale nodes reporting in within a few minutes.

# Legal stuff
Licensed under GNU GPL, see LICENSE.md for details.

send_nrdp.sh was taken from https://github.com/NagiosEnterprises/nrdp/blob/master/clients/send_nrdp.sh, I didn't write it. Just including it for ease of use.