#   Instalando docker

apt-get update
apt-get install -y docker.io

#   Suporte HTTPS caso necessario

apt-get update 
apt-get install -y apt-transport-https

#   Isntalando curl

apt-get install curl

#   Chave Kubernetes

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

#   Adicionando repositorio kubernetes

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

#   Instalando Kubeadm, Kubectl e kubelet

apt-get update
apt-get install -y kubelet kubeadm kubectl

# Cliando cluster com Calico

# kubeadm init --pod-network-cidr=192.168.0.0/16

# #   Preparando ambiente

# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# #   Instalando configurações do calico (pode trocar por outra)

# kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml