-- UniReg sample data (seed)
USE unireg;

-- Departments
INSERT INTO departments (name, code) VALUES
('Computer Science and Engineering', 'CSE'),
('Electrical and Electronic Engineering', 'EEE'),
('Business Administration', 'BBA');

-- Teachers (dept_id: 1=CSE, 2=EEE, 3=BBA)
INSERT INTO teachers (name, email, dept_id) VALUES
('Dr. Rahman', 'rahman@univ.edu', 1),
('Dr. Akter', 'akter@univ.edu', 1),
('Dr. Hossain', 'hossain@univ.edu', 2),
('Ms. Nabila', 'nabila@univ.edu', 3);

-- Students
INSERT INTO students (name, email, dept_id, cgpa) VALUES
('Saifur Rahman', 'saifur@univ.edu', 1, 3.85),
('Tanvir Ahmed', 'tanvir@univ.edu', 1, 3.20),
('Mitu Akter', 'mitu@univ.edu', 1, 3.95),
('Rakib Hasan', 'rakib@univ.edu', 1, 2.90),
('Nusrat Jahan', 'nusrat@univ.edu', 2, 3.60),
('Fahim Khan', 'fahim@univ.edu', 2, 3.10),
('Sadia Islam', 'sadia@univ.edu', 3, 3.75),
('Arif Chowdhury', 'arif@univ.edu', 3, 3.40);

-- Courses (dept_id: 1=CSE, 2=EEE, 3=BBA)
INSERT INTO courses (code, title, credit, dept_id) VALUES
('CSE101', 'Introduction to Programming', 3, 1),
('CSE201', 'Data Structures', 3, 1),
('CSE301', 'Database Systems', 3, 1),
('CSE401', 'Machine Learning', 3, 1),
('EEE101', 'Basic Electrical Engineering', 3, 2),
('BBA101', 'Principles of Management', 3, 3);

-- Prerequisites: course_id nite hole requires_course_id age lagbe
-- CSE201 (id 2) needs CSE101 (id 1)
-- CSE301 (id 3) needs CSE201 (id 2)
-- CSE401 (id 4) needs CSE301 (id 3)
INSERT INTO prerequisites (course_id, requires_course_id) VALUES
(2, 1),
(3, 2),
(4, 3);

-- Sections (course_id, teacher_id, semester, seat_limit, seats_taken)
-- CSE301 er seat kom rakhlam (2) jate seat lorai demo kora jay
INSERT INTO sections (course_id, teacher_id, semester, seat_limit, seats_taken) VALUES
(1, 1, 'Fall2026', 40, 0),
(2, 2, 'Fall2026', 30, 0),
(3, 1, 'Fall2026', 2,  0),
(5, 3, 'Fall2026', 35, 0),
(6, 4, 'Fall2026', 50, 0);