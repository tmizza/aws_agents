import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    step_function_arn = "arn:aws:states:us-east-1:123456789012:stateMachine:MyStateMachine" # Replace with your ARN
    client = boto3.client('stepfunctions')

    try:
        response = client.start_execution(
            stateMachineArn=step_function_arn,
            input=json.dumps({"input": "hello"})  # Pass input to Step Function
        )
        return {
            'statusCode': 200,
            'body': json.dumps({
                'executionArn': response['executionArn'],
                'message': 'Step Function triggered successfully'
            })
        }
    except Exception as e:
        logger.error(f"Error triggering Step Function: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to trigger Step Function'})
        }
