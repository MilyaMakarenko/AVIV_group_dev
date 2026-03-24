-- clean and transform raw listings data for staging layer

with source as (
    select listing_id,
            property_type,
            city,
            region,
            price,
            created_at,
            updated_at,
            agent_id
    from {{ source('raw', 'listings') }}
),

casted as (
    select
        -- keys
        listing_id,
        agent_id,
        
        -- text fields
        property_type,
        city,
        "region",
        
        -- numeric fields
        try_cast(price as number(38,0)) as price,
        
        -- dates
        try_cast(created_at as date) as created_at,
        try_cast(updated_at as date) as updated_at,
        
        -- listing age in days
        datediff(day, try_cast(created_at as date), current_date()) as listing_age_days
        
    from source
),

cleaned as (
    select
        *,
        -- active listings (≤ 120 days) 4 months
        case 
            when listing_age_days <= 120 then true
            else false
        end as is_active
    from casted
    where listing_id is not null
)

select * from cleaned
