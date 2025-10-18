LFCS - Questão 20: Limites de Usuários e Grupos
Objetivo da Tarefa
Gerenciar Limites de Recursos (ulimit): Configurar limites de recursos para usuários e grupos de forma persistente.

Diferenciar Limites soft e hard: Entender e aplicar um limite máximo (hard) que não pode ser modificado pelo usuário.

A tarefa exige a execução das seguintes ações no servidor web-srv1:

Para a usuária jackie, configurar um limite máximo (hard limit) de 1024 processos (nproc). Remover a solução temporária que estava no arquivo .bashrc da usuária.

Para o grupo operators, configurar um limite de no máximo 1 login simultâneo (maxlogins).

1. Preparando o Ambiente no Lab
A preparação envolve simular o cenário inicial: criar a usuária jackie com a configuração temporária em seu .bashrc e criar o grupo operators.

1.1 Criar Usuário, Grupo e Configuração Temporária
Bash

# Conecte-se ao servidor web-srv1
ssh web-srv1

# Crie o grupo e a usuária
sudo groupadd operators
sudo useradd -m jackie

# Adicione a configuração temporária ao .bashrc da usuária
echo 'ulimit -S -u 1024' | sudo tee -a /home/jackie/.bashrc > /dev/null
2. Resolvendo a Questão: Passo a Passo
A configuração persistente de limites de recursos é feita no arquivo /etc/security/limits.conf.

Parte 1: Remover a Configuração Temporária e Aplicar o Limite hard
Primeiro, removemos a linha do .bashrc para garantir que a única configuração válida seja a do sistema.

Bash

# Edite o arquivo .bashrc da usuária jackie e remova a linha 'ulimit -S -u 1024'
sudo nano /home/jackie/.bashrc
Em seguida, adicione a regra permanente no arquivo de limites.

Bash

# Edite o arquivo de limites para adicionar as novas regras
sudo nano /etc/security/limits.conf
Adicione a seguinte linha no final do arquivo:

# <domain>      <type>  <item>         <value>

# Limite máximo de processos para a usuária jackie
jackie          hard    nproc          1024
Parte 2: Configurar o Limite para o Grupo operators
No mesmo arquivo /etc/security/limits.conf, adicione a regra para o grupo.

# Limite de logins simultâneos para o grupo operators
@operators      hard    maxlogins      1
O arquivo final terá as duas novas linhas:

jackie          hard    nproc          1024
@operators      hard    maxlogins      1
Salve e feche o editor.

Verificação Final
As novas regras são aplicadas na próxima sessão de login do usuário.

Bash

# Para verificar o limite da jackie, inicie uma nova sessão como ela
sudo su - jackie

# Verificar o limite atual (deve mostrar 1024)
ulimit -u

# Tentar aumentar o limite soft. Como não definimos um hard limit maior, isso pode ou não funcionar.
# O teste crucial é tentar aumentar o limite para além do hard limit (impossível).
# Como soft e hard são 1024, qualquer tentativa de aumento deve falhar.
ulimit -u 1100
# Saída esperada: bash: ulimit: max user processes: cannot modify limit: Operation not permitted

exit

Nota: A verificação do maxlogins não é trivial de ser testada no ambiente do simulado, mas a configuração correta no arquivo é o que será avaliado.

Conceitos Importantes para a Prova
/etc/security/limits.conf: O arquivo padrão para configurar limites de recursos de usuários e grupos de forma persistente no sistema (via PAM - Pluggable Authentication Modules).

hard limit: Um teto máximo que não pode ser ultrapassado pelo usuário ou por seus processos. Apenas o root pode aumentar um hard limit.

soft limit: O limite efetivo atual, que pode ser aumentado pelo usuário até o valor do hard limit.

ulimit: Um comando de shell para visualizar e definir limites de recursos para a sessão atual e seus processos filhos. Alterações feitas com ulimit não são persistentes entre logins, a menos que sejam colocadas em scripts de inicialização como .bashrc.

Sintaxe do limits.conf:

@group: O @ antes do nome indica que a regra se aplica a um grupo.

nproc: Número de processos.

maxlogins: Número de logins simultâneos.
