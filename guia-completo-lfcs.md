# 

# **LFCS - Questão 1: Informações do Kernel e Sistema**

### **Objetivo da Tarefa**

- **Coletar Dados do Sistema:** Usar comandos de linha para extrair informações específicas do sistema operacional.
- **Redirecionar Saída:** Salvar os dados coletados em arquivos de texto nos locais designados.

A tarefa exige as seguintes ações no servidor `terminal`:

1. Escrever a release do Kernel do Linux no arquivo `/opt/course/1/kernel`.
2. Escrever o valor atual do parâmetro de rede `ip_forward` no arquivo `/opt/course/1/ip_forward`.
3. Escrever o fuso horário (timezone) do sistema no arquivo `/opt/course/1/timezone`.

---

### **1. Preparando o Ambiente no Lab**

Para esta tarefa, a única preparação necessária é garantir que o diretório onde as respostas serão salvas exista.

### **1.1 Criar o Diretório de Destino**

bash

```
sudo mkdir -p /opt/course/1
```

---

### **2. Resolvendo a Questão: Passo a Passo**

A solução envolve executar comandos específicos para cada informação e redirecionar a saída para o arquivo de destino correto.

### **Parte 1: Coletar a Versão do Kernel**

bash

```
uname -r > /opt/course/1/kernel
```

### **Parte 2: Coletar o Parâmetro ip_forward**

bash

```
cat /proc/sys/net/ipv4/ip_forward > /opt/course/1/ip_forward
```

### **Parte 3: Coletar o Fuso Horário**

bash

```
cat /etc/timezone > /opt/course/1/timezone
```

---

### **Verificação Final**

bash

```
# Verifique o conteúdo do arquivo do kernelcat /opt/course/1/kernel
# Saída esperada (exemplo): 5.15.0-69-generic# Verifique o conteúdo do arquivo ip_forwardcat /opt/course/1/ip_forward
# Saída esperada (exemplo): 1# Verifique o conteúdo do arquivo de fuso horáriocat /opt/course/1/timezone
# Saída esperada (exemplo): UTC
```

---

### **Conceitos Importantes para a Prova**

- **`uname -r`:** Comando específico para imprimir a release (versão) do kernel em execução.
- **`/proc/sys/`:** Sistema de arquivos virtual que permite visualizar e alterar parâmetros do kernel em tempo real.
- **`/proc/sys/net/ipv4/ip_forward`:** Controla se o encaminhamento de pacotes IP está ativado (1) ou desativado (0).
- **`/etc/timezone`:** Arquivo de configuração que contém o nome do fuso horário utilizado pelo sistema.

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
    
    # **LFCS - Questão 3: Sincronização de Horário (NTP)**
    
    ### **Objetivo da Tarefa**
    
    - **Configurar Servidores NTP:** Atualizar a configuração do systemd-timesyncd para usar servidores NTP específicos.
    - **Ajustar Parâmetros:** Definir intervalos de consulta e de nova tentativa de conexão.
    
    A tarefa exige as seguintes configurações no servidor `terminal`:
    
    1. Definir `0.pool.ntp.org` e `1.pool.ntp.org` como servidores NTP principais.
    2. Definir `ntp.ubuntu.com` e `0.debian.pool.ntp.org` como servidores NTP de fallback (reserva).
    3. Definir o intervalo máximo de consulta (`PollIntervalMaxSec`) para 1000 segundos e a tentativa de reconexão (`ConnectionRetrySec`) para 20 segundos.
    
    ---
    
    ### **1. Preparando o Ambiente no Lab**
    
    Para esta tarefa, não é preciso criar arquivos ou usuários. A preparação consiste em inspecionar o estado atual do serviço de sincronização de tempo.
    
    ### **1.1 Verificar o Status Atual**
    
    bash
    
    ```
    timedatectl
    ```
    
    Isso mostrará se o serviço systemd-timesyncd está ativo e se o relógio do sistema está sincronizado.
    
    ### **1.2 Inspecionar a Configuração Existente**
    
    bash
    
    ```
    cat /etc/systemd/timesyncd.conf
    ```
    
    ---
    
    ### **2. Resolvendo a Questão: Passo a Passo**
    
    A solução envolve editar o arquivo de configuração e reiniciar o serviço para aplicar as novas diretivas.
    
    ### **Parte 1: Editar o Arquivo de Configuração**
    
    bash
    
    ```
    sudo nano /etc/systemd/timesyncd.conf
    ```
    
    Adicione ou edite as linhas na seção `[Time]`:
    
    ini
    
    ```
    [Time]NTP=0.pool.ntp.org 1.pool.ntp.org
    FallbackNTP=ntp.ubuntu.com 0.debian.pool.ntp.org
    PollIntervalMaxSec=1000
    ConnectionRetrySec=20
    ```
    
    Salve e feche o arquivo.
    
    ### **Parte 2: Reiniciar o Serviço**
    
    bash
    
    ```
    sudo systemctl restart systemd-timesyncd
    ```
    
    ---
    
    ### **Verificação Final**
    
    Verifique o status do serviço para confirmar que está funcionando corretamente:
    
    bash
    
    ```
    sudo systemctl status systemd-timesyncd
    ```
    
    A saída deve mostrar `Active: active (running)` e nos logs você deve ver uma mensagem indicando sincronização com um dos novos servidores configurados.
    
    ---
    
    ### **Conceitos Importantes para a Prova**
    
    - **systemd-timesyncd:** Serviço do systemd responsável por sincronizar o relógio do sistema com servidores NTP.
    - **`/etc/systemd/timesyncd.conf`:** Arquivo de configuração principal.
    - **Diretivas:**
        - `NTP=`: Define servidores NTP principais
        - `FallbackNTP=`: Define servidores de reserva
        - `PollIntervalMaxSec=`: Intervalo máximo de consulta
        - `ConnectionRetrySec=`: Tempo de tentativa de reconexão

# **LFCS - Questão 4: Variáveis de Ambiente**

### **Objetivo da Tarefa**

- **Manipular Variáveis:** Criar um script que defina e utilize variáveis de ambiente.
- **Entender Escopo:** Demonstrar a diferença entre uma variável de shell local e uma variável exportada para processos filhos.

A tarefa exige a criação de um script em `/opt/course/4/script.sh` que execute as seguintes ações:

1. Defina uma nova variável de ambiente `VARIABLE2` com o conteúdo `v2`, disponível apenas dentro do próprio script.
2. Imprima o conteúdo da variável `VARIABLE2`.
3. Defina uma nova variável de ambiente `VARIABLE3` com o conteúdo `${VARIABLE1}-extended`, que deve estar disponível no script e em todos os seus processos filhos.
4. Imprima o conteúdo da variável `VARIABLE3`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Criar o Diretório e o Arquivo de Script**

bash

```
sudo mkdir -p /opt/course/4
sudo touch /opt/course/4/script.sh
sudo chmod +x /opt/course/4/script.sh
```

### **1.2 Simular a Variável Pré-existente**

bash

```
export VARIABLE1="random-string"
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Escrever o Script**

bash

```
sudo nano /opt/course/4/script.sh
```

Adicione o seguinte conteúdo:

bash

```
#!/bin/bash
# 1. Define uma variável local, disponível apenas neste scriptVARIABLE2="v2"

# 2. Imprime o conteúdo da variável localecho $VARIABLE2

# 3. Define e EXPORTA uma variável, tornando-a disponível para processos filhosexport VARIABLE3="${VARIABLE1}-extended"

# 4. Imprime o conteúdo da variável exportadaecho $VARIABLE3
```

---

### **Verificação Final**

bash

```
/opt/course/4/script.sh
```

Saída esperada:

text

```
v2
random-string-extended
```

---

### **Conceitos Importantes para a Prova**

- **Variável Local (`NOME="valor"`):** Existe apenas no processo onde foi criada.
- **Variável Exportada (`export NOME="valor"`):** Fica disponível para o processo e todos os processos filhos.
- **Escopo de Variáveis:** O `export` não afeta o processo "pai" que chamou o script.

# **LFCS - Questão 5: Arquivos Compactados e Compressão**

### **Objetivo da Tarefa**

- **Manipular Arquivos:** Descompactar um arquivo `.tar.bz2` e re-compactá-lo usando um algoritmo de compressão diferente (gzip).
- **Verificar Integridade:** Garantir que o conteúdo do arquivo original e do novo arquivo seja idêntico.

A tarefa exige as seguintes ações no servidor `data-001`:

1. Usar o arquivo original `/imports/import001.tar.bz2`.
2. Criar um novo arquivo `/imports/import001.tar.gz` com o mesmo conteúdo, utilizando a melhor compressão gzip possível.
3. Listar o conteúdo de ambos os arquivos, ordenar a lista e salvá-la em `/imports/import001.tar.bz2_list` e `/imports/import001.tar.gz_list`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Criar o Arquivo de Exemplo**

bash

```
# Conecte-se ao servidor data-001ssh data-001

# Crie a estrutura de diretórios e arquivos de exemplosudo mkdir -p /imports/source_files/dir1
sudo touch /imports/source_files/file1.txt
sudo touch /imports/source_files/dir1/file2.txt

# Crie o arquivo .tar.bz2 inicialsudo tar cjf /imports/import001.tar.bz2 -C /imports/source_files .

# Limpe os arquivos de origemsudo rm -rf /imports/source_files
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Extrair o Conteúdo Original**

bash

```
sudo mkdir /imports/temp_extract
sudo tar xjf /imports/import001.tar.bz2 -C /imports/temp_extract
```

### **Parte 2: Criar o Novo Arquivo .tar.gz**

bash

```
sudo tar czf /imports/import001.tar.gz --gzip:best -C /imports/temp_extract .
```

### **Parte 3: Limpar o Ambiente**

bash

```
sudo rm -rf /imports/temp_extract
```

### **Parte 4: Verificar Integridade**

bash

```
sudo tar tjf /imports/import001.tar.bz2 | sort > /imports/import001.tar.bz2_list
sudo tar tzf /imports/import001.tar.gz | sort > /imports/import001.tar.gz_list
diff /imports/import001.tar.bz2_list /imports/import001.tar.gz_list
```

---

### **Conceitos Importantes para a Prova**

- **`tar`:** Ferramenta para criar e manipular arquivos de arquivamento.
- **Operações:**
    - `c`: criar
    - `x`: extrair
    - `t`: listar
    - `f`: arquivo
- **Filtros de Compressão:**
    - `z`: gzip
    - `j`: bzip2
- **`C <DIRETÓRIO>`:** Muda para o diretório antes de executar a operação.

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

# **LFCS - Questão 7: Filtro de Pacotes de Rede (Firewall)**

### **Objetivo da Tarefa**

- **Filtrar Tráfego:** Implementar regras de firewall para controlar o tráfego de rede de entrada e saída.
- **Manipular Pacotes:** Usar iptables para bloquear, redirecionar e permitir tráfego com base em portas e endereços IP.

A tarefa exige a implementação das seguintes regras de firewall na interface `eth0` do servidor `data-002`:

1. Fechar a porta 5000 para tráfego externo.
2. Redirecionar todo o tráfego que chega na porta 6000 para a porta local 6001.
3. Permitir que a porta 6002 seja acessível apenas pelo IP 192.168.10.80 (servidor data-001).
4. Bloquear todo o tráfego de saída para o IP 192.168.10.70 (servidor app-srv1).

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Verificar a Conectividade Atual**

bash

```
# De um servidor remoto, teste o acesso às portascurl data-002:5000
curl data-002:6001
curl data-002:6002
```

### **1.2 Inspecionar as Regras de Firewall Existentes**

bash

```
# Conecte-se ao servidor data-002ssh data-002

# Liste as regras atuaissudo iptables -L
sudo iptables -t nat -L
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Fechar a Porta 5000**

bash

```
sudo iptables -A INPUT -p tcp --dport 5000 -j DROP
```

### **Parte 2: Redirecionar a Porta 6000 para 6001**

bash

```
sudo iptables -t nat -A PREROUTING -p tcp --dport 6000 -j REDIRECT --to-port 6001
```

### **Parte 3: Restringir o Acesso à Porta 6002**

bash

```
# Primeiro permita o IP específicosudo iptables -A INPUT -p tcp --dport 6002 -s 192.168.10.80 -j ACCEPT

# Depois bloqueie todo o restosudo iptables -A INPUT -p tcp --dport 6002 -j DROP
```

### **Parte 4: Bloquear Tráfego de Saída**

bash

```
sudo iptables -A OUTPUT -d 192.168.10.70 -j DROP
```

---

### **Verificação Final**

bash

```
# Liste as regras aplicadassudo iptables -L
sudo iptables -t nat -L

# Teste o acesso às portascurl data-002:5000# Deve falharcurl data-002:6000# Deve retornar conteúdo da porta 6001curl data-002:6002# Deve falhar (exceto do data-001)
```

---

### **Conceitos Importantes para a Prova**

- **`iptables`:** Ferramenta para configurar firewall Netfilter
- **Tabelas:**
    - `filter`: Tabela padrão (INPUT, OUTPUT, FORWARD)
    - `nat`: Para tradução de endereços (PREROUTING, POSTROUTING)
- **Ações:**
    - `ACCEPT`: Permite pacote
    - `DROP`: Descarta pacote
    - `REDIRECT`: Redireciona para porta local

# **LFCS - Questão 8: Gerenciamento de Discos**

### **Objetivo da Tarefa**

- **Formatar e Montar Discos:** Criar um novo sistema de arquivos em um disco, montá-lo e criar um arquivo.
- **Gerenciar Espaço em Disco:** Identificar o disco com maior uso e liberar espaço nele.
- **Lidar com Discos Ocupados:** Identificar um processo que está utilizando um ponto de montagem, finalizá-lo e desmontar o disco.

A tarefa exige a execução das seguintes ações:

1. Formatar o disco `/dev/vdb` com ext4, montá-lo em `/mnt/backup-black` e criar o arquivo `/mnt/backup-black/completed`.
2. Verificar qual dos discos, `/dev/vdc` ou `/dev/vdd`, tem maior uso de armazenamento e esvaziar a pasta de lixo (`.trash`) nele.
3. Identificar qual dos processos, `dark-matter-v1` ou `dark-matter-v2`, consome mais memória, descobrir em qual disco o executável está localizado e desmontar esse disco.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Inspecionar os Discos Existentes**

bash

```
# Lista os dispositivos de bloco
lsblk -f

# Mostra o uso de espaço em discodf -h
```

### **1.2 Inspecionar os Processos em Execução**

bash

```
# Lista os processos dark-matterps aux | grep dark-matter
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Formatar e Montar /dev/vdb**

bash

```
# Cria sistema de arquivos ext4sudo mkfs.ext4 /dev/vdb

# Cria diretório de montagemsudo mkdir -p /mnt/backup-black

# Monta o discosudo mount /dev/vdb /mnt/backup-black

# Cria arquivo de verificaçãosudo touch /mnt/backup-black/completed
```

### **Parte 2: Limpar o Disco Mais Cheio**

bash

```
# Verifica uso dos discosdf -h | grep /dev/vd[cd]

# Identifica o ponto de montagem do disco mais cheio# Supondo que seja /mnt/backup001sudo rm -rf /mnt/backup001/.trash/*
```

### **Parte 3: Desmontar o Disco em Uso**

bash

```
# Identifica o processo com maior consumo de memóriaps aux | grep dark-matter

# Tenta desmontar (deve falhar)sudo umount /mnt/app-4e9d7e1e

# Identifica processo bloqueadorsudo lsof | grep /mnt/app-4e9d7e1e

# Finaliza o processosudo kill <PID_do_dark-matter-v2>

# Desmonta o discosudo umount /mnt/app-4e9d7e1e
```

---

### **Verificação Final**

bash

```
# Verifique se o novo disco está montadodf -h | grep /mnt/backup-black

# Verifique se o espaço foi liberadodf -h

# Verifique se o disco foi desmontadodf -h | grep /mnt/app-4e9d7e1e
```

---

### **Conceitos Importantes para a Prova**

- **`mkfs.ext4`:** Cria sistema de arquivos ext4
- **`mount`/`umount`:** Monta/desmonta sistemas de arquivos
- **`df -h`:** Exibe uso de espaço em disco
- **`ps aux`:** Lista processos em execução
- **`lsof`:** Lista arquivos abertos por processos

# **LFCS - Questão 9: Encontrar Arquivos com Propriedades e Executar Ações**

### **Objetivo da Tarefa**

- **Busca Avançada de Arquivos:** Utilizar o comando `find` com diferentes critérios (data, tamanho, permissão) para localizar arquivos específicos.
- **Executar Ações em Lote:** Executar comandos (`rm`, `mv`) nos arquivos encontrados para automatizar a organização e limpeza.

A tarefa exige as seguintes ações no diretório `/var/backup/backup-015` do servidor `data-001`:

1. Deletar todos os arquivos modificados antes de 01/01/2020.
2. Mover todos os arquivos restantes que são menores que 3KiB para o subdiretório `small/`.
3. Mover todos os arquivos restantes que são maiores que 10KiB para o subdiretório `large/`.
4. Mover todos os arquivos restantes que têm permissão 777 para o subdiretório `compromised/`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar e Criar Diretórios de Destino**

bash

```
# Conecte-se ao servidor data-001ssh data-001

# Navegue até o diretório de backupcd /var/backup/backup-015

# Crie os subdiretóriossudo mkdir small large compromised
```

### **1.2 Inspecionar o Diretório**

bash

```
# Conte o número total de arquivosls | wc -l
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Deletar Arquivos Antigos**

bash

```
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -exec rm {} \;
```

### **Parte 2: Mover Arquivos Pequenos (< 3KiB)**

bash

```
find . -maxdepth 1 -type f -size -3k -exec mv {} ./small/ \;
```

### **Parte 3: Mover Arquivos Grandes (> 10KiB)**

bash

```
find . -maxdepth 1 -type f -size +10k -exec mv {} ./large/ \;
```

### **Parte 4: Mover Arquivos com Permissão 777**

bash

```
find . -maxdepth 1 -type f -perm 777 -exec mv {} ./compromised/ \;
```

---

### **Verificação Final**

bash

```
# Conte os arquivos em cada diretóriols | wc -l
ls small/ | wc -l
ls large/ | wc -l
ls compromised/ | wc -l
```

---

### **Conceitos Importantes para a Prova**

- **`find`:** Ferramenta principal para localizar arquivos
- **Predicados:**
    - `maxdepth 1`: Limita busca ao diretório atual
    - `type f`: Apenas arquivos regulares
    - `! -newermt "DATE"`: Arquivos mais antigos que a data
    - `size [-|+]N[k|M|G]`: Filtra por tamanho
    - `perm MODE`: Filtra por permissões
- **`exec COMANDO {} \;`:** Executa comando para cada arquivo encontrado

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

# **LFCS - Questão 11: Gerenciamento de Docker**

### **Objetivo da Tarefa**

- **Gerenciar Ciclo de Vida:** Parar um contêiner em execução.
- **Inspecionar Contêineres:** Extrair informações detalhadas, como configurações de rede e volumes.
- **Criar e Executar Contêineres:** Iniciar um novo contêiner com configurações específicas.

A tarefa exige as seguintes ações:

1. Parar o contêiner Docker chamado `frontend_v1`.
2. Obter informações do contêiner `frontend_v2`:
    - Escrever seu endereço IP no arquivo `/opt/course/11/ip-address`
    - Escrever o diretório de destino do seu volume montado em `/opt/course/11/mount-destination`
3. Iniciar um novo contêiner em modo detached com:
    - Nome: `frontend_v3`
    - Imagem: `nginx:alpine`
    - Limite de Memória: 30m (30 Megabytes)
    - Mapeamento de Porta: 1234 (host) para 80 (contêiner)

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Listar Contêineres Atuais**

bash

```
# Lista os contêineres em execuçãosudo docker ps
```

### **1.2 Criar o Diretório de Destino**

bash

```
sudo mkdir -p /opt/course/11
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Parar o Contêiner frontend_v1**

bash

```
sudo docker stop frontend_v1
```

### **Parte 2: Inspecionar o Contêiner frontend_v2**

bash

```
# Extrai o endereço IPsudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' frontend_v2 > /opt/course/11/ip-address

# Extrai o diretório de destino do volumesudo docker inspect -f '{{range .Mounts}}{{.Destination}}{{end}}' frontend_v2 > /opt/course/11/mount-destination
```

### **Parte 3: Iniciar o Novo Contêiner frontend_v3**

bash

```
sudo docker run -d --name frontend_v3 --memory 30m -p 1234:80 nginx:alpine
```

---

### **Verificação Final**

bash

```
# Verifique que 'frontend_v1' está paradosudo docker ps -a

# Verifique o conteúdo dos arquivos de informaçãocat /opt/course/11/ip-address
cat /opt/course/11/mount-destination

# Verifique se o novo contêiner está em execuçãosudo docker ps

# Teste o acesso à porta mapeadacurl localhost:1234
```

---

### **Conceitos Importantes para a Prova**

- **`docker ps`:** Lista contêineres em execução
- **`docker stop`:** Para um contêiner
- **`docker inspect`:** Fornece informações detalhadas do contêiner
- **`docker run`:** Cria e inicia um novo contêiner
- **Flags do `docker run`:**
    - `d`: Executa em segundo plano
    - `-name`: Atribui nome ao contêiner
    - `-memory`: Define limite de memória
    - `p`: Mapeia porta do host para contêiner

# **LFCS - Questão 12: Fluxo de Trabalho com Git**

### **Objetivo da Tarefa**

- **Gerenciar Repositório:** Clonar um repositório Git.
- **Trabalhar com Branches:** Inspecionar o conteúdo de diferentes branches, identificar a correta e mesclá-la na branch principal.
- **Versionar Alterações:** Criar um novo diretório, garantir que ele seja versionado e salvar as alterações com commit.

A tarefa exige as seguintes ações:

1. Clonar o repositório `/repositories/auto-verifier` para `/home/candidate/repositories/auto-verifier`.
2. Dentre as branches `dev4`, `dev5` e `dev6`, encontrar aquela em que o arquivo `config.yaml` contém a linha `user_registration_level: open`.
3. Fazer o merge apenas da branch encontrada para a branch `main`.
4. Na branch `main`, criar um novo diretório chamado `Logs` e, dentro dele, um arquivo oculto e vazio chamado `.keep`.
5. Fazer o commit da alteração com a mensagem "added log directory".

---

### **1. Preparando o Ambiente no Lab**

A primeira etapa da resolução é a clonagem que prepara o ambiente de trabalho.

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Clonar o Repositório**

bash

```
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier
cd /home/candidate/repositories/auto-verifier
```

### **Parte 2: Encontrar e Mesclar a Branch Correta**

bash

```
# Liste todas as branchesgit branch -a

# Verifique cada branchgit checkout dev4
grep "user_registration_level" config.yaml# Saída: closedgit checkout dev5
grep "user_registration_level" config.yaml# Saída: open → ENCONTRAMOS!git checkout dev6
grep "user_registration_level" config.yaml# Saída: closed# Volte para main e faça o mergegit checkout main
git merge dev5
```

### **Parte 3: Criar o Novo Diretório e Arquivo**

bash

```
mkdir Logs
touch Logs/.keep
```

### **Parte 4: Fazer o Commit da Alteração**

bash

```
git add Logs
git commit -m "added log directory"
```

---

### **Verificação Final**

bash

```
# Verifique se a alteração do merge está presentegrep "user_registration_level" config.yaml

# Verifique o status do gitgit status

# Verifique o histórico de commitsgit log -1
```

---

### **Conceitos Importantes para a Prova**

- **`git clone`:** Cria cópia local de repositório
- **`git branch -a`:** Lista todas as branches
- **`git checkout`:** Muda para branch especificada
- **`git merge`:** Traz alterações de uma branch para outra
- **`git add`:** Adiciona arquivos à staging area
- **`git commit`:** Salva alterações no histórico

# **LFCS - Questão 13: Segurança de Processos em Tempo de Execução**

### **Objetivo da Tarefa**

- **Análise de Processos:** Inspecionar processos em execução em tempo real para identificar atividades suspeitas.
- **Uso de Ferramentas de Diagnóstico:** Utilizar `strace` para monitorar as chamadas de sistema feitas por um processo.
- **Ação de Remediação:** Finalizar um processo malicioso e remover seu executável.

A tarefa exige as seguintes ações no servidor `web-srv1`:

1. Investigar os três processos em execução: `collector1`, `collector2`, e `collector3`.
2. Identificar qual(is) deles está(ão) executando a chamada de sistema proibida `kill`.
3. Para o(s) processo(s) infrator(es), finalizar sua execução e apagar o arquivo executável correspondente.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar ao Servidor e Listar os Processos**

bash

```
ssh web-srv1
ps aux | grep collector
```

Anote os PIDs dos processos `collector1`, `collector2` e `collector3`.

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Inspecionar os Processos com strace**

bash

```
# Inspecione cada processo (substitua <PID> pelos IDs reais)sudo strace -p <PID_collector1># Nenhuma chamada 'kill'sudo strace -p <PID_collector2># Mostra 'kill' → INFRATORsudo strace -p <PID_collector3># Nenhuma chamada 'kill'
```

### **Parte 2: Finalizar o Processo e Remover o Executável**

bash

```
# Use o PID do collector2 identificadosudo kill <PID_collector2>

# Remova o executávelsudo rm /bin/collector2
```

---

### **Verificação Final**

bash

```
# Procure pelo processo novamenteps aux | grep collector2

# Tente listar o arquivo executávells /bin/collector2# Deve retornar erro
```

---

### **Conceitos Importantes para a Prova**

- **`ps aux`:** Lista todos os processos em execução
- **`strace`:** Rastreia chamadas de sistema de um processo
- **`p <PID>`:** Anexa strace a processo em execução
- **`kill <PID>`:** Envia sinal para finalizar processo
- **Syscall:** Chamada de sistema do kernel

# **LFCS - Questão 14: Redirecionamento de Saída**

### **Objetivo da Tarefa**

- **Entender Streams de Saída:** Diferenciar e manipular os canais de saída padrão (stdout) e de erro padrão (stderr).
- **Usar Operadores de Redirecionamento:** Utilizar operadores do shell (`>`, `2>`, `2>&1`) para controlar para onde a saída é enviada.
- **Capturar Códigos de Saída:** Salvar o código de status de um programa após sua execução.

A tarefa exige as seguintes ações com o programa `/bin/output-generator` no servidor `app-srv1`:

1. Executar o programa e redirecionar toda sua stdout para `/var/output-generator/1.out`.
2. Executar o programa e redirecionar toda sua stderr para `/var/output-generator/2.out`.
3. Executar o programa e redirecionar tanto stdout quanto stderr para `/var/output-generator/3.out`.
4. Executar o programa e escrever seu código de saída numérico em `/var/output-generator/4.out`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar ao Servidor e Criar Diretório**

bash

```
ssh app-srv1
sudo mkdir -p /var/output-generator
```

### **1.2 Inspecionar o Comportamento do Programa**

bash

```
/bin/output-generator
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Redirecionar stdout**

bash

```
/bin/output-generator > /var/output-generator/1.out
```

### **Parte 2: Redirecionar stderr**

bash

```
/bin/output-generator 2> /var/output-generator/2.out
```

### **Parte 3: Redirecionar stdout e stderr**

bash

```
/bin/output-generator > /var/output-generator/3.out 2>&1
```

### **Parte 4: Capturar o Código de Saída**

bash

```
/bin/output-generator > /dev/null 2>&1
echo $? > /var/output-generator/4.out
```

---

### **Verificação Final**

bash

```
# Conte as linhas em cada arquivowc -l /var/output-generator/1.out# ~20342 linhaswc -l /var/output-generator/2.out# ~12336 linhaswc -l /var/output-generator/3.out# ~32678 linhascat /var/output-generator/4.out# Código de saída (ex: 123)
```

---

### **Conceitos Importantes para a Prova**

- **Descritores de Arquivo:**
    - `0`: stdin
    - `1`: stdout
    - `2`: stderr
- **Operadores de Redirecionamento:**
    - `>`: Redireciona stdout
    - `2>`: Redireciona stderr
    - `2>&1`: Redireciona stderr para stdout
- **`/dev/null`:** "Buraco negro" para descartar saída
- **`$?`:** Variável com código de saída do último comando

# **LFCS - Questão 15: Compilar e Instalar a partir do Código-Fonte**

### **Objetivo da Tarefa**

- **Compilação de Software:** Entender e executar o processo padrão de compilação e instalação de um programa a partir de seu código-fonte.
- **Configuração de Build:** Utilizar o script `configure` para personalizar a instalação.

A tarefa exige as seguintes ações no servidor `app-srv1`:

1. Utilizar o código-fonte do navegador `links2`, fornecido em `/tools/links-2.14.tar.bz2`.
2. Configurar o processo de instalação para que o binário principal seja instalado em `/usr/bin/links`.
3. Configurar o processo para que o suporte a IPv6 seja desabilitado.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar e Extrair o Código-Fonte**

bash

```
ssh app-srv1
cd /tools
sudo tar xjf links-2.14.tar.bz2
cd links-2.14
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Configurar o Build**

bash

```
./configure --prefix=/usr --without-ipv6
```

### **Parte 2: Compilar o Código**

bash

```
make
```

### **Parte 3: Instalar o Programa**

bash

```
sudo make install
```

---

### **Verificação Final**

bash

```
# Verifique se o programa foi instaladowhereis links

# Verifique a versão
/usr/bin/links -version

# Verifique se IPv6 está desabilitado
/usr/bin/links -lookup ip6-localhost# Deve falhar
```

---

### **Conceitos Importantes para a Prova**

- **Fluxo de Compilação:** `./configure`, `make`, `sudo make install`
- **`./configure`:** Gera Makefile customizado
- **`-prefix=/usr`:** Define diretório base de instalação
- **`-without-ipv6`:** Desabilita funcionalidade específica
- **`make`:** Executa processo de compilação
- **`make install`:** Instala arquivos compilados

# **LFCS - Questão 16: Load Balancer (Balanceador de Carga)**

### **Objetivo da Tarefa**

- **Proxy Reverso:** Usar Nginx como um proxy reverso para redirecionar tráfego para aplicações internas.
- **Balanceamento de Carga:** Configurar o Nginx para distribuir requisições entre múltiplos servidores de backend.

A tarefa exige a criação de um Load Balancer HTTP no servidor `web-srv1` que:

1. Escute na porta 8001 e redirecione todo o tráfego para `192.168.10.60:2222/special`.
2. Escute na porta 8000 e balanceie o tráfego entre `192.168.10.60:1111` e `192.168.10.60:2222` no modo Round Robin.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Verificar as Aplicações de Backend**

bash

```
# Conecte-se ao servidor web-srv1ssh web-srv1

# Teste o acesso às aplicaçõescurl localhost:1111# Saída: app1curl localhost:2222# Saída: app2curl localhost:2222/special# Saída: app2 special
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Criar o Arquivo de Configuração do Nginx**

bash

```
# Crie um novo arquivo de configuraçãosudo nano /etc/nginx/sites-available/load-balancer.conf
```

Adicione o seguinte conteúdo:

nginx

```
# Define o grupo de servidores para balanceamentoupstream backend {
    server 192.168.10.60:1111;# app1server 192.168.10.60:2222;# app2}

# Balanceamento na porta 8000server {
    listen 8000;
    server_name _;

    location / {
        proxy_pass http://backend;
    }
}

# Redirecionamento na porta 8001server {
    listen 8001;
    server_name _;

    location / {
        proxy_pass http://192.168.10.60:2222/special;
    }
}
```

### **Parte 2: Habilitar a Configuração e Recarregar o Nginx**

bash

```
# Crie link simbólico para sites-enabledsudo ln -s /etc/nginx/sites-available/load-balancer.conf /etc/nginx/sites-enabled/

# Teste a sintaxesudo nginx -t

# Recarregue o serviçosudo systemctl reload nginx
```

---

### **Verificação Final**

bash

```
# Teste o balanceamento (deve alternar entre app1 e app2)curl http://web-srv1:8000
curl http://web-srv1:8000
curl http://web-srv1:8000

# Teste o redirecionamento (sempre app2 special)curl http://web-srv1:8001
curl http://web-srv1:8001/qualquer/caminho
```

---

### **Conceitos Importantes para a Prova**

- **`upstream`:** Define grupo de servidores backend
- **`proxy_pass`:** Diretiva para redirecionar requisições
- **Round Robin:** Método de balanceamento padrão do Nginx
- **`nginx -t`:** Testa sintaxe da configuração
- **`sites-available/sites-enabled`:** Organização de configurações do Nginx

# **LFCS - Questão 17: Configuração do OpenSSH**

### **Objetivo da Tarefa**

- **Proteger o Servidor SSH:** Alterar a configuração padrão do sshd para aumentar a segurança.
- **Configuração Condicional:** Aplicar configurações específicas para determinados usuários.

A tarefa exige as seguintes ações no arquivo de configuração do sshd no servidor `data-002`:

1. Desabilitar o `X11Forwarding` globalmente.
2. Desabilitar a `PasswordAuthentication` para todos os usuários, exceto para a usuária `marta`.
3. Habilitar um Banner (usando o arquivo `/etc/ssh/sshd-banner`) que apareça quando os usuários `marta` e `cilla` tentarem se conectar.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar ao Servidor e Criar o Arquivo de Banner**

bash

```
ssh data-002
echo "Bem-vindo ao servidor seguro. Todas as atividades são monitoradas." | sudo tee /etc/ssh/sshd-banner > /dev/null
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Editar o Arquivo de Configuração**

bash

```
sudo nano /etc/ssh/sshd_config
```

Faça as seguintes alterações:

**Configurações Globais:**

bash

```
X11Forwarding no
PasswordAuthentication no
```

**Adicione no FINAL do arquivo:**

bash

```
# Sobrescritas específicas por usuário
Match User marta
    PasswordAuthentication yes
    Banner /etc/ssh/sshd-banner

Match User cilla
    Banner /etc/ssh/sshd-banner
```

### **Parte 2: Testar e Reiniciar o Serviço SSH**

bash

```
# Teste a sintaxesudo sshd -t

# Reinicie o serviçosudo systemctl restart sshd
```

---

### **Verificação Final**

bash

```
# Teste de login com 'marta' (deve mostrar banner e pedir senha)ssh marta@data-002

# Teste de login com 'cilla' (deve mostrar banner, mas negar acesso por senha)ssh cilla@data-002

# Teste de login com outro usuário (não deve mostrar banner)ssh root@data-002
```

---

### **Conceitos Importantes para a Prova**

- **`/etc/ssh/sshd_config`:** Arquivo de configuração principal do SSH
- **`Match`:** Aplica configurações específicas para usuários/grupos
- **`X11Forwarding`:** Controla tunelamento de aplicações gráficas
- **`PasswordAuthentication`:** Controla login com senha
- **`Banner`:** Exibe mensagem antes da autenticação
- **`sshd -t`:** Testa sintaxe do arquivo de configuração

# **LFCS - Questão 18: Armazenamento com LVM**

### **Objetivo da Tarefa**

- **Gerenciar Volume Groups (VG):** Reduzir um VG existente removendo um disco e criar um novo VG.
- **Gerenciar Logical Volumes (LV):** Criar um novo LV com um tamanho específico.
- **Criar Sistema de Arquivos:** Formatar um LV recém-criado.

A tarefa exige as seguintes ações de gerenciamento de LVM:

1. Reduzir o Volume Group `vol1` removendo o disco `/dev/vdh` dele.
2. Criar um novo Volume Group chamado `vol2` que utilize o disco `/dev/vdh`.
3. Criar um Logical Volume de 50M chamado `p1` dentro do `vol2`.
4. Formatar o novo volume lógico `p1` com o sistema de arquivos ext4.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Inspecionar a Configuração LVM**

bash

```
# Liste os Physical Volumessudo pvs

# Liste os Volume Groupssudo vgs

# Liste os Logical Volumessudo lvs
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Reduzir o Volume Group vol1**

bash

```
sudo vgreduce vol1 /dev/vdh
```

### **Parte 2: Criar o Volume Group vol2**

bash

```
sudo vgcreate vol2 /dev/vdh
```

### **Parte 3: Criar o Logical Volume p1**

bash

```
sudo lvcreate -L 50M -n p1 vol2
```

### **Parte 4: Formatar o Novo Logical Volume**

bash

```
sudo mkfs.ext4 /dev/vol2/p1
```

---

### **Verificação Final**

bash

```
# Verifique se /dev/vdh pertence a 'vol2'sudo pvs

# Verifique se os VGs foram configurados corretamentesudo vgs

# Verifique se o novo LV existesudo lvs

# Verifique o sistema de arquivossudo blkid /dev/vol2/p1
```

---

### **Conceitos Importantes para a Prova**

- **Hierarquia LVM:**
    - PV (Physical Volume): Disco físico
    - VG (Volume Group): Pool de storage
    - LV (Logical Volume): "Partição" virtual
- **Comandos LVM:**
    - `pvs`, `vgs`, `lvs`: Listam componentes
    - `vgreduce`: Remove PV do VG
    - `vgcreate`: Cria novo VG
    - `lvcreate`: Cria novo LV
- **Caminho do LV:** `/dev/<vg_name>/<lv_name>`

# **LFCS - Questão 19: Regex (Expressões Regulares) para Filtrar Logs**

### **Objetivo da Tarefa**

- **Filtragem de Texto:** Usar `grep` com expressões regulares para extrair linhas específicas de arquivos de log.
- **Busca e Substituição:** Usar `sed` com regex para encontrar e substituir linhas.

A tarefa exige as seguintes ações no servidor `web-srv1`:

1. No arquivo `/var/log-collector/003/nginx.log`: Extrair todas as linhas onde URLs começam com `/app/user` e que foram acessadas por browser identity `hacker-bot/1.2`. Salvar o resultado em `/var/log-collector/003/nginx.log.extracted`.
2. No arquivo `/var/log-collector/003/server.log`: Substituir todas as linhas começando com `container.web`, terminando com `24h` e contendo `Running` no meio por: `SENSITIVE LINE REMOVED`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar e Inspecionar os Arquivos**

bash

```
ssh web-srv1
cd /var/log-collector/003
head nginx.log
head server.log
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Extrair Linhas do nginx.log**

bash

```
grep -E "/app/user.*hacker-bot/1.2" nginx.log > nginx.log.extracted
```

### **Parte 2: Substituir Linhas no server.log**

bash

```
# Faça backup primeirocp server.log server.log.bak

# Substitua as linhas sensíveissed -i 's/^container\.web.*Running.*24h$/SENSITIVE LINE REMOVED/g' server.log
```

---

### **Verificação Final**

bash

```
# Verifique a extraçãowc -l nginx.log.extracted# Deve ser 27 linhas# Verifique a substituiçãogrep "SENSITIVE LINE REMOVED" server.log | wc -l# Deve ser 44 linhas
```

---

### **Conceitos Importantes para a Prova**

- **`grep -E`:** Habilita expressões regulares estendidas
- **`sed -i`:** Edita arquivo in-place
- **Regex Básica:**
    - `^`: Início da linha
    - `$`: Fim da linha
    - `.*`: Qualquer sequência de caracteres
    - `\.`: Ponto literal (escapado)
- **Padrão:** `^container\.web.*Running.*24h$`

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
