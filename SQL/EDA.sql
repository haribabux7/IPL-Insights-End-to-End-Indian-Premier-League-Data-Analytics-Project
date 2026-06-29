/* EDA.sql — Exploratory SQL Analysis for cleaned_ipl_analytics */

-- Dataset Summary
SELECT COUNT(*) AS delivery_records, COUNT(DISTINCT match_id) AS matches, COUNT(DISTINCT season) AS seasons,
       COUNT(DISTINCT batting_team) AS teams, SUM(total_runs) AS total_runs, SUM(is_wicket) AS total_wickets,
       ROUND(SUM(total_runs) * 6.0 / NULLIF(SUM(legal_ball),0), 2) AS overall_run_rate
FROM cleaned_ipl_analytics;

-- Data Quality Audit
SELECT SUM(CASE WHEN match_id IS NULL THEN 1 ELSE 0 END) AS missing_match_id,
       SUM(CASE WHEN match_date IS NULL THEN 1 ELSE 0 END) AS missing_match_date,
       SUM(CASE WHEN batting_team='Unknown' THEN 1 ELSE 0 END) AS unknown_batting_team,
       SUM(CASE WHEN bowler='Unknown' THEN 1 ELSE 0 END) AS unknown_bowler
FROM cleaned_ipl_analytics;

-- Trend Analysis
SELECT match_year, COUNT(DISTINCT match_id) AS matches, SUM(total_runs) AS runs, SUM(is_wicket) AS wickets,
       ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate
FROM cleaned_ipl_analytics
GROUP BY match_year
ORDER BY match_year;

-- Category Analysis: Phase
SELECT phase, SUM(total_runs) AS runs, SUM(is_wicket) AS wickets, SUM(is_boundary) AS boundaries,
       ROUND(AVG(is_dot_ball)*100,2) AS dot_ball_pct,
       ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate
FROM cleaned_ipl_analytics
GROUP BY phase
ORDER BY runs DESC;

-- Category Analysis: Boundary Type
SELECT boundary_type, COUNT(*) AS events, SUM(total_runs) AS runs
FROM cleaned_ipl_analytics
GROUP BY boundary_type
ORDER BY runs DESC;

-- Top Performance: Batting Teams
SELECT batting_team, SUM(total_runs) AS runs, COUNT(DISTINCT match_id) AS matches,
       ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate
FROM cleaned_ipl_analytics
GROUP BY batting_team
ORDER BY runs DESC
FETCH FIRST 10 ROWS ONLY;

-- Bottom Performance: Batting Teams by Run Rate with minimum sample
SELECT batting_team, SUM(total_runs) AS runs, SUM(legal_ball) AS balls,
       ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate
FROM cleaned_ipl_analytics
GROUP BY batting_team
HAVING SUM(legal_ball) >= 600
ORDER BY run_rate ASC
FETCH FIRST 10 ROWS ONLY;

-- Top Batters
SELECT batter, SUM(batsman_runs) AS runs, SUM(legal_ball) AS balls, SUM(is_four) AS fours, SUM(is_six) AS sixes,
       ROUND(SUM(batsman_runs)*100.0/NULLIF(SUM(legal_ball),0),2) AS strike_rate
FROM cleaned_ipl_analytics
GROUP BY batter
HAVING SUM(legal_ball) >= 100
ORDER BY runs DESC
FETCH FIRST 20 ROWS ONLY;

-- Top Bowlers
SELECT bowler, SUM(CASE WHEN dismissal_kind <> 'run out' THEN is_wicket ELSE 0 END) AS wickets,
       SUM(total_runs) AS runs_conceded, SUM(legal_ball) AS balls,
       ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS economy
FROM cleaned_ipl_analytics
GROUP BY bowler
HAVING SUM(legal_ball) >= 120
ORDER BY wickets DESC
FETCH FIRST 20 ROWS ONLY;

-- Segmentation: Geographic Performance
SELECT venue_city, COUNT(DISTINCT match_id) AS matches, SUM(total_runs) AS runs, SUM(is_wicket) AS wickets,
       ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate
FROM cleaned_ipl_analytics
GROUP BY venue_city
ORDER BY matches DESC, runs DESC;

-- Toss Decision and Outcome
SELECT toss_decision, COUNT(DISTINCT match_id) AS matches,
       SUM(toss_match_winner_flag) AS toss_winner_match_wins,
       ROUND(SUM(toss_match_winner_flag)*100.0/COUNT(DISTINCT match_id),2) AS toss_win_conversion_pct
FROM (SELECT DISTINCT match_id, toss_decision, toss_match_winner_flag FROM cleaned_ipl_analytics) x
GROUP BY toss_decision;
