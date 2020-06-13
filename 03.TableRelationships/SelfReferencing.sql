CREATE TABLE Teachers (
	[TeacherID] INT NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[ManagerID] INT NULL FOREIGN KEY REFERENCES Teachers([TeacherID])
)

INSERT INTO Teachers
VALUES
	(101, 'John', NULL),
	(102, 'Maya', 106),
	(103, 'Silvia', 106),
	(104, 'Ted', 105),
	(105, 'Mark', 101),
	(106, 'Greta', 101)