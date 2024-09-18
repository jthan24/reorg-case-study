# Resource for app lambda
resource "aws_s3_bucket" "example" {
  bucket = "lambda-write-destination-bucket-338890947306"

  tags = merge(local.common_tags, {
    description = "lambda-write-destination-bucket"
  })
}


module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "private-ecr"

  repository_read_write_access_arns = ["arn:aws:iam::${local.account_id}:role/terraform"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    description = "private-ecr-for-lambda"
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "test_lambda" {

  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  package_type  = "Image"
  image_uri     = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/lambdawriter:latest"

  environment {
    variables = {
      foo = "bar"
    }
  }

  tags = merge(local.common_tags, {
    description = "lambda-app"
  })
}


resource "aws_scheduler_schedule" "lambda_schedule" {
  name = "lambda-schedule"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(1 hours)"

  target {
    arn      = aws_lambda_function.test_lambda.arn
    role_arn = aws_iam_role.iam_for_lambda.arn
  }

  description = "Schedule for a lambda"
}
