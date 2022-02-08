INSERT INTO Accounts (FirstName, MiddleName,	LastName,	CityId,	BirthDate,	Email)
VALUES
('John',	'Smith',	'Smith',	34,	'1975-07-21',	'j_smith@gmail.com'),
('Gosho',	NULL,	'Petrov',	11,	'1978-05-16',	'g_petrov@gmail.com'),
('Ivan',	'Petrovich',	'Pavlov',	59,	'1849-09-26',	'i_pavlov@softuni.bg'),
('Friedrich',	'Wilhelm',	'Nietzsche',	2,	'1844-10-15',	'f_nietzsche@softuni.bg')

INSERT INTO Trips(RoomId,	BookDate,	ArrivalDate,	ReturnDate,	CancelDate)
VALUES
(101,	'2015-04-12',	'2015-04-14',	'2015-04-20',	'2015-02-02'),
(102,	'2015-07-07',	'2015-07-15',	'2015-07-22',	'2015-04-29'),
(103,	'2013-07-17',	'2013-07-23',	'2013-07-24',	NULL),
(104,	'2012-03-17',	'2012-03-31',	'2012-04-01',	'2012-01-10'),
(109,	'2017-08-07',	'2017-08-28',	'2017-08-29',	NULL)


UPDATE Rooms
SET Price = Price * 1.14
WHERE HotelId IN (5, 7, 9)

DELETE FROM AccountsTrips
WHERE AccountId IN (47)

SELECT FirstName,	LastName, FORMAT(BirthDate, 'MM-dd-yyyy') AS  BirthDate, Cities.Name AS	Hometown,	Email
	FROM Accounts
	JOIN Cities ON Accounts.CityId = Cities.Id
	WHERE Email LIKE 'e%'
	ORDER BY Cities.Name ASC

SELECT Cities.Name AS City, COUNT(Hotels.Id) AS Hotels
	FROM Cities
	JOIN Hotels ON Cities.Id = Hotels.CityId
	GROUP BY Cities.Id, Cities.Name
		HAVING COUNT(Hotels.Id) > 0
	ORDER BY Hotels DESC, City ASC

SELECT Accounts.Id AS AccountId,
	CONCAT(Accounts.FirstName, ' ', Accounts.LastName) AS FullName,
	DATEPART(DAY, ReturnDate) - DATEPART(DAY, ArrivalDate) AS LongestTrip,
	DATEPART(DAY, ReturnDate) - DATEPART(DAY, ArrivalDate) AS ShortestTrip
	FROM Accounts
	JOIN AccountsTrips ON Accounts.Id = AccountsTrips.AccountId
	JOIN Trips ON AccountsTrips.TripId = Trips.Id
	GROUP BY Accounts.Id, Accounts.FirstName, Accounts.LastName, Trips.Id
	ORDER BY LongestTrip DESC, ShortestTrip ASC

SELECT TOP(10) Cities.Id, Cities.Name, Cities.CountryCode, COUNT(Accounts.Id) AS Accounts
	FROM Cities
	JOIN Accounts ON Cities.Id = Accounts.CityId
	GROUP BY Cities.Id
	ORDER BY Accounts DESC

SELECT Accounts.Id, Accounts.Email, Cities.Name AS City, COUNT(Trips.Id) AS Trips
	FROM Accounts
	JOIN Cities ON Accounts.CityId = Cities.Id
	JOIN AccountsTrips ON Accounts.Id = AccountsTrips.AccountId
	JOIN Trips ON AccountsTrips.TripId = Trips.Id
	JOIN Rooms ON Trips.RoomId = Rooms.Id
	JOIN Hotels ON Rooms.HotelId = Hotels.Id
		WHERE Hotels.CityId = Accounts.CityId
	GROUP BY Accounts.Id, Accounts.Email, Cities.Name
	ORDER BY Trips DESC, Accounts.Id

SELECT Trips.Id,
	CONCAT_WS(' ', Accounts.FirstName, Accounts.MiddleName, Accounts.LastName) AS [Full Name],
	(SELECT Cities.Name FROM Accounts
		JOIN Cities ON Accounts.CityId = Cities.Id) AS [From],
	(SELECT Cities.Name
		FROM Hotels
		JOIN AccountsTrips ON Accounts.Id = AccountsTrips.AccountId
		JOIN Trips ON AccountsTrips.TripId = Trips.Id
		JOIN Rooms ON
		JOIN Cities ON Hotels.CityId = Cities.Id) AS [To]
	--CASE
	--	WHEN Trips.CancelDate IS NULL THEN DATEPART(DAY, ReturnDate) - DATEPART(DAY, ArrivalDate) + ' days' AS Duration,
	--	WHEN Trips.CancelDate IS NOT NULL THEN DATEPART(DAY, ReturnDate) - DATEPART(DAY, ArrivalDate) + ' days' AS Duration,
	--END
	FROM Accounts
	JOIN AccountsTrips ON Accounts.Id = AccountsTrips.AccountId
	JOIN Trips ON AccountsTrips.TripId = Trips.Id
	JOIN

GO
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @totalPrice DECIMAL(18, 2)

	DECLARE @roomId INT = (SELECT Rooms.Id FROM Rooms
					JOIN Trips ON Rooms.Id = Trips.RoomId
					WHERE ((@Date NOT BETWEEN Trips.ArrivalDate AND Trips.ReturnDate) OR Trips.CancelDate IS NOT NULL)
						AND (Rooms.HotelId = @HotelId)
						AND (Rooms.Beds >= @People))




	RETURN ()

	SELECT
		
END
GO;


CREATE PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
BEGIN
	DECLARE @currentBeds INT = (SELECT Rooms.Beds
									FROM Rooms
									JOIN Trips ON Rooms.Id = Trips.RoomId
									WHERE Trips.Id = @TripId)

	DECLARE @bedsInTargetRoom INT = (SELECT Rooms.Beds
									FROM Rooms
									WHERE Rooms.Id = @TargetRoomId)

	DECLARE @currentHotel INT = (SELECT Rooms.HotelId
									FROM Rooms
									JOIN Trips ON Rooms.Id = Trips.RoomId
									WHERE Trips.Id = @TripId)

	DECLARE @TargetHotel INT = (SELECT Rooms.HotelId
									FROM Rooms
									WHERE Rooms.Id = @TargetRoomId)

	IF(@currentHotel != @TargetHotel AND @currentBeds <= @bedsInTargetRoom)
		BEGIN
			PRINT 'Target room is in another hotel!'
		END
	ELSE IF @currentBeds > @bedsInTargetRoom
		BEGIN
			PRINT 'Not enough beds in target room!'
		END
	ELSE
		BEGIN
			UPDATE Trips
			SET Trips.RoomId = @TargetRoomId
		END
END