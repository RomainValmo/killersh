### Vous voilà dans l'univer Kubernetes

Vous disposez dans cette environement d'un serveur `Ubuntu 20.04` appelé Node ( Noeuds ) dans K8s

Vous êtes directement connecté à l'environement.

Ici pour des raison de simplicité, nous allons travailler avec un seul serveur qui fera office de Control-plan et de worker 

Ici vous allez apprendre à installer un cluster Kubernetes sur une machine ubuntu 20.04. 
Vous pourrez reprendre ces éléments, si vous souhaitez creer votre prope cluster sur GCP, AWS ou autre. 

### 1- On desactive le swap 

`swapoff -a`

`sed -i '/\sswap\s/ s/^\(.*\)$/#\1/g' /etc/fstab`

[Le swap c'est quoi?](https://fr.wikipedia.org/wiki/Espace_d%27%C3%A9change#:~:text=L'espace%20d'%C3%A9change%2C,se%20trouvent%20en%20m%C3%A9moire%20vive.)

### 2- Mise à jour des paquets UBUNTU du control-plan 

***  Pour être tranquille passons en sudo `sudo -i `

***  Mettons à jours les paquets APT avec la commande `apt update && apt upgrade -y`

***  Procédons à l'instalation des paquets nécessaires `apt-get install -y apt-transport-https ca-certificates curl gpg`

On crée un dossier pour les clés apt `mkdir -p -m 755 /etc/apt/keyrings`

On recupère les fichiers nécessaires `curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key |  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg`

On ajoute la source de répo

`echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list`

On met de nouveau à jour APT 

`apt update`

On télécharge et installe les paquets necessaires 

`apt-get install -y docker.io containerd kubelet=1.31.1-* kubeadm=1.31.1-* kubectl=1.31.1-* kubernetes-cni`

On verouille ensuite les versions 

`apt-mark hold kubelet kubeadm kubectl kubernetes-cni`

### 3- Installation de Containerd 

Containerd est le CRI. 

C'est le logiciel en coulisses qui s'assure que les conteneurs fonctionnent correctement. Voici ses principaux rôles :

Lancer les conteneurs : Il démarre les conteneurs et les configure.
Gérer les conteneurs en cours d'exécution : Par exemple, surveiller leur consommation de ressources (CPU, mémoire) ou les redémarrer si nécessaire.
Arrêter les conteneurs : Lorsque l'application dans le conteneur n'est plus nécessaire.
Interagir avec les images de conteneur : Une image est une "recette" pour créer un conteneur. Containerd télécharge, stocke et gère ces images.

*** On télécharge donc les fichiers d'instalation 

`wget https://github.com/containerd/containerd/releases/download/v1.6.12/containerd-1.6.12-linux-amd64.tar.gz`

*** On extrait l'archive 

`tar xvf containerd-1.6.12-linux-amd64.tar.gz`

*** On arrete le service, on copie le binaire puis on supprime l'archive avant de redemarer le service.

`systemctl stop containerd`

`mv bin/* /usr/bin`

`rm -rf bin containerd-1.6.12-linux-amd64.tar.gz`

`systemctl unmask containerd`

`systemctl start containerd`

### 4- Configuration Containerd

On execute ce script 

```
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

On set ces paramètres 

`sudo modprobe overlay`

`sudo modprobe br_netfilter`

Puis on excute ce nouveau script :

```
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

On recharge la configuration system 

`sudo sysctl --system`

On crée ensuite le dossier 

`mkdir -p /etc/containerd`

On génère le config.toml de containerd. Il s'agit ici de la facon dont les containers sont gérés .

Exécutez ce script de génération.

```
cat > /etc/containerd/config.toml <<EOF
disabled_plugins = []
imports = []
oom_score = 0
plugin_dir = ""
required_plugins = []
root = "/var/lib/containerd"
state = "/run/containerd"
version = 2

[plugins]

  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
      base_runtime_spec = ""
      container_annotations = []
      pod_annotations = []
      privileged_without_host_devices = false
      runtime_engine = ""
      runtime_root = ""
      runtime_type = "io.containerd.runc.v2"

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        BinaryName = ""
        CriuImagePath = ""
        CriuPath = ""
        CriuWorkPath = ""
        IoGid = 0
        IoUid = 0
        NoNewKeyring = false
        NoPivotRoot = false
        Root = ""
        ShimCgroup = ""
        SystemdCgroup = true
EOF
```

*** Configurons maintenant les différentes applications pour utiliser containerd


Utilisation de containerd par défaut 

```
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF
```

Set par defaut de containerd pour Kubelet

```
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS="--container-runtime-endpoint unix:///run/containerd/containerd.sock"
EOF

```

### 5- On redémarre les services.

```
systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd
systemctl enable kubelet && systemctl start kubelet

```

### 6- On peut enfin creer notre noeud Kubernetes 

On utilise pour çà 
la commande kubeadm 

`kubeadm init --kubernetes-version=1.31.1 --ignore-preflight-errors=NumCPU --skip-token-print --pod-network-cidr 192.168.0.0/16`

Ici on définit que nos pods se trouveront dans le réseau 192.168.0.0/16. 

Attention vous devez utiliser une plage libre. 

Si vous lisez bien le prompt à l'ecran. on vous demande de charger les fichier de configuration Kube pour l'user courant

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  ```

### 7- Vous venez de creer votre cluster. Mais c'est pas fini...

Effectivement, 
vous pouvez voir grace à la commande 
`kubectl get node`
( commande qui permet de lister les noeuds du cluster) que votre control-plan n'est pas ready. 

La raison se situe dans le fait , que nous n'avons pas encore défini de **CNI** 

Le CNI est un plugin Network qui permet aux différents éléments du cluster de communiquer entre eux. 

J'ai un faible pour [Cilium](https://cilium.io/), que nous allons installer à l'etape suivante. 


Maintenant si tout est fait correctement , tu peux cliquer sur check pour passer à l'étape suivante. 
 



