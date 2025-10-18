LFCS - Questão 6: Gerenciamento de Usuários, Grupos e Sudo
Objetivo da Tarefa
Modificar Usuário Existente: Alterar o grupo primário e o diretório home de um usuário já existente.

Criar Novo Usuário: Adicionar um novo usuário com grupos, diretório e shell específicos.

Configurar Sudo: Conceder permissões de sudo para um comando específico, para um usuário, sem a necessidade de senha.

A tarefa exige as seguintes ações no servidor app-srv1:

Mudar o grupo primário do usuário user1 para dev e seu diretório home para /home/accounts/user1. 

Adicionar um novo usuário user2 com os grupos dev e op, diretório home /home/accounts/user2, e terminal /bin/bash. 

Permitir que o usuário user2 execute o comando sudo bash /root/dangerous.sh sem precisar digitar a senha. 

1. Preparando o Ambiente no Lab
Para esta tarefa, precisamos garantir que os usuários e grupos existam, assim como o script que será usado no sudo.

1.1 Criar a Estrutura de Diretórios e Grupos
Bash

# Conecte-se ao servidor (ou execute localmente)
# ssh app-srv1

# Crie os grupos que serão utilizados, caso não existam
sudo groupadd dev
sudo groupadd op

# Crie o diretório base para os novos 'homes'
sudo mkdir -p /home/accounts
1.2 Criar o Usuário user1 de Exemplo
Bash

# Crie o usuário 'user1' com uma configuração padrão para podermos modificá-lo
sudo useradd -m user1
1.3 Criar o Script para o Teste de Sudo
Bash

# Crie o script de exemplo que o 'user2' poderá executar
echo '#!/bin/bash' | sudo tee /root/dangerous.sh > /dev/null
echo 'echo "Script perigoso executado com sucesso!"' | sudo tee -a /root/dangerous.sh > /dev/null

# Dê permissão de execução ao script
sudo chmod +x /root/dangerous.sh
2. Resolvendo a Questão: Passo a Passo
Agora, executamos as tarefas de gerenciamento de usuários e permissões.

Parte 1: Modificar o Usuário user1
Use o comando usermod para alterar as propriedades do usuário existente.

Bash

# -g: muda o grupo primário (gid)
# -d: muda o diretório home
sudo usermod -g dev -d /home/accounts/user1 user1
Parte 2: Criar o Novo Usuário user2
Use o comando useradd com as flags apropriadas para criar o usuário conforme especificado.

Bash

# -s: define o shell de login
# -m: cria o diretório home se não existir
# -d: especifica o caminho do diretório home
# -G: adiciona o usuário a uma lista de grupos suplementares (separados por vírgula)
sudo useradd -s /bin/bash -m -d /home/accounts/user2 -G dev,op user2
Parte 3: Configurar a Permissão Sudo
A edição do arquivo de sudoers deve sempre ser feita com o comando visudo para evitar erros de sintaxe que poderiam travar seu acesso sudo.

Bash

# Este comando abre o arquivo /etc/sudoers em um editor de texto seguro
sudo visudo
Adicione a seguinte linha no final do arquivo:

# Permite que user2 execute dangerous.sh sem senha
user2 ALL=(ALL) NOPASSWD: /bin/bash /root/dangerous.sh
Salve e feche o editor.

Verificação Final
Verifique se cada etapa foi concluída com sucesso.

Bash

# Verifique as novas propriedades do user1
id user1
# A saída deve mostrar 'gid=... (dev)'

getent passwd user1 | cut -d: -f6
# A saída deve ser '/home/accounts/user1'

# Verifique as propriedades do user2
id user2
# A saída deve mostrar que o usuário pertence aos grupos 'dev' e 'op'

# Teste a regra do sudo
# 1. Mude para o usuário user2
sudo su - user2

# 2. Tente executar o comando com sudo (não deve pedir senha)
sudo bash /root/dangerous.sh
# A saída esperada é "Script perigoso executado com sucesso!"
Conceitos Importantes para a Prova
usermod: Comando para modificar um usuário existente.

-g: Altera o grupo primário.

-G: Altera os grupos suplementares.

-d: Altera o diretório home.

useradd: Comando para adicionar um novo usuário.

visudo: A única forma segura de editar o arquivo /etc/sudoers. Ele trava o arquivo e verifica a sintaxe antes de salvar.

Sintaxe do Sudoers: quem ONDE=(COMO_QUEM) O_QUE

user2 ALL=(ALL) NOPASSWD: /bin/bash /root/dangerous.sh significa: o usuário user2, em TODOS os hosts, pode executar como TODOS os usuários, SEM SENHA, o comando específico /bin/bash /root/dangerous.sh.
