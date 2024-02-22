# ----- Adicionando o repositório do CRI-O e instalando pré-requisitos -----

sudo apt-get update
sudo apt-get upgrade
 
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Parâmetros sysctl

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Aplica as definições do sysctl sem reiniciar a máquina

sudo sysctl --system

# Verificando os módulos carregados

lsmod | grep br_netfilter
lsmod | grep overlay

# Configurando variáveis de ambiente com as versões

OS=xUbuntu_22.04
VERSION=1.26

sudo echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

sudo echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list


mkdir -p /usr/share/keyrings

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

# ----- Instalação do CRI-O -----

apt-get update && apt-get install cri-o cri-o-runc cri-tools -y

# Adicionando o usuário atual ao grupo cri-o para evitar usar sudo

sudo usermod -aG cri-o $USER

# Reiniciando o CRI-O para aplicar as configurações

sudo systemctl start crio.service
sudo systemctl enable crio.service
sudo systemctl status crio.service

# Aplica as definições do sysctl sem reiniciar a máquina

sudo sysctl --system

# ----- Instalação do kubeadm, kubelet e kubectl -----

# Desabilitando swap para melhor funcionamento do kubelet

sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a

# Instalando pre-requisitos

sudo apt-get install -y apt-transport-https software-properties-common


curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update && sudo apt-get install -y kubelet=1.26.3-00 kubeadm=1.26.3-00 kubectl=1.26.3-00

# Marcar as versões instaladas para evitar atualizações automáticas
sudo apt-mark hold kubelet kubeadm kubectl
