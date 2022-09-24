# Cyclistic: How Does a Bike-Share Navigate Speedy Success?
#### ***[Data Source](https://divvy-tripdata.s3.amazonaws.com/index.html)***

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
While importing the dataset into SQL, I noticed that the 'started_at' and 'ended_at' columns were TEXT datatypes instead of DATETIME datatypes, so I converted both of those. I also added a few columns including: started_time (TIME), ended_time (TIME), ride_length (TIME), and day_of_week (INT). See below or [click here]()

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
```






