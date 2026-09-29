# talos

## Usage

Install Talos and Kubernets
```
terraform init

terraform plan

terraform apply
```

Connect to the cluster
```
terraform output -raw talosconfig > talosconfig
terraform output -raw kubeconfig  > kubeconfig

chmod 600 ./talosconfig
chmod 600 ./kubeconfig

export TALOSCONFIG=./talosconfig
export KUBECONFIG=./kubeconfig

talosctl config info
talosctl health -n 10.10.1.41
talosctl get extensions -n 10.10.1.41

kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A
```

Sample deployment
```
kubectl create deployment nginx \
  --image=nginx:latest \
  --replicas=3

kubectl get pods -A -o wide
```
