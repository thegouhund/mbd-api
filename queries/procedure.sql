DELIMITER $$

-- CREATE OR REPLACE PROCEDURE Login(
--     IN p_username VARCHAR(255),
--     IN p_password VARCHAR(255),
--     OUT p_success INT
-- )
-- BEGIN
--     SELECT EXISTS(
--         SELECT user_id FROM v_users WHERE username = p_username AND password = SHA2(p_password, 256)
--     ) INTO p_success;
-- END$$

CREATE OR REPLACE PROCEDURE Login(
    IN p_username VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_username VARCHAR(255);
    DECLARE v_role VARCHAR(20);
    
    SELECT user_id, username, role 
    INTO v_user_id, v_username, v_role
    FROM users 
    WHERE username = p_username AND password = SHA2(p_password, 256)
    LIMIT 1;
    
    IF v_user_id IS NULL THEN
        SELECT 'ERROR' AS status, 'Invalid username or password' AS message, NULL AS user_id, NULL AS username, NULL AS role;
    ELSE
        SELECT 'OK' AS status, 'Login successful' AS message, v_user_id AS user_id, v_username AS username, v_role AS role;
    END IF;
END$$

CREATE OR REPLACE PROCEDURE Register(
    IN p_username VARCHAR(255), 
    IN p_password VARCHAR(255), 
    IN p_role ENUM('student', 'instructor')
)
BEGIN
    DECLARE v_existing_user_id INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN   
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT user_id INTO v_existing_user_id
    FROM users 
    WHERE username = p_username
    LIMIT 1;
    
    IF v_existing_user_id IS NOT NULL THEN
        SELECT 'ERROR' AS status, 'Username sudah terdaftar' AS message, NULL AS username, NULL AS role;
    ELSE
        START TRANSACTION;
        INSERT INTO users (username, password, role) 
        VALUES (p_username, SHA2(p_password, 256), p_role);
        COMMIT;
        
        SELECT 'OK' AS status, 'Registrasi berhasil' AS message, p_username AS username, p_role AS role;
    END IF;
END$$

CREATE OR REPLACE PROCEDURE GetUserByID(IN p_user_id INT)
BEGIN
    SELECT user_id, username, role FROM v_users WHERE user_id = p_user_id;
END$$

CREATE OR REPLACE PROCEDURE DeleteUser(IN p_user_id INT)
BEGIN
    DECLARE v_role VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR' AS status, 'Gagal menghapus pengguna' AS message;
    END;

    START TRANSACTION;

    SELECT role INTO v_role FROM users WHERE user_id = p_user_id FOR UPDATE;

    IF v_role = 'instructor' THEN
        DELETE FROM courses WHERE creator_id = p_user_id;
    END IF;

    DELETE FROM users WHERE user_id = p_user_id;

    COMMIT;
    
    SELECT 'OK' AS status, 'User Berhasil Dihapus' AS message;
END$$

CREATE OR REPLACE PROCEDURE CreateCourse(
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_creator_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT CheckUserRole(p_creator_id, 'instructor') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya instructor yang dapat membuat course.';
    END IF;

    START TRANSACTION;
        INSERT INTO courses (title, description, creator_id)
        VALUES (p_title, p_description, p_creator_id);
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE GetAllCourses()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Gagal mengambil daftar course';
    END;

    START TRANSACTION;
    SELECT course_id, title, description, creator_id FROM v_courses;
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE UpdateCourseDetails(IN p_course_id INT, IN p_new_title VARCHAR(255), IN p_new_description TEXT, IN p_creator_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT CheckUserRole(p_creator_id, 'instructor') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Creator harus role instructor';
    END IF;

    START TRANSACTION;
    UPDATE courses SET title = p_new_title, description = p_new_description WHERE course_id = p_course_id;
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE DeleteCourse(IN p_course_id INT, IN p_creator_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT CheckUserRole(p_creator_id, 'instructor') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Creator harus role instructor';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course tidak ditemukan';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id AND creator_id = p_creator_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya creator course yang dapat menghapus course ini.';
    END IF;

    START TRANSACTION;
    DELETE FROM courses WHERE course_id = p_course_id;
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE AddModuleToCourse(IN p_course_id INT, IN p_title VARCHAR(255), IN p_content TEXT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course tidak ditemukan';
    END IF;

    START TRANSACTION;
    INSERT INTO modules (course_id, title, content) VALUES (p_course_id, p_title, p_content);
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE GetModulesForCourse(IN p_course_id INT, IN p_user_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course tidak ditemukan';
    END IF;

    IF NOT IsCreatorOfCourse(p_user_id, p_course_id) THEN 
        IF NOT IsUserEnrolledInCourse(p_user_id, p_course_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User belum terdaftar di course ini';
        END IF;
    END IF;

    SELECT module_id, title, content FROM v_modules WHERE course_id = p_course_id;
END$$

CREATE OR REPLACE PROCEDURE UpdateModule(IN p_module_id INT, IN p_new_title VARCHAR(255), IN p_new_content TEXT, IN p_creator_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM modules WHERE module_id = p_module_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modul tidak ditemukan';
    END IF;

    IF NOT IsCreatorOfCourse(p_creator_id, (SELECT course_id FROM modules WHERE module_id = p_module_id)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User belum terdaftar di course ini';
    END IF;

    START TRANSACTION;
    UPDATE modules SET title = p_new_title, content = p_new_content WHERE module_id = p_module_id;
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE DeleteModule(IN p_module_id INT, IN p_creator_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM modules WHERE module_id = p_module_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modul tidak ditemukan';
    END IF;

    IF NOT IsCreatorOfCourse(p_creator_id, (SELECT course_id FROM modules WHERE module_id = p_module_id)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User belum terdaftar di course ini';
    END IF;

    START TRANSACTION;
    DELETE FROM modules WHERE module_id = p_module_id;
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE EnrollUser(IN p_user_id INT, IN p_course_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User tidak ditemukan';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course tidak ditemukan';
    END IF;

    IF EXISTS (
        SELECT 1 FROM enrollments 
        WHERE user_id = p_user_id AND course_id = p_course_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User sudah terdaftar di course ini';
    END IF;

    START TRANSACTION;
        INSERT INTO enrollments (user_id, course_id) VALUES (p_user_id, p_course_id);
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE UnenrollUser(IN p_user_id INT, IN p_course_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User tidak ditemukan';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course tidak ditemukan';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM enrollments WHERE user_id = p_user_id AND course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User tidak terdaftar di course ini';
    END IF;

    START TRANSACTION;
    DELETE FROM enrollments WHERE user_id = p_user_id AND course_id = p_course_id;
    COMMIT;
END$$

CREATE OR REPLACE PROCEDURE GetStudentCourses(IN p_user_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User tidak ditemukan';
    END IF;

    SELECT c.course_id, c.title, c.description
    FROM v_courses c
    JOIN enrollments e ON c.course_id = e.course_id
    WHERE e.user_id = p_user_id;
END$$

CREATE OR REPLACE PROCEDURE GetCourseStudents(IN p_course_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = p_course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course tidak ditemukan';
    END IF;

    SELECT u.user_id, u.username
    FROM v_users u
    JOIN enrollments e ON u.user_id = e.user_id
    WHERE e.course_id = p_course_id;
END$$

CREATE OR REPLACE PROCEDURE GetAllUsers()
BEGIN
    SELECT user_id, username, role, password FROM v_users;
END$$

CREATE OR REPLACE PROCEDURE GetAllInstructors()
BEGIN
    SELECT * FROM v_users WHERE role = 'instructor';
END$$

CREATE OR REPLACE PROCEDURE GetAllStudents()
BEGIN
    SELECT * FROM v_users WHERE role = 'student';
END$$

DELIMITER;

CALL Register ( 'instructor_4', 'password123', 'instructor' )

CALL Login ( 'student_5', 'password123', @current_user_id );

SELECT @current_user_id AS current_user_id;

CALL GetAllUsers ();
-- CALL CreateCourse ( 'Javascript', 'Belajar Javascript', 15 );
-- CALL CreateCourse('Database', 'Belajar Database', 1);
CALL CreateCourse (
    'Test Course',
    'Belajar Database',
    @current_user_id
);

CALL GetAllCourses ();
-- CALL DeleteUser(1);
CALL AddModuleToCourse (
    66,
    'Variabel dan Tipe Data',
    'Variabel dan Tipe Data di Javascript adalah...'
);
-- CALL AddModuleToCourse(1, 'Fungsi dan Objek', 'Fungsi dan Objek di Javascript adalah...');
-- CALL AddModuleToCourse(1, 'Arrow Function', 'Arrow Function di Javascript adalah...');
-- CALL AddModuleToCourse(2, 'Pengertian Database', 'Pengertian Database adalah...');
-- CALL AddModuleToCourse(57, 'Relasi', 'Relasi dalam Database adalah...');
-- CALL EnrollUser(2, 2);
-- CALL EnrollUser(3, 1);
-- CALL EnrollUser(3, 2);
-- CALL GetUserByID(4);
-- CALL UpdateModule(12, 'Variabel, Tipe Data, dan Operasi', 'Variabel, Tipe Data, dan Operasi di Javascript adalah...');
-- CALL GetAllCourses ();
-- CALL `DeleteCourse`(64, 19);

CALL GetModulesForCourse (66);
-- CALL DeleteModule(12);
-- CALL DeleteModule(8);
-- CALL GetStudentCourses(3);
-- CALL GetCourseStudents(1);
-- CALL UpdateUserPassword(2, 'new_secure_password');
-- CALL UpdateCourseDetails (
--     57,
--     'Advanced Database Concepts',
--     'An in-depth course on database normalization and indexing.',
--     15
-- );
-- CALL UnenrollUser(2,2);