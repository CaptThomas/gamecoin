### Qos ###

This is a Linux bash script that will set up tc to limit the outgoing bandwidth for connections to the Gamecoin network. It limits outbound TCP traffic with a source or destination port of 62005, but not if the destination IP is within a LAN (defined as 192.168.x.x).

This means one can have an always-on gamecoind instance running, and another local gamecoind/gamecoin-qt instance which connects to this node and receives blocks from it.
