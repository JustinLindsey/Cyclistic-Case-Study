SELECT *
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
















