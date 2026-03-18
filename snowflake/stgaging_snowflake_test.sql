--------------------------------------------------stg LISTINGS -----------------------------------------------

create or alter view AVIV_TEST.DBT.stg_listings as 
with source as (
    select * from AVIV_TEST.PUBLIC.LISTINGS
),

casted as (
    select
        -- ключи
        listing_id,
        agent_id,
        
        -- текстовые поля
        property_type,
        city,
        "region",
        
        -- числовые поля
        try_cast(price as number(38,0)) as price,
        
        -- даты
        try_cast(created_at as date) as created_at,
        try_cast(updated_at as date) as updated_at,
        
        -- возраст объявления в днях
        datediff(day, try_cast(created_at as date), current_date()) as listing_age_days
        
    from source
),

cleaned as (
    select
        *,
        -- активные объявления (≤ 120 дней)
        case 
            when listing_age_days <= 120 then true
            else false
        end as is_active
    from casted
    where listing_id is not null
)

select *  
from cleaned

;
select * from AVIV_TEST.DBT.stg_listings
where is_active;
--------------------------------------------------stg LEADS -----------------------------------------------
create or alter view AVIV_TEST.DBT.stg_leads as 
with
source as (
    select * from AVIV_TEST.PUBLIC.LEADS
)

 , casted as (
    select
        CONTACT_ID,
        listing_id,
        contact_source,
        -- try_cast(contact_timestamp as timestamp) as contact_timestamp,
        try_cast(contact_timestamp as date) as contact_date
    from source
    where CONTACT_ID is not null
)
,
leads_with_listing as (
    select
        c.*,
        l.created_at as listing_created_at
        ,datediff(day, l.created_at, c.contact_date) as days_to_lead
    from casted c
    left join AVIV_TEST.DBT.stg_listings l on c.listing_id = l.listing_id
)

select * from leads_with_listing
;
select * from AVIV_TEST.DBT.stg_leads;