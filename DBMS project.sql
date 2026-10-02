/* =========================================================
   SMART UNIVERSITY ACADEMIC MANAGEMENT SYSTEM
   DBMS PROJECT - MYSQL
   ========================================================= */


/* =========================================================
   1. CREATE DATABASE
   ========================================================= */



CREATE DATABASE smart_university;

USE smart_university;


/* =========================================================
   2. DEPARTMENT TABLE
   ========================================================= */

CREATE TABLE department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    hod_name VARCHAR(100),
    office_email VARCHAR(100) UNIQUE
);


/* =========================================================
   3. STUDENT TABLE
   ========================================================= */

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    department_id INT NOT NULL,
    admission_year YEAR NOT NULL,
    current_semester INT NOT NULL,

    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id),

    CONSTRAINT chk_student_semester
        CHECK (current_semester BETWEEN 1 AND 8)
);


/* =========================================================
   4. FACULTY TABLE
   ========================================================= */

CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    designation VARCHAR(50),
    department_id INT NOT NULL,

    CONSTRAINT fk_faculty_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);


/* =========================================================
   5. COURSE TABLE
   ========================================================= */

CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    semester INT NOT NULL,
    department_id INT NOT NULL,
    faculty_id INT,

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id),

    CONSTRAINT fk_course_faculty
        FOREIGN KEY (faculty_id)
        REFERENCES faculty(faculty_id),

    CONSTRAINT chk_course_credits
        CHECK (credits BETWEEN 1 AND 10),

    CONSTRAINT chk_course_semester
        CHECK (semester BETWEEN 1 AND 8)
);


/* =========================================================
   6. ENROLLMENT TABLE
   ========================================================= */

CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    semester INT NOT NULL,
    enrollment_date DATE NOT NULL,

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES course(course_id),

    CONSTRAINT chk_enrollment_semester
        CHECK (semester BETWEEN 1 AND 8),

    CONSTRAINT uq_student_course
        UNIQUE(student_id, course_id, academic_year)
);


/* =========================================================
   7. ATTENDANCE TABLE
   ========================================================= */

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    semester INT NOT NULL,
    classes_held INT NOT NULL,
    classes_attended INT NOT NULL,

    attendance_percentage
        DECIMAL(5,2)
        GENERATED ALWAYS AS
        (
            CASE
                WHEN classes_held = 0 THEN 0
                ELSE (classes_attended / classes_held) * 100
            END
        ) STORED,

    CONSTRAINT fk_attendance_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_attendance_course
        FOREIGN KEY (course_id)
        REFERENCES course(course_id),

    CONSTRAINT chk_classes_held
        CHECK (classes_held >= 0),

    CONSTRAINT chk_classes_attended
        CHECK (
            classes_attended >= 0
            AND classes_attended <= classes_held
        )
);


/* =========================================================
   8. EXAMINATION TABLE
   ========================================================= */

CREATE TABLE examination (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    exam_type VARCHAR(50) NOT NULL,
    exam_date DATE NOT NULL,
    maximum_marks INT NOT NULL,

    CONSTRAINT fk_exam_course
        FOREIGN KEY (course_id)
        REFERENCES course(course_id),

    CONSTRAINT chk_maximum_marks
        CHECK (maximum_marks > 0)
);


/* =========================================================
   9. RESULT TABLE
   ========================================================= */

CREATE TABLE result (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    exam_id INT NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    grade VARCHAR(5),
    result_status VARCHAR(10),

    CONSTRAINT fk_result_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_result_exam
        FOREIGN KEY (exam_id)
        REFERENCES examination(exam_id),

    CONSTRAINT chk_marks
        CHECK (marks_obtained >= 0 AND marks_obtained <= 100),

    CONSTRAINT uq_student_exam
        UNIQUE(student_id, exam_id)
);


/* =========================================================
   10. PLACEMENT TABLE
   ========================================================= */

CREATE TABLE placement (
    placement_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    package_lpa DECIMAL(6,2),
    placement_status VARCHAR(30) NOT NULL,
    placement_date DATE,

    CONSTRAINT fk_placement_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT chk_package
        CHECK (package_lpa >= 0)
);


/* =========================================================
   11. SCHOLARSHIP TABLE
   ========================================================= */

CREATE TABLE scholarship (
    scholarship_id INT PRIMARY KEY AUTO_INCREMENT,
    scholarship_name VARCHAR(100) NOT NULL,
    minimum_percentage DECIMAL(5,2) NOT NULL,
    maximum_income DECIMAL(12,2) NOT NULL,

    CONSTRAINT chk_scholarship_percentage
        CHECK (
            minimum_percentage BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_scholarship_income
        CHECK (maximum_income >= 0)
);


/* =========================================================
   12. STUDENT SCHOLARSHIP TABLE
   ========================================================= */

CREATE TABLE student_scholarship (
    student_id INT NOT NULL,
    scholarship_id INT NOT NULL,
    family_income DECIMAL(12,2) NOT NULL,
    application_status VARCHAR(30) DEFAULT 'PENDING',

    PRIMARY KEY(student_id, scholarship_id),

    CONSTRAINT fk_ss_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_ss_scholarship
        FOREIGN KEY (scholarship_id)
        REFERENCES scholarship(scholarship_id),

    CONSTRAINT chk_family_income
        CHECK (family_income >= 0)
);


/* =========================================================
   13. PERFORMANCE HISTORY TABLE
   ========================================================= */

CREATE TABLE performance_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    semester INT NOT NULL,
    semester_percentage DECIMAL(5,2) NOT NULL,

    CONSTRAINT fk_history_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT chk_semester_percentage
        CHECK (
            semester_percentage BETWEEN 0 AND 100
        )
);


/* =========================================================
   14. AUDIT TABLE
   ========================================================= */

CREATE TABLE result_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    result_id INT,
    student_id INT,
    action_type VARCHAR(30),
    old_marks DECIMAL(5,2),
    new_marks DECIMAL(5,2),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


/* =========================================================
   15. INSERT DEPARTMENTS
   ========================================================= */

INSERT INTO department
(department_name, hod_name, office_email)
VALUES
('Artificial Intelligence and Machine Learning',
 'Dr. Rajesh Kumar',
 'aiml@university.edu'),

('Computer Science and Engineering',
 'Dr. Suresh Rao',
 'cse@university.edu'),

('Electronics and Communication Engineering',
 'Dr. Priya Sharma',
 'ece@university.edu'),

('Information Technology',
 'Dr. Anil Kumar',
 'it@university.edu');


/* =========================================================
   16. INSERT STUDENTS
   ========================================================= */

INSERT INTO student
(student_id, student_name, gender, date_of_birth,
 phone, email, department_id, admission_year, current_semester)
VALUES
(101, 'Amrutha', 'Female', '2007-07-12',
 '9000000001', 'amrutha@university.edu', 1, 2025, 3),

(102, 'Rahul', 'Male', '2006-05-15',
 '9000000002', 'rahul@university.edu', 2, 2025, 3),

(103, 'Sneha', 'Female', '2007-02-10',
 '9000000003', 'sneha@university.edu', 1, 2025, 3),

(104, 'Kiran', 'Male', '2006-11-21',
 '9000000004', 'kiran@university.edu', 3, 2025, 3),

(105, 'Anjali', 'Female', '2007-08-18',
 '9000000005', 'anjali@university.edu', 1, 2025, 3),

(106, 'Vijay', 'Male', '2006-03-25',
 '9000000006', 'vijay@university.edu', 2, 2025, 3),

(107, 'Pooja', 'Female', '2007-09-30',
 '9000000007', 'pooja@university.edu', 4, 2025, 3),

(108, 'Arjun', 'Male', '2006-06-14',
 '9000000008', 'arjun@university.edu', 1, 2025, 3);


/* =========================================================
   17. INSERT FACULTY
   ========================================================= */

INSERT INTO faculty
(faculty_name, email, phone, designation, department_id)
VALUES
('Dr. Meena Rao', 'meena@university.edu',
 '9100000001', 'Professor', 1),

('Prof. Naveen Kumar', 'naveen@university.edu',
 '9100000002', 'Associate Professor', 2),

('Dr. Kavitha Singh', 'kavitha@university.edu',
 '9100000003', 'Professor', 3),

('Prof. Arun Prasad', 'arun@university.edu',
 '9100000004', 'Assistant Professor', 4);


/* =========================================================
   18. INSERT COURSES
   ========================================================= */

INSERT INTO course
(course_code, course_name, credits, semester, department_id, faculty_id)
VALUES
('AI301', 'Artificial Intelligence', 4, 3, 1, 1),
('ML301', 'Machine Learning', 4, 3, 1, 1),
('DB301', 'Database Management Systems', 4, 3, 1, 1),
('CS301', 'Data Structures', 4, 3, 2, 2),
('CS302', 'Operating Systems', 4, 3, 2, 2),
('EC301', 'Digital Electronics', 4, 3, 3, 3),
('IT301', 'Web Technologies', 4, 3, 4, 4);


/* =========================================================
   19. INSERT ENROLLMENTS
   ========================================================= */

INSERT INTO enrollment
(student_id, course_id, academic_year, semester, enrollment_date)
VALUES
(101, 1, '2026-27', 3, '2026-07-01'),
(101, 2, '2026-27', 3, '2026-07-01'),
(101, 3, '2026-27', 3, '2026-07-01'),

(102, 4, '2026-27', 3, '2026-07-01'),
(102, 5, '2026-27', 3, '2026-07-01'),

(103, 1, '2026-27', 3, '2026-07-01'),
(103, 2, '2026-27', 3, '2026-07-01'),

(104, 6, '2026-27', 3, '2026-07-01'),

(105, 1, '2026-27', 3, '2026-07-01'),
(105, 2, '2026-27', 3, '2026-07-01'),

(106, 4, '2026-27', 3, '2026-07-01'),

(107, 7, '2026-27', 3, '2026-07-01'),

(108, 1, '2026-27', 3, '2026-07-01'),
(108, 2, '2026-27', 3, '2026-07-01');


/* =========================================================
   20. INSERT ATTENDANCE
   ========================================================= */

INSERT INTO attendance
(student_id, course_id, academic_year, semester,
 classes_held, classes_attended)
VALUES
(101, 1, '2026-27', 3, 50, 45),
(101, 2, '2026-27', 3, 50, 43),
(101, 3, '2026-27', 3, 50, 47),

(102, 4, '2026-27', 3, 50, 40),
(102, 5, '2026-27', 3, 50, 38),

(103, 1, '2026-27', 3, 50, 35),
(103, 2, '2026-27', 3, 50, 32),

(104, 6, '2026-27', 3, 50, 30),

(105, 1, '2026-27', 3, 50, 48),
(105, 2, '2026-27', 3, 50, 46),

(106, 4, '2026-27', 3, 50, 25),

(107, 7, '2026-27', 3, 50, 42),

(108, 1, '2026-27', 3, 50, 20),
(108, 2, '2026-27', 3, 50, 22);


/* =========================================================
   21. INSERT EXAMINATIONS
   ========================================================= */

INSERT INTO examination
(course_id, exam_type, exam_date, maximum_marks)
VALUES
(1, 'Internal-1', '2026-08-01', 100),
(2, 'Internal-1', '2026-08-03', 100),
(3, 'Internal-1', '2026-08-05', 100),
(4, 'Internal-1', '2026-08-07', 100),
(5, 'Internal-1', '2026-08-09', 100),
(6, 'Internal-1', '2026-08-11', 100),
(7, 'Internal-1', '2026-08-13', 100);


/* =========================================================
   22. RESULT TRIGGER
   Automatically calculates grade and status
   ========================================================= */

DELIMITER $$

CREATE TRIGGER before_result_insert
BEFORE INSERT ON result
FOR EACH ROW
BEGIN

    IF NEW.marks_obtained >= 90 THEN
        SET NEW.grade = 'A+';
    ELSEIF NEW.marks_obtained >= 80 THEN
        SET NEW.grade = 'A';
    ELSEIF NEW.marks_obtained >= 70 THEN
        SET NEW.grade = 'B';
    ELSEIF NEW.marks_obtained >= 60 THEN
        SET NEW.grade = 'C';
    ELSEIF NEW.marks_obtained >= 50 THEN
        SET NEW.grade = 'D';
    ELSE
        SET NEW.grade = 'F';
    END IF;

    IF NEW.marks_obtained >= 40 THEN
        SET NEW.result_status = 'PASS';
    ELSE
        SET NEW.result_status = 'FAIL';
    END IF;

END$$

DELIMITER ;


/* =========================================================
   23. INSERT RESULTS
   Grade/status will be automatically generated
   ========================================================= */

INSERT INTO result
(student_id, exam_id, marks_obtained)
VALUES
(101, 1, 85),
(101, 2, 82),
(101, 3, 90),

(102, 4, 68),
(102, 5, 72),

(103, 1, 55),
(103, 2, 48),

(104, 6, 38),

(105, 1, 92),
(105, 2, 88),

(106, 4, 35),

(107, 7, 78),

(108, 1, 30),
(108, 2, 35);


/* =========================================================
   24. SCHOLARSHIPS
   ========================================================= */

INSERT INTO scholarship
(scholarship_name, minimum_percentage, maximum_income)
VALUES
('Merit Scholarship', 80, 500000),
('Academic Excellence Scholarship', 90, 800000),
('Need Based Scholarship', 60, 300000);


/* =========================================================
   25. STUDENT SCHOLARSHIP APPLICATIONS
   ========================================================= */

INSERT INTO student_scholarship
(student_id, scholarship_id, family_income, application_status)
VALUES
(101, 1, 400000, 'APPROVED'),
(105, 2, 600000, 'APPROVED'),
(103, 3, 250000, 'PENDING'),
(108, 3, 200000, 'PENDING');


/* =========================================================
   26. PERFORMANCE HISTORY
   ========================================================= */

INSERT INTO performance_history
(student_id, academic_year, semester, semester_percentage)
VALUES
(101, '2024-25', 1, 68),
(101, '2025-26', 2, 75),
(101, '2026-27', 3, 85),

(102, '2024-25', 1, 62),
(102, '2025-26', 2, 70),
(102, '2026-27', 3, 70),

(103, '2024-25', 1, 72),
(103, '2025-26', 2, 65),
(103, '2026-27', 3, 51),

(105, '2024-25', 1, 80),
(105, '2025-26', 2, 86),
(105, '2026-27', 3, 90),

(108, '2024-25', 1, 70),
(108, '2025-26', 2, 55),
(108, '2026-27', 3, 32);


/* =========================================================
   27. ACADEMIC RISK FUNCTION
   ========================================================= */

DELIMITER $$

CREATE FUNCTION calculate_risk(
    attendance_value DECIMAL(5,2),
    average_marks DECIMAL(5,2),
    failed_subjects INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN

    IF attendance_value < 60
       OR average_marks < 40
       OR failed_subjects >= 2 THEN

        RETURN 'HIGH RISK';

    ELSEIF attendance_value < 75
       OR average_marks < 60
       OR failed_subjects = 1 THEN

        RETURN 'MEDIUM RISK';

    ELSE

        RETURN 'LOW RISK';

    END IF;

END$$

DELIMITER ;


/* =========================================================
   28. ACADEMIC RISK VIEW
   ========================================================= */

CREATE VIEW academic_risk_report AS

SELECT
    s.student_id,
    s.student_name,

    ROUND(AVG(a.attendance_percentage), 2)
        AS average_attendance,

    ROUND(
        COALESCE(
            (
                SELECT AVG(r.marks_obtained)
                FROM result r
                WHERE r.student_id = s.student_id
            ),
            0
        ),
        2
    ) AS average_marks,

    (
        SELECT COUNT(*)
        FROM result r2
        WHERE r2.student_id = s.student_id
          AND r2.result_status = 'FAIL'
    ) AS failed_subjects,

    calculate_risk(
        ROUND(AVG(a.attendance_percentage), 2),

        ROUND(
            COALESCE(
                (
                    SELECT AVG(r3.marks_obtained)
                    FROM result r3
                    WHERE r3.student_id = s.student_id
                ),
                0
            ),
            2
        ),

        (
            SELECT COUNT(*)
            FROM result r4
            WHERE r4.student_id = s.student_id
              AND r4.result_status = 'FAIL'
        )
    ) AS risk_level

FROM student s
LEFT JOIN attendance a
    ON s.student_id = a.student_id

GROUP BY
    s.student_id,
    s.student_name;


/* =========================================================
   29. PLACEMENT ELIGIBILITY FUNCTION
   ========================================================= */

DELIMITER $$

CREATE FUNCTION placement_eligibility(
    input_student_id INT
)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN

    DECLARE avg_marks DECIMAL(5,2);
    DECLARE avg_attendance DECIMAL(5,2);
    DECLARE failed_count INT;

    SELECT
        COALESCE(AVG(marks_obtained), 0)
    INTO avg_marks
    FROM result
    WHERE student_id = input_student_id;

    SELECT
        COALESCE(AVG(attendance_percentage), 0)
    INTO avg_attendance
    FROM attendance
    WHERE student_id = input_student_id;

    SELECT
        COUNT(*)
    INTO failed_count
    FROM result
    WHERE student_id = input_student_id
      AND result_status = 'FAIL';

    IF avg_marks >= 60
       AND avg_attendance >= 75
       AND failed_count = 0 THEN

        RETURN 'ELIGIBLE';

    ELSE

        RETURN 'NOT ELIGIBLE';

    END IF;

END$$

DELIMITER ;


/* =========================================================
   30. PLACEMENT ELIGIBILITY VIEW
   ========================================================= */

CREATE VIEW placement_eligibility_report AS

SELECT
    s.student_id,
    s.student_name,

    ROUND(
        COALESCE(
            (
                SELECT AVG(r.marks_obtained)
                FROM result r
                WHERE r.student_id = s.student_id
            ),
            0
        ),
        2
    ) AS average_marks,

    ROUND(
        COALESCE(
            (
                SELECT AVG(a.attendance_percentage)
                FROM attendance a
                WHERE a.student_id = s.student_id
            ),
            0
        ),
        2
    ) AS average_attendance,

    (
        SELECT COUNT(*)
        FROM result r2
        WHERE r2.student_id = s.student_id
          AND r2.result_status = 'FAIL'
    ) AS backlogs,

    placement_eligibility(s.student_id)
        AS placement_status

FROM student s;


/* =========================================================
   31. STUDENT ACADEMIC SUMMARY VIEW
   ========================================================= */

CREATE VIEW student_academic_summary AS

SELECT
    s.student_id,
    s.student_name,
    d.department_name,

    ROUND(
        COALESCE(
            (
                SELECT AVG(r.marks_obtained)
                FROM result r
                WHERE r.student_id = s.student_id
            ),
            0
        ),
        2
    ) AS average_marks,

    ROUND(
        COALESCE(
            (
                SELECT AVG(a.attendance_percentage)
                FROM attendance a
                WHERE a.student_id = s.student_id
            ),
            0
        ),
        2
    ) AS average_attendance,

    (
        SELECT COUNT(*)
        FROM result r2
        WHERE r2.student_id = s.student_id
          AND r2.result_status = 'FAIL'
    ) AS backlogs

FROM student s

JOIN department d
    ON s.department_id = d.department_id;


/* =========================================================
   32. DEPARTMENT PERFORMANCE VIEW
   ========================================================= */

CREATE VIEW department_performance AS

SELECT
    d.department_id,
    d.department_name,
    COUNT(DISTINCT s.student_id) AS total_students,

    ROUND(
        AVG(r.marks_obtained),
        2
    ) AS average_marks,

    ROUND(
        AVG(a.attendance_percentage),
        2
    ) AS average_attendance

FROM department d

LEFT JOIN student s
    ON d.department_id = s.department_id

LEFT JOIN result r
    ON s.student_id = r.student_id

LEFT JOIN attendance a
    ON s.student_id = a.student_id

GROUP BY
    d.department_id,
    d.department_name;


/* =========================================================
   33. RESULT AUDIT TRIGGER
   ========================================================= */

DELIMITER $$

CREATE TRIGGER after_result_update
AFTER UPDATE ON result
FOR EACH ROW
BEGIN

    INSERT INTO result_audit
    (
        result_id,
        student_id,
        action_type,
        old_marks,
        new_marks
    )
    VALUES
    (
        NEW.result_id,
        NEW.student_id,
        'RESULT UPDATED',
        OLD.marks_obtained,
        NEW.marks_obtained
    );

END$$

DELIMITER ;


/* =========================================================
   34. PROCEDURE - STUDENT ACADEMIC REPORT
   ========================================================= */

DELIMITER $$

CREATE PROCEDURE get_student_report(
    IN input_student_id INT
)
BEGIN

    SELECT
        s.student_id,
        s.student_name,
        d.department_name,
        c.course_name,
        e.exam_type,
        r.marks_obtained,
        r.grade,
        r.result_status

    FROM student s

    JOIN department d
        ON s.department_id = d.department_id

    JOIN result r
        ON s.student_id = r.student_id

    JOIN examination e
        ON r.exam_id = e.exam_id

    JOIN course c
        ON e.course_id = c.course_id

    WHERE s.student_id = input_student_id

    ORDER BY e.exam_date;

END$$

DELIMITER ;


/* =========================================================
   35. PROCEDURE - AT RISK STUDENTS
   ========================================================= */

DELIMITER $$

CREATE PROCEDURE get_at_risk_students()
BEGIN

    SELECT *
    FROM academic_risk_report
    WHERE risk_level IN ('HIGH RISK', 'MEDIUM RISK')
    ORDER BY
        CASE risk_level
            WHEN 'HIGH RISK' THEN 1
            WHEN 'MEDIUM RISK' THEN 2
            ELSE 3
        END;

END$$

DELIMITER ;


/* =========================================================
   36. INDEXES
   ========================================================= */

CREATE INDEX idx_student_department
ON student(department_id);

CREATE INDEX idx_result_student
ON result(student_id);

CREATE INDEX idx_attendance_student
ON attendance(student_id);

CREATE INDEX idx_enrollment_student
ON enrollment(student_id);

CREATE INDEX idx_course_department
ON course(department_id);


/* =========================================================
   37. PLACEMENT SAMPLE DATA
   ========================================================= */

INSERT INTO placement
(student_id, company_name, package_lpa,
 placement_status, placement_date)
VALUES
(101, 'Tech Solutions Pvt Ltd', 8.50,
 'SELECTED', '2026-09-01'),

(105, 'AI Innovations Ltd', 10.00,
 'SELECTED', '2026-09-05');


/* =========================================================
   END OF DATABASE CREATION
   ========================================================= */
   
   SHOW DATABASES;
   USE smart_university;
   SHOW TABLES;
   select * from student;
   SELECT * FROM department;
   SELECT * FROM faculty;
   SELECT * FROM course;
   SELECT * FROM enrollment;
   SELECT * FROM attendance;
   SELECT * FROM examination;
   SELECT * FROM result;
   
   SELECT
    student_id,
    course_id,
    classes_held,
    classes_attended,
    attendance_percentage
FROM attendance;

SELECT
    student_id,
    course_id,
    classes_held,
    classes_attended,
    attendance_percentage
FROM attendance;
SELECT *
FROM academic_risk_report;
SELECT *
FROM academic_risk_report
WHERE risk_level = 'HIGH RISK';

SELECT *
FROM placement_eligibility_report;