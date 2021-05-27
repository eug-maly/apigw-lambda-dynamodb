output "lambda_name" {
  value = aws_lambda_function.apigw.function_name
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.apigw.invoke_arn
}

output "apigw_execution_arn" {
  value = aws_apigatewayv2_api.api.execution_arn
}

output "apigw_invoke_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}
