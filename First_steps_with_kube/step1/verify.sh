#!/bin/bash

kubectl get pod nginx-pod

#!/bin/bash
  
kubectl get pod nginx-pod

imagepod2=$(kubectl get pod pod2 -o yaml | grep 'image: ng' | xargs)
exepectedimagepod2="- image: nginx"
if [ "$imagepod2" == "$exepectedimagepod2" ]; then
    echo "✅   pod créé."
else
    echo "❌   pod non trouvé"
    exit 1
fi

cat <<EOF > expected.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod3
  name: pod3
spec:
  containers:
  - image: httpd
    name: pod3
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
EOF

if [ ! -f pod3.yaml ]; then
  echo "❌ Le fichier 'pod3.yaml' n'existe pas. Veuillez générer ce fichier avant de continuer."
  exit 1
fi

if diff -q expected.yaml pod3.yaml > /dev/null; then
  echo "✅ Les fichiers 'expected.yaml' et 'pod3.yaml' sont identiques."
else
  echo "❌ Les fichiers 'expected.yaml' et 'pod3.yaml' diffèrent."
  echo "Différences :"
  diff expected.yaml pod3.yaml
  exit 1
fi

kubectl get pod pod3


