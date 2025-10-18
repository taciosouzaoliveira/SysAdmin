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

