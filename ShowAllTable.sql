



select * from Customers_1;
select * from Customers_2@site_link;

select * from Customers_1 UNION select * from Customers_2@site_link;

select * from Products_1;
select * from Products_2@site_link;

select * from Products_1 UNION select * from Products_2@site_link;

select * from Orders_1;
select * from Orders_2@site_link;

select * from Orders_1 a join Orders_2@site_link b on a.Order_ID=b.Order_ID;

select * from Order_Items_1;
select * from Order_Items_2@site_link;

select * from Order_Items_1 UNION select * from Order_Items_2@site_link;





























