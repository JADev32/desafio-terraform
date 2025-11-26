# Teracloud Lab3 – Challenge Terraform

## 🚀 Objetivo del Proyecto

Diseñar, aprovisionar y desplegar una infraestructura completa en AWS utilizando **Terraform** siguiendo buenas prácticas de IaC, modularización y alta disponibilidad.

El objetivo principal fue construir una plataforma capaz de:

- Servir tráfico público mediante un **Application Load Balancer (ALB)**.
- Ejecutar un frontend PHP en contenedores gestionados con **ECS (EC2 mode)**.
- Mantener una base de datos MySQL persistente utilizando **EFS**.
- Gestionar secretos y configuraciones mediante **SSM Parameter Store**.
- Proveer escalabilidad automática mediante ASG + ECS Capacity Providers.
- Integrar un pipeline CI/CD usando **CodePipeline + CodeBuild** para automatizar builds y despliegues.

---

## Pre-requisitos

  - Parameter store creados previamente para la base de datos
  - Hosted zone creada con el certificado
  - Estar logueado en CLI
  - Crear tfvars como en el siguiente ejemplo |https://github.com/JADev32/desafio-terraform/blob/develop/envs/dev.tfvars.example|

---

## Arquitectura Implementada

La infraestructura desarrollada incluye:

### 🔹 Red y Seguridad
- **VPC** con subnets públicas y privadas distribuidas en 2 AZ.
- **Security Groups** diseñados específicamente para:
  - ALB
  - Frontend ECS Service
  - MySQL
  - EFS
  - EC2 del cluster ECS
- Reglas estrictas basadas en *mínimos privilegios*.

### Cómputo y Contenedores
- **ECS Cluster (EC2 Launch Type)** con:
  - Launch Template
  - Auto Scaling Group
  - Capacity Provider
  - AMI ECS-Optimized
  - Instancias `t2.micro` para ejecución de tareas

### Frontend (PHP)
- Task Definition con:
  - Imagen Docker desde ECR
  - Puerto 80
  - Variables de entorno DB desde SSM
  - Logs via awslogs
- ECS Service integrado al ALB usando target groups dinámicos (IP mode).

### MySQL sobre ECS
- Contenedor MySQL con:
  - Volumen persistente montado a **EFS**
  - Credenciales desde SSM
  - Logs gestionados por awslogs

### Almacenamiento
- **EFS** para persistencia de la base de datos.
- **ECR** para alojamiento de imágenes Docker.

### CI/CD
Pipeline completamente automatizado con:
- **CodePipeline**
- **CodeBuild**
- Artifact bucket en S3
- Buildspec para construir y pushear la imagen a ECR
- Actualización automática del ECS Service mediante `imagedefinitions.json`

---

## Infraestructura como Código

Todo el proyecto está desarrollado con **Terraform modular**:

- `modules/network`
- `modules/security`
- `modules/iam`
- `modules/efs`
- `modules/alb`
- `modules/tg`
- `modules/ecs-cluster`
- `modules/ecs-service-frontend`
- `modules/ecs-service-mysql`
- `modules/ecr`
- `modules/pipeline`
- `main.tf` (orquestación completa)

---

## Acceso al Repositorio

 Para ver el proyecto completo en GitHub, **[hacé click acá](https://github.com/JADev32/desafio-terraform)**.

---

## Equipo DevOps

Miembros:

| Nombre     | GitHub |
|------------|--------|
| **Agustín** | https://github.com/Aguppesce |
| **Magali**  | https://github.com/magalimou |
| **Santino** | https://github.com/santinozc11 |
| **Julian**  | https://github.com/JADev32 |

---

## Tecnologías y Herramientas Utilizadas

- **Terraform** – Infraestructura como Código  
- **AWS ECS (EC2)** – Orquestación de contenedores  
- **ECR** – Registro de imágenes  
- **EFS** – Persistencia del database storage  
- **ALB + Target Groups** – Ingreso público  
- **SSM Parameter Store** – Manejo de secretos  
- **CodePipeline / CodeBuild** – CI/CD  
- **Docker** – Build y empaquetado  
- **Git & GitHub** – Versionado y colaboración  
- **Trello** – Gestión de tareas  

---

## Notas Finales

Este laboratorio refuerza conceptos fundamentales de DevOps:

- Modularidad en Terraform  
- Infraestructura reproducible  
- Despliegues automatizados  
- Buenas prácticas de seguridad  
- Arquitectura escalable y resiliente  

---

