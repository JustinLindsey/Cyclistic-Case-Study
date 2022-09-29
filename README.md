# Cyclistic: How Does a Bike-Share Navigate Speedy Success?
#### ***[Data Source](https://divvy-tripdata.s3.amazonaws.com/index.html)***
#### **10-15 minute read**

## **Introduction**
For this Case Study, I'm a junior data analyst working for a fictional company, **Cyclistic**. I will follow the basic steps for a data analyst process: **ask, prepare, process, analyze, share, act.** The director believes that the success of the company depends on maximizing the number of annual memberships. Three questions guide the marketing program. How do annual members and casual riders use Cyclistic bikes differently? Why would casual riders buy Cyclistic annual memberships? How can Cyclistic use digital media to influence casual riders to become members? My job will be to answer the first question!

## **Ask**
### ***Identify the business task***
How do annual members and casual riders use Cyclistic bikes differently is the question I am tasked with answering in this study. Cyclistic has concluded that annual members are more profitable, so the goal will be to conver those casual riders into annual members!

### ***Identify Stakeholders***
Key stakeholders include: Cyclistic executive team, Director of Marketing (Lily Moreno), and the Marketing Analytics team.

## **Prepare**
### ***Download data and store it appropriately***
The data has been made available by Motivate International Inc. under this [license](https://ride.divvybikes.com/data-license-agreement). The data source used can be seen above.

### ***Identify how it's organized***
All the data is in comma-delimited (.CSV) format with 15 columns. These columns are: **ride ID #, ride type, start/end time, ride length (in minutes), day of the week, starting point (code, name, and latitude/longitude), ending point (code, name, and latitude/longitude), and member/casual rider**.

### ***Determine the credibility of the data***
This is a fictional company and a case study presented by Google so we will assume it is credible.

## Process
### ***Check the data for errors***
Data from this set goes back to May of 2020. We will only be looking at the last 12 months of data to analyze. 12 individual files each representing the last 12 months respectively. This is an appropriate sample size.

### ***Choose your tools***
The tools that I chose to use during this case study included **MySQL Workbench, Excel, and Tableau.** SQL for easy analysis and Tableau for visualizations of my findings.

### ***Transforming and Documenting the Data***
While importing the dataset into SQL, I noticed that the 'started_at' and 'ended_at' columns were TEXT datatypes instead of DATETIME datatypes, so I converted both of those. I also added a few columns including: 'started_time' (TIME), 'ended_time' (TIME), 'ride_length' (TIME), and 'day_of_week' (INT). See below or [click here](https://github.com/JustinLindsey/Cyclistic-Case-Study/blob/main/CLEANcyclistic.sql)

`Data Cleaning`

```SELECT *
FROM cyclistic;

-- Converting two columns from text datatypes, to datetime datatypes
ALTER TABLE cyclistic
MODIFY started_at DATETIME;

ALTER TABLE cyclistic
MODIFY ended_at DATETIME;

-- altering table to add an empty column that will hold a starting ride time, then adding that starting time
ALTER TABLE cyclistic
ADD started_time TIME;

UPDATE cyclistic
SET started_time = CAST(started_at AS TIME);

-- altering table to add an empty column that will hold a ending ride time, then adding that ending time
ALTER TABLE cyclistic
ADD ended_time TIME;

UPDATE cyclistic
SET ended_time = CAST(ended_at AS TIME);

-- making sure my ride_length query works before I add a new column for the ride_length time
SELECT ended_time, started_time, SUBTIME(ended_time, started_time) as ride_length
FROM cyclistic;

-- altering table to add empty column that will hold the ride length, which is the ending time minus the starting time
ALTER TABLE cyclistic
ADD ride_length TIME;

UPDATE cyclistic
SET ride_length = SUBTIME(ended_time, started_time);

-- beginning to make a column to add the day of the week, 0 = Monday, 1 = Tuesday, and so on until 6 = Sunday
SELECT started_at, WEEKDAY(started_at) as day_of_week
FROM cyclistic;

ALTER TABLE cyclistic
ADD day_of_week INT;

UPDATE cyclistic
SET day_of_week = WEEKDAY(started_at);

-- Changing day_of_week column into a text datatype. It still has numbers 0,1,2 and so on to represent Monday, Tuesday etc.

ALTER TABLE cyclistic
MODIFY day_of_week TEXT;

-- Updating table so that it is much easier to look at the day_of_week column and decipher what day it actually is.

UPDATE cyclistic
SET day_of_week = CASE 
	WHEN day_of_week = '0' THEN 'Monday' 
	WHEN day_of_week = '1' THEN 'Tuesday'
	WHEN day_of_week = '2' THEN 'Wednesday'
	WHEN day_of_week = '3' THEN 'Thursday'
	WHEN day_of_week = '4' THEN 'Friday'
	WHEN day_of_week = '5' THEN 'Saturday'
	WHEN day_of_week = '6' THEN 'Sunday'
    ELSE day_of_week
END
```
## **Analyze**
### ***Analysis was done using MySQL Workbench***

First up was doing a simple query to see the percentage of rides taken by each group (casual/member). The numbers showed that casual riders made up **41.96%** of the rides while members made up **58.04%** of rides

```
WITH cte AS
(SELECT CAST(COUNT(ride_id) AS FLOAT) AS total_num
FROM cyclistic)
SELECT member_casual, 
CASE
 	WHEN member_casual = 'member' THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS float),2)
	WHEN member_casual = 'casual' THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS float),2)
END AS percentage_of_total_rides_all_year
FROM cyclistic, cte
GROUP BY member_casual, cte.total_num;
```

Second on the list was checking to see which months were the most active between both groups. As expected, both groups saw a major spike during the spring-summer months and drop during the cooler months. The casual riders took a huge hit once the weather began changing.

```SELECT MONTH(started_at) as month, count(*) as num
FROM cyclistic
WHERE member_casual LIKE 'casual'
GROUP BY MONTH(started_at)
ORDER BY count(*) desc;

SELECT MONTH(started_at) as month, count(*) as num
FROM cyclistic
WHERE member_casual LIKE 'member'
GROUP BY MONTH(started_at)
ORDER BY count(*) desc;
```

Now for checking the average ride duration for each group of riders. Casual riders tended to have longer trips than the members by 2-3 minutes

```
SELECT member_casual, LEFT(sec_to_time(avg(time_to_sec(ride_length))),8) as avg
FROM cyclistic
WHERE month(started_at) IN (5,6,7,8,9)
GROUP BY member_casual
```

Next I checked which days were most active amongst each group. The results tells us a lot. The most active days for casual riders was the weekend. Friday through Sunday is where most of the riders came for them and we see a drop off for weekdays. However, we see the opposite for members. The most frequent days are the weekdays while the weekends take a hit for members.

```
-- Viewing which days are active amongst both casual and member riders
SELECT member_casual, day_of_week, CASE
WHEN member_casual = 'member' THEN COUNT(*)
WHEN member_casual = 'casual' THEN COUNT(*)
END AS week_day_count
FROM cyclistic
GROUP BY member_casual, day_of_week
ORDER BY member_casual, week_day_count DESC;
```

Now checked the amount of stations and see which stations are visited the most frequently by the casual riders. There were a total of 1,439 distinct stations. 

**Top three for casuals**

* Streeter Dr & Grand Ave
* DuSable Lake Shore Dr & Monroe St
* Millennium Park

**Top three for members**

* Kingsbury St & Kinzie St
* Clark St & Elm St
* Wells St & Concord Ln


```
SELECT count(distinct start_station_name), count(start_station_name)
FROM cyclistic
WHERE start_station_name IS NOT null
```
```
with cte AS
(
SELECT member_casual, start_station_name,
CASE 
	WHEN member_casual = 'casual' THEN
		DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC)
	WHEN member_casual = 'member' THEN
		DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC)
END AS ranking
FROM cyclistic
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name, member_casual
ORDER BY member_casual, ranking
)
SELECT * FROM cte
WHERE ranking <= 4 AND start_station_name IS NOT null;
```

```
with cte AS
(
SELECT member_casual, end_station_name,
CASE 
	WHEN member_casual = 'casual' THEN
		DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC)
	WHEN member_casual = 'member' THEN
		DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC)
END AS ranking
FROM cyclistic
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name, member_casual
ORDER BY member_casual, ranking
)
SELECT * FROM cte
WHERE ranking <= 4 AND end_station_name IS NOT null;
```
The last form of analysis will be looking at the different types of bikes and the frequency at which they were used throughout the year. For the most part classic and electric were used during the busiest parts of the year, Spring-Summer. Docked bikes become more prevalent in the winter months

```
SELECT rideable_type, member_casual, EXTRACT(QUARTER FROM started_at) AS quarter, COUNT(*) AS total_rides
FROM cyclistic
GROUP BY quarter, rideable_type, member_casual
ORDER BY total_rides desc;
```

## **Share**
### ***The software used for visualizatizing my analysis was Tableau Public***
Link to the full [Dashboard](https://public.tableau.com/app/profile/justin.lindsey/viz/CyclisticAnalysis_16643791706850/Dashboard1) 

![Screen Shot 2022-09-28 at 11 20 43 AM](https://user-images.githubusercontent.com/99827985/192833350-94d60dc7-fb53-4a28-ad5e-ebbabba47d03.png)

We can see a spike in rides for all riders during the summer months and a dip once the fall and winter seasons come around

![Screen Shot 2022-09-28 at 11 26 14 AM](https://user-images.githubusercontent.com/99827985/192834477-c5458087-fd7e-48c9-b895-90dd201237bb.png)

The busiest days for casual riders are saturday and sunday, the weekend gets a huge influx of casual riders. The weekdays are where the members do most of their riding.

![Screen Shot 2022-09-28 at 11 28 32 AM](https://user-images.githubusercontent.com/99827985/192835096-d5be920e-6dde-4faf-8709-0c8ac5381d75.png)

The stations where riders start and end seem to be very consistent in terms of popularity.

![Screen Shot 2022-09-28 at 11 30 02 AM](https://user-images.githubusercontent.com/99827985/192835679-090b286a-1298-4aa6-ad50-0e4ce4fa0ade.png)

Classic and Electric bikes are much more popular than the docked bikes especially during peak season.

## **Act**
Reminder: The goal is to convert casual riders into members
### ***Recommendations***

* From the analysis it seems that marketing should start in May and run through September. Quarter's 2 and 3 is the most active in terms of riders.

* Saturday and Sunday should be prioritised when it comes to scheduling ads for any campaigns ran.

* I recommend running more marketing campaigns targeting certain bike stations. Primarily 'Streeter Dr. and Grand Ave','Dusable Lake Shore Dr.', and 'Millennium Park' locations seeing as they are the most frequented bike stations.

* Taking a look at the different bike types, we should look towards pushing classic and electric bikes rather than docked ones. Maybe certain promotions can be ran to encourage their use.

Thank you for your time.
* Email: justinmarquis.lindsey@gmail.com
* LinkedIn: [Justin Lindsey](https://www.linkedin.com/in/justinmlindsey/)
