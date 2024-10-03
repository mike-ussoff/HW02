drop table if exists harvesting_fruits;
create temporary table harvesting_fruits (
     company_id integer
    ,apple integer
    ,grape integer
    ,"year" integer
);

drop table if exists company;
create temporary table company(
     "id" integer constraint IX_company_id primary key
    ,"name" varchar(45)
);

insert into harvesting_fruits values
 (1, 1000, 2000, 2015)
,(1, 5000, 3000, 2016)
,(1, 5000, 3000, 2017)
,(1, 5000, 3000, 2018)
,(2, 9995, 8880, 2015)
,(2, 9990, 8880, 2016)
,(2, 9990, 6660, 2017)
,(2, 9990, 5550, 2018)
,(3, 3995, 3880, 2015)
,(3, 3990, 4880, 2016)
,(3, 3990, 5660, 2017)
,(3, 3990, 6550, 2018);

insert into company values
 (1, 'FGS')
,(2, 'Village')
,(3, 'Best Fruit');


select * from  harvesting_fruits f
inner join company c on c.id = f.company_id;

select c."name", fruits_by_year.* 
from  harvesting_fruits f
inner join company c on c.id = f.company_id
cross join lateral (values (concat('APPLES - ', "year"), apple),
                           (concat('GRAPES - ', "year"), grape)
                   ) fruits_by_year (fruit_year, amont);

select * from crosstab
(
$$
select c."name", fruits_by_year.fruit_year, max(fruits_by_year.amont) as amount
from  harvesting_fruits f
inner join company c on c.id = f.company_id
cross join lateral (values (concat('APPLES - ', "year"), apple),
                           (concat('GRAPES - ', "year"), grape)
                   ) fruits_by_year (fruit_year, amont)
where f.year >= 2015 and f.year <= 2017
group by c."name", fruits_by_year.fruit_year
order by 1,2;
$$
)
as ct("NAME" varchar(45), "APPLES - 2015" int, "APPLES - 2016" int, "APPLES - 2017" int,
"GRAPES - 2015" int, "GRAPES - 2016" int, "GRAPES - 2017" int);


















