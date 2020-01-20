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
  count                 = length(var.pscloud_target_groups)
  name                  = var.pscloud_target_groups[count.index].name
  port                  = var.pscloud_target_groups[count.index].port
  protocol              = var.pscloud_target_groups[count.index].protocol
  vpc_id                = var.pscloud_vpc_id

  tags = {
    Name                = "${var.pscloud_company}_lb_tg_${var.pscloud_target_groups[count.index].name}_${var.pscloud_env}"
  }
}


resource "aws_lb_listener" "pscloud-lb-listener" {
  count                 = length(var.pscloud_listeners)

  load_balancer_arn = aws_lb.pscloud-lb.arn
  port                  = var.pscloud_listeners[count.index].port
  protocol              = var.pscloud_listeners[count.index].protocol

  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.pscloud-lb-tg[var.pscloud_listeners[count.index].tg_index].arn
  }
}

resource "aws_lb_listener_certificate" "pscloud-lb-certs" {
  count                 = length(var.pscloud_certificates)

  certificate_arn       = var.pscloud_certificates[count.index].cert_arn
  listener_arn          = aws_lb_listener.pscloud-lb-listener[var.pscloud_certificates[count.index].listener_index].arn
}

resource "aws_lb_listener_rule" "pscloud-lb-listener-rule-redirect" {
  count                 = length(var.pscloud_listeners_redirect_rules)
  listener_arn          = aws_lb_listener.pscloud-lb-listener[var.pscloud_listeners_redirect_rules[count.index].li_index].arn //[0] listener is 80 port

  action {
    type = "redirect"

    redirect {
      port              = var.pscloud_listeners_redirect_rules[count.index].port
      protocol          = var.pscloud_listeners_redirect_rules[count.index].protocol
      status_code       = "HTTP_301"
    }
  }

  condition {
    field                = "host-header"
    values               = [ var.pscloud_listeners_redirect_rules[count.index].host_header ]
  }
}

resource "aws_lb_listener_rule" "pscloud-lb-listener-rule-forward" {
  count                 = length(var.pscloud_listeners_forward_rules)
  listener_arn          = aws_lb_listener.pscloud-lb-listener[ var.pscloud_listeners_forward_rules[count.index].li_index ].arn

  action {
    type                = "forward"
    target_group_arn = aws_lb_target_group.pscloud-lb-tg[ var.pscloud_listeners_forward_rules[count.index].tg_index ].arn
  }

  condition {
    field                = "host-header"
    values               = [ var.pscloud_listeners_forward_rules[count.index].host_header ]
  }
}


resource "aws_lb_target_group_attachment" "pscloud-lb-tg-attachment" {
  count                 = length(var.pscloud_ec2_ids)
  target_group_arn      = aws_lb_target_group.pscloud-lb-tg["silverpigeon"].arn
  target_id             = var.pscloud_ec2_ids[count.index]
  port                  = 80
}