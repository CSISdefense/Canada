USE [DIIG]
GO

/****** Object:  View [Location].[CCCcontractExtraction]    Script Date: 9/22/2016 8:56:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [Location].[CCCcontractExtraction]
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
[ContractNumber] as OriginalContractNumber
   ,case
	  when right([ContractNumber],6)='-PRIME'
	  then replace(substring([ContractNumber],1,len([ContractNumber])-6),'-','')
	  when right([ContractNumber],10)='-PRIME-BOA'
	  then replace(substring([ContractNumber],1,len([ContractNumber])-10),'-','')
	  --when CHARINDEX(' - ',[ContractNumber]
	  when CHARINDEX(' - ',[ContractNumber],1)>0
	  then replace(substring([ContractNumber],1,CHARINDEX(' - ',[ContractNumber],1)-1),'-','')
	  else replace(ContractNumber,'-','')
	  end as ExtractedContractNumber
	,case when right([ContractNumber],5)='PRIME'
		then 'PRIME'
		when right([ContractNumber],10)='-PRIME-BOA'
		then 'PRIME-BOA'
		when CHARINDEX(' - ',[ContractNumber],1)>0
	  then substring([ContractNumber],CHARINDEX(' - ',[ContractNumber])+3,999)
		end  as Suffix

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
	  ,CSIScontractID
	  ,CSISidvpiidID
      --,[ProductCode]
  FROM [DIIG].[Location].[CCCContractIDtoVendorName]
  group by ContractNumber
  ,CSIScontractID
	  ,CSISidvpiidID






GO


