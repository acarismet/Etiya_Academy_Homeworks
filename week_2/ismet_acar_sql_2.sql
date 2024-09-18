-- ## 1) Her kategorideki (CategoryID) ürün sayısını gösteren bir sorgu yazın.

SELECT categoryID, COUNT(*) FROM Products
GROUP BY categoryID



-- ## 2) Birim fiyatı en yüksek 5 ürünü listeleyin.

SELECT * FROM Products
ORDER BY unitprice DESC
LIMIT 5



-- ## 3) Her tedarikçinin sattığı ürünlerin ortalama fiyatını listeleyin.

SELECT supplierid, AVG(unitprice) FROM Products
GROUP by supplierid



-- ## 4) "Products" tablosunda birim fiyatı 100'den büyük olan ürünlerin kategorilerini ve bu kategorilerdeki ortalama fiyatı listeleyin.

SELECT categoryID, AVG(unitprice) AS AvarageByCategory FROM Products
WHERE unitprice > 100
GROUP BY categoryID



-- ## 5) "OrderDetails" tablosunda birim fiyat ve miktar çarpımıyla toplam satış değeri 1000'den fazla olan siparişleri listeleyin.

SELECT orderID, (unitPrice * quantity) AS TotalSale
FROM 'Order Details'
WHERE TotalSale > 1000;



-- 6) En son sevk edilen 10 siparişi listeleyin.

SELECT * FROM Orders
ORDER BY shippeddate DESC
LIMIT 10



-- ## 7) "Products" tablosundaki ürünlerin ortalama fiyatını hesaplayın.

SELECT AVG(UnitPrice) AS AvgPrice
FROM Products



-- ## 8) "Products" tablosunda fiyatı 50’den büyük olan ürünlerin toplam stok miktarını hesaplayın.

SELECT SUM(unitsInStock) AS TotalStock
FROM Products
WHERE unitPrice > 50



-- ## 9) "Orders" tablosundaki en eski sipariş tarihini bulun.

SELECT orderID, MIN(OrderDate) AS OldestOrderDate
FROM Orders



-- ## 10) "Employees" tablosundaki çalışanların kaç yıl önce işe başladıklarını gösteren bir sorgu yazın.

-- SQLite Version
SELECT EmployeeID, (strftime('%Y', 'now') - strftime('%Y', HireDate)) AS YearsWorked
FROM Employees


-- Classic Version
SELECT EmployeeID, YEAR(CURDATE()) - YEAR(HireDate) AS YearsWorked
FROM Employees



-- ## 11) "OrderDetails" tablosundaki her bir sipariş için, birim fiyatın toplamını yuvarlayarak (ROUND) hesaplayın.

SELECT orderID, ROUND(SUM(unitPrice), 2) AS TotalUnitPrice
FROM 'Order Details'
GROUP BY orderID



-- ## 12) "Products" tablosunda stoktaki (UnitsInStock) ürün sayısını gösteren bir COUNT sorgusu yazın.

SELECT COUNT(*) AS StockedProducts
FROM Products
WHERE unitsInStock > 0



-- ## 13) "Products" tablosundaki en düşük ve en yüksek fiyatları hesaplayın.

SELECT MIN(unitPrice) AS MinPrice, MAX(unitPrice) AS MaxPrice
FROM Products



-- ## 14) "Orders" tablosunda her yıl kaç sipariş alındığını listeleyin (YEAR() fonksiyonunu kullanarak).

-- SQLite Version
SELECT STRFTIME('%Y', OrderDate) AS OrderYear, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderYear


-- Classic Version
SELECT YEAR(orderDate) AS OrderYear, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderYear




-- ## 15) "Employees" tablosundaki çalışanların tam adını (FirstName + LastName) birleştirerek gösterin.

SELECT CONCAT(firstName, ' ', lastName) AS FullName
FROM Employees



-- ## 16) "Customers" tablosundaki şehir adlarının uzunluğunu (LENGTH) hesaplayın.

SELECT city, LENGTH(City) AS CityNameLength
FROM Customers
GROUP BY city


-- ## 17) "Products" tablosundaki her ürünün fiyatını iki ondalık basamağa yuvarlayarak gösterin.

SELECT productName, ROUND(unitPrice, 2) AS RoundedPrice
FROM Products



-- ## 18) "Orders" tablosundaki tüm siparişlerin toplam sayısını bulun.

SELECT COUNT(*) AS AllOrdersCount FROM Orders



-- ## 19) "Products" tablosunda her kategorideki (CategoryID) ürünlerin ortalama fiyatını (AVG) hesaplayın.

SELECT categoryID, AVG(unitprice) AS AvarageByCategory FROM Products
GROUP BY categoryID



-- ## 20) "Orders" tablosunda sevk tarihi (ShippedDate) boş olan siparişlerin yüzdesini (COUNT ve toplam sipariş sayısını kullanarak) hesaplayın.

SELECT ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders)), 2) AS NoshippedDateRatio
FROM Orders
WHERE shippedDate IS NULL;



-- ## 21) "Products" tablosundaki en pahalı ürünün fiyatını bulun ve bir fonksiyon kullanarak fiyatı 10% artırın.

SELECT productName, unitPrice, unitPrice * 1.1 AS TenPercentMore
FROM Products
ORDER BY unitPrice DESC
LIMIT 1



-- ## 22) "Products" tablosundaki ürün adlarının ilk 3 karakterini gösterin (SUBSTRING).

SELECT productName, SUBSTRING(productName, 1, 3)
FROM Products



-- ## 23) "Orders" tablosunda verilen siparişlerin yıl ve ay bazında kaç sipariş alındığını hesaplayın (YEAR ve MONTH fonksiyonları).

-- SQLite Version
SELECT strftime('%Y', OrderDate) AS OrderYear, strftime('%m', OrderDate) AS OrderMonth, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderYear, OrderMonth



-- ## 24) "OrderDetails" tablosunda toplam sipariş değerini (UnitPrice * Quantity) hesaplayıp, bu değeri iki ondalık basamağa yuvarlayarak gösterin.

SELECT orderID, ROUND(SUM(unitPrice * quantity), 2) AS TotalOrderValue
FROM 'Order Details'
GROUP BY orderID



-- ## 25) "Products" tablosunda stokta olmayan (UnitsInStock = 0) ürünlerin fiyatlarını toplam fiyat olarak hesaplayın.

SELECT SUM(unitPrice) AS TotalPrice
FROM Products
WHERE unitsInStock = 0
