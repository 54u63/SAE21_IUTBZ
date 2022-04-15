# jan/02/1970 02:10:54 by RouterOS 6.48
# software id = MLIQ-2ZZ8
#
# model = RB750Gr3
# serial number = CC210E95AFF3
/interface bridge
add admin-mac=2C:C8:1B:06:B4:AF auto-mac=no comment=defconf name=bridge
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
set [ find default=yes ] html-directory=hotspot
/ip pool
add name=dhcp ranges=192.168.6.2-192.168.6.253
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.6.1/24 comment=defconf interface=bridge network=\
    192.168.6.0
/ip dhcp-client
add comment=defconf disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.6.0/24 comment=defconf gateway=192.168.6.1 netmask=24
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.6.1 comment=defconf name=router.lan
/ip firewall filter
add action=accept chain=forward connection-state=new dst-port=80 protocol=tcp
add action=accept chain=forward connection-state=new dst-port=443 protocol=\
    tcp
add action=accept chain=forward connection-state=new protocol=icmp
add action=accept chain=forward connection-state=new dst-port=1194 protocol=\
    udp
add action=accept chain=forward connection-state=established
add action=drop chain=forward
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/ip route
add distance=1 dst-address=192.0.10.0/24 gateway=10.213.0.225
add distance=1 dst-address=192.0.10.0/24 gateway=10.213.0.225
add distance=1 dst-address=192.0.12.0/24 gateway=10.213.0.184
add distance=1 dst-address=192.168.80.0/24 gateway=10.202.0.198
add distance=1 dst-address=192.168.83.0/24 gateway=10.202.0.164
add distance=1 dst-address=192.168.89.0/24 gateway=10.203.0.175
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
