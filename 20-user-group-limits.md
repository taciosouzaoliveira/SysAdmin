# **LFCS - Questão 20: Limites de Usuários e Grupos**

### **Objetivo da Tarefa**

- **Gerenciar Limites de Recursos (ulimit):** Configurar limites de recursos para usuários e grupos de forma persistente.
- **Diferenciar Limites soft e hard:** Aplicar um limite máximo que não pode ser modificado pelo usuário.

A tarefa exige as seguintes ações no servidor `web-srv1`:

1. Para a usuária `jackie`, configurar um limite máximo (hard limit) de 1024 processos (`nproc`). Remover a solução temporária que estava no arquivo `.bashrc`.
2. Para o grupo `operators`, configurar um limite de no máximo 1 login simultâneo (`maxlogins`).

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Criar Usuário, Grupo e Configuração Temporária**

bash

```
ssh web-srv1
sudo groupadd operators
sudo useradd -m jackie

# Adicione configuração temporária (para depois remover)echo 'ulimit -S -u 1024' | sudo tee -a /home/jackie/.bashrc > /dev/null
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Configurar Limite Hard para jackie**

bash

```
# Remova a configuração temporária do .bashrcsudo nano /home/jackie/.bashrc# Remova a linha 'ulimit -S -u 1024'# Configure limite permanentesudo nano /etc/security/limits.conf
```

Adicione a linha:

text

```
jackie    hard    nproc    1024
```

### **Parte 2: Configurar Limite para Grupo operators**

No mesmo arquivo `/etc/security/limits.conf`, adicione:

text

```
@operators    hard    maxlogins    1
```

---

### **Verificação Final**

bash

```
# Teste o limite da jackiesudo su - jackie
ulimit -u# Deve mostrar 1024ulimit -S -u 1100# Deve falhar (não pode modificar hard limit)exit
```

---

### **Conceitos Importantes para a Prova**

- **`/etc/security/limits.conf`:** Arquivo para limites persistentes
- **Hard limit:** Teto máximo que não pode ser ultrapassado
- **Soft limit:** Limite atual, pode ser aumentado até o hard limit
- **`nproc`:** Número de processos
- **`maxlogins`:** Número de logins simultâneos
- **`@group`:** Aplica regra a um grupo inteiro

---

## **Resumo Geral dos Conceitos LFCS**

### **Comandos Essenciais:**

- **Sistema:** `uname -r`, `timedatectl`, `systemctl`
- **Arquivos:** `find`, `grep`, `sed`, `tar`, `mount`
- **Rede:** `iptables`, `curl`, `ssh`
- **Usuários:** `useradd`, `usermod`, `visudo`
- **Processos:** `ps`, `kill`, `strace`
- **Discos:** `lsblk`, `df`, `mkfs`, `lvm`
- **Contêineres:** `docker`
- **Versionamento:** `git`

### **Arquivos de Configuração Importantes:**

- `/etc/crontab` - Cronjobs de sistema
- `/etc/systemd/timesyncd.conf` - Sincronização de tempo
- `/etc/ssh/sshd_config` - Configuração SSH
- `/etc/sudoers` - Permissões sudo
- `/etc/exports` - Compartilhamentos NFS
- `/etc/security/limits.conf` - Limites de recursos
- `/etc/nginx/sites-available/` - Configurações Nginx

### **Boas Práticas:**

- Sempre use `visudo` para editar `/etc/sudoers`
- Teste configurações antes de aplicar (`nginx -t`, `sshd -t`)
- Faça backup antes de modificar arquivos importantes
- Use `find -exec` para operações em lote
- Configure limites hard para segurança
