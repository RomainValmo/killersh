#!/bin/bash


curl -o /tmp/exercice1.yaml https://raw.githubusercontent.com/RomainValmo/killersh/main/kubernetes-pod-error/resources/badimage.yaml

echo "Creating excercices namespace"

kubectl create ns exercice1

kubectl create ns exercice2

kubectl create ns exercice3

echo " Ecercice 1 : find bad image"

kubectl apply -f /tmp/exercice1.yaml -n exercice1



