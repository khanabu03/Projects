select *
From road_accident
--
Select sum(number_of_casualties) AS CY_Casualties
From road_accident
Where YEAR(accident_date) = '2022'
--
Select COUNT(distinct accident_index) AS CY_Accidents
From road_accident
Where YEAR(accident_date) = '2022'
--
Select SUM(number_of_casualties) AS Fatal_Accidents
from road_accident
Where accident_severity = 'Fatal'
--
Select SUM(number_of_casualties) AS Fatal_Accidents
from road_accident
Where accident_severity = 'Serious'
--
Select SUM(number_of_casualties) AS Fatal_Accidents
from road_accident
Where accident_severity = 'Slight'
--
Select cast(SUM(number_of_casualties) AS Decimal(10,2)) * 100/ (Select Cast(sum(number_of_casualties) AS decimal(10,2)) 
From road_accident) AS PCT
from road_accident
Where accident_severity = 'Slight'
-- For finding out percentages, cast and divide then multiply
Select
case 
   when vehicle_type IN ('Agricultural vehicle') Then 'Agricultural' 
   when vehicle_type IN ('Car' , 'Taxi/Private hire car') Then 'Cars'
   when vehicle_type IN ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 500cc', 'Pedal cycle') Then 'Bike'
   when vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus(8 to 16 passenger seats)') Then 'Bus'
   when vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') Then 'Van'
   Else 'Other'
   End AS vehicle_group,
   SUM(number_of_casualties) as CY_Casualties
   From road_accident
   Where Year(accident_date) = '2022'
   Group By 
   case 
   when vehicle_type IN ('Agricultural vehicle') Then 'Agricultural'
      when vehicle_type IN ('Car' , 'Taxi/Private hire car') Then 'Cars'
   when vehicle_type IN ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 500cc', 'Pedal cycle') Then 'Bike'
   when vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus(8 to 16 passenger seats)') Then 'Bus'
   when vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') Then 'Van'
   Else 'Other'
   End
-- Grouping using 'case' for CY Casualties
Select DATENAME(Month, accident_date) AS Month_Name, SUM(number_of_casualties) AS CY_Casualties
From road_accident
Where YEAR(accident_date) = '2022'
Group By DATENAME(Month, accident_date) 
--
Select road_type, SUM(number_of_casualties)
From road_accident
Where YEAR(accident_date) = '2022'
Group By road_type 
--
Select urban_or_rural_area, SUM(number_of_casualties)
from road_accident
Where YEAR(accident_date) = '2022'
Group By urban_or_rural_area 
--
Select urban_or_rural_area, Cast(SUM(number_of_casualties) AS decimal(10,2)) * 100 / 
(Select Cast(SUM(number_of_casualties) AS decimal(10,2)) from road_accident Where YEAR(accident_date) = '2022')
from road_accident
Where YEAR(accident_date) = '2022'
Group By urban_or_rural_area 
--For PCT
Select
  Case
       When light_conditions IN ('Daylight') Then 'Day'
	   When light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 
	   'Darkness - no lighting') Then 'Night'
	   End AS Light_Condition,
	   Cast(Cast(sum(number_of_casualties) AS decimal(10,2)) * 100 / (Select Cast(sum(number_of_casualties) AS decimal(10,2))
	   from road_accident Where YEAR(accident_date) = '2022') AS decimal(10,2)) AS CY_Casualties_PCT
	   from road_accident
	   Where YEAR(accident_date) = '2022'
	   Group By 
	     Case
       When light_conditions IN ('Daylight') Then 'Day'
	   When light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 
	   'Darkness - no lighting') Then 'Night'
	   End
-- Grouping light and dark and converting them to percentages
Select TOP 10 local_authority, sum(number_of_casualties) AS Total_Casualties
From road_accident
Group By local_authority
Order By Total_Casualties DESC