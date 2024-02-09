Set Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE UpdateCust AS
    PROCEDURE cust_Update1(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2);
	PROCEDURE cust_Update2(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2);
END UpdateCust;
/


CREATE OR REPLACE PACKAGE BODY UpdateCust AS
    PROCEDURE cust_Update1(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2)
    IS
    BEGIN
        IF opt = 'Name' THEN
            Update Customers_1 Set C_Name=val where Customer_ID=id;
        ELSif opt = 'Address' THEN
            Update Customers_1 Set Address=val where Customer_ID=id;
		ELSif opt = 'Email' THEN
            Update Customers_1 Set Email=val where Customer_ID=id;
		ELSE 
           Update Customers_1 Set Phone=val where Customer_ID=id;
        END IF;
		
		DBMS_OUTPUT.PUT_LINE('After Update :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
    END cust_Update1;
	PROCEDURE cust_Update2(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2)
    IS
    BEGIN
        IF opt = 'Name' THEN
            Update Customers_2@site_link Set C_Name=val where Customer_ID=id;
        ELSif opt = 'Address' THEN
            Update Customers_2@site_link Set Address=val where Customer_ID=id;
		ELSif opt = 'Email' THEN
            Update Customers_2@site_link Set Email=val where Customer_ID=id;
		ELSE 
           Update Customers_2@site_link Set Phone=val where Customer_ID=id;
        END IF;
		
		DBMS_OUTPUT.PUT_LINE('After Update :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
    END cust_Update2;
	
END UpdateCust;
/
select * from Customers_1;
select * from Customers_2@site_link;
DECLARE
	opt         VARCHAR2(10);
	val			VARCHAR2(27);
	id  		Number ; 
	checkid1	Number := 0;
	checkid2	Number := 0;
	
	ID_Not_Found EXCEPTION;
	
BEGIN
	id := &ID_Where_To_Update ;
	opt := '&Column_Where_To_Update' ;
	val :='&The_Data';
	select COUNT(Customer_ID) into checkid1 from Customers_1  where Customer_ID=id;
	select COUNT(Customer_ID) into checkid2 from Customers_2@site_link  where Customer_ID=id;
	
	if checkid1>0 then
		DBMS_OUTPUT.PUT_LINE('Before Update :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
		
		UpdateCust.cust_Update1(id,opt,val);
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
	ELSif checkid2>0 then
		DBMS_OUTPUT.PUT_LINE('Before Update :');
		DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
		
		UpdateCust.cust_Update2(id,opt,val);
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