# Letterboxd-Inspired Movie Social Database

**Author:** [Daipayan Chatterjee](https://github.com/dchatterjee01-prog) · Economic Data Scientist | Quantitative Analyst

<p align="left">
  <a href="https://linkedin.com/in/your-profile"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white" alt="LinkedIn"/></a>
  <a href="mailto:daipayanchatterjee01@gmail.com"><img src="https://img.shields.io/badge/Email-D14836?style=flat-square&logo=gmail&logoColor=white" alt="Email"/></a>
</p>

[![MySQL](https://img.shields.io/badge/MySQL-8.0.46-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Normalized](https://img.shields.io/badge/Normalization-1NF--BCNF-success)](Documentation/Normalization_Report.md)
[![ERD](https://img.shields.io/badge/ERD-dbdiagram.io-orange)](https://dbdiagram.io/d/Letterboxd_Physical_ERD-6a477a224ac62e474c21705e)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A university-level MySQL 8.0 database project modeling a movie social networking platform — inspired by the public features of Letterboxd (not a copy of its internal database or data).

Users can rate and review movies, log viewings via a diary, build watchlists and custom lists, follow other users, like/comment on reviews, and tag their own entries. The schema is fully normalized (1NF–BCNF), constraint-enforced, and includes views, stored functions/procedures, and triggers for business rules that can't be expressed with a same-row `CHECK`.

## Stack
- MySQL 8.0.46, `InnoDB` engine throughout
- snake_case, singular table names
- Naming conventions: `fk_*` (foreign keys), `uq_*` (unique constraints), `chk_*` (check constraints), `idx_*` (indexes), `trg_*` (triggers), `vw_*` (views), `sp_*` (procedures), `fn_*` (functions)

## Schema at a glance
- **29 base tables** across 5 groups: Lookup, Core Entities, Bridge/Metadata, User-Generated Content, Social Features
- **2 views**: `vw_movie_ratings_summary`, `vw_user_activity_summary`
- **2 stored functions**: `fn_get_movie_avg_rating`, `fn_user_rating_count`
- **2 stored procedures**: `sp_add_rating`, `sp_get_user_stats`
- **4 triggers**: exactly-one-target enforcement on `report` (INSERT + UPDATE), self-like prevention on `review_like` (INSERT + UPDATE — the UPDATE trigger closes a bypass discovered during constraint testing)
- Composite PKs used only where the relationship itself is the primary fact (junction tables, `watchlist`, `movie_cast`, `movie_crew`)

## SQL Query Showcase

13 queries across four tiers, each with explanation, verified output, and `EXPLAIN`-based optimization notes — full detail in [`Documentation/Query_Showcase.md`](Documentation/Query_Showcase.md).

| # | Tier | Query | SQL Features Demonstrated |
|---|------|-------|---------------------------|
| 1 | Beginner | Recent Movies, Sorted | `WHERE`, multi-column `ORDER BY` |
| 2 | Beginner | Users Needing Attention | `OR`, `LIKE`, `IS NULL` |
| 3 | Beginner | Movie Catalog at a Glance | Aggregate functions, no `GROUP BY` |
| 4 | Intermediate | Highest-Rated Genres | Multi-table `JOIN`, `GROUP BY` |
| 5 | Intermediate | Movie Ratings Leaderboard | `JOIN` + `GROUP BY` + `ORDER BY` (basis for `vw_movie_ratings_summary`) |
| 6 | Intermediate | Most Prolific & Best-Reviewed Actors | `COUNT(DISTINCT ...)` |
| 7 | Intermediate | User Rating Behavior | `MIN`/`MAX`/`AVG` together |
| 8 | Intermediate | Review Counts per Movie | Two-hop `LEFT JOIN`, zero-inclusive counts |
| 9 | Intermediate | Top 5 Movies (Rating Threshold) | `HAVING` vs. `WHERE` |
| 10 | Advanced | User Activity Dashboard | Correlated subqueries ×3 (basis for `vw_user_activity_summary`) |
| 11 | Advanced | Mutual Followers | `SELF JOIN` vs. `EXISTS` (two solutions, one problem) |
| 12 | Expert | Top-Ranked Movie per Genre | CTE + `RANK() OVER (PARTITION BY ...)` |
| 13 | Expert | Recommendation Engine | CTE + multi-table join chain + `NOT EXISTS` anti-join |

## Design highlights worth reading first
- `Review` is tied to `Diary_Entry` (not directly to `user_id`/`movie_id`), so a user can log and review the same movie multiple times across separate viewings — see `Documentation/Normalization_Report.md` §4 for the full 3NF reasoning.
- `Rating` and `Review` are independent — rating without reviewing (and vice versa) is a first-class case.
- Two mechanisms enforce integrity depending on scope: same-row rules use `CHECK` constraints (e.g. `chk_followers_no_self_follow`), cross-table rules use triggers (e.g. `report`'s exactly-one-target rule, which a same-row `CHECK` structurally cannot express).

## ERD

**Live, editable diagram:** [dbdiagram.io/d/Letterboxd_Physical_ERD](https://dbdiagram.io/d/Letterboxd_Physical_ERD-6a477a224ac62e474c21705e)

A static export is also included at `ERD/physical_erd.png`, and the raw DDL used to generate the diagram (stripped of CHECKs/non-FK indexes, which dbdiagram.io doesn't need) is at `ERD/erd_import.sql`.

## Repository structure
```
Database/
  schema_reference.sql   — full mysqldump: structure + seed data + views/functions/procedures/triggers
ERD/
  physical_erd.png        — physical ERD (crow's foot)
  erd_import.sql           — stripped DDL-only file for dbdiagram.io re-import (no CHECKs / non-FK indexes)
Documentation/
  Normalization_Report.md — 1NF/2NF/3NF/BCNF proof for all 29 tables
  Query_Showcase.md        — 13 annotated queries, Beginner → Expert, with EXPLAIN-based optimization notes
```

## Setup
```sql
CREATE DATABASE letterboxd_db;
USE letterboxd_db;
SOURCE Database/schema_reference.sql;
```

## License
MIT — see `LICENSE`.
