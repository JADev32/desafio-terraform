# Terraform AWS Infrastructure

Este proyecto contiene la infraestructura base de AWS implementada con **Terraform**, organizada en módulos reutilizables.
Actualmente incluye:

* **Módulo VPC**
* **Módulo IAM Roles & Policies para ECS, CodeBuild y CodePipeline**

---

## 📌 Estructura del Proyecto

```
.
├── modules
│   ├── vpc/
│   └── iam/
└── main.tf
```

Cada módulo está diseñado para ser reutilizable, desacoplado y fácilmente integrable con otros módulos (ECS, ALB, RDS, etc.).

---

# 🟦 MÓDULO: VPC

Este módulo crea la red principal donde se ejecutarán los servicios.
Incluye:

### ✔️ Recursos creados

* VPC con DNS habilitado
* Internet Gateway
* Subnets públicas (N subnets)
* Subnets privadas (N subnets)
* Elastic IP para NAT Gateway
* NAT Gateway en la primera subnet pública
* Route Tables:

  * **1 pública** (salida a Internet vía IGW)
  * **N privadas** (salida vía NAT Gateway)
* Asociaciones de route tables

---

## 📥 Variables del módulo VPC

| Variable               | Tipo         | Descripción                  |
| ---------------------- | ------------ | ---------------------------- |
| `name`                 | string       | Prefijo para nombres lógicos |
| `vpc_cidr`             | string       | CIDR principal de la VPC     |
| `azs`                  | list(string) | Availability Zones           |
| `public_subnet_cidrs`  | list(string) | Lista de CIDRs públicas      |
| `private_subnet_cidrs` | list(string) | Lista de CIDRs privadas      |
| `tags`                 | map(string)  | Tags opcionales              |

---

## 📤 Outputs del módulo VPC

| Output                    | Descripción               |
| ------------------------- | ------------------------- |
| `vpc_id`                  | ID de la VPC              |
| `vpc_cidr_block`          | CIDR de la VPC            |
| `public_subnet_ids`       | Lista de subnets públicas |
| `private_subnet_ids`      | Lista de subnets privadas |
| `internet_gateway_id`     | ID del IGW                |
| `nat_gateway_id`          | ID del NAT                |
| `public_route_table_id`   | RTB pública               |
| `private_route_table_ids` | Lista RTBs privadas       |

---

# 🟩 MÓDULO: IAM (ECS, CodeBuild, CodePipeline)

Este módulo crea todos los roles necesarios para que la infraestructura funcione correctamente.

---

## ✔️ ECS Instance Role & Instance Profile

Rol utilizado por instancias EC2 dentro del cluster ECS.

Incluye:

* `AmazonEC2ContainerServiceforEC2Role`
* Instance Profile requerido para asociarlo al Launch Template / ASG.

### Output:

* `ecs_instance_role_arn`
* `ecs_instance_profile_arn`

---

## ✔️ ECS Task Execution Role

Rol usado por las ECS Tasks (Fargate o EC2).

Incluye:

* `AmazonECSTaskExecutionRolePolicy`
* Política custom para:

  * CloudWatch Logs
  * SSM Parameter Store
  * KMS Decrypt

### Output:

* `ecs_task_execution_role_arn`

---

## ✔️ CodeBuild Role

Permisos necesarios para:

* Obtener/pushear imágenes a ECR
* Logs
* S3 artifacts

### Output:

* `codebuild_role_arn`

---

## ✔️ CodePipeline Role

Permite que CodePipeline interactúe con:

* IAM (PassRole)
* ECS deployments
* CodeBuild
* ECR
* S3

### Output:

* `codepipeline_role_arn`

---

# 🚀 Cómo usar estos módulos

### Ejemplo en un `main.tf`

```hcl
module "vpc" {
  source = "./modules/vpc"

  name                 = "lab3"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  tags = {
    Project = "Lab3"
  }
}

module "iam" {
  source = "./modules/iam"
  prefix = "lab3"
}
```





