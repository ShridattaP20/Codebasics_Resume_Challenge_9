-- 3. Generate a report that displays each campaign along with the total revenue genearated before and after campaign.
select 
	d.campaign_name,
    concat(round(sum(f.base_price * f.`quantity_sold(before_promo)`/1000000),2),' ', 'M') as Total_Revenue_Before_Promo,
	concat(round(sum(
	case
		when f.promo_type='BOGOF'then f.base_price  * 0.5 * 2 * f.`quantity_sold(after_promo)`
		when f.promo_type='500 Cashback' then (f.base_price - 500) * f.`quantity_sold(after_promo)`
		when f.promo_type='50% OFF' then f.base_price * 0.5 * f.`quantity_sold(after_promo)` 
		when f.promo_type='25% OFF' then f.base_price  * 0.75 * f.`quantity_sold(after_promo)`
		when f.promo_type='33% OFF' then f.base_price  * 0.67 * f.`quantity_sold(after_promo)`
		end)/1000000,2),' ', 'M') as Total_Revenue_After_Promo
from dim_campaigns d
join fact_events f 
on d.campaign_id=f.campaign_id
group by d.campaign_name;