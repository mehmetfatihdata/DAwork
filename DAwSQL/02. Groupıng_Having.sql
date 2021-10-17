USE SampleSales


--/////////JOINS_2/////////--

-- Ma�aza �al��anlar�n� yapt�klar� sat��lar ile birlikte listeleyin...


SELECT TOP 20 A.staff_id, A.first_name, A.last_name, B.*
FROM sale.staff as A
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id
ORDER BY B.order_id;

-- A�a��daki �rneklerde iki JOIN(Left-Inner) aras�ndaki fark� g�rebiliriz.

SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id)
FROM sale.staff as A 
INNER JOIN sale.orders B
ON A.staff_id = B.staff_id

SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id)
FROM sale.staff as A 
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id

--//CROSS JOIN//-- �dev

-- Hangi markada hangi kategoride ka�ar �r�n oldu�u bilgisine ihtiya� duyuluyor

SELECT B.brand_id, B.brand_name, A.category_name, A.category_id
FROM product.category A
CROSS JOIN product.brand B
ORDER BY B.brand_name, A.category_name;

--//SELF JOIN//-- �dev

SELECT A.first_name, A.last_name,  as manager_name
FROM sale.staff A
JOIN sale.staff B
ON A.manager_id = B.staff_id

-- Personelleri ve �eflerini listeleyin
-- �al��an ad� ve y�netici ad� bilgilerini getirin


-- Advanced Grouping Operations

--/////////HAVING/////////--/////////GROUPBY/////////--


----product tablosunda herhangi bir product id' nin �oklay�p �oklamad���n� kontrol ediniz.

SELECT product_id, COUNT(product_id)
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1

--maximum list price' � 4000' in �zerinde olan veya minimum list price' � 500' �n alt�nda olan categori id' leri getiriniz
--category name' e gerek yok.

--SELECT	category_id, list_price
--FROM	product.product
--ORDER BY 1,2
--Write a query


SELECT p.category_id, max(o.list_price) AS mx, min(o.list_price) AS mn
FROM product.product p join sale.order_item o ON p.product_id = o.product_id
GROUP BY p.category_id
HAVING max(o.list_price) > 4000 OR min(o.list_price) < 500

--Markalara ait ortalama �r�n fiyatlar�n� bulunuz.
--Ortalama fiyatlara g�re azalan s�rayla g�steriniz.

SELECT B.brand_name, AVG(list_price)
FROM product.product A
JOIN product.brand B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
ORDER BY AVG(list_price) DESC

---Ortalama �r�n fiyat� 1000' den y�ksek olan MARKALARI getiriniz

SELECT B.brand_name, AVG(list_price) AS Avg_PRICE
FROM product.product A
JOIN product.brand B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
HAVING AVG(list_price) > 1000
ORDER BY AVG(list_price)

--bir sipari�in toplam net tutar�n� getiriniz. (m��terinin sipari� i�in �dedi�i tutar)
--discount' � ve quantity' yi ihmal etmeyiniz.



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



----1. Toplam sales miktar�n� hesaplay�n�z.


SELECT	SUM(total_sales_price)
FROM	sale.sales_summary


--2. Markalar�n toplam sales miktar�n� hesaplay�n�z


SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand


--3. Kategori baz�nda yap�lan toplam sales miktar�n� hesaplay�n�z



SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	Category


--4. Marka ve kategori k�r�l�m�ndaki toplam sales miktar�n� hesaplay�n�z


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


-------brand, category, model_year s�tunlar� i�in Rollup kullanarak total sales hesaplamas� yap�n�z.
--�� s�tun i�in 4 farkl� gruplama varyasyonu incelemeye �al���n�z.


