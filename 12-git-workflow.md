LFCS - Questão 12: Fluxo de Trabalho com Git
Objetivo da Tarefa
Gerenciar Repositório: Clonar um repositório Git.

Trabalhar com Branches: Inspecionar o conteúdo de diferentes branches, identificar a correta com base em um critério e mesclá-la (merge) na branch principal.

Versionar Alterações: Criar um novo diretório, garantir que ele seja versionado pelo Git e salvar as alterações com um commit específico.

A tarefa exige a execução das seguintes ações:

Clonar o repositório /repositories/auto-verifier para o diretório /home/candidate/repositories/auto-verifier. 

Dentre as branches dev4, dev5 e dev6, encontrar aquela em que o arquivo config.yaml contém a linha user_registration_level: open. 

Fazer o merge apenas da branch encontrada no passo anterior para a branch main. 

Na branch main, criar um novo diretório chamado Logs e, dentro dele, um arquivo oculto e vazio chamado .keep. 

Fazer o commit da alteração com a mensagem "added log directory". 

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação consiste em garantir que o Git está instalado e que o repositório de origem (/repositories/auto-verifier) existe para ser clonado. A primeira etapa da resolução é, na verdade, a clonagem que prepara o ambiente de trabalho.

2. Resolvendo a Questão: Passo a Passo
A solução envolve uma sequência de comandos Git para clonar, inspecionar, mesclar e commitar as alterações.

Parte 1: Clonar o Repositório
Bash

# Clone o repositório de origem para o destino especificado
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier [cite: 986]

# Navegue para o diretório do repositório recém-clonado
cd /home/candidate/repositories/auto-verifier [cite: 987]
Parte 2: Encontrar e Mesclar a Branch Correta
Vamos inspecionar cada uma das branches dev para encontrar a que corresponde ao critério.

Bash

# Liste todas as branches disponíveis (locais e remotas)
git branch -a [cite: 994]

# Mude para a branch dev4 e verifique o arquivo
git checkout dev4 [cite: 1001]
grep "user_registration_level" config.yaml [cite: 1003]
# Saída esperada: user_registration_level: closed

# Mude para a branch dev5 e verifique o arquivo
git checkout dev5 [cite: 1004]
grep "user_registration_level" config.yaml [cite: 1006]
# Saída esperada: user_registration_level: open -> ENCONTRAMOS!

# Volte para a branch 'main' para preparar o merge
git checkout main [cite: 1064]

# Execute o merge da branch 'dev5' na 'main'
git merge dev5 [cite: 1071]
Parte 3: Criar o Novo Diretório e o Arquivo .keep
O Git não versiona diretórios vazios. Por isso, criamos um arquivo .keep (uma convenção comum) para forçar o Git a rastrear o diretório.

Bash

# Crie o novo diretório
mkdir Logs [cite: 1079]

# Crie o arquivo oculto e vazio dentro dele
touch Logs/.keep [cite: 1090]
Parte 4: Fazer o Commit da Alteração
Adicione o novo diretório ao "stage" e, em seguida, faça o commit com a mensagem solicitada.

Bash

# Adicione o diretório 'Logs' (e o arquivo .keep dentro dele) para ser versionado
git add Logs [cite: 1109]

# Faça o commit com a mensagem exata
git commit -m "added log directory" [cite: 1117]
Verificação Final
Verifique se cada etapa foi concluída com sucesso.

Bash

# Verifique se a alteração do merge está presente na branch 'main'
grep "user_registration_level" config.yaml
# Saída esperada: user_registration_level: open [cite: 1076]

# Verifique o status do git; deve mostrar que a árvore está limpa
git status

# Verifique o histórico de commits para ver sua última alteração
# A flag -1 mostra apenas o commit mais recente
git log -1
# A saída deve mostrar seu commit com a mensagem "added log directory".
Conceitos Importantes para a Prova
git clone: Cria uma cópia local de um repositório remoto ou local.

git branch -a: Lista todas as branches, tanto as locais quanto as remotas (remotes/...).

git checkout <branch>: Muda o seu "ambiente de trabalho" (HEAD) para a branch especificada.

git merge <branch>: Traz as alterações da <branch> especificada para a branch em que você está atualmente.

Rastreamento de Diretórios: O Git rastreia o conteúdo dos arquivos, não os diretórios em si. Um diretório vazio não pode ser adicionado a um commit. A criação de um arquivo como .keep ou .gitkeep é uma convenção para contornar isso.

git add <arquivo/diretório>: Adiciona alterações à "área de preparação" (staging area), marcando-as para serem incluídas no próximo commit.

git commit -m "mensagem": Salva as alterações da staging area permanentemente no histórico do repositório com uma mensagem descritiva.
