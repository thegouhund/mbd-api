-- CREATE USER 'instructor_1'@'localhost' IDENTIFIED BY 'password_instructor';
-- FLUSH PRIVILEGES;

DROP USER IF EXISTS 'app' @'localhost';
CREATE USER IF NOT EXISTS 'app' @'localhost' IDENTIFIED BY 'password_db_app';
GRANT EXECUTE ON *.* TO 'app' @'localhost';
FLUSH PRIVILEGES;
GRANT EXECUTE ON PROCEDURE course_mbd_db.AddModuleToCourse TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.CreateCourse TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.DeleteCourse TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.DeleteModule TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.EnrollUser TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetAllCourses TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetCourseById TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetCoursesByCreatorId TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetCourseStudents TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetModulesForCourse TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetStudentCourses TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.GetUserByID TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.Login TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.Register TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.UnenrollUser TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.UpdateCourseDetails TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE course_mbd_db.UpdateModule TO 'app'@'localhost';
SHOW GRANTS FOR 'app' @'localhost';
-- CREATE USER 'student_1'@'localhost' IDENTIFIED BY 'password_student1';
-- FLUSH PRIVILEGES;



-- GRANT EXECUTE ON PROCEDURE course_mbd_db.CreateCourse TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.UpdateCourseDetails TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.DeleteCourse TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.AddModuleToCourse TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.UpdateModule TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.DeleteModule TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetAllCourses TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetModulesForCourse TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetCourseStudents TO 'instructor_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.DeleteCourse TO 'instructor_1'@'localhost';

-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetAllCourses TO 'student_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetModulesForCourse TO 'student_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetStudentCourses TO 'student_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.EnrollUser TO 'student_1'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.UnenrollUser TO 'student_1'@'localhost';

-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetUserByID TO 'instructor_1'@'localhost', 'student_1'@'localhost', 'student_2'@'localhost';
-- GRANT EXECUTE ON PROCEDURE course_mbd_db.GetAllUsers TO 'instructor_1'@'localhost', 'student_1'@'localhost', 'student_2'@'localhost';

-- GRANT SELECT ON course_mbd_db.courses TO 'instructor_1'@'localhost';
-- GRANT SELECT ON course_mbd_db.modules TO 'instructor_1'@'localhost';
-- GRANT SELECT ON course_mbd_db.enrollments TO 'instructor_1'@'localhost';

-- GRANT SELECT ON course_mbd_db.courses TO 'student_1'@'localhost';
-- GRANT SELECT ON course_mbd_db.modules TO 'student_1'@'localhost';
-- GRANT SELECT ON course_mbd_db.enrollments TO 'student_1'@'localhost';

-- REVOKE SELECT ON course_mbd_db.enrollments FROM 'student_1'@'localhost';

-- GRANT UPDATE(password) ON course_mbd_db.users TO 'instructor_1'@'localhost', 'student_1'@'localhost';

-- GRANT SELECT, INSERT ON course_mbd_db.courses TO 'instructor_1'@'localhost';
-- SHOW GRANTS FOR 'instructor_1'@'localhost';

-- select user, host from mysql.user;