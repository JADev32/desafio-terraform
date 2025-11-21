## 🌐 Documentación del Módulo Terraform: `network`

Este módulo crea una **VPC** (Virtual Private Cloud) con una configuración de red básica y altamente disponible en AWS, incluyendo subredes públicas y privadas, un Internet Gateway (IGW), un único NAT Gateway (NGW) y las tablas de ruteo asociadas.

-----

## 🏗️ Recursos Creados

  * **1** `aws_vpc`: La red principal.
  * **1** `aws_internet_gateway`: Permite la comunicación saliente e internet para la VPC.
  * **1** `aws_eip`: Dirección IP elástica dedicada para el NAT Gateway.
  * **1** `aws_nat_gateway`: Permite que las subredes privadas accedan a internet.
  * **N** `aws_subnet`: Subredes públicas y privadas, donde $N = \text{Número de AZs}$ (zonas de disponibilidad) configuradas.
  * **1** `aws_route_table`: Tabla de ruteo para las subredes públicas.
  * **N** `aws_route_table`: Tablas de ruteo para las subredes privadas (una por subred privada).

-----

## 📑 Ejemplo de Uso

```hcl
module "network" {
  source = "./modules/network"

  # Nombres
  name                 = "${var.project_name}-${var.environment}"
  
  # Bloque de red principal
  vpc_cidr             = "10.0.0.0/16"
  
  # Configuración de subredes (debe haber el mismo número en azs, public_subnet_cidrs y private_subnet_cidrs)
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.16.0/24"]
  private_subnet_cidrs = ["10.0.128.0/24", "10.0.144.0/24"]

  # Tags comunes
  tags = local.common_tags
}
```

-----

## 📥 Variables de Entrada (Inputs)

| Nombre | Descripción | Tipo | Valor por Defecto |
| :--- | :--- | :--- | :--- |
| **`name`** | Prefijo para nombres lógicos (tags Name) de todos los recursos. | `string` | n/a |
| **`vpc_cidr`** | CIDR block de la VPC (ej. `10.0.0.0/16`). | `string` | n/a |
| **`azs`** | Lista de AZs donde se crearán las subredes (ej. `["us-east-1a", "us-east-1b"]`). La cantidad define el número de subredes. | `list(string)` | n/a |
| **`public_subnet_cidrs`** | Lista de CIDRs para las subredes **públicas**, en el mismo orden que `azs`. | `list(string)` | n/a |
| **`private_subnet_cidrs`** | Lista de CIDRs para las subredes **privadas**, en el mismo orden que `azs`. | `list(string)` | n/a |
| **`tags`** | Tags comunes a aplicar a todos los recursos creados. | `map(string)` | `{}` |

-----

## 📤 Valores de Salida (Outputs)

| Nombre | Descripción | Valor |
| :--- | :--- | :--- |
| **`vpc_id`** | ID de la VPC creada. | `aws_vpc.this.id` |
| **`vpc_cidr_block`** | CIDR de la VPC. | `aws_vpc.this.cidr_block` |
| **`internet_gateway_id`** | ID del Internet Gateway (IGW). | `aws_internet_gateway.this.id` |
| **`nat_gateway_id`** | ID del NAT Gateway (NGW) creado. | `aws_nat_gateway.this.id` |
| **`public_subnet_ids`** | Lista de IDs de subnets públicas. | `aws_subnet.public.*.id` |
| **`private_subnet_ids`** | Lista de IDs de subnets privadas. | `aws_subnet.private.*.id` |
| **`public_route_table_id`** | ID de la Route table pública (con ruta a IGW). | `aws_route_table.public.id` |
| **`private_route_table_ids`** | Lista de IDs de Route tables privadas (con ruta a NGW). | `aws_route_table.private.*.id` |





