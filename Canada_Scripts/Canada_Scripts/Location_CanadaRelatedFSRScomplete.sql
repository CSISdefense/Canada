/****** Script for SelectTopNRows command from SSMS  ******/
alter VIEW Location.CanadaRelatedFSRScomplete AS
SELECT f.[CSIScontractID]
      ,[SubawardReportYear]
      ,[Query_Run_Date]
      ,[Customer]
      ,[SubCustomer]
      ,[PrimePlaceIsForeign]
      ,[PrimePlaceCountryText]
      ,[SubPlaceIsForeign]
      ,[SubPlaceCountryText]
      ,[SubVendorIsForeign]
      ,[SubVendorCountryText]
      ,[SubDUNSIsForeign]
      ,[SubDUNSCountryText]
      ,[SubParentIsForeign]
      ,[SubParentCountryText]
      ,[IsPrimePlaceCanada]
      ,[IsSubPlaceCanada]
      ,[IsSubVendorCanadian]
      ,[IsCCCsubVendor]
      ,[PrimeAwardeeParentDuns]
      ,[SubawardeeDunsnumber]
      ,[SubawardeeParentDuns]
      ,[SubawardeeStreet]
      ,[StandardizedTopSubContractor]
      ,[SubSupplier]
      ,[SubSupplier_id]
      ,[ParentID]
      ,[isforeign]
      ,[parentheadquarterscountrycode]
      ,[SubawardeeName]
      ,f.[PrimeAwardAmount]
      ,f.[SubawardAmount]
      ,f.[SubParentIDsupplier]
	      ,[CanadaSector]
      ,[MaxOfIsPlaceCanada]
      ,[MaxOfIsOriginCanada]
      ,[MaxOfIsVendorCanadian]
      ,[MaxOfIsCCCvendor]
      ,[ParentIDsupplier]
  FROM [DIIG].[Location].[CanadaRelatedFSRSpartial] f
  left outer join Contract.ContractCanadaRelatedFPDSandFSRS c
  on f.CSIScontractID=c.CSIScontractID
  	WHERE
	f.SubawardReportYear >=2011
	AND 
	(
	[IsSubPlaceCanada]=1
      or [IsSubVendorCanadian]=1
		)
