--Summary Table

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year

-- ROLLUP

SELECT brand, Category, Model_Year, SUM(total_sales_price) AS total_price

FROM sale.sales_summary
GROUP BY 
		ROLLUP (brand, Category, Model_Year)

--CUBE

-- brand, category, model_year sütunlarý için cube kullanrak total_sales hesaplamasý:

SELECT brand, Category, Model_Year, SUM(total_sales_price) AS total_price

FROM sale.sales_summary
GROUP BY 
		CUBE (brand, Category, Model_Year)

--// PIVOT //--

/* BU ÝÞARET ÝLE BÝRDEN FAZLA
SATIRDA YORUM YAPILABÝLÝR.
*/

-- KATEGORÝLERE VE MODEL YILINA GÖRE TOPLAM SALES MÝKTARINI SUMMARY TABLOSU ÜZERÝNDEN HESAPLAYIN

SELECT Category, Model_Year, SUM(toral_sales_price) TOTAL_PRICE
FROM sale.sales_summary
GROUP BY 
		Category, Model_Year
ORDER BY 1,2


--------------------

SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price
	FROM	SALE.sales_summary
	) A
PIVOT
	(
	SUM(total_sales_price)
	FOR Category
	IN (
	[Children Bicycles],
    [Comfort Bicycles],
    [Cruisers Bicycles],
    [Cyclocross Bicycles],
    [Electric Bikes],
    [Mountain Bikes],
    [Road Bikes]
		)
	) AS P1


	-- SUBQUERIES

	-- Write a qury that returns the total list price for each order id


	SELECT DISTINCT order_id,
			(SELECT SUM(list_price) total_price 
			FROM sale.order_item B 
			WHERE A.order_id = B.order_id)
	FROM sale.order_item A


	-- Bring all the staff from the store Maria Cussona works 


	SELECT *
	FROM sale.staff
	WHERE store_id = (
					SELECT store_id
					FROM sale.staff
					WHERE first_name = 'Maria' AND last_name = 'Cussona'
					 )
-- List the staff .that Jane Destrey is the manager of


	SELECT first_name, last_name
	FROM sale.staff
	WHERE manager_id = (
					SELECT staff_id
					FROM sale.staff
					WHERE first_name = 'Jane' AND last_name = 'Destrey'
					)

-- Holbrook þehrinde oturan müþtetilerin sipariþ tarihlerini listeleyin.


SELECT customer_id, order_id, order_date
FROM Sale.orders
WHERE customer_id IN (
					SELECT customer_id
					FROM Sale.customer
					WHERE city = 'Holbrook'
					)


-- List all customers who orders on the same dates as Abby Parks

SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE order_date IN (
					SELECT order_date
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					)

-- Bütün elektrikli bisikletlerden pahalý olan bisikletleri listeleyin.
-- Ürün adý, model yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

SELECT product_name, list_price
FROM product.product
WHERE list_price > ALL 
					(SELECT A.list_price
					FROM product.product A 
					INNER JOIN product.category B 
					ON A.category_id = B.category_id
					WHERE B.category_name ='Electric Bikes') AND model_year >=2020
					ORDER BY list_price DESC



