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

## Repository Structure

### Architecture Screenshot
> 📸 _Insert architecture image here_

---

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       ├── build.yaml      
│       └── deploy.yaml
├── app/ 
    ├──
    ├──                   
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
├── infra/
│   └── global/
          └── backend
               ├──

│   ├── modules/            
│   │   ├── vpc/
│   │   ├── ecs/
│   │   ├── alb/
│   │   ├── dynamodb/
│   │   ├── iam/
│   │   └── codedeploy/
│   └── envs/
│       └── dev/             
├── README.md
└── .gitignore
