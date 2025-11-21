# Módulo Terraform: SSM Parameters de Base de Datos

Este módulo crea parámetros en **AWS Systems Manager (SSM Parameter Store)** para almacenar de manera segura la información de la base de datos utilizada por tu aplicación (host, nombre, usuario y contraseña).
La contraseña se almacena como **SecureString**.

---

## 📤 Outputs

| Output               | Descripción                                                                                                |
| -------------------- | ---------------------------------------------------------------------------------------------------------- |
| `db_parameters_arn`  | ARNs de los parámetros SSM (`host`, `name`, `user`, `password`) para usar en task definitions o IAM roles. |
| `db_parameters_name` | Nombres de los parámetros SSM (`host`, `name`, `user`, `password`) para uso interno o debugging.           |

---

## ⚙️ Variables

| Variable                   | Tipo        | Descripción                                                                 |
| -------------------------- | ----------- | --------------------------------------------------------------------------- |
| `name`                     | string      | Prefijo lógico para los nombres de los parámetros (ej: lab3-teracloud-dev). |
| `db_parameter_path_prefix` | string      | Prefijo en SSM para los parámetros de DB (ej: `/lab3/dev/db`).              |
| `db_host`                  | string      | Host/endpoint de MySQL que consumirá el frontend.                           |
| `db_name`                  | string      | Nombre de la base de datos (no puede estar vacío).                          |
| `db_user`                  | string      | Usuario de la aplicación para la base de datos (no puede estar vacío).      |
| `db_pass`                  | string      | Contraseña del usuario de la base de datos (sensitive, tipo SecureString).  |
| `tags`                     | map(string) | Tags comunes a aplicar a los parámetros (opcional).                         |

---

## 🔧 Ejemplo de uso

```hcl
module "db_parameters" {
  source                   = "./modules/ssm_db_parameters"

  name                     = "lab3-teracloud-dev"
  db_parameter_path_prefix  = "/lab3/dev/db"
  db_host                   = aws_rds_instance.mysql.endpoint
  db_name                   = "myapp"
  db_user                   = "appuser"
  db_pass                   = var.db_password
  tags                      = { Environment = "dev" }
}
```

---

## 📝 Notas

* La contraseña se guarda como **SecureString**, por lo que está encriptada y protegida.
* Los parámetros pueden usarse en **Task Definitions** mediante `valueFrom`.
* Se pueden agregar tags adicionales mediante la variable `tags`.
* Se sobrescriben automáticamente si cambian los valores (`overwrite = true`).

---
