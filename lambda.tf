resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_fun"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "apigateway.amazonaws.com",
                    "lambda.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "test_policy-1"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("iam-policy.json")  
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}


resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "lambda-oauth2-jwt-authorizer.zip"
  function_name = "Lambda-authorizer-1"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda-oauth2-jwt-authorizer.zip")

  runtime = "nodejs14.x"

  environment {
    variables = {
      AUDIENCE = "api://awsjwttest"
      CLIENT_ID = "0oa4v4j64w0HACtGG5d7"
      ISSUER = "https://dev-65508932.okta.com/oauth2/aus4v4pjsktcihxwV5d7"
    }
  }
}