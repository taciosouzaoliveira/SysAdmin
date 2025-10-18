Arquivo: 01-kernel-info.md
Markdown

# LFCS - Questão 1: Informações do Kernel e Sistema

### Objetivo da Tarefa

-   **Coletar Dados do Sistema:** Usar comandos de linha para extrair informações específicas do sistema operacional.
-   **Redirecionar Saída:** Salvar os dados coletados em arquivos de texto nos locais designados.

A tarefa exige as seguintes ações no servidor `terminal`:
1.  Escrever a release do Kernel do Linux no arquivo `/opt/course/1/kernel`.
2.  Escrever o valor atual do parâmetro de rede `ip_forward` no arquivo `/opt/course/1/ip_forward`.
3.  Escrever o fuso horário (timezone) do sistema no arquivo `/opt/course/1/timezone`.

---

### 1. Preparando o Ambiente no Lab

Para esta tarefa, a única preparação necessária é garantir que o diretório onde as respostas serão salvas exista.

#### 1.1 Criar o Diretório de Destino

Use o comando `mkdir` com a flag `-p` para criar o diretório `/opt/course/1`, caso ele não exista.

```bash
sudo mkdir -p /opt/course/1
Isso garante que o caminho para salvar os arquivos de solução está pronto.

2. Resolvendo a Questão: Passo a Passo
A solução envolve executar comandos específicos para cada informação e redirecionar a saída (>) para o arquivo de destino correto.

Parte 1: Coletar a Versão do Kernel
Use o comando uname -r para obter a release do kernel e salve-a no arquivo.

Bash

# O comando 'uname -r' exibe a versão do kernel em execução.
uname -r > /opt/course/1/kernel
Parte 2: Coletar o Parâmetro ip_forward
O valor deste parâmetro do kernel pode ser lido diretamente do sistema de arquivos virtual /proc.

Bash

# O 'cat' lê o conteúdo do arquivo que representa o parâmetro do kernel.
cat /proc/sys/net/ipv4/ip_forward > /opt/course/1/ip_forward
Parte 3: Coletar o Fuso Horário
O fuso horário do sistema pode ser encontrado no arquivo /etc/timezone.

Bash

# Lê o arquivo que contém o nome do fuso horário configurado.
cat /etc/timezone > /opt/course/1/timezone
Verificação Final
Após executar os comandos, verifique o conteúdo de cada arquivo criado para garantir que a informação correta foi salva.

Bash

# Verifique o conteúdo do arquivo do kernel
cat /opt/course/1/kernel
Saída esperada (exemplo):

5.15.0-69-generic
Bash

# Verifique o conteúdo do arquivo ip_forward
cat /opt/course/1/ip_forward
Saída esperada (exemplo):

1
Bash

# Verifique o conteúdo do arquivo de fuso horário
cat /opt/course/1/timezone
Saída esperada (exemplo):

UTC
Conceitos Importantes para a Prova
uname -r: Comando específico para imprimir a release (versão) do kernel em execução.

/proc/sys/: Um sistema de arquivos virtual que permite visualizar e alterar parâmetros do kernel em tempo real. O arquivo net/ipv4/ip_forward controla se o encaminhamento de pacotes IP está ativado (1) ou desativado (0).

/etc/timezone: Arquivo de configuração de texto simples que contém o nome do fuso horário utilizado pelo sistema.
