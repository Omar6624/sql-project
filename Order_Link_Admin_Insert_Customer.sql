Set Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE InsertCust AS
    PROCEDURE cust_insert(cus_id IN NUMBER, cus_name IN VARCHAR2, cus_add IN VARCHAR2, cus_mail IN VARCHAR2, cus_phn IN VARCHAR2);
END InsertCust;
/


CREATE OR REPLACE PACKAGE BODY InsertCust AS
    PROCEDURE cust_insert(cus_id IN NUMBER, cus_name IN VARCHAR2, cus_add IN VARCHAR2, cus_mail IN VARCHAR2, cus_phn IN VARCHAR2)
    IS
    BEGIN
        IF cus_add = 'Dhaka' THEN
            INSERT INTO Customers_1 VALUES (cus_id, cus_name, cus_add, cus_mail, cus_phn);
        ELSE
            INSERT INTO Customers_2@site_link VALUES (cus_id, cus_name, cus_add, cus_mail, cus_phn);
        END IF;
    END cust_insert;
END InsertCust;
/


DECLARE
	cus_id	  Number;
	cus_name  VARCHAR2(17);
	cus_add   VARCHAR2(10);
	cus_mail  VARCHAR2(27);
	cus_phn   VARCHAR2(11);
	Auto_ID   Number;
	checkid1  Number := 0; 
	checkid2  Number := 0;
	
	Dup_ID EXCEPTION;
	
BEGIN
	
	select max(Customer_ID) into Auto_ID from (select * from Customers_1 UNION select * from Customers_2@site_link);
	Auto_ID:=Auto_ID+1;
	cus_name :='&Customer_Name';
	cus_add := '&Customer_Address';
	cus_mail := '&Customer_Email';
	cus_phn := '&Customer_Phone_Number';
	/*SELECT COUNT(Customer_ID) into checkid1 from Customers_1 where Customer_ID=cus_id;
	SELECT COUNT(Customer_ID) into checkid2 from Customers_2@site_link where Customer_ID=cus_id;
	
	if checkid1>0 or checkid2>0 THEN
		RAISE Dup_ID;
	end if;
	*/
	InsertCust.cust_insert(Auto_ID,cus_name,cus_add,cus_mail,cus_phn);
	
	COMMIT;
	EXCEPTION
		WHEN Dup_ID THEN
			DBMS_OUTPUT.PUT_LINE('Customer ID Entered Already Exists. Adding 1000 With the ID');
			cus_id := cus_id + 1000;
			InsertCust.cust_insert(cus_id,cus_name,cus_add,cus_mail,cus_phn);
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Other errors');
	
End;
/
COMMIT;
select * from Customers_1;
select * from Customers_2@site_link;