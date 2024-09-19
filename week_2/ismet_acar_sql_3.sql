-- 1 - Verilen Customers ve Orders tablolarını kullanarak, Customers tablosundaki müşterileri ve onların verdikleri siparişleri birleştirerek listeleyin. Müşteri adı, sipariş ID'si ve sipariş tarihini gösterin.

SELECT c.CompanyName, c.ContactName, o.OrderID, o.OrderDate
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID



-- 2 - Verilen Suppliers ve Products tablolarını kullanarak tüm tedarikçileri ve onların sağladıkları ürünleri listeleyin. Eğer bir tedarikçinin ürünü yoksa, NULL olarak gösterilsin.

SELECT s.CompanyName, CONCAT(s.ContactTitle, ' - ' ,s.ContactName) as Contact_with_Title, p.ProductName
FROM Suppliers AS s
LEFT JOIN Products AS p ON s.SupplierID = p.SupplierID



-- 3 - Verilen Employees ve Orders tablolarını kullanarak tüm siparişleri ve bu siparişleri işleyen çalışanları listeleyin. Eğer bir sipariş bir çalışan tarafından işlenmediyse, çalışan bilgileri NULL olarak gösterilsin.

SELECT e.Title, CONCAT(e.TitleOfCourtesy, ' ', e.FirstName, ' ', e.LastName), o.OrderID
FROM Orders AS o
LEFT JOIN Employees AS e ON o.EmployeeID = e.EmployeeID



-- 4 - Verilen Customers ve Orders tablolarını kullanarak tüm müşterileri ve tüm siparişleri listeleyin. Sipariş vermeyen müşteriler ve müşterisi olmayan siparişler için NULL döndürün.

SELECT c.CompanyName, o.OrderID
FROM Customers AS c
full outer JOIN Orders AS o ON c.CustomerID = o.CustomerID



-- 5 - Verilen Products ve Categories tablolarını kullanarak tüm ürünler ve tüm kategoriler için olası tüm kombinasyonları listeleyin. Sonuç kümesindeki her satır bir ürün ve bir kategori kombinasyonunu göstermelidir.

SELECT c.CategoryName, p.ProductName FROM Products as p
CROSS JOIN Categories AS c
order by c.CategoryName



-- 6 - Verilen Orders, Customers, Employees tablolarını kullanarak bu tabloları birleştirin ve 2014 yılında verilen siparişleri listeleyin. Müşteri adı, sipariş ID'si, sipariş tarihi ve ilgili çalışan adı gösterilsin.

SELECT c.CompanyName, o.OrderID, o.OrderDate, CONCAT(e.TitleOfCourtesy, ' ', e.FirstName, ' ', e.LastName) AS Coworkers
FROM Orders AS o
JOIN Customers AS c ON o.CustomerID = c.CustomerID
LEFT JOIN Employees AS e ON o.EmployeeID = e.EmployeeID
WHERE strftime('%Y', o.OrderDate) = '2014'



-- 7 - Verilen Orders ve Customers tablolarını kullanarak müşterileri, verdikleri sipariş sayısına göre gruplandırın. Sadece 5’ten fazla sipariş veren müşterileri listeleyin.

SELECT c.CompanyName, COUNT(o.OrderID) AS TotalOrder
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(o.OrderID) > 5
order by TotalOrder



-- 8- Verilen OrderDetails ve Products tablolarını kullanarak her ürün için kaç adet satıldığını ve toplam satış miktarını listeleyin. Ürün adı, satılan toplam adet ve toplam kazancı (Quantity * UnitPrice) gösterin.

SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantity, 
       ROUND(SUM(od.Quantity * od.UnitPrice)) AS TotalRevenue
FROM 'Order Details' AS od
JOIN Products AS p ON od.ProductID = p.ProductID
GROUP BY p.ProductName


-- 9- Verilen Customers ve Orders tablolarını kullanarak, müşteri adı "B" harfiyle başlayan müşterilerin siparişlerini listeleyin.

SELECT c.CompanyName AS Companies_BeginsWithB, o.OrderID
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE c.CompanyName LIKE 'b%'



-- 10 - Verilen Products ve Categories tablolarını kullanarak tüm kategorileri listeleyin ve ürünleri olmayan kategorileri bulun. Ürün adı NULL olan satırları gösterin.

-- All Categories has product
SELECT c.CategoryName, p.ProductName
FROM Categories AS c
LEFT JOIN Products AS p ON c.CategoryID = p.CategoryID
WHERE p.ProductName ISNULL


-- 11 - Verilen Employees tablosunu kullanarak her çalışanın yöneticisiyle birlikte bir liste oluşturun.

SELECT CONCAT(e1.Title, ' - ', e1.TitleOfCourtesy, ' ', e1.FirstName, ' ', e1.LastName) AS EmployeeName,
CONCAT(e2.Title, ' - ', e2.TitleOfCourtesy, ' ', e2.FirstName, ' ', e2.LastName) AS SuperiorName
FROM Employees AS e1
JOIN Employees AS e2 ON e1.ReportsTo = e2.EmployeeID



-- 12 - Verilen Products tablosunu kullanarak her kategorideki en pahalı ürünleri ve bu ürünlerin farklı fiyatlara sahip olup olmadığını sorgulayın.

SELECT c.CategoryName, p.productname, MAX(p.UnitPrice) AS Max_UnitPrice
FROM Products AS p
JOIN Categories AS c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY Max_UnitPrice DESC



-- 13 - Verilen Orders ve OrderDetails tablolarını kullanarak bu tabloları birleştirin ve her siparişin detaylarını sipariş ID'sine göre artan sırada listeleyin.

SELECT o.OrderID, od.*
FROM Orders AS o
JOIN 'Order Details' AS od ON o.OrderID = od.OrderID
ORDER BY o.OrderID



-- 14 - Verilen Employees ve Orders tablolarını kullanarak her çalışanın kaç tane sipariş işlediğini listeleyin. Sipariş işlemeyen çalışanlar da gösterilsin.

SELECT CONCAT(e.Title, ' - ', e.TitleOfCourtesy, ' ', e.FirstName, ' ', e.LastName) AS EmployeeName, COUNT(o.OrderID) AS OrderCount
FROM Employees AS e
LEFT JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
GROUP BY EmployeeName;



-- 15 - Verilen Products tablosunu kullanarak bir kategorideki ürünleri kendi arasında fiyatlarına göre karşılaştırın ve fiyatı düşük olan ürünleri listeleyin.

SELECT c.CategoryName, p.ProductName, p.UnitPrice FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.UnitPrice = (
    SELECT MIN(UnitPrice) FROM Products AS subp
 	WHERE subp.CategoryID = p.CategoryID)
    


-- 16 - Verilen Products ve Suppliers tablolarını kullanarak tedarikçiden alınan en pahalı ürünleri listeleyin.

-- Simple Way
SELECT s.CompanyName, CONCAT(p.ProductID, ' - ' ,p.ProductName), MAX(p.UnitPrice) AS ProductID_Name
FROM Products as p
JOIN Suppliers AS s ON s.SupplierID = p.SupplierID


-- With SubQuery
SELECT p.ProductName, s.CompanyName, p.UnitPrice
FROM Products AS p
JOIN Suppliers as s ON p.SupplierID = s.SupplierID
WHERE p.UnitPrice = (SELECT MAX(UnitPrice) FROM Products WHERE SupplierID = Products.SupplierID)



-- 17 - Verilen Employees ve Orders tablolarını kullanarak her çalışanın işlediği en son siparişi bulun.

SELECT CONCAT(e.FirstName, ' ', e.LastName) as 'Our Employees' ,MAX(o.OrderDate) FROM Orders AS o
JOIN Employees AS e ON e.EmployeeID = o.EmployeeID
GROUP BY e.FirstName



-- 18 - Verilen Products tablosunu kullanarak ürünleri fiyatlarına göre gruplandırın ve fiyatı 20 birimden fazla olan ürünlerin sayısını listeleyin.

SELECT COUNT(*) AS Above20 FROM Products
WHERE unitprice > 20



-- 19 - Verilen Orders ve Customers tablolarını kullanarak 2017 ile 2021 yılları arasında verilen siparişleri müşteri adıyla birlikte listeleyin.

SELECT c.CompanyName, o.OrderID, o.OrderDate FROM Orders AS o
JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '2017-01-01' AND '2020-12-31'


-- 20- Verilen Customers ve Orders tablolarını kullanarak hiç sipariş vermeyen müşterileri listeleyin.

-- *** It returns no result for Northwind DB

SELECT c.CompanyName, c.ContactName FROM Customers AS c
LEFT JOIN orders AS o ON c.CustomerID = o.CustomerID
WHERE o.OrderID ISNULL