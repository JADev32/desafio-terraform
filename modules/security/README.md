# Módulo Terraform: Security Groups para ECS y ALB

Este módulo crea los **Security Groups (SG)** necesarios para un entorno ECS completo con frontend, backend MySQL, ALB, EFS y los hosts EC2 del cluster.

---

## 📌 Recursos del módulo

### Security Groups creados

| SG          | Propósito                                                 |
| ----------- | --------------------------------------------------------- |
| `alb`       | Seguridad del Application Load Balancer público           |
| `frontend`  | Seguridad del servicio ECS frontend                       |
| `db`        | Seguridad del servicio ECS MySQL                          |
| `efs`       | Seguridad del File System EFS                             |
| `ecs_hosts` | Seguridad de las instancias EC2 que forman el cluster ECS |

---

### Reglas principales

#### 🔹 SG ALB

* **Ingreso HTTP/HTTPS desde Internet** (puertos 80 y 443).
* **Egreso hacia frontend** (puerto 80).

#### 🔹 SG Frontend

* **Ingreso HTTP solo desde ALB**.
* **Egreso MySQL hacia SG DB** (puerto 3306).
* **Egreso DNS al resolver VPC** (puertos 53 TCP/UDP).
* **Egreso HTTPS a internet** (para NAT, ECR, ACM, etc.).

#### 🔹 SG DB

* **Ingreso MySQL solo desde frontend** (puerto 3306).
* **Egreso NFS hacia SG EFS** (puerto 2049).
* **Egreso DNS al resolver VPC** (puertos 53 TCP/UDP).

#### 🔹 SG EFS

* **Ingreso NFS solo desde SG DB** (puerto 2049).

#### 🔹 SG ECS Hosts

* **Egreso DNS al resolver VPC** (puertos 53 TCP/UDP).
* **Egreso HTTPS a internet** (para updates, ECR, SSM, etc.).

---

## 🔧 Uso del módulo

```hcl
module "security_groups" {
  source = "./modules/security"

  name                 = "lab3"
  vpc_id               = module.network.vpc_id
  vpc_dns_resolver_cidr = "10.0.0.2/32"
  tags = {
    Owner = "lab3"
  }
}
```

---

# Módulo Terraform: Security Groups (SG) para ECS, ALB, MySQL y EFS

Este módulo crea Security Groups para un entorno completo de ECS con frontend, backend MySQL, ALB, EFS y hosts EC2, y expone sus IDs como **outputs** para usar en otros módulos o recursos.

---

## 📤 Outputs

| Output            | Descripción                                           |
| ----------------- | ----------------------------------------------------- |
| `sg_alb_id`       | Security Group del Application Load Balancer.         |
| `sg_frontend_id`  | Security Group del servicio frontend.                 |
| `sg_db_id`        | Security Group de la base de datos MySQL.             |
| `sg_efs_id`       | Security Group del file system EFS.                   |
| `sg_ecs_hosts_id` | Security Group de las instancias EC2 del cluster ECS. |

---

## ⚙️ Variables

| Variable                | Tipo        | Descripción                                      | Default |
| ----------------------- | ----------- | ------------------------------------------------ | ------- |
| `name`                  | string      | Prefijo para nombres lógicos (tags Name).        | N/A     |
| `vpc_id`                | string      | ID de la VPC donde se crean los SG.              | N/A     |
| `vpc_dns_resolver_cidr` | string      | CIDR del resolver de la VPC (ej: `10.0.0.2/32`). | N/A     |
| `tags`                  | map(string) | Tags comunes que se aplican a todos los SG.      | `{}`    |

---

## 📝 Consideraciones

* Las reglas son **mínimas para el funcionamiento del stack ECS con ALB y EFS**.
* Los SG se vinculan mediante **source_security_group_id** para control interno seguro.
* Los puertos expuestos a internet son **solo los necesarios (80 y 443 en ALB)**.
* El resto de reglas aseguran la comunicación interna entre servicios (frontend ↔ DB ↔ EFS).

---

