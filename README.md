# bengomesh

this should set up my mesh network.

The network should be able to span
* 2 x [WD-N600](https://wiki.openwrt.org/toh/wd/n600)s  - Used as wireless gateways throughout my apt. Currently running sudowrt.
* 1 x container running on k8s.bengo.is that has an IP on this mesh and can respond to simple HTTP requests
* 1 x container running on k8s.bengo.is that has a public nonmesh IP/domain, and hosts a web service that lets you find out info about the mesh. e.g. which IPs are mapped to what

## Usage

```
⚡ ./bin/bengomesh 
Usage:
./bin/bengomesh digitalocean-exitnode [options]

Options:
-h| --help                              print this help text
```

Docker

```
⚡ docker build -t bengomesh .
# ...
⚡ docker run \
    -v /Users/ben/dev/sudomesh/bengomesh:/opt/bengomesh \
    -v  ~/.config/doctl/config.yaml:/root/.config/doctl/config.yaml \
    -v /Users/ben/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub bengomesh \
    digitalocean-exitnode list
# Or here is a convenience wrapper for the same `docker run...`
⚡ ./bin/bengomesh-docker -h
Usage:
./bengomesh digitalocean-exitnode [options]

Options:
-h| --help                              print this help text
```

## digitalocean-exitnode

Manage exitnodes in DigitalOcean

Status:
* [x] - create/delete droplet via `doctl`
* [ ] - provision exitnode once droplet is booted using makenode

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
