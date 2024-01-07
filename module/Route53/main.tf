data "aws_route53_zone" "zone" {
  name         =var.domain1
  private_zone = false
}

resource "aws_route53_record" "st" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain2
  type    = "A"
  alias{
    name= var.stage_dns_name
    zone_id = var.stage_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "pr" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain3
  type    = "A"
  alias{
    name = var.prod_dns_name2
    zone_id = var.prod_zone_id2
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "team-cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = [var.domain_name4]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "team-validation-record" {
    for_each = {
        for dvo in aws_acm_certificate.team-cert.domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            record = dvo.resource_record_value
            type   = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    name    = each.value.name
    records = [each.value.record]
    ttl     = 60
    type    = each.value.type
    zone_id = data.aws_route53_zone.zone.zone_id
 
}

resource "aws_acm_certificate_validation" "team-cert-validation" {
    certificate_arn = aws_acm_certificate.team-cert.arn
    validation_record_fqdns = [for record in aws_route53_record.team-validation-record : record.fqdn]
}