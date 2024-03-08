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