#!/bin/bash

# Variables : IPs et noms d'hôtes
export MASTER_IP="172.30.1.2"
export MASTER_HOSTNAME="master"
export WORKER1_IP="172.30.2.2"
export WORKER1_HOSTNAME="worker1"

ssh -o StrictHostKeyChecking=no $MASTER_IP "hostnamectl set-hostname ${MASTER_HOSTNAME}"
ssh -o StrictHostKeyChecking=no $MASTER_IP "echo '${MASTER_IP} ${MASTER_HOSTNAME}' |  tee -a /etc/hosts"
ssh -o StrictHostKeyChecking=no $MASTER_IP "echo '${WORKER1_IP} ${WORKE1_HOSTNAME}' |  tee -a /etc/hosts"

ssh -o StrictHostKeyChecking=no $WORKER1_IP "hostnamectl set-hostname ${WORKER1_HOSTNAME}"
ssh -o StrictHostKeyChecking=no $WORKER1_IP "echo '${MASTER_IP} ${MASTER_HOSTNAME}' |  tee -a /etc/hosts"
ssh -o StrictHostKeyChecking=no $WORKER1_IP "echo '${WORKER1_IP} ${WORKE1_HOSTNAME}' |  tee -a /etc/hosts"
