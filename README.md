# Solutions Engineering Template Repository

A template repository that contains all required files (LICENSE, SUPPORT, CONTRIBUTING, etc) as outlined in the org standards.  

The sections below are recommended in your project's README.md file.

## Overview

Provide a short overview of the project.

## Getting Started

Provide a quick example of how to use your code.  This should provide the user with a launch point to quickly see what the project can offer them.

## Installation

This has already been completed, but if updates are needed here's how to pull the various configs down.

### BIG-IP A

```bash
curl -s -o /tmp/f5-bigip-runtime-init-2.0.3-1.gz.run https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v2.0.3/dist/f5-bigip-runtime-init-2.0.3-1.gz.run
bash /tmp/f5-bigip-runtime-init-2.0.3-1.gz.run --
curl -s -o /config/runtime-init-conf.yaml https://raw.githubusercontent.com/mhermsdorferf5/bigip-bgp-ecmp-lab/refs/heads/main/bigip-a_runtime-init.yaml
f5-bigip-runtime-init --config-file /config/runtime-init-conf.yaml
```

### BIG-IP B

```bash
curl -s -o /tmp/f5-bigip-runtime-init-2.0.3-1.gz.run https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v2.0.3/dist/f5-bigip-runtime-init-2.0.3-1.gz.run
bash /tmp/f5-bigip-runtime-init-2.0.3-1.gz.run --
curl -s -o /config/runtime-init-conf.yaml https://raw.githubusercontent.com/mhermsdorferf5/bigip-bgp-ecmp-lab/refs/heads/main/bigip-b_runtime-init.yaml
f5-bigip-runtime-init --config-file /config/runtime-init-conf.yaml
```

### BIG-IP C

```bash
curl -s -o /tmp/f5-bigip-runtime-init-2.0.3-1.gz.run https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v2.0.3/dist/f5-bigip-runtime-init-2.0.3-1.gz.run
bash /tmp/f5-bigip-runtime-init-2.0.3-1.gz.run --
curl -s -o /config/runtime-init-conf.yaml https://raw.githubusercontent.com/mhermsdorferf5/bigip-bgp-ecmp-lab/refs/heads/main/bigip-c_runtime-init.yaml
f5-bigip-runtime-init --config-file /config/runtime-init-conf.yaml
```

### AS3 App Config

```bash
curl -s -o /config/as3.json https://raw.githubusercontent.com/mhermsdorferf5/bigip-bgp-ecmp-lab/refs/heads/main/anycast-app-as3.json
curl -k -u admin:admin -d @/config/as3.json https://127.0.0.1/mgmt/shared/appsvcs/declare
```

## Usage

The UDF environment is fully up and running when when started.  Traffic will start flowing across all 3 BIG-IPs from the traffic generator linux instance, through the BIG-IPs, to four pool members on the 'server' linux instance.

### Check routing on vyos router

* SSH into VYOS Router.
* Use "show ip route" or "show bpg ipv4" to observe the FIB and RIB tables.
* Use "show bgp summary" to check for neighbor adjacency and state.

```bash
vyos@vyos:~$ show bgp summary

IPv4 Unicast Summary (VRF default):
BGP router identifier 10.255.255.1, local AS number 65540 vrf-id 0
BGP table version 15
RIB entries 13, using 2496 bytes of memory
Peers 3, using 2172 KiB of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
10.1.10.5       4      65541      6703      6161        0    0    0 02:16:34            1        7 N/A
10.1.20.6       4      65542       550       547        0    0    0 01:12:09            1        7 N/A
10.1.30.7       4      65543       958       903        0    0    0 01:47:38            1        7 N/A

Total number of neighbors 3
vyos@vyos:~$
vyos@vyos:~$ show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

S>* 0.0.0.0/0 [210/0] via 10.1.1.1, eth0, weight 1, 1d05h51m
C>* 10.1.1.0/24 is directly connected, eth0, 1d06h11m
C>* 10.1.10.0/24 is directly connected, eth1, 1d05h51m
C>* 10.1.20.0/24 is directly connected, eth2, 1d05h51m
C>* 10.1.30.0/24 is directly connected, eth3, 1d05h51m
C>* 10.1.40.0/24 is directly connected, eth4, 1d05h51m
B>* 10.100.101.50/32 [20/0] via 10.1.10.5, eth1, weight 1, 00:48:44
  *                         via 10.1.20.6, eth2, weight 1, 00:48:44
  *                         via 10.1.30.7, eth3, weight 1, 00:48:44
B>* 10.100.101.100/32 [20/0] via 10.1.10.5, eth1, weight 1, 00:03:13
  *                          via 10.1.20.6, eth2, weight 1, 00:03:13
  *                          via 10.1.30.7, eth3, weight 1, 00:03:13
C>* 10.255.255.1/32 is directly connected, lo, 1d05h32m
vyos@vyos:~$
vyos@vyos:~$ show bgp ipv4
BGP table version is 16, local router ID is 10.255.255.1, vrf id 0
Default local pref 100, local AS 65540
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

   Network          Next Hop            Metric LocPrf Weight Path
*> 10.1.1.0/24      0.0.0.0                 50         32768 ?
*> 10.1.10.0/24     0.0.0.0                 50         32768 ?
*> 10.1.20.0/24     0.0.0.0                 50         32768 ?
*> 10.1.30.0/24     0.0.0.0                 50         32768 ?
*> 10.1.40.0/24     0.0.0.0                 50         32768 ?
*  10.100.101.50/32 10.1.20.6                              0 65542 ?
*                   10.1.10.5                              0 65541 ?
*>                  10.1.30.7                              0 65543 ?
*  10.100.101.100/32
                    10.1.10.5                              0 65541 ?
*                   10.1.20.6                              0 65542 ?
*>                  10.1.30.7                              0 65543 ?
*> 10.255.255.1/32  0.0.0.0                 50         32768 ?

Displayed  8 routes and 12 total paths
vyos@vyos:~$
```

### Check routing on BIG-IPs

* SSH into any BIG-IP.
* Use "tmsh show net routing" to check for neighbor adjacency and state.
* Use "tmsh show net route" to check that dynamic route entries are found for 10.1.10.0/24, 10.1.20.0/24, 10.1.30.0/24, 10.1.40.0/24, etc.
* Use "show ip route" or "show bpg ipv4" to observe the FIB and RIB tables.

```bash
root@(bigip-a)(cfg-sync In Sync)(Active)(/Common)(tmos)# imish -e "show ip route"
Codes: K - kernel, C - connected, S - static, R - RIP, B - BGP
       O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2
       i - IS-IS, L1 - IS-IS level-1, L2 - IS-IS level-2, ia - IS-IS inter area
       * - candidate default

C       10.1.10.0/24 is directly connected, subnet10
K       10.100.101.50/32 [0/0] is directly connected, tmm
C       127.0.0.1/32 is directly connected, lo
C       127.1.1.254/32 is directly connected, tmm

Gateway of last resort is not set
root@(bigip-a)(cfg-sync In Sync)(Active)(/Common)(tmos)# show net route

----------------------------------------------------------------------------------
Net::Routes
Name                Destination         Type       NextHop               Origin
----------------------------------------------------------------------------------
127.20.0.0/16       127.20.0.0/16       interface  tmm_bp                connected
10.1.10.0/24        10.1.10.0/24        interface  /Common/subnet10      connected
127.1.1.0/24        127.1.1.0/24        interface  tmm                   connected
fe80::%vlan4090/64  fe80::%vlan4090/64  interface  /Common/subnet10      connected
ff02:fff::/64       ff02:fff::/64       interface  tmm_bp                connected
fe80::%vlan4095/64  fe80::%vlan4095/64  interface  tmm_bp                connected
fe80::/64           fe80::/64           interface  /Common/socks-tunnel  connected
fe80::/64           fe80::/64           interface  /Common/http-tunnel   connected
fe80::%vlan4095/64  fe80::%vlan4095/64  interface  /Common/tmm_bp        connected
ff02:fff::/64       ff02:fff::/64       interface  /Common/tmm_bp        connected
ff02:ffa::/64       ff02:ffa::/64       interface  /Common/subnet10      connected
ff02::/64           ff02::/64           interface  tmm                   connected
fe80::/64           fe80::/64           interface  tmm                   connected
10.1.20.0/24        10.1.20.0/24        gw         10.1.10.8             dynamic
10.1.30.0/24        10.1.30.0/24        gw         10.1.10.8             dynamic
10.255.255.1/32     10.255.255.1/32     gw         10.1.10.8             dynamic
10.1.40.0/24        10.1.40.0/24        gw         10.1.10.8             dynamic
10.1.1.0/24         10.1.1.0/24         gw         10.1.10.8             dynamic
root@(bigip-a)(cfg-sync In Sync)(Standby)(/Common)(tmos)# 
root@(bigip-a)(cfg-sync In Sync)(Active)(/Common)(tmos)# imish -e "show bgp route"
root@(bigip-a)(cfg-sync In Sync)(Active)(/Common)(tmos)# quit
[root@bigip-a:Active:In Sync] config # tmsh show net route

----------------------------------------------------------------------------------
Net::Routes
Name                Destination         Type       NextHop               Origin
----------------------------------------------------------------------------------
127.20.0.0/16       127.20.0.0/16       interface  tmm_bp                connected
10.1.10.0/24        10.1.10.0/24        interface  /Common/subnet10      connected
127.1.1.0/24        127.1.1.0/24        interface  tmm                   connected
fe80::%vlan4090/64  fe80::%vlan4090/64  interface  /Common/subnet10      connected
ff02:fff::/64       ff02:fff::/64       interface  tmm_bp                connected
fe80::%vlan4095/64  fe80::%vlan4095/64  interface  tmm_bp                connected
fe80::/64           fe80::/64           interface  /Common/socks-tunnel  connected
fe80::/64           fe80::/64           interface  /Common/http-tunnel   connected
fe80::%vlan4095/64  fe80::%vlan4095/64  interface  /Common/tmm_bp        connected
ff02:fff::/64       ff02:fff::/64       interface  /Common/tmm_bp        connected
ff02:ffa::/64       ff02:ffa::/64       interface  /Common/subnet10      connected
ff02::/64           ff02::/64           interface  tmm                   connected
fe80::/64           fe80::/64           interface  tmm                   connected
[root@bigip-a:Active:In Sync] config # tmsh show net routing
[api-status-warning] net/routing/bgp is early_access

--------------------------------------------
Net::BGP Instance (route-domain: 0)
--------------------------------------------
  Name                               bgp_rd0
  Local AS                             65541

  --------------------------------------------------------
  | Net::BGP Neighbor - 10.1.10.8 via 10.1.10.5
  --------------------------------------------------------
  | Remote AS                   0
  | State                       established   0:07:26
  | Notification
  | Address Family              IPv4 Unicast  IPv6 Unicast
  |  Prefix
  |   Accepted                  6             0
  |   Announced                 1             0
  |  Table Version
  |   Local                     2             1
  |   Neighbor                  2             1
  | Message/Notification/Queue  Sent          Received
  |  Message                    48            51
  |  Notification               0             0
  |  Queued                     0             0
  | Route Refresh               0             0

[root@bigip-a:Active:In Sync] config #
[root@bigip-a:Active:In Sync] config # imish -e "show ip route"
Codes: K - kernel, C - connected, S - static, R - RIP, B - BGP
       O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2
       i - IS-IS, L1 - IS-IS level-1, L2 - IS-IS level-2, ia - IS-IS inter area
       * - candidate default

C       10.1.10.0/24 is directly connected, subnet10
K       10.100.101.50/32 [0/0] is directly connected, tmm
C       127.0.0.1/32 is directly connected, lo
C       127.1.1.254/32 is directly connected, tmm

Gateway of last resort is not set
[root@bigip-a:Active:In Sync] config # imish -e "show bgp ipv4 unicast"
BGP table version is 3, local router ID is 10.255.255.10
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal, l - labeled
              S Stale
Origin codes: i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric     LocPrf     Weight Path
*> 10.100.101.50/32 0.0.0.0                                    32768 ?

Total number of prefixes 1
[root@bigip-a:Active:In Sync] config #
```

## Development

Outline any requirements to setup a development environment if someone would like to contribute.  You may also link to another file for this information.

## Support

For support, please open a GitHub issue.  Note, the code in this repository is community supported and is not supported by F5 Networks.  For a complete list of supported projects please reference [SUPPORT.md](SUPPORT.md).

## Community Code of Conduct

Please refer to the [F5 DevCentral Community Code of Conduct](code_of_conduct.md).

## License

[Apache License 2.0](LICENSE)

## Copyright

Copyright 2014-2020 F5 Networks Inc.

### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects.
Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein.
You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA.
