# porttrigger
User space Port trigger function 

To use port trigger Linux user space function prerequesite is:

1.tcpdump

2.iptables support for port forward 

3.nice

This assume :

Your system has bridge br0 for LAN
WAN or internet facing interface eth2.4 or 2.5 or eth3
Usage:

nice --20 porttrigger trig_rule_no trigger_port fwd_port

Example (port): porttrigger 1 6565 8585

Example (port range): porttrigger 2 6565-6570 8585-8590

Example (port range): porttrigger 3 6565-6570 8585

Example (port range): porttrigger 4 6565 8585-8590

Trigger rule number has to be unique number amount all port trigger setup.
