# 1. Which actor has appeared in the most films?
select
sa.first_name,
sa.last_name,
count(sf.film_id) as Films
from sakila.film_actor as sf
join sakila.actor as sa on sf.actor_id = sa.actor_id
group by sf.actor_id
order by Films desc
limit 1
;

# 2. Most active customer (the customer that has rented the most number of films)
select
sc.first_name,
sc.last_name,
count(sr.rental_id) as rented_films
from sakila.customer as sc
join sakila.rental as sr on sc.customer_id = sr.customer_id
where sc.active=1
group by sc.customer_id
order by rented_films desc
limit 1
;

# 3. List number of films per category.
select
sc.name as category,
count(sf.film_id) as films
from sakila.film as sf
join sakila.film_category as sfc on sf.film_id = sfc.film_id
join sakila.category as sc on sfc.category_id = sc.category_id
group by category
order by films desc
;

# 4. Display the first and last names, as well as the address, of each staff member.
select
ss.first_name,
ss.last_name,
sa.address,
sa.district
from sakila.staff as ss
join sakila.address as sa on ss.address_id = sa.address_id
;

# 5. Display the total amount rung up by each staff member in August of 2005.
select
ss.first_name,
ss.last_name,
round(sum(sp.amount)) as total_amount
from sakila.payment as sp
join sakila.staff as ss on sp.staff_id = ss.staff_id
where sp.payment_date like ("2005-08%")
group by sp.staff_id
order by total_amount desc
;

# 6. List each film and the number of actors who are listed for that film.
select
sf.title as film,
count(sfa.actor_id) as actors
from sakila.film as sf
join sakila.film_actor as sfa on sf.film_id = sfa.film_id
group by film
order by actors desc
;

# 7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name. 
select
sc.first_name,
sc.last_name,
round(sum(sp.amount)) as total_amount
from sakila.customer as sc
join sakila.payment as sp on sc.customer_id = sp.customer_id
group by sc.customer_id
order by sc.last_name
;

# Bonus: Which is the most rented film? The answer is Bucket Brotherhood This query might require using more than one join statement.
select
title,
count(rental_id) as times_rented
from sakila.film as sf
join sakila.inventory as si on sf.film_id = si.film_id
join sakila.rental as sr on si.inventory_id = sr.inventory_id
group by title
order by times_rented desc
limit 1
;
