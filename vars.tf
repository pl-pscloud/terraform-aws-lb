variable "pscloud_env" {}
variable "pscloud_company" {}

variable "pscloud_lb_type" { default = "application" }

variable "pscloud_vpc_id" {}

variable "pscloud_subnets_ids" {}
variable "pscloud_sec_gr" { default = "" }

variable "pscloud_idle_timeout" { default = 60 }
variable "enable_deletion_protection" { default = false }

variable "pscloud_target_groups" {
  type = map(object({
    index     = string
    name      = string
    protocol  = string
    port      = number
  }))
  
  default = {
    
  }
}

variable "pscloud_listeners" {
  type = map(object({
    tg_index    = string
    port        = number
    protocol    = string
    cert_arn    = string
  }))
  
  default = {
    
  }
}

variable "pscloud_certificates" {
  type = map(object({
    listener_index    = string
    cert_arn          = string
  }))
  
  default = {
    
  }
}

variable "pscloud_listeners_redirect_rules" {
  type = map(object({
    tg_index        = string
    li_index        = string
    port            = number
    protocol        = string
    host_header     = string
  }))

  default = {
    
  }
}

variable "pscloud_listeners_forward_rules" {
  type = map(object({
    tg_index        = string
    li_index        = string
    host_header     = string
  }))

  default = {

  }
}



