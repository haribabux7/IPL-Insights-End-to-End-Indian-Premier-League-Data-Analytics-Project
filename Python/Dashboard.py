import io
from pathlib import Path
import numpy as np
import pandas as pd
import streamlit as st
import plotly.express as px

st.set_page_config(page_title="IPL Analytics Dashboard", page_icon="🏏", layout="wide")

DEFAULT_PATHS = [
    Path(__file__).resolve().parents[1] / "Dataset" / "Cleaned_Data.csv",
    Path("Dataset/Cleaned_Data.csv"),
    Path("../Dataset/Cleaned_Data.csv"),
]

@st.cache_data(show_spinner=False)
def load_default_data():
    for path in DEFAULT_PATHS:
        if path.exists():
            return pd.read_csv(path, parse_dates=["match_date"])
    return pd.DataFrame()

st.title("🏏 IPL End-to-End Data Analytics Dashboard")
st.caption("Upload any compatible CSV or use the cleaned IPL dataset generated in this project.")

with st.sidebar:
    st.header("Data Source")
    uploaded = st.file_uploader("Upload CSV", type=["csv"])
    st.markdown("---")
    st.header("Filters")

if uploaded is not None:
    df = pd.read_csv(uploaded)
    if "match_date" in df.columns:
        df["match_date"] = pd.to_datetime(df["match_date"], errors="coerce")
else:
    df = load_default_data()

if df.empty:
    st.error("No data available. Place Cleaned_Data.csv in Dataset/ or upload a CSV.")
    st.stop()

# Defensive defaults make the dashboard reusable for similar datasets.
if "match_year" not in df.columns:
    df["match_year"] = pd.to_datetime(df.get("match_date", pd.Series(pd.NaT)), errors="coerce").dt.year
for col, default in {
    "batting_team": "Unknown", "bowling_team": "Unknown", "venue_city": "Unknown", "phase": "Unknown",
    "total_runs": 0, "is_wicket": 0, "legal_ball": 1, "is_boundary": 0, "is_dot_ball": 0,
    "batter": "Unknown", "bowler": "Unknown", "batsman_runs": 0, "match_id": range(len(df)),
    "extra_runs": 0, "over_number": 0, "is_extra": 0
}.items():
    if col not in df.columns:
        df[col] = default

with st.sidebar:
    years = sorted([int(x) for x in pd.Series(df["match_year"]).dropna().unique()])
    teams = sorted(df["batting_team"].dropna().astype(str).unique())
    cities = sorted(df["venue_city"].dropna().astype(str).unique())
    selected_years = st.multiselect("Season / Year", years, default=years)
    selected_teams = st.multiselect("Category / Team", teams, default=teams)
    selected_cities = st.multiselect("Region / City", cities, default=cities)
    top_n = st.slider("Top N performers", 5, 25, 10)

filtered = df[
    df["match_year"].isin(selected_years) &
    df["batting_team"].astype(str).isin(selected_teams) &
    df["venue_city"].astype(str).isin(selected_cities)
].copy()

if filtered.empty:
    st.warning("No records match the selected filters.")
    st.stop()

runs = int(filtered["total_runs"].sum())
wickets = int(filtered["is_wicket"].sum())
matches = int(filtered["match_id"].nunique())
teams_count = int(pd.concat([filtered["batting_team"], filtered["bowling_team"]]).nunique())
balls = max(filtered["legal_ball"].sum(), 1)
run_rate = runs / (balls / 6)

c1, c2, c3, c4, c5 = st.columns(5)
c1.metric("Total Runs", f"{runs:,}", help="Revenue equivalent")
c2.metric("Wickets", f"{wickets:,}", help="Profit/impact equivalent")
c3.metric("Matches", f"{matches:,}", help="Orders equivalent")
c4.metric("Teams", f"{teams_count:,}", help="Customers equivalent")
c5.metric("Run Rate", f"{run_rate:.2f}", help="Growth/efficiency KPI")

st.markdown("### Dynamic Insights")
top_team = filtered.groupby("batting_team")["total_runs"].sum().sort_values(ascending=False).head(1)
top_batter = filtered.groupby("batter")["batsman_runs"].sum().sort_values(ascending=False).head(1)
col_i1, col_i2, col_i3 = st.columns(3)
col_i1.info(f"Top scoring team: **{top_team.index[0]}** with **{int(top_team.iloc[0]):,}** runs.")
col_i2.info(f"Top batter: **{top_batter.index[0]}** with **{int(top_batter.iloc[0]):,}** runs.")
col_i3.info(f"Dot-ball rate: **{filtered['is_dot_ball'].mean()*100:.1f}%**; boundary rate: **{filtered['is_boundary'].mean()*100:.1f}%**.")

st.markdown("---")
trend = filtered.groupby("match_year").agg(runs=("total_runs","sum"), wickets=("is_wicket","sum"), balls=("legal_ball","sum"), matches=("match_id","nunique")).reset_index()
trend["run_rate"] = trend["runs"] / (trend["balls"] / 6).replace(0, np.nan)
st.plotly_chart(px.line(trend, x="match_year", y="runs", markers=True, title="Revenue Trend Equivalent: Runs by Season"), use_container_width=True)

left, right = st.columns(2)
with left:
    cat = filtered.groupby("phase").agg(runs=("total_runs","sum"), wickets=("is_wicket","sum"), balls=("legal_ball","sum")).reset_index()
    st.plotly_chart(px.bar(cat, x="phase", y="runs", color="wickets", title="Category Analysis: Runs by Match Phase"), use_container_width=True)
with right:
    team = filtered.groupby("batting_team").agg(runs=("total_runs","sum"), wickets=("is_wicket","sum"), balls=("legal_ball","sum")).reset_index().sort_values("runs", ascending=False).head(top_n)
    st.plotly_chart(px.bar(team, y="batting_team", x="runs", orientation="h", color="runs", title="Top Performers: Teams by Runs"), use_container_width=True)

left2, right2 = st.columns(2)
with left2:
    numeric_cols = [c for c in ["over_number","batsman_runs","extra_runs","total_runs","is_wicket","legal_ball","is_boundary","is_dot_ball","is_extra"] if c in filtered.columns]
    corr = filtered[numeric_cols].corr(numeric_only=True).round(2)
    st.plotly_chart(px.imshow(corr, text_auto=True, color_continuous_scale="RdBu_r", title="Correlation Heatmap"), use_container_width=True)
with right2:
    geo = filtered.groupby("venue_city").agg(runs=("total_runs","sum"), matches=("match_id","nunique"), wickets=("is_wicket","sum")).reset_index().sort_values("matches", ascending=False).head(top_n)
    fig_geo = px.bar(geo, x="venue_city", y="runs", color="matches", title="Geographic Analysis: Venue-City Runs")
    fig_geo.update_layout(xaxis_tickangle=-45)
    st.plotly_chart(fig_geo, use_container_width=True)

st.markdown("### Download Reports")
summary_df = pd.DataFrame({"Metric": ["Runs", "Wickets", "Matches", "Teams", "Run Rate"], "Value": [runs, wickets, matches, teams_count, round(run_rate, 2)]})
st.download_button("Download KPI Summary CSV", summary_df.to_csv(index=False), "kpi_summary.csv", "text/csv")
st.download_button("Download Filtered Data CSV", filtered.to_csv(index=False), "filtered_ipl_data.csv", "text/csv")
st.caption("Run with: streamlit run Python/Dashboard.py")
