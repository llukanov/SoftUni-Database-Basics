USE Geography

-- Problem 12.	Countries Holding ‘A’ 3 or More Times
SELECT [CountryName], [IsoCode] FROM Countries
	WHERE LEN([CountryName]) - LEN(REPLACE([CountryName], 'A', '')) >= 3
	ORDER BY [IsoCode] ASC

-- Mix of Peak and River Names
SELECT Peaks.[PeakName], Rivers.[RiverName], 
	LOWER([PeakName] + RIGHT(RiverName, LEN(RiverName) - 1)) AS Mix
	FROM Peaks 
	INNER JOIN Rivers ON RIGHT(PeakName, 1) = LEFT(RiverName, 1)
	ORDER BY Mix