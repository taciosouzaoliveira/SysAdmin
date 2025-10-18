LFCS - Questão 18: Armazenamento com LVM
Objetivo da Tarefa
Gerenciar Volume Groups (VG): Reduzir um VG existente removendo um disco e criar um novo VG.

Gerenciar Logical Volumes (LV): Criar um novo LV com um tamanho específico.

Criar Sistema de Arquivos: Formatar um LV recém-criado para que possa ser usado pelo sistema.

A tarefa exige a execução das seguintes ações de gerenciamento de LVM:

Reduzir o Volume Group vol1 removendo o disco (Physical Volume) /dev/vdh dele.

Criar um novo Volume Group chamado vol2 que utilize o disco /dev/vdh.

Criar um Logical Volume de 50M chamado p1 dentro do vol2.

Formatar o novo volume lógico p1 com o sistema de arquivos ext4.

1. Preparando o Ambiente no Lab
A preparação envolve inspecionar a configuração atual do LVM para entender a estrutura de Physical Volumes (PV), Volume Groups (VG) e Logical Volumes (LV).

1.1 Inspecionar a Configuração LVM
Bash

# Liste os Physical Volumes para ver a quais VGs eles pertencem
sudo pvs

# Liste os Volume Groups para ver seu tamanho e quais PVs eles contêm
sudo vgs -o +devices

# Liste os Logical Volumes
sudo lvs
A partir dessa inspeção, você confirmará que /dev/vdh faz parte do VG vol1.

2. Resolvendo a Questão: Passo a Passo
A solução envolve uma sequência de comandos vg... e lv... para manipular a estrutura do LVM.

Parte 1: Reduzir o Volume Group vol1
Bash

# Remove o Physical Volume /dev/vdh do Volume Group vol1
sudo vgreduce vol1 /dev/vdh
Parte 2: Criar o Volume Group vol2
Agora que o disco /dev/vdh está livre, podemos usá-lo para criar um novo VG.

Bash

# Cria um novo VG chamado 'vol2' usando o PV /dev/vdh
sudo vgcreate vol2 /dev/vdh
Parte 3: Criar o Logical Volume p1
Crie um LV de 50MB a partir do espaço disponível no novo VG vol2.

Bash

# -L: especifica o tamanho (Size)
# -n: especifica o nome (name)
# A sintaxe é lvcreate [opções] <NomeDoVG>
sudo lvcreate -L 50M -n p1 vol2
Parte 4: Formatar o Novo Logical Volume
O novo LV está disponível no sistema através de um caminho em /dev/.

Bash

# O caminho para o LV é /dev/<nome_do_vg>/<nome_do_lv>
sudo mkfs.ext4 /dev/vol2/p1
Verificação Final
Use os comandos de listagem do LVM para verificar se cada etapa foi concluída com sucesso.

Bash

# Verifique se /dev/vdh agora pertence a 'vol2'
sudo pvs

# Verifique se 'vol1' foi reduzido e se 'vol2' foi criado
sudo vgs

# Verifique se o novo LV 'p1' existe dentro de 'vol2'
sudo lvs

# Verifique se o sistema de arquivos foi criado corretamente no LV
sudo blkid /dev/vol2/p1
# A saída deve conter a informação TYPE="ext4"
Conceitos Importantes para a Prova
LVM (Logical Volume Manager): Uma camada de abstração sobre os discos físicos que permite um gerenciamento de armazenamento flexível.

Hierarquia LVM:

PV (Physical Volume): Um disco físico ou partição (/dev/sda1, /dev/vdb) inicializado para uso do LVM.

VG (Volume Group): Um "pool" de armazenamento composto por um ou mais PVs.

LV (Logical Volume): Uma "partição" virtual criada a partir de um VG, que é o que o sistema operacional de fato usa.

Comandos LVM: A nomenclatura é intuitiva.

pv...: Comandos para gerenciar PVs (ex: pvs, pvcreate).

vg...: Comandos para gerenciar VGs (ex: vgs, vgcreate, vgreduce).

lv...: Comandos para gerenciar LVs (ex: lvs, lvcreate, lvresize).

Caminho do LV: Os LVs são acessíveis através do device mapper em /dev/mapper/<vg_name>-<lv_name> ou do atalho /dev/<vg_name>/<lv_name>.

