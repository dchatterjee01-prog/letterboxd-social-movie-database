# Query Showcase
### Letterboxd-Inspired Movie Social Database
### 13 queries, Beginner → Expert, extracted from actual verified session history

**Note on sourcing:** every query below is copied exactly as it was written and run against the live database in earlier sessions — none have been rewritten or "cleaned up" for this document. Where a query was later re-examined with `EXPLAIN` during Phase 8, that finding is included in its Optimization Notes.

---

## BEGINNER TIER

### Query 1 — Recent Movies, Sorted
```sql
SELECT title,
       release_year,
       runtime_minutes
FROM movie
WHERE release_year >= 2015
ORDER BY release_year DESC, title ASC;
```
**What it does:** Lists every movie from 2015 onward, most recent first, alphabetically within each year.
**Why it's here:** Simplest possible pattern — single table, `WHERE`, multi-column `ORDER BY` with mixed directions (`DESC` then `ASC`).
**Verified output:** 16 rows (confirmed multiple times across sessions, including after the `release_year` type migration from `YEAR` to `SMALLINT UNSIGNED` — proving the fix didn't alter query behavior).
**Optimization notes (from Phase 8 `EXPLAIN`):** `idx_movie_release_year` fully satisfies the filter (`type=range` once table size was scaled up in a synthetic 5,000-row test — at native 28-row scale, MySQL's optimizer correctly judged a full scan cheaper than an index lookup, `type=ALL`). Critically, the index does **not** eliminate `Using filesort` — the compound `ORDER BY release_year DESC, title ASC` needs a composite index covering both columns in matching sort direction to avoid a sort step; a single-column index on `release_year` alone only helps the filter, not the full ordering.

---

### Query 2 — Users Needing Attention (Pattern Match + NULL Check)
```sql
SELECT username,
       email,
       bio
FROM user
WHERE username LIKE '%film%'
   OR bio IS NULL;
```
**What it does:** Finds users whose username contains "film," OR who haven't written a bio yet.
**Why it's here:** Demonstrates `OR` logic combining a pattern-match condition with a `NULL` check — a common beginner mistake is assuming `bio = NULL` works; this correctly uses `IS NULL`.
**Optimization notes:** A leading-wildcard `LIKE '%film%'` cannot use any index (the wildcard at the start prevents index range-scanning) — this is a full table scan by necessity, not by a missed indexing opportunity. Worth knowing as a genuine limitation, not something a CREATE INDEX statement could fix.

---

### Query 3 — Movie Catalog at a Glance
```sql
SELECT COUNT(*) AS total_movies,
       MIN(release_year) AS earliest_year,
       MAX(release_year) AS latest_year,
       ROUND(AVG(runtime_minutes), 1) AS avg_runtime
FROM movie;
```
**What it does:** A single-row dashboard summary of the whole catalog.
**Why it's here:** Demonstrates multiple aggregate functions (`COUNT`, `MIN`, `MAX`, `AVG`) in one query with no `GROUP BY` — the simplest form of aggregation, collapsing the whole table to one row.

---

## INTERMEDIATE TIER

### Query 4 — Highest-Rated Genres
```sql
SELECT g.genre_name,
       ROUND(AVG(r.rating_value), 2) AS avg_rating,
       COUNT(r.rating_id) AS num_ratings
FROM rating r
JOIN movie_genre mg ON mg.movie_id = r.movie_id
JOIN genre g ON g.genre_id = mg.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY avg_rating DESC;
```
**What it does:** Ranks genres by their average rating across every movie tagged with that genre.
**Why it's here:** A two-table `JOIN` chain through a bridge table (`movie_genre`), aggregated with `GROUP BY` — the first real multi-table analytical query.
**Optimization notes (from Phase 8 `EXPLAIN`):** All three tables join on indexed foreign key / primary key columns, so this executes efficiently even before any additional indexing — the FK auto-indexing InnoDB provides on `movie_genre.genre_id` and `.movie_id` already covers the join paths.

---

### Query 5 — Movie Ratings Leaderboard
```sql
SELECT m.title,
       m.release_year,
       ROUND(AVG(r.rating_value), 2) AS avg_rating,
       COUNT(r.rating_id) AS num_ratings
FROM movie m
JOIN rating r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title, m.release_year
ORDER BY avg_rating DESC, num_ratings DESC;
```
**What it does:** Ranks every movie by average rating, using rating count as a tiebreaker.
**Why it's here:** This exact query later became the basis for `vw_movie_ratings_summary` (Phase 7) — a direct, traceable example of "a useful ad-hoc query becoming a permanent view."

---

### Query 6 — Most Prolific & Best-Reviewed Actors
```sql
SELECT a.full_name,
       COUNT(DISTINCT mc.movie_id) AS num_movies,
       ROUND(AVG(r.rating_value), 2) AS avg_rating_of_their_movies
FROM actor a
JOIN movie_cast mc ON mc.actor_id = a.actor_id
JOIN rating r ON r.movie_id = mc.movie_id
GROUP BY a.actor_id, a.full_name
ORDER BY num_movies DESC, avg_rating_of_their_movies DESC;
```
**What it does:** For each actor, counts distinct movies they appear in and the average rating across those movies.
**Why it's here:** Introduces `COUNT(DISTINCT ...)` — necessary here because joining `movie_cast → rating` can multiply rows (a popular movie has many ratings), so a plain `COUNT(mc.movie_id)` would over-count.

---

### Query 7 — User Rating Behavior
```sql
SELECT u.username,
       COUNT(r.rating_id) AS num_ratings_given,
       ROUND(AVG(r.rating_value), 2) AS avg_rating_given,
       ROUND(MIN(r.rating_value), 2) AS lowest_rating_given,
       ROUND(MAX(r.rating_value), 2) AS highest_rating_given
FROM user u
JOIN rating r ON r.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY num_ratings_given DESC;
```
**What it does:** Profiles each user's rating behavior — how many ratings, and the spread (min/avg/max).
**Optimization notes (from Phase 8 `EXPLAIN`):** Confirmed the join and `GROUP BY` both resolve via existing indexes (`rating.user_id`'s FK index) with no additional indexing needed at current data scale.

---

### Query 8 — Review Counts per Movie (Two-Hop Join)
```sql
SELECT m.title,
       COUNT(rv.review_id) AS num_reviews
FROM movie m
LEFT JOIN diary_entry de ON de.movie_id = m.movie_id
LEFT JOIN review rv ON rv.diary_entry_id = de.diary_entry_id
GROUP BY m.movie_id, m.title
ORDER BY num_reviews DESC, m.title ASC;
```
**What it does:** Counts reviews per movie, including movies with **zero** reviews (shown as 0, not excluded).
**Why it's here:** This is the schema's most instructive query for demonstrating the `Review → Diary_Entry → Movie` design decision from Phase 4 — because `review` has no direct `movie_id` column, reaching "reviews for this movie" *requires* the two-hop `LEFT JOIN` through `diary_entry`. Two `LEFT JOIN`s (not `INNER JOIN`) are essential here — an `INNER JOIN` would silently drop every movie with no diary entries or no reviews, breaking the "show zero too" requirement.

---

### Query 9 — Top 5 Movies (Minimum Rating Threshold via HAVING)
```sql
SELECT m.title,
       ROUND(AVG(r.rating_value), 2) AS avg_rating,
       COUNT(r.rating_id) AS num_ratings
FROM movie m
JOIN rating r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(r.rating_id) >= 3
ORDER BY avg_rating DESC
LIMIT 5;
```
**What it does:** Finds the top 5 movies by rating, but only among movies with at least 3 ratings — preventing a single 5-star rating on an obscure movie from dominating the leaderboard.
**Why it's here:** The canonical `WHERE` vs. `HAVING` teaching example — `HAVING` filters on an *aggregated* value (`COUNT(...)`) that doesn't exist until after `GROUP BY` runs, so it cannot be expressed in a `WHERE` clause.
**Optimization notes:** Confirmed during Phase 8 that indexing provides zero help to `HAVING` clauses specifically — the filter can only apply after aggregation completes, so no index on the base table can shortcut it.

---

## ADVANCED TIER

### Query 10 — User Activity Dashboard (Correlated Subqueries)
```sql
SELECT u.username,
       (SELECT COUNT(*) FROM diary_entry de WHERE de.user_id = u.user_id) AS num_diary_entries,
       (SELECT COUNT(*) FROM rating r WHERE r.user_id = u.user_id) AS num_ratings,
       (SELECT COUNT(*) FROM review rv 
          JOIN diary_entry de2 ON de2.diary_entry_id = rv.diary_entry_id 
          WHERE de2.user_id = u.user_id) AS num_reviews
FROM user u
ORDER BY num_diary_entries DESC
LIMIT 10;
```
**What it does:** For each user, three independent correlated subqueries count diary entries, ratings, and reviews.
**Why it's here:** Demonstrates correlated subqueries (each subquery references the outer query's `u.user_id`, re-running conceptually once per outer row) as an alternative to `JOIN + GROUP BY` — useful specifically when combining counts from tables that aren't directly joinable without risking row multiplication (joining `diary_entry`, `rating`, and `review` together directly would multiply rows incorrectly). This query later became `vw_user_activity_summary` (Phase 7).

---

### Query 11 — Mutual Followers (Two Techniques, Same Question)

**Approach A — Self-Join:**
```sql
SELECT u1.username AS user_a,
       u2.username AS user_b
FROM followers f1
JOIN followers f2 
    ON f1.follower_id = f2.followed_id 
   AND f1.followed_id = f2.follower_id
JOIN user u1 ON u1.user_id = f1.follower_id
JOIN user u2 ON u2.user_id = f1.followed_id
WHERE f1.follower_id < f1.followed_id
ORDER BY user_a, user_b;
```

**Approach B — Correlated Subquery (`EXISTS`):**
```sql
SELECT f1.follower_id, f1.followed_id
FROM followers f1
WHERE EXISTS (
    SELECT 1 FROM followers f2
    WHERE f2.follower_id = f1.followed_id
      AND f2.followed_id = f1.follower_id
)
ORDER BY f1.follower_id, f1.followed_id;
```
**What they do:** Both find pairs of users who follow *each other* (mutual follows), out of a table where following is normally one-directional.
**Why both are here:** This is the schema's `SELF JOIN` requirement, solved two ways on purpose — the self-join (`followers` joined to itself) directly pairs up reciprocal rows in one pass, while the `EXISTS` version asks the same question per-row without ever materializing the join. The `WHERE f1.follower_id < f1.followed_id` trick in Approach A is worth understanding on its own: without it, every mutual pair would appear twice (once in each direction) — the inequality guarantees each pair surfaces exactly once, by arbitrarily always listing the lower ID first.

---

## EXPERT TIER

### Query 12 — Top-Ranked Movie per Genre (CTE + Window Function)
```sql
WITH genre_movie_ratings AS (
    SELECT g.genre_name,
           m.title,
           ROUND(AVG(r.rating_value), 2) AS avg_rating,
           COUNT(r.rating_id) AS num_ratings
    FROM movie m
    JOIN movie_genre mg ON mg.movie_id = m.movie_id
    JOIN genre g ON g.genre_id = mg.genre_id
    JOIN rating r ON r.movie_id = m.movie_id
    GROUP BY g.genre_id, g.genre_name, m.movie_id, m.title
    HAVING COUNT(r.rating_id) >= 2
)
SELECT genre_name,
       title,
       avg_rating,
       num_ratings,
       RANK() OVER (PARTITION BY genre_name ORDER BY avg_rating DESC) AS rank_in_genre
FROM genre_movie_ratings
ORDER BY genre_name, rank_in_genre;
```
**What it does:** Ranks movies *within* each genre by rating (not overall) — answering "what's the best-rated Drama, the best-rated Comedy," etc., all in one query.
**Why it's here:** Combines a CTE (pre-aggregating ratings per genre/movie, with a `HAVING` floor to exclude near-zero-data movies) with `RANK() OVER (PARTITION BY ...)` — a window function that restarts its ranking counter for each genre partition, rather than ranking globally.
**Optimization notes (general, from Phase 8's broader findings):** Window function `PARTITION BY`/`ORDER BY` sort work is not something a base-table index can eliminate — the ranking happens on the CTE's already-computed result set, not on raw table rows.

---

### Query 13 — "Movies Your Follows Liked, That You Haven't Watched" (Recommendation Engine)
```sql
WITH followed_likes AS (
    SELECT f.follower_id AS user_id,
           m.movie_id,
           m.title
    FROM followers f
    JOIN review_like rl ON rl.user_id = f.followed_id
    JOIN review rv ON rv.review_id = rl.review_id
    JOIN diary_entry de ON de.diary_entry_id = rv.diary_entry_id
    JOIN movie m ON m.movie_id = de.movie_id
)
SELECT u.username,
       fl.title AS recommended_movie,
       COUNT(*) AS liked_by_followed_count
FROM followed_likes fl
JOIN user u ON u.user_id = fl.user_id
WHERE NOT EXISTS (
    SELECT 1
    FROM diary_entry de2
    WHERE de2.user_id = fl.user_id
      AND de2.movie_id = fl.movie_id
)
GROUP BY fl.user_id, u.username, fl.movie_id, fl.title
ORDER BY u.username, liked_by_followed_count DESC;
```
**What it does:** For each user, recommends movies that people *they follow* have liked (via reviews), excluding anything the user has already logged themselves.
**Why it's here:** The most complex query in the project — a CTE chains four joins (`followers → review_like → review → diary_entry → movie`) to trace "what did people I follow like," then a `NOT EXISTS` anti-join filters out movies the user already has a diary entry for. This is a genuine, realistic feature query (a real recommendation engine would run something structurally similar), not an artificial demonstration of syntax. It also indirectly exercises the `Review → Diary_Entry` join path a third time in this showcase (Queries 8 and 13), reinforcing how central that design decision is to nearly every content-retrieval query in this schema.

---

## Summary Table

| # | Tier | SQL Features Demonstrated |
|---|---|---|
| 1 | Beginner | `WHERE`, multi-column `ORDER BY` |
| 2 | Beginner | `OR`, `LIKE`, `IS NULL` |
| 3 | Beginner | Aggregate functions, no `GROUP BY` |
| 4 | Intermediate | Multi-table `JOIN`, `GROUP BY` |
| 5 | Intermediate | `JOIN` + `GROUP BY` + `ORDER BY` (became a View) |
| 6 | Intermediate | `COUNT(DISTINCT ...)` |
| 7 | Intermediate | `MIN`/`MAX`/`AVG` together |
| 8 | Intermediate | Two-hop `LEFT JOIN`, zero-inclusive counts |
| 9 | Intermediate | `HAVING` vs. `WHERE` |
| 10 | Advanced | Correlated subqueries ×3 (became a View) |
| 11 | Advanced | `SELF JOIN` vs. `EXISTS` (two solutions, one problem) |
| 12 | Expert | CTE + `RANK() OVER (PARTITION BY ...)` |
| 13 | Expert | CTE + multi-table join chain + `NOT EXISTS` anti-join |
