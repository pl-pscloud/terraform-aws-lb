resource "aws_lb" "pscloud-lb" {
  name                  = "${var.pscloud_company}-elb-${var.pscloud_env}"
  internal              = false
  load_balancer_type    = "application"
  subnets               = var.pscloud_subnets_ids
  security_groups       = [ var.pscloud_sec_gr ]

  enable_deletion_protection = false

  tags = {
    Name                = "${var.pscloud_company}_elb_${var.pscloud_env}"
  }
}

resource "aws_lb_target_group" "pscloud-lb-tg" {
  name                  = "tf-lb-tg"
  port                  = 80
  protocol              = "HTTP"
  vpc_id                = var.pscloud_vpc_id

  tags = {
    Name                = "${var.pscloud_company}_lb_target_group_${var.pscloud_env}"
  }
}

resource "aws_lb_listener" "pscloud-lb-listener" {
  for_each = var.pscloud_ports

  load_balancer_arn = aws_lb.pscloud-lb.arn
  port                  = split(",", each.value)[0]
  protocol              = each.key
  certificate_arn       = split(",", each.value)[1]
  ssl_policy            = split(",", each.value)[2]


  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.pscloud-lb-tg.arn
  }
}

resource "aws_lb_listener_rule" "pscloud-lb-listener-rule" {
  for_each             = aws_lb_listener.pscloud-lb-listener
  listener_arn          = aws_lb_listener.pscloud-lb-listener[each.key].arn
  priority              = 99

  action {
    type                = "forward"
    target_group_arn = aws_lb_target_group.pscloud-lb-tg.arn
  }

  condition {
    field               = "host-header"
    values               = [ var.pscloud_domain_name ]
  }
}

resource "aws_lb_target_group_attachment" "pscloud-lb-tg-attachment" {
  count                 = length(var.pscloud_ec2_ids)
  target_group_arn      = aws_lb_target_group.pscloud-lb-tg.arn
  target_id             = var.pscloud_ec2_ids[count.index]
  port                  = 80
}