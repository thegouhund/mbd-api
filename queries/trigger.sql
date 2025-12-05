DELIMITER $$

CREATE TRIGGER before_enrollment_insert_check_instructor_role
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    DECLARE user_role ENUM('student', 'instructor');

    SELECT role INTO user_role FROM users WHERE user_id = NEW.user_id;

    IF user_role = 'instructor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hanya student yang dapat melakukan enroll pada course.';
    END IF;
END$$


DROP TRIGGER before_delete_course_delete_enrollments_modules;
CREATE TRIGGER before_delete_course_prevent_if_enrollments_exist
BEFORE DELETE ON courses
FOR EACH ROW
BEGIN
    DECLARE enrollments_count INT;
    SELECT COUNT(enrollment_id) INTO enrollments_count from enrollments where course_id = OLD.course_id;
    IF (enrollments_count > 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Masih ada user yang terdaftar dalam course ini';
    END IF;
END$$


DELIMITER ;