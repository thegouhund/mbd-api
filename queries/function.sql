DELIMITER $$

CREATE OR REPLACE FUNCTION CheckUserRole(p_user_id INT, p_expected_role VARCHAR(255))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_role VARCHAR(255);
    SELECT role INTO v_role FROM users WHERE user_id = p_user_id;
    IF v_role IS NOT NULL AND v_role = p_expected_role THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

CREATE OR REPLACE FUNCTION IsUserEnrolledInCourse(p_user_id INT, p_course_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM enrollments WHERE user_id = p_user_id AND course_id = p_course_id;
    IF v_count > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

CREATE OR REPLACE FUNCTION IsCreatorOfCourse(p_user_id INT, p_course_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM courses WHERE creator_id = p_user_id AND course_id = p_course_id;
    IF v_count > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

DELIMITER ;