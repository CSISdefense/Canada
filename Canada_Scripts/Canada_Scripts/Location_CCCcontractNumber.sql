USE [DIIG]
GO

/****** Object:  View [Location].[CCCcontractNumber]    Script Date: 9/22/2016 8:57:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


















ALTER VIEW [Location].[CCCcontractNumber]
AS


select CSIScontractID
,CSISidvPIIDid
,ContractNumber
			--,IDVpiid
			--,PIID
,iif(MaxOfSupplier=MinOfSupplier,MinOfSupplier,NULL) as Supplier
,iif(MaxOfSupplier_ID=MinOfSupplier_ID,MinOfSupplier_ID,NULL) as Supplier_ID
,ExtractedContractNumber
,Suffix
from (select max(Supplier) as MaxOfSupplier
			,min(Supplier) as MinOfSupplier
			,max(Supplier_ID) as MaxOfSupplier_ID
			,min(Supplier_ID) as MinOfSupplier_ID
			,ContractNumber
			--,IDVpiid
			--,PIID
			,c.CSIScontractID
			,c.CSISidvPIIDid
			,e.ExtractedContractNumber
			,e.Suffix
		from location.CCCContractIDtoVendorName c
		--where CSIScontractID is not null
		inner join location.CCCcontractExtraction e
		on c.ContractNumber=e.OriginalContractNumber
		group by --Supplier
			--,Supplier_ID
			c.CSIScontractID
			,c.CSISidvPIIDid
			,c.ContractNumber
			
			,e.ExtractedContractNumber
			,e.Suffix
			--,IDVpiid
			--,PIID
			) cns



























GO


