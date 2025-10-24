# **LFCS - Questão 5: Arquivos Compactados e Compressão**

### **Objetivo da Tarefa**

- **Manipular Arquivos:** Descompactar um arquivo `.tar.bz2` e re-compactá-lo usando um algoritmo de compressão diferente (gzip).
- **Verificar Integridade:** Garantir que o conteúdo do arquivo original e do novo arquivo seja idêntico.

A tarefa exige as seguintes ações no servidor `data-001`:

1. Usar o arquivo original `/imports/import001.tar.bz2`.
2. Criar um novo arquivo `/imports/import001.tar.gz` com o mesmo conteúdo, utilizando a melhor compressão gzip possível.
3. Listar o conteúdo de ambos os arquivos, ordenar a lista e salvá-la em `/imports/import001.tar.bz2_list` e `/imports/import001.tar.gz_list`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Criar o Arquivo de Exemplo**

bash

```
# Conecte-se ao servidor data-001ssh data-001

# Crie a estrutura de diretórios e arquivos de exemplosudo mkdir -p /imports/source_files/dir1
sudo touch /imports/source_files/file1.txt
sudo touch /imports/source_files/dir1/file2.txt

# Crie o arquivo .tar.bz2 inicialsudo tar cjf /imports/import001.tar.bz2 -C /imports/source_files .

# Limpe os arquivos de origemsudo rm -rf /imports/source_files
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Extrair o Conteúdo Original**

bash

```
sudo mkdir /imports/temp_extract
sudo tar xjf /imports/import001.tar.bz2 -C /imports/temp_extract
```

### **Parte 2: Criar o Novo Arquivo .tar.gz**

bash

```
sudo tar czf /imports/import001.tar.gz --gzip:best -C /imports/temp_extract .
```

### **Parte 3: Limpar o Ambiente**

bash

```
sudo rm -rf /imports/temp_extract
```

### **Parte 4: Verificar Integridade**

bash

```
sudo tar tjf /imports/import001.tar.bz2 | sort > /imports/import001.tar.bz2_list
sudo tar tzf /imports/import001.tar.gz | sort > /imports/import001.tar.gz_list
diff /imports/import001.tar.bz2_list /imports/import001.tar.gz_list
```

---

### **Conceitos Importantes para a Prova**

- **`tar`:** Ferramenta para criar e manipular arquivos de arquivamento.
- **Operações:**
    - `c`: criar
    - `x`: extrair
    - `t`: listar
    - `f`: arquivo
- **Filtros de Compressão:**
    - `z`: gzip
    - `j`: bzip2
- **`C <DIRETÓRIO>`:** Muda para o diretório antes de executar a operação.
