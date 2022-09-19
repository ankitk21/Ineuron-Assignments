
--------------------------------------CREATING TABLE ACCIDENTS ------------------------------
CREATE TABLE ACCIDENTS (
Accident_Index VARCHAR(30),
Location_Easting_OSGR VARCHAR(30),
Location_Northing_OSGR VARCHAR(30),
Longitude VARCHAR(30),
Latitude VARCHAR(30),
Police_Force INT,
Accident_Severity INT,
Number_of_Vehicles INT,
Number_of_Casualties INT,
`Date` VARCHAR(30),
Day_of_Week INT,
`Time` VARCHAR(30),
`Local_Authority_(District)` INT,
`Local_Authority_(Highway)` VARCHAR(30),
1st_Road_Class INT,
1st_Road_Number INT,
Road_Type INT,
Speed_limit INT,
Junction_Detail INT,
Junction_Control INT,
2nd_Road_Class INT,
2nd_Road_Number INT,
Pedestrian_Crossing_Human_Control INT,
Pedestrian_Crossing_Physical_Facilities INT,
Light_Conditions INT,
Weather_Conditions INT,
Road_Surface_Conditions INT,
Special_Conditions_at_Site INT,
Carriageway_Hazards INT,
Urban_or_Rural_Area INT,
Did_Police_Officer_Attend_Scene_of_Accident INT,
LSOA_of_Accident_Location VARCHAR(30))
--------------------------------------CREATING TABLE VEHICLE TYPES--------------------------
CREATE TABLE VEHICLE_TYPES(
`CODE` INT,
LABEL VARCHAR(100))
--------------------------------------CREATING TABLE VEHICLES-------------------------------
CREATE TABLE VEHICLES(
Accident_Index VARCHAR(20),
Vehicle_Reference VARCHAR(20),
Vehicle_Type VARCHAR(20),
Towing_and_Articulation VARCHAR(20),
Vehicle_Manoeuvre VARCHAR(20),
Vehicle_Location_Restricted_Lane VARCHAR(20),
Junction_Location VARCHAR(20),
Skidding_and_Overturning VARCHAR(20),
Hit_Object_in_Carriageway VARCHAR(20),
Vehicle_Leaving_Carriageway VARCHAR(20),
Hit_Object_off_Carriageway VARCHAR(20),
1st_Point_of_Impact VARCHAR(20),
Was_Vehicle_Left_Hand_Drive VARCHAR(20),
Journey_Purpose_of_Driver VARCHAR(20),
Sex_of_Driver VARCHAR(20),
Age_of_Driver VARCHAR(20),
Age_Band_of_Driver VARCHAR(20),
`Engine_Capacity_(CC)` VARCHAR(20),
Propulsion_Code VARCHAR(20),
Age_of_Vehicle VARCHAR(20),
Driver_IMD_Decile VARCHAR(20),
Driver_Home_Area_Type VARCHAR(20),
Vehicle_IMD_Decile VARCHAR(20))

-----Problem Statement 1: Evaluate the median severity value of accidents caused by various Motorcycles.---------
    -------------------CREATE A TABLE WHERE ACCIDENTS ARE BY DIFFERENT MOTORCYCLES------------------
		CREATE TABLE ACC_MOT AS
		SELECT V.ACCIDENT_INDEX, ACCIDENT_SEVERITY, M.LABEL, M.CODE
		FROM ACCIDENTS A
		INNER JOIN VEHICLES V
		ON A.Accident_Index = V.Accident_Index
		INNER JOIN (SELECT * FROM VEHICLE_TYPES WHERE LABEL LIKE '%MOTORCYCLE%') M
		ON V.VEHICLE_TYPE = M.CODE
		ORDER BY CODE
	----------------------------------EVALUATING MEDIAN SEVERITY-------------------------------------
	SELECT CODE,LABEL,ROUND(AVG(ACCIDENT_SEVERITY)) AS MEDIAN_SEVERITY 
	FROM
	(SELECT *,ROW_NUMBER() OVER (PARTITION BY LABEL ORDER BY ACCIDENT_SEVERITY) AS RN,COUNT(*) OVER
    (PARTITION BY LABEL) AS TOTAL 
	FROM ACC_MOT) AS A
	WHERE RN BETWEEN (TOTAL/2) AND (TOTAL/2 + 1)
    GROUP BY LABEL
	ORDER BY CODE                                               
    
    

-----Problem Statement 2: Evaluate Accident Severity and Total Accidents per Vehicle Type---------
    -------------------ACCIDENT SEVERITY AND TOTAL SEVERITY BY DIFFERENT VEHICLE TYPES ------------------
	SELECT T.LABEL, a.ACCIDENT_SEVERITY AS SEVERITY , COUNT(T.LABEL) AS TOTAL_ACCIDENTS
	from accidents a
	inner join vehicles v
	on a.accident_index = v.accident_index
	inner join vehicle_types T
	on v.vehicle_type = t.code
	GROUP BY LABEL

-----Problem Statement 3: Calculate the Average Severity by vehicle type.---------
	SELECT T.LABEL, AVG(a.ACCIDENT_SEVERITY) AS AVERAGE_SEVERITY
	from accidents a
	inner join vehicles v
	on a.accident_index = v.accident_index
	inner join vehicle_types T
	on v.vehicle_type = t.code
	GROUP BY LABEL
    
-----Problem Statement 4: Calculate the Average Severity and Total Accidents by Motorcycle.---------
	SELECT M.LABEL,A.ACCIDENT_SEVERITY AS SEVERITY ,AVG(ACCIDENT_SEVERITY) AS AVERAGE_SEVERITY 
	FROM ACCIDENTS A
	INNER JOIN VEHICLES V
	ON A.Accident_Index = V.Accident_Index
	INNER JOIN (SELECT * FROM VEHICLE_TYPES WHERE LABEL LIKE '%MOTORCYCLE%') M
	ON V.VEHICLE_TYPE = M.CODE
	GROUP BY LABEL



