# ----- Adicionando o repositório do Docker e instalando pré-requisitos -----

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# ----- Instalação do Docker -----

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# ----- Configuração do Docker -----

# Adicionando o usuário atual ao grupo docker para evitar usar sudo
sudo usermod -aG docker $USER

# Reiniciando o Docker para aplicar as configurações
sudo systemctl restart docker

# ----- Configuração dos parâmetros do sysctl -----

# Configurando os parâmetros do sysctl para o Docker
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
