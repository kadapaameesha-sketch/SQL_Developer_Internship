# 📊 Social Media Analytics Backend

### 📊 SQL Developer Internship — Task 10

**By K. Ameesha**

A PostgreSQL project for tracking post engagement and finding top-performing social media content.

---

## 🎯 Objective

Create a SQL system to track and analyze likes, comments, and overall post engagement.

## 🛠️ Tools

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)

## ✨ Features

❤️ Track likes on posts  
💬 Store comments  
👤 Connect users with their posts and activity  
📈 Calculate engagement scores  
🏆 Rank top-performing posts with window functions  
⚙️ Update like counts automatically using triggers  
📤 Generate engagement reports

## 🗂️ Database Design

| Table | Description |
|---|---|
| 👤 `users` | User account details |
| 📝 `posts` | Posts created by users |
| ❤️ `likes` | Likes given to posts |
| 💬 `comments` | Comments on posts |

## 📁 Project Files

📦 social-media-analytics  
 ┣ 📜 01_schema_design.sql  
 ┣ 📜 02_triggers.sql  
 ┣ 📜 03_seed_data.sql  
 ┣ 📜 04_views.sql  
 ┣ 📜 05_window_rankings.sql  
 ┣ 📜 06_engagement_reports.sql  
 ┣ 📄 Brand Guidelines  
 ┣ 📄 GEMINI.md  
 ┗ 📄 README.md  


## 🚀 Getting Started

1. Create a PostgreSQL database.
2. Run the schema script.
3. Insert the sample data.
4. Run the views and trigger scripts.
5. Execute the analytics queries to explore engagement.

## 📊 Example Ranking Query

```sql
SELECT
    post_id,
    engagement_score,
    RANK() OVER (ORDER BY engagement_score DESC) AS engagement_rank
FROM post_engagement;
```

## 📦 Deliverables

- Database design for users, posts, likes, and comments
- Views for top posts and engagement scores
- Ranking queries using window functions
- Triggers for maintaining like counts
- Engagement data reports

## 🎯 Project Goal

Turn social media activity into clear, useful engagement insights.
