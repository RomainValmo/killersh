# Introduction aux Services dans Kubernetes

Kubernetes est un système de gestion de conteneurs qui permet de déployer, gérer et faire évoluer des applications. L'un des concepts clés de Kubernetes est le **Service**. Ce document explique ce qu'est un Service dans Kubernetes, comment il fonctionne, et pourquoi il est important.

## Qu'est-ce qu'un Service dans Kubernetes ?

Dans Kubernetes, un **Service** est une abstraction qui définit un ensemble de règles d'accès à un ensemble de pods. Un Service permet de garantir la communication entre les différentes parties de votre application, indépendamment du nombre de réplicas ou de l'adresse IP des pods.

Un Service fournit une adresse stable et un point d'entrée pour accéder aux applications déployées dans les pods, ce qui est essentiel dans un environnement dynamique où les pods peuvent être créés et supprimés fréquemment.

## Types de Services dans Kubernetes

Kubernetes propose plusieurs types de services, chacun ayant un comportement spécifique :

### 1. **ClusterIP (par défaut)**
Le service `ClusterIP` est le type de service par défaut. Il expose le service uniquement à l'intérieur du cluster Kubernetes. Autrement dit, seul le cluster peut accéder à ce service via une adresse IP interne.

- **Utilisation** : Parfait pour les services internes au cluster (comme les bases de données ou les services de backend).
  
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: apache
  name: test
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: apache
  type: ClusterIP

```

### 2. **NodePort**

Le service `NodePort` expose le service sur une adresse IP externe de chaque nœud du cluster à un port spécifique. Il permet d'accéder au service depuis l'extérieur du cluster via l'IP d'un nœud et un port prédéfini.

- **Utilisation** : Idéal pour les tests ou les déploiements à petite échelle où vous souhaitez exposer un service à l'extérieur du cluster.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mon-service-nodeport
spec:
  selector:
    app: mon-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
      nodePort: 30001
  type: NodePort
```

### 3. **LoadBalancer**

Le service `LoadBalancer` expose un service via un équilibreur de charge externe (généralement fourni par un fournisseur de cloud, comme AWS, Google Cloud, etc.). Un LoadBalancer crée une adresse IP externe pour le service.

- **Utilisation** : C'est la solution idéale pour des applications en production où l'accès externe doit être contrôlé via un équilibreur de charge.

 
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mon-service-loadbalancer
spec:
  selector:
    app: mon-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

## Creer son premier service

Nous allons exposer notre pod1 créé à la premiere étape de ce Killersh

1. Création du service de Type ClusterIP

   Le plus simple pour créer un service est d'utiliser la commande 
   ```
   kubectl expose <type d'objet> <nom de l'objet> --name <nom du service > --type <type de service> --port <numero du port>
   ``` 
   Nous vons donc exposer le pod `nginx-pod` qui est un serveur nginx qui écoute le port 80.

   Pour ce faire nous allons utilser la commande suivante:
   `kubectl expose pod nginx-pod --name service1 --type ClusterIP --port 80`

2. Vérification de la création du service 
   
   Listons les services actifs :
   `kubectl get service`

   Vous devez voir apparaitre votre service `service1`avec son ip.

3. Test de connection
   
   Faisons un curl sur cette IP 

   `curl <l'ip_du_service>`

   le retour doit être celui de la page d'acceuil de Nginx

4. Regardons a quoi ressemble notre fichier .yaml de service

   Pour çà nous faisons cette commande 

   `kubectl get service service1 -oyaml`  

## Exercice 

Vous devez creer un service nommé `apache-service`
Ce dernier doit : <br>

a) Exposer le deployment `apache`

b) Utiliser le type `ClusterIP`
  
c) Utiliser le port `80`

