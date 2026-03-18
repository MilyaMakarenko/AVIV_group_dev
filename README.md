# AVIV_group_test

## **Project Overview**
This project demonstrates the process of transforming raw real estate data (listings and leads) into **business metrics** using a modern stack: **AWS S3 → Snowflake → dbt**.

**Key Metric:**  
*Leads per Active Listing* by property type and region.

### Components:
1. **AWS S3** — storage for raw CSV files (`synthetic_listings.csv`, `synthetic_leads.csv`)
2. **Snowflake** — data ingestion via `COPY INTO` (see `s3_stage.sql`)
3. **dbt Core** — data transformation, testing, and documentation
4. **GitHub** — version control and collaboration

## All steps:

Firs step:
- generated data , 2 csv files with synthetic data - synthetic_listings.csv and synthetic_leads.csv
script - generate_data.ipynb
  <img width="975" height="304" alt="image" src="https://github.com/user-attachments/assets/a905cf90-a9bf-433c-aeb9-80f5eb3fc3ff" />


Secont step:
- added data to a S3 bucket (!!! using WEB interface)
  <img width="1685" height="660" alt="image" src="https://github.com/user-attachments/assets/14530b03-974e-4434-91b6-1608d9b4df1e" />

Third step:
- Raw CSV files were uploaded to S3  and loaded into Snowflake using `COPY INTO` commands with a storage integration for secure cross-account access.
  <img width="1871" height="665" alt="image" src="https://github.com/user-attachments/assets/7d023396-d82b-4b4a-8aef-402e7137805a" />
  <img width="922" height="533" alt="image" src="https://github.com/user-attachments/assets/9286bedf-ebce-4f69-939b-9c17a5d4be7b" />

4 step:
- During this take-home assignment, I encountered limitations with my Snowflake trial account, which blocks external connections by default (connecting via dbt Core from a local machine). 
This is a known restriction for trial accounts, as outlined in Snowflake's official documentation: external access is often disabled for trial environments.
<img width="491" height="130" alt="image" src="https://github.com/user-attachments/assets/96914e2c-5cac-442b-bd66-b564c886164c" />
<img width="531" height="160" alt="image" src="https://github.com/user-attachments/assets/a84abba9-0320-4487-a41e-787b8ce87a25" />



- All dbt models were fully developed following best practices (staging and mart layers, tests, documentation)
- SQL logic was tested and validated directly in the Snowflake web interface (Worksheets)
- The pipeline logic remains intact and production-ready
- Project structure fully meets the assignment requirements

  <img width="264" height="96" alt="image" src="https://github.com/user-attachments/assets/88d33c8a-5066-47a8-8387-bb4820ac3d36" />
  <img width="941" height="528" alt="image" src="https://github.com/user-attachments/assets/3c26f063-b0e7-49be-926c-a825c2985c3a" />

5 step:
- created structure and test every step in Snowflake (because I couldn't connect dbt and Sf)
  <img width="1073" height="518" alt="image" src="https://github.com/user-attachments/assets/4629a016-0f7f-446b-b54c-cd3366c92c08" />

6 step:
- created transformation (dbt) using Staging Layer (models/staging/) and  Mart Layer (models/marts/)
  Data type casting, NULL value filtering, Derived fields calculation (is_active, days_to_lead), Value normalization
  Aggregation by property type and region, Key metric Leads per Active Listing calculation, Conversion categorization (High/Medium/Low/No leads)
- created data quality testing
  All tests are defined in schema.yml and include:
  - Uniqueness (unique) — on listing_id, contact_id
  - NOT NULL — on key fields
  - Referential integrity (relationships) — leads to listings
  - Accepted values (accepted_values) — for property_type, contact_source
  - Price range (dbt_utils.accepted_range) — 0–10M
  - Freshness (freshness) — ingestion monitoring
- calculated the business metric: Leads per Active Listing
    Leads per Active Listing = Total Leads / Active Listings

      where Active Listings are listings created within the last 4 mounths.
  <img width="1289" height="697" alt="image" src="https://github.com/user-attachments/assets/5bb74f1a-41ff-4633-a1c4-7d7cbc4669ec" />
  <img width="2083" height="721" alt="image" src="https://github.com/user-attachments/assets/182d78f4-66d9-45e0-a98e-e6a30b822620" />


Result structire:
```
📦 AVIV_group_dev
├── 📁 data/ # Generated CSV files
│ ├── synthetic_listings.csv
│ └── synthetic_leads.csv
├── 📁 models/ # dbt models
│ ├── 📁 staging/ # Staging layer
│ │ ├── schema.yml # Tests and documentation
│ │ ├── stg_listings.sql # Listings cleaning
│ │ └── stg_leads.sql # Leads cleaning
│ └── 📁 marts/ # Data marts
│ ├── schema.yml # Mart tests
│ └── leads_per_listing.sql # Key metric
├── 📁 snapshots/ # SCD Type 2 (history tracking)
│ └── listings_snapshot.sql
├── 📁 tests/ # Custom tests
│ └── assert_positive_leads.sql
├── 📄 .gitignore # Excludes sensitive files
├── 📄 dbt_project.yml # dbt configuration
├── 📄 README.md # Documentation
├── 📄 s3_stage.sql # S3 to Snowflake ingestion
└── 📄 generate_data.ipynb # Synthetic data generation
```

P.S. All calculations and tests were validated directly in Snowflake
  <img width="1359" height="686" alt="image" src="https://github.com/user-attachments/assets/3fd03eeb-47d8-4436-86c2-d6b76252d3ee" />


