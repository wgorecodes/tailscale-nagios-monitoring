# Tailscale status monitoring with Nagios

This repo consists of a simple Ansible playbook which deploys a bash script to your Tailscale endpoints, and some sample Nagios config files for your Tailscale endpoints. I use it for monitoring my subnet routers, but you could use it for making sure any device's Tailscale connection is up. My network is set up in such a way that the Nagios host and the subnet routers are on the same LAN and should always be able to communicate regardless of the Tailscale connection's status, if you're trying to use this with devices on a remote network that normally communicate over Tailscale, you will run into issues if the connection goes down.

# Setup

1. Open `deploy-ts-monitoring.yaml` and change the variables as documented (Note, both scripts must be in the same directory to function properly)
2. Create a host_vars file for each of your endpoints in host_vars, based on `host_vars/endpoint1.yaml`
3. Run the Ansible playbook with `ansible-playbook deploy-ts-monitoring.yaml`
4. Modify tailscale-endpoint.cfg to include a host definition for each of your Tailscale endpoints
5. Copy tailscale-endpoint.cfg to `/usr/local/nagios/etc/objects/tailscale-endpoint.cfg` and add it to `nagios.cfg`
6. Restart the Nagios systemd service

You should see your Tailscale nodes reporting in within a few minutes.

# Legal stuff
Licensed under GNU GPL, see LICENSE.md for details.

send_nrdp.sh was taken from https://github.com/NagiosEnterprises/nrdp/blob/master/clients/send_nrdp.sh, I didn't write it. Just including it for ease of use.