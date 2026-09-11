-- UniReg views
USE unireg;

-- View 1: proti section e koto seat, koto vorti, koto khali + course/teacher naam
CREATE OR REPLACE VIEW section_availability AS
SELECT
    s.section_id,
    c.code        AS course_code,
    c.title       AS course_title,
    t.name        AS teacher_name,
    s.semester,
    s.seat_limit,
    s.seats_taken,
    (s.seat_limit - s.seats_taken) AS seats_left
FROM sections s
JOIN courses  c ON s.course_id  = c.course_id
JOIN teachers t ON s.teacher_id = t.teacher_id;