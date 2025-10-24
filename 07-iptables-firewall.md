# **LFCS - Questão 7: Filtro de Pacotes de Rede (Firewall)**

### **Objetivo da Tarefa**

- **Filtrar Tráfego:** Implementar regras de firewall para controlar o tráfego de rede de entrada e saída.
- **Manipular Pacotes:** Usar iptables para bloquear, redirecionar e permitir tráfego com base em portas e endereços IP.

A tarefa exige a implementação das seguintes regras de firewall na interface `eth0` do servidor `data-002`:

1. Fechar a porta 5000 para tráfego externo.
2. Redirecionar todo o tráfego que chega na porta 6000 para a porta local 6001.
3. Permitir que a porta 6002 seja acessível apenas pelo IP 192.168.10.80 (servidor data-001).
4. Bloquear todo o tráfego de saída para o IP 192.168.10.70 (servidor app-srv1).

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Verificar a Conectividade Atual**

bash

```
# De um servidor remoto, teste o acesso às portascurl data-002:5000
curl data-002:6001
curl data-002:6002
```

### **1.2 Inspecionar as Regras de Firewall Existentes**

bash

```
# Conecte-se ao servidor data-002ssh data-002

# Liste as regras atuaissudo iptables -L
sudo iptables -t nat -L
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Fechar a Porta 5000**

bash

```
sudo iptables -A INPUT -p tcp --dport 5000 -j DROP
```

### **Parte 2: Redirecionar a Porta 6000 para 6001**

bash

```
sudo iptables -t nat -A PREROUTING -p tcp --dport 6000 -j REDIRECT --to-port 6001
```

### **Parte 3: Restringir o Acesso à Porta 6002**

bash

```
# Primeiro permita o IP específicosudo iptables -A INPUT -p tcp --dport 6002 -s 192.168.10.80 -j ACCEPT

# Depois bloqueie todo o restosudo iptables -A INPUT -p tcp --dport 6002 -j DROP
```

### **Parte 4: Bloquear Tráfego de Saída**

bash

```
sudo iptables -A OUTPUT -d 192.168.10.70 -j DROP
```

---

### **Verificação Final**

bash

```
# Liste as regras aplicadassudo iptables -L
sudo iptables -t nat -L

# Teste o acesso às portascurl data-002:5000# Deve falharcurl data-002:6000# Deve retornar conteúdo da porta 6001curl data-002:6002# Deve falhar (exceto do data-001)
```

---

### **Conceitos Importantes para a Prova**

- **`iptables`:** Ferramenta para configurar firewall Netfilter
- **Tabelas:**
    - `filter`: Tabela padrão (INPUT, OUTPUT, FORWARD)
    - `nat`: Para tradução de endereços (PREROUTING, POSTROUTING)
- **Ações:**
    - `ACCEPT`: Permite pacote
    - `DROP`: Descarta pacote
    - `REDIRECT`: Redireciona para porta local
