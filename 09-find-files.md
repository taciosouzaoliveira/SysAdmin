# **LFCS - Questão 9: Encontrar Arquivos com Propriedades e Executar Ações**

### **Objetivo da Tarefa**

- **Busca Avançada de Arquivos:** Utilizar o comando `find` com diferentes critérios (data, tamanho, permissão) para localizar arquivos específicos.
- **Executar Ações em Lote:** Executar comandos (`rm`, `mv`) nos arquivos encontrados para automatizar a organização e limpeza.

A tarefa exige as seguintes ações no diretório `/var/backup/backup-015` do servidor `data-001`:

1. Deletar todos os arquivos modificados antes de 01/01/2020.
2. Mover todos os arquivos restantes que são menores que 3KiB para o subdiretório `small/`.
3. Mover todos os arquivos restantes que são maiores que 10KiB para o subdiretório `large/`.
4. Mover todos os arquivos restantes que têm permissão 777 para o subdiretório `compromised/`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar e Criar Diretórios de Destino**

bash

```
# Conecte-se ao servidor data-001ssh data-001

# Navegue até o diretório de backupcd /var/backup/backup-015

# Crie os subdiretóriossudo mkdir small large compromised
```

### **1.2 Inspecionar o Diretório**

bash

```
# Conte o número total de arquivosls | wc -l
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Deletar Arquivos Antigos**

bash

```
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -exec rm {} \;
```

### **Parte 2: Mover Arquivos Pequenos (< 3KiB)**

bash

```
find . -maxdepth 1 -type f -size -3k -exec mv {} ./small/ \;
```

### **Parte 3: Mover Arquivos Grandes (> 10KiB)**

bash

```
find . -maxdepth 1 -type f -size +10k -exec mv {} ./large/ \;
```

### **Parte 4: Mover Arquivos com Permissão 777**

bash

```
find . -maxdepth 1 -type f -perm 777 -exec mv {} ./compromised/ \;
```

---

### **Verificação Final**

bash

```
# Conte os arquivos em cada diretóriols | wc -l
ls small/ | wc -l
ls large/ | wc -l
ls compromised/ | wc -l
```

---

### **Conceitos Importantes para a Prova**

- **`find`:** Ferramenta principal para localizar arquivos
- **Predicados:**
    - `maxdepth 1`: Limita busca ao diretório atual
    - `type f`: Apenas arquivos regulares
    - `! -newermt "DATE"`: Arquivos mais antigos que a data
    - `size [-|+]N[k|M|G]`: Filtra por tamanho
    - `perm MODE`: Filtra por permissões
- **`exec COMANDO {} \;`:** Executa comando para cada arquivo encontrado
