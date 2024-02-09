Set Verify OFF;
Set ServerOutput ON;
set linesize 200;

select * from Products_1;
select * from Products_2@site_link;
DECLARE
	PID  		Number ;
	quan		Number;
	C_ID		Number;
	checkid1	Number := 0;
	checkid2	Number := 0;
	Auto_Item	INT;
	Auto_Order  INT;
	P_price		Number;
	T_P			Number;
	
	CID_Not_Found EXCEPTION;
	PID_Not_Found EXCEPTION;
	
BEGIN
	PID := &ID_OF_Product ;
	select COUNT(Product_ID) into checkid1 from Products_1  where Product_ID=PID;
	select COUNT(Product_ID) into checkid2 from Products_2@site_link  where Product_ID=PID;
	
	if checkid1=0 and checkid2=0 then
		RAISE PID_Not_Found;
	END if;
	
	quan:= &Quantity;
	
	checkid1:=0;
	checkid2:=0;
	DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_1) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
	DBMS_OUTPUT.PUT_LINE('Customer_ID 	 '||'C_Name 		'||'Address			'||' Email				'||'Phone');
		for r in (SELECT * from Customers_2@site_link) LOOP
			
			DBMS_OUTPUT.PUT_LINE(r.Customer_ID||'		'||r.C_Name||'		'||r.Address||'		'||r.Email||'			'||r.Phone);
		END loop;
	C_ID:=&Customer_ID;
	select COUNT(Customer_ID) into checkid1 from Customers_1  where Customer_ID=C_ID;
	select COUNT(Customer_ID) into checkid2 from Customers_2@site_link  where Customer_ID=C_ID;
	
	if checkid1=0 and checkid2=0 then
		RAISE CID_Not_Found;
	END if;
	
	select max(Item_ID) into Auto_Item from (select * from Order_Items_1 UNION select * from Order_Items_2@site_link);
	select max(a.Order_ID) into Auto_Order from  Orders_1 a join Orders_2@site_link b on a.Order_ID=b.Order_ID;
	
	Auto_Item:=Auto_Item+1;
	Auto_Order:=Auto_Order+1;
	
	select Price into P_price from (select * from Products_1 UNION select * from Products_2@site_link) where Product_ID=PID;
	T_P:=quan*P_price;
	INSERT into Order_Items_1 VALUES(Auto_Item,Auto_Order,PID,quan,T_P,0);
	
	INSERT into Orders_1 VALUES(Auto_Order,C_ID);
	INSERT into Orders_2@site_link VALUES(Auto_Order,SYSDATE);
	
	
	COMMIT;
	EXCEPTION
		WHEN CID_Not_Found THEN
			DBMS_OUTPUT.PUT_LINE('The Customer ID You Entered Does Not Exist................');
		WHEN PID_Not_Found THEN
			DBMS_OUTPUT.PUT_LINE('The Product  ID You Entered Does Not Exist................');	
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Other errors');
	
End;
/
COMMIT;
select * from Order_Items_1;
select * from Order_Items_2@site_link;
select * from Orders_1;
select * from Orders_2@site_link;