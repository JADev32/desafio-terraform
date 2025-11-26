# Terraform Module: CI/CD Pipeline (AWS CodePipeline + CodeBuild + ECS)

Este módulo crea un **pipeline CI/CD completo en AWS** utilizando:

- **AWS CodePipeline** — Orquestación del flujo CI/CD  
- **AWS CodeBuild** — Construcción de la imagen Docker  
- **Amazon ECR** — Registro de contenedores  
- **Amazon ECS** — Deploy del servicio (Fargate o EC2)  
- **Amazon S3** — Almacenamiento de artifacts del pipeline

Este módulo está diseñado para integrarse con un repositorio de GitHub a través de **CodeStar Connections** y automatizar un deploy continuo hacia ECS.

---

## 🚀 Funcionalidades principales

- Crea un **S3 bucket seguro** para almacenar artifacts del pipeline.
- Configura un **proyecto de CodeBuild** que:
  - Construye una imagen Docker.
  - La sube al repositorio ECR.
  - Exporta `imagedefinitions.json` para ECS.
- Crea un **pipeline CodePipeline completo**, con etapas:
  1. **Source** (GitHub → CodeStar Connection)
  2. **Build** (CodeBuild)
  3. **Deploy** (ECS Deploy)
- Actualiza automáticamente un **servicio ECS existente** con la nueva imagen.

---

## 📦 Requisitos

- Terraform 1.0+
- Provider de AWS `>= 4.0`
- Un repositorio GitHub conectado mediante una **CodeStar Connection**
- Roles IAM para:
  - CodeBuild  
  - CodePipeline  
  - Ejecución de ECS

---

## 🧩 Uso básico

```hcl
module "pipeline" {
  source = "./modules/pipeline"

  name_prefix          = "miapp-dev"
  aws_region           = "us-east-1"
  aws_account_id       = "123456789012"

  codeconnection_arn   = "arn:aws:codestar-connections:..."
  github_full_repo_id  = "username/repo"
  branch               = "main"

  codebuild_role_arn   = module.iam.codebuild_role_arn
  codepipeline_role_arn = module.iam.codepipeline_role_arn

  ecr_repository_name  = "miapp-repo"
  image_tag            = "latest"

  ecs_cluster_name     = "miapp-cluster"
  ecs_service_name     = "miapp-service"
  image_definitions_path = "imagedefinitions.json"

  tags = {
    Project = "miapp"
    Env     = "dev"
  }
}

## 📥 Variables

| Variable                 | Tipo        | Descripción                                        |
| ------------------------ | ----------- | -------------------------------------------------- |
| `name_prefix`            | string      | Prefijo para nombrar los recursos.                 |
| `aws_region`             | string      | Región AWS para el pipeline.                       |
| `aws_account_id`         | string      | ID de la cuenta AWS, usado para nombrar el bucket. |
| `codeconnection_arn`     | string      | ARN de CodeStar Connection para GitHub.            |
| `github_full_repo_id`    | string      | Repositorio en formato `owner/repo`.               |
| `branch`                 | string      | Branch que dispara el pipeline.                    |
| `codebuild_role_arn`     | string      | ARN del role IAM para CodeBuild.                   |
| `codepipeline_role_arn`  | string      | ARN del role IAM para CodePipeline.                |
| `ecr_repository_name`    | string      | Nombre del repositorio ECR.                        |
| `image_tag`              | string      | Tag de la imagen Docker.                           |
| `ecs_cluster_name`       | string      | Nombre del cluster ECS.                            |
| `ecs_service_name`       | string      | Nombre del servicio ECS.                           |
| `image_definitions_path` | string      | Ruta a `imagedefinitions.json`.                    |
| `tags`                   | map(string) | Tags comunes para recursos.                        |

## 📥 Outputs

| Output          | Descripción                 |
| --------------- | --------------------------- |
| `pipeline_name` | Nombre del pipeline creado. |


🧪 Notas importantes

- Requiere un archivo buildspec.yml en el repositorio.

- Debe existir un repositorio ECR previo.

- El servicio ECS debe estar creado antes de ejecutar el pipeline.

- Para GitHub, CodeStar Connection debe estar autorizada manualmente en AWS.