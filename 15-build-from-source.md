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
sudo tar xjf links-2.14.tar.bz2 [cite: 1247]

# Entre no diretório recém-criado com o código-fonte
cd links-2.14 [cite: 1248]
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
./configure --prefix=/usr --without-ipv6 [cite: 1279]
O script irá verificar as dependências do sistema e criar um Makefile com base nas opções fornecidas.

Parte 2: Compilar o Código (make)
O comando make lê o Makefile gerado na etapa anterior e executa os comandos de compilação para transformar o código-fonte em binários executáveis.

Bash

# Este processo pode levar alguns minutos
make [cite: 1303]
Parte 3: Instalar o Programa (make install)
Após a compilação bem-sucedida, o comando make install copia os arquivos compilados (binários, páginas de manual, etc.) para os diretórios corretos do sistema, conforme definido pelo --prefix. Esta ação requer privilégios de sudo.

Bash

sudo make install [cite: 1322]
Verificação Final
Verifique se o programa foi instalado corretamente e com as configurações especificadas.

Bash

# Verifique se o binário está no local correto
whereis links
# Saída esperada: links: /usr/bin/links ... [cite: 1329, 1330]

# Verifique a versão do programa para confirmar a instalação
/usr/bin/links -version
# Saída esperada: Links 2.14 [cite: 1331]

# Verifique se o suporte a IPv6 foi realmente desabilitado
# Este comando deve falhar, pois não conseguirá resolver um host IPv6
/usr/bin/links -lookup ip6-localhost
# Saída esperada: error: host not found [cite: 1333, 1334]
Conceitos Importantes para a Prova

Fluxo de Compilação Padrão: A sequência ./configure, make, sudo make install é o método tradicional para compilar e instalar software a partir do código-fonte na maioria dos projetos de código aberto.

./configure: Um script que analisa o ambiente do sistema (bibliotecas, compiladores) e gera um Makefile otimizado. É nesta etapa que se personaliza a instalação.

--prefix=<caminho>: Uma das opções mais importantes, define o diretório base de instalação. O padrão costuma ser /usr/local. Mudar para /usr integra o programa de forma mais nativa ao sistema.

make: A ferramenta que orquestra o processo de compilação, lendo as instruções do Makefile.

make install: A regra dentro do Makefile que copia os arquivos compilados para os diretórios finais do sistema. Quase sempre requer sudo.
