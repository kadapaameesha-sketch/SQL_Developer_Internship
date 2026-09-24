📊 Social Media Analytics Backend
An end-to-end relational database system designed in PostgreSQL to model core social networking interactions and track real-time post engagement metrics. This system implements automated engagement counters, rank-based analytics using window functions, and consolidated views for user activity reporting.

🎯 Key Objectives
Database Architecture: Model relational connections between users, posts, likes, and comments with strict foreign key constraints and cascading rules.

Automated Mechanics: Implement PostgreSQL triggers to update engagement counts automatically upon user interactions without relying on application-level logic.

Advanced Analytics: Utilize SQL window functions and database views to rank top-performing content and compute multi-metric engagement scores.

Reporting: Export aggregated engagement metrics and user interaction summaries for downstream business analytics.

🛠️ Tech Stack & Concepts
Database Management System: PostgreSQL

SQL Concepts Applied:

DDL (Schema Design, Constraints, Indexes)

DML (Seeding Realistic Datasets)

PL/pgSQL Triggers & Functions (Real-time updates)

Window Functions (DENSE_RANK(), ROW_NUMBER(), AVG() OVER())

Database Views & Aggregations

📐 Database Schema Overview
 [ Users ] ───< [ Posts ] ───< [ Likes ]
                   │
                   └───< [ Comments ]
users: Stores user profiles and registration timestamps.

posts: Stores post content, publish dates, and cached engagement counts (likes, comments).

likes: Tracks user-post like relationships (UNIQUE(user_id, post_id)).

comments: Tracks user comments linked to specific posts.

🌟 Features & Highlights
1. Dynamic Engagement Triggers
Automated BEFORE/AFTER triggers increment and decrement likes_count and comments_count directly on the posts table whenever rows are inserted or deleted in the likes or comments tables.

2. Custom Engagement Scoring
An integrated metric calculating total interactions over time:

Engagement Score=(Likes×1.0)+(Comments×2.0)
3. Window Function Ranking
Utilizes DENSE_RANK() over partition windows to analyze high-performing posts relative to global averages and categorical benchmarks without heavy subquery re-execution.

🚀 Deliverables Included
schema.sql: Complete DDL scripts for table creation, constraints, and indexes.

triggers.sql: PL/pgSQL trigger functions for automatic counter updates.

seed.sql: Sample data population script mimicking realistic social media activity.

analytics_views.sql: SQL views for top-performing posts, engagement scores, and user activity summaries.

ranking_queries.sql: Queries leveraging window functions for trending content discovery.
