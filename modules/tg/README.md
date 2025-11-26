# Módulo Terraform: Target Group para ALB/NLB

Este módulo crea un **Target Group** en AWS, asociado a una VPC y listo para integrarse con un **Application Load Balancer (ALB)** .

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
| `health_check_path` | string | Ruta HTTP utilizada para el Health Check.         | `/`                 |

---

## 🔧 Ejemplo de uso

```hcl
module "target_group" {
  source = "./modules/tg"

  vpc_id = module.network.vpc_id

  name              = "tg-lab3"
  health_check_path = "/"
}
```

---

## 📝 Notas

* El Target Group está configurado con **target_type = "ip"**, adecuado para ECS o instancias con IP dinámica.
* El **Health Check** revisa el path definido (`health_check_path`) en el puerto de tráfico (`traffic-port`) usando HTTP.
