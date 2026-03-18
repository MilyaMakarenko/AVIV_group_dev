-- Tracking changes in price and region of listings

{% snapshot listings_snapshot %}

    {{
        config(
            target_schema='snapshots',
            unique_key='listing_id',
            strategy='check',
            check_cols=['price', 'region', 'city'],
            invalidate_hard_deletes=True
        )
    }}

    select * from {{ ref('stg_listings') }}

{% endsnapshot %}