variable "association" {
  description = "Configuration for the subnet route table association"
  type = object({
    subnet_id      = string
    route_table_id = string
  })
} 