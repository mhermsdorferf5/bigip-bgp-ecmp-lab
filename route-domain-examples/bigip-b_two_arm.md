# Example of Two Armed route domain

In this example, each route domain as two BGP adjacencies, one to the IX VRF the other to the tenant VRF.

## BIG-IP Config

### Create Route domains and Base Networking

Note that we can leave strict enabled on the route domains in this situation.

```bash
tmsh modify net vlan subnet10 { interfaces replace-all-with { 1.5 { } } }
tmsh modify net vlan subnet30 { interfaces replace-all-with { 1.2 { } } }
tmsh modify net vlan subnet40 { interfaces replace-all-with { 1.3 { } } }
tmsh modify net vlan subnet50 { interfaces replace-all-with { 1.4 { } } }


tmsh create net route-domain tenant_a { id 101 strict enabled routing-protocol replace-all-with { BGP } vlans replace-all-with { subnet10 subnet30 } }
tmsh create net route-domain tenant_b { id 102 strict enabled routing-protocol replace-all-with { BGP } vlans replace-all-with { subnet40 subnet50 } }

tmsh create net self subnet10-self { address 10.1.10.6%101/24 allow-service all traffic-group traffic-group-local-only vlan subnet10 }
tmsh create net self subnet30-self { address 10.1.30.6%101/24 allow-service all traffic-group traffic-group-local-only vlan subnet30 }
tmsh create net self subnet40-self { address 10.1.40.6%102/24 allow-service all traffic-group traffic-group-local-only vlan subnet40 }
tmsh create net self subnet50-self { address 10.1.50.6%102/24 allow-service all traffic-group traffic-group-local-only vlan subnet50 }

```

### Create Partitions and VIP configs

```bash
tmsh create auth partition tenant_a { default-route-domain 101 }
tmsh create auth partition tenant_b { default-route-domain 102 }

tmsh create ltm virtual /tenant_a/shared-vip { destination 203.0.113.10:443 }
tmsh create ltm virtual /tenant_a/tenant-vip { destination 192.0.2.100:443 }
tmsh modify ltm virtual-address /tenant_a/203.0.113.10%101 { route-advertisement always traffic-group none }
tmsh modify ltm virtual-address /tenant_a/192.0.2.100%101 { route-advertisement always  traffic-group none }

tmsh create ltm virtual /tenant_b/shared-vip { destination 203.0.113.11:443 }
tmsh create ltm virtual /tenant_b/tenant-vip { destination 198.51.100.101:443 }
tmsh modify ltm virtual-address /tenant_b/203.0.113.11%102 { route-advertisement always  traffic-group none }
tmsh modify ltm virtual-address /tenant_b/198.51.100.101%102 { route-advertisement always  traffic-group none }

tmsh save sys config
```

## ZebOS Config

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
router bgp 65562
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
 neighbor 10.1.10.8 peer-group Neighbor
 neighbor 10.1.10.8 ebgp-multihop 2
 neighbor 10.1.10.8 as-override
 neighbor 10.1.30.8 peer-group Neighbor
 neighbor 10.1.30.8 ebgp-multihop 2
 neighbor 10.1.30.8 as-override
!
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
router bgp 65572
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
 neighbor 10.1.50.8 peer-group Neighbor
 neighbor 10.1.50.8 ebgp-multihop 2
 neighbor 10.1.50.8 as-override
 !
end
wr mem
```
