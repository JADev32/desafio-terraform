
---

# 📦 Módulo: `ecs-service-mysql`

Este módulo crea un **servicio ECS de MySQL** ejecutándose en **EC2 Launch Type**, utilizando **EFS para persistencia**, **variables de entorno para inicialización**, y **Service Discovery con Cloud Map**.

Incluye:

* `aws_ecs_task_definition`
* `aws_ecs_service`
* Persistencia con EFS
* Registro en Cloud Map
* Salidas (outputs) útiles para consumir desde otros módulos

---

## 🏗️ Recursos que crea

### ### 1. `aws_ecs_task_definition.mysql_task`

Task Definition configurada para ejecutar MySQL con:

* **Network Mode:** `awsvpc`
* **Launch Type:** EC2
* **EFS Volume:** Montado en `/var/lib/mysql`
* **Variables de entorno**:

  * `MYSQL_DATABASE=app_db`
  * `MYSQL_ROOT_PASSWORD=password`
* **CPU:** `256`
* **Memoria:** `512`
* **Imagen:** provista por la variable `mysql_image`

### 2. `aws_ecs_service.mysql_service`

Servicio ECS con:

* `desired_count = 1` (una sola instancia de MySQL)
* Implementado en las **subnets privadas**
* Con **Security Group específico** para la DB
* Registrado en **Cloud Map** via `service_registries`
* Conectado al cluster ECS pasado por variable

---

---

# ⚙️ Variables

| Variable                      | Tipo         | Descripción                                       |
| ----------------------------- | ------------ | ------------------------------------------------- |
| `name`                        | string       | Prefijo para nombrar recursos.                    |
| `cluster_name`                | string       | Nombre del cluster ECS donde se desplegará MySQL. |
| `private_subnets`             | list(string) | Subnets privadas para ejecutar la tarea ECS.      |
| `sg_db_id`                    | string       | Security Group para la DB.                        |
| `efs_id`                      | string       | ID del EFS para almacenar datos de MySQL.         |
| `ecs_task_execution_role_arn` | string       | ARN del ECS Task Execution Role.                  |
| `mysql_image`                 | string       | Imagen Docker de MySQL a usar.                    |
| `service_registry_arn`        | string       | ARN de Cloud Map para service discovery.          |

---

# 📤 Outputs

| Output                      | Descripción                         |
| --------------------------- | ----------------------------------- |
| `mysql_service_name`        | Nombre del servicio ECS creado.     |
| `mysql_task_definition_arn` | ARN de la Task Definition generada. |

---

## 📘 Ejemplo de uso

```hcl
module "mysql_service" {
  source = "./modules/ecs-service-mysql"

  name                         = "lab3"
  cluster_name                 = module.cluster.cluster_name
  private_subnets              = module.network.private_subnets
  sg_db_id                     = aws_security_group.mysql_sg.id
  efs_id                       = aws_efs_file_system.mysql.id
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution.arn
  mysql_image                  = "mysql/mysql-server:8.0"
  service_registry_arn         = aws_service_discovery_service.mysql.arn
}
```

