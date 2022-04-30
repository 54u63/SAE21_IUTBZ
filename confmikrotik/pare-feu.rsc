# jan/02/1970 02:08:13 by RouterOS 6.48
# software id = MLIQ-2ZZ8
#
# model = RB750Gr3
# serial number = CC210E95AFF3
/ip firewall filter
add action=accept chain=forward connection-state=new dst-port=80 protocol=tcp       #accepte les paquets à destination du port 80 (pour le serveur WEB en HTTP)
add action=accept chain=forward connection-state=new dst-port=443 protocol=tcp      #accepte les paquets à destination du port 443 (pour le serveur WEB en HTTPS)
add action=accept chain=forward connection-state=new dst-port=53 protocol=tcp       #accepte les paquets à destination du port 53 (pour le serveur DNS)
add action=accept chain=forward connection-state=new protocol=icmp                  #accpete les paquets ICMP
add action=accept chain=forward connection-state=new dst-port=1194 protocol=udp     #accpete les paquets à destination du port 1194(pour OPENVPN)
add action=accept chain=forward connection-state=established                        
add action=drop chain=forward                                                       #drop tout les autres paquets
