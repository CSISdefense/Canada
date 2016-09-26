USE [DIIG]
GO

/****** Object:  View [Location].[CCCVendorIdentification]    Script Date: 9/22/2016 8:57:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





alter VIEW [Location].CanadaRelatedFSRSpartial
AS
SELECT u.CSIScontractID
,C.SubawardReportYear
,getdate() AS Query_Run_Date
,A.Customer
,A.SubCustomer 
--,NAICS.principalnaicscodeText
,PrimePlaceISO.IsForeign as PrimePlaceIsForeign
,PrimePlaceISO.name as PrimePlaceCountryText
,SubPlaceISO.IsForeign as SubPlaceIsForeign
,SubPlaceISO.name as SubPlaceCountryText
,SubVendorISO.IsForeign as SubVendorIsForeign
,SubVendorISO.name as SubVendorCountryText

,DUNSISO.IsForeign as SubDUNSIsForeign
,DUNSISO.name as SubDUNSCountryText
,ParentISO.IsForeign as SubParentIsForeign
,ParentISO.name as SubParentCountryText

,iif(PrimePlaceISO.[alpha-3] = 'CAN' ,1,0) as IsPrimePlaceCanada
,iif(SubPlaceISO.[alpha-3] = 'CAN' ,1,0) as IsSubPlaceCanada
		,iif(SubVendorISO.[alpha-3] = 'CAN' or
DunsISO.[alpha-3] ='CAN' or
			ParentISO.[alpha-3] ='CAN' or
			CCC.Is_CCC_Vendor=1
	,1,0) as IsSubVendorCanadian
		
	

,CCC.Is_CCC_Vendor as IsCCCsubVendor
--,C.PrimeAwardDunsnumber --Doesn't exist
,C.PrimeAwardeeParentDuns
,C.SubawardeeDunsnumber
,C.SubawardeeParentDuns
--,C.streetaddress
,C.SubawardeeStreet
,SubDUNS.StandardizedTopContractor as StandardizedTopSubContractor
,isnull(ccid2supplier.Supplier,idv2supplier.Supplier) as SubSupplier
,isnull(ccid2supplier.Supplier_id,idv2supplier.Supplier_id) as SubSupplier_id
,PARENT.ParentID
,PARENT.isforeign
,PARENT.parentheadquarterscountrycode
,c.SubawardeeName
,C.PrimeAwardAmount
,C.SubawardAmount
,CASE 
	WHEN PARENT.ParentID is not null and PARENT.ParentID<>'CANADIAN COMMERCIAL CORPORATION'
	THEN PARENT.ParentID
	WHEN PARENT.ParentID='CANADIAN COMMERCIAL CORPORATION'
	THEN coalesce(ccid2supplier.Supplier,idv2supplier.Supplier,'Unmatched CCC')
	ELSE coalesce(SubDUNS.StandardizedTopContractor,c.SubawardeeName)
END as SubParentIDsupplier

FROM Contract.FSRS as C
	LEFT OUTER JOIN 
		FPDSTypeTable.AgencyID AS A ON C.PrimeAwardContractingAgencyID = A.AgencyID
	--LEFT JOIN FPDSTypeTable.PrincipalNaicsCode AS NAICS
	--	ON C.PrimeAwardPrincipalNaicsCode = NAICS.principalnaicscode


	--Location Code
	--*Vendor State Code	
	--LEFT JOIN FPDStypeTable.StateCode as PrimeVendorStateCode
	--	ON StateCode.StateCode=c.StateCode   PrimeStateCode not captured
	LEFT JOIN FPDStypeTable.StateCode as SubVendorStateCode
		ON SubVendorStateCode.StateCode  =c.SubawardeeState

	--Subvendor Location
	LEFT JOIN FPDSTypeTable.vendorcountrycode as SubVendorCountryCodePartial
		ON SubVendorCountryCodePartial.vendorcountrycode=C.SubawardeeCountrycode
	LEFT JOIN FPDSTypeTable.Country3lettercode as SubVendorCountryCode
		ON SubVendorCountryCodePartial.Country3LetterCode=SubVendorcountrycode.Country3LetterCode
	left outer join location.CountryCodes as SubVendorISO
		on SubVendorCountryCode.ISOcountryCode=SubVendorISO.[alpha-2]





	--*PlaceOfPerformanceCountryCode
	LEFT JOIN FPDSTypeTable.Country3lettercode as PrimePlaceCountryCode
		ON PrimePlaceCountryCode.Country3LetterCode=C.PrimeAwardPrincipalPlaceCountry
	LEFT JOIN FPDSTypeTable.Country3lettercode as SubPlaceCountryCode
		ON SubPlaceCountryCode.Country3LetterCode=C.SubAwardPrincipalPlaceCountry
	left outer join location.CountryCodes as PrimePlaceISO
		on PrimePlaceCountryCode.ISOcountryCode =PrimePlaceISO.[alpha-2]
	left outer join location.CountryCodes as SubPlaceISO
		on SubPlaceCountryCode.ISOcountryCode =SubPlaceISO.[alpha-2]

	--Sub Dunsnumber
	LEFT OUTER JOIN Contractor.DunsnumbertoParentContractorHistory as SubDUNS
		ON C.PrimeAwardReportYear = SubDUNS.FiscalYear 
		AND C.SubawardeeDunsnumber = SubDUNS.DUNSNUMBER
	LEFT OUTER JOIN (SELECT DISTINCT DUNSNumber, Is_CCC_Vendor FROM Location.CCC_DUNS_to_StdTopContractor) AS CCC
		ON C.SubawardeeDunsnumber = CCC.DUNSNumber
	left outer join location.CountryCodes as DunsISO
		on SubDuns.topISO3countrycode =DunsISO.[alpha-3]


	--Parent
	LEFT OUTER JOIN Contractor.ParentContractor as PARENT
		ON SubDUNS.ParentID = PARENT.ParentID
	left outer join location.CountryCodes as ParentISO
		on Parent.topISO3countrycode =ParentISO.[alpha-3]


	
--TransactionID
--Block of CSISIDjoins
left outer join contract.PrimeAwardReportID u
on c.PrimeAwardReportID=u.PrimeAwardReportID
	left join contract.CsiScontractID as CCID
		on CCID.CsiScontractID=u.CsiScontractID
	--left join contract.CSISidvmodificationID as idvmod
	--	on ctid.CSISidvmodificationID=idvmod.CSISidvmodificationID
	left join contract.CSISidvpiidID as idv
		on idv.CSISidvpiidID=CCID.CSISidvpiidID
--CCC vendor matching
	left outer join location.CCCmatchingCSIScontractIDtoSupplier ccid2supplier
		on u.csiscontractid=ccid2supplier.csiscontractid
	left outer join location.CCCmatchingCSISidvpiidIDtoSupplier idv2supplier
		on idv.csisidvpiidid=idv2supplier.csisidvpiidid	

	--WHERE
	----C.fiscal_year >=2000
	----AND 
	--(
	--PrimePlaceISO.[alpha-3] = 'CAN' OR 
	--SubPlaceISO.[alpha-3] = 'CAN' OR 
	--	--PrimeVendorISO.[alpha-3] = 'CAN' OR
	--	SubVendorISO.[alpha-3] = 'CAN' --OR
	--	--DunsISO.[alpha-3] ='CAN' OR
	--	--ParentISO.[alpha-3]  ='CAN' OR
	--	--CCC.Is_CCC_Vendor =1
	--	)






















GO


