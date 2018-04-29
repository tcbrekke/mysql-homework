
#Question 0 :-)
USE sakila;

#1.a
SELECT first_name FROM actor;
#1.b
SELECT CONCAT(first_name,' ' ,last_name) AS full_name FROM actor;
#2.a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name='Joe';
#2.b
SELECT * FROM actor WHERE last_name LIKE '%GEN%';
#2.c
SELECT * FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC;
#2.d
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
#3.a
ALTER TABLE actor
	ADD COLUMN middle_name VARCHAR(50) AFTER first_name;
#3.b 
ALTER TABLE actor
	MODIFY COLUMN middle_name BLOB;
#3.c
ALTER TABLE actor
	DROP COLUMN middle_name;
#4.a
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;
#4.b
SELECT last_name, COUNT(*) AS 'No. of Actors' FROM actor GROUP BY last_name HAVING COUNT(*) > 1;
#4.c
UPDATE actor
SET first_name='HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
#4.d
UPDATE actor SET first_name =
CASE 
	WHEN first_name = 'GROUCHO' AND last_name = 'WILLIAMS' THEN first_name = 'MUCHO GROUCHO'
    WHEN first_name = 'HARPO' AND last_name = 'WILLIAMS' THEN first_name = 'GROUCHO'
    ELSE first_name
END;
#5.a
SHOW CREATE TABLE address;
#6.a
SELECT staff.first_name, staff.last_name, address.address 
FROM staff
JOIN address
ON address.address_id = staff.address_id;
#6.b
SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS employee, SUM(payment.amount)
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY employee;
#6.c
SELECT film.title, COUNT(film_actor.film_id) AS 'actors_in_film'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title;
#6.d
SELECT title,
(
SELECT COUNT(film_id) FROM inventory WHERE inventory.film_id = film.film_id
)
AS 'Number of Copies'
FROM film
WHERE film.title = 'HUNCHBACK IMPOSSIBLE';
#6.e
SELECT CONCAT(c.last_name, ', ', c.first_name) AS 'customer', SUM(p.amount)
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY customer
ORDER BY customer ASC;
#7.a
SELECT f.title
FROM film f
WHERE (f.title LIKE 'Q%' OR f.title LIKE 'K%') AND f.language_id =
(
SELECT l.language_id
FROM language l
WHERE l.name = 'English'
);
#7.b
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN
(
SELECT fa.actor_id
FROM film_actor fa 
WHERE fa.film_id IN
(
SELECT f.film_id
FROM film f
WHERE f.title = 'ALONE TRIP'
)
);
#7.c
SELECT cu.first_name, cu.last_name, cu.email, co.country
FROM customer cu 
JOIN address a
	ON a.address_id = cu.address_id
JOIN city ci
	ON ci.city_id = a.city_id
JOIN country co
	ON ci.country_id = co.country_id
WHERE co.country = 'Canada';
#7.d 
SELECT f.title, cat.name
FROM film f
JOIN film_category fc
	ON fc.film_id = f.film_id
JOIN category cat
	ON fc.category_id = cat.category_id
WHERE cat.name = 'Family';
#7.e
SELECT f.title, COUNT(r.inventory_id) AS 'rentals'
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id
JOIN rental r
	ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY rentals DESC;
#7.f
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff st
	ON st.staff_id = p.staff_id
JOIN store s
	ON s.store_id = st.store_id
GROUP BY s.store_id;
#7.g
SELECT s.store_id, ci.city, co.country
FROM store s 
JOIN address a 
	ON s.address_id = a.address_id
JOIN city ci
	ON ci.city_id = a.city_id
JOIN country co 
	ON co.country_id = ci.country_id;
#7.h 
SELECT cat.name, SUM(p.amount) AS gross_revenue
FROM rental r
JOIN payment p
	ON r.rental_id = p.rental_id
JOIN inventory i
	ON i.inventory_id = r.inventory_id
JOIN film_category fc
	ON i.film_id = fc.film_id
JOIN category cat
	ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY gross_revenue DESC
LIMIT 5;
#8.a
CREATE VIEW top_5_genres_by_revenue AS
SELECT cat.name, SUM(p.amount) AS gross_revenue
FROM rental r
JOIN payment p
	ON r.rental_id = p.rental_id
JOIN inventory i
	ON i.inventory_id = r.inventory_id
JOIN film_category fc
	ON i.film_id = fc.film_id
JOIN category cat
	ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY gross_revenue DESC
LIMIT 5;
#8b
SELECT * FROM top_5_genres_by_revenue;
#8.c
DROP VIEW top_5_genres_by_revenue;