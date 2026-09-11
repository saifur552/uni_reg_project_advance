-- UniReg stored procedures
USE unireg;

DROP PROCEDURE IF EXISTS enroll_student;

DELIMITER $$

CREATE PROCEDURE enroll_student (
    IN  p_student_id INT,
    IN  p_section_id INT,
    OUT p_result     VARCHAR(50)
)
BEGIN
    DECLARE v_limit INT;
    DECLARE v_taken INT;
    DECLARE v_wait_pos INT;

    -- kono error hole sob undo (rollback) kore dibe
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: enrollment failed';
    END;

    START TRANSACTION;

    -- ei section er sari LOCK koro. onno keu ekhon eta dhorte parbe na.
    SELECT seat_limit, seats_taken
      INTO v_limit, v_taken
      FROM sections
     WHERE section_id = p_section_id
     FOR UPDATE;

    IF v_taken < v_limit THEN
        -- seat ache: vorti koro
        INSERT INTO enrollments (student_id, section_id, status)
        VALUES (p_student_id, p_section_id, 'enrolled');

        UPDATE sections
           SET seats_taken = seats_taken + 1
         WHERE section_id = p_section_id;

        SET p_result = 'ENROLLED';
    ELSE
        -- seat nai: waitlist e boshao, position ber koro
        SELECT COALESCE(MAX(position), 0) + 1
          INTO v_wait_pos
          FROM waitlist
         WHERE section_id = p_section_id;

        INSERT INTO waitlist (student_id, section_id, position)
        VALUES (p_student_id, p_section_id, v_wait_pos);

        SET p_result = CONCAT('WAITLISTED at position ', v_wait_pos);
    END IF;

    COMMIT;
END$$

DELIMITER ;