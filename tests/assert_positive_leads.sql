-- Custom test: leads_per_active_listing cannot be negative

select *
from {{ ref('leads_per_listing') }}
where leads_per_active_listing < 0