CREATE DATABASE School

USE School

CREATE TABLE Students
(
	Id INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(25),
	LastName NVARCHAR(30) NOT NULL,
	Age INT NOT NULL CHECK(Age > 0),
	Address NVARCHAR(50),
	Phone NCHAR(10)
)

CREATE TABLE Subjects
(
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(20) NOT NULL,
	Lessons INT NOT NULL
) 

CREATE TABLE StudentsSubjects
(
	Id INT IDENTITY PRIMARY KEY,
	StudentId INT NOT NULL,
	SubjectId INT NOT NULL,
	Grade DECIMAL(18, 2) NOT NULL CHECK(Grade >= 2 AND Grade <= 6)

	CONSTRAINT FK_StudentsSubjects_Students FOREIGN KEY(StudentId) REFERENCES Students(Id),
	CONSTRAINT FK_StudentsSubjects_Subjects FOREIGN KEY(SubjectId) REFERENCES Subjects(Id)
)
CREATE TABLE Exams
(
	Id INT IDENTITY PRIMARY KEY,
	Date DATETIME,
	SubjectId INT NOT NULL,

	CONSTRAINT FK_Exams_Subjects FOREIGN KEY(SubjectId) REFERENCES Subjects(Id) 
)

CREATE TABLE StudentsExams
(
	StudentId INT NOT NULL,
	ExamId INT NOT NULL,
	Grade DECIMAL(18, 2) NOT NULL CHECK(Grade >= 2 AND Grade <= 6)

	CONSTRAINT FK_StudentsExams_Students FOREIGN KEY(StudentId) REFERENCES Students(Id),
	CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY(ExamId) REFERENCES Exams(Id),
	CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentId, ExamId)
)

CREATE TABLE Teachers
(
	Id INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	Address NVARCHAR(20) NOT NULL,
	Phone NCHAR(10),
	SubjectId INT NOT NULL,

	CONSTRAINT FK_Teachers_Subjects FOREIGN KEY(SubjectId) REFERENCES Subjects(Id),
)

CREATE TABLE StudentsTeachers
(
	StudentId INT NOT NULL,
	TeacherId INT NOT NULL,

	CONSTRAINT FK_StudentsTeachers_Students FOREIGN KEY(StudentId) REFERENCES Students(Id),
	CONSTRAINT FK_StudentsTeachers_Teachers FOREIGN KEY(TeacherId) REFERENCES Teachers(Id),
	CONSTRAINT PK_StudentsTeachers PRIMARY KEY(StudentId, TeacherId),
)

-- 2. Insert
INSERT INTO Teachers(FirstName,	LastName,	Address,	Phone,	SubjectId)
VALUES
('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
('Gerrard',	'Lowin', '370 Talisman Plaza',	'3324874824', 2),
('Merrile',	'Lambdin',	'81 Dahle Plaza',	'4373065154',	5),
('Bert',	'Ivie',	'2 Gateway Circle',	'4409584510',	4)

-- 3. Update
INSERT INTO Subjects(Name,	Lessons)
VALUES
('Geometry', 12),
('Health', 10),
('Drama', 7),
('Sports', 9)

UPDATE StudentsSubjects
SET Grade = 6.00
WHERE SubjectId IN(1, 2) AND Grade >= 5.50

-- 4. Delete
DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone LIKE '%72%')

DELETE FROM Teachers
WHERE Phone LIKE '%72%'

-- 5. Teen Students
SELECT FirstName, LastName, Age
	FROM Students
	WHERE Age >= 12
	ORDER BY FirstName ASC, LastName ASC

-- 6. Students Teachers
SELECT FirstName, LastName, COUNT(TeacherId) AS TeachersCount
	FROM StudentsTeachers
	JOIN Students ON StudentsTeachers.StudentId = Students.Id
	GROUP BY StudentsTeachers.StudentId, FirstName, LastName

-- 7. Students to Go