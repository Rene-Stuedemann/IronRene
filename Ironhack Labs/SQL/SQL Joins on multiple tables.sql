# 1. Write a query to display for each store its store ID, city, and country.
select
ss.store_id,
sc.city,
sco.country
from sakila.store as ss
left join sakila.address as sa on ss.address_id = sa.address_id
left join sakila.city as sc on sa.city_id = sc.city_id
left join sakila.country as sco on sc.country_id = sco.country_id
;

# 2. Write a query to display how much business, in dollars, each store brought in.
select
sst.store_id,
round(sum(sp.amount)) as total_amount
from sakila.payment as sp
left join sakila.staff as ss on sp.staff_id = ss.staff_id
left join sakila.store as sst on ss.store_id = sst.store_id
group by sst.store_id
order by total_amount desc
;

# 3. What is the average running time of films by category?
select
sc.name as category,
round(avg(sf.length)) as avg_running_time
from sakila.film as sf
left join sakila.film_category as sfc on sf.film_id = sfc.film_id
left join sakila.category as sc on sfc.category_id = sc.category_id
group by category
order by avg_running_time desc
;

# 4. Which film categories are longest?
select
sc.name as category,
round(sum(sf.length)) as total_running_time
from sakila.film as sf
left join sakila.film_category as sfc on sf.film_id = sfc.film_id
left join sakila.category as sc on sfc.category_id = sc.category_id
group by category
order by total_running_time desc
;

# 5. Display the most frequently rented movies in descending order.
select
sf.title,
count(sr.rental_id) as top_rented
from sakila.film as sf
left join sakila.inventory as si on sf.film_id = si.film_id
left join sakila.rental as sr on si.inventory_id = sr.inventory_id
group by sf.title
order by top_rented desc
limit 10
;

# 6. List the top five genres in gross revenue in descending order.
select
sc.name as category,
round(sum(sp.amount)) as gross_revenue
from sakila.film as sf
left join sakila.film_category as sfc on sf.film_id = sfc.film_id
left join sakila.category as sc on sfc.category_id = sc.category_id
left join sakila.inventory as si on sf.film_id = si.film_id
left join sakila.rental as sr on si.inventory_id = sr.inventory_id
left join sakila.payment as sp on sr.rental_id = sp.rental_id
group by category
order by gross_revenue desc
limit 5
;

# 7. Is "Academy Dinosaur" available for rent from Store 1?
select
sf.title,
si.store_id,
(case when sr.return_date <= now() then "Yes" else "No" end) as Available
from sakila.film as sf
left join sakila.inventory as si on sf.film_id = si.film_id
left join sakila.rental as sr on si.inventory_id = sr.inventory_id
where sf.title in ("Academy Dinosaur")
#and si.store_id = 1
group by si.store_id
order by sr.return_date desc
;
