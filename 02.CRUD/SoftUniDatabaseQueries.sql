SELECT * FROM [Departments]

SELECT [Name] FROM [dbo].[Departments]

SELECT [FirstName], [LastName], [Salary] FROM [dbo].[Employees]

SELECT [FirstName], [MiddleName], [LastName] FROM [dbo].[Employees]

SELECT [FirstName] + '.' + [LastName] + '@softuni.bg'
FROM [dbo].[Employees]
AS [Full Email Address]

SELECT DISTINCT [Salary] FROM [dbo].[Employees]

SELECT [EmployeeID], [FirstName], [LastName], [MiddleName], [JobTitle], [DepartmentID], [ManagerID], [HireDate], [Salary], [AddressID]
FROM [dbo].[Employees]
WHERE [JobTitle] LIKE 'Sales Representative'

SELECT [FirstName], [LastName], [JobTitle]
FROM [dbo].[Employees]
WHERE [Salary] >= 20000 AND [Salary] <= 30000

SELECT [FirstName] + ' ' + [MiddleName] + ' ' + [LastName] AS [Full Name]
FROM [dbo].[Employees]
WHERE [Salary] IN (25000, 14000, 12500, 23600)

SELECT [FirstName], [LastName]
FROM [dbo].[Employees]
WHERE [ManagerID] IS NULL

SELECT [FirstName], [LastName], [Salary]
FROM [dbo].[Employees]
WHERE [Salary] > 50000
ORDER BY [Salary] DESC

SELECT TOP(5) [FirstName], [LastName]
FROM [dbo].[Employees]
ORDER BY [Salary] DESC

SELECT [FirstName], [LastName]
FROM [dbo].[Employees]
WHERE [DepartmentID] != 4

SELECT * FROM [dbo].[Employees]
ORDER BY [Salary] DESC, [FirstName], [LastName] DESC, [MiddleName]

CREATE VIEW V_EmployeesSalaries AS
SELECT [FirstName], [LastName], [Salary]
FROM [dbo].[Employees]

CREATE VIEW V_EmployeeNameJobTitle AS 
SELECT [FirstName] + ' ' + ISNULL([MiddleName], '') + ' ' + [LastName] AS [Full Name], [JobTitle] AS [Job Title]
FROM [dbo].[Employees]

SELECT DISTINCT [JobTitle] FROM [dbo].[Employees]

SELECT TOP(10) * FROM [dbo].[Projects]
ORDER BY [StartDate], [Name]

SELECT TOP(7) [FirstName], [LastName], [HireDate]
FROM [dbo].[Employees]
ORDER BY [HireDate] DESC

UPDATE [Employees]
SET [Salary] = [Salary] * 1.12
	WHERE [DepartmentId] IN (1, 2, 4, 11)
SELECT [Salary] FROM [dbo].[Employees]