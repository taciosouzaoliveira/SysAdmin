LFCS - Questão 8: Gerenciamento de Discos
Objetivo da Tarefa
Formatar e Montar Discos: Criar um novo sistema de arquivos em um disco, montá-lo e criar um arquivo.

Gerenciar Espaço em Disco: Identificar o disco com maior uso e liberar espaço nele.

Lidar com Discos Ocupados: Identificar um processo que está utilizando um ponto de montagem, finalizá-lo e desmontar o disco.

A tarefa exige a execução das seguintes ações:

Formatar o disco /dev/vdb com ext4, montá-lo em /mnt/backup-black e criar o arquivo /mnt/backup-black/completed. 

Verificar qual dos discos, /dev/vdc ou /dev/vdd, tem maior uso de armazenamento e, em seguida, esvaziar a pasta de lixo (.trash) nele. 

Identificar qual dos processos, dark-matter-v1 ou dark-matter-v2, consome mais memória, descobrir em qual disco o executável do processo está localizado e, em seguida, desmontar esse disco. 

1. Preparando o Ambiente no Lab
Para esta tarefa, a preparação consiste em inspecionar os discos e processos existentes para entender o cenário inicial.

1.1 Inspecionar os Discos Existentes
Use comandos como lsblk -f ou df -h para obter uma visão geral dos discos, seus sistemas de arquivos e pontos de montagem. 


Bash

# Lista os dispositivos de bloco com informações de sistema de arquivos e montagem
lsblk -f

# Mostra o uso de espaço em disco de forma legível
df -h
Isso permitirá que você identifique os discos /dev/vdb, /dev/vdc, /dev/vdd e seus estados atuais.

1.2 Inspecionar os Processos em Execução
Verifique os processos dark-matter para analisar seu consumo de memória.

Bash

# Lista os processos e filtra pelos que contêm "dark-matter"
ps aux | grep dark-matter
Observe as colunas %MEM (uso de memória RAM) e VSZ (memória virtual) para determinar qual processo consome mais recursos. 


2. Resolvendo a Questão: Passo a Passo
Execute as tarefas de gerenciamento de disco conforme solicitado.

Parte 1: Formatar e Montar /dev/vdb
Bash

# Cria um sistema de arquivos do tipo ext4 no disco /dev/vdb
sudo mkfs.ext4 /dev/vdb [cite: 506]

# Cria o diretório que servirá como ponto de montagem
sudo mkdir -p /mnt/backup-black [cite: 514]

# Monta o disco no diretório criado
sudo mount /dev/vdb /mnt/backup-black [cite: 515]

# Cria o arquivo vazio para indicar a conclusão
sudo touch /mnt/backup-black/completed [cite: 516]
Parte 2: Limpar o Disco Mais Cheio
Bash

# Use df -h para comparar o uso (coluna Use%) de /dev/vdc e /dev/vdd
df -h [cite: 519]
Com base na saída, identifique o ponto de montagem do disco mais cheio (no simulado, é /dev/vdc montado em /mnt/backup001). 

Bash

# Esvazie a pasta de lixo no ponto de montagem do disco mais cheio
sudo rm -rf /mnt/backup001/.trash/* [cite: 522]
Parte 3: Desmontar o Disco em Uso
Bash

# Identifique o processo com maior consumo de memória (VSZ) usando ps aux
ps aux | grep dark-matter [cite: 528]
O simulado identifica dark-matter-v2 como o processo que consome mais memória e que seu executável está em /mnt/app-4e9d7e1e/dark-matter-v2. 

Bash

# Tente desmontar o disco. A operação falhará porque o processo está em execução.
sudo umount /mnt/app-4e9d7e1e [cite: 539]
# Saída esperada: umount: /mnt/app-4e9d7e1e: target is busy. [cite: 540]

# Use lsof para confirmar qual processo está usando o ponto de montagem
sudo lsof | grep /mnt/app-4e9d7e1e [cite: 542]
# Ou use o PID identificado anteriormente com o comando ps.

# Finalize o processo infrator (substitua <PID> pelo ID do processo)
sudo kill <PID_do_dark-matter-v2> [cite: 549]

# Agora, o comando para desmontar o disco funcionará
sudo umount /mnt/app-4e9d7e1e [cite: 550]
Verificação Final
Verifique se cada etapa foi concluída com sucesso.

Bash

# Verifique se o novo disco está montado e o arquivo existe
df -h | grep /mnt/backup-black
ls /mnt/backup-black

# Verifique se o espaço em disco do /dev/vdc (ou /mnt/backup001) foi liberado
df -h [cite: 524]

# Verifique se o disco /dev/vdf (ou /mnt/app-4e9d7e1e) não está mais montado
df -h | grep /mnt/app-4e9d7e1e
# (Este comando não deve retornar nenhuma saída)
Conceitos Importantes para a Prova
mkfs.ext4: Comando para criar um sistema de arquivos do tipo ext4 em um dispositivo de bloco.

mount / umount: Comandos para anexar (montar) e desanexar (desmontar) sistemas de arquivos à árvore de diretórios do sistema.

df -h: Exibe o uso de espaço em disco de todos os sistemas de arquivos montados em formato legível para humanos.

ps aux: Lista todos os processos em execução no sistema, fornecendo detalhes como PID, uso de CPU, uso de memória (VSZ, RSS), etc.

lsof: Utilitário que significa "List Open Files" (Listar Arquivos Abertos) e é usado para ver quais arquivos estão sendo usados por quais processos. É extremamente útil para diagnosticar problemas de "target is busy".

kill: Comando para enviar um sinal a um processo (por padrão, o sinal de término SIGTERM).
