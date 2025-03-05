# AWS Step Function Orchestration with Lambda

## Overview
This project orchestrates AWS Lambda functions using Step Functions triggered via API Gateway.

## Deployment Steps
1. **Clone the Repository**:
   - Run `git clone <repository-url>` to clone the project.
2. **Install Dependencies**:
   - Run `pip install -r requirements.txt` to install Python dependencies.
3. **Build Lambda Packages**:
   - Run `./build.sh` to create the Lambda deployment packages.
4. **Deploy Infrastructure**:
   - Run `terraform init` and `terraform apply` to deploy the infrastructure.
5. **Test API Gateway**:
   - Use `curl` or Postman to test the API Gateway endpoint.
6. **Check Logs**:
   - Use AWS CloudWatch to monitor logs for debugging.

## Future Enhancements
- Integrate LLM APIs into the agent Lambda functions.
