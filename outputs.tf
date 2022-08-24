output "pscloud_alb_dns_name" {
  value       = var.pscloud_lb_type == "application" ? aws_lb.pscloud-alb[0].dns_name : null
}

output "pscloud_alb_zone_id" {
  value       = var.pscloud_lb_type == "application" ? aws_lb.pscloud-alb[0].zone_id : null
}

output "pscloud_alb_id" {
  value       = var.pscloud_lb_type == "application" ? aws_alb.pscloud-alb[0].id : null
}

output "pscloud_nlb_dns_name" {
  value       = var.pscloud_lb_type == "network" ? aws_lb.pscloud-nlb[0].dns_name : null
}

output "pscloud_nlb_zone_id" {
  value       = var.pscloud_lb_type == "network" ? aws_lb.pscloud-nlb[0].zone_id : null
}

output "pscloud_nlb_id" {
  value       = var.pscloud_lb_type == "network" ? aws_lb.pscloud-nlb[0].id : null
}

output "pscloud_lb_tg_arns" {
  value       = aws_lb_target_group.pscloud-lb-tg
}

output "pscloud_lb_lsiteners" {
  value       = aws_lb_listener.pscloud-lb-listener
}
