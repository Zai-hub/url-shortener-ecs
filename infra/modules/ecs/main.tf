# ECS
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}


resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${var.project_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-logs"
  }
}


resource "aws_ecs_task_definition" "app" {
  family = "${var.project_name}-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.task_cpu
  memory = var.task_memory
  task_role_arn = var.ecs_task_role_arn
  execution_role_arn = var.ecs_execution_role_arn


  container_definitions = jsonencode([
    {
      name = "${var.project_name}-container"
      image = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

    environment = [ {
      name = "TABLE_NAME"
      value = var.dynamodb_table_name
    }]
    
    logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.app.name
          "awslogs-region" = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-task-definition"
  }
}


resource "aws_ecs_service" "app" {
  name = "${var.project_name}-service"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = var.desired_count
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = var.blue_target_group_arn
    container_name   = "${var.project_name}-container"
    container_port   = var.container_port
  }

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

    lifecycle {
    ignore_changes = [
          task_definition,
          # load_balancer,
          # network_configuration
    ]
    }

  depends_on = [var.alb_listener_arn]

  tags = {
    Name = "${var.project_name}-ecs-service"
  }
}