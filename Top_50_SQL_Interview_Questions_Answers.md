# Top 50 SQL Interview Questions & Short Concise Answers

## 1. Fundamentals & Core Concepts

### 1. What is SQL? How is it different from MySQL or PostgreSQL?
- **SQL**: Standard language used to query and manipulate relational databases.
- **MySQL / PostgreSQL**: Relational Database Management Systems (RDBMS) that *implement* SQL along with storage engines, tools, and extensions.

### 2. What are the different types of SQL statements?
- **DDL (Data Definition Language)**: `CREATE`, `ALTER`, `DROP`, `TRUNCATE`
- **DML (Data Manipulation Language)**: `INSERT`, `UPDATE`, `DELETE`
- **DQL (Data Query Language)**: `SELECT`
- **DCL (Data Control Language)**: `GRANT`, `REVOKE`
- **TCL (Transaction Control Language)**: `COMMIT`, `ROLLBACK`, `SAVEPOINT`

### 3. Explain the difference between WHERE and HAVING.
- **`WHERE`**: Filters rows *before* grouping/aggregation. Cannot contain aggregate functions.
- **`HAVING`**: Filters groups *after* `GROUP BY` aggregation. Uses aggregate functions (`COUNT`, `SUM`, `AVG`).

### 4. What are PRIMARY KEY, FOREIGN KEY, UNIQUE, and CHECK constraints?
- **PRIMARY KEY**: Uniquely identifies each row; cannot be `NULL` (1 per table).
- **FOREIGN KEY**: Enforces referential integrity pointing to a Primary Key in another table.
- **UNIQUE**: Ensures all values in a column are distinct (allows `NULL`s).
- **CHECK**: Enforces specific conditions on column values (e.g., `CHECK (age >= 18)`).

### 5. What is the difference between DELETE, TRUNCATE, and DROP?
- **`DELETE`**: DML. Deletes specific/all rows; row-by-row logging; supports `WHERE`; can be rolled back; triggers fire.
- **`TRUNCATE`**: DDL. Deletes all rows by deallocating pages; faster; resets identity counter; triggers don't fire.
- **`DROP`**: DDL. Completely removes table structure, data, indexes, and constraints from DB.

---

## 2. Database Design & Architecture

### 6. What is normalization? Explain different normal forms.
- **Normalization**: Organizing tables to eliminate redundancy and improve data integrity.
  - **1NF**: Atomic values (no multi-valued columns), primary key defined.
  - **2NF**: 1NF + no partial dependency (non-key fields depend on entire primary key).
  - **3NF**: 2NF + no transitive dependency (non-key fields depend ONLY on primary key).
  - **BCNF**: Strict 3NF where every determinant is a candidate key.

### 7. What is denormalization and when is it useful?
- Adding intentional redundancy or combining tables to reduce `JOIN`s and accelerate read performance in analytical/OLAP reporting systems.

### 8. Explain the difference between CHAR and VARCHAR.
- **`CHAR(n)`**: Fixed length. Pads spaces up to $n$ characters. Fixed storage size.
- **`VARCHAR(n)`**: Variable length. Stores only actual characters plus length prefix bytes. Saves storage space.

### 9. What are ACID properties in databases?
- **Atomicity**: All operations in a transaction succeed or all fail.
- **Consistency**: DB transitions from one valid state to another, preserving constraints.
- **Isolation**: Concurrent transactions execute independently without interference.
- **Durability**: Committed data changes are permanently saved even across system crashes.

---

## 3. Joins, Queries & Subqueries

### 10. Difference between INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN?
- **INNER JOIN**: Returns only matching rows in both tables.
- **LEFT JOIN**: Returns all rows from left table + matching rows from right table (`NULL` if no match).
- **RIGHT JOIN**: Returns all rows from right table + matching rows from left table (`NULL` if no match).
- **FULL JOIN**: Returns all rows when there is a match in either table.

### 11. Write a query to find the second highest salary from an Employee table.
```sql
SELECT MAX(salary) FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee);
```

### 12. Write a query to get the department-wise average salary.
```sql
SELECT department_id, AVG(salary) AS avg_salary 
FROM Employee 
GROUP BY department_id;
```

### 13. How would you retrieve duplicate records from a table?
```sql
SELECT email, COUNT(*) 
FROM Users 
GROUP BY email 
HAVING COUNT(*) > 1;
```

### 14. How do you update a column with a calculation (e.g., 10% tax added)?
```sql
UPDATE Products 
SET price = price * 1.10;
```

### 15. How would you delete only duplicate rows from a table?
```sql
WITH CTE AS (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM Users
)
DELETE FROM Users WHERE id IN (SELECT id FROM CTE WHERE rn > 1);
```

### 16. Write a query to list customers who have placed more than 5 orders.
```sql
SELECT customer_id, COUNT(order_id) AS total_orders 
FROM Orders 
GROUP BY customer_id 
HAVING COUNT(order_id) > 5;
```

### 17. Write a query to join three or more tables.
```sql
SELECT c.name, o.order_date, p.product_name 
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;
```

### 18. What is a subquery? How is it different from a JOIN?
- **Subquery**: Query nested inside another query (`SELECT`, `WHERE`, `FROM`).
- **Difference**: JOINs combine columns horizontally across tables and are typically faster and easier for query optimizers to execute.

### 19. What is a correlated subquery? Give an example.
- A subquery that references columns from the outer query and re-evaluates for every outer row.
```sql
SELECT e1.name, e1.salary 
FROM Employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) FROM Employee e2 WHERE e2.dept_id = e1.dept_id
);
```

### 20. How do you filter data based on a date range?
```sql
SELECT * FROM Orders 
WHERE order_date BETWEEN '2026-01-01' AND '2026-03-31';
```

---

## 4. Advanced SQL (Window Functions, CTEs, Views & Triggers)

### 21. What are WINDOW FUNCTIONS? Name a few.
- Perform calculations across related table rows without collapsing rows into a single summary output.
- *Examples*: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`, `LAG()`, `LEAD()`, `SUM() OVER()`.

### 22. What is the use of RANK(), DENSE_RANK(), and ROW_NUMBER()?
- **`ROW_NUMBER()`**: Unique sequential integer (1, 2, 3, 4) for every row regardless of ties.
- **`RANK()`**: Assigns rank; leaves gaps after ties (1, 2, 2, 4).
- **`DENSE_RANK()`**: Assigns rank; NO gaps after ties (1, 2, 2, 3).

### 23. What is a Common Table Expression (CTE)? Difference from subquery?
- **CTE (`WITH cte AS (...)`)**: Named temporary result set defined before main query.
- *Difference*: Enhances readability, re-usable multiple times in same query, supports recursive queries (`WITH RECURSIVE`).

### 24. What are stored procedures? When should they be used?
- Precompiled SQL code block stored on DB server.
- *Use when*: Encapsulating complex multi-step business logic, reducing network round-trips, enforcing authorization.

### 25. What is a trigger? Give a real world example.
- Automated SQL routine that executes upon database events (`INSERT`, `UPDATE`, `DELETE`).
- *Example*: Automatically updating cached `like_count` on a `posts` table when a new row is added to `likes`.

### 26. What is a VIEW? Pros and Cons?
- Virtual table based on a saved `SELECT` query.
- *Pros*: Query simplification, security (column hiding), consistent interface.
- *Cons*: Performance overhead (executes underlying query on call), update limitations.

### 27. What are indexes? How do they improve performance?
- B-Tree/Hash data structures providing fast lookup pointers to table rows, converting $O(N)$ full table scans into $O(\log N)$ tree searches.

### 28. What is a materialized view?
- A view whose query result set is physically persisted on disk and periodically refreshed. Accelerates heavy analytical queries.

### 29. Transactions: COMMIT, ROLLBACK, SAVEPOINT?
- **`COMMIT`**: Permanently saves transaction changes.
- **`ROLLBACK`**: Undoes uncommitted transaction changes.
- **`SAVEPOINT`**: Intermediate marker allowing selective partial rollback.

### 30. Aggregate functions with examples?
- Summarize multiple values into a single result: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`.

---

## 5. Performance Tuning & Optimization

### 31. How to optimize a slow-running SQL query?
- Add indexes on `WHERE`, `JOIN`, `ORDER BY` columns.
- Select only required columns (avoid `SELECT *`).
- Use `EXPLAIN` to inspect query execution plan.
- Avoid leading wildcards in `LIKE` queries (`LIKE '%abc'`).
- Use JOINs / CTEs instead of correlated subqueries.

### 32. What is EXPLAIN / EXPLAIN PLAN used for?
- Displays the database query optimizer's execution plan (Sequential scan vs Index scan, join algorithms, costs, estimated rows).

### 33. How does indexing affect INSERT, UPDATE, and DELETE performance?
- **Slows write operations** because index data structures must be updated alongside table modifications.

### 34. What is a composite index and when should it be used?
- Index on multiple columns. Used when queries filter/group by multiple columns together. Relies on Leftmost Prefix Rule.

### 35. Normalization overhead & how to handle it?
- Heavy join performance penalty caused by high normalization. Handled via selective denormalization, caching, indexing, or materialized views.

### 36. How to avoid Cartesian products in JOINs?
- Always provide explicit join conditions (`ON t1.id = t2.id`) and avoid missing conditions or unintended `CROSS JOIN`s.

### 37. What is partitioning in SQL?
- Dividing a large table into smaller physical child tables (Range, List, Hash) while exposing a single table interface (enables partition pruning).

### 38. Deadlocks in SQL & prevention?
- Occurs when two transactions hold locks on resources the other requires, causing a circular block.
- *Prevention*: Access tables in identical order, keep transactions short, use proper isolation levels.

### 39. Clustered vs Non-Clustered Indexes?
- **Clustered Index**: Determines physical storage order of rows on disk (only 1 per table, usually PK).
- **Non-Clustered Index**: Separate structure with key values and pointers to data rows (multiple per table).

### 40. Tools to monitor SQL query performance?
- `EXPLAIN ANALYZE`, PostgreSQL `pg_stat_statements`, MySQL Slow Query Log, SQL Server Profiler.

---

## 6. System Design & Real-World Scenarios

### 41. Design a student-course grading system.
- `Students` (`student_id` PK)
- `Courses` (`course_id` PK)
- `Enrollments` (`enrollment_id` PK, `student_id` FK, `course_id` FK, `grade`, `semester`)

### 42. Store and retrieve employee attendance scalably?
- Partitioned `Attendance` table (`attendance_id`, `employee_id`, `date`, `check_in`, `check_out`, `status`) with composite index on `(employee_id, date)`.

### 43. Track overdue books and fines using SQL?
```sql
SELECT member_id, SUM((CURRENT_DATE - due_date) * fine_per_day) AS total_fine
FROM Loans
WHERE return_date IS NULL AND CURRENT_DATE > due_date
GROUP BY member_id;
```

### 44. What to do if production DB missing records due to failed update?
- Inspect transaction audit logs/CDC, restore from Point-In-Time Backup (PITR) to staging DB, and execute safe delta update script within a transaction.

### 45. Role-based access to sensitive info in SQL?
- Use DB Roles (`GRANT`/`REVOKE`), Column-level grants, and Row-Level Security (RLS) policies based on session user contexts.

### 46. Load & clean raw CSV dirty data using SQL?
- Load raw CSV into staging `VARCHAR` table, sanitize with SQL functions (`TRIM()`, `COALESCE()`, `REGEXP_REPLACE()`, `CAST()`), and insert into production schema.

### 47. Calculate monthly retention from user login dataset?
- Self-join user activity logs on `user_id` where `login_month = cohort_month + INTERVAL '1 month'`, dividing retained count by total cohort size.

### 48. Security measures for sensitive data?
- TLS encryption in transit & AES at rest, Row-Level Security (RLS), Parameterized queries (SQL Injection defense), Least privilege roles, Audit trail logging.

### 49. Daily backup and restore plan (Short Way)?
- **Backup**: Daily full database dump (`pg_dump` / `mysqldump`) + continuous WAL / Transaction log archiving.
- **Restore**: Restore latest full dump, then apply WAL logs up to target timestamp (PITR). Regularly test on staging.
