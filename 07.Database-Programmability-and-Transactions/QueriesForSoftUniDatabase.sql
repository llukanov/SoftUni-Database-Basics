USE [SoftUni]

-- Problem 1. Employees with Salary Above 35000
GO
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT [FirstName], [LastName]
	FROM [dbo].[Employees]
	WHERE [Salary] > 35000
END
GO;

-- Problem 2. Employees with Salary Above Number
GO
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@number DECIMAL(18,4))
AS
BEGIN
	SELECT [FirstName], [LastName]
	FROM [dbo].[Employees]
	WHERE [Salary] >= @number
END
GO;

-- Problem 3. Town Names Starting With
GO
CREATE PROC usp_GetTownsStartingWith(@input NVARCHAR(MAX))
AS
BEGIN
	SELECT [Name] FROM [dbo].[Towns]
		WHERE LEFT([Name], LEN(@input)) LIKE @input
END
GO;

-- Problem 4. Employees from Town
GO
CREATE PROC usp_GetEmployeesFromTown(@townName NVARCHAR(MAX))
AS
BEGIN
	SELECT [FirstName], [LastName]
		FROM [dbo].[Employees]
		JOIN [Addresses] ON Employees.AddressID = Addresses.AddressID
		JOIN [Towns] ON Addresses.TownID = Towns.TownID
		WHERE Towns.Name = @townName
END
GO;

-- Problem 5. Salary Level Function
GO
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @salaryLevel NVARCHAR(10)
	IF (@salary < 30000)
	BEGIN
		SET @salaryLevel = 'Low';
	END
	ELSE IF (@salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @salaryLevel = 'Average';
	END
	ELSE IF (@salary > 50000)
	BEGIN
		SET @salaryLevel = 'High';
	END

	RETURN @salaryLevel
END
GO;

-- Problem 6. Employees by Salary Level
GO
CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel NVARCHAR(10))
AS
BEGIN
	SELECT [FirstName], [LastName]
	FROM [dbo].[Employees]
	WHERE dbo.ufn_GetSalaryLevel([Salary]) = @salaryLevel
END
GO;
