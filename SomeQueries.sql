-- Highest Rental state
Select 
rental_market_dim.city,
round(avg(rental_market_dim.property_rent)) 
FROM rental_market_dim
GROUP BY city
ORDER BY round(avg(rental_market_dim.property_rent)) DESC;
-------------------------------------------------------------------------------------------

--Add Coulmn
update rental_market_dim
SET monthly_rent = rental_market_dim.property_rent /12;
-------------------------------------------------------------------------------------------

--Property Type Count
SELECT
property_type,
Count(*)
From rental_market_dim
GROUP BY property_type
ORDER BY Count(*) DESC;
-------------------------------------------------------------------------------------------

--Average Sqft For Every Property
SELECT 
property_type,
Round(Avg(property_area_in_sqft)) AS Average_Area
From rental_market_dim
GROUP BY property_type
ORDER BY Average_Area DESC;
-------------------------------------------------------------------------------------------

--Highest Property Type
SELECt 
property_type,
Round(Avg(property_rent)) 
FROM rental_market_dim 
Group By property_type
ORDER BY Round(Avg(property_rent)) DESC;
-------------------------------------------------------------------------------------------

--Growth in Average Rent in From 2023 To 2024
With Average_Rent2024 AS
(
    Select 
    city,
    Round(Avg(property_rent)) As Avg2024
    From rental_market_dim
    Where year = 2024
    GROUP BY City
), Average_Rent2023 AS
(
    Select 
    city,
    Round(Avg(property_rent)) as Avg2023
    From rental_market_dim
    Where year = 2023
    GROUP BY City
)
SELECT
Average_Rent2024.city,
Average_Rent2024.Avg2024-Average_Rent2023.Avg2023 As Growth_in_Average
FROM Average_Rent2024
INNER JOIN Average_Rent2023 on Average_Rent2023.city = Average_Rent2024.city
ORDER BY Growth_in_Average DESC;
---------------------------------------------------------------------------------------

--Highest Locations By Every Emirate
With Base_Table AS 
(
    SELECT 
    Location,
    city,
    Round(Avg(property_rent)) AS AverageRent 
    From rental_market_dim
    Group BY location,City
    ORDER BY City , AverageRent DESC
), SecondTable AS
(
    SELECT 
    city,
    Max(AverageRent) AS Maxi
    From Base_Table
    GROUP BY city
)
Select
b.Location,
b.city,
b.AverageRent
From Base_Table b
INNER JOIN SecondTable ON Maxi = AverageRent
ORDER BY AverageRent DESC;
---------------------------------------------------------------------------------------