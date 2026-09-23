-- ============================================================================
-- 10. SOCIAL MEDIA ANALYTICS BACKEND
-- File: 02_triggers.sql
-- Tool: PostgreSQL
-- Description: PL/pgSQL Functions and Triggers to Automatically Update Like
--              and Comment Counts on Posts
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. TRIGGER FUNCTION FOR LIKE COUNTS
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_maintain_post_like_count()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE posts
        SET like_count = like_count + 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE post_id = NEW.post_id;
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE posts
        SET like_count = GREATEST(0, like_count - 1),
            updated_at = CURRENT_TIMESTAMP
        WHERE post_id = OLD.post_id;
        RETURN OLD;

    ELSIF (TG_OP = 'UPDATE') THEN
        IF OLD.post_id <> NEW.post_id THEN
            -- Decrement old post count
            UPDATE posts
            SET like_count = GREATEST(0, like_count - 1),
                updated_at = CURRENT_TIMESTAMP
            WHERE post_id = OLD.post_id;

            -- Increment new post count
            UPDATE posts
            SET like_count = like_count + 1,
                updated_at = CURRENT_TIMESTAMP
            WHERE post_id = NEW.post_id;
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Bind trigger to LIKES table
DROP TRIGGER IF EXISTS trg_likes_count_update ON likes;
CREATE TRIGGER trg_likes_count_update
AFTER INSERT OR DELETE OR UPDATE ON likes
FOR EACH ROW
EXECUTE FUNCTION fn_maintain_post_like_count();


-- ----------------------------------------------------------------------------
-- 2. TRIGGER FUNCTION FOR COMMENT COUNTS
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_maintain_post_comment_count()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE posts
        SET comment_count = comment_count + 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE post_id = NEW.post_id;
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE posts
        SET comment_count = GREATEST(0, comment_count - 1),
            updated_at = CURRENT_TIMESTAMP
        WHERE post_id = OLD.post_id;
        RETURN OLD;

    ELSIF (TG_OP = 'UPDATE') THEN
        IF OLD.post_id <> NEW.post_id THEN
            -- Decrement old post count
            UPDATE posts
            SET comment_count = GREATEST(0, comment_count - 1),
                updated_at = CURRENT_TIMESTAMP
            WHERE post_id = OLD.post_id;

            -- Increment new post count
            UPDATE posts
            SET comment_count = comment_count + 1,
                updated_at = CURRENT_TIMESTAMP
            WHERE post_id = NEW.post_id;
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Bind trigger to COMMENTS table
DROP TRIGGER IF EXISTS trg_comments_count_update ON comments;
CREATE TRIGGER trg_comments_count_update
AFTER INSERT OR DELETE OR UPDATE ON comments
FOR EACH ROW
EXECUTE FUNCTION fn_maintain_post_comment_count();


-- ----------------------------------------------------------------------------
-- 3. AUDIT & RE-SYNC FUNCTION (Utility function for data integrity)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_recalculate_post_engagement(p_post_id BIGINT)
RETURNS TABLE (
    target_post_id BIGINT,
    actual_likes BIGINT,
    actual_comments BIGINT,
    status_msg TEXT
) AS $$
DECLARE
    v_likes BIGINT;
    v_comments BIGINT;
BEGIN
    SELECT COUNT(*) INTO v_likes FROM likes WHERE post_id = p_post_id;
    SELECT COUNT(*) INTO v_comments FROM comments WHERE post_id = p_post_id;

    UPDATE posts
    SET like_count = v_likes,
        comment_count = v_comments,
        updated_at = CURRENT_TIMESTAMP
    WHERE post_id = p_post_id;

    RETURN QUERY
    SELECT p_post_id, v_likes, v_comments, 'Counts synchronized successfully'::TEXT;
END;
$$ LANGUAGE plpgsql;
