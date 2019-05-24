CREATE DATABASE [Group5];
GO

USE [Group5];

--create schemas
CREATE SCHEMA Person;
GO
CREATE SCHEMA Flight;
GO
CREATE SCHEMA Customer;
GO
CREATE SCHEMA Employee;
GO

-- Create DMK
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Group5@12345!';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'Group Certificate',
EXPIRY_DATE = '2026-10-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

-- Create tables
CREATE TABLE Person.Person
    (
    PersonID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	FirstName varchar(30) NOT NULL,
	MiddleName varchar(30),
	LastName varchar(30) NOT NULL,
	Gender varchar(10) NOT NULL,
	BirthDate date,
	PhoneNumber varchar(20),
	SSN varchar(20),
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Person.EmailAddress
    (
    EmailAddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	PersonID int NOT NULL
	    REFERENCES Person.Person(PersonID),
	EmailAddress varchar(50) NOT NULL,
	ModifiedDate datetime NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Person.Address
    (
    AddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	PersonID int NOT NULL
	    REFERENCES Person.Person(PersonID),
	Country varchar(50) NOT NULL,
	State varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	Street varchar(50) NOT NULL,
	ZipCode int NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Customer.CustomerType
    (
    CustomerTypeID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CustomerTyp varchar(20) NOT NULL,
	SPromotion varchar(50) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Customer.Customer
    (
    CustomerID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CustomerTypeID int NOT NULL
	    REFERENCES Customer.CustomerType(CustomerTypeID),
	PersonID int NOT NULL
	    REFERENCES Person.Person(PersonID),
	PassportNumber varchar(20) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Customer.CreditCard
    (
    CreditCardID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CustomerID int NOT NULL
	    REFERENCES Customer.Customer(CustomerID),
    CardNumber varchar(20) NOT NULL,
	Month int NOT NULL,
	Year int Not NULL,
	NameOnCard varchar(50) NOT NULL,
	SecurityNumber int NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Company
    (
    CompanyID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
    Name varchar(50) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.CompanyAddress
    (
    CompanyAddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CompanyID int NOT NULL
	    REFERENCES Employee.Company(CompanyID),
    Country varchar(50) NOT NULL,
	State varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	Street varchar(50) NOT NULL,
	ZipCode int NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Department
    (
    DepartmentID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CompanyID int NOT NULL
	    REFERENCES Employee.Company(CompanyID),
    Name varchar(50) NOT NULL,
	Description varchar(300) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Role
    (
    RoleID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	DepartmentID int NOT NULL
	    REFERENCES Employee.Department(DepartmentID),
    RoleName varchar(50) NOT NULL,
	Level varchar(20) NOT NULL,
	Salary int NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Employee
    (
    EmployeeID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	PersonID int NOT NULL
	    REFERENCES Person.Person(PersonID),
	RoleID int NOT NULL
	    REFERENCES Employee.Role(RoleID),
    Leader varchar(50) NOT NULL,
	MaritalStatus varchar(20) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Account
    (
    AccountID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	EmployeeID int NOT NULL
	    REFERENCES Employee.Employee(EmployeeID),
    UserName varchar(50) NOT NULL,
    EncryptedPassword VARBINARY(250),
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Mission
    (
    MissionID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	AccountID int NOT NULL
	    REFERENCES Employee.Account(AccountID),
    Content varchar(500) NOT NULL,
	PostDate datetime NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Employee.Report
    (
    ReportID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	MissionID int NOT NULL
	    REFERENCES Employee.Mission(MissionID),
    AccountID int NOT NULL
	    REFERENCES Employee.Account(AccountID),
    Description varchar(500) NOT NULL,
	Process varchar(100) NOT NULL,
	ModifiedDate datetime NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Customer.[Order]
    (
    OrderID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CustomerID int NOT NULL
	    REFERENCES Customer.Customer(CustomerID),
    EmployeeID int NOT NULL
	    REFERENCES Employee.Employee(EmployeeID),
	CreditCardID int NOT NULL
	    REFERENCES Customer.CreditCard(CreditCardID),
    Date datetime NOT NULL,
	Status varchar(50) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Customer.BillingAddress
    (
    BillingAddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	OrderID int NOT NULL
	    REFERENCES Customer.[Order](OrderID),
    Country varchar(50) NOT NULL,
	State varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	Street varchar(50) NOT NULL,
	ZipCode int NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Flight.City
    (
    CityID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
    CityName varchar(50) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Flight.Airport
    (
    AirportID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	CityID int NOT NULL
	    REFERENCES Flight.City(CityID),
    AirportName varchar(50) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Flight.Flight
    (
    FlightID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	DepartureAirportID int NOT NULL
	    REFERENCES Flight.Airport(AirportID),
	ArrivalAirportID int NOT NULL
	    REFERENCES Flight.Airport(AirportID),
    FlightDistance decimal(10,2) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Flight.FlightSchedule
    (
    FlightScheduleID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	FlightID int NOT NULL
	    REFERENCES Flight.Flight(FlightID),
	FlightDate datetime NOT NULL,
	ScheduleDepartureTime datetime NOT NULL,
	ScheduleArrivalTime datetime NOT NULL,
    ActualDepartureTime datetime NOT NULL,
	ActualeArrivalTime datetime NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Flight.Airplane
    (
    AirplaneID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	Manufacture varchar(50) NOT NULL,
    Model varchar(50) NOT NULL,
	NumberOfSeats int NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Flight.FlightScheduleAirplane
     (
    FlightScheduleID int NOT NULL
        REFERENCES Flight.FlightSchedule(FlightScheduleID),
    AirplaneID int NOT NULL
        REFERENCES Flight.Airplane(AirplaneID),
    DeleteFlag varchar(2) NOT NULL,
    FlightScheduleAirplaneID int NOT NULL
        CONSTRAINT PKFlightScheduleAirplane PRIMARY KEY CLUSTERED 
             (FlightScheduleID, AirplaneID)
    );

CREATE TABLE Flight.SeatSchedule
    (
    SeatScheduleID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	FlightScheduleID int NOT NULL
        REFERENCES Flight.FlightSchedule(FlightScheduleID),
	SeatNumber varchar(20) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );

CREATE TABLE Customer.Booking
    (
    BookingID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	OrderID int NOT NULL
	    REFERENCES Customer.[Order](OrderID),
	SeatScheduleID int NOT NULL
        REFERENCES Flight.SeatSchedule(SeatScheduleID),
	PersonID int NOT NULL
        REFERENCES Person.Person(PersonID),
	FlightTicketNumber varchar(20) NOT NULL,
	Price decimal(10,2) NOT NULL,
	DeleteFlag varchar(2) DEFAULT 0
    );
GO

--check whether the ArrivalAirport and DepartureAirport are the same
CREATE FUNCTION CheckAirport(@FlightID int)
RETURNS smallint
AS
BEGIN
   DECLARE @Count smallint=0;
   DECLARE @ArrivalAirportID int=0;
   DECLARE @DepartureAirportID int=0;
   SELECT @ArrivalAirportID = f.ArrivalAirportID,@DepartureAirportID = f.DepartureAirportID 
          FROM Flight.Flight f
          WHERE f.FlightID = @FlightID; 
   RETURN case when @ArrivalAirportID=@DepartureAirportID then 1 else 0 end;
END;
go

ALTER TABLE Flight.Flight ADD CONSTRAINT TheSame CHECK (dbo.CheckAirport(FlightID) = 0);
GO

-- Create a function to calculate total price
CREATE FUNCTION calculateTotalPrice(@OrderID INT)
RETURNS MONEY
AS
   BEGIN
      DECLARE @total MONEY =
         (SELECT SUM(b.Price)
          FROM [Customer].[Booking] b
          WHERE b.OrderID =@OrderID);
      SET @total = ISNULL(@total, 0);
      RETURN @total;
END;
go

-- Add a computed column to the [Customer].[Order]
ALTER TABLE [Customer].[Order]
ADD TotalPurchase AS (dbo.calculateTotalPrice(OrderID));
GO

--view all the information of an employee
CREATE VIEW v_Employees 
WITH SCHEMABINDING
AS
SELECT e.EmployeeID,e.PersonId, p.FirstName, p.MiddleName, p.LastName, p.Gender, p.Birthdate, p.SSN, p.PhoneNumber,a.Country,a.State,a.City,a.Zipcode,ea.EmailAddress,e.Leader, e.MaritalStatus, r.RoleName, r.Level, r.Salary, d.Name
FROM Person.Person p 
INNER JOIN Person.Address a
ON p.PersonID = a.PersonID
INNER JOIN Person.EmailAddress ea
ON p.PersonID = ea.PersonID
INNER JOIN Employee.Employee e
ON p.PersonId = e.PersonId
INNER JOIN Employee.Role r
ON e.RoleId = r.RoleId
INNER JOIN Employee.Department d
ON r.DepartmentID = d.DepartmentID;

SELECT* FROM v_Employees;
GO

--view all the information of a customer
CREATE VIEW v_Customer 
WITH SCHEMABINDING
AS
SELECT c.CustomerID,c.PersonId, p.FirstName, p.MiddleName, p.LastName, p.Gender, p.Birthdate, p.SSN, p.PhoneNumber, a.Country,a.State,a.City,a.Zipcode,ea.EmailAddress,c.PassportNumber,ct.CustomerTypeID, ct.CustomerTyp,ct.SPromotion
FROM Person.Person p
INNER JOIN Person.Address a
ON p.PersonID = a.PersonID
INNER JOIN Person.EmailAddress ea
ON p.PersonID = ea.PersonID
INNER JOIN Customer.Customer c 
ON p.PersonId = c.PersonId
INNER JOIN Customer.[Order] o 
ON c.CustomerId = o.CustomerId
INNER JOIN Customer.CustomerType ct
ON c.CustomerTypeID = ct.CustomerTypeID;

SELECT * FROM v_Customer;
GO

-- Trigger: to insert all the customer information with the view
CREATE TRIGGER trCustomerInsert
ON v_Customer
INSTEAD OF INSERT
AS
BEGIN
    -- Check to see whether the INSERT actually tried to feed us any rows.
    -- (A WHERE clause might have filtered everything out)
    IF (SELECT COUNT(*) FROM Inserted) > 0
    BEGIN
		DECLARE @cid INT, @pid INT,@ctid INT, @newcid INT, @newpid INT, @newctid INT,@ct VARCHAR(5), @f VARCHAR(30), @m VARCHAR(30), @l VARCHAR(30), @g VARCHAR(10), @b DATE, @p VARCHAR(20), @ssn VARCHAR(20), @c VARCHAR(50), @s VARCHAR(50), @ci VARCHAR(50), @z INT, @ea VARCHAR(50), @pn VARCHAR(20), @sp VARCHAR(50)
        SELECT @cid = CustomerID, @pid = PersonID, @ctid = CustomerTypeID, @ct = CustomerTyp, @f = FirstName, @m = MiddleName, @l = LastName, @g = Gender, @b = Birthdate, @p = PhoneNumber, @ssn = SSN, @c = Country,@s = State,@ci = City,@z = Zipcode,@ea = EmailAddress,@pn = PassportNumber,@sp = SPromotion
		FROM inserted; 
		IF NOT EXISTS (SELECT 1 FROM Customer.CustomerType WHERE CustomerTypeID = @ctid)	
			BEGIN
		      ROLLBACK;
		   END

       ELSE 
	   BEGIN
		   BEGIN
		      INSERT Customer.CustomerType (CustomerTyp,SPromotion,DeleteFlag)
			  VALUES (@ct,@sp,0)
			  SET @newctid = SCOPE_IDENTITY();
		   END
		IF NOT EXISTS (SELECT 1 FROM Person.Person WHERE PersonID = @pid)	
			BEGIN
		      INSERT Person.Person (FirstName, MiddleName, LastName, Gender, Birthdate, SSN, PhoneNumber, DeleteFlag)
			  VALUES (@f, @m, @l, @g, @b, @ssn, @p, 0)
			  SET @newpid = SCOPE_IDENTITY();
		   END

		IF NOT EXISTS (SELECT 1 FROM Person.Person WHERE PersonID = @pid)	
			BEGIN
		      INSERT Customer.Customer (PersonID, PassportNumber, DeleteFlag)
			  VALUES (@pid, @pn, 0)
			  SET @newcid = SCOPE_IDENTITY();
		   END
		

        IF @newpid IS NULL 
			INSERT INTO Customer.Customer VALUES(@ctid,@pid, @pn, 0)
		

		END
    END
END

--test whether the trigger of customer work
INSERT INTO v_Customer
    (
     CustomerID,PersonID,FirstName,MiddleName,LastName,Gender,Birthdate,PhoneNumber,
	 SSN,Country,State,City,Zipcode,EmailAddress,PassportNumber, CustomerTypeID,CustomerTyp,SPromotion
    )
VALUES
    (
     99,99,'Jam','Lu','Johson','Male', '1993-12-13',
	 '617-131-313','450-13-1313','American','MA','C1',12131,'1313@gmail.com',587131313,2,'Normal VIP','0.9'
    );
GO

select*from Person.Person;

--view all the information of flight schedule
CREATE VIEW v_FlightSchedule 
WITH SCHEMABINDING
AS 
SELECT fls.FlightScheduleID, fls.FlightID, fls.FlightDate, fls.ScheduleDepartureTime, fls.ScheduleArrivalTime, fls.ActualDepartureTime, fls.ActualeArrivalTime, dep.AirportName AS 'DepartureAirport', dep.CityName as 'DepartureCity', arr.AirportName as 'ArrivalAirport', arr.CityName as 'ArrivalCity', mo.Model
FROM
(SELECT fs.FlightScheduleID, fs.FlightID, fs.FlightDate, fs.ScheduleDepartureTime, fs.ScheduleArrivalTime, fs.ActualDepartureTime, fs.ActualeArrivalTime
 FROM Flight.FlightSchedule fs
 INNER JOIN Flight.Flight f
 ON fs.FlightID = f.FlightID)AS fls
INNER JOIN
(SELECT fs.FlightId, a.AirportName, c.CityName 
 FROM Flight.FlightSchedule fs
 INNER JOIN Flight.Flight f 
 ON fs.FlightID = f.FlightID
 INNER JOIN Flight.Airport a
 ON f.DepartureAirportID = a.AirportID
 INNER JOIN Flight.City c
 ON a.CityID = c.CityID) AS dep
ON fls.FlightID = dep.FlightID
INNER JOIN
(SELECT fs.FlightId, a.AirportName, c.CityName 
 FROM Flight.FlightSchedule fs
 INNER JOIN Flight.Flight f 
 ON fs.FlightID = f.FlightID
 INNER JOIN Flight.Airport a
 ON f.ArrivalAirportID = a.AirportID
 INNER JOIN Flight.City c
 ON a.CityID = c.CityID) AS arr
ON fls.FlightID = arr.FlightID
INNER JOIN
(SELECT fs.FlightID, fs.FlightScheduleID, a.Model 
 FROM Flight.FlightSchedule fs
 INNER JOIN Flight.FlightScheduleAirplane fsa 
 ON fs.FlightScheduleID = fsa.FlightScheduleID
 INNER JOIN Flight.Airplane a
 ON fsa.AirplaneID = a.AirplaneID) AS mo
ON dep.FlightID = mo.FlightID;

SELECT * FROM v_FlightSchedule;
GO

--view all information of orders
CREATE VIEW v_Order 
WITH SCHEMABINDING
AS
SELECT o.OrderID, o.Date, o.Status, o.TotalPurchase, bd.SeatScheduleID,bd.FlightTicketNumber, bd.Price, bd.PassengerFN, bd.PassengerMN, bd.PassengerLN, ss.SeatNumber,ba.Country,ba.State,ba.City,ba.Street,ba.Zipcode,buyer.BuyerFN,buyer.BuyerMN,buyer.BuyerLN
FROM Customer.[Order] o
INNER JOIN 
(SELECT b.OrderID,b.SeatScheduleID,b.FlightTicketNumber, b.Price, p.FirstName AS PassengerFN, p.MiddleName AS PassengerMN, p.LastName AS PassengerLN
 FROM Customer.Booking b 
 INNER JOIN Person.Person p
 ON b.PersonID = p.PersonID) AS bd
ON o.OrderID = bd.OrderID
INNER JOIN Flight.SeatSchedule ss
ON bd.SeatScheduleID = ss.SeatScheduleID
INNER JOIN Customer.BillingAddress ba
ON o.OrderID = ba.OrderID
INNER JOIN 
(SELECT c.CustomerID, p.FirstName AS BuyerFN, p.MiddleName AS BuyerMN, p.LastName AS BuyerLN
 FROM Customer.Customer c
 INNER JOIN Person.Person p
 ON c.PersonID = p.PersonID) AS buyer
ON o.CustomerID = buyer.CustomerID; 

SELECT * FROM v_Order;
GO

--view all information of companies
CREATE VIEW v_Company 
WITH SCHEMABINDING
AS
SELECT c.CompanyID,c.Name, ca.Country, ca.State, ca.Street, ca.Zipcode
FROM Employee.Company c
INNER JOIN Employee.CompanyAddress ca
ON c.CompanyID = ca.CompanyID;

SELECT * FROM v_Company;

--EncryptedPassword 
CREATE TRIGGER EncryptedAccount
ON Employee.Account
After INSERT
As
 BEGIN
Update Employee.Account 
Set
EncryptedPassword=EncryptByKey(Key_GUID(N'TestSymmetricKey'),  convert(varbinary, acc.Password)),
Password='fake'
from Employee.Account acc join inserted i on i.AccountID=acc.AccountID
 END;

 --open SYMMETRIC KEY
OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;

 --Insert Value to Account
 INSERT
INTO Employee.Account
(
	EmployeeID,
	UserName,
	Password
)
VALUES
(1 , 'U1','P1'),(2 , 'U2','P2'),(3 , 'U3','P3'),(4 , 'U4','P4'),(5 , 'U5','P5'),(6 , 'U6','P6'),(7 , 'U7','P7'),(8 , 'U8','P8'),(9 , 'U9','P9'),(10 , 'U10','P10');

--Check
SELECT * FROM Employee.Account;

select AccountID,EmployeeID, UserName, convert(varchar(20), DecryptByKey(EncryptedPassword)) AS Password,DeleteFlag
from Employee.Account

CLOSE SYMMETRIC KEY TestSymmetricKey;