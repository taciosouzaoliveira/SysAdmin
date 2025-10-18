LFCS - Questão 13: Segurança de Processos em Tempo de Execução
Objetivo da Tarefa
Análise de Processos: Inspecionar processos em execução em tempo real para identificar atividades suspeitas.

Uso de Ferramentas de Diagnóstico: Utilizar a ferramenta strace para monitorar as chamadas de sistema (syscalls) feitas por um processo.

Ação de Remediação: Finalizar um processo malicioso e remover seu executável do sistema.

A tarefa exige a execução das seguintes ações no servidor web-srv1:

Investigar os três processos em execução: collector1, collector2, e collector3.

Identificar qual(is) deles está(ão) executando a chamada de sistema (syscall) proibida kill.

Para o(s) processo(s) infrator(es), finalizar sua execução e apagar o arquivo executável correspondente.

1. Preparando o Ambiente no Lab
A preparação para esta tarefa consiste em conectar-se ao servidor e identificar os processos alvo e seus respectivos PIDs (Process IDs), que são necessários para a análise com strace.

1.1 Conectar ao Servidor e Listar os Processos
Bash

# Conecte-se ao servidor web-srv1
ssh web-srv1

# Liste os processos em execução e filtre por "collector" para encontrar seus PIDs
ps aux | grep collector
A saída mostrará os três processos e seus PIDs. Anote os PIDs de collector1, collector2 e collector3, pois eles serão usados na próxima etapa.

Exemplo de saída:

root      3611  0.0  0.0 101924   624 ?        Sl   13:23   0:00 /bin/collector1
root      3612  0.0  0.0 101916   612 ?        Sl   13:23   0:00 /bin/collector2
root      3613  0.0  0.0 101928   616 ?        Sl   13:23   0:00 /bin/collector3
2. Resolvendo a Questão: Passo a Passo
A solução envolve usar strace para monitorar cada processo individualmente, identificar o infrator e, em seguida, tomar a ação de remediação.

Parte 1: Inspecionar os Processos com strace
Execute strace para cada PID que você anotou. Você precisará observar a saída por alguns segundos para cada um, procurando pela chamada de sistema kill.

Bash

# Inspecione o primeiro processo (substitua <PID_collector1> pelo ID real)
# Pressione Ctrl+C para parar a análise após alguns segundos.
sudo strace -p <PID_collector1>
# (Nenhuma chamada 'kill' deve aparecer)

# Inspecione o segundo processo
sudo strace -p <PID_collector2>
# A saída deve mostrar repetidamente a chamada 'kill', como: kill(666, SIGTERM)

# Inspecione o terceiro processo para ter certeza
sudo strace -p <PID_collector3>
# (Nenhuma chamada 'kill' deve aparecer)
A análise revela que collector2 é o processo infrator.

Parte 2: Finalizar o Processo e Remover o Executável
Agora que o processo malicioso foi identificado, use o comando kill para finalizá-lo e o comando rm para remover seu binário.

Bash

# Use o PID do collector2 que você identificou
sudo kill <PID_collector2>

# O caminho do executável foi mostrado na saída do comando 'ps aux'
sudo rm /bin/collector2
Verificação Final
Verifique se o processo foi realmente finalizado e se o arquivo executável foi removido do sistema.

Bash

# Procure pelo processo novamente. O comando não deve retornar o processo 'collector2'.
ps aux | grep collector2

# Tente listar o arquivo executável. Você deve receber um erro.
ls /bin/collector2
# Saída esperada: ls: cannot access '/bin/collector2': No such file or directory
Conceitos Importantes para a Prova
ps aux: Um comando fundamental para listar todos os processos em execução no sistema (a=todos os usuários, u=formato de usuário, x=incluir processos sem terminal).

strace: Uma poderosa ferramenta de depuração que rastreia as chamadas de sistema (syscalls) e sinais de um processo. É essencial para entender o que um programa está fazendo "por baixo dos panos".

-p <PID>: Anexa o strace a um processo já em execução, especificado pelo seu PID.

Syscall (Chamada de Sistema): A interface programática através da qual um programa solicita um serviço do kernel do sistema operacional. kill é a syscall usada para enviar sinais a outros processos.

kill <PID>: O comando de shell para enviar um sinal a um processo. Por padrão, ele envia o SIGTERM, que solicita que o processo termine de forma organizada.

rm: O comando padrão para remover arquivos.
