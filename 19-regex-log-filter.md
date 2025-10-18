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
