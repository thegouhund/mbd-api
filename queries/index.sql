CREATE INDEX idx_courses_creator_id ON courses (creator_id);
CREATE INDEX idx_modules_course_id ON modules (course_id);
CREATE INDEX idx_enrollments_course_id ON enrollments (course_id);

CREATE INDEX idx_users_role ON users (role);
CREATE INDEX idx_courses_title ON courses (title);
CREATE INDEX idx_enrollments_created_at ON enrollments (created_at);

SHOW INDEXES FROM enrollments;