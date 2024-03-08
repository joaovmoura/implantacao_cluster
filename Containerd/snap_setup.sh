# Instalação do ambiente kubernetes usando Containerd como container runtime


# ----- Instalação dos módulos do kernel -----


cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter


# ----- Configuração dos parâmetros do sysctl -----


# Configuração dos parâmetros do sysctl, fica mantido mesmo com reebot da máquina.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Aplica as definições do sysctl sem reiniciar a máquina
sudo sysctl --system


# ----- Instalação -----


# Adicionando o repositório do Docker
# Instalação de pré requisitos
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg --yes
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Configurando o repositório
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt update && sudo apt install containerd.io -y


# Configuração padrão do Containerd
sudo mkdir -p /etc/containerd && containerd config default | sudo tee /etc/containerd/config.toml 


# Alterar o arquivo de configuração pra configurar o systemd cgroup driver. 
# Sem isso o Containerd não gerencia corretamente os recursos computacionais e vai reiniciar em loop
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd

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