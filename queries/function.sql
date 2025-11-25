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

DELIMITER ;