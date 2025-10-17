# 🛰️ Terraform + AWS ECS/Fargate CI/CD Project

Welcome to the **CVS Coding Challenge Project** — a hands-on, fully automated Terraform deployment that builds, pushes, and deploys a containerized Python app to **AWS ECS/Fargate** through a complete **CI/CD pipeline**.

This repo represents a realistic end-to-end DevOps workflow: from infrastructure provisioning to container orchestration, automated testing, and alerting — all written in clean, modular Terraform.

---

## 🚀 Quick Start (One Liner)

Clone the repo and deploy:

```bash
git clone https://github.com/valejojohnson/cvs-codingchallenge.git && terraform init && terraform apply
```

---

## 🎯 Task Recap

Here’s what this project was designed to accomplish:

1. **Deploy a containerized workload via Terraform + CI/CD**
    - ✅ ECS/Fargate cluster deployed using Terraform
    - ✅ Dockerized Python app (`guessing_game_computer.py`) built and pushed via **CodeBuild**
    - ✅ **CodePipeline** automates build and deployment to ECS

2. **Create a secure S3 bucket with Terraform**
    - ✅ Not publicly accessible
    - ✅ Encryption at rest enabled (SSE-S3)
    - ✅ Includes automated Terraform tests under `/tests/s3_bucket.tftest.hcl`

3. **Add a CloudWatch Alarm**
    - ✅ Sends email notifications when a log line is written too frequently (e.g. >10 times/min)
    - ✅ Implemented as a separate **Terraform module** called from the root configuration
    - ✅ Integrated with SNS for alerting

4. **Follow best Terraform practices**
    - ✅ Validations, formatting, and modular file organization
    - ✅ Environment-aware locals and variables
    - ✅ Outputs and IAM roles neatly scoped and reusable

---

## 🧱 Project Structure

| File / Folder | Description |
|----------------|-------------|
| `main.tf` | Root configuration orchestrating all Terraform modules |
| `vars.tf` | Input variables for AWS environment, naming, and app config |
| `locals.tf` | Centralized logic for tags, naming, and environment detection |
| `outputs.tf` | Key deployment outputs (ECS service URL, S3 bucket name, etc.) |
| `ecs.tf` | ECS cluster, task, and service definitions |
| `codepipeline.tf` | Defines CI/CD pipeline with CodeBuild & CodePipeline |
| `cloudwatch.tf` | CloudWatch metrics, alarms, and SNS notifications |
| `iam.tf` | IAM roles and permissions for ECS, CodeBuild, and Terraform |
| `s3.tf` | S3 bucket creation with encryption and restricted access |
| `buildspec.yml` | CodeBuild build instructions for Docker image creation & ECR push |
| `Dockerfile` | Builds the containerized Python guessing game app |
| `tests/s3_bucket.tftest.hcl` | Terraform test to verify S3 configuration |
| `guessing_game_computer.py` | Simple Python CLI app deployed in the container 🎮 |
| `.gitignore` / `.terraform.lock.hcl` | Version control and dependency management |
| `README.md` | You’re reading it! |

---

## ⚙️ How It All Works

1. **Terraform Provisioning**
    - Runs `terraform init`, `plan`, and `apply` to create all AWS resources:
        - ECS/Fargate Cluster
        - ECR Repository
        - S3 Bucket
        - CloudWatch Alarms
        - IAM Roles and Policies

2. **Continuous Deployment**
    - When you push code, **CodePipeline** triggers **CodeBuild**
    - CodeBuild runs `buildspec.yml` to:
        - Build and tag the Docker image
        - Push it to ECR (`latest` + commit SHA)
        - Generate `imagedefinitions.json` for ECS
    - ECS then automatically deploys the new container with zero downtime

3. **Monitoring and Alerts**
    - **CloudWatch** monitors application logs
    - If a specific log line occurs more than 10 times/minute, an **SNS alert** is sent

---