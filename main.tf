module "ecr" {
  for_each = var.ecr_parameters
  source   = "terraform-aws-modules/ecr/aws"
  version  = "3.2.0"

  attach_repository_policy                         = try(each.value.attach_repository_policy, var.ecr_defaults.attach_repository_policy, true)
  create                                           = try(each.value.create, var.ecr_defaults.create, true)
  create_lifecycle_policy                          = try(each.value.create_lifecycle_policy, var.ecr_defaults.create_lifecycle_policy, true)
  create_registry_policy                           = try(each.value.create_registry_policy, var.ecr_defaults.create_registry_policy, false)
  create_registry_replication_configuration        = try(each.value.create_registry_replication_configuration, var.ecr_defaults.create_registry_replication_configuration, false)
  create_repository                                = try(each.value.create_repository, var.ecr_defaults.create_repository, true)
  create_repository_policy                         = try(each.value.create_repository_policy, var.ecr_defaults.create_repository_policy, true)
  manage_registry_scanning_configuration           = try(each.value.manage_registry_scanning_configuration, var.ecr_defaults.manage_registry_scanning_configuration, false)
  public_repository_catalog_data                   = try(each.value.public_repository_catalog_data, var.ecr_defaults.public_repository_catalog_data, null)
  region                                           = try(each.value.region, var.ecr_defaults.region, null)
  registry_policy                                  = try(each.value.registry_policy, var.ecr_defaults.registry_policy, null)
  registry_pull_through_cache_rules                = try(each.value.registry_pull_through_cache_rules, var.ecr_defaults.registry_pull_through_cache_rules, {})
  registry_replication_rules                       = try(each.value.registry_replication_rules, var.ecr_defaults.registry_replication_rules, null)
  registry_scan_rules                              = try(each.value.registry_scan_rules, var.ecr_defaults.registry_scan_rules, null)
  registry_scan_type                               = try(each.value.registry_scan_type, var.ecr_defaults.registry_scan_type, "ENHANCED")
  repository_encryption_type                       = try(each.value.repository_encryption_type, var.ecr_defaults.repository_encryption_type, null)
  repository_force_delete                          = try(each.value.repository_force_delete, var.ecr_defaults.repository_force_delete, null)
  repository_image_scan_on_push                    = try(each.value.repository_image_scan_on_push, var.ecr_defaults.repository_image_scan_on_push, true)
  repository_image_tag_mutability                  = try(each.value.repository_image_tag_mutability, var.ecr_defaults.repository_image_tag_mutability, "IMMUTABLE")
  repository_image_tag_mutability_exclusion_filter = try(each.value.repository_image_tag_mutability_exclusion_filter, var.ecr_defaults.repository_image_tag_mutability_exclusion_filter, null)
  repository_kms_key                               = try(each.value.repository_kms_key, var.ecr_defaults.repository_kms_key, null)
  repository_lambda_read_access_arns               = try(each.value.repository_lambda_read_access_arns, var.ecr_defaults.repository_lambda_read_access_arns, [])
  repository_lifecycle_policy                      = try(each.value.repository_lifecycle_policy, var.ecr_defaults.repository_lifecycle_policy, "")
  repository_name                                  = try(each.value.repository_name, "${local.common_name}-${each.key}")
  repository_policy                                = try(each.value.repository_policy, var.ecr_defaults.repository_policy, null)
  repository_policy_statements                     = try(each.value.repository_policy_statements, var.ecr_defaults.repository_policy_statements, null)
  repository_read_access_arns                      = try(each.value.repository_read_access_arns, var.ecr_defaults.repository_read_access_arns, [])
  repository_read_write_access_arns                = try(each.value.repository_read_write_access_arns, var.ecr_defaults.repository_read_write_access_arns, [])
  repository_type                                  = try(each.value.repository_type, var.ecr_defaults.repository_type, "private")

  tags = merge(local.common_tags, try(each.value.tags, var.ecr_defaults.tags, null))
}