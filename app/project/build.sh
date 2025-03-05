#!/bin/bash
# Package Lambda functions for deployment
zip -r endpoint_lambda.zip endpoint_lambda.py
zip -r agent1_lambda.zip agent1_lambda.py
zip -r agent2_lambda.zip agent2_lambda.py

echo "Lambda functions packaged successfully!"