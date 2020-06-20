USE [SoftUni]

-- Problem 13.	Departments Total Salaries
SELECT [DepartmentID], SUM([Salary]) AS [TotalSalary]
	FROM [dbo].[Employees]
	GROUP BY [DepartmentID]
	ORDER BY [DepartmentID]

-- Problem 14.	Employees Minimum Salaries
SELECT [DepartmentID], MIN([Salary]) AS [MinimumSalary]
	FROM [dbo].[Employees]
	WHERE [DepartmentID] IN (2, 5, 7) AND [HireDate] > '2000-01-01'
	GROUP BY [DepartmentID]

-- Problem 15.	Employees Average Salaries
SELECT * INTO [EmployeesBackup]
	FROM [dbo].[Employees]
	WHERE [Salary] > 30000 

DELETE FROM [EmployeesBackup] WHERE [ManagerID] = 42

UPDATE [EmployeesBackup]
	SET [Salary] = [Salary] + 5000
	WHERE [DepartmentID] = 1

SELECT [DepartmentID], AVG([Salary]) AS [AverageSalary]
	FROM [EmployeesBackup]
	GROUP BY [DepartmentID]

-- Problem 16.	Employees Maximum Salaries
SELECT [DepartmentID], MAX([Salary]) AS [MaxSalary]
	FROM [dbo].[Employees]
	GROUP BY [DepartmentID] HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

-- Problem 17.	Employees Count Salaries
SELECT COUNT(*)
	FROM [dbo].[Employees]
	WHERE [ManagerID] IS NULL
