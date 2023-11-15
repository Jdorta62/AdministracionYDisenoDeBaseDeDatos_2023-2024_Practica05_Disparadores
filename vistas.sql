-- Ejercicio 5a
create view view_total_sales_category as
select aux.categoria, sum(aux.amount) as ventas_totales
from (
    select rental.rental_id, film_category.category_id, category.name as categoria, payment.amount
    from inventory
    join film_category ON film_category.film_id = inventory.film_id
    join category on film_category.category_id = category.category_id
    join rental ON rental.inventory_id = inventory.inventory_id 
    join payment on rental.rental_id = payment.rental_id
) as aux
group by aux.categoria
order by ventas_totales DESC;

-- Ejercicio 5b
create view view_total_sales_store as 
select ventas_por_tienda.total_ventas, encargado_ubicacion_tienda.ubicacion, encargado_ubicacion_tienda.encargado
from (
  select inventory.store_id, sum(payment.amount) as total_ventas
  from rental
  join inventory on inventory.inventory_id = rental.inventory_id
  join payment on rental.rental_id = payment.rental_id
  group by store_id
) as ventas_por_tienda
join (
  select aux.store_id, aux.ubicacion, concat(staff.first_name, ' ', staff.last_name) as encargado
  from (
    select store.store_id, store.manager_staff_id , concat(city.city, ', ', country.country) as ubicacion
    from country
    join city on country.country_id = city.country_id
    join address on address.city_id = city.city_id
    join store on address.address_id = store.address_id
  ) as aux
  join staff on aux.store_id = staff.store_id
) as encargado_ubicacion_tienda on encargado_ubicacion_tienda.store_id = ventas_por_tienda.store_id
order by total_ventas;

-- Ejercicio 5c
create view view_film_list_references as 
select film.film_id, title, description, categoria_pelicula.name as category, replacement_cost, length, rating, actores_pelicula.actor_name
from film
join (
  select film_id, name
  from film_category
  join category on category.category_id = film_category.category_id
) as categoria_pelicula on film.film_id = categoria_pelicula.film_id
join (
  select film_actor.film_id, film_actor.actor_id, concat(first_name, ' ', last_name) as actor_name
  from film_actor
  join actor on film_actor.actor_id = actor.actor_id
) as actores_pelicula on actores_pelicula.film_id = film.film_id
order by film.film_id;

-- Ejercicio 5d
create view view_actor_categories_titles as
select
    concat(actor.first_name, ' ', actor.last_name) AS nombre_actor,
    string_agg(DISTINCT category.name, ':') AS categorias,
    string_agg(DISTINCT film.title, ':') AS titulos
from actor
join film_actor on film_actor.actor_id = actor.actor_id
join film on film.film_id = film_actor.film_id
join film_category on film.film_id = film_category.film_id
join category on category.category_id = film_category.category_id
group by nombre_actor
order by nombre_actor;
