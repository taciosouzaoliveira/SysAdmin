# **LFCS - Questão 18: Armazenamento com LVM**

### **Objetivo da Tarefa**

- **Gerenciar Volume Groups (VG):** Reduzir um VG existente removendo um disco e criar um novo VG.
- **Gerenciar Logical Volumes (LV):** Criar um novo LV com um tamanho específico.
- **Criar Sistema de Arquivos:** Formatar um LV recém-criado.

A tarefa exige as seguintes ações de gerenciamento de LVM:

1. Reduzir o Volume Group `vol1` removendo o disco `/dev/vdh` dele.
2. Criar um novo Volume Group chamado `vol2` que utilize o disco `/dev/vdh`.
3. Criar um Logical Volume de 50M chamado `p1` dentro do `vol2`.
4. Formatar o novo volume lógico `p1` com o sistema de arquivos ext4.

---

### **1. Preparando o Ambiente no Lab**

### **1.1 Inspecionar a Configuração LVM**

bash

```
# Liste os Physical Volumes
sudo pvs

# Liste os Volume Groups
sudo vgs

# Liste os Logical Volumes
sudo lvs
```

---

### **2. Resolvendo a Questão: Passo a Passo**

### **Parte 1: Reduzir o Volume Group vol1**

bash

```
sudo vgreduce vol1 /dev/vdh
```

### **Parte 2: Criar o Volume Group vol2**

bash

```
sudo vgcreate vol2 /dev/vdh
```

### **Parte 3: Criar o Logical Volume p1**

bash

```
sudo lvcreate -L 50M -n p1 vol2
```

### **Parte 4: Formatar o Novo Logical Volume**

bash

```
sudo mkfs.ext4 /dev/vol2/p1
```

---

### **Verificação Final**

bash

```
# Verifique se /dev/vdh pertence a 'vol2'sudo pvs

# Verifique se os VGs foram configurados corretamente
sudo vgs

# Verifique se o novo LV existe
sudo lvs

# Verifique o sistema de arquivos
sudo blkid /dev/vol2/p1
```

---

### **Conceitos Importantes para a Prova**

- **Hierarquia LVM:**
    - PV (Physical Volume): Disco físico
    - VG (Volume Group): Pool de storage
    - LV (Logical Volume): "Partição" virtual
- **Comandos LVM:**
    - `pvs`, `vgs`, `lvs`: Listam componentes
    - `vgreduce`: Remove PV do VG
    - `vgcreate`: Cria novo VG
    - `lvcreate`: Cria novo LV
- **Caminho do LV:** `/dev/<vg_name>/<lv_name>`
