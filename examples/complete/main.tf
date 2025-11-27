module "wrapper_ecr" {
  source = "../../"

  metadata = local.metadata

  ecr_parameters = {
    # Basic example with image scanning and lifecycle policy
    "example" = {
      # Enable image scanning on push to automatically detect vulnerabilities
      repository_image_scan_on_push = true

      # Tag mutability: MUTABLE allows overwriting tags (useful for dev environments)
      repository_image_tag_mutability = "MUTABLE"
      repository_type                 = "private"

      # Lifecycle policy to keep only the last 30 images and reduce storage costs
      create_lifecycle_policy = true
      repository_lifecycle_policy = jsonencode({
        rules = [
          {
            rulePriority = 1
            description  = "Keep last 30 images"
            selection = {
              tagStatus   = "any"
              countType   = "imageCountMoreThan"
              countNumber = 30
            }
            action = {
              type = "expire"
            }
          }
        ]
      })
    }

    # Production example with immutable tags and encryption
    "example-production" = {
      # Enable image scanning for security
      repository_image_scan_on_push = true

      # IMMUTABLE tags prevent overwriting (best practice for production)
      repository_image_tag_mutability = "IMMUTABLE"
      repository_type                 = "private"

      # Use AES256 encryption (or KMS for more control)
      repository_encryption_type = "AES256"

      # Lifecycle policy: Keep last 50 images and expire untagged images older than 7 days
      create_lifecycle_policy = true
      repository_lifecycle_policy = jsonencode({
        rules = [
          {
            rulePriority = 1
            description  = "Keep last 50 production images"
            selection = {
              tagStatus     = "tagged"
              tagPrefixList = ["v", "prod-"]
              countType     = "imageCountMoreThan"
              countNumber   = 50
            }
            action = {
              type = "expire"
            }
          },
          {
            rulePriority = 2
            description  = "Expire untagged images older than 7 days"
            selection = {
              tagStatus   = "untagged"
              countType   = "sinceImagePushed"
              countUnit   = "days"
              countNumber = 7
            }
            action = {
              type = "expire"
            }
          }
        ]
      })
    }

    # Advanced example with immutable tags with exclusions
    "example-advanced" = {
      repository_image_scan_on_push = true

      # IMMUTABLE_WITH_EXCLUSION allows immutable tags except for specific patterns
      repository_image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

      # Define which tags can be overwritten (useful for dev/qa environments)
      repository_image_tag_mutability_exclusion_filter = [
        {
          filter      = "latest*"
          filter_type = "WILDCARD"
        },
        {
          filter      = "dev-*"
          filter_type = "WILDCARD"
        },
        {
          filter      = "qa-*"
          filter_type = "WILDCARD"
        }
      ]

      repository_type = "private"

      # Advanced lifecycle policy with multiple rules
      create_lifecycle_policy = true
      repository_lifecycle_policy = jsonencode({
        rules = [
          {
            rulePriority = 1
            description  = "Keep last 30 tagged images with version prefix"
            selection = {
              tagStatus     = "tagged"
              tagPrefixList = ["v"]
              countType     = "imageCountMoreThan"
              countNumber   = 30
            }
            action = {
              type = "expire"
            }
          },
          {
            rulePriority = 2
            description  = "Expire untagged images older than 14 days"
            selection = {
              tagStatus   = "untagged"
              countType   = "sinceImagePushed"
              countUnit   = "days"
              countNumber = 14
            }
            action = {
              type = "expire"
            }
          }
        ]
      })

      # Grant read access to specific ARNs
      repository_read_access_arns = [
        data.aws_caller_identity.current.arn
      ]
    }

    # Example with KMS encryption
    "example-kms-encrypted" = {
      repository_image_scan_on_push   = true
      repository_image_tag_mutability = "IMMUTABLE"
      repository_type                 = "private"
      repository_encryption_type      = "KMS"
      # repository_kms_key = "arn:aws:kms:region:account:key/key-id" # Uncomment and specify your KMS key ARN

      create_lifecycle_policy = true
      repository_lifecycle_policy = jsonencode({
        rules = [
          {
            rulePriority = 1
            description  = "Keep last 20 images"
            selection = {
              tagStatus   = "any"
              countType   = "imageCountMoreThan"
              countNumber = 20
            }
            action = {
              type = "expire"
            }
          }
        ]
      })
    }
  }

  ecr_defaults = var.ecr_defaults
}
