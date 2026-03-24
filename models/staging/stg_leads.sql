-- cleaned and transformed leads data 

with source as (
    select contact_id,
            listing_id,
            contact_source,
            contact_timestamp
    from {{ source('raw', 'leads') }}
),

casted as (
    select
        contact_id,
        listing_id,
        contact_source,
        try_cast(contact_timestamp as date) as contact_date
    from source
    where contact_id is not null
),

leads_with_listing as (
    select
        c.*,
        l.created_at as listing_created_at,
        datediff(day, l.created_at, c.contact_date) as days_to_lead
    from casted c
    left join {{ ref('stg_listings') }} l on c.listing_id = l.listing_id
)

select * from leads_with_listing
