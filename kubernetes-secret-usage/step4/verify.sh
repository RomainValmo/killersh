#!/bin/bash

function print_result() {
    if [ "$1" -eq 0 ]; then
        echo "✅  $2"
    else
        echo "❌  $2"
        exit 1
    fi
}


 if etcdctl --cacert="/etc/kubernetes/pki/etcd/ca.crt" --key="/etc/kubernetes/pki/etcd/server.key" --cert="/etc/kubernetes/pki/etcd/server.crt" get /registry/secrets/private/myfirstsecret | grep "123456"; then
  echo "  La clé 'secret' dans l'etcd"
  exit 1
else
  echo " c'est OK"

fi


if etcdctl --cacert="/etc/kubernetes/pki/etcd/ca.crt" --key="/etc/kubernetes/pki/etcd/server.key" --cert="/etc/kubernetes/pki/etcd/server.crt" get /registry/secrets/private/securesecret | grep "youcantread"; then 
  echo "  La clé 'secret' dans l'etcd"
  exit 1
else
  echo " c'est OK"

fi



EXPECTED_NAMESPACE="private" 
EXPECTED_SECRET="myfirstsecret"

kubectl -n "$EXPECTED_NAMESPACE" get secret "$EXPECTED_SECRET" > /dev/null 2>&1
print_result $? "Le secret '$EXPECTED_SECRET' existe dans le namespace '$EXPECTED_NAMESPACE'."


EXPECTED_SECRET2="securesecret"


kubectl -n "$EXPECTED_NAMESPACE" get secret "$EXPECTED_SECRET2" > /dev/null 2>&1
print_result $? "Le secret '$EXPECTED_SECRET2' existe dans le namespace '$EXPECTED_NAMESPACE'."

echo "🎉  Toutes les vérifications ont réussi !"



