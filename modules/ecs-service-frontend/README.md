
# 📦 Módulo: `ecs-service-frontend`

Este módulo despliega un **servicio ECS de frontend** ejecutándose en **EC2 Launch Type a través de un Capacity Provider**, integrado con un **Application Load Balancer (ALB)**, usando **Secrets Manager** para las credenciales de la base de datos.

Incluye:

* `aws_ecs_task_definition`
* `aws_ecs_service`
* Integración con ALB
* Uso de Secrets Manager
* Outputs útiles para consumir desde otros módulos

---

## 🏗️ Recursos que crea

### ### 1. `aws_ecs_task_definition.frontend_task`

Task Definition configurada para:

* **Network Mode:** `awsvpc`
* **Launch Type:** EC2 (a través de capacity provider)
* **Secretos inyectados desde Secrets Manager**:

  * `DATABASE_HOST`
  * `DATABASE_NAME`
  * `DATABASE_USER`
  * `DATABASE_PASSWORD`
* **Imagen obtenida desde ECR**
* **CPU:** `256`
* **Memoria:** `256`
* Exposición del container en el **puerto 80**

### 2. `aws_ecs_service.frontend_service`

Servicio ECS configurado con:

* `desired_count = 2`
* Estrategia de capacity provider:

  ```hcl
  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 1
  }
  ```
* Registro en el **Target Group del ALB**
* Despliegue en **subnets privadas**
* Security Group específico del frontend

---

# ⚙️ Variables

| Variable                      | Tipo              | Descripción                                            |
| ----------------------------- | ----------------- | ------------------------------------------------------ |
| `name`                        | string            | Prefijo para los nombres de recursos.                  |
| `cluster_name`                | string            | Cluster ECS donde se despliega el frontend.            |
| `capacity_provider_name`      | string            | Nombre del capacity provider utilizado.                |
| `private_subnets`             | list(string)      | Subnets privadas donde corre el servicio.              |
| `sg_frontend_id`              | string            | Security Group del servicio frontend.                  |
| `target_group_arn`            | string            | Target Group del ALB para enrutar tráfico al frontend. |
| `ecr_repo_url`                | string            | URL del repositorio ECR del frontend.                  |
| `image_tag`                   | string            | Tag de la imagen del frontend.                         |
| `ecs_task_execution_role_arn` | string            | Rol de ejecución de ECS.                               |
| `db_host_arn`                 | string            | Secreto con hostname de la DB.                         |
| `db_name_arn`                 | string            | Secreto con el nombre de la DB.                        |
| `db_user_arn`                 | string            | Secreto con el username de la DB.                      |
| `db_pass_arn`                 | string (sensible) | Secreto con la contraseña de la DB.                    |

---

# 📤 Outputs

| Output                         | Descripción                         |
| ------------------------------ | ----------------------------------- |
| `frontend_service_name`        | Nombre del servicio ECS creado.     |
| `frontend_task_definition_arn` | ARN de la Task Definition generada. |

---

## 📘 Ejemplo de Uso

```hcl
module "ecs_service_frontend" {
  source = "./modules/ecs-service-frontend"

  name                   = "${var.project_name}-${var.environment}"
  cluster_name           = module.ecs_cluster.cluster_name
  capacity_provider_name = module.ecs_cluster.capacity_provider_name

  private_subnets = module.network.private_subnet_ids
  sg_frontend_id  = module.security.sg_frontend_id

  target_group_arn = module.target_group.target_group_arn

  ecr_repo_url = module.ecr.frontend_repository_url
  image_tag    = var.frontend_image_tag

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn

  db_host_arn = module.ssm.db_parameters_arn.host
  db_name_arn = module.ssm.db_parameters_arn.name
  db_user_arn = module.ssm.db_parameters_arn.user
  db_pass_arn = module.ssm.db_parameters_arn.password
}
```

---
