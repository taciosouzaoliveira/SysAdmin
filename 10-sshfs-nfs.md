# **LFCS - Questão 10: SSHFS e NFS (Sistemas de Arquivos em Rede)**

### **Objetivo da Tarefa**

- **Montagem via SSH:** Utilizar o SSHFS para montar um sistema de arquivos remoto de forma segura sobre uma conexão SSH.
- **Compartilhamento de Rede:** Configurar um servidor NFS para compartilhar um diretório em rede e montar esse compartilhamento em um cliente.

A tarefa exige as seguintes ações:

1. No servidor `terminal`: Usar SSHFS para montar o diretório `/data-export` do servidor `app-srv1` no ponto de montagem local `/app-srv1/data-export`, com permissão de leitura/escrita e acessível por outros usuários.
2. No servidor `terminal`: Configurar o servidor NFS para compartilhar o diretório `/nfs/share` em modo somente leitura para toda a rede `192.168.10.0/24`.
3. No servidor `app-srv1`: Montar o compartilhamento NFS (`/nfs/share` do servidor terminal) no diretório local `/nfs/terminal/share`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Preparação do Servidor terminal**

bash

```
# Crie o ponto de montagem para o SSHFSsudo mkdir -p /app-srv1/data-export

# Crie o diretório que será compartilhado via NFSsudo mkdir -p /nfs/share
echo "Arquivo de teste NFS" | sudo tee /nfs/share/teste.txt > /dev/null
```

### **1.2 Preparação do Servidor app-srv1**

bash

```
# Conecte-se ao servidor app-srv1ssh app-srv1

# Crie o ponto de montagem para o NFSsudo mkdir -p /nfs/terminal/share

# Crie o diretório que será acessado remotamente via SSHFSsudo mkdir -p /data-export
echo "Arquivo de teste SSHFS" | sudo tee /data-export/teste_sshfs.txt > /dev/null

exit
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Configurar a Montagem SSHFS (no servidor terminal)**

bash

```
sudo sshfs -o allow_other,rw app-srv1:/data-export /app-srv1/data-export
```

### **Parte 2: Configurar o Servidor NFS (no servidor terminal)**

bash

```
# Edite o arquivo de exportssudo nano /etc/exports
```

Adicione a linha:

text

```
/nfs/share 192.168.10.0/24(ro,sync,no_subtree_check)
```

Aplique as alterações:

bash

```
sudo exportfs -ra
```

### **Parte 3: Configurar o Cliente NFS (no servidor app-srv1)**

bash

```
ssh app-srv1
sudo mount terminal:/nfs/share /nfs/terminal/share
```

---

### **Verificação Final**

bash

```
# No servidor 'terminal', verifique a montagem SSHFSls /app-srv1/data-export
touch /app-srv1/data-export/novo_arquivo.txt

# No servidor 'terminal', verifique o compartilhamento NFS
showmount -e

# No servidor 'app-srv1', verifique a montagem NFSls /nfs/terminal/share
touch /nfs/terminal/share/novo_arquivo.txt# Deve falhar (read-only)
```

---

### **Conceitos Importantes para a Prova**

- **SSHFS:** Sistema de arquivos sobre SSH
- **NFS:** Network File System para compartilhamento de arquivos
- **`/etc/exports`:** Configuração de compartilhamentos NFS
- **`exportfs -ra`:** Recarrega configurações NFS
