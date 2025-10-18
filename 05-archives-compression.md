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
