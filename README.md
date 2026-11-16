# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform ECR Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-ecr/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-ecr.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-ecr.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-ecr/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform wrapper for AWS's ECR (Elastic Container Registry) service simplifies the configuration of container image repositories in the cloud. This wrapper acts as a predefined template, making it easier to create and manage ECR repositories by handling all the technical details.

### ✨ Features

- 🔍 [Image Scanning on Push](#image-scanning-on-push) - Automatically scan container images for vulnerabilities when pushed to the repository

- 🏷️ [Tag Mutability with Exclusions](#tag-mutability-with-exclusions) - Configure immutable tags with exceptions for specific tag patterns

- 📋 [Lifecycle Policies](#lifecycle-policies) - Automatically manage image lifecycle to reduce storage costs

- 🔐 [KMS Encryption](#kms-encryption) - Encrypt container images using AWS KMS for enhanced security

- 🔄 [Registry Replication](#registry-replication) - Configure cross-region replication for container images

- 🛡️ [Registry Scanning Configuration](#registry-scanning-configuration) - Configure enhanced scanning rules at the registry level



### 🔗 External Modules
| Name | Version |
|------|------:|
| <a href="https://github.com/terraform-aws-modules/terraform-aws-ecr" target="_blank">terraform-aws-modules/ecr/aws</a> | 3.2.1 |



## 🚀 Quick Start
```hcl
ecr_parameters = {
  "example" = {
    repository_image_scan_on_push   = true
    repository_image_tag_mutability = "IMMUTABLE"
    repository_type                 = "private"
  }
}
```


## 🔧 Additional Features Usage

### Image Scanning on Push
Enable automatic vulnerability scanning for container images when they are pushed to the ECR repository. This helps identify security issues early in the development lifecycle and ensures only secure images are deployed.


<details><summary>Configuration Code</summary>

```hcl
ecr_parameters = {
  "example" = {
    repository_image_scan_on_push = true
    repository_type               = "private"
  }
}
```


</details>


### Tag Mutability with Exclusions
Use IMMUTABLE_WITH_EXCLUSION to enforce immutable tags while allowing specific tag patterns (like dev-*, qa-*, latest*) to be overwritten. This provides security for production tags while maintaining flexibility for development workflows.


<details><summary>Configuration Code</summary>

```hcl
ecr_parameters = {
  "example" = {
    repository_image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
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
  }
}
```


</details>


### Lifecycle Policies
Configure lifecycle policies to automatically expire old or untagged images based on count, age, or tag patterns. This helps reduce storage costs by keeping only the images you need.


<details><summary>Configuration Code</summary>

```hcl
ecr_parameters = {
  "example" = {
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
}
```


</details>


### KMS Encryption
Use AWS KMS to encrypt container images at rest. This provides additional security controls and allows you to manage encryption keys centrally, with support for key rotation and access policies.


<details><summary>Configuration Code</summary>

```hcl
ecr_parameters = {
  "example" = {
    repository_encryption_type = "KMS"
    repository_kms_key         = "arn:aws:kms:region:account:key/key-id"
    repository_type            = "private"
  }
}
```


</details>


### Registry Replication
Set up automatic replication of container images across multiple AWS regions. This improves availability, reduces latency for multi-region deployments, and provides disaster recovery capabilities.


<details><summary>Configuration Code</summary>

```hcl
ecr_parameters = {
  "example" = {
    create_registry_replication_configuration = true
    registry_replication_rules = [{
      destinations = [
        {
          region      = "us-west-2"
          registry_id = "{account_id}"
        },
        {
          region      = "eu-west-1"
          registry_id = "{account_id}"
        }
      ]
      repository_filters = [{
        filter      = "prod-microservice"
        filter_type = "PREFIX_MATCH"
      }]
    }]
  }
}
```


</details>


### Registry Scanning Configuration
Set up registry-level scanning configuration with custom scan rules based on tag patterns. This allows you to define different scanning frequencies (SCAN_ON_PUSH, CONTINUOUS_SCAN) for different image tags.


<details><summary>Configuration Code</summary>

```hcl
ecr_parameters = {
  "example" = {
    manage_registry_scanning_configuration = true
    registry_scan_type                     = "ENHANCED"
    registry_scan_rules = [
      {
        scan_frequency = "SCAN_ON_PUSH"
        filter = [
          {
            filter      = "prod-*"
            filter_type = "WILDCARD"
          },
          {
            filter      = "release-*"
            filter_type = "WILDCARD"
          }
        ]
      },
      {
        scan_frequency = "CONTINUOUS_SCAN"
        filter = [
          {
            filter      = "latest"
            filter_type = "WILDCARD"
          }
        ]
      }
    ]
  }
}
```


</details>




## 📑 Inputs
| Name                                             | Description                                                                                          | Type     | Default                              | Required |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------------- | -------- | ------------------------------------ | -------- |
| attach_repository_policy                         | Controls whether to attach a repository policy to the ECR repository                                 | `bool`   | `true`                               | no       |
| create                                           | Controls whether to create the ECR repository and associated resources                               | `bool`   | `true`                               | no       |
| create_lifecycle_policy                          | Controls whether to create a lifecycle policy for the repository                                     | `bool`   | `true`                               | no       |
| create_registry_policy                           | Controls whether to create a registry policy                                                         | `bool`   | `false`                              | no       |
| create_registry_replication_configuration        | Controls whether to create registry replication configuration                                        | `bool`   | `false`                              | no       |
| create_repository                                | Controls whether to create the ECR repository                                                        | `bool`   | `true`                               | no       |
| create_repository_policy                         | Controls whether to create a repository policy                                                       | `bool`   | `true`                               | no       |
| manage_registry_scanning_configuration           | Controls whether to manage registry scanning configuration                                           | `bool`   | `false`                              | no       |
| public_repository_catalog_data                   | Public repository catalog data configuration                                                         | `any`    | `null`                               | no       |
| region                                           | Region where this resource will be managed. Defaults to the Region set in the provider configuration | `string` | `null`                               | no       |
| registry_policy                                  | Registry policy document                                                                             | `string` | `null`                               | no       |
| registry_pull_through_cache_rules                | Registry pull through cache rules                                                                    | `map`    | `{}`                                 | no       |
| registry_replication_rules                       | Registry replication rules                                                                           | `any`    | `null`                               | no       |
| registry_scan_rules                              | Registry scan rules                                                                                  | `any`    | `null`                               | no       |
| registry_scan_type                               | Registry scan type (BASIC or ENHANCED)                                                               | `string` | `"ENHANCED"`                         | no       |
| repository_encryption_type                       | Encryption type for the repository (AES256 or KMS)                                                   | `string` | `null`                               | no       |
| repository_force_delete                          | Force delete the repository even if it contains images                                               | `bool`   | `null`                               | no       |
| repository_image_scan_on_push                    | Enable image scanning on push                                                                        | `bool`   | `true`                               | no       |
| repository_image_tag_mutability                  | Tag mutability (MUTABLE or IMMUTABLE)                                                                | `string` | `"IMMUTABLE"`                        | no       |
| repository_image_tag_mutability_exclusion_filter | Tag mutability exclusion filter                                                                      | `list`   | `null`                               | no       |
| repository_kms_key                               | KMS key ARN for encryption                                                                           | `string` | `null`                               | no       |
| repository_lambda_read_access_arns               | Lambda function ARNs with read access                                                                | `list`   | `[]`                                 | no       |
| repository_lifecycle_policy                      | Lifecycle policy document                                                                            | `string` | `""`                                 | no       |
| repository_name                                  | Name of the ECR repository                                                                           | `string` | `"${local.common_name}-${each.key}"` | no       |
| repository_policy                                | Repository policy document                                                                           | `string` | `null`                               | no       |
| repository_policy_statements                     | Repository policy statements                                                                         | `any`    | `null`                               | no       |
| repository_read_access_arns                      | ARNs with read access to the repository                                                              | `list`   | `[]`                                 | no       |
| repository_read_write_access_arns                | ARNs with read/write access to the repository                                                        | `list`   | `[]`                                 | no       |
| repository_type                                  | Repository type (private or public)                                                                  | `string` | `"private"`                          | no       |
| tags                                             | A map of tags to assign to resources                                                                 | `map`    | `{}`                                 | no       |







## ⚠️ Important Notes
- **⚠️ Tag Mutability:** Once set to IMMUTABLE, tags cannot be overwritten. Use MUTABLE for development environments where you need to reuse tags.
- **⚠️ Image Scanning:** Enable image scanning on push to automatically scan images for vulnerabilities.
- **⚠️ Repository Policies:** Configure repository policies to control access to your container images.
- **⚠️ Lifecycle Policies:** Use lifecycle policies to automatically clean up old images and reduce storage costs.



---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 