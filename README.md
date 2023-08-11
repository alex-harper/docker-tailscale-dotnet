# docker-tailscale-dotnet
A dockerised tailscale and dotnet setup

### Why?
I needed to run a distrubuted app, where some of the containers needed to live on a different host and are only provisioned when needed.

### To run:
- Copy .env.sample to .env, and add you tailscale key for provisioning nodes
- Run: docker compose up
- You should now have two nodes join your tailscale network, and the nodes will both be able to see each other (eg: get a shell on one of the containers and `ping tailscale-dotnet` or `ping tailscale-dotnet-worker`)

### How does it work?
This setup passes the host `/dev/net/tun` device to the container so that it can establish a wireguard vpn connection.
I did try to do this with userspace networking, and it almost worked.. but I ran out of patience. Userspace networking also required changes to the app to use a SOCKS5 proxy, which is fine, but I didn't want to change my app if possible.

### The non-standard stuff
This uses an extra section in the `Dockerfile` to install tailscale:
```dockerfile
FROM base as tailscale
RUN apt update && apt install curl iputils-ping net-tools -y
RUN curl -fsSL https://tailscale.com/install.sh | sh
```

It also adds a startup script, `entrypoint.sh`

```shell
#!/bin/bash
tailscaled &
tailscale up --authkey=$TS_AUTHKEY --hostname=$TS_HOSTNAME --accept-routes & 
./TailscaleWorker
```

And uses this as a custom entry point:

```dockerfile
FROM tailscale AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
```

Apart from this, the dotnet side of things is completely unchanged.

If you need to check the status of the wireguard connection, the following may be useful:

```shell
# This should show the network nodes, but doesn't mean routing will work
tailscale status

# This should show the wireguard routing table, if not then setup has failed and you won't be able to resolve nodes
ip route show table 52

# This will show the network devices, you should see an entry for tailscale0
ip addr
```
