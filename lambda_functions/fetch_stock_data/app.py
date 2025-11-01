import json
import boto3
import requests
import os
from datetime import datetime
from decimal import Decimal

sqs = boto3.client("sqs")

# Define which stocks to track
STOCKS = ["AAPL", "TSLA", "AMZN", "MSFT"]

# Load your Alpha Vantage API key from environment variables
API_KEY = os.environ.get("ALPHA_VANTAGE_KEY")

def lambda_handler(event, context):
    queue_url = os.environ["SQS_QUEUE_URL"]
    records = []

    if not API_KEY:
        print("❌ Missing ALPHA_VANTAGE_KEY environment variable.")
        return {"statusCode": 500, "body": "Missing Alpha Vantage API key."}

    for symbol in STOCKS:
        try:
            # Alpha Vantage GLOBAL_QUOTE endpoint
            url = (
                f"https://www.alphavantage.co/query"
                f"?function=GLOBAL_QUOTE&symbol={symbol}&apikey={API_KEY}"
            )
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            data = response.json()

            quote = data.get("Global Quote", {})
            if not quote or "05. price" not in quote:
                print(f"No valid data for {symbol}: {data}")
                continue

            price = float(quote["05. price"])
            record = {
                "symbol": symbol,
                "price": price,
                "timestamp": datetime.utcnow().isoformat(),
            }

            # Send each record to SQS
            sqs.send_message(
                QueueUrl=queue_url,
                MessageBody=json.dumps(record)
            )
            records.append(record)
            print(f"✅ Sent {symbol}: ${price}")

        except requests.exceptions.RequestException as e:
            print(f"⚠️ HTTP error for {symbol}: {str(e)}")
        except Exception as e:
            print(f"❌ Unexpected error for {symbol}: {str(e)}")

    print(f"✅ Completed fetch for {len(records)} symbols.")
    return {
        "statusCode": 200,
        "body": json.dumps({"fetched": len(records), "records": records}, default=str)
    }
