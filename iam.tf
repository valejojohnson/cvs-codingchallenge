resource "aws_iam_role" "task_execution" {
  name               = "guessing-game-task-exec"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
}

resource "aws_iam_role_policy_attachment" "task_exec_ecr" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "guessing-game-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
}

############################
# IAM for CodePipeline
############################
resource "aws_iam_role" "pipeline" {
  name               = "${var.app_name}-cp-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "pipeline" {
  name = "${var.app_name}-cp"
  role = aws_iam_role.pipeline.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["codestar-connections:UseConnection"],
        Resource = var.codestar_connection_arn
      },
      {
        Effect   = "Allow",
        Action   = ["codebuild:BatchGetBuilds","codebuild:StartBuild"],
        Resource = aws_codebuild_project.docker.arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

