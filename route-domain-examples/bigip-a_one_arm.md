# Example of One Armed route domain

In this example, each route domain as a single BGP adjacency to it's corresponding VRF.

## BIG-IP Config

### Create Route domains and Base Networking

Note that we must disable strict on the route domains for this to work.

```bash
tmsh create net vlan subnet20 { interfaces replace-all-with { 1.2 { } } }
tmsh create net vlan subnet30 { interfaces replace-all-with { 1.3 { } } }
tmsh create net vlan subnet40 { interfaces replace-all-with { 1.4 { } } }
tmsh create net vlan subnet50 { interfaces replace-all-with { 1.5 { } } }

tmsh create net route-domain shared_ix { id 10 strict disabled routing-protocol replace-all-with { BGP } vlans replace-all-with { subnet20 } }
tmsh create net route-domain tenant_a { id 101 strict disabled routing-protocol replace-all-with { BGP } vlans replace-all-with { subnet30 } }
tmsh create net route-domain tenant_b { id 102 strict disabled routing-protocol replace-all-with { BGP } vlans replace-all-with { subnet40 } }
tmsh create net route-domain tenant_c { id 103 strict disabled routing-protocol replace-all-with { BGP } vlans replace-all-with { subnet50 } }

tmsh create net self subnet20-self { address 10.1.20.5%10/24 allow-service all traffic-group traffic-group-local-only vlan subnet20 }
tmsh create net self subnet30-self { address 10.1.30.5%101/24 allow-service all traffic-group traffic-group-local-only vlan subnet30 }
tmsh create net self subnet40-self { address 10.1.40.5%102/24 allow-service all traffic-group traffic-group-local-only vlan subnet40 }
tmsh create net self subnet50-self { address 10.1.50.5%103/24 allow-service all traffic-group traffic-group-local-only vlan subnet50 }
```

### Create Partitions and VIP configs

```bash
tmsh create auth partition tenant_a { default-route-domain 101 }
tmsh create auth partition tenant_b { default-route-domain 102 }
tmsh create auth partition tenant_c { default-route-domain 103 }

tmsh create ltm virtual /tenant_a/shared-vip { destination 203.0.113.21%10:443 }
tmsh create ltm virtual /tenant_a/tenant-vip { destination 192.0.2.201:443 }
tmsh modify ltm virtual-address /tenant_a/203.0.113.21%10 { route-advertisement always  traffic-group none }
tmsh modify ltm virtual-address /tenant_a/192.0.2.201%101 { route-advertisement always  traffic-group none }

tmsh create ltm virtual /tenant_b/shared-vip { destination 203.0.113.22%10:443 }
tmsh create ltm virtual /tenant_b/tenant-vip { destination 192.0.2.202:443 }
tmsh modify ltm virtual-address /tenant_b/203.0.113.22%10 { route-advertisement always  traffic-group none }
tmsh modify ltm virtual-address /tenant_b/192.0.2.202%102 { route-advertisement always  traffic-group none }

tmsh create ltm virtual /tenant_c/shared-vip { destination 203.0.113.23%10:443 }
tmsh create ltm virtual /tenant_c/tenant-vip { destination 192.0.2.203:443 }
tmsh modify ltm virtual-address /tenant_c/203.0.113.23%10 { route-advertisement always  traffic-group none }
tmsh modify ltm virtual-address /tenant_c/192.0.2.203%103 { route-advertisement always  traffic-group none }

tmsh save sys config
```

## ZebOS Config

### For Shared Route Domain 10

```text
imish -r 10
enable
configure terminal
!
service password-encryption
!
log syslog
!
bgp extended-asn-cap
!
router bgp 65551
 bgp router-id 10.255.255.11
 bgp graceful-restart restart-time 120
 bgp graceful-restart stalepath-time 60
 bgp graceful-restart graceful-reset
 redistribute kernel
 redistribute static
 timers bgp 10 35
 neighbor Neighbor peer-group
 neighbor Neighbor remote-as 65540
 no neighbor Neighbor capability route-refresh
 neighbor Neighbor soft-reconfiguration inbound
 neighbor 10.1.20.8 peer-group Neighbor
 neighbor 10.1.20.8 ebgp-multihop 2
 neighbor 10.1.20.8 as-override
 !
 address-family ipv6
 neighbor Neighbor activate
 neighbor 10.1.20.8 activate
 no neighbor 10.1.20.8 capability graceful-restart
 exit-address-family
!
end
```

### For Tenant A Route Domain 101

```text
imish -r 101
enable
configure terminal
!
service password-encryption
!
log syslog
!
bgp extended-asn-cap
!
router bgp 65561
 bgp router-id 10.255.255.11
 bgp graceful-restart restart-time 120
 bgp graceful-restart stalepath-time 60
 bgp graceful-restart graceful-reset
 redistribute kernel
 redistribute static
 timers bgp 10 35
 neighbor Neighbor peer-group
 neighbor Neighbor remote-as 65540
 no neighbor Neighbor capability route-refresh
 neighbor Neighbor soft-reconfiguration inbound
 neighbor 10.1.30.8 peer-group Neighbor
 neighbor 10.1.30.8 ebgp-multihop 2
 neighbor 10.1.30.8 as-override
 !
 address-family ipv6
 neighbor Neighbor activate
 neighbor 10.1.30.8 activate
 no neighbor 10.1.30.8 capability graceful-restart
 exit-address-family
!
end
wr mem
```

### For Tenant B Route Domain 102

```text
imish -r 102
enable
configure terminal
!
service password-encryption
!
log syslog
!
bgp extended-asn-cap
!
router bgp 65571
 bgp router-id 10.255.255.11
 bgp graceful-restart restart-time 120
 bgp graceful-restart stalepath-time 60
 bgp graceful-restart graceful-reset
 redistribute kernel
 redistribute static
 timers bgp 10 35
 neighbor Neighbor peer-group
 neighbor Neighbor remote-as 65540
 no neighbor Neighbor capability route-refresh
 neighbor Neighbor soft-reconfiguration inbound
 neighbor 10.1.40.8 peer-group Neighbor
 neighbor 10.1.40.8 ebgp-multihop 2
 neighbor 10.1.40.8 as-override
 !
 address-family ipv6
 neighbor Neighbor activate
 neighbor 10.1.40.8 activate
 no neighbor 10.1.40.8 capability graceful-restart
 exit-address-family
!
end
wr mem
```

### For Tenant C Route Domain 103

```text
imish -r 103
enable
configure terminal
!
service password-encryption
!
log syslog
!
bgp extended-asn-cap
!
router bgp 65581
 bgp router-id 10.255.255.11
 bgp graceful-restart restart-time 120
 bgp graceful-restart stalepath-time 60
 bgp graceful-restart graceful-reset
 redistribute kernel
 redistribute static
 timers bgp 10 35
 neighbor Neighbor peer-group
 neighbor Neighbor remote-as 65540
 no neighbor Neighbor capability route-refresh
 neighbor Neighbor soft-reconfiguration inbound
 neighbor 10.1.50.8 peer-group Neighbor
 neighbor 10.1.50.8 ebgp-multihop 2
 neighbor 10.1.50.8 as-override
 !
end
wr mem
```
