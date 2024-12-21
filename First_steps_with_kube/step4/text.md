# Introduction aux Namespaces dans Kubernetes

Kubernetes est un système de gestion de conteneurs qui permet de déployer et de gérer des applications dans des environnements multi-cloud ou locaux. L'une des fonctionnalités essentielles de Kubernetes est le **Namespace**. Dans ce document, nous allons expliquer ce qu'est un Namespace dans Kubernetes, pourquoi il est important et comment il peut être utilisé pour organiser et gérer vos ressources.

## Qu'est-ce qu'un Namespace dans Kubernetes ?

Un **Namespace** dans Kubernetes est un mécanisme permettant de diviser un cluster Kubernetes en plusieurs espaces logiques, appelés "namespaces". Cela permet de séparer les ressources du cluster (comme les pods, services, et déploiements) en groupes isolés. Chaque namespace fonctionne comme un espace de noms virtuel pour les ressources, ce qui facilite la gestion des ressources et la gestion des accès dans un environnement partagé.

Les namespaces sont particulièrement utiles dans les environnements où plusieurs équipes ou projets utilisent le même cluster Kubernetes, car ils permettent de mieux organiser les ressources et d'isoler les applications ou services.

## Pourquoi utiliser des Namespaces ?

### 1. **Organisation des ressources**
   Les namespaces permettent de regrouper les ressources Kubernetes de manière logique. Par exemple, vous pouvez avoir un namespace pour le développement, un autre pour la production, et ainsi de suite.

### 2. **Isolation des ressources**
   Les namespaces offrent un niveau d'isolation, ce qui signifie que les ressources d'un namespace ne peuvent pas interagir directement avec celles d'un autre namespace, sauf si elles sont explicitement configurées pour le faire.

### 3. **Gestion des accès**
   Vous pouvez utiliser des namespaces pour appliquer des politiques de contrôle d'accès, en définissant des règles de sécurité et des quotas de ressources par namespace.

### 4. **Gestion multi-équipe**
   Si plusieurs équipes utilisent un même cluster, les namespaces permettent à chaque équipe de travailler dans un espace isolé avec ses propres ressources sans interférer avec les autres équipes.

## Comment créer et utiliser un Namespace ?

### 1. **Créer un Namespace**

Vous pouvez créer un namespace dans Kubernetes en utilisant la commande suivante :

```bash
kubectl create namespace mon-namespace
```

### 2. **Lister les Namespaces**

Pour afficher la liste de tous les namespaces dans votre cluster Kubernetes, utilisez la commande :

```bash
kubectl get namespaces
```
Cela vous donnera un aperçu de tous les namespaces disponibles.

### 3. **Utiliser un Namespace avec kubectl**

Lorsque vous travaillez avec kubectl, vous pouvez spécifier un namespace pour que vos commandes s'exécutent dans ce namespace spécifique. Par exemple, pour obtenir tous les pods d'un namespace particulier, vous pouvez utiliser la commande :


```bash
kubectl get pods -n mon-namespace
```

Cela listera tous les pods du namespace mon-namespace.


### 4. **Supprimer un Namespace**

Si vous souhaitez supprimer un namespace, vous pouvez utiliser la commande suivante :

```bash
kubectl delete namespace mon-namespace
```
Cela supprimera le namespace mon-namespace ainsi que toutes les ressources associées à ce namespace.

### 5. **Deployer une ressource dans un namespace**

Par défaut, les ressources que vous créez sont assignées au namespace `default`, pour affecter une ressource à un namespace , soit on le précise dans le .yaml ou dans la ligne de commande avec le flag `--namespace` ou `-n`
```bash
kubectl -n <mon-namespace> run <mon-pod> --image <mon-image> 
```
dans un .yaml 

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mon-pod
  namespace: mon-namespace
spec:
  containers:
  - name: mon-nom-de-container
    image: mon-image
```

## Execrcice :

1. Creer un namespace nommé `exercice`
2. Deployer un pod nommé `exercice1` dans le namespace `exercice` qui utilise l'image `nginx`
3. Dans ce même namespace `exercice` creer un deployment nommé `exercice2` qui deploie deux pods dont les containers utilise l'image `httpd`



