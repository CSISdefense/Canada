USE [DIIG]
GO

/****** Object:  View [Location].[CCCwo_refExtraction]    Script Date: 9/22/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [Location].[CCCwo_refExtraction]
AS
SELECT  
--TOP 1000 [Supplier_ID]
--      ,[Supplier]
--      ,[SuppAddress]
--      ,[SuppCity]
--      ,[SuppProvince]
--      ,[SuppPostCode]
--      ,[SuppCountry]
--      ,[Project]
--      ,[ProjectDescription]

  Wo_Extref as OriginalWo_Extref
      ,case
	  when right(Wo_Extref,6)='-PRIME'
	  then replace(substring(Wo_Extref,1,len(Wo_Extref)-6),'-','')
	  when right(Wo_Extref,10)='-PRIME-BOA'
	  then replace(substring(Wo_Extref,1,len(Wo_Extref)-10),'-','')
	  --when CHARINDEX(' - ',Wo_Extref
	  when CHARINDEX(' - ',WO_Extref,1)>0
	  then replace(substring(WO_Extref,1,CHARINDEX(' - ',WO_Extref,1)-1),'-','')
	  else replace(Wo_Extref,'-','')
	  end as ExtractedWo_Extref
      --,[ProjCustomerID]
      --,[ProjectCustomer]
      --,[ProjCustAddress]
      --,[ProjCustCity]
      --,[ProjCustProvince]
      --,[ProjCustPostCode]
      --,[Country]
      --,[Work_Order]
      --,[WO_Description]
      --,[WO_Extref]
      --,[Reference]
      --,[Amount]
      --,[Currency]
      --,[ExchangeRate]
      --,[CAD_Amount]
      --,[Date]
      --,[SectorCode]
      --,[SectorName]
      ,min([DateFrom]) as MinOfDateFrom
      ,max([DateTo]) as MaxOfDateTo
      --,[Contract_or_Amendment]
      --,[CustomerType]
      ,max([CummulativeAmount]) as MaxOfCummulativeAmount
	  --,CSIScontractID
	  --,CSISidvpiidID
      --,[ProductCode]
  FROM [DIIG].[Location].[CCCContractIDtoVendorName]
  group by Wo_Extref
  





GO


