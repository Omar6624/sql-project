Set Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE InsertProd AS
    PROCEDURE prod_insert(pr_id IN NUMBER, pr_name IN VARCHAR2, pr_price IN Number, S_L IN VARCHAR2);
END InsertProd;
/


CREATE OR REPLACE PACKAGE BODY InsertProd AS
    PROCEDURE prod_insert(pr_id IN NUMBER, pr_name IN VARCHAR2, pr_price IN Number, S_L IN VARCHAR2)
    IS
    BEGIN
        IF S_L = 'Solid' THEN
            INSERT INTO Products_1 VALUES (pr_id, pr_name, pr_price, S_L);
        ELSE
            INSERT INTO Products_2@site_link VALUES (pr_id, pr_name, pr_price, S_L);
        END IF;
    END prod_insert;
END InsertProd;
/


DECLARE
	pr_name  VARCHAR2(30);
	pr_price   Number;
	S_L  VARCHAR2(6);
	Auto_ID		Number;
	checkid1  Number := 0; 
	checkid2  Number := 0;
	
	Dup_ID EXCEPTION;
	
BEGIN
	select max(Product_ID) into Auto_ID from (select * from Products_1 UNION select * from Products_2@site_link);
	Auto_ID:=Auto_ID+1;
	pr_name :='&Product_Name';
	pr_price := &Product_Price;
	S_L := '&Solid_Or_Liquid';
	/*SELECT COUNT(Product_ID) into checkid1 from Products_1  where Product_ID=pr_id;
	SELECT COUNT(Product_ID) into checkid2 from Products_2@site_link  where Product_ID=pr_id;
	
	if checkid1>0 or checkid2>0 THEN
		RAISE Dup_ID;
	end if;
	*/
	InsertProd.prod_insert(Auto_ID,pr_name,pr_price,S_L);
	
	COMMIT;
	EXCEPTION
		WHEN Dup_ID THEN
			DBMS_OUTPUT.PUT_LINE('Product ID Entered Already Exists. Adding 1000 With the ID');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Other errors');
	
End;
/
COMMIT;
select * from Products_1;
select * from Products_2@site_link;