### Vous voilà dans l'univer Kubernetes

Vous disposez dans cette environement de deux serveurs `Ubuntu 20.04` appelé Nodes ( Noeuds ) dans K8s

La première machine est accessible via `ssh master`, il s'agit de la machine que l'on appelera control plan. 
C'est ici que sera gèrè le cerveau de K8s

La deuxième machine est quand à elle accessible via `ssh worker1`, il s'agit d'un noued appelé Worker. C'est sur ce noeud que seront executés les divers pods que l'on aura la chance de creer. 

### 1- Mise à jour des paquets UBUNTU du control-plan 

***  Connectez vous en ssh sur le control-plan `ssh master`

***  Pour être tranquille passons en sudo `sudo -i `

*** mettons à jours les paquets APT avce la commande `apt update && apt upgrade -y`

