-- NBA Home Court Advantage Analysis 
-- Seasons 2017-18 through 2022-23
-- What are its advantages and has it changed over time?

-- ////////////////////////
-- 1. DATA QUALITY CHECK
-- ////////////////////////

-- Number of games
SELECT COUNT(*) AS total_games
FROM nba_games;

-- Seasons
SELECT DISTINCT SEASON
FROM nba_games
ORDER BY season;

-- Duplicate games
SELECT MATCHID, COUNT(*) AS repeats 
FROM nba_games
GROUP BY MATCHID
HAVING COUNT(*) > 1;

-- //////////////////////////
-- 2. HOME COURT BY SEASON
-- /////////////////////////

SELECT 
	SEASON,
    COUNT(*) AS total_games, 
    SUM(W_HOME) AS home_wins, 
    ROUND(SUM(W_HOME) / COUNT(*) * 100, 2) AS home_win_pct
FROM nba_games
GROUP BY SEASON
ORDER BY SEASON;

-- ///////////////////////////////////////
-- 3. POINT AND STATISTIC DIFFERENTIALS
-- //////////////////////////////////////

-- Points
SELECT SEASON, ROUND(AVG(HOME_PTS - AWAY_PTS),2) AS avg_pt_diff
FROM nba_games
GROUP BY SEASON
ORDER BY SEASON; 

-- Field Goal Percetage
SELECT SEASON, ROUND(AVG(HOME_FG_PCT - AWAY_FG_PCT),3) AS avg_fg_diff
FROM nba_games
GROUP BY SEASON
ORDER BY SEASON;

-- Turnovers
SELECT SEASON, AVG(AWAY_TURNOVERS - HOME_TURNOVERS) AS home_TO_adv
FROM nba_games
GROUP BY SEASON
ORDER BY SEASON;

-- //////////////////////////
-- 4. OFFENSIVE EFFICIENCY 
-- /////////////////////////

SELECT SEASON,
	ROUND(AVG(HOME_PTS /(HOME_FGA + (0.44 * HOME_FTA) - HOME_OFF_REB + HOME_TURNOVERS)),3) AS avg_home_ppp,
    ROUND(AVG(AWAY_PTS /(AWAY_FGA + (0.44 * AWAY_FTA) - AWAY_OFF_REB + AWAY_TURNOVERS)),3) AS avg_away_ppp,
	ROUND(AVG(HOME_PTS /(HOME_FGA + (0.44 * HOME_FTA) - HOME_OFF_REB + HOME_TURNOVERS)) -
        AVG(AWAY_PTS /(AWAY_FGA + (0.44 * AWAY_FTA) - AWAY_OFF_REB + AWAY_TURNOVERS)),3) AS ppp_advantage
FROM nba_games
GROUP BY SEASON
ORDER BY SEASON;

-- /////////////////////////////////////////
-- 5. THE 2019-20 SEASON SHUTDOWN ANALYSIS
-- ////////////////////////////////////////

SELECT
    MIN(`DATE`) AS first_game,
    MAX(`DATE`) AS last_game
FROM nba_games
WHERE SEASON = '2019-20';

SELECT
    CASE
        WHEN game_date <= '2020-03-10' THEN 'Before Shutdown'
        WHEN game_date >= '2020-07-30' THEN 'After Shutdown'
    END AS period,
    COUNT(*) AS total_games,
    SUM(W_HOME) AS home_wins,
    ROUND(SUM(W_HOME) / COUNT(*) * 100, 2) AS home_win_pct
FROM nba_games
WHERE SEASON = '2019-20'
  AND (game_date <= '2020-03-10' OR game_date >= '2020-07-30')
GROUP BY period
ORDER BY period;
