📊Social Media Analytics Backend
A PostgreSQL project that tracks social media activity and turns it into useful engagement insights. Explore which posts get the most likes and comments, rank top content, and generate reports.
✨ Features
- 👤 User accounts — store user information
- 📝 Posts — track post content and creation dates
- ❤️ Likes — record who liked each post
- 💬 Comments — connect comments to users and posts
- 📊 Analytics views — summarize post engagement
- 🏆 Rankings — use window functions to find top posts
- ⚙️ Triggers — update like counts automatically
- 📤 Reports — query engagement data for export
🗂️ Database Design
Table	What it stores
users	User account details
posts	Posts created by users
likes	Likes on posts
comments	Comments on posts


Primary and foreign keys connect the data, and constraints help keep records consistent.
🚀 Getting Started
1. Install PostgreSQL.
2. Create a database for the project.
3. Run the SQL scripts in order:
   - Schema
   - Sample data
   - Views and triggers
   - Analytics queries
4. Run the report queries to explore engagement.
Update the script names below to match the files in your repository.

📈 Example: Engagement Score
This example combines likes and comments into one score:
SELECT
    p.post_id,
    p.content,
    COUNT(DISTINCT l.user_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.comment_id) AS engagement_score
FROM posts p
LEFT JOIN likes l ON l.post_id = p.post_id
LEFT JOIN comments c ON c.post_id = p.post_id
GROUP BY p.post_id, p.content
ORDER BY engagement_score DESC;
🏅 Example: Rank Posts
SELECT
    post_id,
    engagement_score,
    RANK() OVER (ORDER BY engagement_score DESC) AS engagement_rank
FROM post_engagement;
post_engagement is an example view name. Replace it with the name used in your project.
📦 Project Structure
.
├── schema.sql
├── sample_data.sql
├── views_and_triggers.sql
├── analytics.sql
└── README.md
🛠️ Built With
- PostgreSQL
- SQL
📄 License
Add a LICENSE file if you’d like to specify how others may use this project.
