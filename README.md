## Description

This module creates the following resources:
- DynamoDB table with 8 items
- Lambda function which reads DynamoDB table item randomly and responds with it
- ApiGateway with a WebSocket type (routes, stage,etc.)

Output:
```
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.
Releasing state lock. This may take a few moments...

Outputs:

apigw_execution_arn = arn:aws:execute-api:eu-west-2:482720962971:bx6tb2ib1m
apigw_invoke_url = wss://bx6tb2ib1m.execute-api.eu-west-2.amazonaws.com/production
lambda_invoke_arn = arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:482720962971:function:apigw-lambda/invocations
lambda_name = apigw-lambda
```

Result:
```
$ wscat -c wss://bx6tb2ib1m.execute-api.eu-west-2.amazonaws.com/production
Connected (press CTRL+C to quit)
> hello
< Oprimus
> readlly?
< Ratchet
> really?
< Ratchet
> nice
< Bumblebee
>
``
