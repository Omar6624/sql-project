Set Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE DeleteCust AS
    PROCEDURE cust_Delete1(id IN NUMBER);
	PROCEDURE cust_Delete2(id IN NUMBER);
END DeleteCust;
/


CREATE OR REPLACE PACKAGE BODY DeleteCust AS
    PROCEDURE cust_Delete1(id IN NUMBER)
    IS
    BEGIN 
        Delete from Customers_1 where Customer_ID=id;
		
		DBMS_OUTPUT.PUT_LINE('After Delete :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
    END cust_Delete1;
	PROCEDURE cust_Delete2(id IN NUMBER)
    IS
    BEGIN
        Delete from Customers_2@site_link where Customer_ID=id;
		
		DBMS_OUTPUT.PUT_LINE('After Delete :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
    END cust_Delete2;
	
END DeleteCust;
/

CREATE OR REPLACE TRIGGER DeleteCust1Trigger
AFTER DELETE ON Customers_1
FOR EACH ROW
BEGIN
    DELETE FROM Orders_1 WHERE Customer_ID = :OLD.Customer_ID;
END;
/
/*
CREATE OR REPLACE TRIGGER DeleteCust2Trigger
AFTER DELETE ON Customers_2@site_link
FOR EACH ROW
BEGIN
    DELETE FROM Orders_1 WHERE Customer_ID = :OLD.Customer_ID;
END;
/
*/
CREATE OR REPLACE TRIGGER DeleteCust1Order2Trigger
AFTER DELETE ON Orders_1
FOR EACH ROW
BEGIN
    DELETE FROM Orders_2@site_link WHERE Order_ID = :OLD.Order_ID;
END;
/
CREATE OR REPLACE TRIGGER DeleteCust1items1Trigger
AFTER DELETE ON Orders_1
FOR EACH ROW
BEGIN
    DELETE FROM Order_Items_1 WHERE Order_ID = :OLD.Order_ID;
END;
/

CREATE OR REPLACE TRIGGER DeleteCust1items2Trigger
AFTER DELETE ON Orders_1
FOR EACH ROW
BEGIN
    DELETE FROM Order_Items_2@site_link WHERE Order_ID = :OLD.Order_ID;
END;
/

select * from Customers_1;
select * from Customers_2@site_link;
DECLARE
	id  		Number ; 
	checkid1	Number := 0;
	checkid2	Number := 0;
	
	ID_Not_Found EXCEPTION;
	
BEGIN
	id := &ID_Where_To_Delete ;
	select COUNT(Customer_ID) into checkid1 from Customers_1  where Customer_ID=id;
	select COUNT(Customer_ID) into checkid2 from Customers_2@site_link  where Customer_ID=id;
	
	if checkid1>0 then
		DBMS_OUTPUT.PUT_LINE('Before Delete :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
		
		DeleteCust.cust_Delete1(id);
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
	ELSif checkid2>0 then
		DBMS_OUTPUT.PUT_LINE('Before Delete :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
		
		DeleteCust.cust_Delete2(id);
		DBMS_OUTPUT.PUT_LINE(' ');
		DBMS_OUTPUT.PUT_LINE(' ');
	ELSE
		RAISE ID_Not_Found;
	END if;
	
	COMMIT;
	EXCEPTION
		WHEN ID_Not_Found THEN
			DBMS_OUTPUT.PUT_LINE('The Customer ID You Entered Does Not Exist................');
			
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Other errors');
	
End;
/
COMMIT;