-- 101. Hangi tedarikçi hangi ürünü sağlıyor ?

SELECT s.company_name AS Supplier, p.product_name FROM suppliers s
JOIN products p ON p.supplier_id = s.supplier_id
ORDER BY s.company_name



-- 102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?

SELECT o.order_id, s.company_name AS shipper, o.shipped_date
FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id



-- 103. Hangi siparişi hangi müşteri verir..?

SELECT o.order_id, c.company_name AS customer
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id



-- 104. Hangi çalışan, toplam kaç sipariş almış..?

SELECT e.first_name, e.last_name, COUNT(o.order_id) AS total_orders
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.first_name, e.last_name;



-- 105. En fazla siparişi kim almış..?

SELECT e.first_name, e.last_name, COUNT(o.order_id) AS total_orders
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY total_orders DESC
LIMIT 1;



-- 106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?

SELECT o.order_id, e.first_name AS employee, c.company_name AS customer
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
JOIN customers c ON o.customer_id = c.customer_id



-- 107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?

SELECT p.product_name, cat.category_name, s.company_name AS supplier
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id



-- 108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış

WITH customer_info AS (
    SELECT o.order_id, c.company_name AS customer, e.first_name AS employee, o.order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN employees e ON o.employee_id = e.employee_id
),
shipping_info AS (
    SELECT o.order_id, s.company_name AS shipper, o.shipped_date
    FROM orders o
    JOIN shippers s ON o.ship_via = s.shipper_id
),
product_info AS (
    SELECT od.order_id, od.quantity, od.unit_price, p.product_name, cat.category_name, sup.company_name AS supplier
    FROM order_details od
    JOIN products p ON od.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN suppliers sup ON p.supplier_id = sup.supplier_id
)
SELECT ci.order_id, ci.customer, ci.employee, ci.order_date, si.shipper, si.shipped_date,
       pi.product_name, pi.quantity, pi.unit_price, pi.category_name, pi.supplier
FROM customer_info ci
JOIN shipping_info si ON ci.order_id = si.order_id
JOIN product_info pi ON ci.order_id = pi.order_id;



-- 109. Altında ürün bulunmayan kategoriler

-- All categories has products
SELECT category_name
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.product_id IS NULL;



-- 110. Manager ünvanına sahip tüm müşterileri listeleyiniz.

SELECT company_name, contact_name
FROM customers
WHERE contact_title LIKE '%Manager%';



-- 111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.

SELECT company_name, contact_name
FROM customers
WHERE customer_id LIKE 'FR%' AND LENGTH(customer_id) = 5;



-- 112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.

SELECT company_name, phone
FROM customers
WHERE phone LIKE '(171)%';



-- 113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.

SELECT product_name, quantity_per_unit
FROM products
WHERE quantity_per_unit LIKE '%boxes%';



-- 114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)

SELECT company_name, phone
FROM customers
WHERE contact_title LIKE '%Manager%'
AND country IN ('France', 'Germany');



-- 115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;



-- 116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.

SELECT company_name, country, city
FROM customers
ORDER BY country, city;



-- 117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.

SELECT employee_id,title || ' - ' || ' ' || first_name || ' ' || last_name AS Coworker, birth_date, AGE(CURRENT_DATE, birth_date) AS age
FROM employees


-- 118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.

SELECT order_id, order_date, shipped_date
FROM orders
WHERE shipped_date - order_date > 35



-- 119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu ile)

SELECT category_name
FROM categories c
WHERE c.category_id = (SELECT p.category_id
                       FROM products p
                       ORDER BY p.unit_price DESC
                       LIMIT 1)



-- 120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)

-- Sub Query
SELECT product_name FROM products p
WHERE category_id IN 
	(SELECT DISTINCT category_id
	FROM categories
	WHERE category_name LIKE '%on%')


-- Simple Join Way
SELECT product_name FROM products p
JOIN categories subc ON subc.category_id = p.category_id
WHERE subc.category_name LIKE '%on%'

	

-- 121. Konbu adlı üründen kaç adet satılmıştır.

SELECT COUNT(*) FROM order_details od
JOIN products p ON p.product_id = od.product_id
WHERE p.product_name = 'Konbu'
	


-- 122. Japonyadan kaç farklı ürün tedarik edilmektedir.


-- ### Simple Way
SELECT COUNT(*) AS PCountsJapan FROM suppliers s
JOIN products p ON p.supplier_id = s.supplier_id
WHERE s.country = 'Japan'

	
-- ### Subquery
SELECT COUNT(pfj.*)
	FROM (SELECT s.supplier_id, s.country, p.product_name
	FROM suppliers s
	JOIN products p ON p.supplier_id = s.supplier_id
	WHERE s.country = 'Japan') AS pfj


-- ### WITH usage
WITH ProductsFromJapan AS (
	SELECT * FROM suppliers s
	JOIN products p ON p.supplier_id = s.supplier_id
	WHERE s.country = 'Japan'
)
SELECT COUNT(pfj.*) FROM ProductsFromJapan pfj



-- 123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?

SELECT MAX(freight), MIN(freight), AVG(freight) FROM orders o
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;



-- 124. Faks numarası olan tüm müşterileri listeleyiniz.

SELECT customer_id, company_name, fax FROM customers
WHERE fax IS NOT NULL



-- 125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz.

SELECT order_id, order_date FROM orders
WHERE order_date >= '1996-07-16' AND order_date <= '1996-07-30'
ORDER BY order_date



