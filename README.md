# Terraform Azure Landing Zone Modules - Repository Documentation

## Overview

This repository contains a comprehensive set of reusable Terraform modules for deploying Azure infrastructure following Infrastructure-as-Code best practices. Our modularization approach emphasizes consistency, reusability, and maintainability across enterprise-scale deployments.

## Documentation Structure

- **📖 README.md**: This file - Repository documentation and architecture overview
- **🎯 LLM_Terraform_Module_Prompt.md**: Expert-level prompt for LLMs to replicate our modularization strategy
- **📁 modules/**: Actual Terraform modules following our established patterns

**For LLM Implementation**: Use `LLM_Terraform_Module_Prompt.md` as your step-by-step instruction guide when creating new modules to ensure architectural consistency.

## Architecture Principles

### 1. Centralized Naming Convention
All resources use a centralized naming module that ensures consistent resource naming across the entire infrastructure:

```hcl
# Example: rg-plat-conn-eus-001
# Format: {resource_type}-{application_code}-{key}-{location}-{instance}
```

**Key Components:**
- **Resource Type Slugs**: Each Azure resource type has a predefined 2-3 character slug (e.g., `rg` for resource groups, `vnet` for virtual networks)
- **Global Settings**: Application codes, location codes, and environment codes are defined globally
- **Instance Versioning**: Automatic instance numbering for resource scaling

#### How the Naming Module Works

The naming module (`modules/_global/modules/naming/`) is the heart of your consistent naming strategy. Here's how to implement and use it:

##### Step 1: Create the Naming Module Structure
```bash
mkdir -p modules/_global/modules/naming
cd modules/_global/modules/naming
```

##### Step 2: Implement main.tf (Naming Logic)
```hcl
locals {
  default_separator         = "-"
  default_key_split         = try(split("_", var.key)[0], null)
  default_instance_version  = try(split("_", var.key)[1], "001")
  default_location          = try(var.settings.location_code, var.global_settings.location_code, null)
  default_application_code  = try(var.global_settings.application_code, null)
  default_environment_code  = try(var.global_settings.environment_code, null)
  default_organization_code = can(local.resource_type.organization_code) ? var.global_settings.organization_code : null
  resource_type             = try(local.resource_types[var.resource_type], null)
  separator                 = try(local.resource_type.separator, local.default_separator)
  slug                      = try(local.resource_type.slug, null)
  suffixes                  = compact([local.default_application_code, local.default_organization_code, local.default_key_split, local.default_environment_code, local.default_location, local.default_instance_version])
  resource_name = try(
    join(local.separator, compact(concat([local.slug], local.suffixes))),
    null
  )
}
```

##### Step 3: Create Resource Types Registry (resource_types.tf)
```hcl
locals {
  resource_types = {
    # Standard resources with hyphen separator
    azurerm_resource_group = {
      slug = "rg"
    }
    azurerm_virtual_network = {
      slug = "vnet"
    }
    azurerm_subnet = {
      slug = "snet"
    }

    # Resources without separator (compact naming)
    azurerm_storage_account = {
      separator         = ""    # No separator between parts
      organization_code = true # Include org code in name
      slug              = "sa"
    }
    azurerm_key_vault = {
      separator         = ""
      organization_code = true
      slug              = "kv"
    }

    # Add your new resource types here
    azurerm_your_resource = {
      slug = "your"  # 2-3 character abbreviation
      # separator = "-"  # optional, defaults to "-"
      # organization_code = true  # optional, include org code in name
    }
  }
}
```

##### Step 4: Implement variables.tf
```hcl
variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "settings" {
  type        = any
  default     = {}
  description = "Provides the configuration values for the specific resources being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "client_config" {
  type        = any
  default     = null
  description = "Data source to access the configurations of the Azurerm provider"
}

variable "remote_states" {
  type        = any
  default     = {}
  description = "Outputs from the previous deployments that are stored in additional Terraform State Files"
}

variable "resource_type" {
  type        = any
  description = "Type of Azure Service being used"
}
```

##### Step 5: Implement outputs.tf
```hcl
output "result" {
  value       = local.resource_name
  description = "Specifies the name of the Named Resource"
}
```

#### How Resource Names Are Generated

The naming module parses inputs and builds names according to this logic:

**Input Parsing:**
```hcl
# Key format: "identifier_version" or just "identifier"
# Examples: "web_002", "database", "shared"

locals {
  # Split key on "_" - first part is identifier, second is version
  default_key_split         = try(split("_", var.key)[0], null)      # "web", "database"
  default_instance_version  = try(split("_", var.key)[1], "001")     # "002", "001"
}
```

**For Multiple Resources (Avoiding Naming Conflicts):**
```hcl
# Method 1: Use different identifiers
resource_groups = {
  web  = {}  # → "rg-plat-web-prod-eus-001"
  api  = {}  # → "rg-plat-api-prod-eus-001"
  data = {}  # → "rg-plat-data-prod-eus-001"
}

# Method 2: Use explicit versions in key
resource_groups = {
  web_001 = {}  # → "rg-plat-web-prod-eus-001"
  web_002 = {}  # → "rg-plat-web-prod-eus-002"
  web_003 = {}  # → "rg-plat-web-prod-eus-003"
}
```

**Global Settings Integration:**
```hcl
# Global settings provide consistent values across all resources
global_settings = {
  application_code = "plat"     # Application identifier
  location_code    = "eus"      # Location code
  environment_code = "prod"     # Environment
  organization_code = "wiz"     # Organization (when needed)
}
```

**Name Assembly:**
```hcl
# Final name = join(separator, [slug, app_code, org_code?, identifier, env_code, location, version])
# Example: "rg-plat-conn-eus-001"

suffixes = compact([
  "plat",           # application_code
  null,             # organization_code (only if resource_type.organization_code = true)
  "conn",           # key identifier
  "prod",           # environment_code
  "eus",            # location_code
  "001"             # instance version
])
```

#### Resource Type Configuration Options

Each resource type in `resource_types.tf` can have these properties:

```hcl
locals {
  resource_types = {
    # Basic configuration (uses defaults)
    azurerm_resource_group = {
      slug = "rg"  # 2-3 character abbreviation
    }

    # Compact naming (no separators)
    azurerm_storage_account = {
      separator         = ""     # Empty string = no separator
      organization_code = true   # Include organization in name
      slug              = "sa"
    }

    # Custom separator
    azurerm_custom_resource = {
      separator         = "_"
      organization_code = false
      slug              = "cust"
    }
  }
}
```

#### Naming Examples

**Standard Resources (with hyphens):**
```hcl
# Input: key = "web_002", resource_type = "azurerm_resource_group"
# Global: application_code = "plat", location_code = "eus", environment_code = "prod"
# Output: "rg-plat-web-prod-eus-002"
```

**Compact Resources (no separators):**
```hcl
# Input: key = "data", resource_type = "azurerm_storage_account"
# Global: organization_code = "wiz", application_code = "plat", location_code = "eus"
# Output: "sawizplatdataeuseus" (no separators, includes org code)
```

**Custom Separators:**
```hcl
# With separator = "_": "rg_plat_web_prod_eus_002"
# With separator = "": "rgplatwebprodeus002"
```

#### When to Add Organization Code

Use `organization_code = true` for globally unique resources:
- **Storage Accounts**: Must be globally unique
- **Key Vaults**: Must be globally unique
- **Container Registries**: Should be globally unique

Don't use for region-specific resources:
- **Resource Groups**: Region-scoped
- **Virtual Networks**: Region-scoped
- **Subnets**: Region-scoped

#### Best Practices for Resource Type Slugs

1. **Keep slugs 2-3 characters** for readability
2. **Use common abbreviations** that match Azure documentation
3. **Be consistent** with existing patterns
4. **Avoid conflicts** with other resource types
5. **Document special cases** in comments

Common slug patterns:
- `rg` → Resource Group
- `vnet` → Virtual Network
- `snet` → Subnet
- `nsg` → Network Security Group
- `vm` → Virtual Machine
- `sa` → Storage Account (compact)
- `kv` → Key Vault (compact)
- `cr` → Container Registry (compact)

#### Complete Naming Flow Example

Here's how the naming works end-to-end:

**1. terraform.tfvars:**
```hcl
# Multiple resource groups with different keys
resource_groups = {
  web_001 = {}  # Version 001 specified
  web_002 = {}  # Version 002 specified
  api     = {}  # No version = defaults to 001
}
```

**2. Global Settings:**
```hcl
global_settings = {
  application_code = "plat"
  location_code    = "eus"
  environment_code = "prod"
  # organization_code only used for globally unique resources
}
```

**3. Naming Module Processing:**
```hcl
# Processing for each resource:
# web_001: key_split = "web", instance_version = "001" → "rg-plat-web-prod-eus-001"
# web_002: key_split = "web", instance_version = "002" → "rg-plat-web-prod-eus-002"
# api:     key_split = "api", instance_version = "001" → "rg-plat-api-prod-eus-001"
```

**4. Resource Creation:**
```hcl
# Each gets a unique name
resource "azurerm_resource_group" "web_001" {
  name     = module.name["web_001"].result  # "rg-plat-web-prod-eus-001"
  location = var.global_settings.location_name
}

resource "azurerm_resource_group" "web_002" {
  name     = module.name["web_002"].result  # "rg-plat-web-prod-eus-002"
  location = var.global_settings.location_name
}

resource "azurerm_resource_group" "api" {
  name     = module.name["api"].result      # "rg-plat-api-prod-eus-001"
  location = var.global_settings.location_name
}
```

#### Adding New Resource Types

**ALWAYS add to resource_types.tf first:**
```hcl
# Add this to locals.resource_types
azurerm_your_new_resource = {
  slug              = "ynr"  # Choose appropriate 2-3 char slug
  separator         = "-"   # Use "-" unless compact naming needed
  organization_code = false # Only true for globally unique resources
}
```

**Then use in your module:**
```hcl
module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_your_new_resource"  # Must match resource_types.tf key
}

# In your resource definition:
resource "azurerm_your_resource" "this" {
  name = try(var.settings.name, module.name.result)  # Use explicit name OR generated name
  # ... other settings
}
```

### 2. Module Structure Pattern

Each module follows a consistent structure:

```
terraform-azurerm-{resource_type}/
├── main.tf           # Resource definition and logic
├── variables.tf      # Input variable definitions (minimal, no validation)
├── outputs.tf        # Output definitions
└── README.md         # Module-specific documentation (auto-generated)
```

### 3. Simplified Settings-Only Pattern

**✅ IMPLEMENT THIS PATTERN EXACTLY:**
```hcl
# In terraform.tfvars - MINIMAL configuration, let naming module generate names
resource_groups = {
  conn = {
    # NO explicit name needed - naming module generates: "rg-plat-conn-eus-001"
    # Only specify overrides if needed (rare)
    # location = "East US"  # Override if different from global_settings.location_name
  }
}

# In main.tf - Clean module calls
module "resource_groups" {
  source = "github.com/org/tf-shared//modules/terraform-azurerm-resource_group?ref=main"
  for_each = var.resource_groups

  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
  tags            = var.tags
}
```

#### When to Override Generated Names

**RARE EXCEPTIONS** - Only override naming module when you MUST use a specific name:
```hcl
# terraform.tfvars - Only when you MUST use a specific existing name
resource_groups = {
  legacy = {
    name = "my-existing-resource-group"  # Existing resource you can't rename
    # location will still use global_settings.location_name
  }
}
```

**✅ NORMAL PATTERN** - Let naming module handle everything:
```hcl
# terraform.tfvars - Naming module generates consistent names
resource_groups = {
  web = {}      # → "rg-plat-web-prod-eus-001"
  data = {}     # → "rg-plat-data-prod-eus-001"
  shared = {}   # → "rg-plat-shared-prod-eus-001"
}
```

**❌ NEVER IMPLEMENT THIS ANTI-PATTERN:**
```hcl
# This pattern with dual variables is FORBIDDEN
variable "resource_group" {
  type = object({
    name     = optional(string)
    location = string
  })
}

# Complex fallback logic is FORBIDDEN:
# name = try(var.settings.name, var.resource_group.name, module.name.result)
```

## Module Categories

### Core Infrastructure Modules
- **Resource Groups** (`terraform-azurerm-resource_group`)
- **Virtual Networks** (`terraform-azurerm-virtual_network`)
- **Subnets** (`terraform-azurerm-subnet`)
- **Network Security Groups** (`terraform-azurerm-network_security_group`)
- **Route Tables** (`terraform-azurerm-route_table`)

### Association Modules
- **Subnet-NSG Associations** (`terraform-azurerm-subnet_network_security_group_association`)
- **Subnet-Route Table Associations** (`terraform-azurerm-subnet_route_table_association`)
- **Virtual Network Peerings** (`terraform-azurerm-virtualnetworkpeering`)

### Service Modules
- **Storage Accounts** (`terraform-azurerm-storage_account`)
- **Key Vaults** (`terraform-azurerm-key_vault`)
- **Log Analytics** (`terraform-azurerm-log_analytics_workspace`)
- **Container Registry** (`terraform-azurerm-container_registry`)
- **Kubernetes Clusters** (`terraform-azurerm_kubernetes_cluster`)
- **Virtual Machines** (`terraform-azurerm-linux_virtual_machine`)

### Security & Governance
- **Policy Definitions** (`terraform-azurerm-policy_definition`)
- **Policy Set Definitions** (`terraform-azurerm-policy_set_definition`)
- **Role Assignments** (`terraform-azurerm-role_assignment`)
- **Diagnostic Settings** (`terraform-azurerm-diagnostic_settings`)

## Step-by-Step Module Creation Instructions

### Step 1: Analyze the Azure Resource Documentation
1. **Study the Terraform azurerm provider documentation** for the resource you want to implement
2. **Identify all possible configuration blocks** (dynamic blocks, nested configurations)
3. **Note required vs optional parameters**
4. **Understand resource dependencies** and relationships

### Step 2: Add Resource Type to Naming Module
**ALWAYS add your new resource type to `modules/_global/modules/naming/resource_types.tf` FIRST:**

```hcl
locals {
  resource_types = {
    # ... existing entries ...

    azurerm_your_resource = {
      slug = "your"  # 2-3 character abbreviation
      # separator = "-"  # optional, defaults to "-"
      # organization_code = true  # optional, set to true for globally unique resources
    }
  }
}
```

**Choose the right slug (2-3 characters):**
- `rg` for resource groups
- `vnet` for virtual networks
- `sa` for storage accounts (use `organization_code = true`)
- `kv` for key vaults (use `organization_code = true`)
- `vm` for virtual machines
- `cr` for container registries (use `organization_code = true`)

**Set `organization_code = true` for:**
- Storage Accounts (globally unique)
- Key Vaults (globally unique)
- Container Registries (globally unique)
- Any other globally unique Azure resources

### Step 3: Create Module Directory Structure
```bash
mkdir -p modules/terraform-azurerm-your_resource
cd modules/terraform-azurerm-your_resource
```

### Step 4: Implement variables.tf (CRITICAL - Follow exactly)
```hcl
variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "settings" {
  type        = any
  default     = {}
  description = "Provides the configuration values for the specific resources being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "client_config" {
  type        = any
  default     = null
  description = "Data source to access the configurations of the Azurerm provider"
}

variable "remote_states" {
  type        = any
  default     = {}
  description = "Outputs from the previous deployments that are stored in additional Terraform State Files"
}

variable "resource_groups" {
  type        = any
  default     = {}
  description = "Resource Groups previously created and being referenced with an Instance key"
}

# Add additional dependency variables as needed (e.g., subnets, virtual_networks)
# NEVER add strongly typed variables with validation or defaults

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
```

### Step 5: Implement main.tf (CRITICAL - Follow exactly)
```hcl
# ALWAYS include this header
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# ALWAYS include the naming module call
module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_your_resource"  # Must match resource_types.tf entry
}

# Create locals for dependency resolution (if needed)
locals {
  # ALWAYS use this pattern for resource group resolution
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)

  # Add other dependency resolutions as needed
  # subnet = can(var.settings.subnet.state_key) ? try(var.remote_states[var.settings.subnet.state_key].subnets[var.settings.subnet.key], null) : try(var.subnets[var.settings.subnet.key], null)
}

# Main resource definition
resource "azurerm_your_resource" "this" {
  # ALWAYS use this pattern for name resolution
  name = try(var.settings.name, module.name.result)

  # ALWAYS use this pattern for resource group
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name)

  # ALWAYS use this pattern for location
  location = try(var.settings.location, var.global_settings.location_name)

  # Use try() for ALL other settings - NEVER use complex fallback chains
  setting1 = try(var.settings.setting1, null)
  setting2 = try(var.settings.setting2, null)

  # Use dynamic blocks for optional complex configurations
  dynamic "complex_config" {
    for_each = try(var.settings.complex_config, null) != null ? [var.settings.complex_config] : []
    content {
      nested_setting = complex_config.value.nested_setting
      # ... more nested settings
    }
  }

  # ALWAYS include tags
  tags = var.tags
}
```

### Step 6: Implement outputs.tf
```hcl
output "your_resource" {
  description = "The Your Resource resource"
  value       = azurerm_your_resource.this
  sensitive   = false  # Set to true if resource contains sensitive data
}
```

### Step 7: Test Your Module
1. **Create a test configuration** in terraform.tfvars
2. **Test with minimal configuration** first
3. **Test with full configuration** including all optional blocks
4. **Verify naming works correctly**
5. **Test dependency injection** patterns

## Key Design Patterns (IMPLEMENT THESE EXACTLY)

### 1. **Simplified Settings-Only Configuration**
**MANDATORY IMPLEMENTATION:**
- **Single `settings` variable**: Contains ALL configuration
- **No strongly typed variables**: Never create `variable "your_resource"`
- **Simple fallback logic**: Always use `try(var.settings.field, null)`
- **No complex chains**: Never use `try(var.settings.field, var.typed_var.field, module.name.result)`

### 2. **Dependency Injection**
**MANDATORY IMPLEMENTATION:**
```hcl
# In root main.tf - Pass module outputs as inputs
module "dependent_resources" {
  source   = "./modules/terraform-azurerm-your_resource"
  for_each = var.your_resources

  # ... standard variables ...
  resource_groups = module.resource_groups  # Inject dependency
  subnets         = module.subnets          # Inject dependency
}
```

### 3. **Association Separation**
**IMPLEMENT WHEN NEEDED:**
```hcl
# Use dedicated association resources for many-to-many relationships
resource "azurerm_association_resource" "this" {
  for_each = {
    for k, v in var.resources : k => v
    if can(v.association.key)  # Conditional creation
  }

  resource_id          = module.resources[each.key].resource.id
  associated_resource_id = module.associated_resources[each.value.association.key].resource.id
}
```

### 4. **Global Settings Inheritance**
**MANDATORY IMPLEMENTATION:**
- **Always accept `global_settings`** as input
- **Use for location**: `try(var.settings.location, var.global_settings.location_name)`
- **Use for naming**: Pass to naming module
- **Consistent across all modules**

## Configuration Management Rules

### terraform.tfvars Structure
```hcl
# global.auto.tfvars - Global settings
global_settings = {
  application_code = "plat"
  location_code    = "eus"
  location_name    = "East US"
  org_name         = "WizArd"
  business_unit    = "Platform Engineering"
}

# terraform.tfvars - Resource-specific configuration
your_resources = {
  example = {
    # Minimal configuration - let naming module handle the rest
    resource_group = {
      key = "shared"  # Reference by key, not name
    }
    # Add any resource-specific settings here
    setting1 = "value1"
    setting2 = "value2"
  }
}
```

### Module Orchestration
```hcl
# main.tf - Clean, dependency-ordered module calls
data "azurerm_client_config" "current" {}

# 1. Foundation resources first
module "resource_groups" {
  source   = "./modules/terraform-azurerm-resource_group"
  for_each = var.resource_groups

  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
  tags            = var.tags
}

# 2. Dependent resources with injected dependencies
module "your_resources" {
  source   = "./modules/terraform-azurerm-your_resource"
  for_each = var.your_resources

  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
  resource_groups = module.resource_groups  # Dependency injection
  tags            = var.tags
}
```

## Best Practices for Module Creation

### Module Development
1. **Single settings variable**: Use only the `settings` variable, eliminate strongly typed variables
2. **Keep modules focused**: Each module should do one thing well
3. **Use consistent variable patterns**: `key`, `settings`, `global_settings`, `tags`
4. **Leverage the naming module**: Never hardcode resource names
5. **Simple fallback logic**: Use `try(var.settings.field, null)` instead of complex chains
6. **Document thoroughly**: Include examples and parameter descriptions

### Configuration Management
1. **Use terraform.tfvars**: Keep all configuration in `terraform.tfvars` files
2. **Environment-specific files**: Use `global.auto.tfvars` for shared settings
3. **Reference by keys**: Use semantic keys instead of resource names
4. **Version your modules**: Use Git tags instead of branch references
5. **Avoid dual variables**: Never mix `settings` with strongly typed variables

### Deployment Strategy
1. **Incremental deployments**: Deploy infrastructure in logical layers
2. **State management**: Use remote state for cross-deployment references
3. **Testing**: Validate modules with different configuration scenarios
4. **Documentation**: Keep READMEs updated with usage examples

## Migration Notes

### From Dual Variable Pattern
If migrating from the old dual variable pattern:

1. **Remove strongly typed variables**: Delete variables like `kubernetes_cluster`, `storage_account`, etc.
2. **Simplify try() statements**: Replace complex fallback chains with simple `try(var.settings.field, null)`
3. **Update terraform.tfvars**: Move all configuration from strongly typed variables to the `settings` object
4. **Remove fallback logic**: No more `var.typed_var != null ? var.typed_var.field : null`

### Before and After Example
```hcl
# OLD (Complex) - NEVER DO THIS
name = try(var.settings.name, var.kubernetes_cluster != null ? var.kubernetes_cluster.name : null, module.name.result)

# NEW (Simple) - ALWAYS DO THIS
name = try(var.settings.name, module.name.result)
```

### Version Pinning
Update module sources to use tags instead of branches:
```hcl
# Instead of
source = "github.com/org/repo//modules/resource?ref=main"

# Use
source = "github.com/org/repo//modules/resource?ref=1.0.0"
```

## Contributing

When adding new modules:

1. **Follow the established naming convention**: `terraform-azurerm-{resource_type}`
2. **Implement the standard module structure** exactly as documented
3. **Add resource type definition** to the naming module FIRST
4. **Test the module** with multiple configuration scenarios
5. **Update this README** with usage examples if adding major new categories

## LLM Implementation Checklist

Before submitting a new module, verify:

- [ ] Resource type added to `modules/_global/modules/naming/resource_types.tf` with appropriate slug and settings
- [ ] `organization_code = true` set for globally unique resources (storage accounts, key vaults, etc.)
- [ ] Module directory follows `terraform-azurerm-{resource_type}` naming convention
- [ ] `variables.tf` uses EXACT pattern (no validation, no defaults except empty collections)
- [ ] `main.tf` includes naming module call with correct `resource_type` parameter
- [ ] All settings use `try(var.settings.field, null)` pattern - NO complex fallback chains
- [ ] All dependencies resolved using local blocks with `can()` and `try()` patterns
- [ ] `outputs.tf` exposes the main resource with `sensitive = true` for secrets
- [ ] Module tested with minimal configuration (just key and resource_group)
- [ ] Module tested with full configuration including all optional blocks
- [ ] No strongly typed variables created (only `settings`, `global_settings`, etc.)
- [ ] No complex fallback chains like `try(var.settings.field, var.typed_var.field, module.name.result)`
- [ ] README.md auto-generated by terraform-docs (not manually created)

This modularization approach provides a scalable, maintainable foundation for enterprise Azure infrastructure deployments while ensuring consistency and reusability across teams and projects.