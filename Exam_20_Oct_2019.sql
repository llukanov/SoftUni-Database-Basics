CREATE DATABASE Service

USE Service

CREATE TABLE Users
(
	Id INT IDENTITY PRIMARY KEY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(50) NOT NULL,
	Name VARCHAR(50),
	Birthdate DATE,
	Age INT CHECK(Age >= 14 AND Age <= 110),
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Employees
(
	Id INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATE,
	Age INT CHECK(Age >= 18 AND Age <= 110),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Categories
(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Status
(
	Id INT IDENTITY PRIMARY KEY,
	Label VARCHAR(30) NOT NULL,
)

CREATE TABLE Reports
(
	Id INT IDENTITY PRIMARY KEY,
	CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
	StatusId INT NOT NULL FOREIGN KEY REFERENCES Status(Id),
	OpenDate DATE NOT NULL,
	CloseDate DATE,
	Description VARCHAR(200) NOT NULL,
	UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
)


-- 12.	Assign Employee
CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN
	DECLARE @employeeDepartment INT = (SELECT DepartmentId
									FROM Employees
									WHERE Id = @EmployeeId)
	DECLARE @reportDepartment INT = (SELECT DepartmentId
									FROM Reports
									JOIN Categories ON Reports.CategoryId = Categories.Id
									WHERE Reports.Id = @ReportId)

	IF(@employeeDepartment = @reportDepartment)
	BEGIN
		UPDATE Reports
		SET EmployeeId = @EmployeeId
		WHERE Id = @ReportId
	END
	ELSE
	BEGIN
		   RAISERROR ('Employee doesn''t belong to the appropriate department!', 16, 1) 
		   RETURN
	END
END