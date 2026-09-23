-- ============================================================================
-- 10. SOCIAL MEDIA ANALYTICS BACKEND
-- File: 06_engagement_reports.sql
-- Tool: PostgreSQL
-- Description: Executive Analytical Reports & Actionable Insight Queries
-- ============================================================================

-- ----------------------------------------------------------------------------
-- REPORT 1: EXECUTIVE PLATFORM ENGAGEMENT KPI OVERVIEW
-- High-level summary dashboard metrics for platform health
-- ----------------------------------------------------------------------------
SELECT 
    (SELECT COUNT(*) FROM users WHERE is_active = TRUE) AS total_active_users,
    (SELECT COUNT(*) FROM posts WHERE status = 'published') AS total_published_posts,
    (SELECT COUNT(*) FROM likes) AS total_likes_given,
    (SELECT COUNT(*) FROM comments) AS total_comments_written,
    (SELECT ROUND(SUM((like_count * 1.0) + (comment_count * 2.5)), 2) FROM posts) AS total_platform_engagement_score,
    (SELECT ROUND(AVG(like_count + comment_count), 2) FROM posts) AS avg_interactions_per_post,
    (SELECT ROUND(COUNT(likes.like_id)::NUMERIC / NULLIF(COUNT(comments.comment_id), 0), 2) FROM likes FULL OUTER JOIN comments ON 1=1) AS overall_like_to_comment_ratio;


-- ----------------------------------------------------------------------------
-- REPORT 2: CATEGORY PERFORMANCE LEADERBOARD REPORT
-- Complete analytical breakdown of post categories with top post details
-- ----------------------------------------------------------------------------
WITH CategoryStats AS (
    SELECT 
        category,
        COUNT(post_id) AS total_posts,
        SUM(like_count) AS total_likes,
        SUM(comment_count) AS total_comments,
        ROUND(AVG((like_count * 1.0) + (comment_count * 2.5)), 2) AS avg_engagement_score
    FROM posts
    GROUP BY category
),
TopCategoryPosts AS (
    SELECT 
        category,
        title AS top_post_title,
        ROUND((like_count * 1.0) + (comment_count * 2.5), 2) AS top_post_score,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY (like_count * 1.0) + (comment_count * 2.5) DESC) AS rn
    FROM posts
)
SELECT 
    cs.category,
    cs.total_posts,
    cs.total_likes,
    cs.total_comments,
    cs.avg_engagement_score,
    tcp.top_post_title,
    tcp.top_post_score
FROM CategoryStats cs
JOIN TopCategoryPosts tcp ON cs.category = tcp.category AND tcp.rn = 1
ORDER BY cs.avg_engagement_score DESC;


-- ----------------------------------------------------------------------------
-- REPORT 3: CREATOR - COMMUNITY FAN INTERACTION MATRIX
-- Identifies top engaged followers (fans who comment & like most on a creator's posts)
-- ----------------------------------------------------------------------------
WITH FanInteractions AS (
    -- Likes interactions
    SELECT 
        p.user_id AS creator_id,
        l.user_id AS fan_id,
        COUNT(l.like_id) AS likes_given,
        0 AS comments_written
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE l.user_id <> p.user_id -- Exclude self-likes
    GROUP BY p.user_id, l.user_id

    UNION ALL

    -- Comments interactions
    SELECT 
        p.user_id AS creator_id,
        c.user_id AS fan_id,
        0 AS likes_given,
        COUNT(c.comment_id) AS comments_written
    FROM comments c
    JOIN posts p ON c.post_id = p.post_id
    WHERE c.user_id <> p.user_id -- Exclude self-comments
    GROUP BY p.user_id, c.user_id
)
SELECT 
    u_creator.username AS creator_username,
    u_fan.username AS top_fan_username,
    SUM(fi.likes_given) AS total_likes_from_fan,
    SUM(fi.comments_written) AS total_comments_from_fan,
    SUM(fi.likes_given) + (SUM(fi.comments_written) * 2) AS fan_loyalty_score,
    DENSE_RANK() OVER (
        PARTITION BY u_creator.username 
        ORDER BY (SUM(fi.likes_given) + (SUM(fi.comments_written) * 2)) DESC
    ) AS fan_rank
FROM FanInteractions fi
JOIN users u_creator ON fi.creator_id = u_creator.user_id
JOIN users u_fan ON fi.fan_id = u_fan.user_id
GROUP BY u_creator.username, u_fan.username
HAVING SUM(fi.likes_given) + SUM(fi.comments_written) > 0
ORDER BY creator_username, fan_rank
LIMIT 20;


-- ----------------------------------------------------------------------------
-- REPORT 4: TIME-OF-DAY ENGAGEMENT HEATMAP REPORT
-- Identifies peak posting hours for maximum community engagement
-- ----------------------------------------------------------------------------
SELECT 
    EXTRACT(HOUR FROM p.created_at) AS post_hour_utc,
    COUNT(p.post_id) AS posts_published,
    SUM(p.like_count) AS total_likes_received,
    SUM(p.comment_count) AS total_comments_received,
    ROUND(AVG((p.like_count * 1.0) + (p.comment_count * 2.5)), 2) AS avg_engagement_per_post,
    CASE 
        WHEN EXTRACT(HOUR FROM p.created_at) BETWEEN 6 AND 11 THEN 'Morning Peak'
        WHEN EXTRACT(HOUR FROM p.created_at) BETWEEN 12 AND 17 THEN 'Afternoon Peak'
        WHEN EXTRACT(HOUR FROM p.created_at) BETWEEN 18 AND 23 THEN 'Evening Peak'
        ELSE 'Night Off-Peak'
    END AS time_of_day_segment
FROM posts p
GROUP BY EXTRACT(HOUR FROM p.created_at)
ORDER BY avg_engagement_per_post DESC;
