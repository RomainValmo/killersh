#!/bin/bash


curl -o /tmp/exercise1.yaml https://raw.githubusercontent.com/RomainValmo/killersh/main/kubernetes-pod-error/resources/badimage.yaml
curl -o /tmp/exercise2.yaml https://raw.githubusercontent.com/RomainValmo/killersh/main/kubernetes-pod-error/resources/readonlyFs.yaml

echo "Creating excercises namespace"

kubectl create ns exercise1

kubectl create ns exercise2

kubectl create ns exercise3

echo " Ecercise 1 : find bad image"

kubectl apply -f /tmp/exercise1.yaml -n exercise1

echo " Ecercise 2 : find readonlyFs"

kubectl apply -f /tmp/exercise2.yaml -n exercise2


echo  "create path to aswser"

mkdir /opt/exercise1
mkdir /opt/exercise2
mkdir /opt/exercise3