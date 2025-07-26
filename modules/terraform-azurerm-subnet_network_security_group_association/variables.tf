variable "association" {
  description = <<EOT
    association = {
      subnet_id : "(Required) The ID of the Subnet. Changing this forces a new resource to be created."
      network_security_group_id : "(Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new resource to be created."
    }
  EOT
  type = object({
    subnet_id                 = string
    network_security_group_id = string
  })
} 