/*
Data_Cleaning.sql — IPL Analytics
Target: PostgreSQL-compatible SQL. Import Dataset/Raw_Data.csv as raw_ipl_deliveries_matches before running.
Purpose: missing-value handling, duplicate removal, standardization, validation, type conversion, feature engineering, and outlier flagging.
*/

DROP TABLE IF EXISTS cleaned_ipl_analytics;

CREATE TABLE cleaned_ipl_analytics AS
WITH base AS (
    SELECT DISTINCT
        match_id,
        CAST(match_date AS DATE) AS match_date,
        CAST(EXTRACT(YEAR FROM CAST(match_date AS DATE)) AS INTEGER) AS match_year,
        CAST(EXTRACT(MONTH FROM CAST(match_date AS DATE)) AS INTEGER) AS match_month,
        COALESCE(NULLIF(TRIM(match_season), ''), 'Unknown') AS season,
        COALESCE(NULLIF(TRIM(match_match_type), ''), 'Unknown') AS match_type,
        COALESCE(NULLIF(TRIM(match_city), ''), 'Neutral/Unknown') AS venue_city,
        COALESCE(NULLIF(TRIM(match_venue), ''), 'Unknown') AS venue,
        CASE COALESCE(NULLIF(TRIM(match_team1), ''), 'Unknown')
            WHEN 'Delhi Daredevils' THEN 'Delhi Capitals'
            WHEN 'Kings XI Punjab' THEN 'Punjab Kings'
            WHEN 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
            WHEN 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
            ELSE COALESCE(NULLIF(TRIM(match_team1), ''), 'Unknown') END AS team1,
        CASE COALESCE(NULLIF(TRIM(match_team2), ''), 'Unknown')
            WHEN 'Delhi Daredevils' THEN 'Delhi Capitals'
            WHEN 'Kings XI Punjab' THEN 'Punjab Kings'
            WHEN 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
            WHEN 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
            ELSE COALESCE(NULLIF(TRIM(match_team2), ''), 'Unknown') END AS team2,
        CASE COALESCE(NULLIF(TRIM(match_winner), ''), 'Unknown')
            WHEN 'Delhi Daredevils' THEN 'Delhi Capitals'
            WHEN 'Kings XI Punjab' THEN 'Punjab Kings'
            WHEN 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
            WHEN 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
            ELSE COALESCE(NULLIF(TRIM(match_winner), ''), 'Unknown') END AS winner,
        CASE COALESCE(NULLIF(TRIM(match_toss_winner), ''), 'Unknown')
            WHEN 'Delhi Daredevils' THEN 'Delhi Capitals'
            WHEN 'Kings XI Punjab' THEN 'Punjab Kings'
            WHEN 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
            WHEN 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
            ELSE COALESCE(NULLIF(TRIM(match_toss_winner), ''), 'Unknown') END AS toss_winner,
        COALESCE(NULLIF(TRIM(match_toss_decision), ''), 'Unknown') AS toss_decision,
        COALESCE(match_result_margin, 0) AS result_margin,
        COALESCE(match_target_runs, 0) AS target_runs,
        COALESCE(match_target_overs, 0) AS target_overs,
        CAST(inning AS INTEGER) AS inning,
        CASE COALESCE(NULLIF(TRIM(batting_team), ''), 'Unknown')
            WHEN 'Delhi Daredevils' THEN 'Delhi Capitals'
            WHEN 'Kings XI Punjab' THEN 'Punjab Kings'
            WHEN 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
            WHEN 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
            ELSE COALESCE(NULLIF(TRIM(batting_team), ''), 'Unknown') END AS batting_team,
        CASE COALESCE(NULLIF(TRIM(bowling_team), ''), 'Unknown')
            WHEN 'Delhi Daredevils' THEN 'Delhi Capitals'
            WHEN 'Kings XI Punjab' THEN 'Punjab Kings'
            WHEN 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
            WHEN 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
            ELSE COALESCE(NULLIF(TRIM(bowling_team), ''), 'Unknown') END AS bowling_team,
        CAST("over" AS INTEGER) AS over_index,
        CAST("over" AS INTEGER) + 1 AS over_number,
        CAST(ball AS INTEGER) AS ball,
        COALESCE(NULLIF(TRIM(batter), ''), 'Unknown') AS batter,
        COALESCE(NULLIF(TRIM(bowler), ''), 'Unknown') AS bowler,
        COALESCE(NULLIF(TRIM(non_striker), ''), 'Unknown') AS non_striker,
        COALESCE(batsman_runs, 0) AS batsman_runs,
        COALESCE(extra_runs, 0) AS extra_runs,
        COALESCE(batsman_runs, 0) + COALESCE(extra_runs, 0) AS total_runs,
        COALESCE(NULLIF(TRIM(extras_type), ''), 'None') AS extras_type,
        COALESCE(is_wicket, 0) AS is_wicket,
        COALESCE(NULLIF(TRIM(player_dismissed), ''), 'None') AS player_dismissed,
        COALESCE(NULLIF(TRIM(dismissal_kind), ''), 'None') AS dismissal_kind,
        COALESCE(NULLIF(TRIM(fielder), ''), 'None') AS fielder,
        COALESCE(NULLIF(TRIM(match_player_of_match), ''), 'Unknown') AS player_of_match
    FROM raw_ipl_deliveries_matches
), features AS (
    SELECT *,
        CASE WHEN LOWER(extras_type) IN ('wides','noballs') THEN 0 ELSE 1 END AS legal_ball,
        CASE WHEN over_number BETWEEN 1 AND 6 THEN 'Powerplay'
             WHEN over_number BETWEEN 7 AND 15 THEN 'Middle Overs'
             WHEN over_number BETWEEN 16 AND 20 THEN 'Death Overs'
             ELSE 'Super Over/Other' END AS phase,
        CASE WHEN batsman_runs = 0 THEN 'Dot Ball'
             WHEN batsman_runs = 4 THEN 'Four'
             WHEN batsman_runs = 6 THEN 'Six'
             WHEN batsman_runs IN (1,2,3) THEN 'Running Runs'
             ELSE 'Other' END AS boundary_type,
        CASE WHEN batsman_runs IN (4,6) THEN 1 ELSE 0 END AS is_boundary,
        CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END AS is_four,
        CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END AS is_six,
        CASE WHEN total_runs = 0 THEN 1 ELSE 0 END AS is_dot_ball,
        CASE WHEN extra_runs > 0 THEN 1 ELSE 0 END AS is_extra,
        CASE WHEN toss_winner = winner THEN 1 ELSE 0 END AS toss_match_winner_flag,
        CASE WHEN batting_team = winner THEN 1 ELSE 0 END AS batting_winner_flag,
        CASE WHEN total_runs > 7 THEN 'High Run Event' ELSE 'Normal' END AS runs_outlier_flag
    FROM base
)
SELECT * FROM features;

-- Data validation checks
SELECT COUNT(*) AS clean_rows FROM cleaned_ipl_analytics;
SELECT COUNT(*) AS critical_nulls FROM cleaned_ipl_analytics WHERE match_id IS NULL OR batting_team IS NULL OR bowling_team IS NULL OR total_runs IS NULL;
SELECT total_runs, COUNT(*) AS delivery_count FROM cleaned_ipl_analytics GROUP BY total_runs ORDER BY total_runs;
