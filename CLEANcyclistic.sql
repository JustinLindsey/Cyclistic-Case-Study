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

/* Issues with server being able to run query for this step, but listed nonetheless */
-- In order to make day_of_week column more descriptive, I want to change the 0,1,2,3,4,5,6 integers, to Monday,Tuesday, etc.alter
ALTER TABLE cyclistic
MODIFY day_of_week TEXT;

UPDATE cyclistic
SET day_of_week = CASE WHEN '0' THEN 'Monday' END;
UPDATE cyclistic
SET day_of_week = CASE WHEN '1' THEN 'Tuesday' END;
UPDATE cyclistic
SET day_of_week = CASE WHEN '2' THEN 'Wednesday' END;
UPDATE cyclistic
SET day_of_week = CASE WHEN '3' THEN 'Thursday' END;
UPDATE cyclistic
SET day_of_week = CASE WHEN '4' THEN 'Friday' END;
UPDATE cyclistic
SET day_of_week = CASE WHEN '5' THEN 'Saturday' END;
UPDATE cyclistic
SET day_of_week = CASE WHEN '6' THEN 'Sunday' END;







