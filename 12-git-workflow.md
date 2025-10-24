# **LFCS - Questão 12: Fluxo de Trabalho com Git**

### **Objetivo da Tarefa**

- **Gerenciar Repositório:** Clonar um repositório Git.
- **Trabalhar com Branches:** Inspecionar o conteúdo de diferentes branches, identificar a correta e mesclá-la na branch principal.
- **Versionar Alterações:** Criar um novo diretório, garantir que ele seja versionado e salvar as alterações com commit.

A tarefa exige as seguintes ações:

1. Clonar o repositório `/repositories/auto-verifier` para `/home/candidate/repositories/auto-verifier`.
2. Dentre as branches `dev4`, `dev5` e `dev6`, encontrar aquela em que o arquivo `config.yaml` contém a linha `user_registration_level: open`.
3. Fazer o merge apenas da branch encontrada para a branch `main`.
4. Na branch `main`, criar um novo diretório chamado `Logs` e, dentro dele, um arquivo oculto e vazio chamado `.keep`.
5. Fazer o commit da alteração com a mensagem "added log directory".

---

### **1. Preparando o Ambiente no Lab**

A primeira etapa da resolução é a clonagem que prepara o ambiente de trabalho.

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Clonar o Repositório**

bash

```
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier
cd /home/candidate/repositories/auto-verifier
```

### **Parte 2: Encontrar e Mesclar a Branch Correta**

bash

```
# Liste todas as branchesgit branch -a

# Verifique cada branchgit checkout dev4
grep "user_registration_level" config.yaml# Saída: closedgit checkout dev5
grep "user_registration_level" config.yaml# Saída: open → ENCONTRAMOS!git checkout dev6
grep "user_registration_level" config.yaml# Saída: closed# Volte para main e faça o mergegit checkout main
git merge dev5
```

### **Parte 3: Criar o Novo Diretório e Arquivo**

bash

```
mkdir Logs
touch Logs/.keep
```

### **Parte 4: Fazer o Commit da Alteração**

bash

```
git add Logs
git commit -m "added log directory"
```

---

### **Verificação Final**

bash

```
# Verifique se a alteração do merge está presentegrep "user_registration_level" config.yaml

# Verifique o status do gitgit status

# Verifique o histórico de commitsgit log -1
```

---

### **Conceitos Importantes para a Prova**

- **`git clone`:** Cria cópia local de repositório
- **`git branch -a`:** Lista todas as branches
- **`git checkout`:** Muda para branch especificada
- **`git merge`:** Traz alterações de uma branch para outra
- **`git add`:** Adiciona arquivos à staging area
- **`git commit`:** Salva alterações no histórico
