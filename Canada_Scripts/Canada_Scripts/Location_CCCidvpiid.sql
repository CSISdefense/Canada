USE [DIIG]
GO

/****** Object:  View [Location].[CCCidvpiid]    Script Date: 9/22/2016 8:57:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




















ALTER VIEW [Location].[CCCidvpiid]
AS


	 --[fiscal_year]
 --     ,[Query_Run_Date]
 --     ,[Customer]
 --     ,[SubCustomer]
 --     ,[ProductServiceOrRnDarea]
 --     ,[PlatformPortfolio]
 --     ,[Simple]
 --     ,[principalnaicscodeText]
 --     ,[isforeignownedandlocated]
 --     ,[isforeigngovernment]
 --     ,[isinternationalorganization]
 --     ,[organizationaltype]
 --     ,[PlaceIsForeign]
 --     ,[PlaceCountryText]
 --     ,[OriginIsForeign]
 --     ,[OriginCountryText]
 --     ,[VendorIsForeign]
 --     ,[VendorCountryText]
 --     ,[DUNSIsForeign]
 --     ,[DUNSCountryText]
 --     ,[ParentIsForeign]
 --     ,[ParentCountryText]
 --     ,[placeofmanufactureText]
 --     ,[Is_CCC_Vendor]
 --     ,[dunsnumber]
 --     ,[parentdunsnumber]
 --     ,[streetaddress]
 --     ,[ParentID]
 --     ,[isforeign]
 --     ,[parentheadquarterscountrycode]
 --     ,[obligatedAmount]
 --     ,[numberOfActions]
 SELECT
       --c.[StandardizedTopContractor] as Supplier
      c.[idvpiid]
       --,c.[piid]
      --,c.[modnumber]
      --,c.[idmodificationnumber]
      --,c.[transactionnumber]
	     ,c.[CSISidvpiidID]
		 --,c.[CSISidvmodificationID]
      --,c.[CSIScontractID]
      --,c.[CSIStransactionID]
   ,sum(ObligatedAmount) as ObligatedAmount
  FROM [DIIG].[Location].[CCC] c
   where c.parentid='Canadian Commercial Corporation'
  group by c.[idvpiid]
       --,c.[piid]
	     ,c.[CSISidvpiidID]
      --,c.[CSIScontractID]

























GO


