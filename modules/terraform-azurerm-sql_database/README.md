# Azure SQL Database Terraform Module

This module creates and manages Azure SQL Server and SQL Database resources with comprehensive security and compliance features.

## Features

- **SQL Server**: Complete SQL Server configuration with authentication options
- **SQL Databases**: Multiple databases with various service tiers and features
- **Security**: Firewall rules, virtual network rules, and threat detection
- **Auditing**: Extended auditing and vulnerability assessment
- **Backup & Recovery**: Short-term and long-term retention policies
- **High Availability**: Zone redundancy and geo-backup options
- **Elastic Pools**: Cost-effective resource sharing for multiple databases
- **Identity Management**: System and user-assigned managed identities
- **Azure AD Integration**: Azure Active Directory authentication

## Usage

```hcl
module "sql_database" {
  source = "./modules/terraform-azurerm-sql_database"

  sql_server = {
    name                         = "sql-server-example-001"
    resource_group_name          = "rg-database"
    location                     = "East US"
    administrator_login          = "sqladmin"
    administrator_login_password = "P@ssw0rd123!"
    minimum_tls_version          = "1.2"
    public_network_access_enabled = false

    azuread_administrator = {
      login_username              = "sql-admins@company.com"
      object_id                   = "12345678-1234-1234-1234-123456789012"
      azuread_authentication_only = false
    }

    identity = {
      type = "SystemAssigned"
    }
  }

  sql_databases = {
    app_db = {
      name                        = "app-database"
      sku_name                    = "S2"
      max_size_gb                 = 250
      zone_redundant              = true
      geo_backup_enabled          = true
      transparent_data_encryption_enabled = true

      short_term_retention_policy = {
        retention_days = 14
      }

      long_term_retention_policy = {
        weekly_retention  = "P1W"
        monthly_retention = "P1M"
        yearly_retention  = "P1Y"
        week_of_year      = 1
      }

      threat_detection_policy = {
        state                = "Enabled"
        email_account_admins = true
        email_addresses      = ["security@company.com"]
        retention_days       = 30
      }
    }
  }

  firewall_rules = {
    allow_azure_services = {
      name             = "AllowAzureServices"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }

  virtual_network_rules = {
    app_subnet = {
      name      = "app-subnet-rule"
      subnet_id = "/subscriptions/.../subnets/app-subnet"
    }
  }

  extended_auditing_policy = {
    enabled                = true
    storage_endpoint       = "https://auditstorage.blob.core.windows.net/"
    storage_account_access_key = var.audit_storage_key
    retention_in_days      = 90
    log_monitoring_enabled = true
  }

  security_alert_policy = {
    state                = "Enabled"
    email_account_admins = true
    email_addresses      = ["security@company.com"]
    retention_days       = 30
  }

  tags = {
    Environment = "Production"
    Application = "WebApp"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_mssql_server | resource |
| azurerm_mssql_database | resource |
| azurerm_mssql_firewall_rule | resource |
| azurerm_mssql_virtual_network_rule | resource |
| azurerm_mssql_server_extended_auditing_policy | resource |
| azurerm_mssql_server_security_alert_policy | resource |
| azurerm_mssql_server_vulnerability_assessment | resource |
| azurerm_mssql_elastic_pool | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| sql_server | Configuration for the SQL Server | `object({...})` | n/a | yes |
| sql_databases | Map of SQL databases to create | `map(object({...}))` | `{}` | no |
| firewall_rules | Map of firewall rules for the SQL server | `map(object({...}))` | `{}` | no |
| virtual_network_rules | Map of virtual network rules for the SQL server | `map(object({...}))` | `{}` | no |
| extended_auditing_policy | Extended auditing policy configuration | `object({...})` | `null` | no |
| security_alert_policy | Security alert policy configuration | `object({...})` | `null` | no |
| vulnerability_assessment | Vulnerability assessment configuration | `object({...})` | `null` | no |
| elastic_pools | Map of elastic pools to create | `map(object({...}))` | `{}` | no |
| tags | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sql_server | The SQL Server resource |
| sql_server_id | The ID of the SQL Server |
| sql_server_fqdn | The fully qualified domain name of the SQL Server |
| sql_databases | Map of SQL databases |
| firewall_rules | Map of firewall rules |
| virtual_network_rules | Map of virtual network rules |
| elastic_pools | Map of elastic pools |

## Database SKUs

### Basic Tier
- `Basic`: 2GB, 5 DTUs

### Standard Tier
- `S0`: 250GB, 10 DTUs
- `S1`: 250GB, 20 DTUs
- `S2`: 250GB, 50 DTUs
- `S3`: 250GB, 100 DTUs
- `S4`: 250GB, 200 DTUs
- `S6`: 250GB, 400 DTUs
- `S7`: 250GB, 800 DTUs
- `S9`: 250GB, 1600 DTUs
- `S12`: 250GB, 3000 DTUs

### Premium Tier
- `P1`: 500GB, 125 DTUs
- `P2`: 500GB, 250 DTUs
- `P4`: 500GB, 500 DTUs
- `P6`: 500GB, 1000 DTUs
- `P11`: 1TB, 1750 DTUs
- `P15`: 1TB, 4000 DTUs

### vCore-based
- `GP_Gen5_2`: General Purpose, Gen5, 2 vCores
- `GP_Gen5_4`: General Purpose, Gen5, 4 vCores
- `BC_Gen5_2`: Business Critical, Gen5, 2 vCores
- `BC_Gen5_4`: Business Critical, Gen5, 4 vCores

## Examples

### Basic SQL Database
```hcl
module "basic_sql" {
  source = "./modules/terraform-azurerm-sql_database"

  sql_server = {
    name                         = "sql-basic-001"
    resource_group_name          = "rg-database"
    location                     = "East US"
    administrator_login          = "sqladmin"
    administrator_login_password = "P@ssw0rd123!"
  }

  sql_databases = {
    app_db = {
      name     = "app-database"
      sku_name = "Basic"
    }
  }

  tags = {
    Environment = "Development"
  }
}
```

### Enterprise SQL Database with Security
```hcl
module "enterprise_sql" {
  source = "./modules/terraform-azurerm-sql_database"

  sql_server = {
    name                         = "sql-enterprise-001"
    resource_group_name          = "rg-database"
    location                     = "East US"
    administrator_login          = "sqladmin"
    administrator_login_password = var.sql_admin_password
    minimum_tls_version          = "1.2"
    public_network_access_enabled = false

    azuread_administrator = {
      login_username              = "sql-admins@company.com"
      object_id                   = var.sql_admin_group_id
      azuread_authentication_only = true
    }

    identity = {
      type = "SystemAssigned"
    }
  }

  sql_databases = {
    production_db = {
      name                        = "production-database"
      sku_name                    = "P2"
      max_size_gb                 = 500
      zone_redundant              = true
      geo_backup_enabled          = true
      transparent_data_encryption_enabled = true
      ledger_enabled              = true

      short_term_retention_policy = {
        retention_days = 35
      }

      long_term_retention_policy = {
        weekly_retention  = "P4W"
        monthly_retention = "P12M"
        yearly_retention  = "P7Y"
        week_of_year      = 1
      }

      threat_detection_policy = {
        state                = "Enabled"
        email_account_admins = true
        email_addresses      = ["security@company.com"]
        retention_days       = 90
      }
    }
  }

  virtual_network_rules = {
    app_subnet = {
      name      = "app-subnet-rule"
      subnet_id = var.app_subnet_id
    }
    data_subnet = {
      name      = "data-subnet-rule"
      subnet_id = var.data_subnet_id
    }
  }

  extended_auditing_policy = {
    enabled                = true
    storage_endpoint       = var.audit_storage_endpoint
    storage_account_access_key = var.audit_storage_key
    retention_in_days      = 365
    log_monitoring_enabled = true
  }

  security_alert_policy = {
    state                = "Enabled"
    email_account_admins = true
    email_addresses      = ["security@company.com", "dba@company.com"]
    retention_days       = 90
  }

  vulnerability_assessment = {
    storage_container_path     = "${var.audit_storage_endpoint}vulnerability-assessment/"
    storage_account_access_key = var.audit_storage_key

    recurring_scans = {
      enabled                   = true
      email_subscription_admins = true
      emails                    = ["security@company.com"]
    }
  }

  tags = {
    Environment = "Production"
    Compliance  = "Required"
    Backup      = "Critical"
  }
}
```

### Elastic Pool Configuration
```hcl
module "elastic_pool_sql" {
  source = "./modules/terraform-azurerm-sql_database"

  sql_server = {
    name                         = "sql-pool-001"
    resource_group_name          = "rg-database"
    location                     = "East US"
    administrator_login          = "sqladmin"
    administrator_login_password = var.sql_admin_password
  }

  elastic_pools = {
    app_pool = {
      name         = "app-elastic-pool"
      license_type = "LicenseIncluded"
      max_size_gb  = 500

      sku = {
        name     = "StandardPool"
        tier     = "Standard"
        capacity = 100
      }

      per_database_settings = {
        min_capacity = 0
        max_capacity = 25
      }
    }
  }

  sql_databases = {
    app1_db = {
      name            = "app1-database"
      elastic_pool_id = "app_pool"
    }
    app2_db = {
      name            = "app2-database"
      elastic_pool_id = "app_pool"
    }
  }

  tags = {
    Environment = "Production"
    CostCenter  = "IT"
  }
}
```

## Security Best Practices

1. **Use Azure AD Authentication**: Enable Azure AD admin and consider disabling SQL authentication
2. **Network Security**: Disable public access and use virtual network rules
3. **Encryption**: Enable Transparent Data Encryption (TDE) with customer-managed keys
4. **Auditing**: Enable extended auditing and store logs in secure storage
5. **Threat Detection**: Enable Advanced Threat Protection for real-time monitoring
6. **Backup**: Configure appropriate retention policies for business requirements
7. **Access Control**: Use least privilege principle for database access

## Notes

- SQL Server names must be globally unique across Azure
- Private endpoints require additional configuration (use the private endpoint module)
- Elastic pools provide cost savings for multiple databases with varying usage patterns
- Vulnerability assessment requires security alert policy to be enabled
- Consider using Azure Key Vault for storing connection strings and passwords 