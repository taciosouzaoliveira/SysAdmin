LFCS - Questão 17: Configuração do OpenSSH
Objetivo da Tarefa
Proteger o Servidor SSH: Alterar a configuração padrão do sshd para aumentar a segurança.

Configuração Condicional: Aplicar configurações específicas para determinados usuários, sobrescrevendo as diretivas globais.

A tarefa exige a execução das seguintes ações no arquivo de configuração do sshd no servidor data-002:

Desabilitar o X11Forwarding globalmente.

Desabilitar a PasswordAuthentication para todos os usuários, exceto para a usuária marta.

Habilitar um Banner (usando o arquivo /etc/ssh/sshd-banner) que apareça quando os usuários marta e cilla tentarem se conectar.

1. Preparando o Ambiente no Lab
A preparação envolve conectar-se ao servidor e garantir que o arquivo de banner mencionado exista.

1.1 Conectar ao Servidor e Criar o Arquivo de Banner
Bash

# Conecte-se ao servidor data-002
ssh data-002

# Crie o arquivo de banner com uma mensagem de exemplo
echo "Bem-vindo ao servidor seguro. Todas as atividades são monitoradas." | sudo tee /etc/ssh/sshd-banner > /dev/null
2. Resolvendo a Questão: Passo a Passo
Todas as alterações são feitas no arquivo de configuração principal do servidor SSH, /etc/ssh/sshd_config.

Parte 1: Editar o Arquivo de Configuração
Bash

# Use um editor de texto com privilégios de sudo para modificar o arquivo
sudo nano /etc/ssh/sshd_config
Dentro do editor, faça as seguintes alterações:

A. Encontre e altere as configurações globais: Estas configurações geralmente já existem no arquivo e podem estar comentadas (#) ou com outros valores.

Snippet de código

# ... (outras configurações)
X11Forwarding no
# ...
PasswordAuthentication no
# ... (outras configurações)
B. Adicione as exceções no final do arquivo: É crucial que os blocos Match fiquem no final do arquivo para que funcionem corretamente.

Snippet de código

# --- Sobrescritas específicas por usuário ---
# (Adicionar no FINAL do arquivo)

Match User marta
    PasswordAuthentication yes
    Banner /etc/ssh/sshd-banner

Match User cilla
    Banner /etc/ssh/sshd-banner
Salve e feche o editor.

Parte 2: Testar e Reiniciar o Serviço SSH
Bash

# Teste a sintaxe do arquivo de configuração para garantir que não há erros
sudo sshd -t
# (Se não houver nenhuma saída, a sintaxe está correta)

# Reinicie o serviço SSH para aplicar as novas configurações
sudo systemctl restart sshd
Verificação Final
Execute os testes de login a partir de um terminal diferente para verificar o comportamento de cada usuário.

Bash

# Teste de login com 'marta'
# Deve mostrar a mensagem do banner e pedir a senha.
ssh marta@data-002

# Teste de login com 'cilla'
# Deve mostrar a mensagem do banner, mas negar o acesso por senha.
ssh cilla@data-002
# Saída esperada: cilla@data-002: Permission denied (publickey).

# Teste de login com outro usuário (ex: 'root')
# Não deve mostrar o banner e deve negar o acesso por senha.
ssh root@data-002
# Saída esperada: root@data-002: Permission denied (publickey).
Conceitos Importantes para a Prova
/etc/ssh/sshd_config: O arquivo de configuração principal do servidor OpenSSH.


Match: Uma diretiva poderosa que permite aplicar configurações específicas que sobrescrevem as globais para um User, Group, Host, etc. Deve ser colocada no final do arquivo de configuração.

X11Forwarding: Permite a tunelagem de aplicações gráficas X11 sobre a conexão SSH. Desabilitá-lo (no) é uma boa prática de segurança se não for necessário.

PasswordAuthentication: Controla se o login com senha é permitido. Desabilitá-lo (no) e forçar o uso de chaves SSH é uma das melhorias de segurança mais importantes.

Banner: Especifica um arquivo cujo conteúdo será exibido para o usuário antes da solicitação de autenticação.

sshd -t: Comando para testar a sintaxe dos arquivos de configuração do sshd. Essencial para evitar travar a si mesmo fora do servidor por um erro de digitação.

