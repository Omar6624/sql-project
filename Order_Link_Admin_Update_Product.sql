aasSet Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE UpdateProd AS
    PROCEDURE prod_Update1(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2);
	PROCEDURE prod_Update2(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2);
END UpdateProd;
/


CREATE OR REPLACE PACKAGE BODY UpdateProd AS
    PROCEDURE prod_Update1(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2)
    IS
    BEGIN
        IF opt = 'Name' THEN
            Update Products_1 Set P_Name=val where Product_ID=id;
        ELSif opt = 'Price' THEN
            Update Products_1 Set Price=TO_NUMBER(val) where Product_ID=id;
		ELSif opt = 'S_L' THEN
            Update Products_1 Set Solid_Or_Liquid=val where Product_ID=id;
        END IF;
		
		DBMS_OUTPUT.PUT_LINE('After Update :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'			'||r.Price||'			'||r.Solid_Or_Liquid||'			');
		END loop;
    END prod_Update1;
	PROCEDURE prod_Update2(id IN NUMBER, opt IN VARCHAR2, val IN VARCHAR2)
    IS
    BEGIN
        IF opt = 'Name' THEN
            Update Products_2@site_link Set P_Name=val where Product_ID=id;
        ELSif opt = 'Price' THEN
            Update Products_2@site_link Set Price=TO_NUMBER(val) where Product_ID=id;
		ELSif opt = 'S_L' THEN
            Update Products_2@site_link Set Solid_Or_Liquid=val where Product_ID=id;
        END IF;
		
		DBMS_OUTPUT.PUT_LINE('After Update :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'			'||r.Price||'			'||r.Solid_Or_Liquid||'			');
		END loop;
    END prod_Update2;
	
END UpdateProd;
/
select * from Products_1;
select * from Products_2@site_link;
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
	select COUNT(Product_ID) into checkid1 from Products_1  where Product_ID=id;
	select COUNT(Product_ID) into checkid2 from Products_2@site_link  where Product_ID=id;
	
	if checkid1>0 then
		DBMS_OUTPUT.PUT_LINE('Before Update :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'			'||r.Price||'			'||r.Solid_Or_Liquid||'			');
		END loop;
		
		UpdateProd.prod_Update1(id,opt,val);
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
	ELSif checkid2>0 then
		DBMS_OUTPUT.PUT_LINE('Before Update :');
		DBMS_OUTPUT.PUT_LINE('Product_ID 	 '||'P_Name 		'||'Price			'||' Solid_Or_Liquid				');
		for r in (SELECT * from Products_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Product_ID||'		'||r.P_Name||'			'||r.Price||'			'||r.Solid_Or_Liquid||'			');
		END loop;
		
		UpdateProd.prod_Update2(id,opt,val);
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