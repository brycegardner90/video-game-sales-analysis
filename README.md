# Video Game Industry Analysis — Sales Trends & Publisher Performance

## Project Overview

I've been playing video games my whole life. I know GTA V is massive. I know Call of Duty prints money. I know Nintendo is iconic.

But knowing something casually and being able to *prove it with data* are two very different things.

This project started as a SQL portfolio piece and turned into a genuinely interesting investigation — including a publisher that shouldn't have ranked anywhere near the top, a Nintendo mystery that took three queries to solve, and a finding about critic scores that most gamers would argue with.

**Core question:** What actually makes a video game commercially successful — and do the publishers with the biggest reputations have the data to back it up?

---

## Tools Used

- **DB Browser for SQLite** — SQL querying and data exploration
- **Power BI Desktop** — data visualization and dashboard design
- **Kaggle** — dataset source
- **GitHub** — portfolio hosting and version control

---

## Dataset

**Source:** Video Game Sales 2024 by asaniczka (Kaggle)
**Records:** 64,000+ games
**Key columns:** title, console, genre, publisher, developer, critic_score, total_sales, na_sales, jp_sales, pal_sales, release_date

---

## Key Findings

**🎮 Sports beats Action** — the genre most people assume dominates (Action) actually gets edged out by Sports in total sales. Not by much, but enough to be surprising.

**💿 GTA V is in a league of its own** — its bar on the top games chart is nearly double the next closest title. And it appears across PS3, PS4, and Xbox 360 — three separate entries all in the top tier.

**📞 Call of Duty is relentless** — COD titles take up the majority of the top games list. Their concentration on Xbox 360 tells a clear story about who their core audience was during their peak era.

**🏆 Only 3 publishers clear the consistency bar** — when filtering to publishers with 20+ games AND average sales above 1 million per title, only Rockstar Games, Microsoft Studios, and Bethesda Softworks qualify. Genuine commercial consistency at scale is extremely rare in this industry.

**🎲 Rockstar is the ultimate paradox** — highest average sales per game by a wide margin, but also the largest outlier gap. GTA carries their entire catalog. Massive success, but built on one franchise.

**🕵️ Ultra Games is not what it looks like** — they ranked near the top of the publisher consistency chart. Investigation revealed they were a Konami shell company created to get around Nintendo's publisher release limits. Their numbers are almost entirely driven by the original Teenage Mutant Ninja Turtles NES release. Also notable: they published the original Metal Gear. One of the most historically significant games ever made, hiding under an unfamiliar publisher name.

**🍄 Nintendo's data has a hidden problem** — Nintendo barely registers as a publisher in this dataset despite being one of the most iconic companies in gaming history. After investigation, the cause is attribution: Mario, Pokemon, and Zelda titles are credited to subsidiary developers (HAL Laboratory, Game Freak, Nintendo EAD) rather than Nintendo as publisher. Their true commercial footprint is significantly understated.

**⭐ Critic scores are a weak predictor of sales** — especially in high-volume genres like Sports and Shooter where franchise loyalty drives purchasing decisions far more than review scores.

---

## Dashboard

### Video Game Sales by Genre
*Total sales across all genres — sorted by commercial performance*

![Video Game Industry Analysis Dashboard](dashboard_screenshot.png)

---

## Analytical Process

### Phase 1 — Data Exploration

Before writing any analysis queries the dataset was explored to understand its structure and identify data quality issues.

**Key data quality decisions made:**

- **"Unknown" publisher records excluded** from all publisher analysis — no attribution means no insight
- **Zero sales values filtered out** using `WHERE total_sales > 0` — these represent missing data, not actual zero sales
- **Publisher naming inconsistencies flagged** — Namco, Namco Bandai, and Namco Bandai Games appear as separate entries despite being the same entity. Noted as a data limitation throughout.

### Phase 2 — Core Analysis

**Genre Sales**
Identified total sales, game count, and average per title across all genres to separate volume-driven success from genuine per-game commercial strength.

**Top Games by Platform**
Analyzed best selling titles with platform-level breakdowns to understand multi-platform reach. This led directly to the stacked bar chart showing console contribution per title — a visualization that tells a richer story than a simple ranking.

**Publisher Consistency**
The most analytically complex question. A custom metric — **outlier_gap** — was created by subtracting a publisher's average sales per game from their single best selling title. Large gap = one hit wonder. Small gap = genuine consistency across the catalog.

### Phase 3 — Additional Exploratory Analysis

Beyond the three core questions, several investigative queries were run to follow surprising results. This is documented in `video_game_analysis.sql` and reflects real analytical practice — good analysts follow unexpected results rather than accepting surface-level findings.

**The Ultra Games rabbit hole:** They appeared at the top of the consistency ranking with no obvious reason why. Querying their full catalog revealed a Konami subsidiary propped up by TMNT and Metal Gear — a textbook one hit wonder hidden behind an unfamiliar name.

**The Nintendo investigation:** Their absence from top publisher rankings triggered a two-query investigation. First confirmed no naming variants existed. Then pulled their top 20 titles and found none of their iconic franchises — confirming the developer attribution problem. The absence of Mario Kart, Super Mario Bros, and Pokemon from Nintendo's publisher record is a meaningful data quality finding for anyone using this dataset.

**The critic score test:** Preliminary analysis explored whether high review scores predict commercial performance. The relationship is weaker than most gamers would assume — franchise titles in Sports and Shooter genres routinely outsell critically acclaimed games regardless of score.

---

## SQL Skills Demonstrated

**Genre totals with SUMIF logic:**
```sql
SELECT genre,
       ROUND(SUM(total_sales), 2) AS total_sales_millions,
       COUNT(*) AS num_games
FROM vgsales
WHERE total_sales > 0
AND genre IS NOT NULL
GROUP BY genre
ORDER BY total_sales_millions DESC;
```

**Publisher consistency with custom outlier metric:**
```sql
SELECT publisher,
       COUNT(*) AS num_games,
       ROUND(AVG(total_sales), 2) AS avg_sales,
       ROUND(MAX(total_sales), 2) AS best_seller,
       ROUND(MAX(total_sales) - AVG(total_sales), 2) AS outlier_gap
FROM vgsales
WHERE publisher IS NOT NULL
AND publisher != 'Unknown'
AND total_sales > 0
GROUP BY publisher
HAVING COUNT(*) >= 20
AND AVG(total_sales) >= 0.5
ORDER BY avg_sales DESC
LIMIT 20;
```

**Full skills used:** SELECT, WHERE, GROUP BY, ORDER BY, LIMIT, HAVING, SUM, AVG, COUNT, MAX, MIN, ROUND, calculated columns, NULL handling, investigative follow-up queries

---

## Data Limitations

- Unknown publisher records excluded — cannot be attributed to a specific entity
- Zero sales values treated as missing data throughout
- Publisher naming inconsistencies exist — Namco family is the clearest example
- Nintendo's commercial presence significantly understated due to developer vs publisher attribution
- Sales figures may not capture full digital distribution for newer titles

---

## How to Reproduce

1. Download the dataset from Kaggle — search "Video Game Sales 2024" by asaniczka
2. Import the CSV into DB Browser for SQLite as a table named `vgsales`
3. Run queries from `video_game_analysis.sql`
4. Export results as CSVs using File → Export → Results to CSV
5. Load CSVs into Power BI Desktop and build visualizations

---

## Project Structure

```
video-game-sales-analysis/
│
├── video_game_analysis.sql      # All SQL queries with comments
├── genre_summary.csv            # Genre sales export
├── top20_games.csv              # Top games by console export
├── publisher_consistency.csv    # Publisher consistency export
└── dashboard_screenshot.png     # Final Power BI dashboard
```

---

## Portfolio Series

| Project | Topic | Tools |
|---------|-------|-------|
| ✅ Project 1 | Video Game Industry Sales Analysis (this project) | SQL · Power BI |
| ✅ Project 2 | NFL Penalty Bias Analysis | Python · SQL · Power BI |
| 🔜 Project 3 | Coming soon | TBD |
| 🔜 Project 4 | Coming soon | TBD |
| 🔜 Project 5 | Coming soon | TBD |

---

## About

*Bryce — Data Analyst · Atlanta, GA · Open to remote opportunities*
🔗 [LinkedIn](https://www.linkedin.com/in/bryce-gardner-16a889183) · [GitHub](https://github.com/brycegardner90)
