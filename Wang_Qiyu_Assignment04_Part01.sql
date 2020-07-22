USE AdventureWorks2014;

SELECT TOP(20) *
FROM Person.EmailAddress;

SELECT ProductID, StockedQty + ScrappedQty AS TotalQty
FROM Production.WorkOrder
WHERE ScrapReasonID IS NOT NULL;
-- 729 rows were returned.

SELECT FirstName + ' ' + LastName AS FullName 
FROM Person.Person
WHERE FirstName LIKE '[AJKL]%' AND LastName LIKE '[^ASTW]%'
ORDER BY LastName;
-- 5051 rows were returned.

SELECT LastName
FROM Person.Person
WHERE LastName LIKE '_[GV]%'
ORDER BY LastName;
-- 93 rows were returned.

SELECT DISTINCT LastName + ',' + FirstName AS FullName
FROM Person.Person
WHERE FirstName LIKE '_[AOT]%' AND LastName IN ('Anderson', 'Hammond', 'Wilson')
ORDER BY FullName;
-- 69 rows were returned.

SELECT CONVERT(varchar(30),TransactionDate,102) AS TranDate, ProductID, ReferenceOrderID, DATEDIFF(mm,TransactionDate,'2019-11-01') AS Months
FROM Production.TransactionHistory
WHERE (ProductID IN (860,950)) AND (ActualCost > 0) AND DATEDIFF(m,TransactionDate,'2019-11-01') > 70
ORDER BY TransactionDate;
-- 247 rows were returned.

SELECT ProductID, ReferenceOrderID, '$'+ Ltrim(str(Quantity*ActualCost)) AS Sales_Amt
FROM Production.TransactionHistory
WHERE ((ReferenceOrderID=53452)AND(Quantity>1))OR((ReferenceOrderID=72482)AND(Quantity<5));
--35 rows were returned.

SELECT ROUND(MAX(Quantity*ActualCost),2) AS MaximumSale, ROUND(AVG(Quantity*ActualCost),2) AS AverageSale
FROM Production.TransactionHistory;
-- MaxSales:45558.98, AvgSale:935.69.

SELECT COUNT(*) AS NumRows, AVG(Rate) AS MeanRate
FROM HumanResources.EmployeePayHistory
WHERE DATEDIFF(yy,RateChangeDate,ModifiedDate) = 4 AND Rate>10.6;
--NumRows:33,MeanRate:15.952.

SELECT COUNT(*) AS TotalRowCount
FROM Person.StateProvince
GROUP BY CountryRegionCode
ORDER BY CountryRegionCode;