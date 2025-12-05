CREATE OR REPLACE VIEW v_enrollmentreport AS
SELECT
    e.enrollment_id,
    e.created_at AS enrollment_date,
    u.user_id AS student_id,
    u.username AS student_name,
    c.course_id,
    c.title AS course_title
FROM
    enrollments e
    JOIN users u ON e.user_id = u.user_id
    JOIN courses c ON e.course_id = c.course_id
WHERE
    u.role = 'student';

CREATE OR REPLACE VIEW v_users AS
SELECT user_id, username, role, password
FROM users;

CREATE OR REPLACE VIEW v_courses AS
SELECT course_id, title, description
FROM courses;

CREATE OR REPLACE VIEW v_enrollments AS
SELECT
    enrollment_id,
    users.user_id
    users.username,
    courses.title,
    created_at
FROM enrollments
    JOIN users ON enrollments.user_id = users.user_id
    JOIN courses ON enrollments.course_id = courses.course_id;

CREATE OR REPLACE VIEW v_courses AS
SELECT
    course_id,
    title,
    description,
    creator_id
FROM courses;

CREATE OR REPLACE VIEW v_modules AS
SELECT
    m.module_id,
    m.title,
    m.content,
    m.course_id,
    c.title AS course_title
FROM modules m
    JOIN courses c ON m.course_id = c.course_id;
