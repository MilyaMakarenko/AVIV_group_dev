-- Tracking changes in price and region of listings

{% snapshot listings_snapshot %}

    {{
        config(
            target_schema='snapshots',
            unique_key='listing_id',
            strategy='check',
            check_cols=['price', 'region', 'city'],
            invalidate_hard_deletes=True,
            updated_at='snapshot_timestamp'
        )
    }}

    select 
        listing_id,
        property_type,
        price,
        furnished_flag,
        current_timestamp as snapshot_timestamp,
        _loaded_at 
    from {{ ref('stg_listings') }}

{% endsnapshot %}
