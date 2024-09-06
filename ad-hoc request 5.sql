-- 5. Create a report featurinf top 5 products, ranked by Incremental revenue(IR%), across all campaigns. 
With facts as (
select 
	product_name,
    category,
    concat(round(sum(base_price * `quantity_sold(before_promo)`/1000000),2),' ', 'M') as Total_Revenue_Before_Promo,
	concat(round(sum(
	case
		when promo_type='BOGOF'then base_price  * 0.5 * 2 * `quantity_sold(after_promo)`
		when promo_type='500 Cashback' then (base_price - 500) * `quantity_sold(after_promo)`
		when promo_type='50% OFF' then base_price * 0.5 * `quantity_sold(after_promo)` 
		when promo_type='25% OFF' then base_price  * 0.75 * `quantity_sold(after_promo)`
		when promo_type='33% OFF' then base_price  * 0.67 * `quantity_sold(after_promo)`
		end)/1000000,2),' ', 'M') as Total_Revenue_After_Promo
from  fact_events join dim_products using (product_code)
join dim_campaigns using (campaign_id)
group by product_name, category),

incre_rev as (
select 
	*, 
    round(100* (Total_Revenue_After_Promo - Total_Revenue_Before_Promo)/Total_Revenue_Before_Promo,2) as `IR%`from facts)
    
select 
	product_name,
    category, `IR%`
from incre_rev 
order by `IR%` desc 
limit 5;
