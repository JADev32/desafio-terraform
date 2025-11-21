# Módulo Terraform: Service Discovery Privado (AWS Cloud Map)

Este módulo crea un **namespace privado** y un **servicio DNS interno** para ECS, permitiendo que los contenedores resuelvan nombres internos como `mysql.lab3.local`.

---

## 📦 Recursos creados

* **Namespace privado**: `lab3.local`
  Espacio de nombres DNS privado dentro de la VPC especificada.

* **Servicio DNS**: `mysql.lab3.local`

  * TTL: 10 segundos
  * Tipo: A
  * Routing Policy: MULTIVALUE
  * Health check personalizado con `failure_threshold = 1`

---


## ⚙️ Variables

| Variable | Tipo   | Descripción                                      |
| -------- | ------ | ------------------------------------------------ |
| `vpc_id` | string | ID de la VPC donde se crea el namespace privado. |

---

## 🔧 Ejemplo de uso

```hcl
module "service_discovery" {
  source = "./modules/service_discovery"

  vpc_id = module.vpc.vpc_id
}

output "mysql_service_arn" {
  value = module.service_discovery.mysql_service_arn
}
```

