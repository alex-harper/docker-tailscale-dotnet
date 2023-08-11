#!/bin/bash
tailscaled &
tailscale up --authkey=$TS_AUTHKEY --hostname=$TS_HOSTNAME --accept-routes & 
./TailscaleWorker