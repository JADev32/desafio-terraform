# 📦 AWS ECR Module (Terraform)

Este módulo crea repositorios de **Amazon ECR** para almacenar imágenes Docker del **frontend** y **MySQL**, incluyendo reglas de ciclo de vida para mantener el repositorio limpio y optimizado.

---

## 🏗️ ¿Qué crea este módulo?

Este módulo provisiona:

### 📁 Repositorios ECR
- Un repositorio ECR para **frontend**:  
  `name-frontend`
- Un repositorio ECR para **mysql**:  
  `name-mysql`

### 🧹 Políticas de ciclo de vida (Lifecycle Policy)
Ambos repositorios incluyen una política que:

- Mantiene **solo las últimas 5 imágenes**
- Expira automáticamente las imágenes antiguas
- Aplica a **todas las tags** (`tagStatus = any`)

---

## ⚙️ Variables

| Variable | Tipo | Descripción | Requerida |
|---------|------|-------------|-----------|
| `name` | string | Prefijo para nombrar los repositorios ECR. | ✔️ |
| `tags` | map(string) | Tags adicionales para los recursos. | No (default `{}`) |

---

## 📤 Outputs

| Output | Descripción |
|--------|-------------|
| `frontend_repository_url` | URL del repositorio ECR del frontend. |
| `frontend_repository_arn` | ARN del repositorio ECR del frontend. |
| `mysql_repository_url` | URL del repositorio ECR de MySQL. |
| `mysql_repository_arn` | ARN del repositorio ECR de MySQL. |

---

## 🚀 Ejemplo de uso

```hcl
module "ecr" {
  source = "./modules/ecr"

  name = "lab3"
  tags = {
    Environment = "dev"
    Owner       = "lab3"
  }
}
```

📝 Notas

Ambos repositorios permiten image_tag_mutability = MUTABLE, lo cual permite sobrescribir tags existentes.
