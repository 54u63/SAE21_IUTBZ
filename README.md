# SAE21-Groupe-Lorenzo-Antoine-Mathéo

Objectif de la SAE : 
Réaliser en groupe de 3 un petit réseau d'entreprise comprenant : un serveur DNS/Bind, un serveur WEB intranet/externe et un firewall.

```Entreprise : Lab418```

> Membres de l'entreprise : 
* Lorenzo MATILLA-NORO
* Mathéo BALAZUC
* Antoine BOURY-LE-STRAT

![Image du projet GNS3 de Lab418](https://github.com/s4uc3-1s-n0t-sus/SAE21_IUTBZ/blob/main/Capture-du-projet-GNS3-Lab418.png "Screenshot du projet GNS3 de Lab418")

## Sommaire 

- [SAE21-Groupe-Lorenzo-Antoine-Mathéo](#sae21-groupe-lorenzo-antoine-mathéo) 
  - [Plan d'adressage](#plan-dadressage)
    - [Dans l'entreprise](#dans-lentreprise)
    - [Dans la DMZ](#dans-la-dmz)
  - [Configuration des machines](#configuration-des-machines)
    - [Switch](#switch) 
    - [Routeurs](#routeurs)
      - [Configuration du routeur Cisco](#configuration-du-routeur-cisco)
      - [Configuration des Vlans](#configuration-des-vlans) 
      - [Configuration du serveur DHCP](#configuration-du-serveur-dhcp)
    - [Serveur WEB](#serveur-web)
      - [Interne](#interne)
      - [Externe](#externe)
    - [Serveur Bind/DNS](#serveur-binddns)
  - [Configuration des autorisations/restrictions](#configuration-des-autorisationsrestrictions)
    - [Pare-Feu/Firewall](#pare-feufirewall)
    - [NAT](#nat)
    - [ACL](#ACL)
  - [Limites et idées non terminées](#limites-et-idées-non-terminées)
  - [Reposit GitHub de chaque membre](#reposit-github-de-chaque-membre)
  
  ## Plan d'adressage
  ### Dans l'entreprise
  
Avant de commencer quelconque configuration nous avons dû choisir un plan d'adresage. Pour cela nous avons choisis une base d'adresse privé en 192.168.0.0/16 pour l'intranet de l'entreprise. Nous avons ensuite créer des sous-réseaux pour chaque Vlan, par exemple pour le Vlan10 192.168.10.0/24. Cela nous permet de savoir directement à quel réseau appartient la machine et nous donne la possibilité d'avoir 255 machines (addresse de réseau et de broadcast à enlever) par Vlan.
<br>
En résumé : 
<br>
Service | Vlan | Adresse du sous-réseau
--------|------|-----------------------
Service Informatique | Vlan 10 | 192.168.10.0/24
Administratif | Vlan 20 | 192.168.20.0/24
Commerciaux | Vlan 30 | 192.168.30.0/24
Serveurs | Vlan 50 | 192.168.50.0/24

  ### Dans la DMZ

Dans la DMZ se trouve tout les services et serveurs qui sont accessibles depuis l'intranet de l'entreprise et depuis l'extérieur. Pour cela elle doit normalement contenir des adresses publiques afin que l'extérieur puisse y avoir accès, ne disposant pas d'adresse publique nous avons donc utilisé une base d'adresses privés en 192.168.60.0/24 pour l'exercice. Nous avons utiliser un routeur MikroTik entre la DMZ et l'extérieur afin de pouvoir mettre un place un pare-feu / Firewall dont nous verrons la configuration plus tard. Pour la patte du routeur du côté DMZ nous avons choisis l'adresse 192.168.60.254, car par convention l'adresse des routeurs est la dernière adresse du réseau disponible, et pour l'adresse de la patte du côté de l'extérieur nous avons choisis 10.213.10.160 afin que le réseau soit accessible directement depuis les ordinateurs de la salle.

  ## Configuration des machines
  ### Switch
  
Nous allons maintenant configurer le switch qui se trouve au milieu de notre montage, pour cela nous avons décidé de passer le lien  qui se trouve sur le port **e0 et e5 en mode TRUNK** afin que toutes les machines du réseau puissent y avoir accès, sur les switchs le mode trunk correspond au mode Dot1q : </br>

<img src=./images/configswitch.png>

</br>
  
  ### Routeurs

Pour cette partie nous avons décidé d'utiliser deux types de routeurs. Le premier est, comme précisé juste avant, un routeur MikroTik placé entre la DMZ et l'extérieur car il est très pratique lors de l'installation d'un firewall. Pour le deuxième type il s'agit d'un routeur Cisco placé entre la DMZ et l'intranet de l'entreprise, les routeurs Cisco sont très utilisés dans les entreprises et facilement configurables sur GNS3 c'est pourquoi nous l'avons choisis. Pour le protocol de routage nous avons décidé d'adresser directement au routeur Cisco la route du routeur MikroTik car cela est plus simple et nous évite d'utiliser des protocols de routage comme OSPF/RIP/BGP pour seulement une seule route. Nous avons aussi utilisé un routeur Cisco pour mettre en place un serveur DHCP dont nous verrons la configuration juste après.

<br>

  ### Configuration du routeur Cisco
  
Pour le routeur nous avons choisi du lui addresser l'addresse 192.168.50.254 afin qu'il soit dans un réseau spécialisé pour les serveurs ainsi qu'en .254 afin de respecter les règles métiers. Pour le réseau hors de l'entrepise j'ai chosi le réseau 192.168.60.0/24 et le routeur en .254 pour les mêmes raisons que précédemment </br>
Nous allons maintenant nous intéresser à la configuration de ce dernier sur l'interface fa0/0 et fa0/1 que on peut voir à l'aide de la commande **ip show interface brief** :</br>

<img src=./images/config-des-ips.png>

</br>

  ### Configuration des Vlans 

Nous allons maintenant voir la configuration des Vlans. Pour cela il faut : 

(Je précise que pour chaque Vlan nous avons addressé une ip différente au routeur, par exemple pour le réseau 192.169.10.1 le routeur est 192.169.10.254)

- Addresser une liste d'ip autoriser à acceder au routeur avec la commande **access-list 1 permit @réseau @masque_inversé**
- Addresser une liste d'ip autoriser à acceder au VLAN avec la commande **ip access-list extended VLAN**
- Il faut ensuite mettre en place des ACLs pour autoriser ou refuser certains protocols venant d'un réseau vers un autre, pour cela nous allons utiliser la commande **permit/deny protocol @réseau_source @réseau_destination**
- Pour refuser tout les protocols venant d'un réseau vers un autre on peut utilsier la commande **deny ip @réseau_source @réseau_destination
- Configurer l'interface fa0/0 pour chaque Vlan en précisant l'IP du routeur pour chaque vlan, l'encapsulation ainsi que l'ip NAT pour sortir sur le réseau

Dans notre cas, nous avons autoriser sur toutes les Vlans le protocol 22 pour le protocol SSH, le protocol 80 et 443 pour l'accès au serveur WEB et le protocol ICMP afin que les machines puissent se pingent entre elles. Il est aussi important d'autoriser les protocols dans les deux sens, c'est à dire du Vlan dont le message est émis et le Vlan dont le message est reçu et faire de même dans l'autre sens pour la réponse. Comme le VLAN10 appartient au réseau du Service Informatique il a accès à tout les autres Vlans. Ce qui nous donne : </br>

<img src=./images/ACL.png>
<img src=./images/R1-CONF.png>
<img src=./images/Interface-R1.png>

</br>

Je précise que pour le PC1 son ip est 192.168.10.1 comme marqué sur le montage et en routes 192.168.10.254 et 192.168.50.254.</br>
On peut maintenant vérifier que cela fonctionne en regardant si le PC1 peut ping les autres machines du réseau ainsi que le routeur :</br>

<img src=./images/pc1-ping.png>

</br>

Nous pouvons aussi vérifier sur WireShark que les requêtes émises entre les machines sont bien "tagués" par le numéro du Vlan.


  ### Configuration du serveur DHCP
  
Pour configurer le serveur DHCP nous avons utilisé un routeur Cisco que nous avons addressé en 192.168.50.5/24. Afin que le protocol DHCP puisse fonctionner nous avons configuré ce dernier en fonction des adresses MACS des PC car les requêtes DHCP Discover ne peuvent pas passer "au delà" du switch.</br>

Pour configurer le serveur DHCP en fonction de l'addresse MAC il faut :

- Préciser l'ip et le masque que l'on veut donner à la machine **host @ip @masque**
- Donner l'addresse MAC de la machine à qui on veut donner cette configuration **hardware-address @mac_adress**
- Préciser le DNS (Vu au Jour 1)**dns-server @ip_du_dns**
- Préciser le routeur par défaut **default-routeur @ip_routeur**

Voici par exemple la configuration pour le PC1 du Vlan10 et l'un des PC du Vlan20 : </br>

<img src=./images/confdhcp-mac.png>

</br>

On peut voir que le serveur DHCP et bien connecter au réseau : </br>

<img src=./images/DHCP-PING.png>

  ## Serveur WEB
  ### Interne
  
  Pour le serveur Web interne que nous n'avons pas eu le temps de finir, nous avions décidé de le placer sur un PC dans le Vlan 50 (serveur) avec l'adresse 192.168.50.10/24. Nous avions décider le lancer sur Apache2 comme vu en R203, même si Apache2 est de moins en moins utilisé et est remplacé par Nginx.
<br>
Voici la configuration du site : 

  - [Index.html](./SiteWEB/index.html)
  - [Image](./SiteWEB/photo.png)
  - [CSS](./SiteWEB/style.css)


  ### Externe
  
Pour la configuration du site externe, il faut se rendre dans le fichier **/var/apache2/sites-availables/000-default.conf** afin de préciser le chemin vers le _DocumentRoot_, dans mon cas j'ai simplement fait une redirection vers un site qui m'appartient,
pour ajouter la redirection il faut rajouter **Redirect 301 / @ip_site** </br>

<img src=./images/site-web.png> </br>

Ce qui nous donne comme résulat lorsque l'on rentre l'addrese IP du serveur WEB (ici 192.168.60.200) : 

[lien vidéo (il faut la télécharger je n'ai pas trouvé d'autre moyen via git](https://github.com/s4uc3-1s-n0t-sus/SAE21_IUTBZ/blob/main/images/vidéos.mp4)

  
  ## Serveur Bind/DNS
  
Je précise avant tout que l'addrese du serveur DNS se trouve dans le réseau 192.168.60.0/24 à l'addresse 192.168.60.200/254 comme le préconise les règles métiers. </br>

Tout d'abord pour la configuration du serveur DNS tout les fichiers qui nous intéressent se trouve dans le répertoire **/etc/bind/**

Pour commencer il faut installer bind9 : 
```
sudo apt install -y bind9 
```
Une fois installer on peut se rendre dans le répertoire **/etc/bind/** </br>
Après un **ls** on se rend compte qu'il existe plusieurs types de fichier : les db et named.conf </br>
Dans notre cas ce qui nous intéresse sont les fichiers db.local et named.conf.local. </br>

Nous allons d'abord créer une zone, pour cela il faut éditer le fichier named.conf.local : 

```
vim named.conf.local
```
<img src=./images/named.conf.local.png>
</br>
On commence par copier la configuration du db.local :

```
cp db.local db.SAE
```
</br>
Une fois cela fait nous pouvons rentrer dans la configuration de la zone : 

```
vim db.SAE
```
<img src=./images/db.SAE.png></br>

Une fois terminé il faut redémarrer le service bind9 :
<br>
```
systemctl restart bind9
```

Une fois cela fait on peut vérifier que notre serveur DNS fonctionne en exécutant les commandes **named-checkconf et named-checkzone** si la première commande ne ressort aucun résultat cela veut dire que la configuration est bonne sinon elle ressort l'erreur avec la ligne. Pour ce qui est de la deuxième cela ressort quelle zone est actuellement active. Si elle n'apparrait pas cela veut dire qu'elle est mal configurée. Il est aussi possible d'utiliser **nslookup** qui permet d'afficher toutes les erreurs de configuration ou on peut aussi sur un autre poste se rendre dans le fichier **/etc/resolv.conf** et renseigner notre serveur DNS (ici 192.168.60.200) et vérifier si il a accès à internet :

<img src=./images/resolv.conf.png>
<img src=./images/accès-internet.png></br>

Voici l'historique de toutes les commandes passées après l'installation de bind9 : 

<img src=./images/historique-commande.png>

  ## Configuration des autorisations/restrictions
  ### Pare-Feu/Firewall
  
  Nous avons décider de configurer un firewall/pare-feu sur le routeur MikroTik qui se trouve en la DMZ et l'extérieur car ce dernier permet aux connexions qui sont déjà établies (established) à d'autres connexions de passer et aux nouvelles connections de s'établir seulement si les conditions du DNAT sont respectées. Ces dernières permettent permet par exemple de filtrer tout les paquets entrant mais de pouvoir laisser passer la connexion SSH au routeur mais aussi vers le routeur Cisco du réseau Interne de l'entreprise
  
<img src=./images/ssh>

  ### NAT
  
Nous avons premièrement mis en place un NAT entre l'intranet de l'entreprise et la DMZ et une deuxième entre la DMZ et internet. Le DNAT lui permet de rediriger uniquement les ports 80 et 53 afin de pouvoir accèder au serveur WEB et DNS. Nous pouvons donc accéder depuis l'extérieur accéder au serveur DNS en faisant des requêtes DNS sur la zone "SAE" et accéder au serveur WEB en HTTP. Si nous avions mis un site en HTTPS nous aurions du permettre au DNAT de rediriger également le port 443.
<br>
Voici la configuration du routeur MikroTik pour le NAT et le pare-feu/firewall : 

- [NAT](./confmikrotik/nat.txt)
- [Firewall](./confmikrotik/pare-feu.rsc)
- [Configuration Mikrotik](./confmikrotik/mikrotik_conf.rsc)
  


  
  
  

  
    
    
    
    
