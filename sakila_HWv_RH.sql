USE SAKILA;
#####  1a;
SELECT first_name, last_name FROM actor;
#####  1b;
SELECT  Upper(concat(first_name, " ",last_name)) as 'Actor Name'
FROM actor;
##### 2a;
 SELECT actor.actor_id, actor.first_name, actor.last_name, actor.last_update
FROM actor
WHERE (((actor.first_name)="joe"));
#####  2b;
SELECT actor.actor_id, actor.first_name, actor.last_name, actor.last_update
FROM actor
WHERE (((actor.last_name) like "%GEN%"));
##### 2c;
SELECT actor.actor_id, actor.first_name, actor.last_name, actor.last_update
FROM actor
WHERE (((actor.last_name) Like "%LI%"))
ORDER BY actor.first_name, actor.last_name;
####### 2d;
SELECT country.country_id, country.country
FROM country
WHERE (((country.country) In ("Afghanistan","Bangladesh","China")));

###### 3a 3b DESCRIPTION  BLOB strings do not hold character data.;

ALTER TABLE actor add description BLOB;
ALTER TABLE actor DROP description;
###### 4a
SELECT actor.last_name, Count(actor.last_name) AS Mycount
FROM actor
GROUP BY actor.last_name;
######### 4b
SELECT actor2.last_name, Count(actor2.last_name) AS Mycount
FROM actor2
GROUP BY actor2.last_name
HAVING (((Count(actor2.last_name))>1));
######## 4c
UPDATE actor SET actor.first_name = "HARPO"
WHERE (((actor.first_name)="GROUCHO") AND ((actor.last_name)="WILLIAMS"));

SELECT actor.first_name, actor.last_name FROM actor WHERE last_name = 'WILLIAMS';

##### 4d;

UPDATE actor SET actor2.first_name = "GROUCHO"
WHERE (((actor.first_name)="HARPO") AND ((actor.last_name)="WILLIAMS"));

SELECT actor.first_name, actor.last_name FROM actor WHERE last_name = 'WILLIAMS';
##### 5a  FIND SCHHEMA


###### 6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff LEFT JOIN address ON staff.address_id = address.address_id;
###### 6b;
SELECT staff.staff_id, staff.first_name, staff.last_name, Sum(payment.amount) AS SumOfamount
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE (((payment.payment_date)>= 8/1/2005))
GROUP BY staff.staff_id, staff.first_name, staff.last_name;

###### 6c
SELECT film.title, Count(film_actor.actor_id) AS CountOfactor_id
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;
#####  6d

SELECT film.title, Count(inventory.film_id) AS CountOffilm_id 
FROM film LEFT JOIN inventory ON film.film_id = inventory.film_id
GROUP BY film.title
HAVING (FILM.TITLE = "HUNCHBACK IMPOSSIBLE");

##### 6e
SELECT customer.first_name, customer.last_name, Sum(payment.amount)  AS SumOfamount
FROM customer LEFT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

##### 7a;

SELECT language.name, film.title
FROM film INNER JOIN language ON film.language_id = language.language_id
WHERE (Left(film.title,1)) IN ('K',"Q")
GROUP BY film.language_id, language.name, film.title
HAVING (((language.name)="English"));
#### 7b
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
    SELECT film_id
    FROM film
    WHERE film.title = 'Alone Trip'
  ) 
);


##### 7b  JOIN
SELECT film.title, actor.first_name, actor.last_name
FROM (film INNER JOIN  film_actor ON film.film_id = film_actor.film_id) INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE (((film.title)= 'Alone Trip'));

#####  7c
SELECT customer.first_name, customer.last_name, customer.email, 'city.name', address.district, country.country
FROM customer INNER JOIN ((address INNER JOIN city ON address.city_id = city.city_id) 
INNER JOIN country ON city.country_id = country.country_id)
ON customer.address_id =address.address_id
WHERE (((country.country )="Canada"));
##### 7d
SELECT  category.name, film.title
FROM (category INNER JOIN film_category ON category.category_id =film_category.category_id)
 INNER JOIN film ON film_category.film_id = film.film_id
WHERE (((category.name)='Family'));
######   7e
SELECT film.title, Count(rental.rental_date) AS CountOfrental_date
FROM (inventory LEFT JOIN film ON inventory.film_id =film.film_id ) 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY Count(rental_date) DESC;
#####  7f
SELECT store.store_id, store.manager_staff_id, payment.staff_id, Sum(payment.amount)  AS SumOfamount
FROM (store INNER JOIN payment on store.manager_staff_id = payment.staff_id)
GROUP BY store.store_id, store.manager_staff_id, payment.staff_id;
########  7g
SELECT store.store_id, address.address, 'city.city_name', 'country.country_name'
FROM store INNER JOIN ((address  INNER JOIN city ON address.city_id = city.city_id) INNER JOIN country 
ON city.country_id = country.country_id) ON store.address_id=address.address_id;
########  8a  \ 8b
CREATE VIEW myRevenue as 
SELECT category.name, Sum(payment.amount) AS SumOfamount
FROM (((category INNER JOIN film_category ON category.category_id= film_category.category_id)
INNER JOIN inventory on film_category.film_id = inventory.film_id) 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id)
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY Sum(payment.amount) DESC;
######## 8C
SELECT * from myRevenue;

###### 8d
DROP VIEW myRevenue;
