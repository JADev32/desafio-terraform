# Decisiones Arquitectónicas - Teracloud Lab3

## 📋 Resumen 

Este documento registra las decisiones arquitectónicas clave tomadas durante el desarrollo de la infraestructura AWS con Terraform para el Lab3 de Teracloud.

---

## 🏗️ Decisiones de Arquitectura

### 1. **Orquestación de Contenedores: ECS con EC2 Launch Type**

**Decisión:** Utilizar Amazon ECS con EC2 Launch Type en lugar de Fargate.

**Contexto:**
- Necesidad de control granular sobre las instancias
- Requisitos de persistencia para MySQL con EFS
- Presupuesto limitado (t2.micro en free tier)

**Alternativas Consideradas:**
- **Fargate:** Más simple pero más costoso y menos control
- **EKS:** Demasiado complejo para el alcance del proyecto
- **EC2 puro:** Menos automatización y escalabilidad

**Justificación:**
- Control total sobre el runtime de contenedores
- Mejor integración con EFS para persistencia
- Capacidad de usar instancias t2.micro (free tier)
- Escalabilidad automática con ASG + Capacity Providers

---

### 2. **Persistencia de Base de Datos: MySQL en Contenedor + EFS**

**Decisión:** Ejecutar MySQL como contenedor ECS con volumen persistente en EFS.

**Contexto:**
- Necesidad de persistencia de datos
- Presupuesto limitado (evitar RDS)
- Simplicidad de despliegue

**Alternativas Consideradas:**
- **RDS MySQL:** Más robusto pero costoso
- **EBS:** Limitado a una AZ, problemas de failover
- **Base de datos externa:** Fuera del alcance del lab

**Justificación:**
- EFS proporciona persistencia multi-AZ
- Menor costo que RDS
- Integración nativa con ECS
- Backup automático con EFS

**Riesgos Aceptados:**
- Menor rendimiento que RDS
- Gestión manual de backups y mantenimiento
- No hay alta disponibilidad automática

---

### 3. **Modularización de Terraform**

**Decisión:** Arquitectura completamente modular con 13 módulos especializados.

**Estructura Adoptada:**
```
modules/
├── network/          # VPC, subnets, routing
├── security/         # Security Groups
├── iam/             # Roles y políticas
├── efs/             # Sistema de archivos
├── alb/             # Load Balancer
├── tg/              # Target Groups
├── ecs-cluster/     # Cluster ECS
├── ecs-service-frontend/  # Servicio frontend
├── ecs-service-mysql/     # Servicio MySQL
├── ecr/             # Repositorios de imágenes
├── pipeline/        # CI/CD
├── route53-acm/     # DNS y certificados
└── service-discovery/     # Cloud Map
```

**Justificación:**
- **Reutilización:** Módulos reutilizables entre ambientes
- **Mantenibilidad:** Cambios aislados por componente
- **Testeo:** Validación independiente de cada módulo
- **Colaboración:** Equipos pueden trabajar en paralelo
- **Versionado:** Control de versiones por módulo

---

### 4. **Gestión de Secretos: SSM Parameter Store**

**Decisión:** Usar AWS Systems Manager Parameter Store para credenciales de base de datos.

**Parámetros Gestionados:**
- `/lab3/{env}/db_host`
- `/lab3/{env}/db_name`
- `/lab3/{env}/db_user`
- `/lab3/{env}/db_pass` (SecureString)

**Alternativas Consideradas:**
- **AWS Secrets Manager:** Más costoso, funcionalidad similar
- **Variables de entorno hardcodeadas:** Inseguro
- **HashiCorp Vault:** Complejidad adicional

**Justificación:**
- Integración nativa con ECS
- Cifrado automático para SecureString
- Sin costo adicional
- Rotación manual controlada
- Auditoría integrada con CloudTrail

---

### 5. **Networking: VPC Multi-AZ con Subnets Calculadas**

**Decisión:** VPC con subnets públicas y privadas distribuidas en 2 AZ usando función `cidrsubnet()`.

**Configuración:**
```hcl
# Subnets Públicas
10.0.0.0/24    # AZ-1a
10.0.16.0/24   # AZ-1b

# Subnets Privadas  
10.0.128.0/24  # AZ-1a
10.0.144.0/24  # AZ-1b
```

**Justificación:**
- **Alta Disponibilidad:** Distribución multi-AZ
- **Seguridad:** Servicios backend en subnets privadas
- **Escalabilidad:** Cálculo automático de CIDRs
- **Flexibilidad:** Fácil adición de nuevas subnets

---

### 6. **CI/CD: CodePipeline + CodeBuild**

**Decisión:** Pipeline nativo de AWS con CodePipeline y CodeBuild.

**Flujo Implementado:**
1. **Source:** GitHub via CodeStar Connections
2. **Build:** CodeBuild con buildspec.yml
3. **Deploy:** Actualización automática de ECS Service

**Alternativas Consideradas:**
- **GitHub Actions:** Requiere configuración de credenciales AWS
- **Jenkins:** Infraestructura adicional a mantener
- **GitLab CI:** Fuera del ecosistema AWS

**Justificación:**
- Integración nativa con servicios AWS
- Gestión de credenciales automática
- Escalabilidad automática
- Logs centralizados en CloudWatch
- Notificaciones via SNS

---

### 7. **Load Balancing: Application Load Balancer**

**Decisión:** ALB con Target Groups dinámicos usando modo IP.

**Configuración:**
- **Target Type:** IP (para compatibilidad con ECS)
- **Health Check:** Endpoint personalizable
- **SSL/TLS:** Certificado ACM
- **Sticky Sessions:** Deshabilitadas

**Justificación:**
- Soporte nativo para contenedores ECS
- Balanceo de carga a nivel de aplicación
- Health checks granulares
- Integración con Route 53
- Soporte para múltiples protocolos

---

### 8. **Seguridad: Principio de Mínimos Privilegios**

**Decisión:** Security Groups específicos por componente con reglas restrictivas.

**Security Groups Implementados:**
- **sg_alb:** Puerto 80/443 desde Internet
- **sg_frontend:** Puerto 80 desde ALB únicamente
- **sg_db:** Puerto 3306 desde frontend únicamente
- **sg_efs:** Puerto 2049 desde servicios ECS
- **sg_ecs_hosts:** Acceso mínimo para gestión

**Justificación:**
- Reducción de superficie de ataque
- Trazabilidad de conexiones
- Cumplimiento de mejores prácticas
- Facilita auditorías de seguridad

---

### 9. **Monitoreo: CloudWatch Logs**

**Decisión:** Logs centralizados usando awslogs driver.

**Log Groups:**
- `/ecs/frontend-service`
- `/ecs/mysql-service`
- `/aws/codebuild/{project}`

**Justificación:**
- Centralización de logs
- Retención configurable
- Búsqueda y filtrado avanzado
- Integración con CloudWatch Insights
- Alertas automáticas

---

### 10. **Service Discovery: AWS Cloud Map**

**Decisión:** Usar AWS Cloud Map para descubrimiento de servicios interno.

**Implementación:**
- Namespace privado en VPC
- Registro automático de servicios ECS
- Resolución DNS interna

**Justificación:**
- Desacoplamiento de servicios
- Resolución DNS automática
- Integración nativa con ECS
- Escalabilidad automática

---

## 🔄 Decisiones de Proceso

### Gestión de Ambientes

**Decisión:** Separación por archivos `.tfvars` y validación de variables.

**Estructura:**
```
envs/
├── dev.tfvars
├── prod.tfvars
└── dev.tfvars.example
```

**Validaciones Implementadas:**
- Nombres de proyecto (regex)
- Ambientes permitidos (dev, prod)
- Regiones AWS válidas

### Naming Convention

**Decisión:** Prefijo consistente `{project}-{environment}` para todos los recursos.

**Ejemplo:**
- Proyecto: `lab3-teracloud`
- Ambiente: `dev`
- Prefijo: `lab3-teracloud-dev`

### Tagging Strategy

**Tags Obligatorios:**
- `Project`: Nombre del proyecto
- `Environment`: Ambiente (dev/prod)
- `Owner`: Equipo responsable

---

## 📊 Métricas de Decisión

### Criterios de Evaluación

1. **Costo:** Optimización para free tier
2. **Simplicidad:** Minimizar complejidad operacional
3. **Escalabilidad:** Capacidad de crecimiento
4. **Seguridad:** Cumplimiento de mejores prácticas
5. **Mantenibilidad:** Facilidad de modificación

### Resultados

| Aspecto | Puntuación (1-5) | Comentarios |
|---------|------------------|-------------|
| Costo | 5 | Uso máximo de free tier |
| Simplicidad | 4 | Modular pero comprensible |
| Escalabilidad | 4 | ASG + Capacity Providers |
| Seguridad | 5 | Principio de mínimos privilegios |
| Mantenibilidad | 5 | Arquitectura modular |

---

## 🔮 Decisiones Futuras

### Mejoras Identificadas

1. **Monitoreo Avanzado:**
   - Implementar CloudWatch Dashboards
   - Alertas proactivas con SNS
   - Métricas personalizadas

2. **Seguridad Adicional:**
   - WAF para el ALB
   - VPC Flow Logs
   - AWS Config para compliance

3. **Backup y Disaster Recovery:**
   - Backup automático de EFS
   - Cross-region replication
   - Runbooks de recuperación

4. **Performance:**
   - CloudFront para contenido estático
   - ElastiCache para sesiones
   - Optimización de imágenes Docker

---

## 👥 Contribuidores

**Equipo DevOps Lab3:**
- Agustín - [@Aguppesce](https://github.com/Aguppesce)
- Magali - [@magalimou](https://github.com/magalimou)  
- Santino - [@santinozc11](https://github.com/santinozc11)
- Julian - [@JADev32](https://github.com/JADev32)

---

**Fecha de Última Actualización:** $(date +%Y-%m-%d)
**Versión del Documento:** 1.0