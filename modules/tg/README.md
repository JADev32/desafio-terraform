# Módulo Terraform: Target Group para ALB/NLB

Este módulo crea un **Target Group** en AWS, asociado a una VPC y listo para integrarse con un **Application Load Balancer (ALB)** o **Network Load Balancer (NLB)**.
Incluye configuración de **Health Check** para monitorear la salud de los targets.

---

## 📤 Outputs

| Output             | Descripción                  |
| ------------------ | ---------------------------- |
| `target_group_arn` | ARN del Target Group creado. |

---

## ⚙️ Variables

| Variable            | Tipo   | Descripción                                       | Default             |
| ------------------- | ------ | ------------------------------------------------- | ------------------- |
| `name`              | string | Nombre del Target Group.                          | `lab3-target-group` |
| `vpc_id`            | string | ID de la VPC donde se desplegará el Target Group. | —                   |
| `port`              | number | Puerto de escucha para el tráfico.                | 80                  |
| `protocol`          | string | Protocolo del tráfico (HTTP, HTTPS, etc.).        | `HTTP`              |
| `health_check_path` | string | Ruta HTTP utilizada para el Health Check.         | `/css/twitter.css`  |

---

## 🔧 Ejemplo de uso

```hcl
module "app_tg" {
  source             = "./modules/target_group"
  name               = "my-app-tg"
  vpc_id             = module.vpc.vpc_id
  port               = 80
  protocol           = "HTTP"
  health_check_path  = "/health"
}

output "tg_arn" {
  value = module.app_tg.target_group_arn
}
```

---

## 📝 Notas

* El Target Group está configurado con **target_type = "ip"**, adecuado para ECS o instancias con IP dinámica.
* El **Health Check** revisa el path definido (`health_check_path`) en el puerto de tráfico (`traffic-port`) usando HTTP.
* Se pueden ajustar los parámetros de Health Check: `timeout`, `interval`, `healthy_threshold` y `unhealthy_threshold`.
* Se asigna un tag `Name` con el valor de la variable `name` para fácil identificación.
* Compatible tanto con ALB como con NLB que soporten targets tipo IP.
