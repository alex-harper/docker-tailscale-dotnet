#!/bin/bash
#tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
tailscaled &
tailscale up --authkey=$TS_AUTHKEY --hostname=$TS_HOSTNAME --accept-routes & 
./TailscaleAndDotnet