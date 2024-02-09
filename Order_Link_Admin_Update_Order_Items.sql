Set Verify OFF;
Set ServerOutput ON;
set linesize 200;
CREATE OR REPLACE PACKAGE UpdateItems AS
    PROCEDURE Items_Update1(id IN NUMBER, opt IN VARCHAR2, val IN Number, O_ID IN Number,P_ID IN Number,Q IN Number,T_P IN Number);
	PROCEDURE Items_Update2(id IN NUMBER, opt IN VARCHAR2, val IN Number);
END UpdateItems;
/


CREATE OR REPLACE PACKAGE BODY UpdateItems AS
    PROCEDURE Items_Update1(id IN NUMBER, opt IN VARCHAR2, val IN Number,O_ID IN Number,P_ID IN Number,Q IN Number,T_P IN Number)
    IS
    BEGIN
        IF opt = 'Quantity' THEN
			Update Order_Items_1 Set Total_Price=(Total_Price/Quantity)*val where Item_ID=id;
            Update Order_Items_1 Set Quantity=val where Item_ID=id;
			
		ELSE 
			INSERT into Order_Items_2@site_link VALUES(id,O_ID,P_ID,Q,T_P,1);
			DELETE from Order_Items_1 where Item_ID=id;
            
        END IF;
		
		DBMS_OUTPUT.PUT_LINE('After Update :');
		DBMS_OUTPUT.PUT_LINE('Site 1 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('Site 2 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_2@site_link) LOOP
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
    END Items_Update1;
	PROCEDURE Items_Update2(id IN NUMBER, opt IN VARCHAR2, val IN Number)
    IS
    BEGIN
        IF opt = 'Quantity' THEN
			Update Order_Items_2@site_link Set Total_Price=(Total_Price/Quantity)*val where Item_ID=id;
            Update Order_Items_2@site_link Set Quantity=val where Item_ID=id;
			
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Order is Already Shipped ...........');
        END IF;
		
		DBMS_OUTPUT.PUT_LINE('After Update :');
		DBMS_OUTPUT.PUT_LINE('Site 1 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('Site 2 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_2@site_link) LOOP
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
    END Items_Update2;
	
END UpdateItems;
/

select * from Order_Items_1;
select * from Order_Items_2@site_link;

DECLARE
	opt         VARCHAR2(15);
	val			Number;
	id  		Number; 
	O_ID		Number:=0;
	P_ID		Number:=0;
	Q 			Number:=0;
	T_P			Number:=0;
	checkid1	Number := 0;
	checkid2	Number := 0;
	
	ID_Not_Found EXCEPTION;
BEGIN
	id := &ID_Where_To_Update ;
	opt := '&Quantity_OR_Status' ;
	val :=&The_Data;
	select COUNT(Item_ID) into checkid1 from Order_Items_1  where Item_ID=id;
	select COUNT(Item_ID) into checkid2 from Order_Items_2@site_link  where Item_ID=id;
	select Order_ID,Product_ID,Quantity,Total_Price into O_ID,P_ID,Q,T_P from Order_Items_1 where Item_ID=id;
	
	if checkid1>0 then
		DBMS_OUTPUT.PUT_LINE('Before Update :');
		DBMS_OUTPUT.PUT_LINE('Site 1 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
		DBMS_OUTPUT.PUT_LINE('Site 2 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_2@site_link) LOOP
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
		
		UpdateItems.Items_Update1(id,opt,val,O_ID,P_ID,Q,T_P);
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');
	ELSif checkid2>0 then
		DBMS_OUTPUT.PUT_LINE('Before Update :');
		DBMS_OUTPUT.PUT_LINE('Site 1 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_1) LOOP
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
		DBMS_OUTPUT.PUT_LINE('Site 2 :');
		DBMS_OUTPUT.PUT_LINE('Item_ID 	 '||'Order_ID 	'||'Product_ID		'||' Quantity		'||'Total_Price		'||'Status			');
		for r in (SELECT * from Order_Items_2@site_link) LOOP
			DBMS_OUTPUT.PUT_LINE(r.Item_ID||'		 '||r.Order_ID||'		'||r.Product_ID||'			 '||r.Quantity||'			'||r.Total_Price||'			'||r.Status);
		END loop;
		
		UpdateItems.Items_Update2(id,opt,val);
		DBMS_OUTPUT.PUT_LINE(' ');
		DBMS_OUTPUT.PUT_LINE(' ');
	ELSE
		RAISE ID_Not_Found;
	END if;
	
	COMMIT;
	EXCEPTION
		WHEN ID_Not_Found THEN
			DBMS_OUTPUT.PUT_LINE('The Customer ID You Entered Does Not Exist................');
		
	
End;
/
COMMIT;