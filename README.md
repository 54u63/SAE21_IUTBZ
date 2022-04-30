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
    - [Routeurs](#routeurs)
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
  ### Routeurs

Pour cette partie nous avons décidé d'utiliser deux types de routeurs. Le premier est, comme précisé juste avant, un routeur MikroTik placé entre la DMZ et l'extérieur car il est très pratique lors de l'installation d'un firewall. Pour le deuxième type il s'agit d'un routeur Cisco placé entre la DMZ et l'intranet de l'entreprise, les routeurs Cisco sont très utilisés dans les entreprises et facilement configurables sur GNS3 c'est pourquoi nous l'avons choisis. Pour le protocol de routage nous avons décidé d'adresser directement au routeur Cisco la route du routeur MikroTik car cela est plus simple et nous évite d'utiliser des protocols de routage comme OSPF/RIP/BGP pour seulement une seule route. Nous avons aussi utilisé un routeur Cisco pour mettre en place un serveur DHCP dont nous verrons la configuration juste après.

<br>







  
  
  

  
    
    
    
    
