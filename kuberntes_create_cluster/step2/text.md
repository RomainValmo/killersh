# Installation du CNI

## Installation de HELM 

[Helm c'est quoi](https://github.com/RomainValmo/killersh/tree/main/About_Kubernetes/Helm.md)

**HELM**

On récupère la dernière version de Helm disponible 

`HELMVERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') `

On télécharge la dernière version

`wget https://get.helm.sh/helm-${HELMVERSION}-linux-amd64.tar.gz`

On decompresse l'archive, on deplace le binaire pour le rendre executable directement, on affecte les bon droits et on supprime les fichiers que l'on utilise plus

```
tar -zxvf helm-${HELMVERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo chmod 755 /usr/local/bin/helm
echo "$(helm version --short) installed"
rm -R ./linux-amd64
rm helm-${HELMVERSION}-linux-amd64.tar.gz
```

## Installation de cilium via HELM 

**On ajoute le repo cilium**

`helm repo add cilium https://helm.cilium.io/`

**On récupère la dernière version disponbile et on l'installe**

```
CILIUMVERSION=$(helm search repo cilium/cilium --versions | awk 'NR==2 {print $2}')
helm install cilium cilium/cilium --version ${CILIUMVERSION} --namespace kube-system
```

**On récupère cilim CLI et on l'installe**

```
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
```

## Verification de l'installation du CNI 

Vous pouvez allez voir si l'installation du CNI a bien fonctionné. 

Helm doit condtruire des Pods dans le namespace kube-system 

On va allez vérifier cà tout de suite avec la commande 

`kubectl -n kube-system get pod`

Vous devriez avoir un retour semblable à celà 

```
ubuntu $ kubectl -n kube-system get pod
NAME                               READY   STATUS    RESTARTS   AGE
cilium-envoy-5fgd6                 1/1     Running   0          80s
cilium-jcdtk                       1/1     Running   0          80s
cilium-operator-54c7465577-55ldj   1/1     Running   0          80s
cilium-operator-54c7465577-jrmdn   0/1     Pending   0          80s
coredns-7c65d6cfc9-dwc2g           1/1     Running   0          24m
coredns-7c65d6cfc9-mdv96           1/1     Running   0          24m
etcd-ubuntu                        1/1     Running   0          24m
kube-apiserver-ubuntu              1/1     Running   0          24m
kube-controller-manager-ubuntu     1/1     Running   0          24m
kube-proxy-7dbqz                   1/1     Running   0          24m
kube-scheduler-ubuntu              1/1     Running   0          24m
```

On voit bien que plusieurs Pod cilium sont en cours d'execution. 

## Verification que notre control-plan est passé en Ready 

On lance notre commande 

`kubectl get node`

Le resultat devrait être 

```
ubuntu $ kubectl get node
NAME     STATUS   ROLES           AGE   VERSION
ubuntu   Ready    control-plane   24m   v1.31.1
```

## Notre cluster est donc prêt. 

Lancons notre premier pod nommé test avec une image nginx pour s'assurer du bon fonctionnement de ce dernier. 

`kubectl run test --image nginx`

Vérifions qu'il tourne bien

`kubectl get pod`

Zut , on voit qu'il ne s'execute pas. La raison est simple, normalement on ne deploye pas de pod de travail sur un control-plan. Mais comme l'on n'a qu'un seul serveur. On va enlever la protection qui empeche de deployer sur le control-plan.

`kubectl taint nodes ubuntu node-role.kubernetes.io/control-plane:NoSchedule-`

Si on regarde de nouveau notre pod test , il passe en running 

`kubectl get pod`

```

ubuntu $ kubectl get pod
NAME   READY   STATUS              RESTARTS   AGE
test   0/1     ContainerCreating   0          3m45s
ubuntu $ kubectl get pod
NAME   READY   STATUS    RESTARTS   AGE
test   1/1     Running   0          4m25s

```


Si tout est ok vous pouvez cliquer sur check. 

