# **LFCS - Questão 2: CronJobs (Agendamento de Tarefas)**

### **Objetivo da Tarefa**

- **Gerenciar Tarefas Agendadas:** Manipular o agendador cron tanto no nível do sistema quanto no nível do usuário.
- **Diferenciar Escopos:** Entender a diferença de sintaxe e propósito entre o crontab do sistema (`/etc/crontab`) e o crontab de um usuário (`crontab -e`).

A tarefa exige as seguintes ações no servidor `data-001`:

1. Converter uma tarefa agendada que hoje é de sistema (`/etc/crontab`) para uma tarefa do usuário `asset-manager`.
2. Criar uma nova tarefa para o mesmo usuário que execute o script `/home/asset-manager/clean.sh` toda segunda e quinta-feira às 11:15 da manhã.

---

### **1. Preparando o Ambiente no Lab**

Para esta tarefa, a preparação envolve simular o cenário inicial, criando o usuário, os scripts de exemplo e a tarefa de sistema que precisará ser migrada.

### **1.1 Criar Usuário e Scripts**

bash

```
# Crie o usuário 'asset-manager' com um diretório homesudo useradd -m -s /bin/bash asset-manager

# Mude para o novo usuário para criar os scripts em seu diretóriosudo su - asset-manager

# Crie os scripts de exemploecho '#!/bin/bash' > ~/generate.sh
echo 'echo "Gerando relatorio em $(date)" >> /tmp/report.log' >> ~/generate.sh

echo '#!/bin/bash' > ~/clean.sh
echo 'echo "Limpando arquivos em $(date)" >> /tmp/clean.log' >> ~/clean.sh

# Torne os scripts executáveischmod +x ~/generate.sh ~/clean.sh

# Volte para seu usuário normalexit
```

### **1.2 Criar o CronJob de Sistema**

Abra o crontab do sistema com `sudo` para adicionar a linha que simula a tarefa existente.

bash

```
sudo nano /etc/crontab
```

Adicione ao final do arquivo:

bash

```
# Tarefa a ser migrada para o usuario asset-manager30 20 * * * root bash /home/asset-manager/generate.sh
```

---

### **2. Resolvendo a Questão: Passo a Passo**

A solução é dividida em duas partes: a migração da tarefa existente e a criação da nova tarefa.

### **Parte 1: Migrar o CronJob do Sistema para o Usuário**

bash

```
# Inspecione o crontab do sistema para ver a linha a ser migradacat /etc/crontab

# Mude para o usuário asset-manager para editar seu crontab pessoalsudo su - asset-manager

# Abra o editor de crontab deste usuáriocrontab -e
```

No editor, cole a tarefa, mas remova o campo de usuário (`root`), pois crontabs de usuário não possuem essa coluna.

bash

```
30 20 * * * bash /home/asset-manager/generate.sh
```

Salve, saia do editor e, para completar a migração, remova a linha antiga do crontab do sistema.

bash

```
# Volte para seu usuário com privilégios sudoexit

# Edite o arquivo de sistema para apagar a linha originalsudo nano /etc/crontab
```

### **Parte 2: Criar a Nova Tarefa Agendada**

Adicione a segunda tarefa diretamente no crontab do usuário.

bash

```
# Abra o crontab do usuário novamente (pode ser feito diretamente com sudo)sudo crontab -u asset-manager -e
```

Adicione a nova linha para a tarefa que roda às 11:15 de segunda-feira (1) e quinta-feira (4).

bash

```
15 11 * * 1,4 bash /home/asset-manager/clean.sh
```

---

### **Verificação Final**

Após executar os passos, liste o crontab do usuário `asset-manager` para confirmar que ambas as tarefas estão configuradas corretamente.

bash

```
# Liste todas as tarefas agendadas para o usuário 'asset-manager'sudo crontab -u asset-manager -l
```

A saída esperada deve conter as duas linhas:

text

```
30 20 * * * bash /home/asset-manager/generate.sh
15 11 * * 1,4 bash /home/asset-manager/clean.sh
```

---

### **Conceitos Importantes para a Prova**

- **Crontab de Sistema (`/etc/crontab`):**
    - Controlado pelo root e usado para tarefas de todo o sistema.
    - Possui uma coluna extra para especificar o usuário que executará o comando.
- **Crontab de Usuário (`crontab -e`):**
    - Cada usuário tem o seu próprio, editado com `crontab -e`.
    - Não tem a coluna de usuário, pois o comando sempre roda como o dono do crontab.
    - Os arquivos de configuração ficam armazenados em `/var/spool/cron/crontabs/`.
- **Sintaxe Cron:**
    - `minuto hora dia_mes mes dia_semana comando`
    - Dias da semana: 0-6 (0=Domingo) ou 1-7 (1=Segunda)
    - Pode usar nomes: `mon,thu` ou números: `1,4`
