
---

# 📦 Módulo: `ecs-cluster`

Despliega un **ECS Cluster basado en EC2**, completamente administrado mediante:

* **Launch Template** para las instancias ECS
* **Auto Scaling Group (ASG)** con tamaño configurable
* **Asociación automática del capacity provider al cluster**
* **Instancias corriendo en subnets privadas**

---

# 🏗️ Recursos que crea

## 1. `aws_launch_template.ecs_launch_template`

Plantilla de lanzamiento utilizada por el ASG.

Incluye:

* AMI ECS Optimized (`ami_id`)
* Tipo de instancia (`instance_type`)
* Instance Profile para ECS (`ecs_instance_profile_arn`)
* User data que registra la instancia en el cluster:

  ```bash
  echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
  ```
---

## 2. `aws_autoscaling_group.ecs_asg`

Grupo de Auto Scaling encargado de crear y mantener las instancias del cluster ECS.

* Tamaño fijo definido:
  `min_size = 2`, `desired_capacity = 3`, `max_size = 3`
* Instancias en **subnets privadas**

---

## 3. `aws_ecs_cluster.ecs_cluster`

Crea el cluster ECS con el nombre provisto.

---

## 4. `aws_ecs_capacity_provider.ecs_capacity_provider`

Define un **capacity provider basado en el ASG**, permitiendo a ECS:

* Escalar instancias automáticamente
* Administrar termination y lifecycle
* Integrarse con la estrategia de deployment

---

## 5. `aws_ecs_cluster_capacity_providers.ecs_cluster_cp`

Asocia el capacity provider al cluster con una estrategia por defecto:

```hcl
default_capacity_provider_strategy {
  capacity_provider = <provider>
  weight            = 1
  base              = 1
}
```

---

# ⚙️ Variables

| Variable                   | Tipo         | Descripción                                             |
| -------------------------- | ------------ | ------------------------------------------------------- |
| `name`                     | string       | Prefijo para nombrar recursos.                          |
| `cluster_name`             | string       | Nombre del ECS Cluster.                                 |
| `ami_id`                   | string       | AMI optimizada para ECS.                                |
| `instance_type`            | string       | Tipo de instancia EC2 para ECS hosts.                   |
| `ecs_instance_profile_arn` | string       | ARN del Instance Profile para ECS.                      |
| `private_subnets`          | list(string) | Subnets privadas donde se crean las instancias del ASG. |
| `sg_ecs_hosts_id`          | string       | Security Group de las instancias ECS.                   |
| `tags`                     | map(string)  | Mapa de tags para aplicar a los recursos.               |

---

# 📤 Outputs

| Output                   | Descripción                            |
| ------------------------ | -------------------------------------- |
| `cluster_id`             | ID del ECS Cluster creado.             |
| `cluster_name`           | Nombre del cluster ECS.                |
| `capacity_provider_name` | Nombre del capacity provider generado. |

---

# 📘 Ejemplo de Uso

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  name         = "${var.project_name}-${var.environment}"
  cluster_name = "${var.project_name}-${var.environment}-cluster"

  # <<< AMI obtenida dinámicamente >>>
  ami_id        = local.ecs_ami_id
  instance_type = "t2.micro"

  ecs_instance_profile_arn = module.iam.ecs_instance_profile_arn

  private_subnets = module.network.private_subnet_ids
  sg_ecs_hosts_id = module.security.sg_ecs_hosts_id

  tags = local.common_tags
}
```

---

