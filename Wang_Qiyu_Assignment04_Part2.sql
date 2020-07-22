Use AdventureWorks2014;

SELECT p.ProductID, p.Name, sd.OrderQty, sd.UnitPrice
FROM Production.Product AS p, Sales.SalesOrderDetail AS sd
WHERE p.ProductID = sd.ProductID
ORDER BY p.ProductID;
--There are duplicate rows in the result. Because not all info are selected and there are hidden info outside the result table.
--The uniqueness of each row can be identified by adding a extra column such as OrderID.
--Other methods avaliable could be adding GROUP BY or SELECT DISTINCT into the statement.
--The procedures should be chosen by what the key info is to be shown in the result table.

SELECT Production.Product.ProductID, Production.Product.Name, Sales.SalesOrderDetail.OrderQty, Sales.SalesOrderDetail.UnitPrice
FROM Production.Product
INNER JOIN Sales.SalesOrderDetail 
ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
ORDER BY Production.Product.ProductID;

SELECT p.ProductID, ROUND(SUM(sd.OrderQty*sd.UnitPrice),2) AS Revenue
FROM Production.Product AS p, Sales.SalesOrderDetail AS sd
WHERE p.ProductID = sd.ProductID
GROUP BY p.ProductID
ORDER BY p.ProductID;

SELECT prod.Color,prod.Name, ROUND(purch.OrderQty*purch.UnitPrice,2) AS Revenue, rev.Rating
FROM Purchasing.PurchaseOrderDetail AS purch, Production.Product AS prod, Production.ProductReview AS rev
WHERE prod.ProductID=rev.ProductID AND prod.ProductID = purch.ProductID
ORDER BY rev.Rating DESC, Revenue ASC; 





