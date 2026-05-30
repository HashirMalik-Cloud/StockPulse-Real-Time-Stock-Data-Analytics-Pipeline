### 📊 Architecture Diagram  
![Architecture Diagram](Architecture%20Diagram.png)

# 📊 StockPulse — Real-Time Serverless Stock Analytics & Alerting Pipeline

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%23623CE4.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

StockPulse is a production-ready, event-driven serverless data pipeline that continuously ingests, analyzes, and archives real-time financial market data. Built entirely using **Infrastructure as Code (Terraform)**, the system tracks significant asset price fluctuations (e.g., $\pm3\%$ within a 10-minute window) and delivers instant notifications, demonstrating a highly available, decoupled cloud architecture running completely on a serverless footprint.

---

## 🏗️ System Architecture

*Below is the structural design of the fully decoupled ingestion and processing pipeline:*

```text
[EventBridge] 
     │ (1 Min Cron)
     ▼
[Fetcher Lambda] ──► (External API)
     │
     ▼
[Amazon SQS] ──► (Micro-batches of 10) ──► [Processor Lambda]
                                                  │
                     ┌────────────────────────────┼───────────────────────────┐
                     ▼                            ▼                           ▼
             [Amazon DynamoDB]             [Amazon S3]                  [Amazon SNS]
         (Low-latency Active Read)     (Historical Archive)         (Alert: Delta $\ge 3\%$)
                     ▲                                                        │
                     │                                                        ▼
             [API Gateway]                                               [Email / SMS]
                     ▲
                     │
            [Frontend Dashboard]

Here’s how the pipeline flows behind the scenes:

1. **Amazon EventBridge** triggers a Lambda function every minute to fetch the latest stock prices from a public API.
2. The fetched data is sent to **Amazon SQS**, which acts as a queue to handle real-time messages efficiently.
3. Another **AWS Lambda** function processes that data — detecting trends, comparing price differences, and determining whether an alert should be sent.
4. The latest processed prices are stored in **Amazon DynamoDB**, while complete historical data is archived in **Amazon S3** for future analytics or visualization.
5. When a significant price movement (e.g., $\pm3\%$) is detected, **Amazon SNS** sends an instant alert.
6. Throughout the process, **Amazon CloudWatch** monitors performance, tracks logs, and manages alarms to ensure everything runs smoothly.
7. **Terraform** ties everything together, provisioning the infrastructure automatically and making deployment as simple as running a few commands.

The beauty of StockPulse lies in its simplicity and scalability. It runs entirely on the AWS Free Tier, costs almost nothing to operate, and scales automatically as data volume grows. 

It’s a practical demonstration of how cloud-native, event-driven systems can be used to build powerful real-time analytics applications without needing to manage servers or complex backend systems.

From a learning perspective, this project introduces you to the core pillars of modern cloud development — **automation, event-driven architecture, data engineering, and serverless design**. Each component works together like a perfectly timed machine, turning live data into actionable insights.

In other words, StockPulse isn’t just about stocks — it’s about understanding how to move, process, and react to real-time data in the cloud. Whether you’re exploring DevOps, Data Engineering, or Cloud Architecture, this project gives you hands-on exposure to how production-grade, real-time systems are built and automated.

---

### ⚙️ Tools & Services Used
* **AWS Lambda** — serverless compute to run code automatically  
* **Amazon EventBridge** — schedule triggers to fetch stock data  
* **Amazon SQS** — reliable queue for real-time message handling  
* **Amazon DynamoDB** — NoSQL database for fast, structured storage  
* **Amazon S3** — object storage for historical and raw JSON data  
* **Amazon SNS** — sends alerts when thresholds are met  
* **Amazon CloudWatch** — monitoring, logging, and alerting  
* **Terraform** — automates infrastructure setup and deployment  

---

## ⚡ Architectural Challenges & Production Solutions

### 1. Handling Downstream Database Overload During High Volatility
> ❌ **The Challenge:** During sudden market crashes or volume spikes, the external API emits massive waves of telemetry. Executing direct database writes from an unthrottled Lambda function risks exhausting connection pools, hitting provisioned throughput limits, and dropping critical data.
> 
> **The Solution:** Integrated an Amazon SQS Queue as an asynchronous middle layer. The processing Lambda consumes messages in micro-batches (BatchSize: 10), smoothing out traffic spikes, reducing database write invocations, and guaranteeing zero data loss.

### 2. Eliminating Idling Costs via Serverless Tiering (FinOps Strategy)
> ❌ **The Challenge:** Traditional relational databases or persistent server instances accumulate high fixed costs even during market closure hours and weekends when data flows stop.
> 
> **The Solution:** Implemented an entirely serverless pay-per-use architecture. Utilizing DynamoDB On-Demand capacity scaling and S3 Lifecycle Policies to transition historical data to Glacier after 90 days, keeping operational overhead strictly close to $0 during market downtime.

---

**In summary:** StockPulse is a real-world demonstration of how data can move automatically through the cloud — from fetching, processing, and storing to alerting — all in real time. 

It’s scalable, efficient, and entirely serverless, making it an ideal portfolio project for showcasing skills in **AWS, DevOps, Cloud Computing, and Data Engineering**.