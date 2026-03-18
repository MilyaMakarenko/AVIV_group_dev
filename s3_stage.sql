---> create the storage integration
drop STORAGE INTEGRATION S3_role_integration;
CREATE OR REPLACE STORAGE INTEGRATION S3_role_integration
 TYPE = EXTERNAL_STAGE
 STORAGE_PROVIDER = S3
 ENABLED = TRUE
 STORAGE_AWS_ROLE_ARN = "arn:aws:iam::125692571484:role/snowflake_role_snowpipe"
 STORAGE_ALLOWED_LOCATIONS = ("s3://intro-to-snowflake-snowpipe-m/");

---> describe the storage integration to see the info you need to copy over to AWS
DESCRIBE INTEGRATION S3_role_integration;

---> create the database
CREATE OR REPLACE DATABASE aviv_test;

---> create the table 
CREATE OR REPLACE TABLE aviv_test.public.listings (
listing_id varchar,
property_type varchar,
city varchar,
"region" varchar,
price INT,
created_at date,
updated_at date,
agent_id varchar
);
CREATE OR REPLACE TABLE aviv_test.public.leads (
contact_id varchar,
listing_id varchar,
contact_source varchar,
contact_timestamp date
);


USE SCHEMA aviv_test.public;



SHOW STAGES;

DESC STORAGE INTEGRATION S3_role_integration;
;
---> create stage with the link to the S3 bucket and info on the associated storage integration
DROP STAGE IF EXISTS listings_s3_stage;

CREATE OR REPLACE STAGE listings_s3_stage
  URL = 's3://intro-to-snowflake-snowpipe-m/'
  STORAGE_INTEGRATION = S3_role_integration;

-- check discription of stage
DESC STAGE listings_s3_stage;
DESC STORAGE INTEGRATION S3_role_integration;



---> see the files in the stage
LIST @listings_s3_stage/synthetic_listings.csv;
LIST @listings_s3_stage;

---> select the first two columns from the stage
SELECT $1, $2 , $3  FROM @listings_s3_stage/synthetic_listings.csv;

USE WAREHOUSE COMPUTE_WH;

 -- SELECT $1, $2 , $3, $4, $5 , $6, $7, $8  FROM @aviv_test.public.listings_s3_stage/synthetic_listings.csv;
 -- select *   FROM aviv_test.public.listings;

 ALTER STAGE listings_s3_stage
SET FILE_FORMAT = (
  TYPE = CSV 
  SKIP_HEADER = 1 
);
 

---> create the snowpipe, copying from S3_stage into S3_table
CREATE PIPE aviv_test.public.S3_pipe_listings AUTO_INGEST=TRUE as
 COPY INTO aviv_test.public.listings
 FROM @aviv_test.public.listings_s3_stage/synthetic_listings.csv;


CREATE PIPE aviv_test.public.S3_pipe_leads AUTO_INGEST=TRUE as
 COPY INTO aviv_test.public.leads
 FROM @aviv_test.public.listings_s3_stage/synthetic_leads.csv;
 

---> see a list of all the pipes
SHOW PIPES;

DESCRIBE PIPE aviv_test.public.S3_pipe_leads;

---> pause the pipe
ALTER PIPE aviv_test.public.S3_pipe_leads SET PIPE_EXECUTION_PAUSED = FALSE;
ALTER PIPE aviv_test.public.S3_pipe_listings SET PIPE_EXECUTION_PAUSED = FALSE;

SELECT * FROM aviv_test.public.listings;
SELECT * FROM aviv_test.public.leads;

