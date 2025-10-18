LFCS - Questão 10: SSHFS e NFS (Sistemas de Arquivos em Rede)
Objetivo da Tarefa
Montagem via SSH: Utilizar o SSHFS para montar um sistema de arquivos remoto de forma segura sobre uma conexão SSH.

Compartilhamento de Rede: Configurar um servidor NFS para compartilhar um diretório em rede e montar esse compartilhamento em um cliente.

A tarefa exige a execução das seguintes ações:

No servidor terminal: Usar SSHFS para montar o diretório /data-export do servidor app-srv1 no ponto de montagem local /app-srv1/data-export, com permissão de leitura/escrita e acessível por outros usuários.


No servidor terminal: Configurar o servidor NFS para compartilhar o diretório /nfs/share em modo somente leitura (read-only) para toda a rede 192.168.10.0/24. 


No servidor app-srv1: Montar o compartilhamento NFS (/nfs/share do servidor terminal) no diretório local /nfs/terminal/share. 

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação envolve criar os diretórios que serão usados como pontos de montagem e como fonte de compartilhamento.

1.1 Preparação do Servidor terminal
Bash

# Crie o ponto de montagem para o SSHFS
sudo mkdir -p /app-srv1/data-export [cite: 614]

# Crie o diretório que será compartilhado via NFS e um arquivo de teste dentro dele
sudo mkdir -p /nfs/share
echo "Arquivo de teste NFS" | sudo tee /nfs/share/teste.txt > /dev/null
1.2 Preparação do Servidor app-srv1
Bash

# Conecte-se ao servidor app-srv1
ssh app-srv1

# Crie o diretório que será o ponto de montagem para o NFS
sudo mkdir -p /nfs/terminal/share [cite: 675]

# Crie o diretório que será acessado remotamente via SSHFS e um arquivo de teste
sudo mkdir -p /data-export
echo "Arquivo de teste SSHFS" | sudo tee /data-export/teste_sshfs.txt > /dev/null

# Saia da sessão ssh
exit
2. Resolvendo a Questão: Passo a Passo
A solução é dividida em três partes: configurar a montagem SSHFS, configurar o servidor NFS e, por fim, montar o compartilhamento no cliente NFS.

Parte 1: Configurar a Montagem SSHFS (no servidor terminal)
Bash

# Monte o diretório remoto do app-srv1 usando sshfs.
# -o allow_other: Permite que outros usuários do sistema acessem a montagem.
# -o rw: Define a montagem como leitura e escrita.
sudo sshfs -o allow_other,rw app-srv1:/data-export /app-srv1/data-export [cite: 615]
Parte 2: Configurar o Servidor NFS (no servidor terminal)
Bash

# Edite o arquivo /etc/exports para definir os compartilhamentos NFS.
sudo nano /etc/exports [cite: 647]
Adicione a seguinte linha ao final do arquivo para compartilhar o diretório /nfs/share com a rede especificada em modo somente leitura (ro):

/nfs/share 192.168.10.0/24(ro,sync,no_subtree_check) [cite: 661, 662]
Salve, feche o editor e aplique as alterações.

Bash

# Recarregue as configurações de exportação do NFS sem reiniciar o serviço.
# -r: re-exportar, -a: todos os diretórios em /etc/exports.
sudo exportfs -ra [cite: 665]
Parte 3: Configurar o Cliente NFS (no servidor app-srv1)
Bash

# Conecte-se novamente ao servidor app-srv1.
ssh app-srv1 [cite: 672]

# Monte o compartilhamento NFS do servidor 'terminal' no diretório local criado anteriormente.
sudo mount terminal:/nfs/share /nfs/terminal/share [cite: 676]
Verificação Final
Verifique se cada montagem foi bem-sucedida e se as permissões estão corretas.

Bash

# No servidor 'terminal', verifique a montagem SSHFS.
ls /app-srv1/data-export
# Deve listar 'teste_sshfs.txt'.
touch /app-srv1/data-export/novo_arquivo.txt [cite: 620]
# O comando deve funcionar, confirmando a permissão de escrita.

# No servidor 'terminal', verifique se o compartilhamento NFS está ativo.
showmount -e
# A saída deve listar o export /nfs/share para 192.168.10.0/24. [cite: 666, 668, 669]

# No servidor 'app-srv1', verifique a montagem NFS.
ls /nfs/terminal/share
# Deve listar 'teste.txt'.
touch /nfs/terminal/share/novo_arquivo.txt [cite: 681]
# O comando deve falhar com a mensagem "Read-only file system", confirmando a permissão de somente leitura. [cite: 681]
Conceitos Importantes para a Prova
SSHFS: Um sistema de arquivos baseado no FUSE (Filesystem in Userspace) que permite montar um diretório remoto sobre uma conexão SSH. É uma forma simples e segura de acessar arquivos remotamente.

NFS (Network File System): Um protocolo de sistema de arquivos distribuído que permite a um usuário em um computador cliente acessar arquivos em uma rede como se estivessem no armazenamento local.


/etc/exports: O arquivo de configuração principal do servidor NFS. Ele define quais diretórios são compartilhados e quais clientes (hosts, redes) têm permissão para acessá-los, juntamente com as opções de acesso (ex: ro para somente leitura, rw para leitura/escrita). 




exportfs -ra: Comando para atualizar a tabela de compartilhamentos do servidor NFS com base no que está configurado em /etc/exports, sem a necessidade de reiniciar o serviço. 

mount: Comando padrão do Linux para montar sistemas de arquivos, incluindo os de rede como NFS.
