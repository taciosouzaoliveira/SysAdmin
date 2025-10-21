LFCS - Questão 3: Sincronização de Horário (NTP)
Objetivo da Tarefa
Configurar Servidores NTP: Atualizar a configuração do systemd-timesyncd para usar servidores NTP específicos.

Ajustar Parâmetros: Definir intervalos de consulta e de nova tentativa de conexão.

A tarefa exige as seguintes configurações no servidor terminal:

Definir 0.pool.ntp.org e 1.pool.ntp.org como servidores NTP principais.

Definir ntp.ubuntu.com e 0.debian.pool.ntp.org como servidores NTP de fallback (reserva).

Definir o intervalo máximo de consulta (PollIntervalMaxSec) para 1000 segundos e a tentativa de reconexão (ConnectionRetrySec) para 20 segundos.

1. Preparando o Ambiente no Lab
A preparação consiste em inspecionar o estado atual do serviço de sincronização de tempo para entender o ponto de partida.

1.1 Verificar o Status Atual
Use o comando timedatectl para ver o status do serviço de tempo.

Bash

timedatectl
Isso mostrará se o serviço systemd-timesyncd está ativo e se o relógio do sistema está sincronizado.

1.2 Inspecionar a Configuração Existente
É uma boa prática verificar o arquivo de configuração atual antes de fazer alterações.

Bash

cat /etc/systemd/timesyncd.conf
2. Resolvendo a Questão: Passo a Passo
A solução envolve editar o arquivo de configuração e reiniciar o serviço para aplicar as novas diretivas.

Primeiro, use um editor de texto com privilégios de sudo para modificar o arquivo de configuração.

Bash

sudo nano /etc/systemd/timesyncd.conf
Dentro do editor, adicione ou modifique as linhas na seção [Time] para que correspondam ao solicitado.

Ini, TOML

[Time]
NTP=0.pool.ntp.org 1.pool.ntp.org
FallbackNTP=ntp.ubuntu.com 0.debian.pool.ntp.org
PollIntervalMaxSec=1000
ConnectionRetrySec=20
Depois de salvar e fechar o arquivo, reinicie o serviço systemd-timesyncd para que as novas configurações entrem em vigor.

Bash

sudo systemctl restart systemd-timesyncd
Verificação Final
Após reiniciar, verifique o status do serviço para confirmar que ele está funcionando corretamente.

Bash

sudo systemctl status systemd-timesyncd
Saída esperada (exemplo):

A saída deve mostrar a linha Active: active (running). Nos logs, você verá uma mensagem indicando a sincronização com um dos novos servidores, como: Initial synchronization to time server 162.159.200.123:123 (0.pool.ntp.org).

Conceitos Importantes para a Prova
systemd-timesyncd: É o serviço do systemd responsável por sincronizar o relógio do sistema com servidores NTP remotos.

/etc/systemd/timesyncd.conf: O arquivo de configuração principal para o systemd-timesyncd.

NTP= e FallbackNTP=: Diretivas que definem a lista de servidores NTP principais e de reserva, respectivamente.

systemctl restart <serviço>: O comando padrão para aplicar mudanças na configuração da maioria dos serviços gerenciados pelo systemd.
