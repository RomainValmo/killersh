### Vous voilà dans l'univer Kubernetes

Vous disposez dans cette environement d'un serveurs `Ubuntu 20.04` appelé Node ( Noeuds ) dans K8s

Vous êtes directement connecté à l'environement.

Ici pour des raison de simplicité, nous allons travailler avec un seul serveur qui fera office de Control-plan et de worker 

### 1- On desactive le swap 

`swapoff -a`

`sed -i '/\sswap\s/ s/^\(.*\)$/#\1/g' /etc/fstab`

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

`kubeadm init --kubernetes-version=${KUBE_VERSION} --ignore-preflight-errors=NumCPU --skip-token-print --pod-network-cidr 192.168.0.0/16`




