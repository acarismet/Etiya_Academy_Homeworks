-- 1) Tedarikçi ID'si 1 ile 5 arasındaki ürünler**:
-- Tedarikçi ID'si 1, 2, 3, 4 veya 5 olan ürünleri listeleyin.

SELECT * FROM products
WHERE supplierID IN (1,2,3,4,5)
ORDER BY productName

-- Alternative
SELECT * FROM products
WHERE supplierID BETWEEN 1 AND 5;



-- 2) Tedarikçi ID'si 1, 2, 4 veya 5 olan ürünler**:
-- Tedarikçi ID'si 1, 2, 4 veya 5 olan ürünleri listeleyin.

SELECT * FROM products
WHERE supplierID IN (1,2,4,5)
ORDER BY productName




-- 3) Ürün adı 'Chang' veya 'Aniseed Syrup' olan ürünler**:
-- Ürün adı 'Chang' veya 'Aniseed Syrup' olan ürünleri listeleyin.

SELECT * FROM products
WHERE productName = 'Chang' OR productName = 'Aniseed Syrup'




--4) Tedarikçi ID'si 3 olan veya birim fiyatı 10'dan büyük ürünler**:
--Tedarikçi ID'si 3 olan veya birim fiyatı 10'dan büyük olan ürünleri listeleyin.

--AND

SELECT * FROM products
WHERE supplierID = 3 and unitPrice > 10
ORDER BY unitPrice DESC

--OR

SELECT * FROM products
WHERE supplierID = 3 or unitPrice > 10
ORDER BY unitPrice DESC




-- 5) Ürün adı ve birim fiyatı ile birlikte getirme**:
-- Ürün adı ve birim fiyatını içeren listeyi getirin.

SELECT productName ||' ' || unitPrice || '--> $' FROM products
order by productName




-- 6) Büyük harfe dönüştürerek 'c' harfi içeren ürünler**:
-- Ürün adlarını büyük harfe dönüştürdükten sonra 'c' harfi içeren ürünleri listeleyin. (örneğin: 'Chai', 'Chocolate', vs.)

--Include C--

SELECT UPPER(productName) from products
WHERE productName LIKE '%c%'

--Begins with C--

SELECT UPPER(productName) from products
WHERE productName LIKE 'c%'




-- 7) 'n' ile başlayan ve tek n karakterli bir harf içeren ürünler**:
-- Ürün adı 'n' harfi ile başlayan ve içerisinde tek karakterli bir harf içeren ürünleri listeleyin. (örneğin: 'Naan', 'Nectar', vs.)

-- there is no product name that starts with n and contains a single letter n --

SELECT * FROM products
WHERE productName LIKE 'n%' AND productName NOT LIKE '%n%n%'




-- 8) Stok miktarı 50'den fazla olan ürünler**:
-- Stok miktarı 50'den fazla olan ürünleri listeleyin.

SELECT * FROM products
WHERE unitsInStock > 50
order by unitsInStock




-- 9) Ürünlerin en yüksek ve en düşük birim fiyatları**:
-- En yüksek ve en düşük birim fiyatına sahip ürünleri listeleyin.

SELECT * FROM products
WHERE unitPrice = (SELECT MAX(unitPrice) FROM products);

SELECT * FROM products
WHERE unitPrice = (SELECT MIN(unitPrice) FROM products);



-- 10) Ürün adında 'Spice' kelimesi geçen ürünler**:
-- Ürün adında 'Spice' kelimesi geçen ürünleri listeleyin.

SELECT * FROM products
WHERE productName LIKE '%Spice%'
