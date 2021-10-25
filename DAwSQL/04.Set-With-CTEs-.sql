

--- 23.10.2021 DAwSQL Session-4 Set Operators & Case Expression

---Exists

--'Trek Remedy 9.8 - 2019' ürününün sipariþ verilmediði state/state' leri getiriniz.


SELECT *
FROM SALE.order_item

-- Q : 'Trek Remedy 9.8 - 2019' ürünün sipariþ edilmediði state bilgilerini getiriniz. : 

-- 'Trek Remedy 9.8 - 2019' ürünün tüm bilgileri : 

SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D.*
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2019'

-- 'Trek Remedy 9.8 - 2019' ürünün sipariþ edilmediði state.

SELECT DISTINCT state 
FROM sale.customer X 
WHERE NOT EXISTS 
				(
				SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D.*
				FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
				WHERE	A.product_id = B.product_id
				AND		B.order_id = C.order_id
				AND		C.customer_id = D.customer_id
				AND		A.product_name = 'Trek Remedy 9.8 - 2019'
				AND		X.state = D.state
				)

-- 'Trek Remedy 9.8 - 2019' ürünün sipariþ edildiði state.

SELECT DISTINCT state 
FROM sale.customer X 
WHERE EXISTS 
				(
				SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D.*
				FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
				WHERE	A.product_id = B.product_id
				AND		B.order_id = C.order_id
				AND		C.customer_id = D.customer_id
				AND		A.product_name = 'Trek Remedy 9.8 - 2019'
				AND		X.state = D.state
				)

-- /// VÝEWS /// --

-- 2019 YILINDAN  SONRA ÜRETÝLEN ÜRÜNLERÝN BULUNDUÐU BÝR "NEW_PRODUCTS" view'i oluþturun.

CREATE VIEW new_view AS
SELECT product_id, model_year
FROM product.product
WHERE model_year > 2018



DROP VIEW new_view

SELECT * FROM new_view

-- CTE's

-- ///QUERY EXAMPLE///

-- Sharyn Hopkins isimli müþterinin son sipariþinden önce sipariþ vermiþ 
-- ve San diego þehrinde ikamet eden müþterileri listeleyin.


-- Shary Hopkins'in sipariþleri.

SELECT *
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'

-- Shary Hopkins'in son sipariþ tarihi. 

SELECT MAX(order_date)
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'

-- San diego þehrinde ikamet eden müþterileri listeleyin.

WITH T1 AS
			(SELECT MAX(order_date) last_purchase
			FROM sale.customer A, sale.orders B
			WHERE A.customer_id = B.customer_id
			AND A.first_name = 'Sharyn'
			AND A.last_name = 'Hopkins'
			)

SELECT DISTINCT A.order_date, A.order_id, B.customer_id, B.first_name, B.last_name, B.city 
FROM sale.orders A, sale.customer B, T1
WHERE A.customer_id = B.customer_id
AND a.order_date < T1.last_purchase
AND B.city = 'San Diego'


-- ///QUERY EXAMPLE///

--  List all customers who orders on the same dates as Abby Parks.

SELECT *
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Abby'
AND A.last_name = 'Parks'

SELECT order_date
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Abby'
AND A.last_name = 'Parks'

WITH T1 AS
			(SELECT order_date last_purchase
			FROM sale.customer A, sale.orders B
			WHERE A.customer_id = B.customer_id
			AND A.first_name = 'Abby'
			AND A.last_name = 'Parks'
			)

SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM sale.orders A, sale.customer B, T1
WHERE A.customer_id = B.customer_id
AND a.order_date = T1.last_purchase

--------------------

WITH T1 AS
(
SELECT 1 AS NUM
UNION ALL 
SELECT NUM + 1
FROM T1
WHERE NUM < 9
)
SELECT * 
FROM T1
;

--------------

---Set Operators

-- Sacramento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soyisimlerini listeleyin


SELECT last_name
FROM sale.customer
WHERE city = 'Sacramento'

UNION ALL

SELECT last_name
FROM sale.customer
WHERE city = 'Monroe'


-- Rreturns customers who first name is 'Carter' or last name is 'Carter' (don't use OR)

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Carter'

UNION ALL

SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Carter'

-- Sayýlarý...

SELECT COUNT(*)
FROM
(
SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Carter'

UNION ALL

SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Carter'
) A

-- Returns brands that have products for both 2018 and 2019
-- hem 2018 yýlýnda hem de 2019 yýlýnda ürünü olan markalarý getiriniz. 

--2018

SELECT *
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
AND a.model_year = 2018

--2019

SELECT *
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
AND a.model_year = 2019

--2018 + 2019

SELECT brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
AND a.model_year = 2018

INTERSECT

SELECT brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
AND a.model_year = 2019

----/////////

---2018,2019 VE 2020 YILLARININ HEPSÝNDE SÝPARÝÞÝ OLAN MÜÞTERÝLERÝN ÝSÝM VE SOYÝSMÝNÝ GETÝRÝNÝZ

-- Customers who have orders for both 2018,2019,2020

SELECT A.first_name, A.last_name, A.customer_id
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2018-01-01' AND '2018-12-31'

INTERSECT

SELECT A.first_name, A.last_name, A.customer_id
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

INTERSECT

SELECT A.first_name, A.last_name, A.customer_id
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2020-01-01' AND '2020-12-31'


----

SELECT	customer_id, first_name, last_name
FROM	sale.customer
WHERE	customer_id IN	(
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2019-01-01' AND '2019-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2020-01-01' AND '2020-12-31'
						)
