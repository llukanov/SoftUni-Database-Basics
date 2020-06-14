-- Problem 14.	Games from 2011 and 2012 year
SELECT TOP (50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start] FROM [Games]
	WHERE DATEPART(YEAR, [Start]) IN (2011, 2012)
	ORDER BY [Start], [Name]

-- Problem 15.	 User Email Providers
SELECT
	[Username],
	RIGHT([Email], LEN([Email]) - CHARINDEX('@', [Email])) AS [Email Provider]
	FROM [Users]
	ORDER BY [Email Provider] ASC, [Username] ASC

-- Problem 16.	 Get Users with IPAdress Like Pattern
SELECT [Username], [IpAddress] FROM [Users]
	WHERE [IpAddress] LIKE '___.1_%._%.___'
	ORDER BY [Username] ASC

-- Problem 17.	 Show All Games with Duration and Part of the Day
SELECT
	[Name],
	CASE
		WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS [Part of the Day],
	CASE
		WHEN [Duration] BETWEEN 0 AND 3 THEN 'Extra Short'
		WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
		WHEN [Duration] > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS [Duration]
	FROM [Games]
	ORDER BY [Name] ASC, [Duration] ASC