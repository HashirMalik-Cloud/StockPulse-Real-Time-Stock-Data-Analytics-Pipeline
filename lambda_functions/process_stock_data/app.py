import json
import boto3
from decimal import Decimal
import os

dynamodb = boto3.resource("dynamodb")
sns = boto3.client("sns")

TABLE_NAME = os.environ["DYNAMO_TABLE"]
ALERT_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)

    for record in event["Records"]:
        try:
            data = json.loads(record["body"], parse_float=Decimal)
            symbol = data["symbol"]
            price = Decimal(str(data["price"]))
            timestamp = data["timestamp"]

            # Get previous record if exists
            old_item = table.get_item(Key={"symbol": symbol}).get("Item")

            if old_item:
                old_price = Decimal(str(old_item["price"]))
                change = ((price - old_price) / old_price) * 100

                if abs(change) >= 3:
                    msg = f"{symbol} changed by {round(change, 2)}% (from {old_price} → {price})"
                    sns.publish(
                        TopicArn=ALERT_TOPIC_ARN,
                        Message=msg,
                        Subject=f"Stock Alert: {symbol}"
                    )
                    print(f"🚨 ALERT SENT: {msg}")

            # Update DynamoDB
            table.put_item(Item={
                "symbol": symbol,
                "price": price,
                "timestamp": timestamp
            })

        except Exception as e:
            print(f"Error processing record: {str(e)}")

    return {"status": "ok"}
