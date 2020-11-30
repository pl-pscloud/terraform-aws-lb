output "pscloud_lb_dns_name" {
  value       = aws_lb.pscloud-lb.dns_name
}

output "pscloud_lb_zone_id" {
  value       = aws_lb.pscloud-lb.zone_id
}

output "pscloud_lb_tg_arns" {
  value       = aws_lb_target_group.pscloud-lb-tg
}

output "pscloud_lb_lsiteners" {
  value       = aws_lb_listener.pscloud-lb-listener
}

output "pscloud_lb_id" {
  value       = aws_lb.pscloud-lb.id
}