# 📘 Application Load Balancer Module (Terraform)

Este módulo de Terraform crea un **Application Load Balancer (ALB)** público en AWS con listeners HTTP y HTTPS, y permite integrarlo fácilmente con un Target Group existente.

---

## 🏗️ ¿Qué crea este módulo?

Este módulo despliega:

- Un **Application Load Balancer (ALB)** público.
- Listener **HTTP (80)** que redirige automáticamente a **HTTPS (443)**.
- Listener **HTTPS (443)** asociado a un certificado ACM.
- Outputs útiles para integraciones con:
  - Route53 (via `zone_id` y `dns_name`)
  - Servicios ECS o EC2 que usen el Target Group.

---

## 📦 Estructura del módulo
modules/
└── alb/
├── main.tf
├── variables.tf
└── outputs.tf


---

## ⚙️ Variables

| Variable              | Tipo         | Descripción                                                | Requerida |
|----------------------|--------------|------------------------------------------------------------|-----------|
| `alb_name`           | string       | Nombre del Application Load Balancer.                     | No (default: `alb-lab2`) |
| `vpc_id`             | string       | ID de la VPC donde se desplegará el ALB.                  | ✔️ |
| `public_subnet_ids`  | list(string) | Subredes públicas donde se colocará el ALB.               | ✔️ |
| `security_group_ids` | list(string) | Security Groups asociados al ALB.                         | ✔️ |
| `target_group_arn`   | string       | ARN del Target Group al cual el ALB enviará tráfico.      | ✔️ |
| `acm_certificate_arn`| string       | ARN del certificado ACM para el listener HTTPS.           | ✔️ |
| `alb_owner`          | string       | Identificador del responsable del recurso.                | ✔️ |

---

## 📤 Outputs

| Output                | Descripción |
|----------------------|-------------|
| `alb_arn`            | ARN del Load Balancer. |
| `alb_dns_name`       | DNS público del ALB. |
| `alb_zone_id`        | Zone ID del ALB (útil para Route53). |
| `https_listener_arn` | ARN del listener HTTPS. |

---

## 🚀 Ejemplo de uso

```hcl
module "alb" {
  source = "./modules/alb"

  alb_name            = "my-app-alb"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnets
  security_group_ids  = [module.sg_alb.id]
  target_group_arn    = module.target_group.arn
  acm_certificate_arn = aws_acm_certificate.cert.arn
  alb_owner           = "magui"
}

🔒 Seguridad

El listener HTTP redirige automáticamente a HTTPS para garantizar tráfico seguro.

El ALB se despliega únicamente en subredes públicas.

La seguridad se maneja a través de los Security Groups proporcionados al módulo.

📝 Notas

Este módulo no crea el Target Group ni el certificado ACM. Ambos deben existir previamente.

El ALB soporta solo IPv4 en este ejemplo, pero puede extenderse a dual-stack (ipv4 + ipv6) si es necesario.
