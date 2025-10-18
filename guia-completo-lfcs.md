# Guia de Estudos Completo para a Certificação LFCS
## Baseado no Simulado Killer Shell

Este documento compila as 20 questões do simulado, formatadas para facilitar o estudo e a prática em laboratório.

---
---

# LFCS - Questão 1: Informações do Kernel e Sistema

### Objetivo da Tarefa

-   **Coletar Dados do Sistema:** Usar comandos de linha para extrair informações específicas do sistema operacional.
-   **Redirecionar Saída:** Salvar os dados coletados em arquivos de texto nos locais designados.

A tarefa exige as seguintes ações no servidor `terminal`:
1.  Escrever a release do Kernel do Linux no arquivo `/opt/course/1/kernel`.
2.  Escrever o valor atual do parâmetro de rede `ip_forward` no arquivo `/opt/course/1/ip_forward`.
3.  Escrever o fuso horário (timezone) do sistema no arquivo `/opt/course/1/timezone`.

---

### 1. Preparando o Ambiente no Lab

Para esta tarefa, a única preparação necessária é garantir que o diretório onde as respostas serão salvas exista.

#### 1.1 Criar o Diretório de Destino

Use o comando `mkdir` com a flag `-p` para criar o diretório `/opt/course/1`, caso ele não exista.

```bash
sudo mkdir -p /opt/course/1
Isso garante que o caminho para salvar os arquivos de solução está pronto.

2. Resolvendo a Questão: Passo a Passo
A solução envolve executar comandos específicos para cada informação e redirecionar a saída (>) para o arquivo de destino correto.

Parte 1: Coletar a Versão do Kernel
Use o comando uname -r para obter a release do kernel e salve-a no arquivo.

Bash

# O comando 'uname -r' exibe a versão do kernel em execução.
uname -r > /opt/course/1/kernel
Parte 2: Coletar o Parâmetro ip_forward
O valor deste parâmetro do kernel pode ser lido diretamente do sistema de arquivos virtual /proc.

Bash

# O 'cat' lê o conteúdo do arquivo que representa o parâmetro do kernel.
cat /proc/sys/net/ipv4/ip_forward > /opt/course/1/ip_forward
Parte 3: Coletar o Fuso Horário
O fuso horário do sistema pode ser encontrado no arquivo /etc/timezone ou obtido com o comando date.

Bash

# Lê o arquivo que contém o nome do fuso horário configurado.
cat /etc/timezone > /opt/course/1/timezone
Verificação Final
Após executar os comandos, verifique o conteúdo de cada arquivo criado para garantir que a informação correta foi salva.

Bash

# Verifique o conteúdo do arquivo do kernel
cat /opt/course/1/kernel
# Saída esperada (exemplo): 5.15.0-69-generic [cite: 226]

# Verifique o conteúdo do arquivo ip_forward
cat /opt/course/1/ip_forward
# Saída esperada (exemplo): 1 [cite: 227]

# Verifique o conteúdo do arquivo de fuso horário
cat /opt/course/1/timezone
# Saída esperada (exemplo): UTC [cite: 228]
Conceitos Importantes para a Prova
uname -r: Comando específico para imprimir a release (versão) do kernel em execução.

/proc/sys/: Um sistema de arquivos virtual que permite visualizar e alterar parâmetros do kernel em tempo real. O arquivo net/ipv4/ip_forward controla se o encaminhamento de pacotes IP está ativado (1) ou desativado (0).


/etc/timezone: Arquivo de configuração de texto simples que contém o nome do fuso horário utilizado pelo sistema.

LFCS - Questão 2: CronJobs (Agendamento de Tarefas)
Objetivo da Tarefa
Gerenciar Tarefas Agendadas: Manipular o agendador cron tanto no nível do sistema quanto no nível do usuário.

Diferenciar Escopos: Entender a diferença de sintaxe e propósito entre o crontab do sistema (/etc/crontab) e o crontab de um usuário (crontab -e).

A tarefa exige as seguintes ações no servidor data-001:

Converter uma tarefa agendada que hoje é de sistema (/etc/crontab) para uma tarefa do usuário asset-manager.

Criar uma nova tarefa para o mesmo usuário que execute o script /home/asset-manager/clean.sh toda segunda e quinta-feira às 11:15 da manhã.

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação envolve simular o cenário inicial, criando o usuário, os scripts de exemplo e a tarefa de sistema que precisará ser migrada.

1.1 Criar Usuário e Scripts
Bash

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
1.2 Criar o CronJob de Sistema
Abra o crontab do sistema com sudo para adicionar a linha que simula a tarefa existente.

Bash

sudo nano /etc/crontab
Adicione ao final do arquivo:

Snippet de código

# Tarefa a ser migrada para o usuario asset-manager
30 20 * * * root bash /home/asset-manager/generate.sh
2. Resolvendo a Questão: Passo a Passo
A solução é dividida em duas partes: a migração da tarefa existente e a criação da nova tarefa.

Parte 1: Migrar o CronJob do Sistema para o Usuário
Bash

# Inspecione o crontab do sistema para ver a linha a ser migrada
cat /etc/crontab

# Mude para o usuário asset-manager para editar seu crontab pessoal
sudo su - asset-manager

# Abra o editor de crontab deste usuário
crontab -e
No editor, cole a tarefa, mas remova o campo de usuário (root), pois crontabs de usuário não possuem essa coluna.

Snippet de código

30 20 * * * bash /home/asset-manager/generate.sh
Salve, saia do editor e, para completar a migração, remova a linha antiga do crontab do sistema.

Bash

# Volte para seu usuário com privilégios sudo
exit

# Edite o arquivo de sistema para apagar a linha original
sudo nano /etc/crontab
Parte 2: Criar a Nova Tarefa Agendada
Adicione a segunda tarefa diretamente no crontab do usuário.

Bash

# Abra o crontab do usuário novamente (pode ser feito diretamente com sudo)
sudo crontab -u asset-manager -e
Adicione a nova linha para a tarefa que roda às 11:15 de segunda-feira (1) e quinta-feira (4).

Snippet de código

15 11 * * 1,4 bash /home/asset-manager/clean.sh
Verificação Final
Após executar os passos, liste o crontab do usuário asset-manager para confirmar que ambas as tarefas estão configuradas corretamente.

Bash

# Liste todas as tarefas agendadas para o usuário 'asset-manager'
sudo crontab -u asset-manager -l
A saída esperada deve conter as duas linhas:


30 20 * * * bash /home/asset-manager/generate.sh
15 11 * * 1,4 bash /home/asset-manager/clean.sh
Conceitos Importantes para a Prova
Crontab de Sistema (/etc/crontab):

Controlado pelo root e usado para tarefas de todo o sistema.

Possui uma coluna extra para especificar o usuário que executará o comando.

Crontab de Usuário (crontab -e):

Cada usuário tem o seu próprio, editado com crontab -e.


Não tem a coluna de usuário, pois o comando sempre roda como o dono do crontab.

Os arquivos de configuração ficam armazenados em /var/spool/cron/crontabs/.

LFCS - Questão 3: Sincronização de Horário (NTP)
Objetivo da Tarefa

Configurar Servidores NTP: Atualizar a configuração do systemd-timesyncd para usar servidores NTP específicos.

Ajustar Parâmetros: Definir intervalos de consulta e de nova tentativa de conexão.

A tarefa exige as seguintes configurações:

Definir 0.pool.ntp.org e 1.pool.ntp.org como servidores NTP principais.

Definir ntp.ubuntu.com e 0.debian.pool.ntp.org como servidores NTP de fallback (reserva).

Definir o intervalo máximo de consulta (PollIntervalMaxSec) para 1000 segundos e a tentativa de reconexão (ConnectionRetrySec) para 20 segundos.

1. Preparando o Ambiente no Lab
Para esta tarefa, não é preciso criar arquivos ou usuários. A preparação consiste em inspecionar o estado atual do serviço de sincronização de tempo para entender o ponto de partida.

1.1 Verificar o Status Atual
Use o comando timedatectl para ver o status do serviço de tempo, incluindo o fuso horário e se o NTP está ativo.

Bash

timedatectl
Isso mostrará se o serviço systemd-timesyncd está ativo e se o relógio do sistema está sincronizado.

1.2 Inspecionar a Configuração Existente
É uma boa prática verificar o arquivo de configuração atual antes de fazer alterações.

Bash

cat /etc/systemd/timesyncd.conf
2. Resolvendo a Questão: Passo a Passo
A solução envolve editar o arquivo de configuração e reiniciar o serviço para aplicar as novas diretivas.

Parte 1: Editar o Arquivo de Configuração
Use um editor de texto com privilégios de sudo para modificar o arquivo de configuração.

Bash

sudo nano /etc/systemd/timesyncd.conf
Dentro do editor, adicione ou edite as linhas na seção [Time] para que correspondam ao que foi solicitado. Muitas vezes, as linhas já existem e estão comentadas (com #); basta remover o # e ajustar os valores.

Ini, TOML

[Time]
NTP=0.pool.ntp.org 1.pool.ntp.org
FallbackNTP=ntp.ubuntu.com 0.debian.pool.ntp.org
PollIntervalMaxSec=1000
ConnectionRetrySec=20
Salve e feche o arquivo.

Parte 2: Reiniciar o Serviço
Para que as novas configurações entrem em vigor, o serviço systemd-timesyncd precisa ser reiniciado.

Bash

sudo systemctl restart systemd-timesyncd
Verificação Final
Após reiniciar, verifique o status do serviço para confirmar que ele está funcionando corretamente e sem erros.

Bash

# Verifique o status detalhado do serviço
sudo systemctl status systemd-timesyncd
A saída deve mostrar a linha Active: active (running). Além disso, nos logs de status, você deve ver uma mensagem indicando que a sincronização inicial foi feita com um dos novos servidores configurados, como, por exemplo: Initial synchronization to time server 162.159.200.123:123 (0.pool.ntp.org). 

Conceitos Importantes para a Prova
systemd-timesyncd: É o serviço do systemd responsável por sincronizar o relógio do sistema com servidores NTP remotos.


/etc/systemd/timesyncd.conf: O arquivo de configuração principal para o systemd-timesyncd.

Diretivas de Configuração:

NTP=: Define a lista de servidores NTP principais, separados por espaço.

FallbackNTP=: Define uma lista de servidores de reserva, usados caso os principais falhem.

systemctl restart <serviço>: O comando padrão para aplicar mudanças na configuração da maioria dos serviços gerenciados pelo systemd.

LFCS - Questão 4: Variáveis de Ambiente
Objetivo da Tarefa
Manipular Variáveis: Criar um script que defina e utilize variáveis de ambiente.

Entender Escopo: Demonstrar a diferença entre uma variável de shell local e uma variável exportada para processos filhos.

A tarefa exige a criação de um script em /opt/course/4/script.sh que execute as seguintes ações:

Defina uma nova variável de ambiente VARIABLE2 com o conteúdo v2, disponível apenas dentro do próprio script.

Imprima o conteúdo da variável VARIABLE2.

Defina uma nova variável de ambiente VARIABLE3 com o conteúdo ${VARIABLE1}-extended, que deve estar disponível no script e em todos os seus processos filhos.

Imprima o conteúdo da variável VARIABLE3.

1. Preparando o Ambiente no Lab
Para esta tarefa, precisamos criar o diretório e o arquivo de script. Além disso, o cenário assume que uma variável VARIABLE1 já existe, então vamos criá-la e exportá-la no nosso terminal para que o script possa acessá-la.

1.1 Criar o Diretório e o Arquivo de Script
Bash

# Crie o diretório de destino
sudo mkdir -p /opt/course/4

# Crie o arquivo de script vazio
sudo touch /opt/course/4/script.sh

# Dê permissão de execução ao script
sudo chmod +x /opt/course/4/script.sh
1.2 Simular a Variável Pré-existente
No seu terminal atual, crie e exporte VARIABLE1 para que ela esteja disponível para o script quando ele for executado.

Bash

# A variável 'VARIABLE1' já está definida no arquivo .bashrc no cenário do simulado
# Para simular, exportamos ela manualmente no nosso terminal:
export VARIABLE1="random-string"
2. Resolvendo a Questão: Passo a Passo
A solução consiste em escrever o script com a lógica correta para definir e exportar as variáveis.

Parte 1: Escrever o Script
Use um editor de texto com privilégios de sudo para adicionar o conteúdo ao script.

Bash

sudo nano /opt/course/4/script.sh
Adicione o seguinte conteúdo ao arquivo:

Bash

#!/bin/bash
# 1. Define uma variável local, disponível apenas neste script
VARIABLE2="v2"

# 2. Imprime o conteúdo da variável local
echo $VARIABLE2

# 3. Define e EXPORTA uma variável, tornando-a disponível para processos filhos
export VARIABLE3="${VARIABLE1}-extended"

# 4. Imprime o conteúdo da variável exportada
echo $VARIABLE3
Salve e feche o arquivo.

Verificação Final
Execute o script e, em seguida, verifique se as variáveis criadas estão ou não disponíveis no seu terminal (o "shell pai"), para confirmar o conceito de escopo.

Bash

# Execute o script para ver sua saída
/opt/course/4/script.sh
Saída esperada do script:

v2
random-string-extended
Bash

# Agora, tente imprimir as variáveis no seu terminal
echo $VARIABLE2
echo $VARIABLE3

# A saída para ambos os comandos acima deve ser uma linha em branco,
# pois 'VARIABLE2' era local ao script e 'VARIABLE3' foi exportada apenas
# para os processos FILHOS do script, não para o processo PAI (seu terminal).
Conceitos Importantes para a Prova
Variável Local (NOME="valor"): Existe apenas no processo (shell) onde foi criada. Não é herdada por processos filhos.


Variável Exportada (export NOME="valor"): Fica disponível para o processo onde foi criada e para todos os processos filhos que forem iniciados a partir dele.

Escopo de Variáveis: O export não afeta o processo "pai" que chamou o script. A herança de variáveis é uma via de mão única: de pai para filho.

LFCS - Questão 5: Arquivos Compactados e Compressão
Objetivo da Tarefa
Manipular Arquivos: Descompactar um arquivo .tar.bz2 e re-compactá-lo usando um algoritmo de compressão diferente (gzip).

Verificar Integridade: Garantir que o conteúdo do arquivo original e do novo arquivo seja idêntico.

A tarefa exige as seguintes ações no servidor data-001:

Usar o arquivo original /imports/import001.tar.bz2.

Criar um novo arquivo /imports/import001.tar.gz com o mesmo conteúdo, utilizando a melhor compressão gzip possível.

Para garantir a integridade, listar o conteúdo de ambos os arquivos, ordenar a lista e salvá-la em /imports/import001.tar.bz2_list e /imports/import001.tar.gz_list, respectivamente.

1. Preparando o Ambiente no Lab
Para esta tarefa, precisamos simular a existência do arquivo original no diretório /imports.

1.1 Criar o Arquivo de Exemplo
Vamos criar um diretório, alguns arquivos dentro dele e, em seguida, compactá-lo no formato .tar.bz2 para simular o ponto de partida.

Bash

# Conecte-se ao servidor (ou execute localmente)
# ssh data-001

# Crie a estrutura de diretórios e arquivos de exemplo
sudo mkdir -p /imports/source_files/dir1
sudo touch /imports/source_files/file1.txt
sudo touch /imports/source_files/dir1/file2.txt

# Crie o arquivo .tar.bz2 inicial
# -c: criar, -j: bzip2, -f: arquivo
# A flag -C permite mudar para o diretório antes de compactar, evitando que a estrutura "source_files" entre no pacote.
sudo tar cjf /imports/import001.tar.bz2 -C /imports/source_files .

# Limpe os arquivos de origem que não são mais necessários
sudo rm -rf /imports/source_files
2. Resolvendo a Questão: Passo a Passo
A abordagem mais segura é extrair o conteúdo original para um diretório temporário e, a partir dele, criar o novo arquivo compactado.

Parte 1: Extrair o Conteúdo Original
Bash

# Crie um diretório temporário para a extração
sudo mkdir /imports/temp_extract

# Extraia o conteúdo do arquivo .tar.bz2 para o diretório temporário
# -x: extrair, -j: bzip2, -f: arquivo, -C: diretório de destino
sudo tar xjf /imports/import001.tar.bz2 -C /imports/temp_extract
Parte 2: Criar o Novo Arquivo .tar.gz
Agora, use o conteúdo extraído para criar o novo arquivo com compressão gzip.

Bash

# Crie o novo arquivo .tar.gz
# -c: criar, -z: gzip, -f: arquivo
# A flag --gzip:best (ou a variável de ambiente GZIP=-9) instrui o gzip a usar a melhor compressão.
# A flag -C muda para o diretório antes de compactar os arquivos.
sudo tar czf /imports/import001.tar.gz --gzip:best -C /imports/temp_extract .
Parte 3: Limpar o Ambiente
Após criar o novo arquivo, o diretório temporário não é mais necessário.

Bash

sudo rm -rf /imports/temp_extract
Verificação Final
Para garantir que ambos os arquivos compactados contêm exatamente os mesmos arquivos e estrutura, listamos seus conteúdos, ordenamos e comparamos as listas.

Bash

# Liste o conteúdo do arquivo original, ordene e salve no arquivo de lista
# -t: listar, -j: bzip2, -f: arquivo
sudo tar tjf /imports/import001.tar.bz2 | sort > /imports/import001.tar.bz2_list

# Liste o conteúdo do novo arquivo, ordene e salve no arquivo de lista
# -t: listar, -z: gzip, -f: arquivo
sudo tar tzf /imports/import001.tar.gz | sort > /imports/import001.tar.gz_list

# Compare os dois arquivos de lista. Se não houver saída, eles são idênticos.
diff /imports/import001.tar.bz2_list /imports/import001.tar.gz_list
Conceitos Importantes para a Prova
tar: A ferramenta padrão do Linux para criar e manipular arquivos de arquivamento (archives), conhecidos como tarballs.

Operações do tar:

-c (create): Cria um novo arquivo .tar.

-x (extract): Extrai arquivos de um .tar.

-t (list): Lista o conteúdo de um .tar sem extrair.

-f (file): Especifica o nome do arquivo .tar a ser usado.

Filtros de Compressão:

-z (gzip): Filtra o arquivo através do gzip.

-j (bzip2): Filtra o arquivo através do bzip2.

-C <DIRETÓRIO>: Uma flag muito útil que instrui o tar a mudar para o <DIRETÓRIO> especificado antes de executar a operação.

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

LFCS - Questão 7: Filtro de Pacotes de Rede (Firewall)
Objetivo da Tarefa
Filtrar Tráfego: Implementar regras de firewall para controlar o tráfego de rede de entrada e saída em um servidor.

Manipular Pacotes: Usar iptables para bloquear, redirecionar e permitir tráfego com base em portas e endereços IP de origem/destino.

A tarefa exige a implementação das seguintes regras de firewall na interface eth0 do servidor data-002:

Fechar a porta 5000 para tráfego externo.

Redirecionar todo o tráfego que chega na porta 6000 para a porta local 6001.

Permitir que a porta 6002 seja acessível apenas pelo IP 192.168.10.80 (servidor data-001).

Bloquear todo o tráfego de saída para o IP 192.168.10.70 (servidor app-srv1).

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação consiste em verificar o estado atual da rede para confirmar o comportamento antes da aplicação das regras. Não há serviços para instalar, mas podemos simular pequenos "listeners" de rede para os testes.

1.1 Verificar a Conectividade Atual
Antes de aplicar qualquer regra, é uma boa prática testar a conectividade atual para confirmar que as portas estão abertas.

Bash

# De um servidor remoto (como o 'terminal'), teste o acesso às portas em data-002
curl data-002:5000
# Saída esperada: app on port 5000

curl data-002:6001
# Saída esperada: app on port 6001

curl data-002:6002
# Saída esperada: app on port 6002
1.2 Inspecionar as Regras de Firewall Existentes
Verifique se já existem regras de iptables configuradas.

Bash

# Conecte-se ao servidor onde as regras serão aplicadas
ssh data-002

# Liste as regras da tabela padrão (filter) e da tabela nat
sudo iptables -L
sudo iptables -t nat -L

# A saída deve mostrar que todas as chains (INPUT, OUTPUT, etc.) estão com a política ACCEPT e sem regras.
2. Resolvendo a Questão: Passo a Passo
A solução envolve adicionar regras (-A) às chains corretas do iptables.

Parte 1: Fechar a Porta 5000
Bash

# -A INPUT: Adiciona a regra na chain de entrada.
# -p tcp --dport 5000: Especifica o protocolo TCP e a porta de destino 5000.
# -j DROP: Ação de descartar o pacote silenciosamente.
sudo iptables -A INPUT -p tcp --dport 5000 -j DROP
Parte 2: Redirecionar a Porta 6000 para 6001
Esta operação usa a tabela de NAT (Network Address Translation).

Bash

# -t nat: Especifica que a operação é na tabela NAT.
# -A PREROUTING: Adiciona a regra na chain PREROUTING (antes da decisão de roteamento).
# -j REDIRECT --to-port 6001: Ação de redirecionar para a porta local 6001.
sudo iptables -t nat -A PREROUTING -p tcp --dport 6000 -j REDIRECT --to-port 6001
Parte 3: Restringir o Acesso à Porta 6002
A ordem das regras é crucial. Primeiro permitimos o IP específico e depois bloqueamos todo o resto para a mesma porta.

Bash

# -s 192.168.10.80: Especifica o endereço IP de origem (source).
# -j ACCEPT: Ação de aceitar o pacote.
sudo iptables -A INPUT -p tcp --dport 6002 -s 192.168.10.80 -j ACCEPT

# Esta segunda regra bloqueará qualquer outro IP que tente acessar a porta 6002
sudo iptables -A INPUT -p tcp --dport 6002 -j DROP
Parte 4: Bloquear Tráfego de Saída
Bash

# -A OUTPUT: Adiciona a regra na chain de saída.
# -d 192.168.10.70: Especifica o endereço IP de destino (destination).
sudo iptables -A OUTPUT -d 192.168.10.70 -j DROP
Verificação Final
Verifique as regras aplicadas e teste a conectividade novamente.

Bash

# No servidor data-002, liste as regras para confirmar
sudo iptables -L
sudo iptables -t nat -L

# Testes a serem executados de um servidor remoto (ex: 'terminal'):
# Teste da porta 5000 (deve falhar/timeout)
curl data-002:5000

# Teste do redirecionamento (deve retornar o conteúdo da porta 6001)
curl data-002:6000
# Saída esperada: app on port 6001

# Teste do acesso restrito (deve falhar/timeout)
curl data-002:6002

# Teste do acesso restrito a partir do servidor permitido ('data-001')
ssh data-001 "curl data-002:6002"
# Saída esperada: app on port 6002

# Teste do bloqueio de saída (dentro de 'data-002')
nc -zv app-srv1 22
# (O comando deve falhar/timeout)
Conceitos Importantes para a Prova
iptables: A ferramenta de linha de comando para configurar o firewall Netfilter do kernel Linux.

Tabelas:

filter: A tabela padrão, usada para permitir ou negar pacotes. Contém as chains INPUT, OUTPUT, FORWARD.

nat: Usada para tradução de endereços de rede. Contém as chains PREROUTING, POSTROUTING, OUTPUT.

Chains: Sequências de regras que são aplicadas aos pacotes.

Ações (-j):

ACCEPT: Permite a passagem do pacote.

DROP: Descarta o pacote silenciosamente.

REDIRECT: Redireciona um pacote para uma porta local (usado na chain PREROUTING da tabela nat).

Parâmetros:

-p: Protocolo (ex: tcp, udp).

--dport: Porta de destino.

-s: Endereço de origem.

-d: Endereço de destino.

LFCS - Questão 8: Gerenciamento de Discos
Objetivo da Tarefa
Formatar e Montar Discos: Criar um novo sistema de arquivos em um disco, montá-lo e criar um arquivo.

Gerenciar Espaço em Disco: Identificar o disco com maior uso e liberar espaço nele.

Lidar com Discos Ocupados: Identificar um processo que está utilizando um ponto de montagem, finalizá-lo e desmontar o disco.

A tarefa exige a execução das seguintes ações:

Formatar o disco /dev/vdb com ext4, montá-lo em /mnt/backup-black e criar o arquivo /mnt/backup-black/completed.

Verificar qual dos discos, /dev/vdc ou /dev/vdd, tem maior uso de armazenamento e, em seguida, esvaziar a pasta de lixo (.trash) nele.

Identificar qual dos processos, dark-matter-v1 ou dark-matter-v2, consome mais memória, descobrir em qual disco o executável do processo está localizado e, em seguida, desmontar esse disco.

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação consiste em inspecionar os discos e processos existentes para entender o cenário inicial.

1.1 Inspecionar os Discos Existentes
Use comandos como lsblk -f ou df -h para obter uma visão geral dos discos, seus sistemas de arquivos e pontos de montagem.

Bash

# Lista os dispositivos de bloco com informações de sistema de arquivos e montagem
lsblk -f

# Mostra o uso de espaço em disco de forma legível
df -h
Isso permitirá que você identifique os discos /dev/vdb, /dev/vdc, /dev/vdd e seus estados atuais.

1.2 Inspecionar os Processos em Execução
Verifique os processos dark-matter para analisar seu consumo de memória.

Bash

# Lista os processos e filtra pelos que contêm "dark-matter"
ps aux | grep dark-matter
Observe as colunas %MEM (uso de memória RAM) e VSZ (memória virtual) para determinar qual processo consome mais recursos.

2. Resolvendo a Questão: Passo a Passo
Execute as tarefas de gerenciamento de disco conforme solicitado.

Parte 1: Formatar e Montar /dev/vdb
Bash

# Cria um sistema de arquivos do tipo ext4 no disco /dev/vdb
sudo mkfs.ext4 /dev/vdb

# Cria o diretório que servirá como ponto de montagem
sudo mkdir -p /mnt/backup-black

# Monta o disco no diretório criado
sudo mount /dev/vdb /mnt/backup-black

# Cria o arquivo vazio para indicar a conclusão
sudo touch /mnt/backup-black/completed
Parte 2: Limpar o Disco Mais Cheio
Bash

# Use df -h para comparar o uso (coluna Use%) de /dev/vdc e /dev/vdd
df -h
Com base na saída, identifique o ponto de montagem do disco mais cheio (no simulado, é /dev/vdc montado em /mnt/backup001).

Bash

# Esvazie a pasta de lixo no ponto de montagem do disco mais cheio
sudo rm -rf /mnt/backup001/.trash/*
Parte 3: Desmontar o Disco em Uso
Bash

# Identifique o processo com maior consumo de memória (VSZ) usando ps aux
ps aux | grep dark-matter
O simulado identifica dark-matter-v2 como o processo que consome mais memória e que seu executável está em /mnt/app-4e9d7e1e/dark-matter-v2.

Bash

# Tente desmontar o disco. A operação falhará porque o processo está em execução.
sudo umount /mnt/app-4e9d7e1e
# Saída esperada: umount: /mnt/app-4e9d7e1e: target is busy.

# Use lsof para confirmar qual processo está usando o ponto de montagem
sudo lsof | grep /mnt/app-4e9d7e1e
# Ou use o PID identificado anteriormente com o comando ps.

# Finalize o processo infrator (substitua <PID> pelo ID do processo)
sudo kill <PID_do_dark-matter-v2>

# Agora, o comando para desmontar o disco funcionará
sudo umount /mnt/app-4e9d7e1e
Verificação Final
Verifique se cada etapa foi concluída com sucesso.

Bash

# Verifique se o novo disco está montado e o arquivo existe
df -h | grep /mnt/backup-black
ls /mnt/backup-black

# Verifique se o espaço em disco do /dev/vdc (ou /mnt/backup001) foi liberado
df -h

# Verifique se o disco /dev/vdf (ou /mnt/app-4e9d7e1e) não está mais montado
df -h | grep /mnt/app-4e9d7e1e
# (Este comando não deve retornar nenhuma saída)
Conceitos Importantes para a Prova
mkfs.ext4: Comando para criar um sistema de arquivos do tipo ext4 em um dispositivo de bloco.

mount / umount: Comandos para anexar (montar) e desanexar (desmontar) sistemas de arquivos à árvore de diretórios do sistema.

df -h: Exibe o uso de espaço em disco de todos os sistemas de arquivos montados em formato legível para humanos.

ps aux: Lista todos os processos em execução no sistema, fornecendo detalhes como PID, uso de CPU, uso de memória (VSZ, RSS), etc.


lsof: Utilitário que significa "List Open Files" (Listar Arquivos Abertos) e é usado para ver quais arquivos estão sendo usados por quais processos. É extremamente útil para diagnosticar problemas de "target is busy".

kill: Comando para enviar um sinal a um processo (por padrão, o sinal de término SIGTERM).

LFCS - Questão 9: Encontrar Arquivos com Propriedades e Executar Ações
Objetivo da Tarefa
Busca Avançada de Arquivos: Utilizar o comando find com diferentes critérios (data, tamanho, permissão) para localizar arquivos específicos.

Executar Ações em Lote: Executar comandos (rm, mv) nos arquivos encontrados para automatizar a organização e limpeza de um diretório.

A tarefa exige a execução das seguintes ações no diretório /var/backup/backup-015 do servidor data-001:

Deletar todos os arquivos modificados antes de 01/01/2020.

Mover todos os arquivos restantes que são menores que 3KiB para o subdiretório /var/backup/backup-015/small/.

Mover todos os arquivos restantes que são maiores que 10KiB para o subdiretório /var/backup/backup-015/large/.

Mover todos os arquivos restantes que têm permissão 777 para o subdiretório /var/backup/backup-015/compromised/.

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação consiste em conectar-se ao servidor correto, navegar até o diretório de trabalho e criar os subdiretórios que serão usados como destino para os arquivos movidos.

1.1 Conectar e Criar Diretórios de Destino
Bash

# Conecte-se ao servidor data-001
ssh data-001

# Navegue até o diretório de backup
cd /var/backup/backup-015

# Crie os subdiretórios que receberão os arquivos movidos
sudo mkdir small large compromised
1.2 Inspecionar o Diretório
Antes de fazer as alterações, é uma boa prática inspecionar o conteúdo do diretório.

Bash

# Conte o número total de arquivos para ter uma referência inicial
ls | wc -l
2. Resolvendo a Questão: Passo a Passo
A solução utiliza o comando find com diferentes predicados e a ação -exec para manipular os arquivos encontrados.

Parte 1: Deletar Arquivos Antigos
Bash

# '! -newermt "DATE"': Encontra arquivos que NÃO são mais novos que a data (ou seja, são mais antigos).
# -maxdepth 1: Limita a busca ao diretório atual, sem entrar nos subdiretórios recém-criados.
# -type f: Assegura que estamos lidando apenas com arquivos.
# -exec rm {} \;: Executa o comando 'rm' para cada arquivo ({}) encontrado.
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -exec rm {} \;
Parte 2: Mover Arquivos Pequenos (< 3KiB)
Bash

# -size -3k: Encontra arquivos com tamanho MENOR que 3 kilobytes.
# -exec mv {} ./small/ \;: Executa o comando 'mv' para mover cada arquivo para o diretório 'small'.
find . -maxdepth 1 -type f -size -3k -exec mv {} ./small/ \;
Parte 3: Mover Arquivos Grandes (> 10KiB)
Bash

# -size +10k: Encontra arquivos com tamanho MAIOR que 10 kilobytes.
find . -maxdepth 1 -type f -size +10k -exec mv {} ./large/ \;
Parte 4: Mover Arquivos com Permissão 777
Bash

# -perm 777: Encontra arquivos que têm exatamente a permissão 777.
find . -maxdepth 1 -type f -perm 777 -exec mv {} ./compromised/ \;
Verificação Final
Após executar todos os comandos, conte os arquivos em cada diretório para verificar se as operações foram bem-sucedidas.

Bash

# Conte os arquivos restantes no diretório principal
ls -l | wc -l

# Conte os arquivos movidos para cada subdiretório
ls small/ | wc -l
ls large/ | wc -l
ls compromised/ | wc -l
Os números devem corresponder às contagens de arquivos encontrados em cada etapa da resolução.

Conceitos Importantes para a Prova
find: A ferramenta principal para localizar arquivos com base em uma vasta gama de critérios.

Predicados do find:

-maxdepth 1: Essencial para evitar que find atue recursivamente dentro dos subdiretórios que você está usando como destino.

-type f: Filtra a busca para incluir apenas arquivos regulares, ignorando diretórios, links, etc.

! -newermt "DATE": Combinação poderosa para encontrar arquivos por data. O ! nega a condição, resultando em "mais antigo que".

-size [-|+]N[c|k|M|G]: Filtra por tamanho. - para "menor que", + para "maior que". A unidade (k, M, etc.) é importante.

-perm MODE: Filtra por permissões de arquivo.

Ação -exec:

-exec COMANDO {} \;: Executa o COMANDO uma vez para cada arquivo encontrado. O {} é substituído pelo nome do arquivo. O \; é necessário para terminar o comando.

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
sudo mkdir -p /app-srv1/data-export

# Crie o diretório que será compartilhado via NFS e um arquivo de teste dentro dele
sudo mkdir -p /nfs/share
echo "Arquivo de teste NFS" | sudo tee /nfs/share/teste.txt > /dev/null
1.2 Preparação do Servidor app-srv1
Bash

# Conecte-se ao servidor app-srv1
ssh app-srv1

# Crie o diretório que será o ponto de montagem para o NFS
sudo mkdir -p /nfs/terminal/share

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
sudo sshfs -o allow_other,rw app-srv1:/data-export /app-srv1/data-export
Parte 2: Configurar o Servidor NFS (no servidor terminal)
Bash

# Edite o arquivo /etc/exports para definir os compartilhamentos NFS.
sudo nano /etc/exports
Adicione a seguinte linha ao final do arquivo para compartilhar o diretório /nfs/share com a rede especificada em modo somente leitura (ro):

/nfs/share 192.168.10.0/24(ro,sync,no_subtree_check)
Salve, feche o editor e aplique as alterações.

Bash

# Recarregue as configurações de exportação do NFS sem reiniciar o serviço.
# -r: re-exportar, -a: todos os diretórios em /etc/exports.
sudo exportfs -ra
Parte 3: Configurar o Cliente NFS (no servidor app-srv1)
Bash

# Conecte-se novamente ao servidor app-srv1.
ssh app-srv1

# Monte o compartilhamento NFS do servidor 'terminal' no diretório local criado anteriormente.
sudo mount terminal:/nfs/share /nfs/terminal/share
Verificação Final
Verifique se cada montagem foi bem-sucedida e se as permissões estão corretas.

Bash

# No servidor 'terminal', verifique a montagem SSHFS.
ls /app-srv1/data-export
# Deve listar 'teste_sshfs.txt'.
touch /app-srv1/data-export/novo_arquivo.txt
# O comando deve funcionar, confirmando a permissão de escrita.

# No servidor 'terminal', verifique se o compartilhamento NFS está ativo.
showmount -e
# A saída deve listar o export /nfs/share para 192.168.10.0/24.

# No servidor 'app-srv1', verifique a montagem NFS.
ls /nfs/terminal/share
# Deve listar 'teste.txt'.
touch /nfs/terminal/share/novo_arquivo.txt
# O comando deve falhar com a mensagem "Read-only file system", confirmando a permissão de somente leitura.
Conceitos Importantes para a Prova
SSHFS: Um sistema de arquivos baseado no FUSE (Filesystem in Userspace) que permite montar um diretório remoto sobre uma conexão SSH. É uma forma simples e segura de acessar arquivos remotamente.

NFS (Network File System): Um protocolo de sistema de arquivos distribuído que permite a um usuário em um computador cliente acessar arquivos em uma rede como se estivessem no armazenamento local.


/etc/exports: O arquivo de configuração principal do servidor NFS. Ele define quais diretórios são compartilhados e quais clientes (hosts, redes) têm permissão para acessá-los, juntamente com as opções de acesso (ex: ro para somente leitura, rw para leitura/escrita).


exportfs -ra: Comando para atualizar a tabela de compartilhamentos do servidor NFS com base no que está configurado em /etc/exports, sem a necessidade de reiniciar o serviço.

mount: Comando padrão do Linux para montar sistemas de arquivos, incluindo os de rede como NFS.

LFCS - Questão 11: Gerenciamento de Docker
Objetivo da Tarefa
Gerenciar Ciclo de Vida: Parar um contêiner em execução.

Inspecionar Contêineres: Extrair informações detalhadas, como configurações de rede e volumes, de um contêiner.

Criar e Executar Contêineres: Iniciar um novo contêiner a partir de uma imagem, aplicando configurações específicas de nome, recursos e rede.

A tarefa exige a execução das seguintes ações:

Parar o contêiner Docker chamado frontend_v1.

Obter informações do contêiner frontend_v2:

Escrever seu endereço IP no arquivo /opt/course/11/ip-address.

Escrever o diretório de destino do seu volume montado em /opt/course/11/mount-destination.

Iniciar um novo contêiner em modo detached com as seguintes especificações:


Nome: frontend_v3 


Imagem: nginx:alpine 


Limite de Memória: 30m (30 Megabytes) 


Mapeamento de Porta: 1234 (host) para 80 (contêiner).

1. Preparando o Ambiente no Lab
A preparação consiste em verificar quais contêineres já estão em execução para entender o estado inicial do ambiente.

1.1 Listar Contêineres Atuais
Use o comando docker ps para listar os contêineres que estão rodando.

Bash

# Lista os contêineres atualmente em execução
sudo docker ps
A saída deve mostrar os contêineres frontend_v1 e frontend_v2 em estado "Up".

1.2 Criar o Diretório de Destino
Crie o diretório onde os arquivos de informação serão salvos.

Bash

sudo mkdir -p /opt/course/11
2. Resolvendo a Questão: Passo a Passo
A solução envolve usar os comandos docker stop, docker inspect, e docker run com as opções corretas.

Parte 1: Parar o Contêiner frontend_v1
Use o comando docker stop seguido pelo nome ou ID do contêiner.

Bash

# Para o contêiner chamado 'frontend_v1'
sudo docker stop frontend_v1
Parte 2: Inspecionar o Contêiner frontend_v2
O comando docker inspect retorna um JSON detalhado. Usaremos a flag -f (format) para extrair apenas as informações que precisamos.

Bash

# Extrai o endereço IP da seção de redes e salva no arquivo
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' frontend_v2 > /opt/course/11/ip-address

# Extrai o caminho de destino da seção de montagens (Mounts) e salva no arquivo
sudo docker inspect -f '{{range .Mounts}}{{.Destination}}{{end}}' frontend_v2 > /opt/course/11/mount-destination
Parte 3: Iniciar o Novo Contêiner frontend_v3
Use o comando docker run com as flags especificadas.

Bash

# -d: Run container in background (detached mode)
# --name: Assign a name to the container
# --memory: Memory limit
# -p: Publish a container's port(s) to the host (host_port:container_port)
sudo docker run -d --name frontend_v3 --memory 30m -p 1234:80 nginx:alpine
Verificação Final
Verifique se cada etapa foi concluída com sucesso.

Bash

# Verifique que 'frontend_v1' está parado (deve aparecer com status 'Exited')
# A flag '-a' mostra todos os contêineres, inclusive os parados.
sudo docker ps -a

# Verifique o conteúdo dos arquivos de informação criados
cat /opt/course/11/ip-address
# Saída esperada (exemplo): 172.17.0.3
cat /opt/course/11/mount-destination
# Saída esperada: /srv

# Verifique se o novo contêiner 'frontend_v3' está em execução
sudo docker ps

# Teste o acesso à porta mapeada do novo contêiner
curl localhost:1234
# A saída deve ser o HTML da página de boas-vindas do Nginx.
Conceitos Importantes para a Prova
docker ps: Lista os contêineres em execução. A flag -a mostra todos, incluindo os parados.


docker stop <nome_container>: Para um contêiner em execução de forma segura (enviando um sinal SIGTERM).


docker inspect <nome_container>: Fornece um JSON detalhado com todas as informações de configuração de um contêiner.

docker run [OPTIONS] IMAGE: O comando principal para criar e iniciar um novo contêiner.


-d ou --detach: Executa o contêiner em segundo plano.


--name: Atribui um nome ao contêiner.

--memory: Define um limite de memória RAM.


-p ou --publish: Mapeia uma porta do host para uma porta do contêiner.

LFCS - Questão 12: Fluxo de Trabalho com Git
Objetivo da Tarefa
Gerenciar Repositório: Clonar um repositório Git.

Trabalhar com Branches: Inspecionar o conteúdo de diferentes branches, identificar a correta com base em um critério e mesclá-la (merge) na branch principal.

Versionar Alterações: Criar um novo diretório, garantir que ele seja versionado pelo Git e salvar as alterações com um commit específico.

A tarefa exige a execução das seguintes ações:

Clonar o repositório /repositories/auto-verifier para o diretório /home/candidate/repositories/auto-verifier.

Dentre as branches dev4, dev5 e dev6, encontrar aquela em que o arquivo config.yaml contém a linha user_registration_level: open.

Fazer o merge apenas da branch encontrada no passo anterior para a branch main.

Na branch main, criar um novo diretório chamado Logs e, dentro dele, um arquivo oculto e vazio chamado .keep.

Fazer o commit da alteração com a mensagem "added log directory".

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação consiste em garantir que o Git está instalado e que o repositório de origem (/repositories/auto-verifier) existe para ser clonado. A primeira etapa da resolução é, na verdade, a clonagem que prepara o ambiente de trabalho.

2. Resolvendo a Questão: Passo a Passo
A solução envolve uma sequência de comandos Git para clonar, inspecionar, mesclar e commitar as alterações.

Parte 1: Clonar o Repositório
Bash

# Clone o repositório de origem para o destino especificado
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier

# Navegue para o diretório do repositório recém-clonado
cd /home/candidate/repositories/auto-verifier
Parte 2: Encontrar e Mesclar a Branch Correta
Vamos inspecionar cada uma das branches dev para encontrar a que corresponde ao critério.

Bash

# Liste todas as branches disponíveis (locais e remotas)
git branch -a

# Mude para a branch dev4 e verifique o arquivo
git checkout dev4
grep "user_registration_level" config.yaml
# (Saída: closed)

# Mude para a branch dev5 e verifique o arquivo
git checkout dev5
grep "user_registration_level" config.yaml
# (Saída: open) -> ENCONTRAMOS!

# Voltar para a branch main e fazer o merge
git checkout main
git merge dev5
Parte 3: Criar o Novo Diretório e o Arquivo .keep
O Git não versiona diretórios vazios. Por isso, criamos um arquivo .keep (uma convenção comum) para forçar o Git a rastrear o diretório.

Bash

# Crie o novo diretório
mkdir Logs

# Crie o arquivo oculto e vazio dentro dele
touch Logs/.keep
Parte 4: Fazer o Commit da Alteração
Adicione o novo diretório ao "stage" e, em seguida, faça o commit com a mensagem solicitada.

Bash

# Adicione o diretório 'Logs' (e o arquivo .keep dentro dele) para ser versionado
git add Logs

# Faça o commit com a mensagem exata
git commit -m "added log directory"
Verificação Final
Verifique se cada etapa foi concluída com sucesso.

Bash

# Verifique se a alteração do merge está presente na branch 'main'
grep "user_registration_level" config.yaml
# Saída esperada: user_registration_level: open

# Verifique o status do git; deve mostrar que a árvore está limpa
git status

# Verifique o histórico de commits para ver sua última alteração
# A flag -1 mostra apenas o commit mais recente
git log -1
# A saída deve mostrar seu commit com a mensagem "added log directory".
Conceitos Importantes para a Prova
git clone: Cria uma cópia local de um repositório remoto ou local.

git branch -a: Lista todas as branches, tanto as locais quanto as remotas (remotes/...).

git checkout <branch>: Muda o seu "ambiente de trabalho" (HEAD) para a branch especificada.

git merge <branch>: Traz as alterações da <branch> especificada para a branch em que você está atualmente.


Rastreamento de Diretórios: O Git não versiona diretórios vazios, por isso a prática de adicionar um arquivo .keep.

git add <arquivo/diretório>: Adiciona alterações à "área de preparação" (staging area), marcando-as para serem incluídas no próximo commit.

git commit -m "mensagem": Salva as alterações da staging area permanentemente no histórico do repositório com uma mensagem descritiva.

LFCS - Questão 13: Segurança de Processos em Tempo de Execução
Objetivo da Tarefa
Análise de Processos: Inspecionar processos em execução em tempo real para identificar atividades suspeitas.

Uso de Ferramientas de Diagnóstico: Utilizar a ferramenta strace para monitorar as chamadas de sistema (syscalls) feitas por um processo.

Ação de Remediação: Finalizar um processo malicioso e remover seu executável do sistema.

A tarefa exige a execução das seguintes ações no servidor web-srv1:

Investigar os três processos em execução: collector1, collector2, e collector3.

Identificar qual(is) deles está(ão) executando a chamada de sistema (syscall) proibida kill.

Para o(s) processo(s) infrator(es), finalizar sua execução e apagar o arquivo executável correspondente.

1. Preparando o Ambiente no Lab
A preparação para esta tarefa consiste em conectar-se ao servidor e identificar os processos alvo e seus respectivos PIDs (Process IDs), que são necessários para a análise com strace.

1.1 Conectar ao Servidor e Listar os Processos
Bash

# Conecte-se ao servidor web-srv1
ssh web-srv1

# Liste os processos em execução e filtre por "collector" para encontrar seus PIDs
ps aux | grep collector
A saída mostrará os três processos e seus PIDs. Anote os PIDs de collector1, collector2 e collector3, pois eles serão usados na próxima etapa.

Exemplo de saída:

root      3611  0.0  0.0 101924   624 ?        Sl   13:23   0:00 /bin/collector1
root      3612  0.0  0.0 101916   612 ?        Sl   13:23   0:00 /bin/collector2
root      3613  0.0  0.0 101928   616 ?        Sl   13:23   0:00 /bin/collector3
2. Resolvendo a Questão: Passo a Passo
A solução envolve usar strace para monitorar cada processo individualmente, identificar o infrator e, em seguida, tomar a ação de remediação.

Parte 1: Inspecionar os Processos com strace
Execute strace para cada PID que você anotou. Você precisará observar a saída por alguns segundos para cada um, procurando pela chamada de sistema kill.

Bash

# Inspecione o primeiro processo (substitua <PID_collector1> pelo ID real)
# Pressione Ctrl+C para parar a análise após alguns segundos.
sudo strace -p <PID_collector1>
# (Nenhuma chamada 'kill' deve aparecer)

# Inspecione o segundo processo
sudo strace -p <PID_collector2>
# A saída deve mostrar repetidamente a chamada 'kill', como: kill(666, SIGTERM)

# Inspecione o terceiro processo para ter certeza
sudo strace -p <PID_collector3>
# (Nenhuma chamada 'kill' deve aparecer)
A análise revela que collector2 é o processo infrator.

Parte 2: Finalizar o Processo e Remover o Executável
Agora que o processo malicioso foi identificado, use o comando kill para finalizá-lo e o comando rm para remover seu binário.

Bash

# Use o PID do collector2 que você identificou
sudo kill <PID_collector2>

# O caminho do executável foi mostrado na saída do comando 'ps aux'
sudo rm /bin/collector2
Verificação Final
Verifique se o processo foi realmente finalizado e se o arquivo executável foi removido do sistema.

Bash

# Procure pelo processo novamente. O comando não deve retornar o processo 'collector2'.
ps aux | grep collector2

# Tente listar o arquivo executável. Você deve receber um erro.
ls /bin/collector2
# Saída esperada: ls: cannot access '/bin/collector2': No such file or directory
Conceitos Importantes para a Prova
ps aux: Um comando fundamental para listar todos os processos em execução no sistema (a=todos os usuários, u=formato de usuário, x=incluir processos sem terminal).


strace: Uma poderosa ferramenta de depuração que rastreia as chamadas de sistema (syscalls) e sinais de um processo. É essencial para entender o que um programa está fazendo "por baixo dos panos".


-p <PID>: Anexa o strace a um processo já em execução, especificado pelo seu PID.

Syscall (Chamada de Sistema): A interface programática através da qual um programa solicita um serviço do kernel do sistema operacional. kill é a syscall usada para enviar sinais a outros processos.

kill <PID>: O comando de shell para enviar um sinal a um processo. Por padrão, ele envia o SIGTERM, que solicita que o processo termine de forma organizada.

rm: O comando padrão para remover arquivos.

LFCS - Questão 14: Redirecionamento de Saída
Objetivo da Tarefa
Entender Streams de Saída: Diferenciar e manipular os canais de saída padrão (stdout) e de erro padrão (stderr).

Usar Operadores de Redirecionamento: Utilizar os operadores do shell (>, 2>, 2>&1) para controlar para onde a saída de um programa é enviada.

Capturar Códigos de Saída: Salvar o código de status de um programa após sua execução.

A tarefa exige a execução das seguintes ações com o programa /bin/output-generator no servidor app-srv1:

Executar o programa e redirecionar toda a sua stdout para o arquivo /var/output-generator/1.out.

Executar o programa e redirecionar toda a sua stderr para o arquivo /var/output-generator/2.out.

Executar o programa e redirecionar tanto a stdout quanto a stderr para o mesmo arquivo, /var/output-generator/3.out.

Executar o programa e escrever seu código de saída numérico no arquivo /var/output-generator/4.out.

1. Preparando o Ambiente no Lab
A preparação envolve conectar-se ao servidor, criar o diretório de destino e, opcionalmente, executar o programa uma vez para observar seu comportamento padrão.

1.1 Conectar ao Servidor e Criar Diretório
Bash

# Conecte-se ao servidor app-srv1
ssh app-srv1

# Crie o diretório que armazenará os arquivos de saída
sudo mkdir -p /var/output-generator
1.2 Inspecionar o Comportamento do Programa
Execute o programa sem redirecionamento para ver como ele mistura a saída padrão e a de erro na tela.

Bash

# Execute o programa
/bin/output-generator
Você notará que ele imprime várias linhas na tela. O desafio é separar essas saídas.

2. Resolvendo a Questão: Passo a Passo
A solução envolve a execução do programa quatro vezes, cada uma com diferentes operadores de redirecionamento.

Parte 1: Redirecionar stdout (Saída Padrão)
O operador > por padrão redireciona o descritor de arquivo 1 (stdout).

Bash

# O 'stderr' ainda aparecerá no terminal, mas o 'stdout' será salvo no arquivo.
/bin/output-generator > /var/output-generator/1.out
Parte 2: Redirecionar stderr (Saída de Erro)
Para redirecionar a saída de erro, especificamos seu descritor de arquivo, que é o 2.

Bash

# O 'stdout' ainda aparecerá no terminal, mas o 'stderr' será salvo no arquivo.
/bin/output-generator 2> /var/output-generator/2.out
Parte 3: Redirecionar stdout e stderr
Para enviar ambas as saídas para o mesmo local, redirecionamos stdout primeiro e depois redirecionamos stderr para o mesmo destino de stdout (2>&1).

Bash

# Nada aparecerá no terminal, pois ambas as saídas serão salvas no arquivo.
/bin/output-generator > /var/output-generator/3.out 2>&1
Parte 4: Capturar o Código de Saída
O código de saída de um comando fica armazenado na variável especial $? imediatamente após sua execução.

Bash

# Execute o programa, descartando toda a sua saída para não poluir a tela.
/bin/output-generator > /dev/null 2>&1

# IMEDIATAMENTE após a execução, capture o valor de '$?' e salve-o no arquivo.
echo $? > /var/output-generator/4.out
Verificação Final
Verifique o conteúdo dos arquivos criados para confirmar que as operações foram bem-sucedidas.

Bash

# Conte as linhas em cada arquivo de log
wc -l /var/output-generator/1.out
# Saída esperada (exemplo): 20342
wc -l /var/output-generator/2.out
# Saída esperada (exemplo): 12336
wc -l /var/output-generator/3.out
# Saída esperada (exemplo): 32678

# Exiba o conteúdo do arquivo de código de saída
cat /var/output-generator/4.out
# Saída esperada: 123
Conceitos Importantes para a Prova
Descritores de Arquivo (File Descriptors): O shell gerencia as entradas e saídas de um programa através de canais numerados. Os mais importantes são:

0: stdin (entrada padrão)

1: stdout (saída padrão)

2: stderr (saída de erro padrão)

Operadores de Redirecionamento:

>: Redireciona stdout. É um atalho para 1>.

2>: Redireciona stderr.

2>&1: Redireciona stderr (canal 2) para o mesmo destino que stdout (canal 1). A ordem importa.

/dev/null: Um "buraco negro" virtual. Qualquer coisa redirecionada para cá é descartada. É útil para silenciar a saída de um comando.


$?: Uma variável especial do shell que contém o código de saída do último comando executado. Um valor 0 convencionalmente significa sucesso, enquanto qualquer valor diferente de 0 indica algum tipo de erro.

LFCS - Questão 15: Compilar e Instalar a partir do Código-Fonte
Objetivo da Tarefa
Compilação de Software: Entender e executar o processo padrão de compilação e instalação de um programa a partir de seu código-fonte (tarball).

Configuração de Build: Utilizar o script configure para personalizar a instalação, definindo o local dos binários e desabilitando funcionalidades.

A tarefa exige a execução das seguintes ações no servidor app-srv1:

Utilizar o código-fonte do navegador links2, fornecido em /tools/links-2.14.tar.bz2.

Configurar o processo de instalação para que o binário principal seja instalado em /usr/bin/links.

Configurar o processo para que o suporte a IPv6 seja desabilitado.

1. Preparando o Ambiente no Lab
A preparação envolve conectar-se ao servidor, navegar até o diretório que contém o código-fonte e extrair o arquivo compactado.

1.1 Conectar e Extrair o Código-Fonte
Bash

# Conecte-se ao servidor app-srv1
ssh app-srv1

# Navegue até o diretório onde o código-fonte está localizado
cd /tools

# Extraia o arquivo .tar.bz2
# -x: extrair, -j: filtro bzip2, -f: arquivo
sudo tar xjf links-2.14.tar.bz2

# Entre no diretório recém-criado com o código-fonte
cd links-2.14
2. Resolvendo a Questão: Passo a Passo
A solução segue o fluxo de compilação padrão do Linux: configure, make, make install.

Parte 1: Configurar o Build (configure)
Antes de compilar, precisamos gerar um Makefile customizado com as opções da nossa instalação. O script configure é responsável por isso.

Bash

# É uma boa prática explorar as opções disponíveis com --help
./configure --help

# Execute o script de configuração com as opções solicitadas:
# --prefix=/usr: Define o diretório base da instalação como /usr.
#                Isso fará com que os binários sejam instalados em /usr/bin.
# --without-ipv6: Desabilita a compilação com suporte a IPv6.
./configure --prefix=/usr --without-ipv6
O script irá verificar as dependências do sistema e criar um Makefile com base nas opções fornecidas.

Parte 2: Compilar o Código (make)
O comando make lê o Makefile gerado na etapa anterior e executa os comandos de compilação para transformar o código-fonte em binários executáveis.

Bash

# Este processo pode levar alguns minutos
make
Parte 3: Instalar o Programa (make install)
Após a compilação bem-sucedida, o comando make install copia os arquivos compilados (binários, páginas de manual, etc.) para os diretórios corretos do sistema, conforme definido pelo --prefix. Esta ação requer privilégios de sudo.

Bash

sudo make install
Verificação Final
Verifique se o programa foi instalado corretamente e com as configurações especificadas.

Bash

# Verifique se o binário está no local correto
whereis links
# Saída esperada: links: /usr/bin/links ...

# Verifique a versão do programa para confirmar a instalação
/usr/bin/links -version
# Saída esperada: Links 2.14

# Verifique se o suporte a IPv6 foi realmente desabilitado
# Este comando deve falhar, pois não conseguirá resolver um host IPv6
/usr/bin/links -lookup ip6-localhost
# Saída esperada: error: host not found
Conceitos Importantes para a Prova
Fluxo de Compilação Padrão: A sequência ./configure, make, sudo make install é o método tradicional para compilar e instalar software a partir do código-fonte na maioria dos projetos de código aberto.

./configure: Um script que analisa o ambiente do sistema (bibliotecas, compiladores) e gera um Makefile otimizado. É nesta etapa que se personaliza a instalação.

--prefix=<caminho>: Uma das opções mais importantes, define o diretório base de instalação. O padrão costuma ser /usr/local. Mudar para /usr integra o programa de forma mais nativa ao sistema.

make: A ferramenta que orquestra o processo de compilação, lendo as instruções do Makefile.

make install: A regra dentro do Makefile que copia os arquivos compilados para os diretórios finais do sistema. Quase sempre requer sudo.

LFCS - Questão 16: Load Balancer (Balanceador de Carga)
Objetivo da Tarefa
Proxy Reverso: Usar Nginx como um proxy reverso para redirecionar tráfego para aplicações internas.

Balanceamento de Carga: Configurar o Nginx para distribuir requisições entre múltiplos servidores de backend.

A tarefa exige a criação de um Load Balancer HTTP no servidor web-srv1  que:

Escute na porta 8001 e redirecione todo o tráfego para 192.168.10.60:2222/special.

Escute na porta 8000 e balanceie o tráfego entre 192.168.10.60:1111 e 192.168.10.60:2222 no modo Round Robin.

1. Preparando o Ambiente no Lab
A preparação envolve conectar-se ao servidor web-srv1 e verificar se as aplicações de backend estão respondendo nas portas corretas.

1.1 Verificar as Aplicações de Backend
Bash

# Conecte-se ao servidor web-srv1
ssh web-srv1

# Teste o acesso às aplicações
curl localhost:1111
# Saída esperada: app1
curl localhost:2222
# Saída esperada: app2
curl localhost:2222/special
# Saída esperada: app2 special
2. Resolvendo a Questão: Passo a Passo
A solução envolve criar um novo arquivo de configuração para o Nginx com as diretivas de upstream e proxy_pass.

Parte 1: Criar o Arquivo de Configuração do Nginx
Bash

# Crie um novo arquivo de configuração no diretório 'sites-available'
sudo nano /etc/nginx/sites-available/load-balancer.conf
Adicione o seguinte conteúdo ao arquivo:

Nginx

# Define o grupo de servidores para o balanceamento (backend)
upstream backend {
    # Por padrão, o método é Round Robin
    server 192.168.10.60:1111; # app1
    server 192.168.10.60:2222; # app2
}

# Bloco de servidor para o balanceamento na porta 8000
server {
    listen 8000;
    server_name _;

    location / {
        proxy_pass http://backend;
    }
}

# Bloco de servidor para o redirecionamento na porta 8001
server {
    listen 8001;
    server_name _;

    location / {
        proxy_pass [http://192.168.10.60:2222/special](http://192.168.10.60:2222/special);
    }
}
Salve e feche o arquivo.

Parte 2: Habilitar a Configuração e Recarregar o Nginx
Bash

# Crie um link simbólico do arquivo para o diretório 'sites-enabled'
sudo ln -s /etc/nginx/sites-available/load-balancer.conf /etc/nginx/sites-enabled/

# Teste a sintaxe da configuração do Nginx para evitar erros
sudo nginx -t
# Saída esperada: ...syntax is ok, ...test is successful

# Recarregue o serviço Nginx para aplicar as novas configurações sem downtime
sudo systemctl reload nginx
Verificação Final
Execute estes comandos do seu terminal principal (ou de qualquer máquina na mesma rede) para testar o Load Balancer.

Bash

# Testar o balanceamento na porta 8000 (a saída deve alternar entre 'app1' e 'app2')
curl http://web-srv1:8000
curl http://web-srv1:8000
curl http://web-srv1:8000

# Testar o redirecionamento na porta 8001 (a saída deve ser sempre 'app2 special')
curl http://web-srv1:8001
curl http://web-srv1:8001/qualquer/outra/coisa
Conceitos Importantes para a Prova

upstream: Diretiva do Nginx usada para definir um grupo de servidores (backend) para onde o tráfego pode ser enviado.


proxy_pass: Diretiva que efetivamente passa a requisição para um servidor HTTP ou um grupo upstream definido.


Round Robin: O método de balanceamento de carga padrão do Nginx, onde as requisições são distribuídas sequencialmente para cada servidor do grupo upstream.

sites-available / sites-enabled: O padrão de organização de configurações do Nginx (e Apache) em sistemas Debian/Ubuntu. As configurações são criadas em available e ativadas criando um link simbólico para elas em enabled.

nginx -t: Comando crucial para testar a sintaxe de todos os arquivos de configuração do Nginx antes de tentar recarregar ou reiniciar o serviço, evitando paradas por erros de digitação.

LFCS - Questão 17: Configuração do OpenSSH
Objetivo da Tarefa
Proteger o Servidor SSH: Alterar a configuração padrão do sshd para aumentar a segurança.

Configuração Condicional: Aplicar configurações específicas para determinados usuários, sobrescrevendo as diretivas globais.

A tarefa exige a execução das seguintes ações no arquivo de configuração do sshd no servidor data-002:

Desabilitar o X11Forwarding globalmente.

Desabilitar a PasswordAuthentication para todos os usuários, exceto para a usuária marta.

Habilitar um Banner (usando o arquivo /etc/ssh/sshd-banner) que apareça quando os usuários marta e cilla tentarem se conectar.

1. Preparando o Ambiente no Lab
A preparação envolve conectar-se ao servidor e garantir que o arquivo de banner mencionado exista.

1.1 Conectar ao Servidor e Criar o Arquivo de Banner
Bash

# Conecte-se ao servidor data-002
ssh data-002

# Crie o arquivo de banner com uma mensagem de exemplo
echo "Bem-vindo ao servidor seguro. Todas as atividades são monitoradas." | sudo tee /etc/ssh/sshd-banner > /dev/null
2. Resolvendo a Questão: Passo a Passo
Todas as alterações são feitas no arquivo de configuração principal do servidor SSH, /etc/ssh/sshd_config.

Parte 1: Editar o Arquivo de Configuração
Bash

# Use um editor de texto com privilégios de sudo para modificar o arquivo
sudo nano /etc/ssh/sshd_config
Dentro do editor, faça as seguintes alterações:

A. Encontre e altere as configurações globais: Estas configurações geralmente já existem no arquivo e podem estar comentadas (#) ou com outros valores.

Snippet de código

# ... (outras configurações)
X11Forwarding no
# ...
PasswordAuthentication no
# ... (outras configurações)
B. Adicione as exceções no final do arquivo: É crucial que os blocos Match fiquem no final do arquivo para que funcionem corretamente.

Snippet de código

# --- Sobrescritas específicas por usuário ---
# (Adicionar no FINAL do arquivo)

Match User marta
    PasswordAuthentication yes
    Banner /etc/ssh/sshd-banner

Match User cilla
    Banner /etc/ssh/sshd-banner
Salve e feche o editor.

Parte 2: Testar e Reiniciar o Serviço SSH
Bash

# Teste a sintaxe do arquivo de configuração para garantir que não há erros
sudo sshd -t
# (Se não houver nenhuma saída, a sintaxe está correta)

# Reinicie o serviço SSH para aplicar as novas configurações
sudo systemctl restart sshd
Verificação Final
Execute os testes de login a partir de um terminal diferente para verificar o comportamento de cada usuário.

Bash

# Teste de login com 'marta'
# Deve mostrar a mensagem do banner e pedir a senha.
ssh marta@data-002

# Teste de login com 'cilla'
# Deve mostrar a mensagem do banner, mas negar o acesso por senha.
ssh cilla@data-002
# Saída esperada: cilla@data-002: Permission denied (publickey).

# Teste de login com outro usuário (ex: 'root')
# Não deve mostrar o banner e deve negar o acesso por senha.
ssh root@data-002
# Saída esperada: root@data-002: Permission denied (publickey).
Conceitos Importantes para a Prova
/etc/ssh/sshd_config: O arquivo de configuração principal do servidor OpenSSH.


Match: Uma diretiva poderosa que permite aplicar configurações específicas que sobrescrevem as globais para um User, Group, Host, etc. Deve ser colocada no final do arquivo de configuração.

X11Forwarding: Permite a tunelagem de aplicações gráficas X11 sobre a conexão SSH. Desabilitá-lo (no) é uma boa prática de segurança se não for necessário.

PasswordAuthentication: Controla se o login com senha é permitido. Desabilitá-lo (no) e forçar o uso de chaves SSH é uma das melhorias de segurança mais importantes.

Banner: Especifica um arquivo cujo conteúdo será exibido para o usuário antes da solicitação de autenticação.

sshd -t: Comando para testar a sintaxe dos arquivos de configuração do sshd. Essencial para evitar travar a si mesmo fora do servidor por um erro de digitação.

LFCS - Questão 18: Armazenamento com LVM
Objetivo da Tarefa
Gerenciar Volume Groups (VG): Reduzir um VG existente removendo um disco e criar um novo VG.

Gerenciar Logical Volumes (LV): Criar um novo LV com um tamanho específico.

Criar Sistema de Arquivos: Formatar um LV recém-criado para que possa ser usado pelo sistema.

A tarefa exige a execução das seguintes ações de gerenciamento de LVM:

Reduzir o Volume Group vol1 removendo o disco (Physical Volume) /dev/vdh dele.

Criar um novo Volume Group chamado vol2 que utilize o disco /dev/vdh.

Criar um Logical Volume de 50M chamado p1 dentro do vol2.

Formatar o novo volume lógico p1 com o sistema de arquivos ext4.

1. Preparando o Ambiente no Lab
A preparação envolve inspecionar a configuração atual do LVM para entender a estrutura de Physical Volumes (PV), Volume Groups (VG) e Logical Volumes (LV).

1.1 Inspecionar a Configuração LVM
Bash

# Liste os Physical Volumes para ver a quais VGs eles pertencem
sudo pvs

# Liste os Volume Groups para ver seu tamanho e quais PVs eles contêm
sudo vgs -o +devices

# Liste os Logical Volumes
sudo lvs
A partir dessa inspeção, você confirmará que /dev/vdh faz parte do VG vol1.

2. Resolvendo a Questão: Passo a Passo
A solução envolve uma sequência de comandos vg... e lv... para manipular a estrutura do LVM.

Parte 1: Reduzir o Volume Group vol1
Bash

# Remove o Physical Volume /dev/vdh do Volume Group vol1
sudo vgreduce vol1 /dev/vdh
Parte 2: Criar o Volume Group vol2
Agora que o disco /dev/vdh está livre, podemos usá-lo para criar um novo VG.

Bash

# Cria um novo VG chamado 'vol2' usando o PV /dev/vdh
sudo vgcreate vol2 /dev/vdh
Parte 3: Criar o Logical Volume p1
Crie um LV de 50MB a partir do espaço disponível no novo VG vol2.

Bash

# -L: especifica o tamanho (Size)
# -n: especifica o nome (name)
# A sintaxe é lvcreate [opções] <NomeDoVG>
sudo lvcreate -L 50M -n p1 vol2
Parte 4: Formatar o Novo Logical Volume
O novo LV está disponível no sistema através de um caminho em /dev/.

Bash

# O caminho para o LV é /dev/<nome_do_vg>/<nome_do_lv>
sudo mkfs.ext4 /dev/vol2/p1
Verificação Final
Use os comandos de listagem do LVM para verificar se cada etapa foi concluída com sucesso.

Bash

# Verifique se /dev/vdh agora pertence a 'vol2'
sudo pvs

# Verifique se 'vol1' foi reduzido e se 'vol2' foi criado
sudo vgs

# Verifique se o novo LV 'p1' existe dentro de 'vol2'
sudo lvs

# Verifique se o sistema de arquivos foi criado corretamente no LV
sudo blkid /dev/vol2/p1
# A saída deve conter a informação TYPE="ext4"
Conceitos Importantes para a Prova
LVM (Logical Volume Manager): Uma camada de abstração sobre os discos físicos que permite um gerenciamento de armazenamento flexível.

Hierarquia LVM:

PV (Physical Volume): Um disco físico ou partição (/dev/sda1, /dev/vdb) inicializado para uso do LVM.

VG (Volume Group): Um "pool" de armazenamento composto por um ou mais PVs.

LV (Logical Volume): Uma "partição" virtual criada a partir de um VG, que é o que o sistema operacional de fato usa.

Comandos LVM: A nomenclatura é intuitiva.

pv...: Comandos para gerenciar PVs (ex: pvs, pvcreate).

vg...: Comandos para gerenciar VGs (ex: vgs, vgcreate, vgreduce).

lv...: Comandos para gerenciar LVs (ex: lvs, lvcreate, lvresize).

Caminho do LV: Os LVs são acessíveis através do device mapper em /dev/mapper/<vg_name>-<lv_name> ou do atalho /dev/<vg_name>/<lv_name>.

LFCS - Questão 19: Regex (Expressões Regulares) para Filtrar Logs
Objetivo da Tarefa
Filtragem de Texto: Usar grep com expressões regulares (regex) para extrair linhas específicas de um arquivo de log.

Busca e Substituição: Usar sed com regex para encontrar e substituir linhas inteiras em um arquivo.

A tarefa exige a execução das seguintes ações no servidor web-srv1:

No arquivo /var/log-collector/003/nginx.log: Extrair todas as linhas onde a URL começa com /app/user e que foram acessadas pela identidade de navegador hacker-bot/1.2. Salvar o resultado em /var/log-collector/003/nginx.log.extracted.

No arquivo /var/log-collector/003/server.log: Encontrar todas as linhas que começam com container.web, terminam com 24h e contêm a palavra Running no meio. Substituir essas linhas inteiras pela frase SENSITIVE LINE REMOVED.

1. Preparando o Ambiente no Lab
A preparação envolve conectar-se ao servidor e inspecionar os arquivos de log para entender seu formato.

1.1 Conectar e Inspecionar os Arquivos
Bash

# Conecte-se ao servidor web-srv1
ssh web-srv1

# Navegue até o diretório dos logs
cd /var/log-collector/003

# Dê uma olhada nas primeiras linhas de cada arquivo para entender a estrutura
head nginx.log
head server.log
2. Resolvendo a Questão: Passo a Passo
A solução utiliza grep para extração e sed para substituição, ambos com expressões regulares.

Parte 1: Extrair Linhas do nginx.log com grep
Precisamos de uma expressão regular que garanta que /app/user e hacker-bot/1.2 apareçam na mesma linha na ordem correta.

Bash

# -E: Habilita o uso de expressões regulares estendidas.
# '.*': Coringa que significa "qualquer caractere, zero ou mais vezes".
# A regex procura por '/app/user', seguido de qualquer coisa, seguido por 'hacker-bot/1.2'.
grep -E "/app/user.*hacker-bot/1.2" nginx.log > nginx.log.extracted
Parte 2: Substituir Linhas no server.log com sed
Para substituir as linhas, construiremos uma regex que corresponda à linha inteira e usaremos o comando s (substitute) do sed.

Bash

# É sempre uma boa prática fazer um backup antes de modificar um arquivo no local.
cp server.log server.log.bak

# -i: edita o arquivo "in-place" (no local).
# s/PADRÃO/SUBSTITUIÇÃO/g: sintaxe de substituição.
# ^: indica o início da linha.
# \.: escapa o ponto para que ele signifique um ponto literal.
# $: indica o fim da linha.
sed -i 's/^container\.web.*Running.*24h$/SENSITIVE LINE REMOVED/g' server.log
Verificação Final
Verifique se os arquivos foram criados e modificados corretamente.

Bash

# Verifique a extração contando as linhas do novo arquivo
wc -l nginx.log.extracted
# Saída esperada: 27

# Verifique a substituição contando as linhas que foram substituídas no arquivo original
grep "SENSITIVE LINE REMOVED" server.log | wc -l
# Saída esperada: 44
Conceitos Importantes para a Prova
grep: Uma ferramenta para buscar padrões em texto.

-E: Ativa o modo de Expressão Regular Estendida, que oferece mais flexibilidade.

sed: Um "editor de stream", poderoso para fazer transformações em texto, como busca e substituição.

-i: Modifica o arquivo original diretamente. Sem essa flag, o sed apenas imprime o resultado na saída padrão.

s/regex/substituição/g: O comando de substituição. g no final significa "global", para substituir todas as ocorrências na linha (embora neste caso, como a regex cobre a linha inteira, não faz diferença).

Expressões Regulares (Regex) Básicas:

^: Âncora para o início da linha.

$: Âncora para o final da linha.

.*: Um coringa que corresponde a qualquer sequência de caracteres (incluindo uma sequência vazia).

\.: Caractere de escape para tratar um caractere especial (como o .) como um literal.

LFCS - Questão 20: Limites de Usuários e Grupos
Objetivo da Tarefa
Gerenciar Limites de Recursos (ulimit): Configurar limites de recursos para usuários e grupos de forma persistente.

Diferenciar Limites soft e hard: Entender e aplicar um limite máximo (hard) que não pode ser modificado pelo usuário.

A tarefa exige a execução das seguintes ações no servidor web-srv1:

Para a usuária jackie, configurar um limite máximo (hard limit) de 1024 processos (nproc). Remover a solução temporária que estava no arquivo .bashrc da usuária.

Para o grupo operators, configurar um limite de no máximo 1 login simultâneo (maxlogins).

1. Preparando o Ambiente no Lab
A preparação envolve simular o cenário inicial: criar a usuária jackie com a configuração temporária em seu .bashrc e criar o grupo operators.

1.1 Criar Usuário, Grupo e Configuração Temporária
Bash

# Conecte-se ao servidor web-srv1
ssh web-srv1

# Crie o grupo e a usuária
sudo groupadd operators
sudo useradd -m jackie

# Adicione a configuração temporária ao .bashrc da usuária
echo 'ulimit -S -u 1024' | sudo tee -a /home/jackie/.bashrc > /dev/null
2. Resolvendo a Questão: Passo a Passo
A configuração persistente de limites de recursos é feita no arquivo /etc/security/limits.conf.

Parte 1: Remover a Configuração Temporária e Aplicar o Limite hard
Primeiro, removemos a linha do .bashrc para garantir que a única configuração válida seja a do sistema.

Bash

# Edite o arquivo .bashrc da usuária jackie e remova a linha 'ulimit -S -u 1024'
sudo nano /home/jackie/.bashrc
Em seguida, adicione a regra permanente no arquivo de limites.

Bash

# Edite o arquivo de limites para adicionar as novas regras
sudo nano /etc/security/limits.conf
Adicione a seguinte linha no final do arquivo:

# <domain>      <type>  <item>         <value>

# Limite máximo de processos para a usuária jackie
jackie          hard    nproc          1024
Parte 2: Configurar o Limite para o Grupo operators
No mesmo arquivo /etc/security/limits.conf, adicione a regra para o grupo.

# Limite de logins simultâneos para o grupo operators
@operators      hard    maxlogins      1
O arquivo final terá as duas novas linhas:

jackie          hard    nproc          1024
@operators      hard    maxlogins      1
Salve e feche o editor.

Verificação Final
As novas regras são aplicadas na próxima sessão de login do usuário.

Bash

# Para verificar o limite da jackie, inicie uma nova sessão como ela
sudo su - jackie

# Verificar o limite atual (deve mostrar 1024)
ulimit -u

# Tentar aumentar o limite soft. Como não definimos um hard limit maior, isso pode ou não funcionar.
# O teste crucial é tentar aumentar o limite para além do hard limit (impossível).
# Como soft e hard são 1024, qualquer tentativa de aumento deve falhar.
ulimit -u 1100
# Saída esperada: bash: ulimit: max user processes: cannot modify limit: Operation not permitted

exit

Nota: A verificação do maxlogins não é trivial de ser testada no ambiente do simulado, mas a configuração correta no arquivo é o que será avaliado.

Conceitos Importantes para a Prova
/etc/security/limits.conf: O arquivo padrão para configurar limites de recursos de usuários e grupos de forma persistente no sistema (via PAM - Pluggable Authentication Modules).

hard limit: Um teto máximo que não pode ser ultrapassado pelo usuário ou por seus processos. Apenas o root pode aumentar um hard limit.

soft limit: O limite efetivo atual, que pode ser aumentado pelo usuário até o valor do hard limit.

ulimit: Um comando de shell para visualizar e definir limites de recursos para a sessão atual e seus processos filhos. Alterações feitas com ulimit não são persistentes entre logins, a menos que sejam colocadas em scripts de inicialização como .bashrc.

Sintaxe do limits.conf:

@group: O @ antes do nome indica que a regra se aplica a um grupo.

nproc: Número de processos.

maxlogins: Número de logins simultâneos.
