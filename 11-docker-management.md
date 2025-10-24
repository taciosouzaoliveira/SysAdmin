# **LFCS - Questão 11: Gerenciamento de Docker**

### **Objetivo da Tarefa**

- **Gerenciar Ciclo de Vida:** Parar um contêiner em execução.
- **Inspecionar Contêineres:** Extrair informações detalhadas, como configurações de rede e volumes.
- **Criar e Executar Contêineres:** Iniciar um novo contêiner com configurações específicas.

A tarefa exige as seguintes ações:

1. Parar o contêiner Docker chamado `frontend_v1`.
2. Obter informações do contêiner `frontend_v2`:
    - Escrever seu endereço IP no arquivo `/opt/course/11/ip-address`
    - Escrever o diretório de destino do seu volume montado em `/opt/course/11/mount-destination`
3. Iniciar um novo contêiner em modo detached com:
    - Nome: `frontend_v3`
    - Imagem: `nginx:alpine`
    - Limite de Memória: 30m (30 Megabytes)
    - Mapeamento de Porta: 1234 (host) para 80 (contêiner)

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Listar Contêineres Atuais**

bash

```
# Lista os contêineres em execuçãosudo docker ps
```

### **1.2 Criar o Diretório de Destino**

bash

```
sudo mkdir -p /opt/course/11
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Parar o Contêiner frontend_v1**

bash

```
sudo docker stop frontend_v1
```

### **Parte 2: Inspecionar o Contêiner frontend_v2**

bash

```
# Extrai o endereço IPsudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' frontend_v2 > /opt/course/11/ip-address

# Extrai o diretório de destino do volumesudo docker inspect -f '{{range .Mounts}}{{.Destination}}{{end}}' frontend_v2 > /opt/course/11/mount-destination
```

### **Parte 3: Iniciar o Novo Contêiner frontend_v3**

bash

```
sudo docker run -d --name frontend_v3 --memory 30m -p 1234:80 nginx:alpine
```

---

### **Verificação Final**

bash

```
# Verifique que 'frontend_v1' está paradosudo docker ps -a

# Verifique o conteúdo dos arquivos de informaçãocat /opt/course/11/ip-address
cat /opt/course/11/mount-destination

# Verifique se o novo contêiner está em execuçãosudo docker ps

# Teste o acesso à porta mapeadacurl localhost:1234
```

---

### **Conceitos Importantes para a Prova**

- **`docker ps`:** Lista contêineres em execução
- **`docker stop`:** Para um contêiner
- **`docker inspect`:** Fornece informações detalhadas do contêiner
- **`docker run`:** Cria e inicia um novo contêiner
- **Flags do `docker run`:**
    - `d`: Executa em segundo plano
    - `-name`: Atribui nome ao contêiner
    - `-memory`: Define limite de memória
    - `p`: Mapeia porta do host para contêiner
