# SQL_Coding_Challange_BrainTree

This repository contains a set of SQL queries and tasks that pertain to data analysis and manipulation. It uses a comprehensive combination of both basics and advance queries. Below is a brief description of each task and the SQL queries used to accomplish them. The questions was asked in on of the Paypal take home assessment for the role of Data Analyst.
Thanks to Nick Singh from DataLemur for providing the reference. 

I used Google Big Query for my analysis. I have attached the data files and output. Result is not validated with the origianl solution.

## 1. Data Integrity Checking & Cleanup

**Task:** Alphabetically list all of the country codes in the `continent_map` table that appear more than once. Display any values where `country_code` is null as `country_code = "FOO"` and make this row appear first in the list. For all countries that have multiple rows in the `continent_map` table, delete all multiple records, leaving only one record per country. The record that you keep should be the first one when sorted by the `continent_code` alphabetically ascending.

- **Query:** A SQL query was used to identify duplicate `country_code` values and clean up the data. Specific SQL statements were used to remove redundant records.

## 2. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.

**Task:** List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012. The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp). The list includes the columns `rank`, `continent_name`, `country_code`, `country_name`, and `growth_percent`.

- **Query:** A SQL query was used to calculate and rank the year-over-year growth in GDP, and the result was filtered to include the top 10-12 countries in each continent.

## 3. Report on the Percent Share of GDP per Capita for 2012

**Task:** For the year 2012, create a 3-column, 1-row report showing the percent share of `gdp_per_capita` for the following regions: (i) Asia, (ii) Europe, (iii) the Rest of the World.

- **Query:** A SQL query was used to calculate the percent share of `gdp_per_capita` for Asia, Europe, and the Rest of the World for the year 2012.

## 4a. and 4b. Count of Countries with GDP per Capita in 2007

**Task 4a:** Find the count of countries and sum of their related `gdp_per_capita` values for the year 2007 where the string 'an' (case-insensitive) appears anywhere in the country name.

**Task 4b:** Repeat Task 4a, but this time make the query case-sensitive.

- **Queries:** SQL queries were used to count the number of countries and calculate the sum of `gdp_per_capita` values for the year 2007, considering both case-insensitive and case-sensitive criteria for the country name.

## 5. Sum of GDP per Capita by Year and Count of Countries

**Task:** Find the sum of `gdp_per_capita` by year and the count of countries for each year that have non-null `gdp_per_capita` where (i) the year is before 2012 and (ii) the country has a null `gdp_per_capita` in 2012. The result includes the columns `year`, `country_count`, and `total`.

- **Query:** A SQL query was used to calculate the sum of `gdp_per_capita` and count the countries for each year before 2012 while considering the specified conditions.

## 6. Multi-Step Query

**Task 6a:** Create a single list of all `per_capita` records for the year 2009 with specific columns.

**Task 6b:** Order this list by `continent_name` in ascending order and characters 2 through 4 (inclusive) of the `country_name` in descending order.

**Task 6c:** Create a running total of `gdp_per_capita` by `continent_name`.

**Task 6d:** Return only the first record from the ordered list for which each continent's running total of `gdp_per_capita` meets or exceeds $70,000.00. The result includes the columns `continent_name`, `country_code`, `country_name`, `gdp_per_capita`, and `running_total`.

- **Queries:** A sequence of SQL queries was used to perform the multi-step task that includes data selection, ordering, running total calculation, and filtering based on a running total threshold.

## 7. Find the Country with the Highest Average GDP per Capita by Continent

**Task:** Find the country with the highest average `gdp_per_capita` for each continent across all years.

- **Query:** A SQL query was used to calculate the average `gdp_per_capita` for each country within its continent and to identify the country with the highest average `gdp_per_capita` for each continent.

## Data Validation

The final task involved comparing the result to a provided

 dataset and describing any discrepancies. SQL code and analysis were used to identify and document any mistakes in the provided dataset.

Each task's query and explanation are included in this repository to provide a comprehensive solution to the BrainTree SQL coding challenge.
