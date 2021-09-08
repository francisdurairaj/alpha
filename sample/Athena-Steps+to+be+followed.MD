=================================================================================
What is Amazon Athena?
=================================================================================
- Interactive query service,that makes it easy to analyze data in Amazon S3 using standard SQL
- Athena is serverless,
- No infrastructure to manage, and you pay only for the queries that you run
- Pay per query
- Only pay for data scanned
- With Amazon Athena, you pay only for the queries that you run.
- You are charged $5 per terabyte scanned by your queries.
- Athena is out-of-the-box integrated with AWS Glue Data Catalog
- allowing you to create a unified metadata repository across various service
- Crawl data sources to discover schemas
- Helps to populate your Catalog with new and modified table and partition definitions, and maintain schema versioning.
=================================================================================
What is Amazon Glue?
=================================================================================
- AWS Glue is a serverless data-preparation service for extract, transform, and load (ETL) operations
- AWS Glue reduces the time it takes to start analyzing your data from months to minutes
- It provides you with both visual and code-based interfaces to make data preparation easy
- Data engineers and ETL developers can use AWS Glue Studio to create, run, and monitor ETL jobs with a few clicks
- Data analysts and data scientists can use AWS Glue DataBrew to visually clean up and normalize data without writing code

Crawler Name:     sigma-tickitdb-crawler-us-east-2
Inclue Path:      s3://app-ion-dev-bucket-us-east-2/tickitdb/allevents_pipe/allevents_pipe.txt/
                  s3://app-ion-dev-bucket-us-east-2/cars_csv/
IAM Role:         sigma-tickitdb-crawler-us-east-2-glue-role
Glue Table:       sigma-tickitdb
