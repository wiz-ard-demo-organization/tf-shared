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
