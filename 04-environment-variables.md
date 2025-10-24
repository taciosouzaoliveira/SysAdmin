# **LFCS - Questão 4: Variáveis de Ambiente**

### **Objetivo da Tarefa**

- **Manipular Variáveis:** Criar um script que defina e utilize variáveis de ambiente.
- **Entender Escopo:** Demonstrar a diferença entre uma variável de shell local e uma variável exportada para processos filhos.

A tarefa exige a criação de um script em `/opt/course/4/script.sh` que execute as seguintes ações:

1. Defina uma nova variável de ambiente `VARIABLE2` com o conteúdo `v2`, disponível apenas dentro do próprio script.
2. Imprima o conteúdo da variável `VARIABLE2`.
3. Defina uma nova variável de ambiente `VARIABLE3` com o conteúdo `${VARIABLE1}-extended`, que deve estar disponível no script e em todos os seus processos filhos.
4. Imprima o conteúdo da variável `VARIABLE3`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Criar o Diretório e o Arquivo de Script**

bash

```
sudo mkdir -p /opt/course/4
sudo touch /opt/course/4/script.sh
sudo chmod +x /opt/course/4/script.sh
```

### **1.2 Simular a Variável Pré-existente**

bash

```
export VARIABLE1="random-string"
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Escrever o Script**

bash

```
sudo nano /opt/course/4/script.sh
```

Adicione o seguinte conteúdo:

bash

```
#!/bin/bash
# 1. Define uma variável local, disponível apenas neste scriptVARIABLE2="v2"

# 2. Imprime o conteúdo da variável localecho $VARIABLE2

# 3. Define e EXPORTA uma variável, tornando-a disponível para processos filhosexport VARIABLE3="${VARIABLE1}-extended"

# 4. Imprime o conteúdo da variável exportadaecho $VARIABLE3
```

---

### **Verificação Final**

bash

```
/opt/course/4/script.sh
```

Saída esperada:

text

```
v2
random-string-extended
```

---

### **Conceitos Importantes para a Prova**

- **Variável Local (`NOME="valor"`):** Existe apenas no processo onde foi criada.
- **Variável Exportada (`export NOME="valor"`):** Fica disponível para o processo e todos os processos filhos.
- **Escopo de Variáveis:** O `export` não afeta o processo "pai" que chamou o script.
