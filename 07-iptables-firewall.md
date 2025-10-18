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
# Saída esperada: app on port 5000 [cite: 401]

curl data-002:6001
# Saída esperada: app on port 6001 [cite: 405]

curl data-002:6002
# Saída esperada: app on port 6002 [cite: 407]
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
# Saída esperada: app on port 6001 [cite: 453]

# Teste do acesso restrito (deve falhar/timeout)
curl data-002:6002

# Teste do acesso restrito a partir do servidor permitido ('data-001')
ssh data-001 "curl data-002:6002"
# Saída esperada: app on port 6002 [cite: 465]

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
