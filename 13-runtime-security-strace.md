# **LFCS - Questão 13: Segurança de Processos em Tempo de Execução**

### **Objetivo da Tarefa**

- **Análise de Processos:** Inspecionar processos em execução em tempo real para identificar atividades suspeitas.
- **Uso de Ferramentas de Diagnóstico:** Utilizar `strace` para monitorar as chamadas de sistema feitas por um processo.
- **Ação de Remediação:** Finalizar um processo malicioso e remover seu executável.

A tarefa exige as seguintes ações no servidor `web-srv1`:

1. Investigar os três processos em execução: `collector1`, `collector2`, e `collector3`.
2. Identificar qual(is) deles está(ão) executando a chamada de sistema proibida `kill`.
3. Para o(s) processo(s) infrator(es), finalizar sua execução e apagar o arquivo executável correspondente.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Conectar ao Servidor e Listar os Processos**

bash

```
ssh web-srv1
ps aux | grep collector
```

Anote os PIDs dos processos `collector1`, `collector2` e `collector3`.

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Inspecionar os Processos com strace**

bash

```
# Inspecione cada processo (substitua <PID> pelos IDs reais)sudo strace -p <PID_collector1># Nenhuma chamada 'kill'sudo strace -p <PID_collector2># Mostra 'kill' → INFRATORsudo strace -p <PID_collector3># Nenhuma chamada 'kill'
```

### **Parte 2: Finalizar o Processo e Remover o Executável**

bash

```
# Use o PID do collector2 identificadosudo kill <PID_collector2>

# Remova o executávelsudo rm /bin/collector2
```

---

### **Verificação Final**

bash

```
# Procure pelo processo novamenteps aux | grep collector2

# Tente listar o arquivo executávells /bin/collector2# Deve retornar erro
```

---

### **Conceitos Importantes para a Prova**

- **`ps aux`:** Lista todos os processos em execução
- **`strace`:** Rastreia chamadas de sistema de um processo
- **`p <PID>`:** Anexa strace a processo em execução
- **`kill <PID>`:** Envia sinal para finalizar processo
- **Syscall:** Chamada de sistema do kernel
