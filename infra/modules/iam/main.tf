# ECS Task Assume Role Policy
data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS Task Role
resource "aws_iam_role" "ecs_task" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json

  tags = {
    Name = "${var.project_name}-ecs-task-role"
  }
}

# DynamoDB Policy for Task Role
data "aws_iam_policy_document" "dynamodb_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]
    resources = [var.dynamodb_table_arn]
  }
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.project_name}-dynamodb-access"
  description = "DynamoDB access for ECS task"
  policy      = data.aws_iam_policy_document.dynamodb_access.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_dynamodb" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

# ECS Execution Role
resource "aws_iam_role" "ecs_execution" {
  name               = "${var.project_name}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json

  tags = {
    Name = "${var.project_name}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CodeDeploy Assume Role Policy
data "aws_iam_policy_document" "codedeploy_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

# CodeDeploy Role
resource "aws_iam_role" "codedeploy" {
  name               = "${var.project_name}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume.json

  tags = {
    Name = "${var.project_name}-codedeploy-role"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# GitHub OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Name = "${var.project_name}-github-oidc"
  }
}

# GitHub Assume Role Policy
data "aws_iam_policy_document" "github_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:*"]
    }
  }
}

# GitHub Actions Role
resource "aws_iam_role" "github" {
  name               = "${var.project_name}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_assume.json

  tags = {
    Name = "${var.project_name}-github-actions-role"
  }
}

# GitHub ECR Policy
data "aws_iam_policy_document" "github_ecr" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_ecr" {
  name        = "${var.project_name}-github-ecr"
  description = "ECR permissions for GitHub Actions"
  policy      = data.aws_iam_policy_document.github_ecr.json
}

resource "aws_iam_role_policy_attachment" "github_ecr" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.github_ecr.arn
}

# # GitHub ECS Policy
data "aws_iam_policy_document" "github_ecs" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_ecs" {
  name        = "${var.project_name}-github-ecs"
  description = "ECS permissions for GitHub Actions"
  policy      = data.aws_iam_policy_document.github_ecs.json
}

resource "aws_iam_role_policy_attachment" "github_ecs" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.github_ecs.arn
}

# # GitHub CodeDeploy Policy
data "aws_iam_policy_document" "github_codedeploy" {
  statement {
    effect = "Allow"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:GetApplicationRevision",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_codedeploy" {
  name        = "${var.project_name}-github-codedeploy"
  description = "CodeDeploy permissions for GitHub Actions"
  policy      = data.aws_iam_policy_document.github_codedeploy.json
}

resource "aws_iam_role_policy_attachment" "github_codedeploy" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.github_codedeploy.arn
}

# GitHub Terraform State Policy
data "aws_iam_policy_document" "github_state" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${var.state_bucket}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${var.state_bucket}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:${var.region}:*:table/${var.lock_table}"]
  }
}

resource "aws_iam_policy" "github_state" {
  name        = "${var.project_name}-github-terraform-state"
  description = "Terraform state access for GitHub Actions"
  policy      = data.aws_iam_policy_document.github_state.json
}

resource "aws_iam_role_policy_attachment" "github_state" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.github_state.arn
}

# # GitHub IAM PassRole Policy
data "aws_iam_policy_document" "github_passrole" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.ecs_task.arn,
      aws_iam_role.ecs_execution.arn
    ]
  }
}

resource "aws_iam_policy" "github_passrole" {
  name        = "${var.project_name}-github-passrole"
  description = "IAM PassRole for GitHub Actions"
  policy      = data.aws_iam_policy_document.github_passrole.json
}

resource "aws_iam_role_policy_attachment" "github_passrole" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.github_passrole.arn
}