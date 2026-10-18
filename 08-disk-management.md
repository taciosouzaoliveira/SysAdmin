# **LFCS - Questão 8: Gerenciamento de Discos**

### **Objetivo da Tarefa**

- **Formatar e Montar Discos:** Criar um novo sistema de arquivos em um disco, montá-lo e criar um arquivo.
- **Gerenciar Espaço em Disco:** Identificar o disco com maior uso e liberar espaço nele.
- **Lidar com Discos Ocupados:** Identificar um processo que está utilizando um ponto de montagem, finalizá-lo e desmontar o disco.

A tarefa exige a execução das seguintes ações:

1. Formatar o disco `/dev/vdb` com ext4, montá-lo em `/mnt/backup-black` e criar o arquivo `/mnt/backup-black/completed`.
2. Verificar qual dos discos, `/dev/vdc` ou `/dev/vdd`, tem maior uso de armazenamento e esvaziar a pasta de lixo (`.trash`) nele.
3. Identificar qual dos processos, `dark-matter-v1` ou `dark-matter-v2`, consome mais memória, descobrir em qual disco o executável está localizado e desmontar esse disco.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Inspecionar os Discos Existentes**

bash

```
# Lista os dispositivos de bloco
lsblk -f

# Mostra o uso de espaço em disco
df -h
```

### **1.2 Inspecionar os Processos em Execução**

bash

```
# Lista os processos dark-matterps aux | grep dark-matter
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Formatar e Montar /dev/vdb**

bash

```
# Cria sistema de arquivos ext4sudo mkfs.ext4 /dev/vdb

# Cria diretório de montagem
sudo mkdir -p /mnt/backup-black

# Monta o disco
sudo mount /dev/vdb /mnt/backup-black

# Cria arquivo de verificação
sudo touch /mnt/backup-black/completed
```

### **Parte 2: Limpar o Disco Mais Cheio**

bash

```
# Verifica uso dos discos
df -h | grep /dev/vd[cd]

# Identifica o ponto de montagem do disco mais cheio
# Supondo que seja /mnt/backup001sudo rm -rf /mnt/backup001/.trash/*
```

### **Parte 3: Desmontar o Disco em Uso**

bash

```
# Identifica o processo com maior consumo de memóriaps aux | grep dark-matter

# Tenta desmontar (deve falhar)
sudo umount /mnt/app-4e9d7e1e

# Identifica processo bloqueador
sudo lsof | grep /mnt/app-4e9d7e1e

# Finaliza o processo
sudo kill <PID_do_dark-matter-v2>

# Desmonta o disco
sudo umount /mnt/app-4e9d7e1e
```

---

### **Verificação Final**

bash

```
# Verifique se o novo disco está montado
df -h | grep /mnt/backup-black

# Verifique se o espaço foi liberado
df -h

# Verifique se o disco foi desmontado
df -h | grep /mnt/app-4e9d7e1e
```

---

### **Conceitos Importantes para a Prova**

- **`mkfs.ext4`:** Cria sistema de arquivos ext4
- **`mount`/`umount`:** Monta/desmonta sistemas de arquivos
- **`df -h`:** Exibe uso de espaço em disco
- **`ps aux`:** Lista processos em execução
- **`lsof`:** Lista arquivos abertos por processos
