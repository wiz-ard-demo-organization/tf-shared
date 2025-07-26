variable "association" {
  description = "Configuration for the subnet NSG association"
  type = object({
    subnet_id                 = string
    network_security_group_id = string
  })
} 