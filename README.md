# AVIV_group_test

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





