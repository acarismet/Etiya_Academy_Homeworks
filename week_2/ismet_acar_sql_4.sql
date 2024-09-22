--TR-- Tümünü PostgreSQL'de yaptım o yüzden diğer SQL türlerinde çalıştırmadan önce kontrol ediniz.
--EN-- I did it all in PostgreSQL, so check it before running it in other SQL types.




-- 1. En Pahalı Ürünü Getirin

-- Based on Products Table
-- ** Version 1 ** 
SELECT product_id, product_name, unit_price FROM products
WHERE unit_price = (SELECT MAX(unit_price) FROM products)

-- ** Version 2 **
SELECT product_id, product_name, unit_price FROM products
ORDER BY unit_price DESC
LIMIT 1

-- Based on Order Table -- En pahalıya satılan ürün
SELECT od.product_id, p.product_name, od.unit_price FROM order_details AS od
JOIN products AS p ON p.product_id = od.product_id
ORDER BY od.unit_price DESC
LIMIT 1



-- 2. En Son Verilen Siparişi Bulun

SELECT * FROM orders
ORDER BY order_date DESC
LIMIT 1



-- 4. Belirli Kategorilerdeki Ürünleri Listeleyin

SELECT product_id, product_name, unit_price FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY unit_price



-- 5. En Yüksek Fiyatlı Ürünlere Sahip Kategorileri Listeleyin

WITH max_price_products AS (
    SELECT product_id, product_name, unit_price, category_id
    FROM products
    WHERE unit_price = (SELECT MAX(unit_price) FROM products)
)
SELECT category_id, product_id, product_name, unit_price
FROM max_price_products
ORDER BY category_id;



-- 6. Bir Ülkedeki Müşterilerin Verdiği Siparişleri Listeleyin

--TR-- Ülke olarak Almanya'yı seçtim.
--EN-- I selected Germany as country.

SELECT c.customer_id, c.company_name, CONCAT(c.contact_title, ' ', c.contact_name) AS ContactInfo FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.ship_country = 'Germany'
GROUP BY c.customer_id


	
-- 7. Her Kategori İçin Ortalama Fiyatın Üzerinde Olan Ürünleri Listeleyin

SELECT c.category_name, p.product_name, p.unit_price FROM products AS p
JOIN categories AS c ON c.category_id = p.category_id
WHERE p.unit_price > (SELECT AVG(unit_price) FROM products
GROUP BY p.category_id)
ORDER BY category_name
	


-- 8. Her Müşterinin En Son Verdiği Siparişi Listeleyin

SELECT 
    c.company_name, 
    CONCAT_WS(' - ', c.contact_title, c.contact_name) AS contact_info,
    o.order_date AS latest_order, o.order_id 
FROM customers AS c
JOIN orders AS o 
    ON c.customer_id = o.customer_id
WHERE o.order_date = (
    SELECT MAX(order_date)
    FROM orders
    WHERE customer_id = c.customer_id
)



-- 9. En çok sipariş alan çalışanın adı soyadı

SELECT e.first_name, e.last_name
FROM employees e
JOIN (
    SELECT employee_id FROM orders
    GROUP BY employee_id
    ORDER BY COUNT(employee_id) DESC
    LIMIT 1
) o ON e.employee_id = o.employee_id

-- Alternatif - En çok sipariş alan çalışanın kazandırdığı gelir

SELECT CONCAT(e.title, ' - ', e.title_of_courtesy , ' ', e.first_name, ' ' , e.last_name) AS OurBest, o.total_revenue
FROM employees e
JOIN (
    SELECT o.employee_id, 
           COUNT(o.order_id) AS total_orders,
           ROUND(SUM((od.unit_price * od.quantity) - ((od.unit_price * od.quantity) * od.discount))) AS total_revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.employee_id
    ORDER BY COUNT(o.order_id) DESC
    LIMIT 1
) o ON e.employee_id = o.employee_id;



-- 10. En Az 10 Ürün Satın Alınan Siparişleri Listeleyin

SELECT order_id, SUM(quantity) FROM order_details
GROUP BY order_id
HAVING SUM(quantity) >= 10



-- 11. Her Kategoride En Pahalı Olan Ürünlerin Ortalama Fiyatını Bulun

WITH AverageOfMax AS(
	SELECT  MAX(unit_price) AS MaxPrices FROM products
GROUP BY category_id
)
SELECT AVG(MaxPrices) FROM AverageOfMax

-- Alternative

SELECT AVG(max_price) AS avg_max_price
FROM (
    SELECT MAX(unit_price) AS max_price
    FROM products
    GROUP BY category_id
) AS AverageOfMax



-- 12. Müşterilerin Verdiği Toplam Sipariş Sayısına Göre Sıralama Yapın

SELECT o.customer_id, c.company_name, CONCAT_WS(' - ', c.contact_title, c.contact_name) AS ContactInfo, COUNT(o.order_id) AS TotalOrderCount
	FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.company_name, c.contact_title, c.contact_name
ORDER BY TotalOrderCount DESC



-- 13. En Fazla Sipariş Vermiş 5 Müşteriyi ve Son Sipariş Tarihlerini Listeleyi

SELECT o.customer_id, c.company_name, CONCAT_WS(' - ', c.contact_title, c.contact_name) AS ContactInfo, MAX(o.order_date), COUNT(o.order_id) AS TotalOrderCount
	FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.company_name, c.contact_title, c.contact_name
ORDER BY TotalOrderCount DESC
LIMIT 5
	


-- 14. Toplam Ürün Sayısı 15'ten Fazla Olan Kategorileri Listeleyin

-- But there is no category has even 15 products
SELECT category_id, COUNT(*) FROM products
GROUP BY category_id
HAVING COUNT(*) > 15

-- >>> All categories has less than 15 products

SELECT category_id, COUNT(*) FROM products
GROUP BY category_id
HAVING COUNT(*) < 15



-- 15. En Fazla 5 Farklı Ürün Sipariş Eden Müşterileri Listeleyin

SELECT o.customer_id, c.company_name, COUNT(DISTINCT od.product_id) AS uniqueProducts
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.company_name
HAVING COUNT(DISTINCT od.product_id) <= 5
ORDER BY uniqueProducts DESC



-- 16. 20'den Fazla Ürün Sağlayan Tedarikçileri Listeleyin

-- There is no supplier which provides more than 6
	
SELECT s.supplier_id, s.company_name, COUNT(p.product_id) AS product_count
FROM suppliers AS s
JOIN products AS p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.company_name
HAVING COUNT(p.product_id) > 20
ORDER BY product_count DESC


-- 17. Her Müşteri İçin En Pahalı Ürünü Bulun

WITH MaxPricePerCustomer AS (
    SELECT o.customer_id, MAX(od.unit_price) AS max_price
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT c.customer_id, c.company_name, od.product_id, od.unit_price
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN order_details AS od ON o.order_id = od.order_id
JOIN MaxPricePerCustomer AS mpc ON mpc.customer_id = c.customer_id AND od.unit_price = mpc.max_price
ORDER BY c.customer_id



-- 18. 10.000'den Fazla Sipariş Değeri Olan Çalışanları Listeleyin

WITH EmployeeOrderTotals AS (
    SELECT 
        o.employee_id,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))) AS total_order_value
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.employee_id
)
SELECT 
    e.employee_id,
    CONCAT(e.title, ' - ', e.title_of_courtesy, ' ', e.first_name, ' ', e.last_name) AS GreatCoworker,
    eot.total_order_value
FROM EmployeeOrderTotals AS eot
JOIN employees AS e ON e.employee_id = eot.employee_id
WHERE eot.total_order_value > 10000
ORDER BY eot.total_order_value DESC



-- 19. Kategorisine Göre En Çok Sipariş Edilen Ürünü Bulun

WITH CountedByProduct AS (
    SELECT product_id, COUNT(*) AS counts
    FROM order_details
    GROUP BY product_id
),
MaxCountByCategory AS (
    SELECT p.category_id, MAX(cbp.counts) AS max_count
    FROM CountedByProduct AS cbp
    JOIN products AS p ON p.product_id = cbp.product_id
    GROUP BY p.category_id
)
SELECT mcc.category_id, p.product_id, p.product_name, mcc.max_count
FROM MaxCountByCategory AS mcc
JOIN products AS p ON p.category_id = mcc.category_id
JOIN CountedByProduct AS cbp ON cbp.product_id = p.product_id AND cbp.counts = mcc.max_count
ORDER BY mcc.category_id



-- 20. Müşterilerin En Son Sipariş Verdiği Ürün ve Tarihlerini Listeleyin

SELECT 
    c.company_name, 
    p.product_name,
    o.order_date AS latest_order, o.order_id 
FROM customers AS c
JOIN orders AS o 
    ON c.customer_id = o.customer_id
JOIN order_details AS od
	ON od.order_id = o.order_id
JOIN products AS p
	ON p.product_id = od.product_id
WHERE o.order_date = (
    SELECT MAX(order_date)
    FROM orders
    WHERE customer_id = c.customer_id
)
ORDER BY company_name

-- Alternative

WITH LatestOrders AS (
    SELECT customer_id, MAX(order_date) AS latest_order
    FROM orders
    GROUP BY customer_id
)
SELECT 
    c.company_name, 
    p.product_name,
    o.order_date, 
    o.order_id 
FROM customers AS c
JOIN orders AS o 
    ON c.customer_id = o.customer_id
JOIN LatestOrders lo 
    ON o.customer_id = lo.customer_id AND o.order_date = lo.latest_order
JOIN order_details AS od
    ON od.order_id = o.order_id
JOIN products AS p
    ON p.product_id = od.product_id
ORDER BY c.company_name



-- 21. Her Çalışanın Teslim Ettiği En Pahalı Siparişi ve Tarihini Listeleyin

WITH EmployeeMaxOrder AS (
    SELECT 
        o.employee_id,
        o.order_id,
        o.shipped_date,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS order_value
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.employee_id, o.order_id, o.shipped_date
),
MaxOrderPerEmployee AS (
    SELECT 
        employee_id,
        MAX(order_value) AS max_order_value
    FROM EmployeeMaxOrder
    GROUP BY employee_id
)
SELECT 
    e.employee_id,
    CONCAT(e.title, ' - ', e.title_of_courtesy, ' ', e.first_name, ' ', e.last_name) AS OurBest,
    emo.order_id,
    emo.shipped_date,
    emo.order_value AS max_order_value
FROM employees AS e
JOIN EmployeeMaxOrder AS emo ON e.employee_id = emo.employee_id
JOIN MaxOrderPerEmployee AS moe ON emo.employee_id = moe.employee_id AND emo.order_value = moe.max_order_value
ORDER BY emo.order_value DESC



-- 22. En Fazla Sipariş Verilen Ürünü ve Bilgilerini Listeleyin

SELECT p.* ,COUNT(*) FROM order_details AS od
JOIN products AS p ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY COUNT(*) DESC
LIMIT 1

