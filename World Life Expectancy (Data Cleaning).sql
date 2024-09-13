# World Life Expectancy Project (Data Cleaning)
SELECT * 
from World_Life_Expectancy
;
-- 1) REMOVEING DUPLICATES.
-- Looking for duplicate data in our dataset
SELECT country, Year, concat(Country, Year), count(concat(Country, Year)) as existence_count
from World_Life_Expectancy
group by country, Year, concat(Country, Year)
Having existence_count > 1
;

-- Looking for duplicates using window fucntions 
select Row_ID,
concat(Country, Year),
Row_Number() over (partition by concat(Country, Year) order by concat(Country, Year)) AS Row_Num
from World_Life_Expectancy
;

-- Using the above query to filter out the duplicates
select * 
from (
	select Row_ID,
	concat(Country, Year),
	Row_Number() over (partition by concat(Country, Year) order by concat(Country, Year)) AS Row_Num
	from World_Life_Expectancy
	) as Row_table
where row_num > 1
; 

-- In response of the above input we see 3 rows with Row_Num as 2 indicating that they are the duplicates and are to be deleted from the database.
-- Making sure to keep a backup copy of the table before making any changes to the original table.
-- Deleting the duplicates

Delete from world_life_expectancy
where 
	Row_ID in (
		select Row_ID 
		from (
			select Row_ID,
			concat(Country, Year),
			Row_Number() over (partition by concat(Country, Year) order by concat(Country, Year)) AS Row_Num
			from World_Life_Expectancy
			) as Row_table
		where row_num > 1)
;
 -- Now when we check the output we see that it the response says '3 row(s) affected' which indicates that the 3 duplications are 
 -- deleted from the database.
 
 
 -- 2) STANDARDIZING DATA
 
-- looking for the records which have the status column as blank
SELECT *
from World_Life_Expectancy
where status = ''
;
-- the output table shows us that there are 8 rows which have status as blank 

-- Figuring out the possible inputs in the Status column in the data 
SELECT DISTINCT(Status)
from World_Life_Expectancy
where status != ''
;

 
-- looking for the developing countries
SELECT DISTINCT(Country)
from World_Life_Expectancy
where status = 'Developing'
;
 
-- updating the data to set status of developing countries if they have a blank status column from the record
update world_life_expectancy t1
join world_life_expectancy t2 
on t1.country = t2.country
set t1.Status = 'Developing'
where t1.status = '' and t2.status != '' and t2.status = 'Developing'
;

-- we can see the response throwing out 7 row(s) affected which means that 7 blank rows were updated with the status Developing

-- Repeat the same process with countries whicc have a status as 'Developed' 

 -- looking for the developed countries
SELECT DISTINCT(Country)
from World_Life_Expectancy
where status = 'Developed'
;
 
-- updating the data to set status of developed countries if they have a blank status column from the record
update world_life_expectancy t1
join world_life_expectancy t2 
on t1.country = t2.country
set t1.Status = 'Developed'
where t1.status = '' and t2.status != '' and t2.status = 'Developed'
;

-- we can see the response throwing out 1 row(s) affected which means that 1 blank rows were updated with the status 'Developed'.
 
-- Checking if there are any records left with their status fiedl as blank.
SELECT *
from World_Life_Expectancy
where status = ''
;


SELECT *
from World_Life_Expectancy
;
--  Now we can see in the data that the column life eexpectancy has some blank columns as well
SELECT *
from World_Life_Expectancy
where Lifeexpectancy = ''
;

-- We can notice a pattern in the countries that developing countires' life expectancy increases every year.

-- separating the blanks rows of Lifeexpectancy
SELECT Country, year, Lifeexpectancy
from World_Life_Expectancy
where Lifeexpectancy = ''
;

-- Using self joins we can align the previous and next year's lifeexpectancy in a row and then 
-- calculate the average of the two for the value of the blank life expectancy field.
SELECT t1.Country, t1.year, t1.Lifeexpectancy,
t2.Country, t2.year, t2.Lifeexpectancy,
t3.Country, t3.year, t3.Lifeexpectancy,
ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1) as estimated_current_Lifeexpectancy
from World_Life_Expectancy t1
join World_Life_Expectancy t2 
 on t1.country = t2.country 
 and t1.year = t2.year - 1
join World_Life_Expectancy t3
 on t1.country = t3.country 
 and t1.year = t3.year + 1
where t1.Lifeexpectancy = ''
;

 --  use the above query to update the originla table 
update World_Life_Expectancy t1
join World_Life_Expectancy t2 
 on t1.country = t2.country 
 and t1.year = t2.year - 1
join World_Life_Expectancy t3
 on t1.country = t3.country 
 and t1.year = t3.year + 1
set t1.lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1) 
where t1.Lifeexpectancy = ''
;

--  response said that 2 row(s) were affected which means the fields have been updated 

-- checking if the query has any blank fields left.
SELECT *
from World_Life_Expectancy
where Lifeexpectancy = ''
;
 
 
 
 
 




