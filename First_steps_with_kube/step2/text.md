# Les Deployments dans Kubernetes

Les Deployments sont un objet Kubernetes essentiel qui facilite la gestion des applications conteneurisées. Ils permettent de déployer, de mettre à jour et de gérer facilement les Pods de votre application.

---

## Qu'est-ce qu'un Deployment ?

Un **Deployment** est une ressource Kubernetes qui vous aide à :

- Déployer des Pods.
- Assurer une haute disponibilité avec plusieurs répliques.
- Effectuer des mises à jour progressives (rolling updates).
- Restaurer une version précédente si une mise à jour échoue.

---

## Pourquoi utiliser un Deployment ?

1. **Automatisation** : Simplifie le déploiement de vos applications.
2. **Mises à jour faciles** : Applique des changements de manière progressive.
3. **Scalabilité** : Permet d'ajuster dynamiquement le nombre de répliques des Pods.
4. **Auto-récupération** : Redémarre automatiquement les Pods défaillants.

---

## Structure d'un fichier YAML pour un Deployment

Voici un exemple de base d'un fichier YAML pour un Deployment :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: nginx:1.21
        ports:
        - containerPort: 80
```

### Explications :

1. **`apiVersion`** : Version de l'API Kubernetes utilisée (`apps/v1` pour les Deployments).
2. **`kind`** : Type de ressource (ici, `Deployment`).
3. **`metadata`** : Métadonnées comme le nom du Deployment et les labels.
4. **`spec`** :
   - **`replicas`** : Nombre de Pods souhaités.
   - **`selector`** : Définit comment Kubernetes identifie les Pods appartenant à ce Deployment.
   - **`template`** : Modèle utilisé pour créer les Pods.
     - **`containers`** : Liste des conteneurs avec leurs images, ports, et autres configurations.



### Créons notre premier déployment :

1. Créons un fichier `deployement1.yaml` :

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mon-premier-deployement # Le nom du deployment
      labels:
        app: mginx-dep # les labels
    spec:
      replicas: 2 # le nombre de réplicas c'est a dire le nombre de pod que l'on souhaite
      selector:
        matchLabels:
          app: nginx-dep 
      template:
        metadata:
          labels:
            app: nginx-dep
        spec:
          containers:
          - name: nginx-dep # le nom du container 1
            image: nginx # l'image du container 1
            ports:
            - containerPort: 80
    ```

2. Créons notre ressource :

   `kubectl create -f  deployement1.yaml`

3. Vérifions notre déloyement :

    Avec la commande ,
    `kubectl get deployment` nous devons voir apparaitre le nom de notre déployment 'mon-premier-deployment'

4. Vérifions le nombre de pods demandés : 

    A l'aide de la commande vue à l'étape précédente, listons nos pods
    `kubectl get pod`, nous devons voir deux pods nginx-dep

## Commandes principales pour gérer les Deployments

### Créer un Deployment
```bash
kubectl apply -f deployment.yaml
```

### Vérifier le statut du Deployment
```bash
kubectl get deployments
```

### Mettre à jour un Deployment
Modifiez l'image dans le fichier YAML, puis appliquez les changements :
```bash
kubectl apply -f deployment.yaml
```

### Scaler un Deployment
Ajustez le nombre de répliques (exemple : 5 Pods) :
```bash
kubectl scale deployment my-deployment --replicas=5
```

### Supprimer un Deployment
```bash
kubectl delete deployment my-deployment
```

---

## Rolling Updates et Rollbacks

### Rolling Updates

Les Deployments utilisent des **rolling updates** pour appliquer les changements de manière progressive :
- Kubernetes met à jour un nombre limité de Pods à la fois.
- Assure la disponibilité continue de l'application pendant la mise à jour.

### Rollback (Restaurer une version précédente)

Si une mise à jour échoue, vous pouvez restaurer la version précédente :
```bash
kubectl rollout undo deployment my-deployment
```

### Vérifier l'historique des rollouts
```bash
kubectl rollout history deployment my-deployment
```

### Suivre le statut d'un rollout
```bash
kubectl rollout status deployment my-deployment
```

---

### Exercices

1. Crée un deployment nommé `apache` , qui a les attributs suivants :
 
    a) 3 réplicas
    b) utilise le label app: apache
    c) le container utilise l'image `httpd` et à pour nom `apache-pod`
    d) upsacler le nombre de pods à 4 grace à la commande dédiée. 

Tip: On peut aussi utiliser la commande 

```
kubectl create deployment <nom de deployment> --image <nom de l'image> --dry-run=client -oyaml > <nomdu fichier>.yaml pour creer rapidement un template
```

## Bonnes pratiques

1. **Utilisez des labels clairs** : Facilitez l'identification et la gestion de vos Pods.
2. **Définissez des ressources** : Configurez les limites et les requêtes CPU/mémoire pour vos conteneurs.
3. **Automatisez vos déploiements** : Intégrez vos fichiers YAML dans une CI/CD.
4. **Surveillez vos Deployments** : Utilisez des outils comme Prometheus et Grafana pour monitorer l'état de vos Pods et Deployments.

---

## Conclusion

Les Deployments sont un outil puissant pour gérer vos applications conteneurisées dans Kubernetes. Ils offrent des fonctionnalités essentielles comme les mises à jour progressives, le scaling automatique et la récupération en cas de panne, ce qui en fait un élément clé de vos infrastructures cloud-native.
