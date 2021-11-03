# 1. How many copies of the film Hunchback Impossible exist in the inventory system?
# not really see a need for a subquery to get the result
select
sf.title,
count(si.film_id) as copies
from sakila.film as sf
join sakila.inventory as si on sf.film_id = si.film_id
where sf.title in ("Hunchback Impossible")
;

# 2. List all films whose length is longer than the average of all the films.
select
title,
sf.length
from sakila.film as sf
where sf.length >
(
select
round(avg(length)) as avg_length
from sakila.film
)
order by sf.length
;

# 3. Use subqueries to display all actors who appear in the film Alone Trip.
select
concat(sa.first_name, " ", sa.last_name) as 'Actors in "Alone Trip"'
from sakila.actor as sa
join sakila.film_actor as sfa using (actor_id)
where film_id in
(
select
film_id
from sakila.film as sf
where title in ("Alone Trip")
)
;

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select
sf.title as "Family Movies"
from sakila.film as sf
join sakila.film_category as sfc using (film_id)
where sfc.category_id in
(
select
category_id
from sakila.category
where name in ("family")
)
;

# 5. Get name and email from customers from Canada using subqueries.
select
concat(sc.first_name, " ", sc.last_name) as Customer,
sc.email
from sakila.customer as sc
where address_id in
(select
address_id
from sakila.address as sa
join sakila.city as sci using (city_id)
join sakila.country as sco using (country_id)
where sco.country in ("Canada")
)
;

# Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select
concat(sc.first_name, " ", sc.last_name) as Customer,
sc.email,
sco.country
from sakila.customer as sc
join sakila.address as sa using (address_id)
join sakila.city as sci using (city_id)
join sakila.country as sco using (country_id)
where sco.country in ("Canada")
;

# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select  # parent query to get films of actor with most films
sf.title as "Movies by the most prolific actor"
from sakila.film as sf
join sakila.film_actor as sfa using (film_id)
where actor_id in
(
select  # sub-query to get actor_id of actor with most films
actor_id
from
(select   # sub-sub-query to count films by actor
actor_id,
count(film_id) as acted_in
from sakila.film_actor
group by actor_id
order by acted_in desc) as sub1
having max(acted_in)
)
;

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select # parent-query to get film titles of of customer with highest amount
title as "Films rented by most profitable customer"
from sakila.film
where film_id in
(# sub-query to get film_ids of of customer with highest amount
select 
film_id
from sakila.inventory
where inventory_id in
(# sub-query to get inventory_ids of of customer with highest amount
select 
inventory_id
from sakila.rental
where customer_id in
(# sub-query to get cust_id of customer with highest amount
select  
customer_id
from
(# sub-query to get total amount of customers
select  
customer_id,
round(sum(amount)) as total_amount
from sakila.payment
group by customer_id
order by total_amount desc
) as sub1
having max(total_amount)
)
)
);

# 8. Customers who spent more than the average payments.
select # get customer where avg_cst_amount > avg_amount
customer_id,
avg_cst_amount
from
(
select # sub-query to get avg_amount by customer
customer_id,
round(avg(amount)) as avg_cst_amount
from sakila.payment
group by customer_id
order by avg_cst_amount desc
) as sub1
where avg_cst_amount >
(# sub-query to get overall avg_amount
select
round(avg(amount)) as avg_amount
from sakila.payment
order by avg_amount desc
)
;

