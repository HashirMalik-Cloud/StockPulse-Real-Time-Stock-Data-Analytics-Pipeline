def lambda_handler(event, context):
    for record in event['Records']:
        message = record['Sns']['Message']
        print("📢 ALERT:", message)
