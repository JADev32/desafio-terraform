# Módulo Terraform: Route 53 Alias hacia ALB

Este módulo crea un registro **A (Alias)** en Route 53 para apuntar un dominio a un **Application Load Balancer (ALB)**.

Ideal para exponer un frontend ECS o cualquier servicio detrás de un ALB utilizando un dominio propio.

---

## 📌 Recursos del módulo

### ✔️ `aws_route53_record`

Crea un registro **A Alias** que apunta al DNS del ALB.

### ✔️ `data "aws_route53_zone"`

Obtiene automáticamente la Hosted Zone existente en Route 53 (no crea una nueva).

---

## 📥 Variables

| Variable           | Tipo   | Descripción                                        |
| ------------------ | ------ | -------------------------------------------------- |
| `domain_name`      | string | Dominio final a publicar. Ej: `app.misitio.com.`   |
| `hosted_zone_name` | string | Nombre de la Hosted Zone ya existente en Route 53. |
| `alb_dns_name`     | string | DNS público del ALB generado por AWS.              |
| `alb_zone_id`      | string | Hosted Zone ID propia del ALB.                     |

---

## 📤 Outputs

| Output        | Descripción                                                       |
| ------------- | ----------------------------------------------------------------- |
| `record_fqdn` | Devuelve el FQDN limpio (sin el punto final) del registro creado. |

---

## 🧩 Ejemplo de uso

```hcl
module "route53" {
  source = "./modules/route53"

  domain_name       = "app.lab3.example.com."
  hosted_zone_name  = "lab3.example.com."
  alb_dns_name      = module.alb.dns_name
  alb_zone_id       = module.alb.zone_id
}
```

---

## 🔎 Detalles importantes

* El módulo **no crea Hosted Zones**, solo usa una existente.
* El registro es tipo **A Alias**, que:

  * No tiene costo
  * Se actualiza automáticamente si cambia la IP del ALB
* `evaluate_target_health = true` permite que Route 53 considere la salud del ALB.

---