


--Replace 

SELECT REPLACE('CHARACTER STRING', ' ', '/')


--STR

SELECT STR(5454)

SELECT STR(5454.475, 7)

SELECT STR(5454.475, 3, 2)

SELECT REPLACE(1232435464, 123, 'aha')

SELECT REPLACE(1232435464, 123, 'aha') + 1

SELECT REPLACE(1232435464, 123, 123) + 1 

SELECT ISNUMERIC(REPLACE(1232435464, 123, 'aha'))

-- CAST

SELECT CAST(123135 AS VARCHAR) 

SELECT CAST((0.3333333) AS NUMERIC(3,2))

SELECT CAST((0.3333333) AS DECIMAL(3,2))


--CONVERT

SELECT CONVERT(INT, 30.48)

SELECT CONVERT(DATETIME, '2021-10-10')

SELECT CONVERT(VARCHAR, '2021-10-10', 6)

--COALAESCE 

SELECT COALESCE(NULL, NULL, 'Ahmet', NULL)

--NULLIF 

SELECT NULLIF (10, 9)

--ROUND

SELECT ROUND(432.368, 2)

SELECT ROUND(432.368, 3)

SELECT ROUND(432.368, 2, 1)

-- Yahoo mailini kullanan customerlarýn  miktarýný getirin. 

SELECT COUNT(*)
FROM sale.customer
WHERE email LIKE '%yahoo%'

SELECT 
SUM(
CASE WHEN 
PATINDEX('%@yahoo%', email)<> 0 AND 
PATINDEX('%@yahoo%', email) is not null 
THEN 1 ELSE 0 END) AS mail
FROM sale.customer

-- EMAIL deki '.' dan önceki stringleri getiriniz. 

SELECT email
FROM sale.customer

SELECT email, CHARINDEX('.', email)
FROM sale.customer

SELECT email, LEFT(email, CHARINDEX('.', email))
FROM sale.customer

SELECT email, LEFT(email, CHARINDEX('.', email)-1)
FROM sale.customer

-- Add a new column to the custome that contains the customers contact info.

-- if the phone is  not null, the phone information will be printed, if not, the email information will be printed.

SELECT *, COALESCE(phone, email) CONTACT
FROM sale.customer

SELECT *, COALESCE(phone, nullif(email, 'emily.brooks@yahoo.com')) CONTACT
FROM sale.customer

-- The third character of the streets is numerical 

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer
WHERE SUBSTRING(street, 3, 1) LIKE '[a-z]'

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer
WHERE SUBSTRING(street, 3, 1) LIKE '[^0-9]'

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer
WHERE SUBSTRING(street, 3, 1) NOT LIKE '[^0-9]'

----/////WINDOW FUNC/////----

-- Ürünlerin stock sayýlarýný bulunuz

SELECT product_id, SUM(quantity)
FROM product.stock
GROUP BY product_id

SELECT DISTINCT *, 
				SUM(quantity) OVER (PARTITION BY product_id) AS Total_Stock
FROM product.stock

--En ucuz bisikletin fiyatý.

SELECT MIN(list_price)
FROM product.product

SELECT MIN(list_price) OVER (PARTITION BY list_price) as CHEAPEST
FROM product.product

-- HErhangi bir kategorindeki en ucuz bisiklerin fiyatý.

SELECT DISTINCT category_id, MIN(list_price) OVER (PARTITION BY list_price) as CHEAPEST
FROM product.product








