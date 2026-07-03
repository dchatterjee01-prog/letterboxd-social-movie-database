# Normalization Report
### Letterboxd-Inspired Movie Social Database
### Schema verified against: `schema_reference.sql` (live-tested, MySQL 8.0.46)

---

## 1. Methodology

This report proves that all 29 tables in the final schema satisfy First, Second, and Third Normal Form, and Boyce-Codd Normal Form where composite keys create the possibility of a violation. Each proof works from the **actual, current column list and primary key** of the live schema — not the original Phase 3 design — since two tables (`review`, and the composite keys of `movie_cast`/`movie_crew`) changed during the build process. Where a design decision from Phases 1–4 directly explains why a table is shaped the way it is, that decision is cited rather than re-argued.

**Definitions used:**
- **1NF**: Every column holds a single, atomic value; no repeating groups; every row is uniquely identifiable.
- **2NF**: Every non-key attribute depends on the *whole* primary key, not a subset of it. Only meaningful to test on tables with a **composite** primary key — single-column surrogate-key tables satisfy 2NF automatically.
- **3NF**: Every non-key attribute depends on the primary key *directly*, not transitively through another non-key attribute.
- **BCNF**: Every determinant (any column or column-set that determines another column) must itself be a candidate key.

---

## 2. First Normal Form (1NF) — All 29 Tables

**Proof:** Every column in every table stores a single atomic value (no comma-separated lists, no repeating groups of columns like `genre_1, genre_2, genre_3`). Every table has a declared primary key guaranteeing row uniqueness.

The clearest evidence of 1NF-by-design is what does **not** exist in this schema: there is no `genres` column on `movie` holding `"Action, Sci-Fi, Thriller"`, no `cast_list` column holding a delimited string of actor names, no `tags` column on `diary_entry` holding freeform comma-separated text. Every one of these multi-valued relationships was deliberately resolved into its own table during Phase 1–2 (`movie_genre`, `movie_cast`, `diary_entry_tag`, etc.) specifically to satisfy 1NF from the start, rather than needing correction later.

**Verdict: All 29 tables satisfy 1NF.**

---

## 3. Second Normal Form (2NF) — The 11 Composite-Key Tables

2NF only applies where a partial dependency is *possible* — i.e., where the primary key has more than one column. The following tables are tested individually; every other table (18 of them) uses a single-column surrogate key and satisfies 2NF trivially.

| Table | Composite PK | Non-key attribute(s) | Partial dependency check | Verdict |
|---|---|---|---|---|
| `movie_genre` | `(movie_id, genre_id)` | none | N/A — no non-key attributes exist to test | ✅ 2NF |
| `movie_studio` | `(movie_id, studio_id)` | none | N/A | ✅ 2NF |
| `favorite_genre` | `(user_id, genre_id)` | none | N/A | ✅ 2NF |
| `collection_movie` | `(collection_id, movie_id)` | none | N/A | ✅ 2NF |
| `diary_entry_tag` | `(diary_entry_id, tag_id)` | none | N/A | ✅ 2NF |
| `watchlist` | `(user_id, movie_id)` | `date_added` | Depends on *when this specific user added this specific movie* — genuinely requires both key columns together. Not derivable from `user_id` alone (different per movie) or `movie_id` alone (different per user). | ✅ 2NF |
| `review_like` | `(user_id, review_id)` | `liked_at` | Same reasoning as `watchlist` — the timestamp is a fact about this specific (user, review) pairing, not about either user or review in isolation. | ✅ 2NF |
| `followers` | `(follower_id, followed_id)` | `followed_at` | Depends on the specific follow relationship (this follower following this followed-user), not on either `user_id` alone. | ✅ 2NF |
| `list_movie` | `(list_id, movie_id)` | `position`, `added_at` | Both attributes describe this movie's placement *within this specific list* — a movie's position on List A is independent of its position on List B, so it cannot depend on `movie_id` alone; nor can it depend on `list_id` alone (a list has many movies, each with a different position). | ✅ 2NF |
| `movie_cast` | `(movie_id, actor_id, character_name)` | `billing_order` | `billing_order` describes this actor's billing position *for this specific movie and this specific character* (supporting the dual-role decision from Phase 4) — depends on the full three-column key, not any subset. | ✅ 2NF |
| `movie_crew` | `(movie_id, director_id, job_title)` | none | N/A — the composite key itself (movie + person + role) is the complete fact being recorded | ✅ 2NF |

**Verdict: All 11 composite-key tables satisfy 2NF.** Every non-key attribute present was deliberately checked against the *full* key, not a subset — this is precisely why `character_name` and `job_title` were folded into the primary keys of `movie_cast`/`movie_crew` during Phase 4 (to support dual roles and multi-role crew members) rather than being left as ordinary non-key columns that would have created ambiguity about what they depend on.

---

## 4. Third Normal Form (3NF) — The 18 Single-Surrogate-Key Tables

3NF is tested by checking whether every non-key column depends on the primary key *directly*, or transitively through some other non-key column. The most instructive proofs are the ones where a transitive dependency was consciously *avoided* by a Phase 1–3 design decision — those are called out explicitly below.

| Table | Non-key attributes | Transitive dependency check | Verdict |
|---|---|---|---|
| `country` | `country_name` | Single non-key attribute — no other column for it to depend on transitively | ✅ 3NF |
| `language` | `language_name` | Same reasoning | ✅ 3NF |
| `genre` | `genre_name` | Same reasoning | ✅ 3NF |
| `tag` | `tag_name` | Same reasoning | ✅ 3NF |
| `actor` | `full_name`, `birth_date`, `bio` | All three describe the actor as a person — none depends on another non-key column (e.g. `bio` doesn't depend on `birth_date`) | ✅ 3NF |
| `director` | `full_name`, `birth_date`, `bio` | Same reasoning as `actor` | ✅ 3NF |
| `studio` | `studio_name`, `founded_year`, `country_id` | **Key proof**: `founded_year` could easily have been left off `studio` and instead inferred from something else, but there's no other non-key column here it could transitively depend on. `country_id` is itself a foreign key, not a transitive path to another studio attribute. This table is exactly what `movie` would have violated 3NF by resembling, had `studio_name` and `studio_founded_year` been columns directly on `movie` instead (see the worked hypothetical in Phase 3) | ✅ 3NF |
| `user` | `username`, `email`, `password_hash`, `bio`, `avatar_url`, `join_date` | Each is an independent fact about the user; none is derivable from another (e.g. `avatar_url` doesn't depend on `email`) | ✅ 3NF |
| `movie` | `title`, `release_year`, `runtime_minutes`, `synopsis`, `poster_url`, `country_id`, `language_id`, `created_at` | **Key proof, directly tied to the schema's actual history**: had `country_name` or `language_name` been stored directly on `movie` instead of via `country_id`/`language_id` foreign keys, this would create the exact transitive dependency demonstrated in Phase 3's worked example (`movie_id → country_id → country_name`). Storing only the FK, not the looked-up name, is what keeps this table in 3NF | ✅ 3NF |
| `diary_entry` | `user_id`, `movie_id`, `watched_date`, `is_rewatch`, `created_at` | All four non-key attributes describe this specific viewing event directly; none depends on another non-key column | ✅ 3NF |
| `review` | `diary_entry_id`, `review_text`, `contains_spoilers`, `created_at`, `updated_at` | **Key proof, reflecting the mid-project design pivot**: because `review` stores only `diary_entry_id` — not `user_id`/`movie_id` directly — there is no transitive path at all from `review_id` through `diary_entry_id` to a duplicated `user_id`/`movie_id`. Had the original design (Review tied directly to `user_id` + `movie_id`) been kept *alongside* a `diary_entry_id` column, that would have created redundant, potentially-inconsistent data — a textbook 3NF violation. The pivot to `diary_entry_id`-only is what keeps this table clean | ✅ 3NF |
| `rating` | `user_id`, `movie_id`, `rating_value`, `rated_at` | `rating_value` and `rated_at` both describe this specific rating event; neither depends on `user_id` or `movie_id` alone, and there's no other non-key column for a transitive path to run through | ✅ 3NF |
| `movie_list` | `user_id`, `list_name`, `description`, `visibility`, `created_at` | Each attribute is a direct fact about this list; none is derivable from another | ✅ 3NF |
| `notification` | `user_id`, `notification_type`, `message`, `is_read`, `created_at` | Each attribute describes the notification event directly | ✅ 3NF |
| `activity_log` | `user_id`, `action_type`, `action_details`, `created_at` | Same reasoning | ✅ 3NF |
| `report` | `user_id`, `reported_review_id`, `reported_comment_id`, `reason`, `status`, `created_at` | All attributes describe this specific report directly. Note: the *exactly-one-target* business rule (Known Issue #2) is enforced via triggers rather than functional dependency, and is a business-logic constraint, not a normalization concern — it doesn't affect this proof | ✅ 3NF |
| `review_comment` | `user_id`, `review_id`, `comment_text`, `created_at` | Each attribute is a direct fact about this specific comment | ✅ 3NF |
| `movie_collection` | `collection_name`, `description`, `created_at` | Each attribute describes the collection directly; no transitive path exists | ✅ 3NF |

**Verdict: All 18 single-surrogate-key tables satisfy 3NF.**

---

## 5. Boyce-Codd Normal Form (BCNF)

BCNF is a stricter version of 3NF: it additionally requires that *every* determinant — not just ones involving the primary key — be a candidate key. A BCNF violation can only occur when a table has **more than one candidate key**, or when a non-key subset of a composite key determines another attribute in the same table.

**Checking the 11 composite-key tables for hidden determinants:**

- `movie_cast (movie_id, actor_id, character_name) → billing_order`: does any subset of the key determine `billing_order` on its own? No — the same actor's billing order varies by movie, and the same character name could theoretically recur across different movies with no consistent billing. No hidden determinant.
- `list_movie (list_id, movie_id) → position, added_at`: does `list_id` alone determine `position`? No — a single list has many movies, each with its own position. Does `movie_id` alone determine `position`? No — the same movie has different positions on different lists. No hidden determinant.
- `followers (follower_id, followed_id) → followed_at`: neither column alone determines the timestamp (a user's follow timestamp varies by relationship). No hidden determinant.
- All remaining composite-key tables (`movie_genre`, `movie_studio`, `favorite_genre`, `collection_movie`, `diary_entry_tag`, `movie_crew`, `watchlist`, `review_like`) either have no non-key attributes at all, or were already shown under 2NF to require the full key — meaning there is no smaller determinant to test.

**Checking the 18 single-surrogate-key tables:** each has exactly one candidate key structure (the surrogate PK, plus in most cases one `UNIQUE` constraint — e.g. `user.username`, `user.email`, `genre.genre_name`). Where a table has two candidate keys (like `user`, with `user_id` as PK and both `username` and `email` independently unique), BCNF requires checking whether either alternate candidate key determines something the other doesn't cover — in `user`'s case, both `username` and `email` uniquely identify the same single row and the same full attribute set, so there's no partial determination issue.

**Verdict: All 29 tables satisfy BCNF. No hidden or non-candidate-key determinants were found anywhere in the schema.**

---

## 6. Summary Matrix

| Normal Form | Tables Satisfying | Notes |
|---|---|---|
| 1NF | 29 / 29 | By construction — every multi-valued relationship resolved into its own table from Phase 1–2 |
| 2NF | 29 / 29 | 11 composite-key tables individually verified; 18 surrogate-key tables trivially satisfy |
| 3NF | 29 / 29 | Includes 2 tables (`studio`, `movie`) that directly demonstrate the transitive-dependency trap this schema was designed to avoid |
| BCNF | 29 / 29 | No table has a non-candidate-key determinant |

---

## 7. Two Notes on Scope

**This is a normalization report, not a data-integrity report.** Known Issue #9 (the `movie.release_year` dead-code CHECK bug, fixed via `ALTER TABLE ... MODIFY COLUMN`) was a **data type / constraint reachability problem**, not a normalization violation — `release_year` was always correctly a direct, non-transitive attribute of `movie`, regardless of whether it was typed as `YEAR` or `SMALLINT UNSIGNED`. The two issues are unrelated, and it's worth being precise about that distinction in submission, since conflating "the CHECK didn't fire" with "the table wasn't normalized" would be a real conceptual error.

**Deliberate denormalization was NOT used anywhere in this schema.** Some production systems intentionally denormalize for read-performance reasons (e.g. storing a cached `avg_rating` directly on `movie` instead of always computing it via `rating`). This schema does not do that — `vw_movie_ratings_summary` (Phase 7) computes averages via a view instead, keeping the base tables fully normalized while still offering fast, pre-built access to the aggregate. This is a deliberate trade-off worth mentioning if asked why no cached aggregate columns exist anywhere in the schema.
