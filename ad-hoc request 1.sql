-- 1. Provide list of products with base price greater than 500 and that are featured in promo type 'BOGOF'.
select 
	distinct p.product_name,
	f.promo_type, 
	f.base_price    
from fact_events f 
join dim_products p
on p.product_code=f.product_code
where f.base_price > 500 and f.promo_type='BOGOF'
order by f.base_price desc;