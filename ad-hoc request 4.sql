-- 4. Produce a report that calculates Incremental sales unit(ISU%) for each category during Diwali campaign. Additionally provide rankings
-- to the category based on their ISU%.
With quantity as (
select 
	d.category, dc.campaign_name, sum(f.`quantity_sold(before_promo)`) as total_quantity_sold_before_promo, 
    sum(if(f.promo_type='BOGOF', f.`quantity_sold(after_promo)`*2,f.`quantity_sold(after_promo)`)) as total_quantity_sold_after_promo
from dim_campaigns dc
join fact_events f using(campaign_id)
join dim_products d using(product_code)
where campaign_name='Diwali'
group by d.category),

rankings as(
select  
	category, 
    campaign_name, 
	round(100 * (total_quantity_sold_after_promo - total_quantity_sold_before_promo)/total_quantity_sold_before_promo,2)
as `ISU%`
from quantity 
group by category)

select 
	*, 
    dense_rank() over( order by `ISU%` desc)
from rankings;
