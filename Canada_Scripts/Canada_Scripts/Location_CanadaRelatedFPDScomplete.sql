/****** Script for SelectTopNRows command from SSMS  ******/
alter VIEW Location.CanadaRelatedFPDScomplete AS
SELECT [fiscal_year]
      ,f.[CSIScontractID]
      ,f.[IDVpiid]
      ,f.[PIID]
      ,[Query_Run_Date]
      ,[Customer]
      ,[SubCustomer]
      ,[ProductServiceOrRnDarea]
      ,[Simple]
      ,[ProductOrServiceCode]
      ,[ProductOrServiceCodeText]
      ,[principalnaicscodeText]
      ,f.[CanadaSector]
      ,[PlatformPortfolio]
      ,[isforeignownedandlocated]
      ,[isforeigngovernment]
      ,[isinternationalorganization]
      ,[organizationaltype]
      ,[PlaceIsForeign]
      ,[PlaceCountryText]
      ,[OriginIsForeign]
      ,[OriginCountryText]
      ,[VendorIsForeign]
      ,[VendorCountryText]
      ,[DUNSIsForeign]
      ,[DUNSCountryText]
      ,[ParentIsForeign]
      ,[ParentCountryText]
      ,[IsPlaceCanada]
      ,[IsOriginCanada]
      ,IsVendorCanadian
	  ,IsVendorCanadianClassic
	  ,IsParentHQCanadian
      ,[placeofmanufactureText]
      ,[IsCCCvendor]
      ,[dunsnumber]
      ,[parentdunsnumber]
      ,[streetaddress]
      ,[StandardizedTopContractor]
      ,[Supplier]
      ,[Supplier_id]
      ,f.[ParentIDsupplier]
      ,[ParentID]
      ,[isforeign]
      ,[parentheadquarterscountrycode]
      ,f.[obligatedAmount]
      ,[numberOfActions]
	  --SubContract Information 
	  ,iif(c.CSIScontractID is not null,1,0) as IsSubcontractReportingContract
	  ,[CanadaMinOfSubawardFiscalYear]
      ,[MaxOfIsPrimePlaceCanada]
      ,[MaxOfIsSubPlaceCanada]
      ,[MaxOfIsSubVendorCanadian]
      ,[MaxOfIsCCCsubvendor]
      ,[subParentIDsupplier]
  FROM [DIIG].[Location].[CanadaRelatedFPDSpartial] f
  left outer join Contract.ContractCanadaRelatedFPDSandFSRS c
  on f.CSIScontractID=c.CSIScontractID
  WHERE
	f.fiscal_year >=2000
	AND ( [IsPlaceCanada]=1
      OR [IsOriginCanada]=1
      OR IsVendorCanadian=1)
     
