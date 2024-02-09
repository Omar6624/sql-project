/* 
Inputs For Site 1

*/
SET Verify OFF;
SET ServerOutput ON;


CLEAR screen;
drop table Customers_1   CASCADE CONSTRAINTS;
drop table Products_1    CASCADE CONSTRAINTS;
drop table Orders_1 	 CASCADE CONSTRAINTS;
drop table Order_Items_1 CASCADE CONSTRAINTS;

CREATE table Customers_1(
	Customer_ID INT PRIMARY KEY ,
	C_Name VARCHAR2(17) ,
	Address VARCHAR2(10),
	Email VARCHAR2(27) ,
	Phone VARCHAR2(11)
);
CREATE table Products_1(
	Product_ID INT PRIMARY KEY,
	P_Name VARCHAR2(30) ,
	Price NUMBER,
	Solid_Or_Liquid VARCHAR2(6)
);

CREATE table Orders_1(
	Order_ID INT PRIMARY KEY ,
	Customer_ID INT
	--dated date
);

CREATE table Order_Items_1(
	Item_ID INT PRIMARY KEY ,
	Order_ID INT,
	Product_ID INT,
	Quantity INT,
	Total_Price NUMBER,
	Status int
);

INSERT INTO Customers_1 VALUES(1,'Md. Rahman','Dhaka','md.rahman@gmail.com','01634563456');
INSERT INTO Customers_1 VALUES(2,'Farida Akter','Dhaka','farida.akter@email.com','01811987654');
INSERT INTO Customers_1 VALUES(3,'Kamal Ahmed','Dhaka','kamal.ahmed@email.com','01710246810');
INSERT INTO Customers_1 VALUES(4,'Nusrat Jahan','Dhaka','nusrat.jahan@email.com','01919876543');
INSERT INTO Customers_1 VALUES(5,'Ayesha Begum','Dhaka','ayesha.begum@email.com','01713135790');

INSERT INTO Products_1 VALUES(1,'Rice',40,'solid');
INSERT INTO Products_1 VALUES(2,'Biriyani',120,'solid');
INSERT INTO Products_1 VALUES(3,'Pitha',200,'solid');
INSERT INTO Products_1 VALUES(4,'Samosa',30,'solid');
INSERT INTO Products_1 VALUES(5,'Mango',100,'solid');

--INSERT INTO Orders_1 VALUES(1,1,to_date('01/12/2021','DD/MM/YYYY'));
INSERT INTO Orders_1 VALUES(1,1);
INSERT INTO Orders_1 VALUES(2,2);
INSERT INTO Orders_1 VALUES(3,3);
INSERT INTO Orders_1 VALUES(4,4);
INSERT INTO Orders_1 VALUES(5,5);
INSERT INTO Orders_1 VALUES(6,6);
INSERT INTO Orders_1 VALUES(7,7);
INSERT INTO Orders_1 VALUES(8,8);
INSERT INTO Orders_1 VALUES(9,9);
INSERT INTO Orders_1 VALUES(10,10);

INSERT INTO Order_Items_1 VALUES(1,1,1,5,200,0);
INSERT INTO Order_Items_1 VALUES(2,1,4,3,90,0);
INSERT INTO Order_Items_1 VALUES(3,2,2,1,120,0);
INSERT INTO Order_Items_1 VALUES(4,2,3,2,400,0);
INSERT INTO Order_Items_1 VALUES(5,3,8,5,100,0);

COMMIT; 

Select * from Customers_1;
Select * from Products_1;
Select * from Orders_1;
Select * from Order_Items_1;

Select * from Customers_2@site_link;
Select * from Products_2@site_link;
Select * from Orders_2@site_link;
Select * from Order_Items_2@site_link;























