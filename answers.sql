"""SECTION: 1"""

-- SQL script that creates a new user, and database. Make the user the owner of the db.

-- To move to the postgres terminal from your bash terminal.
1. sudo -i -u postgres

-- To create a user
2. createuser <your_user>  # Replace <your_user> with the user name you want to give.

-- To create a database
3. createdb <your_dbname>  # Replace <your_dbname> with the database name you want to give.

-- To move to the postgres terminal of a specific user from your bash terminal.
4. psql

-- To make your_user the owner of your_dbname.
5. ALTER DATABASE <your_dbname> OWNER TO <your_user>.

-- To exit from the postgres terminal of a specific user.
6. \q

-- To exit from the postgres terminal.
7. exit





"""SECTION: 2"""

-- SQL script that cleans up the user, and database created in the previous step.

-- To move to the postgres terminal from your bash terminal.
1. sudo -i -u postgres

-- To move to the postgres terminal of a specific user from your bash terminal.
2. psql

-- Revoke any privileges from the user
3. REVOKE ALL PRIVILEGES ON DATABASE your_database_name FROM your_username;

-- Disconnect any active connections to the database
4.  SELECT pg_terminate_backend (pg_stat_activity.pid)
	FROM pg_stat_activity
	WHERE pg_stat_activity.datname = 'your_database_name';

-- Drop the database
5. DROP DATABASE your_database_name;


-- Drop the user
6. DROP USER your_username;





"""SECTION: 3"""\

-- SQL script that loads CSV data into a table and queries that will solve the problems of the IPL data set

-- Create the table using the acccording to the column names in csv files
1. CREATE TABLE cricket_matches (
	    id serial PRIMARY KEY,
	    season integer,
	    city text,
	    date date,
	    team1 text,
	    team2 text,
	    toss_winner text,
	    toss_decision text,
	    result text,
	    dl_applied integer,
	    winner text,
	    win_by_runs integer,
	    win_by_wickets integer,
	    player_of_match text,
	    venue text,
	    umpire1 text,
	    umpire2 text
);

2. CREATE TABLE cricket_deliveries (
    match_id integer,
    inning integer,
    batting_team text,
    bowling_team text,
    over integer,
    ball integer,
    batsman text,
    non_striker text,
    bowler text,
    is_super_over boolean,
    wide_runs integer,
    bye_runs integer,
    legbye_runs integer,
    noball_runs integer,
    penalty_runs integer,
    batsman_runs integer,
    extra_runs integer,
    total_runs integer,
    player_dismissed text,
    dismissal_kind text,
    fielder text
);

3. CREATE TABLE umpires (
    umpire VARCHAR(255),
    country VARCHAR(255)
);


-- Copy the data from your csv file to your table
4. \COPY cricket_matches FROM '/home/divesh/Desktop/Python/Projects/IPL-project/Data/matches.csv' DELIMITER ',' CSV HEADER;

5. \COPY cricket_deliveries FROM '/home/divesh/Desktop/Python/Projects/IPL-project/Data/deliveries.csv' DELIMITER ',' CSV HEADER;

6. \COPY umpires FROM '/home/divesh/Desktop/Python/Projects/IPL-project/Data/umpires.csv' DELIMITER ',' CSV HEADER;

"""Note: after FROM you have to give the absolute path to your file"""


-- Query's used to show the data from the IPL-project
 
-- Plot a chart of the total runs scored by each teams over the history of IPL. Hint: use the total_runs field.
7.  SELECT                                                                                                                        
	    batting_team,
	    SUM(total_runs) AS total_runs_scored
	FROM cricket_deliveries
	GROUP BY batting_team
	ORDER BY total_runs_scored DESC;


-- Consider only games played by Royal Challengers Bangalore. Now plot the total runs scored by 
-- top 10 batsman playing for Royal Challengers Bangalore over the history of IPL.
8.  SELECT           
	    batsman,
	    SUM(batsman_runs) AS total_runs
	FROM cricket_deliveries
	WHERE batting_team = 'Royal Challengers Bangalore'
	GROUP BY batsman
	ORDER BY total_runs DESC
	LIMIT 10;


-- Obtain a source for country of origin of umpires. Plot a chart of number of umpires by in IPL by country.
--  Indian umpires should be ignored as this would dominate the graph.
9.  SELECT country, COUNT(umpire) AS count_of_umpires
	FROM umpires
	WHERE country != ' India'
	GROUP BY country
	ORDER BY count_of_umpires DESC;


 -- Plot a stacked bar chart of ...
 --    number of games played
 --    by team
 --    by season 
10. SELECT season, teams.team1, COUNT(*) AS games_played FROM (
    SELECT season, team1 from cricket_matches 
	UNION ALL
	 SELECT season, team2 from cricket_matches
	 ) AS teams
 GROUP BY season, teams.team1 
 ORDER BY season, teams.team1;


-- Number of matches played per year for all the years in IPL.
11. SELECT season, COUNT(season) AS count FROM cricket_matches GROUP BY season ORDER BY count;


-- Number of matches won per team per year in IPL.
12. SELECT teams.team1,season, COUNT(*) AS games_played FROM (
	SELECT team1,season FROM cricket_matches
	UNION ALL 
	SELECT team2,season FROM cricket_matches)
	AS teams 
	GROUP BY teams.team1,season
	ORDER BY teams.team1,season;


-- Extra runs conceded per team in the year 2016 
13. SELECT
    d.batting_team AS team,
    m.season,
    SUM(d.extra_runs) AS extra_runs_conceded
	FROM cricket_deliveries AS d
	JOIN cricket_matches AS m ON d.match_id = m.id
	WHERE m.season = 2016
	GROUP BY d.batting_team, m.season
	ORDER BY m.season, d.batting_team;


-- Top 10 economical bowlers in the year 2015
14. SELECT
	    bowler,
	    (total_runs / (total_deliveries / 6)) AS economy_rate
	FROM (
	    SELECT
	        d.bowler,
	        m.season,
	        SUM(d.total_runs) AS total_runs,
	        COUNT(*) AS total_deliveries
	    FROM cricket_deliveries AS d
	    JOIN cricket_matches AS m ON d.match_id = m.id
	    WHERE m.season = 2015
	    GROUP BY d.bowler, m.season
	) AS BowlerStats
	GROUP BY bowler, total_runs, total_deliveries
	ORDER BY economy_rate
	LIMIT 10;
