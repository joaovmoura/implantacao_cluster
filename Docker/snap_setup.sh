#!/bin/bash

# Instalando Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Suporte HTTPS
sudo apt-get update
sudo apt-get install -y apt-transport-https

# Instalando curl
sudo apt-get install curl

# Instalando Kubernetes via Snap
sudo snap install kubectl --classic
sudo snap install kubelet --classic
sudo snap install kubeadm --classic

# Configurando as versões específicas do Snap (substitua <versão> pela versão desejada)
sudo snap switch kubectl --channel=<versão>
sudo snap switch kubelet --channel=<versão>
sudo snap switch kubeadm --channel=<versão>

# Bloqueando as versões
sudo snap hold kubectl kubelet kubeadm
