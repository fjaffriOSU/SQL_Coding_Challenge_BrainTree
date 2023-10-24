/*
1. Data Integrity Checking & Cleanup
Alphabetically list all of the country codes in the continent_map table that appear more than once. Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list, even though it should alphabetically sort to the middle. Provide the results of this query as your answer.*/

with HandleNullValue as (
SELECT 
  Coalesce(country_code,'FOO') as country_code
FROM `sentiment-analysis-101-379822.Paypal_assignment.continent_map`
GROUP BY
  country_code
HAVING
  count(country_code) > 1
)
,
MakeFooAtTop as 
(
select
  country_code,
  case when country_code = 'FOO' then 2 else 1 end as order_cnt
from
  HandleNullValue
)
select 
  country_code
FROM
  MakeFooAtTop
order by
  order_cnt DESC

  /*For all countries that have multiple rows in the continent_map table, delete all multiple records leaving only the 1 record per country. The record that you keep should be the first one when sorted by the continent_code alphabetically ascending. Provide the query/ies and explanation of step(s) that you follow to delete these records..*/

CREATE OR REPLACE TABLE `` AS
WITH Ranked_Countries AS (
  SELECT
    country_code,
    continent_code,
    ROW_NUMBER() OVER (PARTITION BY country_code ORDER BY continent_code) AS row_num
  FROM `sentiment-analysis-101-379822.Paypal_assignment.continent_map`
)
SELECT
  country_code,
  continent_code
FROM Ranked_Countries
WHERE row_num = 1;



/*2. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)
The list should include the columns:
rank
continent_name
country_code
country_name
growth_percent
*/

With Growth_Percent_cte as 
(
select
  country_code,
  Round((sum(case when year = 2012 then gdp_per_capita end)-sum(case when year = 2011 then gdp_per_capita end))/sum(case when year = 2011 then gdp_per_capita end)*100.0,2) as growth_percent
from
  `sentiment-analysis-101-379822.Paypal_assignment.per_capita` pc
group by
  country_code
)
,
Ranked_by_GP_cte as 
(SELECT
  continent_code,
  Growth_Percent_cte.*,
  Rank() over(PARTITION BY continent_code order by growth_percent DESC) as rank_by_growth_percent
from
  Growth_Percent_cte
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.continent_map` cntm
on Growth_Percent_cte.country_code = cntm.country_code
where 
  growth_percent is not null
order by
continent_code
)
select
  rank_by_growth_percent as rank,
  cnt.continent_name,
  Ranked_by_GP_cte.country_code,
  c.country_name,
  growth_percent
from
  Ranked_by_GP_cte
inner join 
  `sentiment-analysis-101-379822.Paypal_assignment.continent` cnt
on 
  Ranked_by_GP_cte.continent_code = cnt.continent_code
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.countries` c
on 
  Ranked_by_GP_cte.country_code = c.country_code
where
  rank_by_growth_percent between 10 and 12
order by
  continent_name


/*
3. For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:
(i) Asia, (ii) Europe, (iii) the Rest of the World. Your result should look something like
Asia  Europe  Rest of World
25.0% 25.0% 50.0%
*/
with overall_gdp_contitnent_wise as
(
SELECT
  cont.continent_name,
  sum(gdp_per_capita) as sum_gdp_per_capita

FROM
    `sentiment-analysis-101-379822.Paypal_assignment.per_capita` pc
inner join
    `sentiment-analysis-101-379822.Paypal_assignment.continent_map` cmap
on 
  pc.country_code = cmap.country_code
inner join
   `sentiment-analysis-101-379822.Paypal_assignment.continent` cont
on
  cmap.continent_code = cont.continent_code
where
  year = 2012
group by
  cont.continent_name
)
,
total_cte as
(
  select sum(sum_gdp_per_capita) as total_gdp from overall_gdp_contitnent_wise
)

SELECT
  Concat(Round(Sum(case when continent_name='Asia' then sum_gdp_per_capita end)*100.0/ (select total_gdp from total_cte),2),'%') as Asia,
  Concat(Round(Sum(case when continent_name='Europe' then sum_gdp_per_capita end)*100.0/ (select total_gdp from total_cte),2),'%' )as Europe,
  Concat(Round(Sum(case when continent_name not in ('Asia', 'Europe') then sum_gdp_per_capita end)*100.0/ (select total_gdp from total_cte),2),'%') as Rest_of_world,
  
from
  overall_gdp_contitnent_wise
/*
4a. What is the count of countries and sum of their related gdp_per_capita values for the year 2007 where the string 'an' (case insensitive) appears anywhere in the country name?

4b. Repeat question 4a, but this time make the query case sensitive.
*/


SELECT
  count(*) as number_of_countries,
  Concat(Round(sum(gdp_per_capita),2),'$') as total_gdp
FROM 
    `sentiment-analysis-101-379822.Paypal_assignment.countries` c
inner join
     
    `sentiment-analysis-101-379822.Paypal_assignment.per_capita` pc
on   c.country_code  = pc.country_code
WHERE 
    year = 2007
and
  lower(country_name) like '%an%'

  SELECT
  count(*) as number_of_countries,
  Concat(Round(sum(gdp_per_capita),2),'$') as total_gdp
FROM 
    `sentiment-analysis-101-379822.Paypal_assignment.countries` c
inner join
     
    `sentiment-analysis-101-379822.Paypal_assignment.per_capita` pc
on   c.country_code  = pc.country_code
WHERE 
    year = 2007
and
  country_name like '%an%'



/*
5. Find the sum of gpd_per_capita by year and the count of countries for each year 
that have non-null gdp_per_capita where 
(i) the year is before 2012 and 
(ii) the country has a null gdp_per_capita in 2012. Your result should have the columns:
year
country_count
total*/

with cte_before_2012 as
(
select
  year, 
  country_code,
  gdp_per_capita
from 
  `sentiment-analysis-101-379822.Paypal_assignment.per_capita`
where 
  year < 2012
and
  gdp_per_capita is not null

)
,
cte_country_with_null_in_2012 as 
(
  select
  country_code
from 
  `sentiment-analysis-101-379822.Paypal_assignment.per_capita`
where 
  year = 2012
and
  gdp_per_capita is null
)

select
  year,
  count(cte_before_2012.country_code) as country_count,
  Concat('$',Round(sum(gdp_per_capita),2)) as total 
from
  cte_before_2012
inner join
  cte_country_with_null_in_2012
on 
  cte_before_2012.country_code = cte_country_with_null_in_2012.country_code
group by year



/*
6 a-d
*/
With list_per_capita as 
(
SELECT
  cont.continent_name,
  pc.country_code,
  cntr.country_name,
  pc.gdp_per_capita
FROM 
  `sentiment-analysis-101-379822.Paypal_assignment.per_capita` pc
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.countries` cntr
on  
  cntr.country_code  = pc.country_code
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.continent_map` cmap
on
  cmap.country_code =  pc.country_code
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.continent` cont
on
  cont.continent_code = cmap.continent_code
where 
  year = 2009
order by
  cont.continent_name, 
  substr(cntr.country_name, 2, 5)
),
per_capita_running_total as 
(
select 
  list_per_capita.*,
  Sum(gdp_per_capita) over (PARTITION BY continent_name order by country_name) as running_gdp_total,
from
  list_per_capita
)
,
ranked_per_capita_running_total as
(
SELECT
  per_capita_running_total.*,
  RANK() over (partition by continent_name order by running_gdp_total) as ranked_running_total
from 
  per_capita_running_total
where 
  running_gdp_total > 70000
)

select
  continent_name,
  country_code,
  country_name,
  Concat('$',Round(gdp_per_capita,2)) as gdp_per_capita,
  Concat('$',Round(running_gdp_total,2)) as running_total
from
  ranked_per_capita_running_total
where
  ranked_running_total = 1
order by
  continent_name

/*
7. Find the country with the highest average gdp_per_capita for each continent for all years.
*/
with cte_avg_per_capita_allyears as 
(
SELECT
  country_code,
  Round(avg(gdp_per_capita),2) as avg_gdp_per_capita
FROM
  `sentiment-analysis-101-379822.Paypal_assignment.per_capita`  
where
  gdp_per_capita is not null
group by
  country_code
),
ranked_nations_gdp as
(
select
  RANK() over(partition by cont.continent_name order by cte_avg.avg_gdp_per_capita DESC) as rank,
  cont.continent_name,
  cte_avg.country_code,
  cntr.country_name,
  concat('$',cte_avg.avg_gdp_per_capita) as avg_gdp_per_capita,
  

FROM
  cte_avg_per_capita_allyears cte_avg
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.countries` cntr
on  
  cntr.country_code  = cte_avg.country_code
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.continent_map` cmap
on
  cmap.country_code =  cte_avg.country_code
inner join
  `sentiment-analysis-101-379822.Paypal_assignment.continent` cont
on
  cont.continent_code = cmap.continent_code
)

select  
  *
from
  ranked_nations_gdp
where
  rank = 1
order by
  continent_name









