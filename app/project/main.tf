# main.tf
provider "aws" {
  region = "us-east-1" # Change as needed
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_step_function_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

resource "aws_iam_role" "step_function_role" {
  name = "step_function_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_function_policy" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

# main.tf
resource "aws_lambda_function" "endpoint_lambda" {
  filename      = "endpoint_lambda.zip"
  function_name = "endpoint_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "endpoint_lambda.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = filebase64sha256("endpoint_lambda.zip")
}

resource "aws_lambda_function" "agent1_lambda" {
  filename      = "agent1_lambda.zip"
  function_name = "agent1_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "agent1_lambda.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = filebase64sha256("agent1_lambda.zip")
}

resource "aws_lambda_function" "agent2_lambda" {
  filename      = "agent2_lambda.zip"
  function_name = "agent2_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "agent2_lambda.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = filebase64sha256("agent2_lambda.zip")
}

resource "aws_api_gateway_rest_api" "api" {
  name = "example_api"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "trigger"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.endpoint_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.endpoint_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gat…