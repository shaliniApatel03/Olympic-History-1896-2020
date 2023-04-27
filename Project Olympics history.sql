
CREATE TABLE OLYMPICS_HISTORY (
    id NUMBER,
    name VARCHAR(120),
    sex VARCHAR(10),
    age VARCHAR(10),
    height VARCHAR(20),
    weight VARCHAR(20),
    team VARCHAR(80),
    noc VARCHAR(10),
    games VARCHAR(50),
    year NUMBER,
    season VARCHAR(10),
    city VARCHAR(50),
    sport VARCHAR(50),
    event VARCHAR(100),
    medal VARCHAR(20)
);

CREATE TABLE OLYMPICS_HISTORY_NOC_REGIONS (
    noc VARCHAR(10),
    region VARCHAR(50),
    notes VARCHAR(100)
);

select count(*) from OLYMPICS_HISTORY;
select count(*) from OLYMPICS_HISTORY_NOC_REGIONS;



-- List all the countries that have never won a gold medal in any Olympic Games.
SELECT olympics_history_noc_regions.region
FROM olympics_history_noc_regions
LEFT JOIN olympics_history
ON olympics_history_noc_regions.noc = olympics_history.noc
WHERE olympics_history.medal IS NULL;


-- List all the athletes who have won more than 10 Olympic medals, along with the total number of medals they've won.

SELECT name, COUNT(*) AS medal_count
FROM olympics_history
WHERE medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY name
HAVING COUNT(*) > 10
ORDER BY COUNT(*) DESC;


-- List all the countries that won a medal in the 2016 Summer Olympics in Rio de Janeiro, along with the number of medals they won.
SELECT olympics_history_noc_regions.region, COUNT(olympics_history.medal) AS medal_count
FROM olympics_history
JOIN olympics_history_noc_regions
ON olympics_history.noc = olympics_history_noc_regions.noc
WHERE olympics_history.year = 2016
--AND olympics_history.team = 'India'
AND olympics_history.season = 'Summer'
AND olympics_history.city = 'Rio de Janeiro'
GROUP BY olympics_history_noc_regions.region
Order by medal_count desc;





-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
SELECT region, total_medals, rnk
FROM (
    SELECT nr.region, COUNT(*) AS total_medals, DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM olympics_history oh
    JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
    WHERE medal <> 'NA'
    GROUP BY nr.region
)
WHERE rnk <= 5;



-- Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
SELECT team, sport, games, COUNT(*) AS total_medals
FROM olympics_history
WHERE medal <> 'NA'
AND team = 'India' AND sport = 'Hockey'
GROUP BY team, sport, games
ORDER BY total_medals DESC;









--  return the list of countries who have been part of every Olympics games.
SELECT nr.region AS country, COUNT(DISTINCT oh.games) AS total_participated_games, oh.noc
FROM olympics_history oh
JOIN olympics_history_noc_regions nr 
ON oh.noc = nr.noc
JOIN olympics_history_noc_regions nr 
ON oh.noc = nr.noc
GROUP BY nr.region, oh.noc
HAVING COUNT(DISTINCT oh.games) = (SELECT COUNT(DISTINCT games) FROM olympics_history)
ORDER BY nr.region;











