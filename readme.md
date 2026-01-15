# URL Shortener on AWS (ECS Fargate)

![CICD](https://img.shields.io/badge/CICD-GitHub_Actions-blue)
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED)
![AWS ECS](https://img.shields.io/badge/AWS-ECS_Fargate-orange)
![CodeDeploy](https://img.shields.io/badge/Deploy-CodeDeploy-green)

---
## Description

This service accepts a long URL, generates a short code and redirects requests for the short URL back to the original destination.

The application runs as a containerised Python service on **ECS Fargate**, behind an **Application Load Balancer (ALB)** protected by **AWS WAF**.  

URL mappings are stored in **DynamoDB**, and deployments are handled via **AWS CodeDeploy** using **blue/green canary releases**.

All infrastructure is managed using **Terraform** and CI/CD is implemented with **GitHub Actions** using **OIDC** (no long-lived AWS credentials).

---

## Architecture
![Architecture Image](./images/url-shortener-ecs.png)

---
## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       ├── build.yaml
│       └── deploy.yaml
│
├── app/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── requirements.txt
│
├── images/
│
└── infra/
    ├── envs/
    │   └── dev/
    │
    ├── global/
    │   └── backend/
    │
    └── modules/
│    
├── modules/                 
├── README.md
└── .gitignore
```

## ✨ Features

- Containerised URL shortener application using Docker.
- Deployed on AWS ECS Fargate (serverless containers).
- Blue/Green deployments with AWS CodeDeploy.
- Application Load Balancer with health checks.
- Zero-downtime deployments.
- Infrastructure as Code using Terraform.
- Secure CI/CD using GitHub Actions with AWS OIDC (no static credentials).
- Environment isolation using Terraform modules.
- Automated image build and push to Amazon ECR.
- Automated ECS task definition revisions.
- Canary deployment strategy using CodeDeploy.
- VPC networking with private resources and VPC endpoints.

---

## 🔄 How the Project Works

This project follows a full CI/CD and Blue/Green deployment workflow:

1. Application code is containerized using Docker.
2. Images are built and pushed to Amazon ECR via GitHub Actions.
3. Terraform provisions and manages all AWS infrastructure.
4. ECS task definitions are updated dynamically with new image versions.
5. AWS CodeDeploy performs Blue/Green deployments.
6. Traffic is shifted only after health checks pass.

---

## Application Verification

### Health Check
```bash
curl https://ecs.zaitech.uk/healthz
```
