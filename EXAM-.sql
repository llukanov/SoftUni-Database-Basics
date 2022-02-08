CREATE DATABASE ColonialJourney

CREATE TABLE Planets
(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	PlanetId INT NOT NULL,

	CONSTRAINT FK_Spaceports_Planets FOREIGN KEY (PlanetId) REFERENCES Planets(Id)
)

CREATE TABLE Spaceships
(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(30) NOT NULL,
	LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists
(
	Id INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Ucn VARCHAR(10) NOT NULL UNIQUE,
	BirthDate DATE NOT NULL,
)

CREATE TABLE Journeys
(
	Id INT IDENTITY PRIMARY KEY,
	JourneyStart DATE NOT NULL,
	JourneyEnd DATE NOT NULL,
	Purpose VARCHAR(11) NOT NULL CHECK(Purpose IN('Medical', 'Technical', 'Educational', 'Military')),
	DestinationSpaceportId INT NOT NULL,
	SpaceshipId INT NOT NULL,

	CONSTRAINT FK_Journeys_Spaceports FOREIGN KEY(DestinationSpaceportId) REFERENCES Spaceports(Id),
	CONSTRAINT FK_Journeys_Spaceships FOREIGN KEY(SpaceshipId) REFERENCES Spaceships(Id),
)


CREATE TABLE TravelCards
(
	Id INT IDENTITY PRIMARY KEY,
	CardNumber CHAR(10) NOT NULL UNIQUE,
	JobDuringJourney VARCHAR(8) NOT NULL CHECK(JobDuringJourney IN('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
	ColonistId INT NOT NULL,
	JourneyId INT NOT NULL,

	CONSTRAINT FK_TravelCards_Colonists FOREIGN KEY(ColonistId) REFERENCES Colonists(Id),
	CONSTRAINT FK_TravelCards_Journeys FOREIGN KEY(JourneyId) REFERENCES Journeys(Id),

)

INSERT INTO Planets(Name)
VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO Spaceships(Name,	Manufacturer,	LightSpeedRate)
VALUES
('Golf','VW',	3),
('WakaWaka','Wakanda',	4),
('Falcon9','SpaceX',	1),
('Bed','Vidolov',	6)

UPDATE Spaceships
SET LightSpeedRate += 1
WHERE Id BETWEEN 8 AND 12

DELETE TravelCards
WHERE JourneyId IN(SELECT TOP(3) Id FROM Journeys)

DELETE TOP(3) Journeys

SELECT Id, FORMAT(JourneyStart, 'dd/MM/yyyy') AS JourneyStart, FORMAT(JourneyEnd, 'dd/MM/yyyy') AS JourneyEnd
FROM Journeys
WHERE Purpose = 'Military'
ORDER BY Journeys.JourneyStart ASC


SELECT Colonists.Id, FirstName + ' ' + LastName AS full_name
FROM Colonists
JOIN TravelCards ON Colonists.Id = TravelCards.ColonistId
WHERE TravelCards.JobDuringJourney = 'Pilot'
ORDER BY Colonists.Id ASC

SELECT COUNT(*) AS [count]
FROM Colonists
JOIN TravelCards ON Colonists.Id = TravelCards.ColonistId
JOIN Journeys ON TravelCards.JourneyId = Journeys.Id
WHERE Journeys.Purpose = 'Technical'

SELECT DISTINCT Spaceships.Name, Manufacturer
FROM Spaceships
JOIN Journeys ON Spaceships.Id = Journeys.SpaceshipId
JOIN TravelCards ON Journeys.Id = TravelCards.JourneyId
JOIN Colonists ON TravelCards.ColonistId = ColonistId
WHERE TravelCards.JobDuringJourney = 'Pilot'
ORDER BY Spaceships.Name

SELECT Spaceships.Name, Spaceships.Manufacturer
FROM Spaceships
JOIN Journeys ON Spaceships.Id = Journeys.SpaceshipId
JOIN TravelCards ON Journeys.Id = TravelCards.JourneyId
JOIN Colonists ON TravelCards.ColonistId = Colonists.Id
WHERE TravelCards.JobDuringJourney = 'Pilot' AND DATEDIFF(YEAR,BirthDate,'2019-01-01') < 30
ORDER BY Spaceships.Name ASC

SELECT Planets.Name AS PlanetName, COUNT(Journeys.Id) AS JourneysCount
FROM Planets
JOIN Spaceports ON Planets.Id =Spaceports.PlanetId
JOIN Journeys ON Spaceports.Id = Journeys.DestinationSpaceportId
GROUP BY Planets.Name
ORDER BY JourneysCount DESC, Planets.Name ASC

WITH MyCte AS 
(
    select   JobDuringJourney,  FirstName + ' ' + LastName AS FullName,
             JobRank = DENSE_RANK() OVER (PARTITION  BY JobDuringJourney order by BirthDate)
    from     Colonists
	JOIN TravelCards ON Colonists.Id = TravelCards.ColonistId
)
SELECT  JobDuringJourney, FullName, JobRank
FROM    MyCte
WHERE JobRank = 2

GO
CREATE FUNCTION dbo.udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT
AS
BEGIN
	DECLARE @COUNDT INT = (SELECT COUNT(*)
						FROM Planets
						JOIN Spaceports ON Planets.Id = Spaceports.PlanetId
						JOIN Journeys ON Spaceports.Id = Journeys.DestinationSpaceportId
						JOIN TravelCards ON Journeys.Id = TravelCards.JourneyId
						JOIN Colonists ON TravelCards.ColonistId = Colonists.Id
						WHERE Planets.Name = @PlanetName)
	RETURN @COUNDT
END
GO;

GO
CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(100))
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM Journeys WHERE Journeys.Id = @JourneyId)
	BEGIN
		RAISERROR ('The journey does not exist!', 16, 1) 
		RETURN
	END

	DECLARE @PURPOSE NVARCHAR(1000) = (SELECT Purpose FROM Journeys WHERE Journeys.Id = @JourneyId)

	IF (@PURPOSE = @NewPurpose)
	BEGIN
		RAISERROR ('You cannot change the purpose!', 17, 1) 
		RETURN
	END

	UPDATE Journeys
	SET Purpose = @NewPurpose
	WHERE ID = @JourneyId
END