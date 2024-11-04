output "lb_endpoint" {
  description = "Wordpress Endpoint"
  value       = aws_lb.wordpress_alb.dns_name
}

