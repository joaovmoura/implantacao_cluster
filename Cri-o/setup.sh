# ----- Adicionando o repositório do CRI-O e instalando pré-requisitos -----

sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$(lsb_release -rs)/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_$(lsb_release -rs)/Release.key | gpg --dearmor -o /usr/share/keyrings/devel:kubic:libcontainers:stable.gpg

sudo apt-get update

# ----- Instalação do CRI-O -----

sudo apt-get install -y cri-o

# ----- Configuração do CRI-O -----

# Adicionando o usuário atual ao grupo cri-o para evitar usar sudo
sudo usermod -aG cri-o $USER

# Reiniciando o CRI-O para aplicar as configurações
sudo systemctl restart crio

# ----- Configuração dos parâmetros do sysctl -----

# Configurando os parâmetros do sysctl para o CRI-O
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

# Aplica as definições do sysctl sem reiniciar a máquina
sudo sysctl --system

# ----- Instalação do kubeadm, kubelet e kubectl -----

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Marcar as versões instaladas para evitar atualizações automáticas
sudo apt-mark hold kubelet kubeadm kubectl
