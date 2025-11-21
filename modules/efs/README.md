# 📁 AWS EFS Module (Terraform)

Este módulo crea un sistema de archivos **Amazon EFS** con dos mount targets en subnets privadas y un Access Point configurado específicamente para MySQL, ideal para workloads que requieren almacenamiento compartido y persistente.

---

## 🏗️ ¿Qué crea este módulo?

Este módulo provisiona:

### 📦 EFS File System
- Sistema de archivos EFS cifrado (`encrypted = true`)
- Tags personalizables
- Creation token basado en el nombre del entorno

### 🔌 Mount Targets
Crea **2 mount targets**, uno en cada subnet privada:
- `main_az1` → `private_subnet_ids[0]`
- `main_az2` → `private_subnet_ids[1]`

Ambos asociados a un Security Group definido externamente.

### 🎯 Access Point (para MySQL)
Configura:
- `uid = 1000`, `gid = 1000`
- Directorio raíz `/mysql-data`
- Permisos `755`
- Ownership adecuado para procesos MySQL

---

## 📦 Estructura del módulo

modules/
└── efs/
├── main.tf
├── variables.tf
└── outputs.tf

---

## ⚙️ Variables

| Variable               | Tipo         | Descripción                                    | Requerida |
|------------------------|--------------|------------------------------------------------|-----------|
| `environment`          | string       | Nombre del entorno de despliegue.             | No (default: `dev`) |
| `name`                 | string       | Prefijo para el nombrado de recursos.          | ✔️ |
| `private_subnet_ids`   | list(string) | Subnets privadas donde crear los mount targets.| ✔️ |
| `efs_security_group_id`| string       | Security Group asignado al EFS.               | ✔️ |
| `tags`                 | map(string)  | Tags adicionales.                              | No |

---

## 📤 Outputs

| Output             | Descripción |
|-------------------|-------------|
| `file_system_id`  | ID del sistema de archivos EFS. |
| `access_point_id` | ID del Access Point para MySQL. |

---

## 🚀 Ejemplo de uso

```hcl
module "efs" {
  source = "./modules/efs"

  environment          = "dev"
  name                 = "lab3"
  private_subnet_ids   = module.network.private_subnets
  efs_security_group_id = module.sg_efs.id

  tags = {
    Owner       = "magui"
    Application = "mysql-storage"
  }
}

🔒 Seguridad

EFS cifrado en reposo.

Accesible solo a través del Security Group especificado.

Mount Targets ubicados exclusivamente en subnets privadas.

Access Point con permisos adecuados para MySQL, evitando problemas de permisos dentro del contenedor.

📝 Notas

Este módulo asume que existen al menos dos subnets privadas.

No crea el Security Group; debe ser pasado como parámetro.

El Access Point facilita el montaje seguro desde ECS o EC2, recomendado para tareas con usuario no root.