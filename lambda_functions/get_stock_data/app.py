import json
import boto3
import os
from decimal import Decimal

# Initialize DynamoDB
dynamodb = boto3.resource("dynamodb")
TABLE_NAME = os.environ.get("DYNAMO_TABLE", "StockPrices")  # default fallback

def lambda_handler(event, context):
    # Handle CORS preflight request
    if event.get("httpMethod") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET,OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": ""
        }

    try:
        table = dynamodb.Table(TABLE_NAME)

        # Fetch latest 20 items
        response = table.scan(Limit=20)
        items = response.get("Items", [])

        # Convert all Decimal types to float
        for item in items:
            for key, value in item.items():
                if isinstance(value, Decimal):
                    item[key] = float(value)

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET,OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": json.dumps(items)
        }

    except Exception as e:
        # Print for CloudWatch
        print(f"[Error] {str(e)}")
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET,OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": json.dumps({"error": str(e)})
        }
