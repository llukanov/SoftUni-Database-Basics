CREATE DATABASE OnlineStore

USE OnlineStore

CREATE TABLE ItemTypes(
	[ItemTypeID] INT IDENTITY NOT NULL PRIMARY KEY,
	[Name] VARCHAR (50) NOT NULL
)

CREATE TABLE Items (
	[ItemID] INT IDENTITY NOT NULL PRIMARY KEY,
	[Name] VARCHAR (50) NOT NULL,
	[ItemTypeID] INT NOT NULL FOREIGN KEY REFERENCES ItemTypes([ItemTypeID])
)

CREATE TABLE Cities (
	[CityID] INT IDENTITY NOT NULL PRIMARY KEY,
	[Name] VARCHAR (50) NOT NULL
)

CREATE TABLE Customers (
	[CustomerID] INT IDENTITY NOT NULL PRIMARY KEY,
	[Name] VARCHAR (50) NOT NULL,
	[Birthday] DATE NOT NULL,
	[CityID] INT NOT NULL FOREIGN KEY REFERENCES Cities([CityID])
)

CREATE TABLE Orders (
	[OrderID] INT IDENTITY NOT NULL PRIMARY KEY,
	[CustomerID] INT NOT NULL FOREIGN KEY REFERENCES Customers([CustomerID]),
)

CREATE TABLE OrderItems(
	[OrderID] INT NOT NULL FOREIGN KEY REFERENCES Orders([OrderID]),
	[ItemID] INT NOT NULL FOREIGN KEY REFERENCES Items([ItemID]),
	PRIMARY KEY ([OrderID], [ItemID])
)