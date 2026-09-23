-- ============================================================================
-- 10. SOCIAL MEDIA ANALYTICS BACKEND
-- File: 05_window_rankings.sql
-- Tool: PostgreSQL
-- Description: Advanced Window Function Queries for Post & Creator Rankings
-- ============================================================================

-- ----------------------------------------------------------------------------
-- QUERY 1: CATEGORY & GLOBAL POST RANKINGS
-- Demonstrates ROW_NUMBER(), RANK(), and DENSE_RANK() across post categories
-- ----------------------------------------------------------------------------
SELECT 
    category,
    post_id,
    title,
    author_username,
    engagement_score,
    ROW_NUMBER() OVER (
        PARTITION BY category 
        ORDER BY engagement_score DESC, post_id ASC
    ) AS category_row_num,

    RANK() OVER (
        PARTITION BY category 
        ORDER BY engagement_score DESC
    ) AS category_rank,

    DENSE_RANK() OVER (
        PARTITION BY category 
        ORDER BY engagement_score DESC
    ) AS category_dense_rank,

    DENSE_RANK() OVER (
        ORDER BY engagement_score DESC
    ) AS global_overall_rank
FROM vw_post_engagement_summary
ORDER BY category, category_dense_rank;


-- ----------------------------------------------------------------------------
-- QUERY 2: CREATOR QUARTILE TIERING (NTILE)
-- Categorizes content creators into 4 performance quartiles
-- ----------------------------------------------------------------------------
SELECT 
    user_id,
    username,
    full_name,
    total_posts_created,
    total_engagement_score,
    NTILE(4) OVER (
        ORDER BY total_engagement_score DESC
    ) AS creator_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY total_engagement_score DESC) = 1 THEN 'Tier 1: Top Influencer'
        WHEN NTILE(4) OVER (ORDER BY total_engagement_score DESC) = 2 THEN 'Tier 2: High Performer'
        WHEN NTILE(4) OVER (ORDER BY total_engagement_score DESC) = 3 THEN 'Tier 3: Moderate Creator'
        ELSE 'Tier 4: Emerging Creator'
    END AS creator_tier
FROM vw_creator_performance
WHERE total_posts_created > 0
ORDER BY creator_quartile ASC, total_engagement_score DESC;


-- ----------------------------------------------------------------------------
-- QUERY 3: PERCENTILE & CUMULATIVE DISTRIBUTION OF POSTS
-- Calculates PERCENT_RANK() and CUME_DIST() for post engagement
-- ----------------------------------------------------------------------------
SELECT 
    post_id,
    title,
    category,
    engagement_score,
    ROUND(
        (PERCENT_RANK() OVER (ORDER BY engagement_score ASC))::NUMERIC, 
        4
    ) AS percentile_rank,
    ROUND(
        (CUME_DIST() OVER (ORDER BY engagement_score ASC))::NUMERIC, 
        4
    ) AS cumulative_distribution,
    CASE 
        WHEN CUME_DIST() OVER (ORDER BY engagement_score ASC) >= 0.90 THEN 'Top 10% Viral Post'
        WHEN CUME_DIST() OVER (ORDER BY engagement_score ASC) >= 0.75 THEN 'Top 25% High Performing'
        ELSE 'Standard Post'
    END AS performance_badge
FROM vw_post_engagement_summary
ORDER BY engagement_score DESC;


-- ----------------------------------------------------------------------------
-- QUERY 4: AUTHOR POST PERFORMANCE TRAJECTORY (LAG / LEAD)
-- Compares each post against the author's previous post to measure growth
-- ----------------------------------------------------------------------------
SELECT 
    author_username,
    post_id,
    title,
    created_at,
    engagement_score,
    LAG(engagement_score, 1) OVER (
        PARTITION BY author_id 
        ORDER BY created_at ASC
    ) AS prev_post_engagement,
    
    ROUND(
        (engagement_score - LAG(engagement_score, 1) OVER (
            PARTITION BY author_id 
            ORDER BY created_at ASC
        )), 
        2
    ) AS engagement_growth_delta,

    ROUND(
        EXTRACT(EPOCH FROM (created_at - LAG(created_at, 1) OVER (
            PARTITION BY author_id 
            ORDER BY created_at ASC
        ))) / 86400.0,
        1
    ) AS days_since_last_post
FROM vw_post_engagement_summary
ORDER BY author_username, created_at ASC;


-- ----------------------------------------------------------------------------
-- QUERY 5: 3-POST MOVING AVERAGE & RUNNING TOTAL PER CREATOR
-- Calculates windowed moving average engagement per author
-- ----------------------------------------------------------------------------
SELECT 
    author_username,
    post_id,
    title,
    created_at,
    engagement_score,
    SUM(engagement_score) OVER (
        PARTITION BY author_id 
        ORDER BY created_at ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_creator_engagement,

    ROUND(
        AVG(engagement_score) OVER (
            PARTITION BY author_id 
            ORDER BY created_at ASC
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_3_posts
FROM vw_post_engagement_summary
ORDER BY author_username, created_at ASC;
