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


CREATE TRIGGER before_delete_course_delete_enrollments_modules
BEFORE DELETE ON courses
FOR EACH ROW
BEGIN
    DELETE FROM enrollments WHERE course_id = OLD.course_id;
    DELETE FROM modules WHERE course_id = OLD.course_id;
END$$

CREATE TRIGGER before_delete_user_delete_enrollments
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    DELETE FROM enrollments WHERE user_id = OLD.user_id;
END$$

DELIMITER ;