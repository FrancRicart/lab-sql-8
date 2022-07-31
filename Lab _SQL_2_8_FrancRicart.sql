/* 
Instructions
1. Write a query to display for each store its store ID, city, and country.
2. Write a query to display how much business, in dollars, each store brought in.
3. Which film categories are longest?
4. Display the most frequently rented movies in descending order.
5. List the top five genres in gross revenue in descending order.
6. Is "Academy Dinosaur" available for rent from Store 1?
7. Get all pairs of actors that worked together.
-- ignore this one 8. Get all pairs of customers that have rented the same film more than 3 times.
9. For each film, list actor that has acted in more films.
*/

USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.

SELECT 	
	s.store_id AS store,
    ci.city AS city,
    co.country AS country
FROM store AS s

LEFT JOIN address as a
ON s.address_id = a.address_id

LEFT JOIN city as ci
ON a.city_id = ci.city_id

LEFT JOIN country as co
ON ci.country_id = co.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id as store, SUM(p.amount) as business
FROM staff as s
LEFT JOIN payment as p
ON s.staff_id = p.staff_id
GROUP BY store
ORDER BY business DESC;

-- 3. Which film categories are longest?

SELECT ca.name as "category", AVG(fi.length) AS "Duration"
FROM film AS fi
LEFT JOIN film_category AS fc
ON fi.film_id = fc.film_id
LEFT JOIN category AS ca
ON ca.category_id = fc.category_id
GROUP BY category
ORDER BY length DESC;

-- 4. Display the most frequently rented movies in descending order.

SELECT fi.title AS title, COUNT(re.rental_id) AS times_rented
FROM film AS fi
LEFT JOIN inventory AS i
ON fi.film_id = i.film_id
LEFT JOIN rental AS re
ON i.inventory_id = re.inventory_id
GROUP BY fi.film_id
ORDER BY times_rented DESC;


-- 5. List the top five genres in gross revenue in descending order.
SELECT ca.name AS genre, SUM(p.amount) as gross_revenue
FROM category as ca
LEFT JOIN film_category as fc
ON ca.category_id = fc.category_id
LEFT JOIN inventory as i
ON fc.film_id = i.film_id
LEFT JOIN rental as r
ON i.inventory_id = r.inventory_id
LEFT JOIN payment as p
ON r.rental_id = p.rental_id
GROUP BY genre
ORDER BY gross_revenue DESC;


-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT i.store_id as store_number, COUNT(f.title) as title
FROM film AS f
LEFT JOIN inventory as i
ON f.film_id = i.film_id
WHERE (f.title = "Academy Dinosaur") AND (i.store_id = 1);


-- 7. Get all pairs of actors that worked together.

SELECT 
	a1.first_name AS "Name1", 
	a1.last_name AS "Surname1", 
    a2.first_name AS "Name2", 
    a2.last_name AS "Surname2"
    
FROM film_actor AS f1
INNER JOIN film_actor AS f2
ON f1.film_id = f2.film_id
INNER JOIN actor AS a1
ON f1.actor_id = a1.actor_id
INNER JOIN actor AS a2
ON f2.actor_id = a2.actor_id

WHERE (f1.film_id = f2.film_id) AND (f1.actor_id != f2.actor_id) AND (a1.actor_id NOT IN (SELECT a2.actor_id))
ORDER BY Surname1, Name1, Surname2, Name2;

-- -------------------------------

SELECT 
	a1.film_id, 
    concat(a1.first_name, ' ', a1.last_name) AS actor1, 
    concat(a2.first_name, ' ', a2.last_name) AS actor2
    
FROM 
	(SELECT a.actor_id, a.first_name, a.last_name, fa.film_id
	FROM actor AS a
	JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id) AS a1

JOIN 
	(SELECT a.actor_id, a.first_name, a.last_name, fa.film_id
	FROM actor AS a
	JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id) AS a2

ON a1.film_id = a2.film_id AND a1.actor_id != a2.actor_id;


-- 9. For each film, list actor that has acted in more films.
-- It does not work!

SELECT 
	f.title AS film_title,
	concat(a.first_name, ' ', a.last_name) AS actor_name,
	count(f.film_id) AS number_of_films
FROM actor AS a

JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id

JOIN film AS f 
ON fa.film_id = f.film_id

GROUP BY f.film_id
ORDER BY 3 DESC;


