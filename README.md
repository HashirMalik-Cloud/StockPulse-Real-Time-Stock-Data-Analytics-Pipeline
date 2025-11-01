### 📊 Architecture Diagram  
![Architecture Diagram](Architecture%20Diagram.png)

## 🧭 Project Overview

**StockPulse — Real-Time Stock Data Analytics Pipeline**

StockPulse is a fully automated, serverless system built on AWS that continuously collects, processes, and analyzes real-time stock market data. It’s designed to monitor popular stocks like Tesla (TSLA), Apple (AAPL), Amazon (AMZN), and Microsoft (MSFT), detect when their prices change significantly, and instantly alert users when those changes cross a defined threshold — such as a ±3% fluctuation within 10 minutes.

In simple terms, StockPulse acts like a 24/7 stock-watching assistant that never misses a move. It constantly fetches data, processes it intelligently, and notifies you the moment something noteworthy happens — all without needing a single manually managed server.

The project showcases how to build a **real-time, event-driven data pipeline** using AWS serverless tools. It demonstrates how different cloud services can work together seamlessly — fetching data from an external API, processing it, storing it for analytics, and triggering automated alerts when needed.

At its heart, StockPulse is powered by a combination of AWS Lambda, EventBridge, SQS, DynamoDB, S3, SNS, and CloudWatch — all managed and deployed through Terraform for complete automation.

Here’s how the pipeline flows behind the scenes:

1. **Amazon EventBridge** triggers a Lambda function every minute to fetch the latest stock prices from a public API.
2. The fetched data is sent to **Amazon SQS**, which acts as a queue to handle real-time messages efficiently.
3. Another **AWS Lambda** function processes that data — detecting trends, comparing price differences, and determining whether an alert should be sent.
4. The latest processed prices are stored in **Amazon DynamoDB**, while complete historical data is archived in **Amazon S3** for future analytics or visualization.
5. When a significant price movement (e.g., ±3%) is detected, **Amazon SNS** sends an instant alert.
6. Throughout the process, **Amazon CloudWatch** monitors performance, tracks logs, and manages alarms to ensure everything runs smoothly.
7. **Terraform** ties everything together, provisioning the infrastructure automatically and making deployment as simple as running a few commands.

The beauty of StockPulse lies in its simplicity and scalability. It runs entirely on the AWS Free Tier, costs almost nothing to operate, and scales automatically as data volume grows. It’s a practical demonstration of how cloud-native, event-driven systems can be used to build powerful real-time analytics applications without needing to manage servers or complex backend systems.

From a learning perspective, this project introduces you to the core pillars of modern cloud development — **automation, event-driven architecture, data engineering, and serverless design**. Each component works together like a perfectly timed machine, turning live data into actionable insights.

In other words, StockPulse isn’t just about stocks — it’s about understanding how to move, process, and react to real-time data in the cloud. Whether you’re exploring DevOps, Data Engineering, or Cloud Architecture, this project gives you hands-on exposure to how production-grade, real-time systems are built and automated.

---

### ⚙️ Tools & Services Used
- **AWS Lambda** — serverless compute to run code automatically  
- **Amazon EventBridge** — schedule triggers to fetch stock data  
- **Amazon SQS** — reliable queue for real-time message handling  
- **Amazon DynamoDB** — NoSQL database for fast, structured storage  
- **Amazon S3** — object storage for historical and raw JSON data  
- **Amazon SNS** — sends alerts when thresholds are met  
- **Amazon CloudWatch** — monitoring, logging, and alerting  
- **Terraform** — automates infrastructure setup and deployment  

---

**In summary:**  
StockPulse is a real-world demonstration of how data can move automatically through the cloud — from fetching, processing, and storing to alerting — all in real time. It’s scalable, efficient, and entirely serverless, making it an ideal portfolio project for showcasing skills in **AWS, DevOps, Cloud Computing, and Data Engineering**.
