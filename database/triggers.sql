-- UniReg triggers
USE unireg;

DROP TRIGGER IF EXISTS after_enroll_insert;

DELIMITER $$

-- enrollments e notun sari dhuklei ei trigger jege uthbe
CREATE TRIGGER after_enroll_insert
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action, detail)
    VALUES (
        'enrollments',
        'INSERT',
        CONCAT('student_id=', NEW.student_id,
               ' enrolled in section_id=', NEW.section_id)
    );
END$$

DELIMITER ;