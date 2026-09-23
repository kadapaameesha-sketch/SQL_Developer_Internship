-- ============================================================================
-- 10. SOCIAL MEDIA ANALYTICS BACKEND
-- File: 01_schema_design.sql
-- Tool: PostgreSQL
-- Description: Core Schema Definition for Users, Posts, Likes, and Comments
-- ============================================================================

-- Drop existing tables if re-running script (in reverse dependency order)
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS likes CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. USERS TABLE
CREATE TABLE users (
    user_id         BIGSERIAL PRIMARY KEY,
    username        VARCHAR(50) NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL UNIQUE,
    full_name       VARCHAR(100) NOT NULL,
    bio             TEXT,
    country         VARCHAR(50) DEFAULT 'USA',
    created_at      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active       BOOLEAN DEFAULT TRUE
);

-- 2. POSTS TABLE
CREATE TABLE posts (
    post_id         BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title           VARCHAR(255) NOT NULL,
    content         TEXT NOT NULL,
    category        VARCHAR(50) NOT NULL CHECK (category IN ('Tech', 'Lifestyle', 'Science', 'Gaming', 'Travel', 'Education', 'Entertainment')),
    media_url       VARCHAR(255),
    like_count      INT DEFAULT 0 CHECK (like_count >= 0),
    comment_count   INT DEFAULT 0 CHECK (comment_count >= 0),
    status          VARCHAR(20) DEFAULT 'published' CHECK (status IN ('published', 'archived', 'draft')),
    created_at      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. LIKES TABLE
CREATE TABLE likes (
    like_id         BIGSERIAL PRIMARY KEY,
    post_id         BIGINT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
    user_id         BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    -- Prevent duplicate likes by the same user on the same post
    CONSTRAINT uk_post_user_like UNIQUE (post_id, user_id)
);

-- 4. COMMENTS TABLE
CREATE TABLE comments (
    comment_id        BIGSERIAL PRIMARY KEY,
    post_id           BIGINT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
    user_id           BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    parent_comment_id BIGINT REFERENCES comments(comment_id) ON DELETE CASCADE, -- Self-referential for threaded comments
    content           TEXT NOT NULL,
    created_at        TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES FOR QUERY OPTIMIZATION
-- ============================================================================

-- Foreign key lookup indexes
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_likes_post_id ON likes(post_id);
CREATE INDEX idx_likes_user_id ON likes(user_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_parent_id ON comments(parent_comment_id);

-- Analytics & Window Query optimization indexes
CREATE INDEX idx_posts_category_created ON posts(category, created_at DESC);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_likes_created_at ON likes(created_at DESC);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

COMMENT ON TABLE users IS 'User profiles and account metadata';
COMMENT ON TABLE posts IS 'Social media posts created by users with cached engagement counters';
COMMENT ON TABLE likes IS 'User reactions (likes) given to specific posts';
COMMENT ON TABLE comments IS 'Top-level and threaded comments on posts';
