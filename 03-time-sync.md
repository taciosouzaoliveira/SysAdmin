LFCS - Questão 3: Configuração de Sincronização de Tempo (NTP)
Objetivo da Tarefa

Configurar Servidores NTP: Definir servidores NTP primários e de fallback para a sincronização de tempo do sistema.


Ajustar Intervalos: Modificar os intervalos máximo de consulta (poll) e de nova tentativa de conexão.

1. Verificando o Ambiente
Antes de começar, é uma boa prática inspecionar a configuração atual do serviço de tempo.

1.1 Inspecionar Status Atual
Use o comando timedatectl para ver o status do serviço, incluindo o fuso horário e se a sincronização NTP está ativa.


Bash

# Verifique o status do serviço de tempo
timedatectl
1.2 Acessar o Arquivo de Configuração
O arquivo que precisa ser editado é o /etc/systemd/timesyncd.conf. É necessário usar sudo para modificá-lo.

Bash

# Abra o arquivo de configuração com um editor
sudo nano /etc/systemd/timesyncd.conf
2. Resolvendo a Questão: Passo a Passo
A tarefa é dividida em editar o arquivo de configuração e depois reiniciar e verificar o serviço.

Parte 1: Editar o Arquivo timesyncd.conf
Dentro do arquivo, você encontrará uma seção [Time]. Descomente e/ou adicione as linhas necessárias para atender aos requisitos da questão.


Servidores principais: 0.pool.ntp.org e 1.pool.ntp.org.


Servidores de fallback: ntp.ubuntu.com e 0.debian.pool.ntp.org.


Intervalo máximo de poll: 1000 segundos.


Tentativa de reconexão: 20 segundos.

O arquivo editado deve conter as seguintes linhas:

Ini, TOML

[Time]
NTP=0.pool.ntp.org 1.pool.ntp.org
FallbackNTP=ntp.ubuntu.com 0.debian.pool.ntp.org
PollIntervalMaxSec=1000
ConnectionRetrySec=20
Salve e feche o editor.

Parte 2: Reiniciar e Verificar o Serviço
Para que as alterações entrem em vigor, o serviço systemd-timesyncd deve ser reiniciado.

Bash

# Reinicie o serviço para aplicar a nova configuração
sudo systemctl restart systemd-timesyncd
Verificação Final:

Verifique o status do serviço para garantir que ele está rodando sem erros e para ver qual servidor NTP foi utilizado para a sincronização.


Bash

# Verifique o status do serviço
sudo systemctl status systemd-timesyncd

# A saída deve mostrar o serviço como "active (running)"
# e uma linha nos logs indicando o servidor usado, como:
# "Initial synchronization to time server ... (0.pool.ntp.org)." [cite: 225, 233]
Conceitos Importantes para a Prova
Arquivo de Configuração (/etc/systemd/timesyncd.conf):

É o local padrão para configurar o cliente NTP do systemd.

A diretiva NTP= define a lista de servidores principais, separados por espaço.

A diretiva FallbackNTP= define uma lista secundária de servidores para usar caso os principais falhem.

Comandos de Gerenciamento:


timedatectl: Ferramenta principal para visualizar e controlar a data, hora, fuso horário e status do serviço de sincronização.


systemctl restart systemd-timesyncd: Comando essencial para aplicar quaisquer mudanças feitas no arquivo .conf.


systemctl status systemd-timesyncd: Usado para depurar problemas e verificar se o serviço está funcionando corretamente após uma alteração.
