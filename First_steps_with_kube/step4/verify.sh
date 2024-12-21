#!/bin/bash

kubectl get ns exercice
kubectl -n exercice get pod exercice1
imageexercice1=$(kubectl -n exercice get pod exercice1 -ojsonpath='{.spec.containers[0].image}')
imageexpected1="nginx"

if [ "$imageexercice1" == "$imageexpected1" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi

kubectl -n exercice geet deployment exercice2
imageexercice2=$(kubectl -n exercice get deployment exercice2 -ojsonpath='{.spec.template.spec.containers[0].image}')
imageexpected2="httpd"

if [ "$imageexercice2" == "$imageexpected2" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi

replicaexercice2=$(kubectl -n exercice get deployment exercice2 -ojsonpath='{.spec.replicas}')
replicaexpected2="2"

if [ "$replicaexercice2" == "$replicaexpected2" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi

replicaavailable=$(kubectl -n exercice get deployment exercice2 -ojsonpath='{.status.availableReplicas}')
replicaexpected="2"

if [ "$replicaavailable" == "$replicaexpected" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi