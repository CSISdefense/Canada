USE [DIIG]
GO

/****** Object:  View [Location].[CCCcontractMatching]    Script Date: 9/22/2016 8:56:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [Location].[CCCcontractMatching]
AS
select CSISidvpiidID
			,Supplier
			,Supplier_ID
			,ContractNumber
		from location.CCCContractIDtoVendorName c
				where csisidvpiidid is not null and 
				csisidvpiidid <> 23356 and
				CSIScontractID is null
	
		group by CSISidvpiidID
			,Supplier
			,Supplier_ID
			,ContractNumber
			

























GO


