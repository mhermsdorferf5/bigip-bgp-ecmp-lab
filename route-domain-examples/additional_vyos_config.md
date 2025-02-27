# Vyos config to support demo

## Required basic Config

```text
# Add subnet50 interface
set interfaces ethernet eth5 description 'subnet50'
set interfaces ethernet eth5 address 10.1.50.8/24

# BGP Peer BIG-IP A_subnet20:
set protocols bgp neighbor 10.1.20.5 remote-as 65551
set protocols bgp neighbor 10.1.20.5 update-source 10.255.255.1
set protocols bgp neighbor 10.1.20.5 address-family ipv4-unicast soft-reconfiguration inbound
# BGP Peer BIG-IP A_subnet30:
set protocols bgp neighbor 10.1.30.5 remote-as 65561
set protocols bgp neighbor 10.1.30.5 update-source 10.255.255.1
set protocols bgp neighbor 10.1.30.5 address-family ipv4-unicast soft-reconfiguration inbound
# BGP Peer BIG-IP A_subnet40:
set protocols bgp neighbor 10.1.40.5 remote-as 65571
set protocols bgp neighbor 10.1.40.5 update-source 10.255.255.1
set protocols bgp neighbor 10.1.40.5 address-family ipv4-unicast soft-reconfiguration inbound
# BGP Peer BIG-IP A_subnet50:
set protocols bgp neighbor 10.1.50.5 remote-as 65581
set protocols bgp neighbor 10.1.50.5 update-source 10.255.255.1
set protocols bgp neighbor 10.1.50.5 address-family ipv4-unicast soft-reconfiguration inbound


# BGP Peer BIG-IP B_subnet20:
set protocols bgp neighbor 10.1.10.6 remote-as 65562
set protocols bgp neighbor 10.1.10.6 update-source 10.255.255.1
set protocols bgp neighbor 10.1.10.6 address-family ipv4-unicast soft-reconfiguration inbound
# BGP Peer BIG-IP B_subnet30:
set protocols bgp neighbor 10.1.30.6 remote-as 65562
set protocols bgp neighbor 10.1.30.6 update-source 10.255.255.1
set protocols bgp neighbor 10.1.30.6 address-family ipv4-unicast soft-reconfiguration inbound
# BGP Peer BIG-IP B_subnet40:
set protocols bgp neighbor 10.1.40.6 remote-as 65572
set protocols bgp neighbor 10.1.40.6 update-source 10.255.255.1
set protocols bgp neighbor 10.1.40.6 address-family ipv4-unicast soft-reconfiguration inbound
# BGP Peer BIG-IP B_subnet50:
set protocols bgp neighbor 10.1.50.6 remote-as 65572
set protocols bgp neighbor 10.1.50.6 update-source 10.255.255.1
set protocols bgp neighbor 10.1.50.6 address-family ipv4-unicast soft-reconfiguration inbound
```

## Optional Config w/tunnels and multi VRFs

```text
# VRFs for multi-VRF Example: 
 set vrf name VRF1000 table 1000
 set vrf name VRF2000 table 2000
 set vrf name VRF3000 table 3000

# Tunnels for additional VRFs:
unset interfaces tunnel tun101
unset interfaces tunnel tun102
unset interfaces tunnel tun103
unset interfaces tunnel tun201
unset interfaces tunnel tun202
unset interfaces tunnel tun203
unset interfaces tunnel tun301
unset interfaces tunnel tun302
unset interfaces tunnel tun303

# Tunnels for additional VRFs:
set interfaces ethernet eth5 description 'subnet50'
set interfaces ethernet eth5 address 10.1.50.8/24

set interfaces tunnel tun10 address '10.10.1.1/24'
set interfaces tunnel tun10 encapsulation 'gre'
set interfaces tunnel tun10 source-address '10.1.10.8'
set interfaces tunnel tun10 remote '10.1.10.5'
set interfaces tunnel tun10 vrf 'VRF1000'

set interfaces tunnel tun102 address '10.10.2.1/24'
set interfaces tunnel tun102 encapsulation 'gre'
set interfaces tunnel tun102 source-address '10.1.10.8'
set interfaces tunnel tun102 remote '10.1.10.5'
set interfaces tunnel tun102 vrf 'VRF1000'
set interfaces tunnel tun102 parameters ip key 1002

set interfaces tunnel tun103 address '10.10.3.1/24'
set interfaces tunnel tun103 encapsulation 'gre'
set interfaces tunnel tun103 source-address '10.1.10.8'
set interfaces tunnel tun103 remote '10.1.10.5'
set interfaces tunnel tun103 vrf 'VRF1000'
set interfaces tunnel tun103 parameters ip key 1003

set interfaces tunnel tun201 address '10.20.1.1/24'
set interfaces tunnel tun201 encapsulation 'gre'
set interfaces tunnel tun201 source-address '10.1.20.8'
set interfaces tunnel tun201 remote '10.1.20.6'
set interfaces tunnel tun201 vrf 'VRF2000'
set interfaces tunnel tun201 parameters ip key 2001

set interfaces tunnel tun202 address '10.20.2.1/24'
set interfaces tunnel tun202 encapsulation 'gre'
set interfaces tunnel tun202 source-address '10.1.20.8'
set interfaces tunnel tun202 remote '10.1.20.6'
set interfaces tunnel tun202 vrf 'VRF2000'
set interfaces tunnel tun202 parameters ip key 2002

set interfaces tunnel tun203 address '10.20.3.1/24'
set interfaces tunnel tun203 encapsulation 'gre'
set interfaces tunnel tun203 source-address '10.1.20.8'
set interfaces tunnel tun203 remote '10.1.20.6'
set interfaces tunnel tun203 vrf 'VRF2000'
set interfaces tunnel tun203 parameters ip key 2003

set interfaces tunnel tun301 address '10.30.1.1/24'
set interfaces tunnel tun301 encapsulation 'gre'
set interfaces tunnel tun301 source-address '10.1.30.8'
set interfaces tunnel tun301 remote '10.1.30.7'
set interfaces tunnel tun301 vrf 'VRF3000'
set interfaces tunnel tun301 parameters ip key 1003

set interfaces tunnel tun302 address '10.30.2.1/24'
set interfaces tunnel tun302 encapsulation 'gre'
set interfaces tunnel tun302 source-address '10.1.30.8'
set interfaces tunnel tun302 remote '10.1.30.7'
set interfaces tunnel tun302 vrf 'VRF3000'
set interfaces tunnel tun302 parameters ip key 2003

set interfaces tunnel tun303 address '10.30.3.1/24'
set interfaces tunnel tun303 encapsulation 'gre'
set interfaces tunnel tun303 source-address '10.1.30.8'
set interfaces tunnel tun303 remote '10.1.30.7'
set interfaces tunnel tun303 vrf 'VRF3000'
set interfaces tunnel tun303 parameters ip key 3003
```
