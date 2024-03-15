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
- Após realizar o join, é possível alterar a role do nó fazendo:
    ```bash
    kubectl label node <NOME DO NÓ> node-role.kubernetes.io/worker=worker
    ```
## Problemas
Atualmente, um pacote referente ao ubuntu xenial parece ter sido desativado. Atualizei o script de instalção do Docker usando a documentação oficial para resolver isso e parece ter funcionado. No entanto, nos meus testes, o cluster caiu repetidas vezes, mas não sei exatamente a causa.
