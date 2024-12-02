#!/bin/bash

# Variables : IPs et noms d'hôtes
MASTER_IP="172.30.1.2"
MASTER_HOSTNAME="master"
WORKER1_IP="172.30.2.2"
WORKER1_HOSTNAME="worker1"

# Fonction pour configurer un nœud
configure_node() {
  local NODE_IP=$1
  local NODE_HOSTNAME=$2

  echo "Configuring node ${NODE_HOSTNAME} (${NODE_IP})..."

  # 1. Définir le nom d'hôte
  ssh -o StrictHostKeyChecking=no ubuntu@${NODE_IP} "sudo hostnamectl set-hostname ${NODE_HOSTNAME}"

  # 2. Mettre à jour /etc/hosts
  ssh ${NODE_IP} "echo '${MASTER_IP} ${MASTER_HOSTNAME}' | sudo tee -a /etc/hosts"
  ssh ${NODE_IP} "echo '${WORKER1_IP} ${WORKER1_HOSTNAME}' | sudo tee -a /etc/hosts"

  # 3. Générer une clé SSH si elle n'existe pas déjà
  ssh ${NODE_IP} "if [ ! -f ~/.ssh/id_rsa ]; then ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ''; fi"
}

# Configurer les deux nœuds
configure_node $MASTER_IP $MASTER_HOSTNAME
configure_node $WORKER1_IP $WORKER1_HOSTNAME

# 4. Échanger les clés SSH entre les nœuds
echo "Exchanging SSH keys between nodes..."

# Copier la clé publique du master vers le worker1
ssh $MASTER_IP "ssh-keyscan -H $WORKER1_HOSTNAME >> ~/.ssh/known_hosts"
ssh $MASTER_IP "ssh-copy-id -o StrictHostKeyChecking=no $WORKER1_HOSTNAME"

# Copier la clé publique du worker1 vers le master
ssh $WORKER1_IP "ssh-keyscan -H $MASTER_HOSTNAME >> ~/.ssh/known_hosts"
ssh $WORKER1_IP "ssh-copy-id -o StrictHostKeyChecking=no $MASTER_HOSTNAME"

echo "Setup completed successfully!"
