#!/bin/bash

# Détecter l'adresse IP du serveur actuel
CURRENT_IP=$(hostname -I | awk '{print $1}')

# Définir les noms d'hôtes et leurs adresses IP
if [[ "$CURRENT_IP" == "172.30.1.2" ]]; then
    # Configuration du serveur master
    hostnamectl set-hostname master
    echo "172.30.2.2 worker1" >> /etc/hosts
elif [[ "$CURRENT_IP" == "172.30.2.2" ]]; then
    # Configuration du serveur worker1
    hostnamectl set-hostname worker1
    echo "172.30.1.2 master" >> /etc/hosts
fi

# Ajouter les deux serveurs dans /etc/hosts pour garantir la communication
echo "172.30.1.2 master" >> /etc/hosts
echo "172.30.2.2 worker1" >> /etc/hosts
