# bengomesh

this should set up my mesh network.

The network should be able to span
* 2 x [WD-N600](https://wiki.openwrt.org/toh/wd/n600)s  - Used as wireless gateways throughout my apt. Currently running sudowrt.
* 1 x container running on k8s.bengo.is that has an IP on this mesh and can respond to simple HTTP requests
* 1 x container running on k8s.bengo.is that has a public nonmesh IP/domain, and hosts a web service that lets you find out info about the mesh. e.g. which IPs are mapped to what

## Usage

* ./bengomesh-node 

## Components

* bengomesh-node - basic host on the network, has a bengomesh IP. Can talk to other nodes.
* bengomesh-broker - node that also accepts tunnel requests.
