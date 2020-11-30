-- drop schema if exists yelp_covid;
create schema yelp_covid;
use yelp_covid;


create view closed_restaurant as
select * 
from restaurant
where is_closed = 1;

select count(*) from closed_restaurant; -- 79 total closed restaurants
select count(*) from restaurant; -- 4353

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant; -- 1.81% of restaurants are closed (not as bad as I thought)

-- Average review rating for restaurants that closed was lower than the ones open

select avg(star_rating)
from restaurant
where num_reviews >= 100; -- 3.723

select avg(star_rating)
from closed_restaurant
where num_reviews >= 100; -- 3.595

-- determine type of cuisine in closed
select cuisine, count(cuisine)
from closed_restaurant
group by cuisine;

-- 27 total "american" cuisine restaurants closed 
select count(*)
from closed_restaurant
where cuisine like '%, american%' or cuisine like 'american%'; -- 27

select count(*)
from restaurant
where cuisine like '%, american%' or cuisine like 'american%'; -- 544

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%, american%' or cuisine like 'american%'; -- 4.96

-- italian cuisine
select count(*)
from closed_restaurant
where cuisine like '%, italian%' or cuisine like 'italian%'; -- 8

select count(*)
from restaurant
where cuisine like '%, italian%' or cuisine like 'italian%'; -- 263

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%, italian%' or cuisine like 'italian%'; -- 3.04

-- breakfast
select count(*)
from closed_restaurant
where cuisine like '%, breakfast%' or cuisine like 'breakfast%'; -- 14

select count(*)
from restaurant
where cuisine like '%, breakfast%' or cuisine like 'breakfast%'; -- 301

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%, breakfast%' or cuisine like 'breakfast%'; -- 4.65

-- bars (any bars, not just sports bars or dive bars)
select count(*)
from closed_restaurant
where cuisine like '%, bars%' or cuisine like '% bars%' or cuisine like 'bars%'; -- 29

select count(*)
from restaurant
where cuisine like '%, bars%' or cuisine like '% bars%' or cuisine like 'bars%'; -- 750

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%, bars%' or cuisine like '% bars%' or cuisine like 'bars%'; -- 3.87

-- mexican cuisine
select count(*)
from closed_restaurant
where cuisine like '%, mexican%' or cuisine like 'mexican%'; -- 1

select count(*)
from restaurant
where cuisine like '%, mexican%' or cuisine like 'mexican%'; -- 171

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%, mexican%' or cuisine like 'mexican%'; -- .58

-- food trucks
select count(*)
from closed_restaurant
where cuisine like '%food trucks%'; -- 0

select count(*)
from restaurant
where cuisine like '%food trucks%'; -- 62

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%food trucks%'; -- 0

-- coffee and tea
select count(*)
from closed_restaurant
where cuisine like '%coffee & tea%'; -- 8

select count(*)
from restaurant
where cuisine like '%coffee & tea%'; -- 632

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%coffee & tea%'; -- 1.27

-- japanese
select count(*)
from closed_restaurant
where cuisine like '%japanese%'; -- 4

select count(*)
from restaurant
where cuisine like '%japanese%'; -- 108

select round((sum(is_closed) / count(*)) * 100, 2)
from restaurant
where cuisine like '%japanese%'; -- 3.70

-- How many closed restaurants are in the same zip codes as colleges/universities 

select * from closed_restaurant;
select * from zip_codes;

select zip_code 
from closed_restaurant;
-- where zip_code in (
-- 	select Zipcode
--     from colleges_and_universities);

select address
from colleges_and_universities
where address like ', street,  %0%';

-- average rating per cuisine 



-- shows the difference in property costs, and therefore, the rent costs of different regions in boston
create view downtown_property as
select zip_code, round(avg(value)) as 'average_property_value'
from property_assessment
where zip_code in ('02108', '02109', '02110', '02210', '02114', '02113', '02116', '02118')
group by zip_code
order by average_property_value desc;

create view non_downtown_property as
select zip_code, round(avg(value)) as 'average_property_value'
from property_assessment
where zip_code in ('02115', '02129', '02128')
group by zip_code
order by average_property_value desc;

select round(avg(average_property_value)) as 'average_value'
from downtown_property;

select round(avg(average_property_value)) as 'average_value'
from non_downtown_property;


-- which zip code had the highest number of restaurants closed (number of closed restauraunts per zip code)
select * from restaurant;
select * from zip_code;

select zip_code, count(zip_code) as 'num_closed'
from closed_restaurant
group by zip_code
order by num_closed desc
limit 3;

-- average property value for zipcodes with highest closed restaurants rate (2nd and 3rd highest)
-- 8 restaurants closed
select round(avg(average_property_value)) as 'average_value'
from downtown_property;
-- 7 restaurants closed
select round(avg(average_property_value)) as 'average_value'
from non_downtown_property;

select * from colleges_and_universities;
select * from closed_business_data_reviews;
select * from restaurant;
select * from zip_code;
select * from property_assessment;

-- restaurants that closed that did only delivery 
select restaurant_id, zip_code, cuisine
from closed_restaurant
where transactions like '%delivery' 
and transactions not like '%delivery,pickup'
and transactions not like '%pickup, delivery';

-- restaurants that stayed open that only did delivery
select restaurant_name, zip_code, cuisine
from restaurant
where transactions like '%delivery' 
and transactions not like '%delivery,pickup'
and transactions not like '%pickup, delivery'
and is_closed != 1;


-- restaurants that stayed open but did not offer delivery/pickup

update restaurant 
set transactions = null 
where transactions = '';

select is_closed, restaurant_name, zip_code, cuisine
from restaurant
where transactions is null;
