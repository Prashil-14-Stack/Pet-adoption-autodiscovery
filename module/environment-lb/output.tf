output "stage_dns" {
    value = aws_lb.stage_lb.dns_name
}
output "stage_zone_id" {
    value = aws_lb.stage_lb.zone_id
}

output "stage_arn" {
    value = aws_lb.stage_lb.arn
}

output "stage_tg_arn" {
    value = aws_lb_target_group.stage-target-group.arn
}

output "prod_dns" {
    value = aws_lb.prod_lb.dns_name
}
output "prod_zone_id" {
    value = aws_lb.prod_lb.zone_id
}    

output "prod_arn" {
    value = aws_lb.prod_lb.arn
} 

output "prod_tg_arn" {
   value = aws_lb_target_group.prod-target-group.arn
}