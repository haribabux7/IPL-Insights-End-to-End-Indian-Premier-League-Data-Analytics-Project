# 🏏 IPL Insights — End-to-End Indian Premier League Data Analytics Project


**IPL Insights** is a full-cycle data analytics project that takes raw ball-by-ball Indian Premier League data and transforms it into a clean, query-ready dataset, a rich exploratory analysis, business-style SQL reporting, and an interactive Streamlit dashboard. The project is designed to mirror the workflow of a real data analyst — ingest, clean, model, analyse, visualise, and present.

Built around 17+ seasons of IPL match data, the project answers questions that fans, scouts, and team strategists actually care about: *Which teams win toss and match together? Who are the most consistent finishers? How does powerplay scoring trend across seasons? Which venues favour chasing?* Every notebook, query, and dashboard panel is built to be reproducible end-to-end on a fresh clone.

The repository is organised so that each layer — Dataset, Python, SQL — can stand on its own as a portfolio artefact, while together they form a cohesive analytics pipeline suitable for review by recruiters, hiring managers, and technical interviewers.

---

## 📖 Overview

The Indian Premier League generates one of the richest publicly available sports datasets — every ball of every match is recorded. Raw data alone, however, is noisy and hard to act on. **IPL Insights** bridges that gap.

- **Purpose:** Convert raw IPL ball-by-ball data into structured insight through cleaning, EDA, SQL business reporting, and an interactive dashboard.
- **Business value:** Demonstrates a complete analytics workflow — the same shape used for product analytics, sales reporting, and operational KPIs.
- **User benefits:** Quickly explore team form, player consistency, venue trends, toss impact, powerplay/death-overs phases, and season-on-season patterns without writing a single line of code.
- **Main functionality:** Data cleaning pipeline, exploratory analysis notebooks, parameterised SQL business queries, and a Streamlit dashboard with upload support and dynamic filters.

---

## ✨ Features

### Core Features
- ✅ End-to-end pipeline: raw CSV → cleaned dataset → analytics → dashboard
- ✅ Reproducible Jupyter notebooks for cleaning, EDA, and visualisation
- ✅ Production-grade SQL scripts for cleaning, EDA, and business reporting
- ✅ Interactive Streamlit dashboard with filtering, KPIs, and Plotly charts

### User Features
- ✅ Upload any compatible CSV or use the bundled cleaned IPL dataset
- ✅ Filter by season, team, venue, phase (powerplay / middle / death), and date range
- ✅ Drill-down views for batters, bowlers, teams, and venues
- ✅ Export filtered data and chart-ready tables

### Analyst Features
- ✅ Pre-computed aggregates: `team_runs`, `team_wins`, `top_batters`, `top_bowlers`, `season_trend`, `phase`, `city`
- ✅ Outlier flagging (`runs_outlier_flag`) and toss/win correlation flags
- ✅ Modular SQL: `Data_Cleaning.sql`, `EDA.sql`, `Business_Queries.sql`

### Advanced Features
- ✅ Phase-wise scoring breakdown (powerplay, middle, death overs)
- ✅ Boundary analytics (`is_four`, `is_six`, `boundary_type`)
- ✅ Toss-vs-match-winner causal-style flags
- ✅ Player-of-the-match leaderboard and consistency scoring

### Quality & Security Features
- ✅ Schema validation on data load
- ✅ Null and duplicate handling in cleaning pipeline
- ✅ No PII — fully public dataset
- ✅ Read-only dashboard (no data mutation from the UI)

---

## 🛠️ Tech Stack

### Frontend / Visualisation
- **Streamlit** — interactive dashboard UI
- **Plotly Express** — interactive charts
- **Matplotlib & Seaborn** — notebook-grade static visualisations

### Backend / Data Processing
- **Python 3.10+**
- **Pandas**, **NumPy** — data manipulation
- **scikit-learn** — auxiliary modelling utilities
- **nbformat** — notebook tooling
- **ReportLab** — PDF report generation

### Database
- **MySQL / PostgreSQL** — for executing the SQL layer
- Compatible with **SQLite** for local exploration

### Data Analytics
- **Jupyter Notebooks** — `Data_Cleaning.ipynb`, `EDA.ipynb`, `Data_Visualization.ipynb`
- **SQL scripts** — cleaning, EDA, and business queries

### DevOps & Deployment
- **Streamlit Community Cloud** (primary)
- **Docker** (optional containerised deploy)
- **GitHub Actions** — lint + notebook execution CI

### Development Tools
- **VS Code**, **JupyterLab**, **DBeaver**
- **Git & GitHub** for version control
- **Black**, **Ruff**, **nbqa** for formatting & linting

---

## 🏗️ Architecture

```text
        ┌────────────────────┐
        │   Raw IPL CSVs     │
        │  (matches, balls)  │
        └─────────┬──────────┘
                  │
                  ▼
        ┌────────────────────┐
        │  Cleaning Layer     │
        │  Python + SQL       │
        └─────────┬──────────┘
                  │  Cleaned_Data.csv
                  ▼
        ┌────────────────────┐        ┌────────────────────┐
        │   EDA & Analytics  │──────▶ │  Aggregated CSVs   │
        │ (Notebooks + SQL)  │        │ team_runs, phase…  │
        └─────────┬──────────┘        └─────────┬──────────┘
                  │                              │
                  ▼                              ▼
        ┌────────────────────────────────────────────────┐
        │       Streamlit Dashboard (Plotly UI)          │
        │  Filters · KPIs · Charts · Export              │
        └────────────────────────────────────────────────┘
```

- **System Architecture:** Three-tier — ingestion → analytics → presentation.
- **Application Flow:** User opens Streamlit → app loads `Cleaned_Data.csv` (or uploaded file) → filters drive cached aggregations → Plotly charts render.
- **Client–Server Communication:** Streamlit handles its own websocket-based reactive loop; SQL queries run against the configured database.
- **Database Relationships:** `matches` (1) ↔ (N) `deliveries`; lookup tables: `city`, `phase`, `category`.

---

## 📂 Project Structure

```text
ipl-insights/
│
├── Data-Analytics-Project/
│   ├── Dataset/
│   │   ├── Raw_Data.csv
│   │   ├── Cleaned_Data.csv
│   │   ├── matches_raw.csv
│   │   ├── city.csv
│   │   ├── phase.csv
│   │   ├── category.csv
│   │   ├── season_trend.csv
│   │   ├── team_runs.csv
│   │   ├── team_wins.csv
│   │   ├── top_batters.csv
│   │   └── top_bowlers.csv
│   │
│   ├── Python/
│   │   ├── Dashboard.py             # Streamlit app entry point
│   │   ├── Data_Cleaning.ipynb      # Raw → cleaned pipeline
│   │   ├── EDA.ipynb                # Exploratory analysis
│   │   ├── Data_Visualization.ipynb # Charts & storytelling
│   │   └── Requirements.txt
│   │
│   └── SQL/
│       ├── Data_Cleaning.sql        # Schema + cleaning DDL/DML
│       ├── EDA.sql                  # Exploratory queries
│       └── Business_Queries.sql     # Reporting queries
│
├── docs/
│   └── screenshots/                 # README screenshots
│
├── tests/                           # (optional) data validation tests
├── .env.example
├── LICENSE
└── README.md
```

**Folder roles**
- `Dataset/` — raw, cleaned, and pre-aggregated CSVs.
- `Python/` — notebooks for analysis and the Streamlit dashboard.
- `SQL/` — portable SQL implementing the same logic against a database.
- `docs/` — screenshots, diagrams, exported reports.
- `tests/` — data-quality / smoke tests.

---

## ⚙️ Installation

### Prerequisites
- **Python 3.10+**
- **pip** / **virtualenv** (or **conda**)
- **Git**
- (Optional) **MySQL 8** or **PostgreSQL 14+** for the SQL layer

### 1. Clone the repository
```bash
git clone https://github.com/haribabux7/ipl-insights.git
cd ipl-insights/Data-Analytics-Project
```

### 2. Create a virtual environment
```bash
python -m venv .venv
source .venv/bin/activate         # macOS / Linux
.venv\Scripts\activate            # Windows
```

### 3. Install dependencies
```bash
pip install -r Python/Requirements.txt
```

### 4. Configure environment variables
```bash
cp .env.example .env
# then edit .env with your DB credentials if you want to run the SQL layer
```

### 5. Start the dashboard
```bash
streamlit run Python/Dashboard.py
```

The app will open at `http://localhost:8501`.

---

## 🔐 Environment Variables

Create a `.env` file at the project root:

```env
# App
PORT=8501
APP_ENV=development

# Database (optional — only needed for the SQL layer)
DATABASE_URL=postgresql://user:password@localhost:5432/ipl
MYSQL_URI=mysql+pymysql://user:password@localhost:3306/ipl

# Auth / API (reserved for future API mode)
JWT_SECRET=replace-me
API_KEY=replace-me

# Email (reserved for scheduled report delivery)
EMAIL_HOST=smtp.gmail.com
EMAIL_USER=you@example.com
EMAIL_PASSWORD=app-password
```

| Variable | Description |
|---|---|
| `PORT` | Port the Streamlit app binds to. |
| `APP_ENV` | `development` / `production` toggle. |
| `DATABASE_URL` | PostgreSQL connection string for SQL layer. |
| `MYSQL_URI` | MySQL connection string (alternative to Postgres). |
| `JWT_SECRET` | Secret for future authenticated API mode. |
| `API_KEY` | External API key placeholder. |
| `EMAIL_*` | SMTP credentials for the future scheduled-report feature. |

---

## 🚀 Usage

1. **Launch the dashboard** with `streamlit run Python/Dashboard.py`.
2. **Pick a data source** — use the bundled `Cleaned_Data.csv` or upload your own.
3. **Apply filters** — season, team, venue, phase, date range.
4. **Explore KPIs** — total runs, sixes, wickets, win share.
5. **Drill into charts** — team comparison, top batters/bowlers, phase-wise scoring.
6. **Export** filtered tables for downstream reports.

**Example scenarios**
- A fan compares Mumbai Indians vs Chennai Super Kings across all seasons.
- An analyst inspects powerplay run-rate trends from 2008 → 2024.
- A scout finds the top 10 death-overs bowlers by economy.

---

## 🧾 API Documentation

> The project is dashboard-first. An optional FastAPI layer is planned (see *Future Improvements*). The proposed contract:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/seasons` | List all seasons available. |
| GET | `/api/teams` | List all teams with aggregate stats. |
| GET | `/api/players/top-batters?season=2024&limit=10` | Top batters for a season. |
| GET | `/api/players/top-bowlers?season=2024&limit=10` | Top bowlers for a season. |
| POST | `/api/upload` | Upload a CSV for ad-hoc analysis. |
| PUT | `/api/filters` | Update saved filter presets. |
| DELETE | `/api/filters/:id` | Delete a saved filter preset. |

**Sample response — `GET /api/players/top-batters`**
```json
{
  "season": 2024,
  "results": [
    { "batter": "V Kohli", "runs": 741, "strike_rate": 154.7, "fours": 62, "sixes": 38 },
    { "batter": "R Sharma", "runs": 417, "strike_rate": 150.4, "fours": 35, "sixes": 21 }
  ]
}
```

---

## 🗄️ Database Schema

**Core tables**

- `matches` — one row per match (id, season, date, venue, teams, toss, result).
- `deliveries` — one row per legal/illegal ball (match_id, inning, over, ball, batter, bowler, runs, extras, wicket).
- `city` — city → region lookup.
- `phase` — over → phase (powerplay / middle / death).
- `category` — categorical metadata (e.g. boundary types).

**Relationships**
- `deliveries.match_id` → `matches.match_id` (many-to-one)
- `matches.venue_city` → `city.city` (many-to-one)
- `deliveries.over_number` → `phase.over` (many-to-one)

**Sample columns (from `Cleaned_Data.csv`)**
```
match_id, season, match_date, venue_city, match_venue, match_winner,
match_toss_winner, match_toss_decision, inning, batting_team, bowling_team,
over, ball, batter, bowler, batsman_runs, extra_runs, total_runs,
is_wicket, dismissal_kind, phase, is_boundary, is_six, is_four, is_dot_ball,
toss_match_winner_flag, batting_winner_flag, runs_outlier_flag,
match_player_of_match
```

---

## 🧪 Testing

```bash
# Unit tests
pytest tests/

# Notebook smoke tests
pytest --nbmake Python/*.ipynb

# Lint
ruff check Python/
black --check Python/
```

- **Unit testing:** `pytest` for data-cleaning helpers.
- **Integration testing:** end-to-end notebook execution via `nbmake`.
- **E2E testing:** Streamlit page rendered with `playwright` (planned).
- **Tools:** `pytest`, `nbmake`, `ruff`, `black`, `playwright`.

---

## ⚡ Performance Optimizations

- **Caching:** `@st.cache_data` on data loaders avoids re-reading the CSV on every interaction.
- **Lazy loading:** Charts render only when their tab is opened.
- **Pagination:** Long leaderboards paginated to 25 rows.
- **Query optimisation:** Pre-aggregated CSVs (`team_runs.csv`, `season_trend.csv`) avoid recomputing heavy joins.
- **Vectorisation:** Pandas operations vectorised — no Python loops over rows.
- **Compression:** Cleaned CSVs stored with integer downcasts where safe.

---

## 🛡️ Security Features

- 🔒 Read-only dashboard — no DB writes from UI.
- 🔒 Uploaded files validated for schema and size before processing.
- 🔒 SQL templates use parameter binding (no string concatenation).
- 🔒 Secrets loaded from `.env` — never committed.
- 🔒 Rate-limiting & CSRF protection planned for the optional API layer.
- 🔒 `.env.example` documents required vars without leaking secrets.

---

## 🌍 Deployment

**Streamlit Community Cloud (recommended)**
1. Push the repo to GitHub.
2. Go to [share.streamlit.io](https://share.streamlit.io) → *New app*.
3. Point it at `Data-Analytics-Project/Python/Dashboard.py`.
4. Add any `.env` secrets via the *Secrets* UI.

**Other targets**
- **Render / Railway:** add a `start` command `streamlit run Python/Dashboard.py --server.port $PORT --server.address 0.0.0.0`.
- **Vercel / Netlify:** host an exported static report (`Data_Visualization.ipynb` → HTML).
- **AWS (EC2 / ECS) / Azure App Service:** run the provided Dockerfile.

**CI/CD overview**
- GitHub Actions runs lint + `nbmake` on each PR.
- On merge to `main`, Streamlit Cloud auto-deploys.

---

## 🧩 Challenges & Solutions

- **Inconsistent team names across seasons** (e.g. *Delhi Daredevils* → *Delhi Capitals*). Solved with a canonical mapping applied in the cleaning notebook and mirrored in `Data_Cleaning.sql`.
- **Mixed date formats in raw CSVs.** Standardised to ISO-8601 via `pd.to_datetime(..., errors="coerce")` plus a quarantine bucket for un-parseable rows.
- **Over numbering vs phase boundaries.** Built a `phase.csv` lookup so business queries stay declarative.
- **Outlier overs distorting averages.** Introduced `runs_outlier_flag` using IQR clamping, surfaced as a dashboard toggle rather than silently dropping data.
- **Heavy joins were slow in the dashboard.** Pre-computed aggregates (`team_runs`, `season_trend`, `top_batters`, `top_bowlers`) materialised as CSVs and cached at app load.
- **Notebook reproducibility.** Pinned versions in `Requirements.txt` and added `nbmake` CI so notebooks always execute on a clean machine.

---

## 🔮 Future Improvements

1. FastAPI service exposing the analytics as a JSON API.
2. Authenticated user accounts with saved filter presets.
3. Real-time score ingestion via a public cricket API.
4. ML model: win-probability predictor per ball.
5. ML model: player form forecaster (next-match projected runs).
6. PDF auto-report generation (scheduled email delivery).
7. Natural-language Q&A over the dataset (LLM + SQL agent).
8. Dockerfile + docker-compose for one-command spin-up.
9. Test coverage badge and full `pytest` suite.
10. Multi-language support (English / Hindi / Tamil) in the dashboard.
11. Dark-mode theming and custom team-colour palettes.
12. Mobile-first redesign with collapsible chart cards.

---

## 🤝 Contributing

1. **Fork** the repository.
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature
   ```
3. **Commit** your changes
   ```bash
   git commit -m "feat: add powerplay heatmap"
   ```
4. **Push** the branch
   ```bash
   git push origin feature/your-feature
   ```
5. **Open a Pull Request** describing the change, motivation, and screenshots if UI-related.

**Coding standards**
- Follow **PEP 8**, formatted with **Black**, linted with **Ruff**.
- Notebooks must run top-to-bottom on a clean kernel.
- SQL formatted with consistent uppercase keywords.
- Keep PRs small and focused.

---

## ❓ FAQ

**Q: Do I need a database to run the project?**
A: No. The Streamlit dashboard runs entirely from the bundled `Cleaned_Data.csv`. The SQL layer is optional and demonstrates how the same logic would be expressed against a relational database.

**Q: Can I use my own dataset?**
A: Yes. Upload any CSV that matches the schema in the *Database Schema* section. The dashboard falls back to the uploaded file when one is provided.

**Q: Which seasons are covered?**
A: All publicly available IPL seasons in the source data (2008 onwards). Re-run the cleaning notebook to extend it.

**Q: Why both notebooks and SQL?**
A: Notebooks are great for exploration and storytelling; SQL is the lingua franca of analytics teams. Maintaining both shows the same insight can be derived in either environment.

**Q: How do I deploy it for free?**
A: Streamlit Community Cloud hosts the dashboard at no cost — see *Deployment*.

---

## 📜 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for full text.

---

## 🙏 Acknowledgements

- **Open-source libraries:** Pandas, NumPy, Plotly, Streamlit, Matplotlib, Seaborn, scikit-learn, ReportLab.
- **Data:** Public IPL ball-by-ball datasets from the cricket open-data community.
- **Learning resources:** Official Streamlit docs, Plotly Express gallery, *Python for Data Analysis* (Wes McKinney), Mode Analytics SQL tutorials.
- **Inspiration:** ESPNcricinfo Statsguru, Cricsheet, and every analyst who has ever argued about strike rate over chai.

---
## 👤 Author

**HARI BABU C H**

Frontend Developer | Data Analyst | Chennai, India

- 🌐 Portfolio: [https://www.haribabu.me](https://www.haribabu.me)
- 💼 LinkedIn: [https://www.linkedin.com/in/haribabux8](https://www.linkedin.com/in/haribabux8)
- 🐙 GitHub: [https://github.com/haribabux8](https://github.com/haribabux8)
- 📧 Email: [haribabuc458@gmail.com](mailto:haribabuc458@gmail.com)

---

