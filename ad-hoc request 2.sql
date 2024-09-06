-- 2. Generate a report that provide an overview of number of stores in each city.
select 
	city,
    count(distinct store_id) as store_count
from dim_stores
group by city
order by store_count desc;