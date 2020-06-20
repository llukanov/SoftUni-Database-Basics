-- Problem 1.	Employee Address
SELECT TOP(5) e.EmployeeId,  e.JobTitle, Addresses.AddressId, Addresses.AddressText
	FROM Employees AS e
	JOIN Addresses ON e.AddressID = Addresses.AddressID
	ORDER BY [AddressId] ASC

-- Problem 2.	Addresses with Towns
SELECT TOP (50) Employees.FirstName, Employees.LastName, Towns.Name, Addresses.AddressText
	FROM Employees
	JOIN Addresses ON Employees.AddressID = Addresses.AddressID
	JOIN Towns ON Addresses.TownID = Towns.TownID
	ORDER BY [FirstName] ASC, [LastName]

-- Problem 3.	Sales Employee
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, Departments.Name
	FROM Employees
	JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
		WHERE Departments.Name = 'Sales'
	ORDER BY [EmployeeID] ASC

-- Problem 4.	Employee Departments
SELECT TOP (5) Employees.EmployeeID, Employees.FirstName, Employees.Salary, Departments.Name
	FROM Employees
	JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
		WHERE Employees.Salary > 15000
	ORDER BY Departments.DepartmentID ASC

-- Problem 5.	Employees Without Project
SELECT TOP(3) Employees.EmployeeID, Employees.FirstName
	FROM Employees
	LEFT JOIN EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID
		WHERE EmployeesProjects.ProjectID IS NULL
	ORDER BY [EmployeeID] ASC

-- Problem 6.	Employees Hired After
SELECT Employees.FirstName, Employees.LastName, Employees.HireDate, Departments.Name
	FROM Employees
	JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
		WHERE Employees.HireDate > '1.1.1999' AND Departments.Name IN ('Sales', 'Finance')
	ORDER BY [HireDate] ASC

-- Problem 7.	Employees with Project
SELECT TOP(5)Employees.EmployeeID, Employees.FirstName, Projects.Name AS [ProjectName]
	FROM Employees
	JOIN EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID
	JOIN Projects ON EmployeesProjects.ProjectID = Projects.ProjectID
		WHERE Projects.StartDate > '2002.08.13' AND Projects.EndDate IS NULL
	ORDER BY [EmployeeID] ASC

-- Problem 8.	Employee 24
SELECT Employees.EmployeeID, Employees.FirstName,
	CASE 
		WHEN DATEPART(YEAR, Projects.StartDate) >= 2005 THEN NULL
		ELSE Projects.Name
	END AS [ProjectName]
	FROM Employees
	JOIN EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID
	JOIN Projects ON EmployeesProjects.ProjectID = Projects.ProjectID
		WHERE Employees.EmployeeID = 24

-- Problem 9.	Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, Employees.FirstName AS [ManagerName]
	FROM Employees AS e
	JOIN Employees ON e.ManagerID = Employees.EmployeeID
		WHERE e.ManagerID IN (3, 7)
	ORDER BY e.EmployeeID ASC

-- Problem 10.	Employee Summary
SELECT TOP (50) e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName) AS [EmployeeName],
	CONCAT(m.FirstName, ' ', m.LastName) AS [ManagerName],
	d.Name AS [DepartmentName]
	FROM Employees e
	JOIN Employees m ON e.ManagerID = m.EmployeeID
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
	ORDER BY e.EmployeeID

-- Problem 11.	Min Average Salary
SELECT MIN(AverageSalaryByDepartment) AS [MinAverageSalary]
	FROM
	(SELECT AVG(Salary) AS AverageSalaryByDepartment
		FROM Employees
		GROUP BY DepartmentID) AS AverageSalaryQuery