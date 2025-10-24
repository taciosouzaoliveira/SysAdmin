# **LFCS - Questão 17: Configuração do OpenSSH**

### **Objetivo da Tarefa**

- **Proteger o Servidor SSH:** Alterar a configuração padrão do sshd para aumentar a segurança.
- **Configuração Condicional:** Aplicar configurações específicas para determinados usuários.

A tarefa exige as seguintes ações no arquivo de configuração do sshd no servidor `data-002`:

1. Desabilitar o `X11Forwarding` globalmente.
2. Desabilitar a `PasswordAuthentication` para todos os usuários, exceto para a usuária `marta`.
3. Habilitar um Banner (usando o arquivo `/etc/ssh/sshd-banner`) que apareça quando os usuários `marta` e `cilla` tentarem se conectar.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar ao Servidor e Criar o Arquivo de Banner**

bash

```
ssh data-002
echo "Bem-vindo ao servidor seguro. Todas as atividades são monitoradas." | sudo tee /etc/ssh/sshd-banner > /dev/null
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Editar o Arquivo de Configuração**

bash

```
sudo nano /etc/ssh/sshd_config
```

Faça as seguintes alterações:

**Configurações Globais:**

bash

```
X11Forwarding no
PasswordAuthentication no
```

**Adicione no FINAL do arquivo:**

bash

```
# Sobrescritas específicas por usuário
Match User marta
    PasswordAuthentication yes
    Banner /etc/ssh/sshd-banner

Match User cilla
    Banner /etc/ssh/sshd-banner
```

### **Parte 2: Testar e Reiniciar o Serviço SSH**

bash

```
# Teste a sintaxesudo sshd -t

# Reinicie o serviçosudo systemctl restart sshd
```

---

### **Verificação Final**

bash

```
# Teste de login com 'marta' (deve mostrar banner e pedir senha)ssh marta@data-002

# Teste de login com 'cilla' (deve mostrar banner, mas negar acesso por senha)ssh cilla@data-002

# Teste de login com outro usuário (não deve mostrar banner)ssh root@data-002
```

---

### **Conceitos Importantes para a Prova**

- **`/etc/ssh/sshd_config`:** Arquivo de configuração principal do SSH
- **`Match`:** Aplica configurações específicas para usuários/grupos
- **`X11Forwarding`:** Controla tunelamento de aplicações gráficas
- **`PasswordAuthentication`:** Controla login com senha
- **`Banner`:** Exibe mensagem antes da autenticação
- **`sshd -t`:** Testa sintaxe do arquivo de configuração
