USE [DIIG]
GO

/****** Object:  View [Contract].[CSIScontractIDtoSupplierID]    Script Date: 3/26/2017 6:17:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [Contract].[CSIScontractIDtoSupplierID] as 
SELECT 	CSIScontractID
,[Supplier_ID]
      ,[Supplier]
      ,[SuppAddress]
      ,[SuppCity]
      ,[SuppProvince]
      ,[SuppPostCode]
      ,[SuppCountry]
	  ,v.ParentID
FROM (SELECT CSIScontractID
	,iif(min([Supplier_ID])=max([Supplier_ID]),max([Supplier_ID]),NULL) as [Supplier_ID]
  FROM [DIIG].[Location].[CCCContractIDtoVendorName]
  WHERE CSIScontractID is not null
  group by CSIScontractID) c
INNER JOIN Vendor.CanadaSupplierID v 
on c.Supplier_ID=v.CanadaSupplierID

GO


