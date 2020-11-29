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

-- any cuisines
select cuisine, count(cuisine)
from restaurant
group by cuisine;

-- create table for number of closed restaurants by cuisine
create table cuisine_num_closed (
	cuisine varchar(50) primary key,
	num_closed int,
    total int
);

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

insert into cuisine_num_closed values ('American', (
	select count(*)
	from closed_restaurant
	where cuisine like '%, american%' or cuisine like 'american%'), (
    select count(*)
	from restaurant
	where cuisine like '%, american%' or cuisine like 'american%'));
    

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

insert into cuisine_num_closed values ('Italian', (
	select count(*)
	from closed_restaurant
	where cuisine like '%, italian%' or cuisine like 'italian%'), (
    select count(*)
	from restaurant
	where cuisine like '%, italian%' or cuisine like 'italian%'));


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

insert into cuisine_num_closed values ('Breakfast', (
	select count(*)
	from closed_restaurant
	where cuisine like '%, breakfast%' or cuisine like 'breakfast%'), (
    select count(*)
	from restaurant
	where cuisine like '%, breakfast%' or cuisine like 'breakfast%'));

-- bars (any bars, not just sports bars or dive bars)
select count(*)
from closed_restaurant
where cuisine like '%cocktail bars%' or
cuisine like '%wine bars%' or
cuisine like '%sports bars%' or
cuisine like '%dive bars%' or
cuisine like '%tiki bars%' or
cuisine like '%beer bar%' or
cuisine like '%pubs%' or
cuisine like '%bars%'; -- 39

select count(*)
from restaurant
where cuisine like '%cocktail bars%' or
cuisine like '%wine bars%' or
cuisine like '%sports bars%' or
cuisine like '%dive bars%' or
cuisine like '%tiki bars%' or
cuisine like '%beer bar%' or
cuisine like '%pubs%' or
cuisine like '%bars%'; -- 838

insert into cuisine_num_closed values ('Bars', (
	select count(*)
	from closed_restaurant
	where cuisine like '%, bars%' or cuisine like '% bars%' or cuisine like 'bars%'), (
    select count(*)
	from restaurant
	where cuisine like '%, bars%' or cuisine like '% bars%' or cuisine like 'bars%'));

update cuisine_num_closed
set num_closed = (
	select count(*)
	from closed_restaurant
	where cuisine like '%cocktail bars%' or
	cuisine like '%wine bars%' or
	cuisine like '%sports bars%' or
	cuisine like '%dive bars%' or
	cuisine like '%tiki bars%' or
	cuisine like '%beer bar%' or
	cuisine like '%pubs%' or
	cuisine like '%bars%'),
total = (
	select count(*)
	from restaurant
	where cuisine like '%cocktail bars%' or
	cuisine like '%wine bars%' or
	cuisine like '%sports bars%' or
	cuisine like '%dive bars%' or
	cuisine like '%tiki bars%' or
	cuisine like '%beer bar%' or
	cuisine like '%pubs%' or
	cuisine like '%bars%')
where cuisine = "Bars";

select * from cuisine_num_closed;

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

insert into cuisine_num_closed values ('Mexican', (
	select count(*)
	from closed_restaurant
	where cuisine like '%, mexican%' or cuisine like 'mexican%'), (
    select count(*)
	from restaurant
	where cuisine like '%, mexican%' or cuisine like 'mexican%'));

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

insert into cuisine_num_closed values ('Food Trucks', (
	select count(*)
	from closed_restaurant
	where cuisine like '%food trucks%'), (
    select count(*)
	from restaurant
	where cuisine like '%food trucks%'));

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

insert into cuisine_num_closed values ('Coffee & Tea', (
	select count(*)
	from closed_restaurant
	where cuisine like '%coffee & tea%'), (
    select count(*)
	from restaurant
	where cuisine like '%coffee & tea%'));
    
select * from cuisine_num_closed;

-- japanese
select count(*)
from closed_restaurant
where cuisine like '%japanese%' or
cuisine like '%ramen%' or
cuisine like '%sushi%'; -- 4

select count(*)
from restaurant
where cuisine like '%japanese%' or
cuisine like '%ramen%' or
cuisine like '%sushi%'; -- 182

insert into cuisine_num_closed values ('Japanese', (
	select count(*)
	from closed_restaurant
	where cuisine like '%japanese%' or
	cuisine like '%ramen%' or
	cuisine like '%sushi%'), (
    select count(*)
	from restaurant
    where cuisine like '%japanese%' or
	cuisine like '%ramen%' or
	cuisine like '%sushi%'));

-- more cuisines

insert into cuisine_num_closed values ('French', (
	select count(*)
	from closed_restaurant
	where cuisine like '%french%'), (
    select count(*)
	from restaurant
	where cuisine like '%french%'));
    
insert into cuisine_num_closed values ('Ice Cream', (
	select count(*)
	from closed_restaurant
	where cuisine like '%ice cream%'), (
    select count(*)
	from restaurant
	where cuisine like '%ice cream%'));
    
insert into cuisine_num_closed values ('Korean', (
	select count(*)
	from closed_restaurant
	where cuisine like '%korean%'), (
    select count(*)
	from restaurant
	where cuisine like '%korean%'));
    
insert into cuisine_num_closed values ('Thai', (
	select count(*)
	from closed_restaurant
	where cuisine like '%thai%'), (
    select count(*)
	from restaurant
	where cuisine like '%thai%'));
    
insert into cuisine_num_closed values ('Vietnamese', (
	select count(*)
	from closed_restaurant
	where cuisine like '%vietnamese%'), (
    select count(*)
	from restaurant
	where cuisine like '%vietnamese%'));
    
insert into cuisine_num_closed values ('Spanish', (
	select count(*)
	from closed_restaurant
	where cuisine like '%spanish%'), (
    select count(*)
	from restaurant
	where cuisine like '%spanish%'));

select count(*)
	from restaurant
	where cuisine like '%Mediterranean%';

insert into cuisine_num_closed values ('Mediterranean', (
	select count(*)
	from closed_restaurant
	where cuisine like '%mediterranean%'), (
    select count(*)
	from restaurant
	where cuisine like '%mediterranean%'));
    
insert into cuisine_num_closed values ('Sandwiches', (
	select count(*)
	from closed_restaurant
	where cuisine like '%sandwiches%'), (
    select count(*)
	from restaurant
	where cuisine like '%sandwiches%'));
    
insert into cuisine_num_closed values ('Tapas', (
	select count(*)
	from closed_restaurant
	where cuisine like '%tapas%'), (
    select count(*)
	from restaurant
	where cuisine like '%tapas%'));
    
insert into cuisine_num_closed values ('Irish', (
	select count(*)
	from closed_restaurant
	where cuisine like '%irish%'), (
    select count(*)
	from restaurant
	where cuisine like '%irish%'));
    
insert into cuisine_num_closed values ('Middle Eastern', (
	select count(*)
	from closed_restaurant
	where cuisine like '%middle eastern%'), (
    select count(*)
	from restaurant
	where cuisine like '%middle eastern%'));
    
insert into cuisine_num_closed values ('Chinese', (
	select count(*)
	from closed_restaurant
	where cuisine like '%chinese%'), (
    select count(*)
	from restaurant
	where cuisine like '%chinese%'));
    
insert into cuisine_num_closed values ('Latin American', (
	select count(*)
	from closed_restaurant
	where cuisine like '%latin american%'), (
    select count(*)
	from restaurant
	where cuisine like '%latin american%'));
    
insert into cuisine_num_closed values ('Juice Bar', (
	select count(*)
	from closed_restaurant
	where cuisine like '%juice bar%'), (
    select count(*)
	from restaurant
	where cuisine like '%juice bar%'));
    
select * from restaurant where cuisine like '%ramen%';
select * from closed_restaurant where cuisine like '%sushi bar%';
    
select * from cuisine_num_closed;

-- create view for percentages
create or replace view cuisine_pct_closed as
select cuisine, round((num_closed/total * 100), 2) as pct_closed
from cuisine_num_closed;

select * from cuisine_pct_closed;
select * from cuisine_pct_closed order by pct_closed desc;

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




-- what percentage of each cuisine was closed post-covid 
-- which cuisine type had the highest percentage of closed restaurants
-- average rent price for zipcodes with highest closed restaurants rate 
-- which zip code had the highest number of restaurants closed (number of closed restauraunts per zip code)
-- 


