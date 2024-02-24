# Implantação Cluster

Testando implantação de cluster com múltiplos container runtimes.


## Instruções

- Clone o repositório:
    `git clone https://github.com/joaovmoura/implantacao_cluster.git`
- Entre no diretório do container runtime desejado:
    `cd implantacao_cluster/<container_runtime_dir>`
- Dê a permissão de execução ao script:
    `chmod +x setup.sh`
- Execute:
    `./setup.sh`

- Para iniciar o cluster faça:
    ```bash
    kubeadm init
    ```
- Após a inicialização, para configurar o kubectl, faça:
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```
- Use o comando abaixo para obter o comando de join, que será usado no worker node:
    ```bash
    kubeadm token create --print-join-command
    ```
