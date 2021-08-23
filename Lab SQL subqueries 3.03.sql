-- Lab SQL subqueries 3.03
USE sakila;

-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
-- with subquery:
SELECT count(inventory_id) from inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- with join:
SELECT count(inventory_id) FROM film f
JOIN inventory i USING(film_id)
WHERE title = 'Hunchback Impossible';
-- there are 6 copies of Hunchback Impossible in the inventory.


-- 2 List all films whose length is longer than the average of all the films.
SELECT title from film
WHERE length > (SELECT avg(length) FROM film);


-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM actor 
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
	WHERE film_id = (
		SELECT film_id FROM film 
        WHERE title = 'Alone Trip'));


/** 4 Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films. **/
SELECT title FROM film f
JOIN film_category fc USING(film_id)
JOIN category USING(category_id)
WHERE name = 'Family';

SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
	WHERE category_id = (
		SELECT category_id FROM category
		WHERE name = 'Family'));


/**  5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
Note that to create a join, you will have to identify the correct tables with their primary keys 
and foreign keys, that will help you get the relevant information. **/
-- using subqueries:
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
	SELECT address_id FROM address
    WHERE city_id IN (
		SELECT city_id from city
		WHERE country_id IN (
			SELECT country_id from country
			WHERE country = 'Canada')));

-- using joins:
SELECT first_name, last_name, email FROM customer
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id)
WHERE country = 'Canada';


/** 6 Which are films starred by the most prolific actor? Most prolific actor is defined as 
the actor that has acted in the most number of films. First you will have to find the most 
prolific actor and then use that actor_id to find the different films that he/she starred. **/
SELECT title FROM film
WHERE film_id IN(
	SELECT film_id FROM film_actor
    WHERE actor_id  = (
		SELECT actor_id FROM film_actor 
		GROUP BY actor_id order by count(*) desc limit 1));


/** 7 Films rented by most profitable customer. You can use the customer table and payment 
table to find the most profitable customer ie the customer that has made the largest sum of 
payments **/
SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM inventory WHERE inventory_id IN (
		SELECT inventory_id FROM rental WHERE customer_id =(
			SELECT customer_id FROM payment
			GROUP BY customer_id ORDER BY sum(amount) desc LIMIT 1)))
LIMIT 7;


-- 8 Customers who spent more than the average payments.
SELECT first_name, last_name FROM customer
WHERE customer_id IN (
	SELECT customer_id FROM payment
	WHERE amount > (SELECT avg(amount) FROM payment));
