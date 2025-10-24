# **LFCS - Questão 15: Compilar e Instalar a partir do Código-Fonte**

### **Objetivo da Tarefa**

- **Compilação de Software:** Entender e executar o processo padrão de compilação e instalação de um programa a partir de seu código-fonte.
- **Configuração de Build:** Utilizar o script `configure` para personalizar a instalação.

A tarefa exige as seguintes ações no servidor `app-srv1`:

1. Utilizar o código-fonte do navegador `links2`, fornecido em `/tools/links-2.14.tar.bz2`.
2. Configurar o processo de instalação para que o binário principal seja instalado em `/usr/bin/links`.
3. Configurar o processo para que o suporte a IPv6 seja desabilitado.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar e Extrair o Código-Fonte**

bash

```
ssh app-srv1
cd /tools
sudo tar xjf links-2.14.tar.bz2
cd links-2.14
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Configurar o Build**

bash

```
./configure --prefix=/usr --without-ipv6
```

### **Parte 2: Compilar o Código**

bash

```
make
```

### **Parte 3: Instalar o Programa**

bash

```
sudo make install
```

---

### **Verificação Final**

bash

```
# Verifique se o programa foi instaladowhereis links

# Verifique a versão
/usr/bin/links -version

# Verifique se IPv6 está desabilitado
/usr/bin/links -lookup ip6-localhost# Deve falhar
```

---

### **Conceitos Importantes para a Prova**

- **Fluxo de Compilação:** `./configure`, `make`, `sudo make install`
- **`./configure`:** Gera Makefile customizado
- **`-prefix=/usr`:** Define diretório base de instalação
- **`-without-ipv6`:** Desabilita funcionalidade específica
- **`make`:** Executa processo de compilação
- **`make install`:** Instala arquivos compilados
