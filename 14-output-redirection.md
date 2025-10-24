# **LFCS - Questão 14: Redirecionamento de Saída**

### **Objetivo da Tarefa**

- **Entender Streams de Saída:** Diferenciar e manipular os canais de saída padrão (stdout) e de erro padrão (stderr).
- **Usar Operadores de Redirecionamento:** Utilizar operadores do shell (`>`, `2>`, `2>&1`) para controlar para onde a saída é enviada.
- **Capturar Códigos de Saída:** Salvar o código de status de um programa após sua execução.

A tarefa exige as seguintes ações com o programa `/bin/output-generator` no servidor `app-srv1`:

1. Executar o programa e redirecionar toda sua stdout para `/var/output-generator/1.out`.
2. Executar o programa e redirecionar toda sua stderr para `/var/output-generator/2.out`.
3. Executar o programa e redirecionar tanto stdout quanto stderr para `/var/output-generator/3.out`.
4. Executar o programa e escrever seu código de saída numérico em `/var/output-generator/4.out`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar ao Servidor e Criar Diretório**

bash

```
ssh app-srv1
sudo mkdir -p /var/output-generator
```

### **1.2 Inspecionar o Comportamento do Programa**

bash

```
/bin/output-generator
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Redirecionar stdout**

bash

```
/bin/output-generator > /var/output-generator/1.out
```

### **Parte 2: Redirecionar stderr**

bash

```
/bin/output-generator 2> /var/output-generator/2.out
```

### **Parte 3: Redirecionar stdout e stderr**

bash

```
/bin/output-generator > /var/output-generator/3.out 2>&1
```

### **Parte 4: Capturar o Código de Saída**

bash

```
/bin/output-generator > /dev/null 2>&1
echo $? > /var/output-generator/4.out
```

---

### **Verificação Final**

bash

```
# Conte as linhas em cada arquivowc -l /var/output-generator/1.out# ~20342 linhaswc -l /var/output-generator/2.out# ~12336 linhaswc -l /var/output-generator/3.out# ~32678 linhascat /var/output-generator/4.out# Código de saída (ex: 123)
```

---

### **Conceitos Importantes para a Prova**

- **Descritores de Arquivo:**
    - `0`: stdin
    - `1`: stdout
    - `2`: stderr
- **Operadores de Redirecionamento:**
    - `>`: Redireciona stdout
    - `2>`: Redireciona stderr
    - `2>&1`: Redireciona stderr para stdout
- **`/dev/null`:** "Buraco negro" para descartar saída
- **`$?`:** Variável com código de saída do último comando
