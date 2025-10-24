# **LFCS - Questão 19: Regex (Expressões Regulares) para Filtrar Logs**

### **Objetivo da Tarefa**

- **Filtragem de Texto:** Usar `grep` com expressões regulares para extrair linhas específicas de arquivos de log.
- **Busca e Substituição:** Usar `sed` com regex para encontrar e substituir linhas.

A tarefa exige as seguintes ações no servidor `web-srv1`:

1. No arquivo `/var/log-collector/003/nginx.log`: Extrair todas as linhas onde URLs começam com `/app/user` e que foram acessadas por browser identity `hacker-bot/1.2`. Salvar o resultado em `/var/log-collector/003/nginx.log.extracted`.
2. No arquivo `/var/log-collector/003/server.log`: Substituir todas as linhas começando com `container.web`, terminando com `24h` e contendo `Running` no meio por: `SENSITIVE LINE REMOVED`.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar e Inspecionar os Arquivos**

bash

```
ssh web-srv1
cd /var/log-collector/003
head nginx.log
head server.log
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Extrair Linhas do nginx.log**

bash

```
grep -E "/app/user.*hacker-bot/1.2" nginx.log > nginx.log.extracted
```

### **Parte 2: Substituir Linhas no server.log**

bash

```
# Faça backup primeirocp server.log server.log.bak

# Substitua as linhas sensíveissed -i 's/^container\.web.*Running.*24h$/SENSITIVE LINE REMOVED/g' server.log
```

---

### **Verificação Final**

bash

```
# Verifique a extraçãowc -l nginx.log.extracted# Deve ser 27 linhas# Verifique a substituiçãogrep "SENSITIVE LINE REMOVED" server.log | wc -l# Deve ser 44 linhas
```

---

### **Conceitos Importantes para a Prova**

- **`grep -E`:** Habilita expressões regulares estendidas
- **`sed -i`:** Edita arquivo in-place
- **Regex Básica:**
    - `^`: Início da linha
    - `$`: Fim da linha
    - `.*`: Qualquer sequência de caracteres
    - `\.`: Ponto literal (escapado)
- **Padrão:** `^container\.web.*Running.*24h$`
