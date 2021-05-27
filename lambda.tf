data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.cwd}/scripts/lambda.py"
  output_path = "${path.cwd}/scripts/lambda.zip"
}


resource "aws_lambda_function" "apigw" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.prefix}-lambda"
  role             = aws_iam_role.apigw-lambda-execution-role.arn
  handler          = var.lambda_handler
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.7"
}

resource "aws_lambda_permission" "apigw_to_invoke_connect" {
  statement_id  = "AllowExecutionFromApigatewayConnect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apigw.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/$connect"
}

resource "aws_lambda_permission" "apigw_to_invoke_default" {
  statement_id  = "AllowExecutionFromApigatewayDefault"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apigw.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/$default"
}

resource "aws_cloudwatch_log_group" "health_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.apigw.function_name}"

  retention_in_days = 30
}
