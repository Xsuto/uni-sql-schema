CREATE TABLE Employee (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    street VARCHAR(255) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    phone VARCHAR(15) NOT NULL,
    pesel VARCHAR(11) UNIQUE,
    employment_date DATE NOT NULL,
    termination_date DATE,
    bank_account_number VARCHAR(34)
);

CREATE TABLE Institution (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    street VARCHAR(255) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    phone VARCHAR(15),
    rector_id BIGINT UNSIGNED UNIQUE,
    FOREIGN KEY (rector_id) REFERENCES Employee(id) ON DELETE RESTRICT
);

CREATE TABLE InstitutionDean (
    institution_id BIGINT UNSIGNED NOT NULL,
    dean_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (institution_id, dean_id),
    FOREIGN KEY (dean_id) REFERENCES Employee(id) ON DELETE RESTRICT,
    FOREIGN KEY (institution_id) REFERENCES Institution(id) ON DELETE RESTRICT 
);

CREATE TABLE EmployeeRole (
    id SERIAL PRIMARY KEY,
    employee_id BIGINT UNSIGNED NOT NULL,
    role ENUM ( 'Dean', 'Rector', 'Lecturer') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE,
    UNIQUE (employee_id, role)
);

CREATE TABLE Subject (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    ects INTEGER NOT NULL,
    language VARCHAR(50) NOT NULL
);

CREATE TABLE EmployeeSubject (
    employee_id BIGINT UNSIGNED NOT NULL,
    subject_id BIGINT UNSIGNED NOT NULL,
    academic_year VARCHAR(10), -- e.g., "2023/2024"
    semester VARCHAR(20),      -- e.g., "Winter", "Summer"
    PRIMARY KEY (employee_id, subject_id, academic_year, semester),
    FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subject(id) ON DELETE CASCADE
);

CREATE TABLE StudentGroup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    supervisor_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (supervisor_id) REFERENCES Employee(id) ON DELETE RESTRICT
);

CREATE TABLE Student(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    birth_date DATE NOT NULL,
    street VARCHAR(255) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    phone VARCHAR(15) NOT NULL,
    pesel VARCHAR(11) UNIQUE,
    group_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (group_id) REFERENCES StudentGroup(id) ON DELETE RESTRICT 
);

CREATE TABLE Grade (
    id SERIAL PRIMARY KEY,
    student_id BIGINT UNSIGNED NOT NULL,
    subject_id BIGINT UNSIGNED NOT NULL,
    lecturer_id BIGINT UNSIGNED NOT NULL,
    grade_value DECIMAL(2,1) NOT NULL CHECK (grade_value IN (2.0, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5)),
    description VARCHAR(100),
    assessment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES Student(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subject(id) ON DELETE RESTRICT,
    FOREIGN KEY (lecturer_id) REFERENCES Employee(id) ON DELETE RESTRICT 
);

CREATE TABLE FinalGrade (
    id SERIAL PRIMARY KEY,
    student_id BIGINT UNSIGNED NOT NULL,
    subject_id BIGINT UNSIGNED NOT NULL,
    lecturer_id BIGINT UNSIGNED NOT NULL,
    grade_value DECIMAL(2,1) NOT NULL CHECK (grade_value IN (2.0, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5)),
    assessment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES Student(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subject(id) ON DELETE RESTRICT,
    FOREIGN KEY (lecturer_id) REFERENCES Employee(id) ON DELETE RESTRICT,
    UNIQUE (student_id, subject_id)
);

