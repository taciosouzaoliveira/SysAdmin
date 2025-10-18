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
