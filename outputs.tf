
output "attributes" {
  description = "Attribute string lowercase"
  value       = "${local.attr}"
}
output "environment" {
  description = "Environment name lowercase"
  value       = "${local.env}"
}
output "id" {
  description = "Fully formatted name ID"
  value       = "${local.id}"
}
output "id_20" {
  description = "ID truncated to 20 characters"
  value       = "${local.id_20}"
}
output "id_32" {
  description = "ID truncated to 32 characters"
  value       = "${local.id_32}"
}
output "id_env" {
  description = "If env namespace enabled <env>-<name> else <name>"
  value       = "${local.id_env}"
}
output "id_org" {
  description = "If org namespace enabled <org>-<id_env> else <id_env>"
  value       = "${local.id_org}"
}
output "name" {
  description = "Name lowercase"
  value       = "${local.name_low}"
}
output "organization" {
  description = "Organization name lowercase"
  value       = "${local.org}"
}
output "tags" {
  description = "Tags map merged with standard tags"
  value       = "${local.tags}"
}
