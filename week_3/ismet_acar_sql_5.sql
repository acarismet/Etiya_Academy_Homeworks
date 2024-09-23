-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.

SELECT product_name,quantity_per_unit FROM products 



-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.

SELECT product_id, product_name, discontinued
FROM products
WHERE discontinued = 1



-- 3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.

-- Aksi ima edilmiş olabilir diye yukarıdaki sorgunun aynısını yazmak yerine devam eden ürünleri verebiliriz:
-- In case it is implied otherwise, instead of writing the same query as above, we can give the following products:
SELECT product_id, product_name, discontinued
FROM products
WHERE discontinued = 0



-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.

SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price < 20 



-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.

-- ## 15 dahil, 25 değil || Includes 15 Not 25
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price BETWEEN 15 AND 25 

-- ## İkisi de dahil || Including both
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price <= 25 AND unit_price >= 15

-- ## İkisi de dahil değil || Neither of them included
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price < 25 AND unit_price > 15



-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.

SELECT product_name, units_on_order, units_in_stock
FROM products
WHERE units_in_stock < units_on_order 



-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.

SELECT * FROM products
WHERE product_name LIKE 'A%' 


-- 8. İsmi `i` ile biten ürünleri listeleyeniz.

SELECT * FROM products
WHERE product_name LIKE '%i' 



-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.

SELECT product_name, unit_price, unit_price * 1.18 AS UnitPriceWithKDV
FROM products 


-- 10. Fiyatı 30 dan büyük kaç ürün var?

SELECT COUNT(*) AS ABOVE_30
FROM products
WHERE unit_price > 30 



-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele

SELECT LOWER(product_name) AS LowercaseProductName, unit_price
FROM products
ORDER BY unit_price DESC;



-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır

SELECT CONCAT(first_name, ' ',last_name) FROM employees; 


-- 13. Region alanı NULL olan kaç tedarikçim var?

SELECT COUNT(*) AS Null_Region
FROM suppliers
WHERE region IS NULL 


-- 14. a.Null olmayanlar?

-- Adet
SELECT COUNT(*) AS Null_Region FROM suppliers

-- Liste
SELECT * FROM suppliers
WHERE region IS NOT NULL



-- 15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.

SELECT CONCAT('TR ', UPPER(product_name)) FROM products; 



-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle

SELECT CONCAT('TR ', UPPER(product_name))
FROM products
WHERE unit_price < 20 



-- 17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

-- a. En Pahalı Ürün Bilgileri Olarak Varsayarsak
SELECT product_name, unit_price
FROM products
WHERE unit_price = (SELECT MAX(unit_price) FROM products)

-- b. En pahalıdan ucuza sıralama olarak varsayarsak
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC 



-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC LIMIT 10;



-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY unit_price 


-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.

SELECT product_name, unit_price * units_in_stock AS Total_Income
FROM products
WHERE units_in_stock > 0
ORDER BY unit_price * units_in_stock DESC



-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.

SELECT COUNT(CASE WHEN discontinued = 0 THEN 1 END) AS discontinued_0,
			 COUNT(CASE WHEN discontinued = 1 THEN 1 END) AS discontinued_1,
			 COUNT(*) AS Total FROM products;


			
-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.

SELECT products.product_name, categories.category_name
FROM products
INNER JOIN categories ON products.category_id = categories.category_id 
ORDER BY category_name 		



-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.

SELECT c.category_name, AVG(p.unit_price) AS Average_Prices
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
GROUP BY c.category_name;			



-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?

SELECT p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
WHERE unit_price = (SELECT MAX(unit_price) FROM products) 



-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı

SELECT c.category_id, c.category_name, od.product_id, p.product_name, SUM(quantity) AS totalQ
FROM order_details od
JOIN products p ON p.product_id = od.product_id
JOIN categories c ON c.category_id = p.category_id 
GROUP BY od.product_id, c.category_id, c.category_name, p.product_name 
ORDER BY totalQ DESC
LIMIT 1


--*-*-*-*-*-*-*-*
-- Alternative NOT DONE - DEVAM EDECEĞİM BU ALTERNATİFİ YAZMAYA...

WITH TotalQuantitiesByProducts AS (
	SELECT od.product_id, SUM(quantity) AS totalQ
	FROM order_details od
	GROUP BY od.product_id
	ORDER BY totalQ DESC
)
SELECT MAX(totalQ) AS TopOne
	FROM (SELECT od.product_id, SUM(quantity) AS totalQ
			FROM order_details od
			GROUP BY od.product_id
			ORDER BY totalQ DESC)

--*-*-*-*-*-*-*-*


			
-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.

SELECT p.product_id, p.product_name, s.company_name, s.phone
FROM products p
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.units_in_stock = 0



-- 27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı

SELECT ship_address, first_name || ' ' || last_name, order_date FROM orders AS o
INNER JOIN employees AS e ON e.employee_id = o.employee_id
WHERE order_date >= '1998-03-01' AND order_date <= '1998-03-31'



-- 28. 1997 yılı şubat ayında kaç siparişim var?

SELECT COUNT(order_id) AS March_Total_Order
FROM orders
WHERE date_part('year', order_date) = 1997
AND date_part('month', order_date) = 02



-- 29. London şehrinden 1998 yılında kaç siparişim var?

SELECT ship_city, COUNT(order_id) AS TotalOrder FROM orders
WHERE ship_city = 'London'
AND date_part('year', order_date) = 1998
GROUP BY ship_city



-- 30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası

SELECT contact_name, phone FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE date_part('year', order_date) = 1997
GROUP BY customers.customer_id
ORDER BY contact_name



-- 31. Taşıma ücreti 40 üzeri olan siparişlerim

SELECT order_id, freight AS Ship_Price FROM orders
WHERE freight > 40
ORDER BY order_id



-- 32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

SELECT company_name, city, SUM(freight) AS Total_Ship_Price
FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE freight > 40
GROUP BY company_name, city
ORDER BY company_name



-- 33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),

SELECT order_date, ship_city, UPPER(first_name || ' ' || last_name) FROM orders
JOIN employees ON employees.employee_id = orders.employee_id
WHERE date_part('year', order_date) = 1997



-- 34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )

SELECT DISTINCT contact_name,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), '.', '') AS formatted_phone
FROM customers
INNER JOIN orders ON orders.customer_id = customers.customer_id
WHERE date_part('year', order_date) = 1997



-- 35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad

SELECT o.shipped_date, c.contact_name,
(e.first_name || ' ' || e.last_name) AS Employee FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
INNER JOIN employees AS e ON e.employee_id = o.employee_id
ORDER BY o.shipped_date



-- 36. Geciken siparişlerim?

SELECT order_id, required_date, shipped_date, (shipped_date - required_date) AS Delay_Days
FROM orders
WHERE required_date < shipped_date



-- 37. Geciken siparişlerimin tarihi, müşterisinin adı

SELECT order_id, company_name, contact_name, required_date, shipped_date, (shipped_date - required_date) AS Delay_Days
FROM orders
INNER JOIN customers ON customers.customer_id = orders.customer_id
WHERE required_date < shipped_date



-- 38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT p.product_name, c.category_name, od.quantity FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id 
INNER JOIN categories AS c ON c.category_id = p.category_id
WHERE order_id = 10248



-- 39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

SELECT p.product_name, s.company_name AS Supplier_Company, s.contact_name FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id 
INNER JOIN suppliers AS s ON s.supplier_id = p.supplier_id
WHERE order_id = 10248



-- 40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT o.employee_id, p.product_name, od.quantity
FROM order_details AS od
JOIN products AS p ON p.product_id = od.product_id
JOIN orders AS o ON o.order_id = od.order_id
WHERE o.employee_id = 3
AND date_part('year', order_date) = 1997



-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

-- Ürün Adedi bazında ise: Andrew Fuller with 286
SELECT o.order_id, o.employee_id, (e.first_name || ' ' || e.last_name) AS our_Hero, SUM(od.quantity) AS Total_Unit, o.order_date
FROM order_details AS od
JOIN orders AS o ON o.order_id = od.order_id
JOIN employees AS e ON e.employee_id = o.employee_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY o.order_id, o.employee_id, our_Hero, o.order_date
ORDER BY Total_Unit DESC LIMIT 1


-- Kazanç bazında ise: Robert King with 11493 Dollares
SELECT o.order_id, o.employee_id, (e.first_name || ' ' || e.last_name) AS our_Hero, SUM(od.quantity * od.unit_price) AS Total_Revenue, o.order_date
FROM order_details AS od
JOIN orders AS o ON o.order_id = od.order_id
JOIN employees AS e ON e.employee_id = o.employee_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY o.order_id, o.employee_id, our_Hero, o.order_date
ORDER BY Total_Revenue DESC LIMIT 1



-- 42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

-- Ürün Adedi bazında ise: Margaret Peacock with 5273 quantity
SELECT o.employee_id, (e.first_name || ' ' || e.last_name) AS TheBest, SUM(od.quantity) AS Total_Sale_Unit
FROM order_details AS od
JOIN orders AS o ON o.order_id = od.order_id
JOIN employees AS e ON e.employee_id = o.employee_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY SUM(od.quantity) DESC LIMIT 1;


-- Kazanç bazında ise: Margaret Peacock with 139477.69 revenue
SELECT o.employee_id, (e.first_name || ' ' || e.last_name) AS TheBest, SUM(od.quantity * od.unit_price) AS Total_Revenue
FROM order_details AS od
JOIN orders AS o ON o.order_id = od.order_id
JOIN employees AS e ON e.employee_id = o.employee_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY SUM(od.quantity * od.unit_price) DESC LIMIT 1;


-- Satış Miktarı Olarak İse: Laura Callahan with 54 orders
SELECT o.employee_id, COUNT(*) AS countOF, (e.first_name || ' ' || e.last_name) AS TheBest
FROM orders AS o
JOIN employees AS e ON e.employee_id = o.employee_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY SUM(o.employee_id) DESC LIMIT 1;

-- ******************** Sağlaması ******************** --
SELECT employee_id FROM orders
WHERE employee_id = 8
AND date_part('year', order_date) = 1997



-- 43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

SELECT p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c ON c.category_id = p.category_id
INNER JOIN order_details AS od ON od.product_id = p.product_id
WHERE od.unit_price = (SELECT MAX(order_details.unit_price) FROM order_details)
GROUP BY p.product_name, p.unit_price, c.category_name



-- 44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

WITH MaxUnitPriceProduct AS (
    SELECT 
        od.product_id,
        od.unit_price
    FROM order_details AS od
    WHERE od.unit_price = (SELECT MAX(unit_price) FROM order_details)
)
SELECT 
    p.product_name, 
    c.category_name, 
    e.first_name, 
    e.last_name,
    o.order_id,
    o.order_date
FROM MaxUnitPriceProduct AS mup
INNER JOIN products AS p ON p.product_id = mup.product_id
INNER JOIN categories AS c ON c.category_id = p.category_id
INNER JOIN order_details AS od ON od.product_id = p.product_id
INNER JOIN orders AS o ON o.order_id = od.order_id
INNER JOIN employees AS e ON e.employee_id = o.employee_id
GROUP BY p.product_name, c.category_name, e.first_name, e.last_name, o.order_id, o.order_date



-- 45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

SELECT od.order_id, AVG(od.unit_price * od.quantity) AS Average, o.order_date
FROM order_details od
INNER JOIN orders  o ON o.order_id = od.order_id
GROUP BY od.order_id, o.order_date
ORDER BY o.order_date DESC LIMIT 5


-- 46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

-- Kazanç - Revenue
SELECT p.product_name, c.category_name, od.quantity * od.unit_price AS Total_Revenue
FROM orders as o
JOIN order_details od on od.order_id = o.order_id
JOIN products p on p.product_id = od.product_id
JOIN categories c on c.category_id = p.category_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1


-- Satış Adedi - Sales Quantity
SELECT p.product_name, c.category_name, od.quantity
FROM orders as o
JOIN order_details od on od.order_id = o.order_id
JOIN products p on p.product_id = od.product_id
JOIN categories c on c.category_id = p.category_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1



-- 47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

SELECT order_id FROM order_details
WHERE (unit_price * quantity) > (SELECT AVG(unit_price * quantity) FROM order_details)



-- 48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

SELECT p.product_name, c.category_name, s.company_name, od.quantity
FROM products AS p
JOIN order_details AS od ON od.product_id = p.product_id
JOIN categories AS c ON c.category_id = p.category_id
JOIN suppliers AS S ON s.supplier_id = p.supplier_id
WHERE od.quantity = (SELECT MAX(order_details.quantity) FROM order_details)



-- 49. Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) AS total_countries
FROM customers



-- 50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

SELECT SUM(od.quantity * od.unit_price) AS Total_Sales
FROM order_details AS od
JOIN orders AS o ON o.order_id = od.order_id
JOIN employees AS e ON e.employee_id = o.employee_id
WHERE o.employee_id = 3
AND order_date BETWEEN '1998-01-01' AND CURRENT_DATE;



-- *** 51-52-53-54-55-56-57-58-59-60-61-62--64 same from 38 to 50 *** --





-- 63. Hangi ülkeden kaç müşterimiz var

SELECT country, COUNT(customer_id) AS Total_Customer FROM customers
GROUP BY country
ORDER BY country



-- 65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

SELECT p.product_id, p.product_name, SUM(od.quantity * od.unit_price)
FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id
INNER JOIN orders AS o ON o.order_id = od.order_id
WHERE p.product_id = 10
AND o.order_date >= '1998-04-01'
GROUP BY p.product_id



-- 66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

SELECT e.employee_id, (e.first_name || ' ' || e.last_name) AS employee, COUNT(o.order_id) AS Total_Order
FROM orders AS o
INNER JOIN employees AS e ON e.employee_id = o.employee_id
INNER JOIN order_details AS od ON od.order_id = o.order_id
GROUP BY e.employee_id



-- 67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

SELECT * FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.customer_id IS NULL



-- 68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

SELECT company_name, contact_name, address, city, country FROM customers
WHERE country = 'Brazil'



-- 69. Brezilya’da olmayan müşteriler

SELECT company_name, country FROM customers
WHERE country <> 'Brazil'



-- 70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

SELECT company_name, country FROM customers
WHERE country = 'Spain' OR country = 'France' OR country = 'Germany'



-- 71. Faks numarasını bilmediğim müşteriler

SELECT company_name, fax FROM customers
WHERE fax IS NULL



-- 72. Londra’da ya da Paris’de bulunan müşterilerim

SELECT company_name, city FROM customers
WHERE city = 'London' OR city = 'Paris'



-- 73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

SELECT company_name, CONCAT(contact_title, ' - ', contact_name) AS ContactInfo FROM customers
WHERE city = 'México D.F.' AND contact_title = 'Owner'



-- 74. C ile başlayan ürünlerimin isimleri ve fiyatları

SELECT product_name, unit_price FROM products
WHERE product_name LIKE 'C%'



-- 75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

SELECT first_name, last_name, birth_date FROM employees
WHERE first_name LIKE 'A%'



-- 76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

SELECT company_name FROM customers
WHERE company_name LIKE '%Restaurant%'



-- 77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

SELECT product_name, unit_price FROM products
WHERE unit_price >= 50 AND unit_price <= 100
ORDER BY unit_price 



-- 78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri

SELECT order_id, order_date FROM orders
WHERE order_date >= '1996-07-01' AND order_date <= '1996-12-31'



-- 79, 80 same with 70 and 71




-- 81. Müşterilerimi ülkeye göre sıralıyorum:

SELECT country, company_name FROM customers
ORDER BY country



-- 82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz

-- ** Aynı ürünün, farklı siparişlerde birim fiyatı değişmiş
SELECT p.product_name, od.unit_price FROM order_details AS od
JOIN products AS p ON p.product_id = od.product_id
GROUP BY p.product_name, od.unit_price
ORDER BY od.unit_price DESC



-- 83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT p.product_name, od.unit_price, p.units_in_stock FROM order_details AS od
JOIN products AS p ON p.product_id = od.product_id
GROUP BY p.product_name, od.unit_price, p.units_in_stock
ORDER BY od.unit_price DESC, p.units_in_stock ASC



-- 84. 1 Numaralı kategoride kaç ürün vardır..?

SELECT COUNT(category_id) AS Category1Quantity FROM products
WHERE category_id = 1
GROUP BY category_id



-- 85. Kaç farklı ülkeye ihracat yapıyorum..?

SELECT COUNT(DISTINCT country) AS total_countries
FROM customers



-- 86. a.Bu ülkeler hangileri..?

SELECT DISTINCT country FROM customers
ORDER BY country



-- 87. En Pahalı 5 ürün

-- Satışlara Göre Olursa 2 ürün tekrara düşüyor. Farklı siparişlerde farklı fiyatlar
SELECT DISTINCT od. product_id, p.product_name, od.unit_price FROM order_details od
JOIN products p ON p.product_id = od.product_id 
ORDER BY od.unit_price DESC LIMIT 5;


-- Products Tablosuna Göre Tekrarsız
SELECT DISTINCT product_id, product_name, unit_price FROM products
ORDER BY unit_price DESC LIMIT 5



-- 88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?

SELECT COUNT(customer_id) FROM customers
WHERE customer_id = 'ALFKI'



-- 89. Ürünlerimin toplam maliyeti

-- Stoktaki adetleriyle birlikte
SELECT SUM(unit_price * units_in_stock) FROM products



-- 90. Şirketim, şimdiye kadar ne kadar ciro yapmış..? 

SELECT SUM(quantity * unit_price) AS Total_Revenue FROM order_details



-- 91. Ortalama Ürün Fiyatım

-- Ürün bazında 
SELECT product_id, AVG(unit_price) AS average_price
FROM order_details
GROUP BY product_id

-- Siparişlerdeki fiyatlandırma bazında
SELECT AVG(unit_price) FROM order_details


-- 92. En Pahalı Ürünün Adı 

SELECT p.product_name AS The_Most_Expensive
FROM products AS p
JOIN order_details AS od ON od.product_id = p.product_id
WHERE od.unit_price = (SELECT MAX(order_details.unit_price) FROM order_details)
GROUP BY p.product_name



-- 93. En az kazandıran sipariş 

SELECT od.product_id, p.product_name, SUM(od.quantity * od.unit_price) AS total_revenue
FROM order_details AS od
JOIN products AS p ON p.product_id = od.product_id
GROUP BY od.product_id, p.product_name
ORDER BY total_revenue ASC LIMIT 1


-- 94. Müşterilerimin içinde en uzun isimli müşteri

SELECT customer_id, company_name, contact_name FROM customers
ORDER BY LENGTH(company_name) DESC LIMIT 1


-- 95. Çalışanlarımın Ad, Soyad ve Yaşları

SELECT employee_id,title || ' - ' || ' ' || first_name || ' ' || last_name AS Coworker, birth_date, AGE(CURRENT_DATE, birth_date) AS age
FROM employees



-- 96. Hangi üründen toplam kaç adet alınmış..?

SELECT od.product_id, p.product_name, SUM(od.quantity)
FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id
GROUP BY od.product_id, p.product_name
ORDER BY od.product_id



-- 97. Hangi siparişte toplam ne kadar kazanmışım..? 

SELECT order_id, SUM(quantity * unit_price) FROM order_details
GROUP BY order_id
ORDER BY order_id



-- 98. Hangi kategoride toplam kaç adet ürün bulunuyor..?

SELECT p.category_id, c.category_name, COUNT(p.product_id)
FROM products AS p
JOIN categories AS c ON c.category_id = p.category_id
GROUP BY p.category_id, c.category_name
ORDER BY p.category_id



-- 99. 1000 Adetten fazla satılan ürünler?

SELECT product_id, SUM(quantity) AS Total
FROM order_details
GROUP BY product_id
HAVING SUM(quantity) >= 1000
ORDER BY Total


-- 100. Hangi Müşterilerim hiç sipariş vermemiş..?

SELECT * FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.customer_id IS NULL

