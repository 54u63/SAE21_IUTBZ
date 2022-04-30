# jan/02/1970 02:08:13 by RouterOS 6.48
# software id = MLIQ-2ZZ8
#
# model = RB750Gr3
# serial number = CC210E95AFF3
/ip firewall filter
add action=accept chain=forward connection-state=new dst-port=80 protocol=tcp
add action=accept chain=forward connection-state=new dst-port=443 protocol=\tcp
add action=accept chain=forward connection-state=new protocol=icmp
add action=accept chain=forward connection-state=new dst-port=1194 protocol=\udp
add action=accept chain=forward connection-state=established
add action=drop chain=forward
