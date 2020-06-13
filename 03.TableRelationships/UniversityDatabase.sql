CREATE DATABASE University

USE University

CREATE TABLE Majors (
	[MajorID] INT IDENTITY NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE Students (
	[StudentID] INT IDENTITY NOT NULL PRIMARY KEY,
	[StudentNumber] INT NOT NULL,
	[StudentName] NVARCHAR(50) NOT NULL,
	[MajorID] INT NOT NULL FOREIGN KEY REFERENCES Majors([MajorID])
)

CREATE TABLE Payments (
	[PaymentID] INT IDENTITY NOT NULL PRIMARY KEY,
	[PaymentDate] DATE NOT NULL,
	[PaymentAmount] DECIMAL(18, 2) NOT NULL,
	[StudentID] INT NOT NULL FOREIGN KEY REFERENCES Students([StudentID])
)

CREATE TABLE Subjects (
	[SubjectID] INT IDENTITY NOT NULL PRIMARY KEY,
	[SubjectsName] NVARCHAR(50) NOT NULL
)

CREATE TABLE Agenda (
	[StudentID] INT NOT NULL FOREIGN KEY REFERENCES Students([StudentID]),
	[SubjectID] INT NOT NULL FOREIGN KEY REFERENCES Subjects([SubjectID]),
	PRIMARY KEY ([StudentID], [SubjectID])
)