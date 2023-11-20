use sakila;
/* 1 Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/
select distinct title as título
from film
order by title asc;

/* 2 Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/
select distinct title as título
from film
where rating = "PG-13"
order by title asc;

/* 3 Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/
select distinct title as título , description as descripción
from film
where description like "%amazing%"
order by title asc;

/* 4 Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/
select distinct title as título, length as duración_película
from film
where length > 120
order by title asc;

/* 5 Recupera los nombres de todos los actores.*/
select first_name as nombre_actor, last_name as apellido_actor
from actor;
select concat_ws(" ", first_name, last_name) as nombre_completo 
from actor;
/*6 Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/
select first_name as nombre_actor, last_name as apellido_actor
from actor
where last_name = "Gibson";
select concat_ws(" ", first_name, last_name) as nombre_completo 
from actor
where last_name = "Gibson";

/*7 Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/
select actor_id, first_name as nombre_actor, last_name as apellido_actor
from actor
where actor_id between 10 and 20;

/*8 Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/
select distinct title as título, rating as calificación
from film
where rating != "PG-13" and  rating != "R"
order by title asc;

/*9 Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/
select distinct  rating as calificación, count(title) as recuento_títulos
from film
group by rating 
order by rating asc;

/*10 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/
select customer_id, concat_ws(" ", first_name, last_name) as nombre_completo, count(inventory_id) as nº_peliculas_alquiladas
from rental join customer using (customer_id)
group by customer_id;

/*11 Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.*/

select c.name as categoría , count(r.inventory_id) as nº_peliculas_alquiladas
from category as c
join film_category as cf on c.category_id = cf.category_id
join inventory as i on i.film_id = cf.film_id
join rental as r on i.inventory_id = r.inventory_id
group by c.name;

/*12 Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.*/
select distinct  rating as calificación, avg(length) as duración_media
from film
group by rating 
order by rating asc;

/*13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/
select concat_ws(" ", first_name, last_name) as actor_nombre_completo, title as título
from actor as a
join film_actor as fc on a.actor_id = fc.actor_id
join film as f on f.film_id = fc.film_id
where title = "Indian Love";

/*14 Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

select distinct title as título
from film
where description like "%dog%" or description like "%cat%"
order by title asc;

/*15 Hay algún actor que no aparezca en ninguna película en la tabla film_actor.*/

SELECT actor_id, CONCAT_WS(" ", first_name, last_name) AS actor_nombre_completo
FROM actor
WHERE actor_id NOT IN(
	select actor_id
	from film_actor);

/*16 Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/
select title as título, release_year as año_lanzamiento
from film
where release_year between 2005 and 2010
order by title asc;
/*17 Encuentra el título de todas las películas que son de la misma categoría que "Family".*/
select c.name as categoría, f.title as título
from category as c
join film_category as cf on c.category_id = cf.category_id
join  film as f on f.film_id = cf.film_id
where  c.name = "Family"
group by c.name, f.title;

/*18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/
select concat_ws(" ", first_name,last_name) as actor_nombre_completo
from actor as a
join film_actor as fc on a.actor_id = fc.actor_id
join film as f on f.film_id = fc.film_id
where fc.film_id > 10
group by concat_ws(" ", first_name,last_name) 
 ;

/*19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/
select title as título, rating as calificación , length as duración 
from film 
where rating = "R" and length >120;

/*20 Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/
select c.name as categoría, avg(f.length) as duración
from category as c
join film_category as cf on c.category_id = cf.category_id
join  film as f on f.film_id = cf.film_id
where  f.length > 120
group by c.name, f.length
order by f.length asc;


/*21  Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/

select concat_ws(" ", first_name,last_name) as actor_nombre_completo,  count(fc.film_id) as nº_películas
from actor as a
join film_actor as fc on a.actor_id = fc.actor_id
join film as f on f.film_id = fc.film_id
where fc.film_id >= 10
group by concat_ws(" ", first_name,last_name);

/*22 Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/
select title as título,  (date_format(r.return_date, '%d') - date_format(r.rental_date,'%d')) as duración_alquiler
from film as f 
join inventory as i on i.film_id = f.film_id
join rental  as r on i.inventory_id = r.inventory_id
where r.rental_id in (
	select rental_id
	from rental 
	where (date_format(return_date, '%d') - date_format(rental_date,'%d')) > 5);


/*23  Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

select distinct a.actor_id as actor_id, c.name as categoría
	from category as c , film_category as fc, film_actor as fa , actor as a 
	where fc.category_id = c.category_id and  fc.film_id =fa.film_id and a.actor_id = fa.actor_id
	group by c.name, a.actor_id
	having c.name = "horror"
    order by a.actor_id asc;

select actor_id,concat_ws(" ", first_name,last_name) as actor_nombre_completo
from actor 
where  actor_id not in (
	select distinct a.actor_id
	from category as c , film_category as fc, film_actor as fa , actor as a 
	where fc.category_id = c.category_id and  fc.film_id =fa.film_id and a.actor_id = fa.actor_id
	group by c.name, a.actor_id
	having c.name = "horror")
 order by actor_id asc  ;


/*24  BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.*/
select title as título, length as duración_pelicula
from film
where length > 180 and title in(   
    select distinct f.title
	from category as c , film_category as fc, film as f 
	where fc.category_id = c.category_id and  fc.film_id = f.film_id
    group by c.name , f.title 
	having c.name = "comedy");

/*25  BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.*/

/*¡¡¡¡¡ la siguiente query es mi razonamiento del ejercicio, entiendo que hay que hacer self join pero me quedé atascada en como mostrar el nombre y apellido desde la tabla actor!!!!!*/
select count(fc.film_id) as peliculas_juntos, fc.actor_id as actor1, fc1.actor_id as actor2
from film_actor as fc , film_actor as fc1
where fc.actor_id <> fc1.actor_id
and fc.film_id = fc1.film_id
group by fc.actor_id,fc1.actor_id;


/*¡¡¡¡¡¡por ello consulté chat gpt para ver como podía desarrollarse mejor y este es el resultado!!!!!*/
SELECT
    fc.actor_id AS actor1,
    concat_ws(" ", a1.first_name,a1.last_name) as actor1_nombre_completo,
    fc1.actor_id AS actor2,
    concat_ws(" ", a2.first_name,a2.last_name) as actor2_nombre_completo,
    COUNT(fc.film_id) AS peliculas_juntos
FROM
    film_actor fc
JOIN film_actor fc1 ON fc.film_id = fc1.film_id AND fc.actor_id < fc1.actor_id /* AND fc.actor_id < fc1.actor_id en la condición del segundo JOIN para evitar duplicados en las combinaciones de actores  */
JOIN actor a1 ON fc.actor_id = a1.actor_id
JOIN actor a2 ON fc1.actor_id = a2.actor_id
GROUP BY
    fc.actor_id, fc1.actor_id;

