# Guide pour Débutants : Les Pods dans Kubernetes

## Qu'est-ce qu'un Pod ?
- **Définition :** Un Pod est l'unité de base dans Kubernetes. Il représente une ou plusieurs instances de conteneurs (souvent un seul) qui partagent :
  - Le même espace réseau.
  - Le même espace de stockage (volumes).
- **Caractéristiques :**
  - Les Pods sont éphémères.
  - Ils peuvent contenir plusieurs conteneurs qui collaborent pour exécuter une application.
  - Les conteneurs dans un Pod communiquent entre eux via `localhost`.

---

## Structure d'un Pod
Un Pod est décrit dans un fichier YAML. Voici la structure de base :

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod       # Nom du Pod
spec:
  containers:        # Liste des conteneurs du Pod
  - name: my-container
    image: nginx     # Image Docker à utiliser
```

### Éléments principaux :
- **`apiVersion` :** Version de l'API Kubernetes (égale à `v1` pour les Pods).
- **`kind` :** Type de l'objet, ici `Pod`.
- **`metadata` :** Informations sur le Pod, comme son nom.
- **`spec` :** Spécifications du Pod, notamment :
  - **`containers` :** Liste des conteneurs à inclure dans le Pod.
  - **`image` :** Image Docker à utiliser pour le conteneur.

---

## Créons notre premier Pod - Exercice - 
Voici un Pod simple déployant un conteneur Nginx :

1. Crée un fichier `pod1.yaml` ( je vous conseille d'utiliser et de vous familiariser avec VIM) dans lequel nous mettons le block suivant:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80  # Port exposé par le conteneur
```

2. Description des éléments :

- **`labels` :** Permet de classer les Pods (utile pour les Services et les Deployments).
- **`ports` :** Liste des ports exposés par le conteneur.

3. Lancons notre pod :
   
   Pour creer l'objet dans kubernetes nous devons uiliser cette commande:
   ```
   kubectl create -f 'nom de lobjet
   ```

   Donc ici nous faisons 

   `kubectl create -f pod1.yaml`

   Notre pod est donc crée et si nous faisons cetet commande pour lister les pods 

   `kubectl get pod`, nous voyons bien notre pod nginx-pod en mode running.
---

## Commandes de Base pour les Pods

### Création d'un Pod
- Créez un Pod à partir d'un fichier YAML :
  ```bash
  kubectl apply -f pod.yaml
  ```

### Liste des Pods
- Afficher tous les Pods dans le cluster :
  ```bash
  kubectl get pods
  ```

### Détails sur un Pod
- Obtenir des informations complètes sur un Pod :
  ```bash
  kubectl describe pod <nom-du-pod>
  ```

### Journaux d'un Pod
- Voir les logs du conteneur dans un Pod :
  ```bash
  kubectl logs <nom-du-pod>
  ```

### Suppression d'un Pod
- Supprimer un Pod :
  ```bash
  kubectl delete pod <nom-du-pod>
  ```

---

## Quelques TIPS sur les commandes

### Créer un pod rapidement sans la création manuel du fichier .YAML

- Kubectl vous permet de creer rapidement un Pod sans passer par l'etape rédaction du chier .YAML grace à cette commande :
    ```
    kubectl run <nom du pod> --image <nom de l'image>
    ```
    Cette option est pratique pour créer rapidement un pod de débug ou autre. Mais également pour créer un template .YAML de l'objet

- Générer le fichier .YAML depuis cette commande :
    ```
    kubectl run <nom du pod> --image <nom de l'image> --dry-run=client -oyaml > <non du fichier>.yaml

## Exercices

1- Réaliser les opérations pour `nginx-pod` ( Le pod de découverte)

2- Creer un pod nommé `pod2` qui utilise l'image `nginx` sans créer de fichier .yaml

3- Générer un fichier `pod3.yaml` grace à la commande `kubectl run`, pour un pod nommé `pod3` et utilisant l'image apache `httpd`

4- Lancer notre `pod3` 

5- Lister l'ensemble de nos pods actifs avec toutes les imformations dont l'IP avec la commande `kubectl get pod -owide`. Vous devez retrouver l'ensemble de vos pods et voir leur IP. 

## Points Clés à Retenir
- Les Pods sont éphémères : ils peuvent être recréés ou remplacés par Kubernetes.
- Chaque Pod a une adresse IP unique dans le cluster, utilisée pour la communication interne.
- Les conteneurs dans un même Pod partagent :
  - **Réseau :** Accès aux mêmes interfaces.
  - **Volumes :** Systèmes de fichiers partagés.

---

Pour aller plus loin, explorez les objets comme les **Deployments**, **Services**, et **Ingress** qui permettent de gérer les Pods de manière optimale.
