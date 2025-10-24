# **LFCS - Questão 3: Sincronização de Horário (NTP)**

### **Objetivo da Tarefa**

- **Configurar Servidores NTP:** Atualizar a configuração do systemd-timesyncd para usar servidores NTP específicos.
- **Ajustar Parâmetros:** Definir intervalos de consulta e de nova tentativa de conexão.

A tarefa exige as seguintes configurações no servidor `terminal`:

1. Definir `0.pool.ntp.org` e `1.pool.ntp.org` como servidores NTP principais.
2. Definir `ntp.ubuntu.com` e `0.debian.pool.ntp.org` como servidores NTP de fallback (reserva).
3. Definir o intervalo máximo de consulta (`PollIntervalMaxSec`) para 1000 segundos e a tentativa de reconexão (`ConnectionRetrySec`) para 20 segundos.

---

### **1. Preparando o Ambiente no Lab**

Para esta tarefa, não é preciso criar arquivos ou usuários. A preparação consiste em inspecionar o estado atual do serviço de sincronização de tempo.

### **1.1 Verificar o Status Atual**

bash

```
timedatectl
```

Isso mostrará se o serviço systemd-timesyncd está ativo e se o relógio do sistema está sincronizado.

### **1.2 Inspecionar a Configuração Existente**

bash

```
cat /etc/systemd/timesyncd.conf
```

---

### **2. Resolvendo a Questão: Passo a Passo**

A solução envolve editar o arquivo de configuração e reiniciar o serviço para aplicar as novas diretivas.

### **Parte 1: Editar o Arquivo de Configuração**

bash

```
sudo nano /etc/systemd/timesyncd.conf
```

Adicione ou edite as linhas na seção `[Time]`:

ini

```
[Time]NTP=0.pool.ntp.org 1.pool.ntp.org
FallbackNTP=ntp.ubuntu.com 0.debian.pool.ntp.org
PollIntervalMaxSec=1000
ConnectionRetrySec=20
```

Salve e feche o arquivo.

### **Parte 2: Reiniciar o Serviço**

bash

```
sudo systemctl restart systemd-timesyncd
```

---

### **Verificação Final**

Verifique o status do serviço para confirmar que está funcionando corretamente:

bash

```
sudo systemctl status systemd-timesyncd
```

A saída deve mostrar `Active: active (running)` e nos logs você deve ver uma mensagem indicando sincronização com um dos novos servidores configurados.

---

### **Conceitos Importantes para a Prova**

- **systemd-timesyncd:** Serviço do systemd responsável por sincronizar o relógio do sistema com servidores NTP.
- **`/etc/systemd/timesyncd.conf`:** Arquivo de configuração principal.
- **Diretivas:**
    - `NTP=`: Define servidores NTP principais
    - `FallbackNTP=`: Define servidores de reserva
    - `PollIntervalMaxSec=`: Intervalo máximo de consulta
    - `ConnectionRetrySec=`: Tempo de tentativa de reconexão
