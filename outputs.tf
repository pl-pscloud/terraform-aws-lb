output "pscloud_lb_dns_name" {
  value       = var pscloud_lb_type = "application" ? aws_lb.pscloud-alb.dns_name ? aws_lb.pscloud-nlb.dns_name
}

output "pscloud_lb_zone_id" {
  value       = var pscloud_lb_type = "application" ? aws_lb.pscloud-alb.zone_id ? aws_lb.pscloud-nlb.zone_id
}

output "pscloud_lb_tg_arns" {
  value       = aws_lb_target_group.pscloud-lb-tg
}

output "pscloud_lb_lsiteners" {
  value       = aws_lb_listener.pscloud-lb-listener
}

output "pscloud_lb_id" {
  value       = var pscloud_lb_type = "application" ? aws_alb.pscloud-alb.id : aws_alb.pscloud-nlb.id
}