# bengomesh

this should set up my mesh network.

What does that mean?

Right now I've got some tools here to spin up and down virtual computers (i.e. nodes) that will all talk to each other on [peoplesopen.network](https://peoplesopen.net/documentation/). Follow [sudomesh/node-whisperer-program](https://github.com/sudomesh/node-whisperer-program) to learn with us.

There are a couple roles that different computers play to make this network happen
* all nodes
  * run [babeld](https://github.com/jech/babeld) - find and chat with other nodes so you know which ones are closest. To reach far nodes, you ask close ones to route the packet for you.
  * run [tunneldigger](http://tunneldigger.readthedocs.io/en/latest/) client when connecting to exit nodes
* exitnodes - run [sudomesh/exitnode](https://github.com/sudomesh/exitnode), which includes a [tunneldigger.broker](https://github.com/sudomesh/tunneldigger/tree/master/broker). They are the last hop from other nodes (e.g. a router in your house) to the 'big internet' that you're used to. In this way, these nodes sort of act like VPN servers, helping anonymize your traffic and that of others meshers.
* home nodes - run in your home! And usually have radio antennas so they can launch Wi-Fi Network SSIDs (e.g. peoplesopen.net) for others to join, and to find other nodes to mesh with wirelessly.

What's the end result?
* if you run a home node, and its close to other home nodes, the home nodes will mesh. And even if you don't have an internet connection, you can use your neighbor's as long as you can hop to another node with an internet connection
* even if the clouds crash, including all exit nodes and the ISPs themselves, you will still have a little baby internet that works to talk to any node on the network that you can 'hop to'. The more of your neighbors use it, the more useful it is.

## Devices

For my early goals, the network should be able to span
* 2 x [WD-N600](https://wiki.openwrt.org/toh/wd/n600)s  - Used as wireless gateways throughout my apt. Currently running sudowrt.
* 1 x container running on k8s.bengo.is that has an IP on this mesh and can respond to simple HTTP requests
* 1 x container running on k8s.bengo.is that has a public nonmesh IP/domain, and hosts a web service that lets you find out info about the mesh. e.g. which IPs are mapped to what

## Usage

These scripts will have commands added to them over time.

```
⚡ ./bin/bengomesh 
Usage:
./bin/bengomesh digitalocean-exitnode [options]

Options:
-h| --help                              print this help text
```

### Docker

```
⚡ ./bin/bengomesh-docker
Usage:
./bin/bengomesh digitalocean-exitnode [options]
./bin/bengomesh doctl-sshkey

Options:
-h| --help                              print this help text
```

It's basically just doing this

```
⚡ docker build -t bengomesh .
# ...
⚡ docker run \
    -v "$HOME/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub" \
    -v "/Users/ben/.config/doctl/config.yaml:/root/.config/doctl/config.yaml" \
    bengomesh
# ... help text
```

## digitalocean-exitnode

Manage exitnodes in DigitalOcean

Status:
* [x] - create/delete droplet via `doctl`
* [x] - provision exitnode once droplet is booted using makenode
* [x] - check - place to put common diagnostic output
* [ ] - check_babeld - actually try to udp with babeld and make sure it's responding well
* [ ] - check_tunnel_broker - actually try to talk with tunneldigger.broker and make sure its responding well

```
⚡ ./bin/bengomesh digitalocean-exitnode
Usage:
./bin/digitalocean-exitnode <droplet_name> [command] [options]
./bin/digitalocean-exitnode <droplet_name> up
./bin/digitalocean-exitnode <droplet_name> status
./bin/digitalocean-exitnode <droplet_name> down [-f]

Commands:
up                              create/launch the exitnode
down                            delete the exitnode

Options:
-h| --help                      print this help text
-f                              force deletion, i.e. dont ask for confirmation
```

This script also supports being symlinked to. If you do this, the resulting symlink will manage a droplet whose name is the filename

```
⚡ ln -s digitalocean-exitnode ./bin/tmp-vm-0
⚡ ./bin/tmp-vm-0 up
ID          Name        Public IPv4     Private IPv4    Public IPv6    Memory    VCPUs    Disk    Region    Image              Status    Tags    Features    Volumes
83759987    tmp-vm-0    159.65.45.36                                   512       1        20      nyc3      Debian 8.10 x64    active                        
⚡ ./bin/tmp-vm-0 down
Warning: Are you sure you want to delete droplet(s) (y/N) ? y
⚡ ./bin/tmp-vm-0
Usage:
./bin/tmp-vm-0 [command] [options]
./bin/tmp-vm-0 up
./bin/tmp-vm-0 status
./bin/tmp-vm-0 down [-f]

Commands:
up                              create/launch the exitnode
down                            delete the exitnode

Options:
-h| --help                      print this help text
-f                              force deletion, i.e. dont ask for confirmation
```
