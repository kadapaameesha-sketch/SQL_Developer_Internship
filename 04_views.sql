-- ============================================================================
-- 10. SOCIAL MEDIA ANALYTICS BACKEND
-- File: 04_views.sql
-- Tool: PostgreSQL
-- Description: Views for Top Posts, Engagement Scores, and Creator Metrics
-- ============================================================================

-- Drop views if existing (in reverse dependency order)
DROP VIEW IF EXISTS vw_category_engagement_stats CASCADE;
DROP VIEW IF EXISTS vw_creator_performance CASCADE;
DROP VIEW IF EXISTS vw_top_performing_posts CASCADE;
DROP VIEW IF EXISTS vw_post_engagement_summary CASCADE;


-- ----------------------------------------------------------------------------
-- 1. POST ENGAGEMENT SUMMARY VIEW
-- Formula: Engagement Score = (like_count * 1.0) + (comment_count * 2.5)
-- Comments are weighted higher due to higher user effort/intent.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_post_engagement_summary AS
SELECT 
    p.post_id,
    p.user_id AS author_id,
    u.username AS author_username,
    u.full_name AS author_name,
    p.title,
    p.category,
    p.like_count,
    p.comment_count,
    (p.like_count + p.comment_count) AS total_interactions,
    ROUND(
        (p.like_count * 1.0) + (p.comment_count * 2.5), 
        2
    ) AS engagement_score,
    ROUND(
        ((p.like_count * 1.0) + (p.comment_count * 2.5)) / 
        GREATEST(1, EXTRACT(DAY FROM (CURRENT_TIMESTAMP - p.created_at)) + 1),
        2
    ) AS daily_engagement_velocity,
    p.status,
    p.created_at
FROM posts p
JOIN users u ON p.user_id = u.user_id;


-- ----------------------------------------------------------------------------
-- 2. TOP PERFORMING POSTS VIEW
-- Filters posts performing above the overall platform average engagement
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_top_performing_posts AS
SELECT 
    post_id,
    author_username,
    title,
    category,
    like_count,
    comment_count,
    total_interactions,
    engagement_score,
    created_at
FROM vw_post_engagement_summary
WHERE engagement_score >= (
    SELECT AVG((like_count * 1.0) + (comment_count * 2.5)) FROM posts
)
ORDER BY engagement_score DESC;


-- ----------------------------------------------------------------------------
-- 3. CREATOR PERFORMANCE VIEW
-- Aggregates engagement and reach at the user/creator level
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_creator_performance AS
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    u.country,
    COUNT(p.post_id) AS total_posts_created,
    COALESCE(SUM(p.like_count), 0) AS total_likes_received,
    COALESCE(SUM(p.comment_count), 0) AS total_comments_received,
    COALESCE(SUM(p.like_count + p.comment_count), 0) AS total_interactions,
    ROUND(
        COALESCE(SUM((p.like_count * 1.0) + (p.comment_count * 2.5)), 0), 
        2
    ) AS total_engagement_score,
    ROUND(
        COALESCE(AVG((p.like_count * 1.0) + (p.comment_count * 2.5)), 0), 
        2
    ) AS avg_engagement_per_post
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.full_name, u.country;


-- ----------------------------------------------------------------------------
-- 4. CATEGORY ENGAGEMENT STATS VIEW
-- Analyzes content performance broken down by post category
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_category_engagement_stats AS
SELECT 
    category,
    COUNT(post_id) AS total_posts,
    SUM(like_count) AS total_likes,
    SUM(comment_count) AS total_comments,
    SUM(like_count + comment_count) AS total_interactions,
    ROUND(AVG(like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(comment_count), 2) AS avg_comments_per_post,
    ROUND(AVG((like_count * 1.0) + (comment_count * 2.5)), 2) AS avg_category_engagement_score
FROM posts
GROUP BY category;
