-- UniReg analytics queries (recursive CTE + window functions)
USE unireg;

-- Q1: CSE401 (course_id=4) nite hole je sob course age lagbe, puro chain
WITH RECURSIVE prereq_chain AS (
    -- anchor: CSE401 er sorasori prerequisite
    SELECT course_id, requires_course_id, 1 AS depth
    FROM prerequisites
    WHERE course_id = 4

    UNION ALL

    -- recursive: ager step er requirement er o requirement khujo
    SELECT p.course_id, p.requires_course_id, pc.depth + 1
    FROM prerequisites p
    JOIN prereq_chain pc ON p.course_id = pc.requires_course_id
)
SELECT
    c.code  AS need_course,
    c.title AS course_title,
    pc.depth
FROM prereq_chain pc
JOIN courses c ON c.course_id = pc.requires_course_id
ORDER BY pc.depth;


-- Q2: proti department e CGPA onujayi student der rank
SELECT
    d.code AS dept,
    s.name AS student,
    s.cgpa,
    RANK() OVER (
        PARTITION BY s.dept_id
        ORDER BY s.cgpa DESC
    ) AS dept_rank
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
ORDER BY d.code, dept_rank;

-- Q3: proti section e koto % seat vorti hoyeche
SELECT
    c.code AS course,
    sec.seat_limit,
    sec.seats_taken,
    ROUND(100.0 * sec.seats_taken / sec.seat_limit, 1) AS fill_percent,
    RANK() OVER (ORDER BY sec.seats_taken / sec.seat_limit DESC) AS demand_rank
FROM sections sec
JOIN courses c ON sec.course_id = c.course_id
ORDER BY demand_rank;