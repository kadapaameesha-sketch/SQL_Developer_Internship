-- ============================================================================
-- 10. SOCIAL MEDIA ANALYTICS BACKEND
-- File: 03_seed_data.sql
-- Tool: PostgreSQL
-- Description: Population of Realistic User Activities, Posts, Likes, Comments
-- ============================================================================

-- Clear existing data (preserving sequences reset)
TRUNCATE TABLE comments, likes, posts, users RESTART IDENTITY CASCADE;

-- ----------------------------------------------------------------------------
-- 1. SEED USERS (15 Active Social Media Profiles)
-- ----------------------------------------------------------------------------
INSERT INTO users (username, email, full_name, bio, country, created_at) VALUES
('tech_alex',     'alex.chen@techhub.io',        'Alex Chen',       'Building the future of AI & Distributed Systems', 'USA',        '2026-01-10 09:00:00+00'),
('sarah_travel',  'sarah.j@destinations.com',    'Sarah Jenkins',   'Digital nomad & landscape photographer',          'UK',         '2026-01-12 11:30:00+00'),
('gamer_dev',     'devon.k@pixels.net',          'Devon Knight',    'Indie game developer & C++ enthusiast',            'Canada',     '2026-01-15 14:20:00+00'),
('science_sam',   'samira.v@astro.org',          'Samira Patel',    'Astrophysics research fellow & science communicator','India',   '2026-01-18 08:15:00+00'),
('chef_marco',    'marco.r@culinary.it',         'Marco Rossi',     'Authentic Italian cooking & recipe creation',     'Italy',      '2026-01-20 16:45:00+00'),
('fit_elena',     'elena.s@healthlife.de',       'Elena Schmidt',   'Marathon runner & holistic fitness coach',        'Germany',    '2026-01-22 07:10:00+00'),
('crypto_li',     'li.wei@web3labs.com',         'Li Wei',          'Blockchain architect & smart contract auditor',   'Singapore',  '2026-01-25 12:00:00+00'),
('photo_maya',    'maya.l@lenscraft.com',        'Maya Lin',        'Street photography & color grading insights',     'Japan',      '2026-02-01 10:30:00+00'),
('code_priya',    'priya.r@devspace.in',         'Priya Sharma',    'Full-stack engineer & PostgreSQL advocate',       'India',      '2026-02-05 15:00:00+00'),
('movie_buff',    'carlos.m@cinephile.es',       'Carlos Mendez',   'Film critic & cinema historian',                  'Spain',      '2026-02-08 18:20:00+00'),
('eco_hannah',    'hannah.b@greenliving.org',    'Hannah Brown',    'Sustainable living & zero-waste guide',           'Australia',  '2026-02-10 06:40:00+00'),
('music_jordan',  'jordan.t@soundstage.com',     'Jordan Taylor',   'Audio engineer & synthesizer collector',          'USA',        '2026-02-14 21:00:00+00'),
('startup_ben',   'ben.v@venturelabs.co',        'Ben Vance',       'SaaS founder & growth strategist',                'UK',         '2026-02-18 13:15:00+00'),
('art_clara',     'clara.d@studioart.fr',        'Clara Dubois',    'Oil painter & digital illustrator',               'France',     '2026-02-22 17:30:00+00'),
('data_zack',     'zack.m@analytics.io',         'Zack Miller',     'Data scientist & ML researcher',                  'USA',        '2026-02-25 10:00:00+00');


-- ----------------------------------------------------------------------------
-- 2. SEED POSTS (30 Realistic Posts across 6 Categories)
-- ----------------------------------------------------------------------------
INSERT INTO posts (user_id, title, content, category, media_url, created_at) VALUES
-- Tech Posts
(1, 'PostgreSQL 16 Performance Optimization Strategies', 'Here is how we reduced query latencies by 45% using indexing, CTE optimization, and query plan tuning.', 'Tech', 'https://cdn.example.com/posts/pg_perf.png', '2026-03-01 10:00:00+00'),
(9, 'Mastering SQL Window Functions in 2026', 'Window functions like DENSE_RANK and LAG/LEAD transform complex analytical reporting into clean, readable queries.', 'Tech', 'https://cdn.example.com/posts/window_fn.png', '2026-03-02 14:30:00+00'),
(7, 'Zero-Knowledge Proofs in Web3 Systems', 'Understanding ZK-SNARKs and how cryptography is shaping decentralization.', 'Tech', 'https://cdn.example.com/posts/zk_proofs.png', '2026-03-04 09:15:00+00'),
(15, 'Building LLM Pipelines with Vector Databases', 'Combining pgvector with PostgreSQL for semantic search at scale.', 'Tech', 'https://cdn.example.com/posts/vector_db.png', '2026-03-06 11:20:00+00'),
(1, 'The Evolution of Microservices to Pragmatic Monoliths', 'Why modular monoliths are winning in 2026 startup architectures.', 'Tech', NULL, '2026-03-08 16:45:00+00'),

-- Lifestyle & Food
(5, 'Secret to Authentic Carbonara: No Cream Ever!', 'Guanciale, Pecorino Romano, egg yolks, and fresh black pepper. Simple perfection.', 'Lifestyle', 'https://cdn.example.com/posts/carbonara.jpg', '2026-03-01 12:00:00+00'),
(6, 'Sub-3 Hour Marathon Training Blueprint', 'Consistency, nutrition, and zone 2 cardio build world-class endurance.', 'Lifestyle', 'https://cdn.example.com/posts/marathon.jpg', '2026-03-03 07:30:00+00'),
(11, '10 Simple Steps to Achieve Zero-Waste Kitchen', 'Reduce food waste and eliminate single-use plastics effortlessly.', 'Lifestyle', 'https://cdn.example.com/posts/zero_waste.jpg', '2026-03-05 18:00:00+00'),
(5, 'Artisanal Sourdough Bread Mastery', '72-hour fermentation process yields perfect open crumb and crispy crust.', 'Lifestyle', 'https://cdn.example.com/posts/sourdough.jpg', '2026-03-09 10:15:00+00'),

-- Science & Education
(4, 'JWST Captures Earliest Known Galaxies', 'New infrared imagery reveals galaxy formation just 300 million years after the Big Bang.', 'Science', 'https://cdn.example.com/posts/jwst_galaxies.jpg', '2026-03-01 15:20:00+00'),
(4, 'Understanding Gravitational Wave Astronomy', 'How LIGO and Virgo detect black hole mergers across billions of light years.', 'Science', 'https://cdn.example.com/posts/ligo_waves.png', '2026-03-04 20:10:00+00'),
(15, 'Statistical Pitfalls in A/B Testing', 'Why p-hacking and early stopping ruin product decision making.', 'Education', 'https://cdn.example.com/posts/ab_testing.png', '2026-03-07 13:40:00+00'),
(4, 'Quantum Computing Breakthrough in Fault Tolerance', 'Logical qubits achieve error rates below physical qubit thresholds.', 'Science', 'https://cdn.example.com/posts/quantum.png', '2026-03-10 09:00:00+00'),

-- Travel & Photography
(2, 'Sunrise Over the Dolomites, Italy', 'Hiking at 4 AM to capture first light hitting the jagged peaks.', 'Travel', 'https://cdn.example.com/posts/dolomites.jpg', '2026-03-02 06:15:00+00'),
(8, 'Golden Hour Street Photography in Tokyo', 'Shinjuku neon lights and rainy street reflections in 35mm film.', 'Travel', 'https://cdn.example.com/posts/tokyo_rain.jpg', '2026-03-03 19:50:00+00'),
(2, 'Hidden Fjords of Norway: Off the Beaten Path', 'Kayaking through crystal-clear waters in West Norway.', 'Travel', 'https://cdn.example.com/posts/norway_fjords.jpg', '2026-03-07 08:30:00+00'),
(8, 'Color Grading Masterclass for Cinema Look', 'Transforming flat Log footage into vibrant cinematic storytelling.', 'Entertainment', 'https://cdn.example.com/posts/color_grade.png', '2026-03-11 14:00:00+00'),

-- Gaming & Entertainment
(3, 'Designing Responsive Physics in 2D Platformers', 'C++ memory management and custom collision detection algorithms.', 'Gaming', 'https://cdn.example.com/posts/2d_physics.png', '2026-03-02 11:00:00+00'),
(3, 'Procedural Generation in Modern Roguelikes', 'Using Perlin noise and cellular automata for infinite dungeon replayability.', 'Gaming', 'https://cdn.example.com/posts/proc_gen.png', '2026-03-05 16:30:00+00'),
(10, 'Top 10 Masterpiece Cinema Releases of the Decade', 'Analyzing cinematography, narrative structure, and thematic depth.', 'Entertainment', 'https://cdn.example.com/posts/cinema.jpg', '2026-03-06 21:15:00+00'),
(12, 'Analogue Synthesizer Sound Design Tips', 'Modulating filters and envelopes for warm retro synthwave basses.', 'Entertainment', 'https://cdn.example.com/posts/synth.jpg', '2026-03-08 19:00:00+00'),

-- Additional Engagement Posts
(13, 'Bootstrapping a SaaS to $10k MRR without VCs', 'Focusing on customer retention, organic SEO, and rapid feature iteration.', 'Education', 'https://cdn.example.com/posts/saas_bootstrapping.png', '2026-03-03 13:00:00+00'),
(14, 'Oil Painting Techniques: Glazing vs Impasto', 'Building texture and luminosity through classical painting layers.', 'Lifestyle', 'https://cdn.example.com/posts/oil_painting.jpg', '2026-03-04 17:45:00+00'),
(9, 'PostgreSQL Triggers vs Application-Level Logic', 'When to use database triggers for strict integrity vs background queue jobs.', 'Tech', NULL, '2026-03-09 12:30:00+00'),
(13, 'Conversion Rate Optimization Secrets for B2B', 'A/B testing landing page headlines and call-to-action friction reduction.', 'Education', NULL, '2026-03-10 15:15:00+00');


-- ----------------------------------------------------------------------------
-- 3. SEED LIKES (Triggers will automatically increment post.like_count)
-- ----------------------------------------------------------------------------
INSERT INTO likes (post_id, user_id, created_at) VALUES
-- Likes for Post 1 (PostgreSQL 16 Perf - Tech Viral)
(1, 2, '2026-03-01 10:15:00+00'), (1, 3, '2026-03-01 10:30:00+00'), (1, 4, '2026-03-01 11:00:00+00'),
(1, 7, '2026-03-01 11:45:00+00'), (1, 9, '2026-03-01 12:20:00+00'), (1, 13, '2026-03-01 14:10:00+00'),
(1, 15, '2026-03-01 15:00:00+00'), (1, 5, '2026-03-01 16:30:00+00'), (1, 8, '2026-03-01 18:00:00+00'),

-- Likes for Post 2 (Window Functions)
(2, 1, '2026-03-02 14:40:00+00'), (2, 3, '2026-03-02 15:10:00+00'), (2, 4, '2026-03-02 15:45:00+00'),
(2, 7, '2026-03-02 16:20:00+00'), (2, 13, '2026-03-02 17:00:00+00'), (2, 15, '2026-03-02 18:30:00+00'),

-- Likes for Post 6 (Carbonara Recipe)
(6, 1, '2026-03-01 12:30:00+00'), (6, 2, '2026-03-01 13:00:00+00'), (6, 8, '2026-03-01 13:45:00+00'),
(6, 10, '2026-03-01 14:15:00+00'), (6, 11, '2026-03-01 15:00:00+00'), (6, 14, '2026-03-01 16:20:00+00'),
(6, 12, '2026-03-01 17:10:00+00'),

-- Likes for Post 10 (JWST Galaxies - Science Viral)
(10, 1, '2026-03-01 15:40:00+00'), (10, 3, '2026-03-01 16:00:00+00'), (10, 7, '2026-03-01 16:45:00+00'),
(10, 8, '2026-03-01 17:30:00+00'), (10, 9, '2026-03-01 18:15:00+00'), (10, 11, '2026-03-01 19:00:00+00'),
(10, 14, '2026-03-01 20:30:00+00'), (10, 15, '2026-03-01 21:00:00+00'),

-- Likes for Post 14 (Dolomites Sunrise)
(14, 1, '2026-03-02 06:45:00+00'), (14, 5, '2026-03-02 07:15:00+00'), (14, 8, '2026-03-02 08:00:00+00'),
(14, 11, '2026-03-02 09:30:00+00'), (14, 14, '2026-03-02 11:00:00+00'),

-- Likes for Post 18 (Physics 2D Platformers)
(18, 1, '2026-03-02 11:30:00+00'), (18, 7, '2026-03-02 12:15:00+00'), (18, 9, '2026-03-02 13:00:00+00'),
(18, 15, '2026-03-02 14:00:00+00'),

-- Likes for Post 22 (SaaS Bootstrapping)
(22, 1, '2026-03-03 13:30:00+00'), (22, 7, '2026-03-03 14:00:00+00'), (22, 9, '2026-03-03 15:15:00+00'),
(22, 15, '2026-03-03 16:45:00+00'), (22, 3, '2026-03-03 18:00:00+00'),

-- Additional scattered likes
(3, 1, '2026-03-04 10:00:00+00'), (3, 9, '2026-03-04 11:30:00+00'), (3, 15, '2026-03-04 13:00:00+00'),
(4, 1, '2026-03-06 12:00:00+00'), (4, 9, '2026-03-06 13:15:00+00'),
(7, 5, '2026-03-03 08:30:00+00'), (7, 11, '2026-03-03 09:45:00+00'),
(11, 1, '2026-03-04 21:00:00+00'), (11, 15, '2026-03-04 22:30:00+00'),
(15, 2, '2026-03-03 20:30:00+00'), (15, 14, '2026-03-03 21:15:00+00'),
(20, 8, '2026-03-06 22:00:00+00'), (20, 12, '2026-03-06 23:00:00+00');


-- ----------------------------------------------------------------------------
-- 4. SEED COMMENTS (Triggers will automatically increment post.comment_count)
-- ----------------------------------------------------------------------------
-- Top-level comments
INSERT INTO comments (post_id, user_id, parent_comment_id, content, created_at) VALUES
(1, 9,  NULL, 'Excellent breakdown! The CTE optimization tip saved our team hours.', '2026-03-01 10:45:00+00'),
(1, 15, NULL, 'Did you notice any difference between PostgreSQL 15 and 16 JIT compilation?', '2026-03-01 11:30:00+00'),
(1, 7,  NULL, 'Proper indexing strategy is always key. Great insights Alex!', '2026-03-01 12:15:00+00'),

(2, 1,  NULL, 'Window functions turned a 50-line subquery into 10 lines for our reporting DB.', '2026-03-02 15:00:00+00'),
(2, 15, NULL, 'NTILE and DENSE_RANK are absolute game changers.', '2026-03-02 16:00:00+00'),

(6, 10, NULL, 'Finally someone making authentic Carbonara! No cream is the true way.', '2026-03-01 13:15:00+00'),
(6, 14, NULL, 'What brand of Pecorino do you recommend?', '2026-03-01 14:00:00+00'),

(10, 1, NULL, 'The detail from JWST is mind blowing. Human ingenuity at its finest.', '2026-03-01 16:10:00+00'),
(10, 15,NULL, 'Are the redshift calculations fully calibrated yet?', '2026-03-01 17:00:00+00'),

(14, 8, NULL, 'Stunning lighting! What focal length was this shot at?', '2026-03-02 07:30:00+00'),

(18, 9, NULL, 'Fixed-timestep physics updates prevent so many tunneling glitches.', '2026-03-02 12:00:00+00'),

(22, 7, NULL, 'Retention > Acquisition every single time. Great breakdown Ben!', '2026-03-03 14:30:00+00');

-- Threaded (nested) comments
INSERT INTO comments (post_id, user_id, parent_comment_id, content, created_at) VALUES
(1, 1,  2, 'Yes! JIT in PG 16 has significantly lower overhead for short analytical queries.', '2026-03-01 11:50:00+00'),
(6, 5,  7, 'Pecorino Romano DOP from Sardinia gives the perfect sharp salty kick!', '2026-03-01 14:30:00+00'),
(10, 4, 9, 'Yes, the spectroscopy data confirmed z > 14 redshift with high confidence.', '2026-03-01 17:45:00+00'),
(14, 2, 10, 'Shot on 24mm f/1.4 prime lens with a 3-stop soft GND filter.', '2026-03-02 08:15:00+00');
