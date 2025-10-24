# **LFCS - Questão 16: Load Balancer (Balanceador de Carga)**

### **Objetivo da Tarefa**

- **Proxy Reverso:** Usar Nginx como um proxy reverso para redirecionar tráfego para aplicações internas.
- **Balanceamento de Carga:** Configurar o Nginx para distribuir requisições entre múltiplos servidores de backend.

A tarefa exige a criação de um Load Balancer HTTP no servidor `web-srv1` que:

1. Escute na porta 8001 e redirecione todo o tráfego para `192.168.10.60:2222/special`.
2. Escute na porta 8000 e balanceie o tráfego entre `192.168.10.60:1111` e `192.168.10.60:2222` no modo Round Robin.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Verificar as Aplicações de Backend**

bash

```
# Conecte-se ao servidor web-srv1ssh web-srv1

# Teste o acesso às aplicaçõescurl localhost:1111# Saída: app1curl localhost:2222# Saída: app2curl localhost:2222/special# Saída: app2 special
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Criar o Arquivo de Configuração do Nginx**

bash

```
# Crie um novo arquivo de configuraçãosudo nano /etc/nginx/sites-available/load-balancer.conf
```

Adicione o seguinte conteúdo:

nginx

```
# Define o grupo de servidores para balanceamentoupstream backend {
    server 192.168.10.60:1111;# app1server 192.168.10.60:2222;# app2}

# Balanceamento na porta 8000server {
    listen 8000;
    server_name _;

    location / {
        proxy_pass http://backend;
    }
}

# Redirecionamento na porta 8001server {
    listen 8001;
    server_name _;

    location / {
        proxy_pass http://192.168.10.60:2222/special;
    }
}
```

### **Parte 2: Habilitar a Configuração e Recarregar o Nginx**

bash

```
# Crie link simbólico para sites-enabledsudo ln -s /etc/nginx/sites-available/load-balancer.conf /etc/nginx/sites-enabled/

# Teste a sintaxesudo nginx -t

# Recarregue o serviçosudo systemctl reload nginx
```

---

### **Verificação Final**

bash

```
# Teste o balanceamento (deve alternar entre app1 e app2)curl http://web-srv1:8000
curl http://web-srv1:8000
curl http://web-srv1:8000

# Teste o redirecionamento (sempre app2 special)curl http://web-srv1:8001
curl http://web-srv1:8001/qualquer/caminho
```

---

### **Conceitos Importantes para a Prova**

- **`upstream`:** Define grupo de servidores backend
- **`proxy_pass`:** Diretiva para redirecionar requisições
- **Round Robin:** Método de balanceamento padrão do Nginx
- **`nginx -t`:** Testa sintaxe da configuração
- **`sites-available/sites-enabled`:** Organização de configurações do Nginx
