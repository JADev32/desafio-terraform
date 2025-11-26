# Terraform Module: SNS Notifications para Pipeline CI/CD

Este módulo crea un sistema de **notificaciones automáticas** para un pipeline en AWS (CodePipeline), utilizando:

El objetivo es **recibir alertas por email** cuando un pipeline finaliza con éxito, falla o es detenido.

---

## 🚀 Funcionalidades

- Crea un **tópico SNS** para notificaciones del pipeline.
- Suscribe automáticamente **una lista de emails** al tópico.
- Configura una **regla de EventBridge** que detecta cambios de estado del pipeline:
  - `SUCCEEDED`
  - `FAILED`
  - `STOPPED`

---

## 🧩 Variables de entrada

| Variable | Tipo | Descripción | Default |
|----------|------|-------------|---------|
| `name_prefix` | string | Prefijo para nombrar recursos (ej. proyecto-entorno) | n/a |
| `pipeline_name` | string | Nombre del CodePipeline a monitorear | n/a |
| `email_subscriptions` | list(string) | Lista de correos electrónicos que recibirán notificaciones | `[]` |
| `tags` | map(string) | Tags comunes para todos los recursos | `{}` |

---

## 📤 Outputs

| Output | Descripción |
|--------|-------------|
| `topic_arn` | ARN del tópico SNS creado |
| `event_rule_name` | Nombre de la regla de EventBridge que dispara notificaciones |

---

## 🧩 Ejemplo de uso

```hcl
module "pipeline_sns" {
  source = "./modules/sns"

  name_prefix        = "miapp-dev"
  pipeline_name      = "miapp-pipeline"
  email_subscriptions = ["dev1@example.com", "dev2@example.com"]

  tags = {
    Project = "miapp"
    Env     = "dev"
  }
}
