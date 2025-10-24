# **LFCS - Questão 6: Gerenciamento de Usuários, Grupos e Sudo**

### **Objetivo da Tarefa**

- **Modificar Usuário Existente:** Alterar o grupo primário e o diretório home de um usuário já existente.
- **Criar Novo Usuário:** Adicionar um novo usuário com grupos, diretório e shell específicos.
- **Configurar Sudo:** Conceder permissões de sudo para um comando específico, sem a necessidade de senha.

A tarefa exige as seguintes ações no servidor `app-srv1`:

1. Mudar o grupo primário do usuário `user1` para `dev` e seu diretório home para `/home/accounts/user1`.
2. Adicionar um novo usuário `user2` com os grupos `dev` e `op`, diretório home `/home/accounts/user2`, e terminal `/bin/bash`.
3. Permitir que o usuário `user2` execute o comando `sudo bash /root/dangerous.sh` sem precisar digitar a senha.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Criar a Estrutura de Diretórios e Grupos**

bash

```
# Conecte-se ao servidor app-srv1ssh app-srv1

# Crie os grupos que serão utilizadossudo groupadd dev
sudo groupadd op

# Crie o diretório base para os novos 'homes'sudo mkdir -p /home/accounts
```

### **1.2 Criar o Usuário user1 de Exemplo**

bash

```
# Crie o usuário 'user1' com uma configuração padrãosudo useradd -m user1
```

### **1.3 Criar o Script para o Teste de Sudo**

bash

```
# Crie o script de exemploecho '#!/bin/bash' | sudo tee /root/dangerous.sh > /dev/null
echo 'echo "Script perigoso executado com sucesso!"' | sudo tee -a /root/dangerous.sh > /dev/null

# Dê permissão de execução ao scriptsudo chmod +x /root/dangerous.sh
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Modificar o Usuário user1**

bash

```
# -g: muda o grupo primário# -d: muda o diretório homesudo usermod -g dev -d /home/accounts/user1 user1
```

### **Parte 2: Criar o Novo Usuário user2**

bash

```
# -s: define o shell de login# -m: cria o diretório home# -d: especifica o caminho do diretório home# -G: adiciona o usuário a grupos suplementaressudo useradd -s /bin/bash -m -d /home/accounts/user2 -G dev,op user2
```

### **Parte 3: Configurar a Permissão Sudo**

bash

```
# Edite o arquivo sudoers de forma segurasudo visudo
```

Adicione a seguinte linha no final do arquivo:

text

```
user2 ALL=(ALL) NOPASSWD: /bin/bash /root/dangerous.sh
```

Salve e feche o editor.

---

### **Verificação Final**

bash

```
# Verifique as novas propriedades do user1id user1
# A saída deve mostrar 'gid=... (dev)'

getent passwd user1 | cut -d: -f6
# A saída deve ser '/home/accounts/user1'# Verifique as propriedades do user2id user2
# A saída deve mostrar que pertence aos grupos 'dev' e 'op'# Teste a regra do sudosudo su - user2
sudo bash /root/dangerous.sh
# A saída esperada é "Script perigoso executado com sucesso!"
```

---

### **Conceitos Importantes para a Prova**

- **`usermod`:** Comando para modificar usuário existente
- **`useradd`:** Comando para adicionar novo usuário
- **`visudo`:** Comando seguro para editar `/etc/sudoers`
- **Sintaxe do Sudoers:** `quem ONDE=(COMO_QUEM) O_QUE`
