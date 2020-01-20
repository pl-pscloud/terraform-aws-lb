variable "pscloud_env" {}
variable "pscloud_company" {}

variable "pscloud_vpc_id" {}

variable "pscloud_subnets_ids" {}
variable "pscloud_sec_gr" {}

variable "pscloud_ec2_ids" {}

variable "pscloud_target_groups" {
  type = list(object({
    index     = number
    name      = string
    protocol  = string
    port      = number
  }))
}

variable "pscloud_listeners" {
  type = list(object({
    tg_index    = number
    port        = number
    protocol    = string
    cert_arn    = string
  }))
}

variable "pscloud_certificates" {
  type = list(object({
    listener_index    = number
    cert_arn          = string
  }))
}

variable "pscloud_listeners_redirect_rules" {
  type = list(object({
    tg_index        = number
    li_index        = number
    port            = number
    protocol        = string
    host_header     = string
  }))
}

variable "pscloud_listeners_forward_rules" {
  type = list(object({
    tg_index        = number
    li_index        = number
    port            = number
    protocol        = string
    host_header     = string
  }))
}



