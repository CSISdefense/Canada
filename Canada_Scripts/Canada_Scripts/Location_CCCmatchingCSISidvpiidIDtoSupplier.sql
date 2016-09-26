USE [DIIG]
GO

/****** Object:  View [Location].[CCCmatchingCSISidvpiidIDtoSupplier]    Script Date: 9/22/2016 8:57:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

















ALTER VIEW [Location].[CCCmatchingCSISidvpiidIDtoSupplier]
AS


select CSISidvpiidID
,iif(MaxOfSupplier=MinOfSupplier,MinOfSupplier,NULL) as Supplier
,iif(MaxOfSupplier_ID=MinOfSupplier_ID,MinOfSupplier_ID,NULL) as Supplier_ID
from (select max(Supplier) as MaxOfSupplier
			,min(Supplier) as MinOfSupplier
			,max(Supplier_ID) as MaxOfSupplier_ID
			,min(Supplier_ID) as MinOfSupplier_ID
			--,ContractNumber
			,CSISidvpiidID
		from location.CCCContractIDtoVendorName c
		where CSISidvpiidID is not null
		group by --Supplier
			--,Supplier_ID
			CSISidvpiidID) cns


























GO


