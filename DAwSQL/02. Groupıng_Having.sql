USE SampleSales


--/////////JOINS_2/////////--

-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin...


SELECT TOP 20 A.staff_id, A.first_name, A.last_name, B.*
FROM sale.staff as A
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id
ORDER BY B.order_id;

-- Aþaðýdaki örneklerde iki JOIN(Left-Inner) arasýndaki farký görebiliriz.

SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id)
FROM sale.staff as A 
INNER JOIN sale.orders B
ON A.staff_id = B.staff_id

SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id)
FROM sale.staff as A 
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id

--//CROSS JOIN//-- Ödev

-- Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor

SELECT B.brand_id, B.brand_name, A.category_name, A.category_id
FROM product.category A
CROSS JOIN product.brand B
ORDER BY B.brand_name, A.category_name;

--//SELF JOIN//-- Ödev

SELECT A.first_name, A.last_name,  as manager_name
FROM sale.staff A
JOIN sale.staff B
ON A.manager_id = B.staff_id

-- Personelleri ve þeflerini listeleyin
-- Çalýþan adý ve yönetici adý bilgilerini getirin


-- Advanced Grouping Operations

--/////////HAVING/////////--/////////GROUPBY/////////--


----product tablosunda herhangi bir product id' nin çoklayýp çoklamadýðýný kontrol ediniz.

SELECT product_id, COUNT(product_id)
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1

--maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz
--category name' e gerek yok.

--SELECT	category_id, list_price
--FROM	product.product
--ORDER BY 1,2
--Write a query


SELECT p.category_id, max(o.list_price) AS mx, min(o.list_price) AS mn
FROM product.product p join sale.order_item o ON p.product_id = o.product_id
GROUP BY p.category_id
HAVING max(o.list_price) > 4000 OR min(o.list_price) < 500

--Markalara ait ortalama ürün fiyatlarýný bulunuz.
--Ortalama fiyatlara göre azalan sýrayla gösteriniz.

SELECT B.brand_name, AVG(list_price)
FROM product.product A
JOIN product.brand B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
ORDER BY AVG(list_price) DESC

---Ortalama ürün fiyatý 1000' den yüksek olan MARKALARI getiriniz

SELECT B.brand_name, AVG(list_price) AS Avg_PRICE
FROM product.product A
JOIN product.brand B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
HAVING AVG(list_price) > 1000
ORDER BY AVG(list_price)

--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.



-------------------///////////////////






--SELECT ... INTO FROM ...

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year




-----GROUPING SETS



-----------//////////////////

SELECT *
FROM	sale.sales_summary



----1. Toplam sales miktarýný hesaplayýnýz.


SELECT	SUM(total_sales_price)
FROM	sale.sales_summary


--2. Markalarýn toplam sales miktarýný hesaplayýnýz


SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand


--3. Kategori bazýnda yapýlan toplam sales miktarýný hesaplayýnýz



SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	Category


--4. Marka ve kategori kýrýlýmýndaki toplam sales miktarýný hesaplayýnýz


SELECT	brand, Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand, Category
ORDER BY brand



----

SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		GROUPING SETS (
				(brand, category),
				(brand),
 				(category),
				()
				)
ORDER BY
	brand, category


-------brand, category, model_year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýnýz.
--üç sütun için 4 farklý gruplama varyasyonu incelemeye çalýþýnýz.


