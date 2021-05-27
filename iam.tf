resource "aws_iam_role" "apigw-lambda-execution-role" {
  name = "apigw-lambda-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["apigateway.amazonaws.com","lambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "lambda-execution-role" {
  policy_arn = aws_iam_policy.apigw-lambda-execution-policy.arn
  role       = aws_iam_role.apigw-lambda-execution-role.name
}

resource "aws_iam_policy" "apigw-lambda-execution-policy" {
  name = "apigw-lambda-execution-policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ],
      "Effect": "Allow"
    },
    {
      "Action": [
        "codepipeline:GetPipelineExecution"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "dynamodb:Scan"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "execute-api:ManageConnections"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "${aws_iam_role.apigw-lambda-execution-role.arn}"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}
