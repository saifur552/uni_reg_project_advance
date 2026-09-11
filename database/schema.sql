-- UniReg database schema
-- MariaDB 10.4 (XAMPP). Engine InnoDB — transaction + foreign key support.

DROP DATABASE IF EXISTS unireg;
CREATE DATABASE unireg CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE unireg;

-- 1. Departments: CSE, EEE...
CREATE TABLE departments (
    dept_id   INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    code      VARCHAR(10)  NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 2. Students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(120) NOT NULL UNIQUE,
    dept_id    INT NOT NULL,
    cgpa       DECIMAL(3,2) DEFAULT 0.00,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

-- 3. Teachers
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(120) NOT NULL UNIQUE,
    dept_id    INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

-- 4. Courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    code      VARCHAR(15) NOT NULL UNIQUE,
    title     VARCHAR(150) NOT NULL,
    credit    INT NOT NULL,
    dept_id   INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

-- 5. Prerequisites: course_id nite hole age requires_course_id lagbe
CREATE TABLE prerequisites (
    course_id          INT NOT NULL,
    requires_course_id INT NOT NULL,
    PRIMARY KEY (course_id, requires_course_id),
    FOREIGN KEY (course_id)          REFERENCES courses(course_id),
    FOREIGN KEY (requires_course_id) REFERENCES courses(course_id)
) ENGINE=InnoDB;

-- 6. Sections: ek course er section. seat_limit vs seats_taken = seat lorai
CREATE TABLE sections (
    section_id  INT AUTO_INCREMENT PRIMARY KEY,
    course_id   INT NOT NULL,
    teacher_id  INT NOT NULL,
    semester    VARCHAR(20) NOT NULL,
    seat_limit  INT NOT NULL,
    seats_taken INT NOT NULL DEFAULT 0,
    FOREIGN KEY (course_id)  REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
) ENGINE=InnoDB;

-- 7. Enrollments: ke kon section e vorti. status: enrolled / dropped
CREATE TABLE enrollments (
    enroll_id  INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    status     VARCHAR(20) NOT NULL DEFAULT 'enrolled',
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_student_section (student_id, section_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (section_id) REFERENCES sections(section_id)
) ENGINE=InnoDB;

-- 8. Waitlist: seat nai, line e d3ariye. position = line er kramik
CREATE TABLE waitlist (
    wait_id    INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    position   INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_wait_student_section (student_id, section_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (section_id) REFERENCES sections(section_id)
) ENGINE=InnoDB;

-- 9. Grades: proti enrollment er result
CREATE TABLE grades (
    grade_id  INT AUTO_INCREMENT PRIMARY KEY,
    enroll_id INT NOT NULL UNIQUE,
    letter    VARCHAR(2) NOT NULL,
    point     DECIMAL(3,2) NOT NULL,
    FOREIGN KEY (enroll_id) REFERENCES enrollments(enroll_id)
) ENGINE=InnoDB;

-- 10. Audit log: trigger ei table e likhbe (Stage 2)
CREATE TABLE audit_log (
    log_id     INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action     VARCHAR(20),
    detail     VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;