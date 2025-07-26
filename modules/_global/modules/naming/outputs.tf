output "result" {
  value = try(
    var.settings.name,
    local.resource_name
  )
  description = "Specifies the name of the Named Resource"
}
