/* Business_Queries.sql — 30 business questions with SQL query, insight, and recommendation. */


/*
1. Business Question: Which team has scored the most total runs?
Business Insight: Shows long-term scoring volume.
Recommendation: Benchmark lower teams against leaders.
*/
SELECT batting_team, SUM(total_runs) AS runs FROM cleaned_ipl_analytics GROUP BY batting_team ORDER BY runs DESC FETCH FIRST 10 ROWS ONLY;


/*
2. Business Question: Which team has the best run rate?
Business Insight: Normalizes output by balls faced.
Recommendation: Use efficiency with wickets lost.
*/
SELECT batting_team, ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate FROM cleaned_ipl_analytics GROUP BY batting_team HAVING SUM(legal_ball)>=600 ORDER BY run_rate DESC FETCH FIRST 10 ROWS ONLY;


/*
3. Business Question: How has scoring changed by season?
Business Insight: Identifies scoring inflation and tactical evolution.
Recommendation: Update strategy for high-scoring eras.
*/
SELECT match_year, SUM(total_runs) AS runs, ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate FROM cleaned_ipl_analytics GROUP BY match_year ORDER BY match_year;


/*
4. Business Question: Which phase contributes the most runs?
Business Insight: Shows where scoring is concentrated.
Recommendation: Allocate specialists to high-impact phases.
*/
SELECT phase, SUM(total_runs) AS runs FROM cleaned_ipl_analytics GROUP BY phase ORDER BY runs DESC;


/*
5. Business Question: Which teams dominate powerplay scoring?
Business Insight: Powerplay output drives innings control.
Recommendation: Prioritize aggressive openers.
*/
SELECT batting_team, SUM(total_runs) AS runs, ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate FROM cleaned_ipl_analytics WHERE phase=Powerplay GROUP BY batting_team ORDER BY runs DESC FETCH FIRST 10 ROWS ONLY;


/*
6. Business Question: Which teams perform best in death overs?
Business Insight: Death overs differentiate totals.
Recommendation: Recruit finishers and death specialists.
*/
SELECT batting_team, SUM(total_runs) AS runs, ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate FROM cleaned_ipl_analytics WHERE phase=Death Overs GROUP BY batting_team ORDER BY run_rate DESC FETCH FIRST 10 ROWS ONLY;


/*
7. Business Question: Who are the top batters by runs?
Business Insight: Identifies long-term batting value.
Recommendation: Combine with phase/venue splits.
*/
SELECT batter, SUM(batsman_runs) AS runs, SUM(legal_ball) AS balls, ROUND(SUM(batsman_runs)*100.0/NULLIF(SUM(legal_ball),0),2) AS strike_rate FROM cleaned_ipl_analytics GROUP BY batter ORDER BY runs DESC FETCH FIRST 15 ROWS ONLY;


/*
8. Business Question: Who are the fastest scorers?
Business Insight: Strike rate shows scoring speed.
Recommendation: Avoid small-sample bias.
*/
SELECT batter, SUM(batsman_runs) AS runs, SUM(legal_ball) AS balls, ROUND(SUM(batsman_runs)*100.0/NULLIF(SUM(legal_ball),0),2) AS strike_rate FROM cleaned_ipl_analytics GROUP BY batter HAVING SUM(legal_ball)>=300 ORDER BY strike_rate DESC FETCH FIRST 15 ROWS ONLY;


/*
9. Business Question: Who hits the most sixes?
Business Insight: Six hitting shifts momentum.
Recommendation: Use power hitters in death overs.
*/
SELECT batter, SUM(is_six) AS sixes FROM cleaned_ipl_analytics GROUP BY batter ORDER BY sixes DESC FETCH FIRST 15 ROWS ONLY;


/*
10. Business Question: Which batters rely most on boundaries?
Business Insight: Shows attacking style.
Recommendation: Balance risk with rotation ability.
*/
SELECT batter, SUM(is_boundary) AS boundaries, ROUND(SUM(is_boundary)*100.0/NULLIF(SUM(legal_ball),0),2) AS boundary_ball_pct FROM cleaned_ipl_analytics GROUP BY batter HAVING SUM(legal_ball)>=300 ORDER BY boundary_ball_pct DESC FETCH FIRST 15 ROWS ONLY;


/*
11. Business Question: Which bowlers take most wickets?
Business Insight: Wickets break partnerships.
Recommendation: Use strike bowlers in pressure windows.
*/
SELECT bowler, SUM(CASE WHEN dismissal_kind<>run out THEN is_wicket ELSE 0 END) AS wickets FROM cleaned_ipl_analytics GROUP BY bowler ORDER BY wickets DESC FETCH FIRST 15 ROWS ONLY;


/*
12. Business Question: Which bowlers have best economy?
Business Insight: Economy shows control.
Recommendation: Deploy economy bowlers versus hitters.
*/
SELECT bowler, ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS economy FROM cleaned_ipl_analytics GROUP BY bowler HAVING SUM(legal_ball)>=300 ORDER BY economy ASC FETCH FIRST 15 ROWS ONLY;


/*
13. Business Question: Which bowlers create the most dots?
Business Insight: Dot balls create pressure.
Recommendation: Reward pressure-building skills.
*/
SELECT bowler, ROUND(SUM(is_dot_ball)*100.0/NULLIF(SUM(legal_ball),0),2) AS dot_ball_pct FROM cleaned_ipl_analytics GROUP BY bowler HAVING SUM(legal_ball)>=300 ORDER BY dot_ball_pct DESC FETCH FIRST 15 ROWS ONLY;


/*
14. Business Question: Which venues are highest scoring?
Business Insight: Venue conditions affect par score.
Recommendation: Set venue-specific targets.
*/
SELECT venue_city, venue, COUNT(DISTINCT match_id) AS matches, ROUND(SUM(total_runs)*1.0/NULLIF(COUNT(DISTINCT match_id),0),2) AS runs_per_match FROM cleaned_ipl_analytics GROUP BY venue_city, venue ORDER BY runs_per_match DESC FETCH FIRST 15 ROWS ONLY;


/*
15. Business Question: Which cities host most matches?
Business Insight: High-sample cities produce reliable insights.
Recommendation: Use them as benchmark venues.
*/
SELECT venue_city, COUNT(DISTINCT match_id) AS matches FROM cleaned_ipl_analytics GROUP BY venue_city ORDER BY matches DESC FETCH FIRST 15 ROWS ONLY;


/*
16. Business Question: Does toss winner win the match?
Business Insight: Quantifies toss advantage.
Recommendation: Analyze by venue before deciding.
*/
SELECT ROUND(SUM(toss_match_winner_flag)*100.0/COUNT(DISTINCT match_id),2) AS toss_win_conversion_pct FROM (SELECT DISTINCT match_id,toss_match_winner_flag FROM cleaned_ipl_analytics) x;


/*
17. Business Question: How does toss decision affect wins?
Business Insight: Bat/field effect varies.
Recommendation: Create toss playbooks.
*/
SELECT toss_decision, COUNT(DISTINCT match_id) AS matches, ROUND(SUM(toss_match_winner_flag)*100.0/COUNT(DISTINCT match_id),2) AS win_pct FROM (SELECT DISTINCT match_id,toss_decision,toss_match_winner_flag FROM cleaned_ipl_analytics) x GROUP BY toss_decision;


/*
18. Business Question: Which dismissal types are most common?
Business Insight: Shows batting risk channels.
Recommendation: Coach against frequent dismissals.
*/
SELECT dismissal_kind, SUM(is_wicket) AS wickets FROM cleaned_ipl_analytics WHERE dismissal_kind<>None GROUP BY dismissal_kind ORDER BY wickets DESC;


/*
19. Business Question: Which bowling teams concede most extras?
Business Insight: Extras are preventable leakage.
Recommendation: Set discipline KPIs.
*/
SELECT bowling_team, SUM(extra_runs) AS extras, ROUND(SUM(extra_runs)*100.0/NULLIF(SUM(total_runs),0),2) AS extras_pct FROM cleaned_ipl_analytics GROUP BY bowling_team ORDER BY extras DESC FETCH FIRST 15 ROWS ONLY;


/*
20. Business Question: Which extras type costs most runs?
Business Insight: Separates wides/no-balls/byes.
Recommendation: Train the biggest leakage category.
*/
SELECT extras_type, COUNT(*) AS events, SUM(extra_runs) AS runs FROM cleaned_ipl_analytics WHERE extras_type<>None GROUP BY extras_type ORDER BY runs DESC;


/*
21. Business Question: Which batting teams face most dots?
Business Insight: High dot rates signal pressure.
Recommendation: Improve strike rotation.
*/
SELECT batting_team, ROUND(SUM(is_dot_ball)*100.0/NULLIF(SUM(legal_ball),0),2) AS dot_ball_pct FROM cleaned_ipl_analytics GROUP BY batting_team ORDER BY dot_ball_pct DESC FETCH FIRST 15 ROWS ONLY;


/*
22. Business Question: Which bowling teams create most dots?
Business Insight: Pressure bowling creates wickets.
Recommendation: Prioritize dot-ball matchups.
*/
SELECT bowling_team, ROUND(SUM(is_dot_ball)*100.0/NULLIF(SUM(legal_ball),0),2) AS dot_ball_pct FROM cleaned_ipl_analytics GROUP BY bowling_team ORDER BY dot_ball_pct DESC FETCH FIRST 15 ROWS ONLY;


/*
23. Business Question: What is boundary mix by year?
Business Insight: Shows tactical shift toward power.
Recommendation: Recruit according to trend.
*/
SELECT match_year, SUM(is_four) AS fours, SUM(is_six) AS sixes FROM cleaned_ipl_analytics GROUP BY match_year ORDER BY match_year;


/*
24. Business Question: Which phase has highest wicket risk?
Business Insight: Risk varies by phase.
Recommendation: Align aggression to wickets in hand.
*/
SELECT phase, ROUND(SUM(is_wicket)*100.0/NULLIF(SUM(legal_ball),0),2) AS wicket_per_ball_pct FROM cleaned_ipl_analytics GROUP BY phase ORDER BY wicket_per_ball_pct DESC;


/*
25. Business Question: Which batter-bowler matchups produce most runs?
Business Insight: Identifies favorable matchups.
Recommendation: Use for bowling changes.
*/
SELECT batter,bowler,SUM(batsman_runs) AS runs,COUNT(*) AS balls FROM cleaned_ipl_analytics GROUP BY batter,bowler HAVING COUNT(*)>=20 ORDER BY runs DESC FETCH FIRST 20 ROWS ONLY;


/*
26. Business Question: Which matchups produce most wickets?
Business Insight: Shows recurring dismissals.
Recommendation: Exploit known weaknesses.
*/
SELECT batter,bowler,SUM(is_wicket) AS wickets,COUNT(*) AS balls FROM cleaned_ipl_analytics GROUP BY batter,bowler HAVING COUNT(*)>=20 ORDER BY wickets DESC, balls DESC FETCH FIRST 20 ROWS ONLY;


/*
27. Business Question: Who wins most player-of-match awards?
Business Insight: Awards proxy clutch impact.
Recommendation: Combine with objective metrics.
*/
SELECT player_of_match, COUNT(DISTINCT match_id) AS awards FROM cleaned_ipl_analytics WHERE player_of_match<>Unknown GROUP BY player_of_match ORDER BY awards DESC FETCH FIRST 15 ROWS ONLY;


/*
28. Business Question: Which match types have highest run rate?
Business Insight: Pressure context changes scoring.
Recommendation: Adapt by match stage.
*/
SELECT match_type, COUNT(DISTINCT match_id) AS matches, ROUND(SUM(total_runs)*6.0/NULLIF(SUM(legal_ball),0),2) AS run_rate FROM cleaned_ipl_analytics GROUP BY match_type ORDER BY run_rate DESC;


/*
29. Business Question: What are top high-run deliveries?
Business Insight: Rare events swing momentum.
Recommendation: Review preventable high-cost balls.
*/
SELECT match_id, match_date, batting_team, bowling_team, batter, bowler, over_number, ball, total_runs, extras_type FROM cleaned_ipl_analytics WHERE total_runs>=7 ORDER BY total_runs DESC, match_date DESC FETCH FIRST 50 ROWS ONLY;


/*
30. Business Question: Which teams have best win involvement while batting?
Business Insight: Connects batting records to outcomes.
Recommendation: Pair with match-level win rate.
*/
SELECT batting_team, ROUND(AVG(batting_winner_flag)*100,2) AS batting_winner_event_pct FROM cleaned_ipl_analytics GROUP BY batting_team ORDER BY batting_winner_event_pct DESC FETCH FIRST 10 ROWS ONLY;
