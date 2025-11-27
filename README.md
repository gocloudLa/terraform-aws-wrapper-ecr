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
| <a href="https://github.com/terraform-aws-modules/terraform-aws-ecr" target="_blank">terraform-aws-modules/ecr/aws</a> | 3.1.0 |


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

## 📖 Documentation

For detailed module documentation, see the [README.yml](README.yml) file.

## 📝 Examples

See the [examples](./examples) directory for complete working examples.

## ⚠️ Important Notes

- **⚠️ Tag Mutability:** Once set to IMMUTABLE, tags cannot be overwritten. Use MUTABLE for development environments where you need to reuse tags.
- **⚠️ Image Scanning:** Enable image scanning on push to automatically scan images for vulnerabilities.
- **⚠️ Repository Policies:** Configure repository policies to control access to your container images.
- **⚠️ Lifecycle Policies:** Use lifecycle policies to automatically clean up old images and reduce storage costs.

## 📄 License

This module is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
