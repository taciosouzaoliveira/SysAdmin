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
# Saída esperada (exemplo): 172.17.0.3 [cite: 937]
cat /opt/course/11/mount-destination
# Saída esperada: /srv [cite: 938]

# Verifique se o novo contêiner 'frontend_v3' está em execução
sudo docker ps

# Teste o acesso à porta mapeada do novo contêiner
curl localhost:1234
# A saída deve ser o HTML da página de boas-vindas do Nginx. [cite: 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973]
Conceitos Importantes para a Prova
docker ps: Lista os contêineres em execução. A flag -a mostra todos, incluindo os parados. 


docker stop <nome_container>: Para um contêiner em execução de forma segura (enviando um sinal SIGTERM). 


docker inspect <nome_container>: Fornece um JSON detalhado com todas as informações de configuração de um contêiner. 


docker run [OPTIONS] IMAGE: O comando principal para criar e iniciar um novo contêiner. 


-d ou --detach: Executa o contêiner em segundo plano. 


--name: Atribui um nome ao contêiner. 

--memory: Define um limite de memória RAM.


-p ou --publish: Mapeia uma porta do host para uma porta do contêiner.
