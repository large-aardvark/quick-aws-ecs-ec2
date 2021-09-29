output "lb_dns_addr" {
    value = aws_lb.lb.dns_name
}