# 🌍 World Life Expectancy Project (Data Cleaning)

This project involves cleaning and standardizing the World Life Expectancy dataset using MySQL. The process includes removing duplicates, standardizing data entries, and handling missing values in key columns like Status and Lifeexpectancy.

<h3>📁 Project Structure</h3>

	•	World_Life_Expectancy.csv: The raw dataset containing life expectancy data.
	•	SQL Queries.sql: SQL scripts used for data cleaning and standardization.

<h3>🗂️ Database Setup</h3>

1.	Create Database & Table:
```
     CREATE DATABASE WorldLifeDB;
     USE WorldLifeDB;
```
2.	Import Data: <br>

Load the CSV file into a table named World_Life_Expectancy.

<h3>🚀 Data Cleaning Process</h3>

<h4>1️⃣ Removing Duplicates</h4>

•	Check for Duplicates:
```
    SELECT country, Year, COUNT(*) AS existence_count
    FROM World_Life_Expectancy
    GROUP BY country, Year
    HAVING existence_count > 1;
```


•	Delete Duplicates:
```
    DELETE FROM World_Life_Expectancy
    WHERE Row_ID IN (
      SELECT Row_ID
      FROM (
        SELECT Row_ID, ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY Row_ID) AS Row_Num
        FROM World_Life_Expectancy
      ) AS Row_table
      WHERE Row_Num > 1
    );
```

<h4>2️⃣ Standardizing the Status Column</h4>

•	Identify Missing Status Entries:
```
    SELECT * FROM World_Life_Expectancy WHERE status = '';
```

•	Update Missing Developing Countries:
```
    UPDATE World_Life_Expectancy t1
    JOIN World_Life_Expectancy t2 ON t1.country = t2.country
    SET t1.Status = 'Developing'
    WHERE t1.status = '' AND t2.status = 'Developing';
```

•	Update Missing Developed Countries:
```
    UPDATE World_Life_Expectancy t1
    JOIN World_Life_Expectancy t2 ON t1.country = t2.country
    SET t1.Status = 'Developed'
    WHERE t1.status = '' AND t2.status = 'Developed';
```

<h4>3️⃣ Handling Missing Life expectancy</h4>

•	Check for Missing Values:

```
    SELECT * FROM World_Life_Expectancy WHERE Lifeexpectancy = '';
```

•	Estimate Missing Values:
```
UPDATE World_Life_Expectancy t1
JOIN World_Life_Expectancy t2 ON t1.country = t2.country AND t1.year = t2.year - 1
JOIN World_Life_Expectancy t3 ON t1.country = t3.country AND t1.year = t3.year + 1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy) / 2, 1)
WHERE t1.Lifeexpectancy = '';
```

<h3>🧾 Conclusion</h3>

The data cleaning process ensured a clean, reliable dataset by removing duplicates, standardizing entries, and filling missing values. This improved data consistency, making the dataset suitable for advanced analytics and machine learning tasks.








