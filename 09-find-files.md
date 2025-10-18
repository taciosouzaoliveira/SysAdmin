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
find . -maxdepth 1 -type f ! [cite_start]-newermt "2020-01-01" -exec rm {} \; [cite: 575]
Parte 2: Mover Arquivos Pequenos (< 3KiB)
Bash

# -size -3k: Encontra arquivos com tamanho MENOR que 3 kilobytes.
# -exec mv {} ./small/ \;: Executa o comando 'mv' para mover cada arquivo para o diretório 'small'.
find . [cite_start]-maxdepth 1 -type f -size -3k -exec mv {} ./small/ \; [cite: 582]
Parte 3: Mover Arquivos Grandes (> 10KiB)
Bash

# -size +10k: Encontra arquivos com tamanho MAIOR que 10 kilobytes.
find . [cite_start]-maxdepth 1 -type f -size +10k -exec mv {} ./large/ \; [cite: 591]
Parte 4: Mover Arquivos com Permissão 777
Bash

# -perm 777: Encontra arquivos que têm exatamente a permissão 777.
find . [cite_start]-maxdepth 1 -type f -perm 777 -exec mv {} ./compromised/ \; [cite: 596]
Verificação Final
Após executar todos os comandos, conte os arquivos em cada diretório para verificar se as operações foram bem-sucedidas.

Bash

# Conte os arquivos restantes no diretório principal
ls -l | wc -l

# Conte os arquivos movidos para cada subdiretório
[cite_start]ls small/ | wc -l [cite: 599]
[cite_start]ls large/ | wc -l [cite: 601]
[cite_start]ls compromised/ | wc -l [cite: 603]
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
