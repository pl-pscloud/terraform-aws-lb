resource "aws_lb" "pscloud-lb" {
  name                  = "${var.pscloud_company}-elb-${var.pscloud_env}"
  internal              = false
  load_balancer_type    = var.pscloud_lb_type
  subnets               = var.pscloud_subnets_ids
  security_groups       = [ var.pscloud_sec_gr ]

  enable_deletion_protection = var.enable_deletion_protection

  idle_timeout          = var.pscloud_idle_timeout

  tags = {
    Name                = "${var.pscloud_company}_elb_${var.pscloud_env}"
  }
}

resource "aws_lb_target_group" "pscloud-lb-tg" {
  for_each              = var.pscloud_target_groups

  name                  = each.value.name
  port                  = each.value.port
  protocol              = each.value.protocol
  vpc_id                = var.pscloud_vpc_id

  tags = {
    Name                = "${var.pscloud_company}_lb_tg_${each.value.name}_${var.pscloud_env}"
  }
}

resource "aws_lb_listener" "pscloud-lb-listener" {
  for_each              = var.pscloud_listeners

  load_balancer_arn = aws_lb.pscloud-lb.arn
  port                  = each.value.port
  protocol              = each.value.protocol
  certificate_arn       = each.value.cert_arn

  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.pscloud-lb-tg[each.value.tg_index].arn
  }
}

resource "aws_lb_listener_certificate" "pscloud-lb-certs" {
  for_each              = var.pscloud_certificates

  certificate_arn       = each.value.cert_arn
  listener_arn          = aws_lb_listener.pscloud-lb-listener[each.value.listener_index].arn
}

resource "aws_lb_listener_rule" "pscloud-lb-listener-rule-redirect" {
  for_each              = var.pscloud_listeners_redirect_rules

  listener_arn          = aws_lb_listener.pscloud-lb-listener[each.value.li_index].arn //[0] listener is 80 port

  action {
    type = "redirect"

    redirect {
      port              = each.value.port
      protocol          = each.value.protocol
      status_code       = "HTTP_301"
    }
  }

  condition {
    host_header {
      values               = [ each.value.host_header ]
    }
  }
}

resource "aws_lb_listener_rule" "pscloud-lb-listener-rule-forward" {
  for_each              = var.pscloud_listeners_forward_rules

  listener_arn          = aws_lb_listener.pscloud-lb-listener[each.value.li_index].arn

  action {
    type                = "forward"
    target_group_arn = aws_lb_target_group.pscloud-lb-tg[each.value.tg_index].arn
  }

  condition {
    host_header {
      values               = [ each.value.host_header ]
    }
  }
}


