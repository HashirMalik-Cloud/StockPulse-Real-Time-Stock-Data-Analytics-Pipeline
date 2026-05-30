### 📊 Architecture Diagram  
![Architecture Diagram](Architecture%20Diagram.png)

# 📊 StockPulse — Real-Time Serverless Stock Analytics & Alerting Pipeline

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%23623CE4.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)


A serverless AWS pipeline for processing real-time stock price data and generating threshold-based alerts.


## Overview

StockPulse is a serverless AWS pipeline that processes real-time stock price data using Lambda, SQS, and DynamoDB. It detects price changes and triggers alerts via SNS.

The system is fully serverless and provisioned using Terraform.


## Architecture

Event-driven flow:

EventBridge (1-minute schedule)  
→ Lambda (fetch stock data)  
→ SQS (buffering layer)  
→ Lambda (processing and evaluation)  
→ DynamoDB (latest state storage)  
→ S3 (historical data storage)  
→ SNS (alert notifications)

API Gateway is used to expose data to the frontend dashboard.


## Tech Stack

**Cloud & Infrastructure**
- AWS Lambda
- Amazon EventBridge
- Amazon SQS
- Amazon SNS
- Amazon DynamoDB
- Amazon S3
- Amazon API Gateway
- Amazon CloudWatch

**Infrastructure as Code**
-	Terraform

**Frontend**
- HTML
- CSS
- JavaScript


## Features

- Real-time stock data ingestion
- Event-driven processing pipeline
- Decoupled microservice-style architecture
- Threshold-based alerting system (e.g. ±3% change)
- Persistent storage for latest and historical data
- API layer for frontend integration
- Fully serverless deployment


## Data Flow

1. EventBridge triggers a Lambda function every minute.
2. Lambda fetches stock data from an external API.
3. Data is pushed to SQS for decoupled processing.
4. A second Lambda consumes messages in batches and processes them.
5. Processed data is stored in DynamoDB and S3.
6. If a price threshold is breached, SNS sends an alert.
7. API Gateway exposes processed data to the frontend dashboard.


## Key Design Decisions

### 1. Use of SQS for buffering

SQS is used between ingestion and processing to decouple services and handle traffic spikes safely. This prevents direct overload on downstream services during high-frequency updates.


### 2. Separation of storage layers

- DynamoDB is used for fast access to the latest state.
- S3 is used for long-term historical storage.

This separation keeps read performance high while maintaining cost-efficient archival storage.


### 3. Fully serverless design

All components are serverless to reduce operational overhead and ensure automatic scaling based on demand.


## Challenges & Solutions

### 1. Handling traffic spikes during volatile market movement

**Problem:**  
Sudden price fluctuations can result in a high volume of incoming data, which can overload downstream processing.

**Solution:**  
SQS is used as a buffering layer between ingestion and processing. Lambda processes messages in controlled batches, ensuring stable throughput and preventing bottlenecks.


### 2. Ensuring cost efficiency during idle periods

**Problem:**  
Market data is not continuous 24/7, leading to potential idle resource costs in traditional architectures.

**Solution:**  
A fully serverless approach is used with pay-per-use services. S3 lifecycle policies are used for archival storage to further reduce long-term costs.


### 3. Maintaining system decoupling

**Problem:**  
Tightly coupled services make scaling and debugging difficult.

**Solution:**  
Each component is isolated using AWS-managed messaging services (SQS, SNS), ensuring independent scaling and fault isolation.


## Frontend

A simple dashboard built using HTML, CSS, and JavaScript is used to visualize:
- Latest stock prices
- Historical trends
- Alert notifications


## Terraform Structure

Infrastructure is organized into service-based configuration files:

- api_gateway.tf
- lambda.tf
- iam.tf
- sqs.tf
- sns.tf
- dynamodb.tf
- s3.tf
- eventbridge.tf


## Notes

- Designed for learning and portfolio demonstration
- Runs on AWS Free Tier (subject to usage limits)
- No manual server management required

---

