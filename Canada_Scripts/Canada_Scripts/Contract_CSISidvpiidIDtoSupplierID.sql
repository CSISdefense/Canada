USE [DIIG]
GO

/****** Object:  View [Contract].[CSISidvpiidIDtoSupplierID]    Script Date: 3/26/2017 6:17:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [Contract].[CSISidvpiidIDtoSupplierID] as 
SELECT 	[CSISidvpiidID]
,[Supplier_ID]
      ,[Supplier]
      ,[SuppAddress]
      ,[SuppCity]
      ,[SuppProvince]
      ,[SuppPostCode]
      ,[SuppCountry]
	  ,v.ParentID
FROM (SELECT [CSISidvpiidID]
	,iif(min([Supplier_ID])=max([Supplier_ID]),max([Supplier_ID]),NULL) as [Supplier_ID]
  FROM [DIIG].[Location].[CCCContractIDtoVendorName]
  WHERE [CSISidvpiidID] is not null
  group by [CSISidvpiidID]) c
INNER JOIN Vendor.CanadaSupplierID v 
on c.Supplier_ID=v.CanadaSupplierID
GO


