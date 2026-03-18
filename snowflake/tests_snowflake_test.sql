select *
from AVIV_TEST.analytics.leads_per_listing 
where leads_per_active_listing < 0
;
select * from AVIV_TEST.dbt.stg_listings
where property_type not in ('apartment', 'house', 'studio', 'loft', 'duplex');

select listing_id 
from AVIV_TEST.dbt.stg_listings
group by listing_id
having count(*)>1
;

select * 
from AVIV_TEST.dbt.stg_listings
where price < 0 or price >  10000000


;
select * 
from AVIV_TEST.dbt.stg_listings
where price < 100
;