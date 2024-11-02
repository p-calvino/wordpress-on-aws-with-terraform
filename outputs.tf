output "lb_endpoint" {
  value = aws_lb.wordpress_alb.dns_name
}
