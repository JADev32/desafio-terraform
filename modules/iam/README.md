# 🔐 AWS IAM Module for ECS, CodeBuild & CodePipeline (Terraform)

Este módulo define todos los roles, instance profiles y políticas necesarias para operar un entorno ECS con EC2 como capacidad, pipelines de CI/CD con CodeBuild y CodePipeline, y acceso a logs, parámetros y ECR.

---

## 🏗️ ¿Qué crea este módulo?

### 🟦 1. **ECS Instance Role + Instance Profile**
Usado por instancias EC2 que forman parte de un ECS Cluster.

Incluye:
- Rol con `AmazonEC2ContainerServiceforEC2Role`
- Instance Profile obligatorio para asociar el rol al Launch Template/ASG

### 🟩 2. **ECS Task Execution Role**
Requerido para correr tareas ECS (descargar imágenes, enviar logs, leer secretos).

Incluye permisos para:
- ECR
- CloudWatch Logs
- SSM Parameter Store
- KMS (Decrypt)

### 🟨 3. **CodeBuild Role**
Permite a CodeBuild:
- Autenticarse en ECR
- Descargar/subir imágenes
- Leer/escribir en S3
- Enviar logs

### 🟥 4. **CodePipeline Role**
Permite a CodePipeline:
- Ejecutar CodeBuild
- Manipular ECS Services (deploys)
- Acceder a S3, CloudWatch, IAM PassRole

---


---

## ⚙️ Variables

| Variable | Tipo | Descripción | Requerida |
|----------|------|-------------|-----------|
| `prefix` | string | Prefijo para nombrado de todos los recursos IAM. | ✔️ |

---

## 📤 Outputs

| Output | Descripción |
|--------|-------------|
| `ecs_instance_role_arn` | ARN del rol para instancias ECS EC2. |
| `ecs_instance_profile_arn` | ARN del Instance Profile requerido por EC2. |
| `ecs_task_execution_role_arn` | ARN del ECS Task Execution Role. |
| `codebuild_role_arn` | ARN del rol de CodeBuild. |
| `codepipeline_role_arn` | ARN del rol de CodePipeline. |

---

## 🚀 Ejemplo de uso

```hcl
module "iam" {
  source = "./modules/iam"
  prefix = "lab3"
}

```
