# LFCS - Questão 2: CronJobs (Agendamento de Tarefas)

### Objetivo da Tarefa

-   **Migrar um CronJob:** Tirar uma tarefa agendada do arquivo de sistema (`/etc/crontab`) e movê-la para o agendador pessoal do usuário `asset-manager`.
-   **Criar um CronJob:** Adicionar uma nova tarefa, diretamente no agendador do usuário `asset-manager`, com uma programação específica (dias da semana e horário).

---

### 1. Preparando o Ambiente no Lab

Antes de começar, é preciso simular a situação inicial da prova no ambiente de estudos.

#### 1.1 Criar Usuário e Scripts

```bash
# Crie o usuário 'asset-manager' com um diretório home
sudo useradd -m -s /bin/bash asset-manager

# Mude para o novo usuário para criar os scripts em seu diretório
sudo su - asset-manager

# Crie os scripts de exemplo
echo '#!/bin/bash' > ~/generate.sh
echo 'echo "Gerando relatorio em $(date)" >> /tmp/report.log' >> ~/generate.sh
echo '#!/bin/bash' > ~/clean.sh
echo 'echo "Limpando arquivos em $(date)" >> /tmp/clean.log' >> ~/clean.sh

# Torne os scripts executáveis
chmod +x ~/generate.sh ~/clean.sh

# Volte para seu usuário normal
exit
```

#### 1.2 Criar o CronJob de Sistema

Abra o crontab do sistema com `sudo` e adicione a linha que simula a tarefa existente.

```bash
sudo nano /etc/crontab
```

Adicione ao final do arquivo:

```crontab
# Tarefa a ser migrada para o usuario asset-manager
30 20 * * * root bash /home/asset-manager/generate.sh
```

---

### 2. Resolvendo a Questão: Passo a Passo

#### Parte 1: Migrar o CronJob do Sistema para o Usuário

```bash
# Inspecione o crontab do sistema
cat /etc/crontab

# Mude para o usuário asset-manager
sudo su - asset-manager

# Abra o editor de crontab deste usuário
crontab -e
```

No editor, cole a tarefa **removendo o campo `root`**:

```crontab
30 20 * * * bash /home/asset-manager/generate.sh
```

Salve e saia. Agora, complete a migração removendo a linha antiga do sistema:

```bash
# Volte para seu usuário sudoer
exit

# Edite o arquivo de sistema para apagar a linha original
sudo nano /etc/crontab
```

**Verificação:**

```bash
sudo crontab -u asset-manager -l
```

#### Parte 2: Criar a Nova Tarefa Agendada

```bash
# Abra o crontab do usuário novamente
sudo su - asset-manager
crontab -e
```

Adicione a nova linha para a tarefa que roda às 11:15 de segunda (1) e quinta (4):

```crontab
15 11 * * 1,4 bash /home/asset-manager/clean.sh
```

**Verificação Final:**

```bash
# Liste todas as tarefas do usuário
crontab -l

# Saída esperada:
# 30 20 * * * bash /home/asset-manager/generate.sh
# 15 11 * * 1,4 bash /home/asset-manager/clean.sh
```

---

### Conceitos Importantes para a Prova

-   **Crontab de Sistema (`/etc/crontab`):**
    -   Controlado pelo `root`.
    -   Possui uma coluna extra para especificar o **usuário** que executará o comando.
-   **Crontab de Usuário (`crontab -e`):**
    -   Cada usuário tem o seu (armazenado em `/var/spool/cron/crontabs/`).
    -   **Não tem** a coluna de usuário, pois o comando sempre roda como o dono do crontab.
