-- Amount of leads per listing, segmented by property type and region

-- {{
--     config(
--         materialized='table',
--         schema='analytics'
--     )
-- }}
-- create or replace schema AVIV_TEST.analytics;
create or REPLACE  table AVIV_TEST.analytics.leads_per_listing 
as
(
with listings as (
    select
        listing_id,
        property_type,
        "region",
        is_active
    from AVIV_TEST.DBT.stg_listings
),

leads as (
    select
        listing_id,
        count(*) as total_leads
    from AVIV_TEST.DBT.stg_leads
    group by 1
),

joined as (
    select
        l.property_type,
        l."region",
        count(distinct case when l.is_active then l.listing_id end) as active_listings,
        count(distinct l.listing_id) as total_listings,
        coalesce(sum(le.total_leads), 0) as total_leads,
        
        -- key metric: leads per active listing
        round(
            coalesce(sum(le.total_leads), 0) * 1.0 / 
            nullif(count(distinct case when l.is_active then l.listing_id end), 0),
            2
        ) as leads_per_active_listing,
        
        -- for comparison: leads per total listing
        round(
            coalesce(sum(le.total_leads), 0) * 1.0 / 
            nullif(count(distinct l.listing_id), 0),
            2
        ) as leads_per_listing,
        
        -- business categorization based on leads per active listing
        case 
            when leads_per_active_listing > 5 then 'High conversion'
            when leads_per_active_listing between 2 and 5 then 'Medium conversion'
            when leads_per_active_listing > 0 then 'Low conversion'
            else 'No leads'
        end as conversion_category,
        
        current_timestamp() as model_run_time
        
    from listings l
    left join leads le on l.listing_id = le.listing_id
    group by l.property_type,
        l."region"
)

select * from joined
)
;

select * from AVIV_TEST.analytics.leads_per_listing ;