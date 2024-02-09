Set Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE DeleteProd AS
    PROCEDURE Prod_Delete1(id IN NUMBER);
	PROCEDURE Prod_Delete2(id IN NUMBER);
END DeleteProd;
/


CREATE OR REPLACE PACKAGE BODY DeleteProd AS
    PROCEDURE Prod_Delete1(id IN NUMBER)
    IS
    BEGIN 
        Delete from Products_1 where Product_ID=id;
		
		DBMS_OUTPUT.PUT_LINE('After Delete :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'		'||r.Price||'		'||r.Solid_Or_Liquid||'			');
		END loop;
    END Prod_Delete1;
	PROCEDURE Prod_Delete2(id IN NUMBER)
    IS
    BEGIN
        Delete from Products_2@site_link where Product_ID=id;
		
		DBMS_OUTPUT.PUT_LINE('After Delete :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'		'||r.Price||'		'||r.Solid_Or_Liquid||'			');
		END loop;
    END Prod_Delete2;
	
END DeleteProd;
/


CREATE OR REPLACE TRIGGER DeleteProd1items1Trigger
AFTER DELETE ON Products_1
FOR EACH ROW
BEGIN
    DELETE FROM Order_Items_1 WHERE Product_ID = :OLD.Product_ID;
END;
/

CREATE OR REPLACE TRIGGER DeleteProd1items2Trigger
AFTER DELETE ON Products_1
FOR EACH ROW
BEGIN
    DELETE FROM Order_Items_2@site_link WHERE Product_ID = :OLD.Product_ID;
END;
/

select * from Products_1;
select * from Products_2@site_link;

DECLARE
	id  		Number ; 
	checkid1	Number := 0;
	checkid2	Number := 0;
	
	ID_Not_Found EXCEPTION;
	
BEGIN
	id := &ID_Where_To_Delete ;
	select COUNT(Product_ID) into checkid1 from Products_1  where Product_ID=id;
	select COUNT(Product_ID) into checkid2 from Products_2@site_link  where Product_ID=id;
	
	if checkid1>0 then
		DBMS_OUTPUT.PUT_LINE('Before Delete :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'		'||r.Price||'		'||r.Solid_Or_Liquid||'			');
		END loop;
		
		DeleteProd.Prod_Delete1(id);
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
	ELSif checkid2>0 then
		DBMS_OUTPUT.PUT_LINE('Before Delete :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'		'||r.Price||'		'||r.Solid_Or_Liquid||'			');
		END loop;
		
		DeleteProd.Prod_Delete2(id);
		DBMS_OUTPUT.PUT_LINE(' ');
		DBMS_OUTPUT.PUT_LINE(' ');
	ELSE
		RAISE ID_Not_Found;
	END if;
	
	COMMIT;
	EXCEPTION
		WHEN ID_Not_Found THEN
			DBMS_OUTPUT.PUT_LINE('The Product ID You Entered Does Not Exist................');
			
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Other errors');
	
End;
/
COMMIT;