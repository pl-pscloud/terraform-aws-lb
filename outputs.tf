output "pscloud_lb_dns_name" {
  value       = var.pscloud_lb_type == "application" ? aws_lb.pscloud-alb[0].dns_name : aws_lb.pscloud-nlb[0].dns_name
}

output "pscloud_lb_zone_id" {
  value       = var.pscloud_lb_type == "application" ? aws_lb.pscloud-alb[0].zone_id : aws_lb.pscloud-nlb[0].zone_id
}

output "pscloud_lb_tg_arns" {
  value       = aws_lb_target_group.pscloud-lb-tg
}

output "pscloud_lb_lsiteners" {
  value       = aws_lb_listener.pscloud-lb-listener
}

output "pscloud_lb_id" {
  value       = var.pscloud_lb_type == "application" ? aws_alb.pscloud-alb[0].id : aws_alb.pscloud-nlb[0].id
}