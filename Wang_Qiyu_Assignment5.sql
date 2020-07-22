USE AdventureWorks2014;

-- Problem 1 PART A
DROP VIEW IF EXISTS ViewMaster;
GO
CREATE VIEW ViewMaster
AS
(
	SELECT DISTINCT terr.TerritoryID, ccyRate.FromCurrencyCode + '/' +ccyRate.ToCurrencyCode AS ccy_pair
	FROM Sales.SalesTerritory terr, Sales.SalesOrderHeader ord, Sales.CurrencyRate ccyRate
	WHERE terr.TerritoryID = ord.TerritoryID AND ccyRate.CurrencyRateID=ord.CurrencyRateID
);

GO

-- PART B
DROP PROCEDURE IF EXISTS sp_ccy_state_prov;
GO
CREATE PROCEDURE sp_ccy_state_prov
AS
BEGIN
	SELECT v.TerritoryID, v.ccy_pair, sp.StateProvinceCode
	FROM ViewMaster v, Person.StateProvince sp
	WHERE sp.TerritoryID = v.TerritoryID
END;

EXECUTE sp_ccy_state_prov;

/*
	PART C
	1) No, because ORDER BY is only allowed outside of VIEW.
	2) 3 columns were returned, and 340 rows were returned.
*/

/*
	PART D
	Yes, they were unique. Because we returned only unique row in MasterView, which elimates the other column information besides TerrID and ccu_pairs.
	As each row in the both tables (MasterView and Person.StateProvince) are unique, the matched rows are unique.
	For the three column information we care about, we got unique rows for partB.
*/

-- Problem 2
DROP PROCEDURE IF EXISTS sp_terr_dates_ccy;
GO
CREATE PROCEDURE sp_terr_dates_ccy(@n INT)
AS
BEGIN
	SELECT TOP(@n) h.TerritoryID, h.StartDate, h.ModifiedDate, v.ccy_pair
	FROM Sales.SalesTerritoryHistory h
	LEFT OUTER JOIN ViewMaster v
	ON h.TerritoryID = v.TerritoryID
END;

EXECUTE sp_terr_dates_ccy 5;

/*
	6	2011-05-31 00:00:00.000	2011-05-24 00:00:00.000	USD/CAD
	6	2011-05-31 00:00:00.000	2012-05-22 00:00:00.000	USD/CAD
	6	2012-05-30 00:00:00.000	2012-05-23 00:00:00.000	USD/CAD
	7	2012-05-30 00:00:00.000	2012-05-23 00:00:00.000	USD/FRF
	9	2013-05-30 00:00:00.000	2013-05-23 00:00:00.000	USD/AUD
*/

-- Problem 3
DROP FUNCTION IF EXISTS count_ccy;
GO
CREATE FUNCTION count_ccy(@c char(3))
RETURNS INT
AS
BEGIN
	DECLARE @NumRows int

	SELECT @NumRows = count(*)
	FROM ViewMaster v, Sales.SalesTerritoryHistory h
	WHERE v.TerritoryID = h.TerritoryID AND v.ccy_pair LIKE '%'+ @c

	RETURN @NumRows
END;

SELECT dbo.count_ccy('GBP ');

/*
	b)
	CAD: 8 rows
	EUR: 2 rows
	GBP: 2 rows
*/


-- Problem 4
USE Credit;

DROP FUNCTION IF EXISTS cat_name;
GO
CREATE FUNCTION cat_name(@ln varchar(40), @fn varchar(40))
RETURNS varchar(80)
AS
BEGIN
	RETURN @ln + ',' + @fn
END;

SELECT TOP(20) dbo.cat_name(m.lastname, m.firstname) AS FullName , r.region_name
FROM dbo.region r, dbo.member m
WHERE r.region_no = m.region_no AND m.lastname LIKE 'X%'
ORDER BY Fullname;

/* Yes, the rows are unique, because the rows in each table are unique, and for each row they join upon a unique member information row. 
By examing the result with SELECT DISTINCT, the table return same number of rows. */

SELECT DISTINCT *
FROM dbo.member;