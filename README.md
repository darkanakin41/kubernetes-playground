darkanakin41/kubernetes-playground
===
This project have been generated with [darkanakin41/project-toolbox](https://github.com/darkanakin41/project-toolbox)

# Procedure
1. [Install docker](https://docs.docker.com/engine/install/debian/)
```shell script
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo usermod -aG docker $USER
```
2. [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
```shell script
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```
3. [Install minikube](https://minikube.sigs.k8s.io/docs/start/)
```shell script
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```
4. Create a basic cluster: 
```shell script
minikube start
```

5. Load project configuration:
```shell script
# Apply persistent volumes configuration
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/drupal-private-persistentvolumeclaim.yaml
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/drupal-public-persistentvolumeclaim.yaml

# Apply deployment configuration
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/database-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/drupal-deployement.yaml
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/varnish-deployment.yaml

# Apply service configuration
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/drupal-service.yaml
kubectl apply -f https://raw.githubusercontent.com/darkanakin41/kubernetes-playground/master/.k8s/kubernetes/varnish-service.yaml
```