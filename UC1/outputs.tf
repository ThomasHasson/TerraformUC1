output "this_elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = module.elb_http.this_elb_dns_name
}
