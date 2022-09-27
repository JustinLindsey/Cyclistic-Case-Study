SELECT *
FROM cyclistic 
LIMIT 50;

-- Calculating the mean of ride_length for each group
SELECT member_casual, LEFT(sec_to_time(avg(time_to_sec(ride_length))),8) as avg
FROM cyclistic
WHERE month(started_at) IN (5,6,7,8,9)
GROUP BY member_casual
;

-- Calculating the max of ride_length
SELECT max(ride_length)
FROM cyclistic;

-- Calculating the mode of day_of_week
SELECT day_of_week, count(*) as rides
FROM cyclistic
GROUP BY day_of_week
ORDER BY count(*) desc;

-- Calculating the average ride_length for members and casual riders.
-- member
SELECT LEFT(sec_to_time(avg(time_to_sec(ride_length))),8) as avg
FROM cyclistic
WHERE member_casual LIKE 'member';
-- casual
SELECT LEFT(sec_to_time(avg(time_to_sec(ride_length))),8) as avg
FROM cyclistic
WHERE member_casual LIKE 'casual';

-- Calculate the number of rides for users
SELECT member_casual, count(*)
FROM cyclistic
GROUP BY member_casual;

-- Viewing which days are active amongst both casual and member riders
SELECT member_casual, day_of_week, CASE
WHEN member_casual = 'member' THEN COUNT(*)
WHEN member_casual = 'casual' THEN COUNT(*)
END AS week_day_count
FROM cyclistic
GROUP BY member_casual, day_of_week
ORDER BY member_casual, week_day_count DESC;

-- Seeing percentage of rides for each group
WITH cte AS
(SELECT cast(count(ride_id) AS float) AS total_num
FROM cyclistic)
SELECT member_casual, 
CASE
 	WHEN member_casual = 'member' THEN round(cast((count(*) / total_num) * 100 AS float),2)
	WHEN member_casual = 'casual' THEN round(cast((count(*) / total_num) * 100 AS float),2)
END AS percentage_of_total_rides_all_year
FROM cyclistic, cte
GROUP BY member_casual, cte.total_num;

-- checking to see months with the most activity for casual riders
SELECT MONTH(started_at) as month, count(*) as num
FROM cyclistic
WHERE member_casual LIKE 'casual'
GROUP BY MONTH(started_at)
ORDER BY count(*) desc;

-- checking to see which months hold the most activity with members
SELECT MONTH(started_at) as month, count(*) as num
FROM cyclistic
WHERE member_casual LIKE 'member'
GROUP BY MONTH(started_at)
ORDER BY count(*) desc;

-- counting the amount of station names
SELECT count(distinct start_station_name), count(start_station_name)
FROM cyclistic
WHERE start_station_name IS NOT null;

-- Ranking the start stations visited most between both types of riders
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

-- Ranking the end stations visited most between both types of riders
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

-- seeing the frequency at which certain bikes were used throughout the year
SELECT rideable_type, member_casual, EXTRACT(QUARTER FROM started_at) AS quarter, COUNT(*) AS total_rides
FROM cyclistic
GROUP BY quarter, rideable_type, member_casual
HAVING member_casual = 'casual'
ORDER BY total_rides;



