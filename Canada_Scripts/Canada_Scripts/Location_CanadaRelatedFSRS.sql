USE [DIIG]
GO

/****** Object:  View [Location].[CCCVendorIdentification]    Script Date: 9/22/2016 8:57:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





alter VIEW [Location].CanadaRelatedFSRS
AS
SELECT u.CSIScontractID
,C.SubawardReportYear
,getdate() AS Query_Run_Date
,A.Customer
,A.SubCustomer 
--,NAICS.principalnaicscodeText
--,PrimePlaceISO.IsForeign as PrimePlaceIsForeign
--,PrimePlaceISO.name as PrimePlaceCountryText
--,SubPlaceISO.IsForeign as SubPlaceIsForeign
--,SubPlaceISO.name as SubPlaceCountryText
,SubVendorISO.IsForeign as VendorIsForeign
,SubVendorISO.name as VendorCountryText

--,DUNSISO.IsForeign as DUNSIsForeign
--,DUNSISO.name as DUNSCountryText
--,ParentISO.IsForeign as ParentIsForeign
--,ParentISO.name as ParentCountryText

,iif(PrimePlaceISO.[alpha-3] = 'CAN' ,1,0) as IsPrimePlaceCanada
,iif(SubPlaceISO.[alpha-3] = 'CAN' ,1,0) as IsSubPlaceCanada
		--,iif(OriginISO.[alpha-3] = 'CAN' ,1,0) IsOriginCanada
,iif(SubVendorISO.[alpha-3] = 'CAN',1,0) as IsSubVendorCanadian
		--,iif(VendorISO.[alpha-3] = 'CAN' or
			--DunsISO.[alpha-3] ='CAN' or
			--ParentISO.[alpha-3] ='CAN',1,0) as IsVendorCanadian

	

--,CCC.Is_CCC_Vendor
--,C.PrimeAwardDunsnumber --Doesn't exist
,C.PrimeAwardeeParentDuns
,C.SubawardeeDunsnumber
,C.SubawardeeParentDuns
--,C.streetaddress
,C.SubawardeeStreet
--,DUNS.StandardizedTopContractor
--,isnull(ccid2supplier.Supplier,idv2supplier.Supplier) as Supplier
--,isnull(ccid2supplier.Supplier_id,idv2supplier.Supplier_id) as Supplier_id
--,PARENT.ParentID
--,PARENT.isforeign
--,PARENT.parentheadquarterscountrycode
,C.PrimeAwardAmount
,C.SubawardAmount

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

	--Prime Dunsnumber
	--LEFT OUTER JOIN Contractor.DunsnumbertoParentContractorHistory as DUNS
	--	ON C.fiscal_year = DUNS.FiscalYear 
	--	AND C.DUNSNumber = DUNS.DUNSNUMBER
	--LEFT OUTER JOIN (SELECT DISTINCT DUNSNumber, Is_CCC_Vendor FROM Location.CCC_DUNS_to_StdTopContractor) AS CCC
	--	ON C.dunsnumber = CCC.DUNSNumber
	--left outer join location.CountryCodes as DunsISO
	--	on Duns.topISO3countrycode =DunsISO.[alpha-3]


	--Parent
	--LEFT OUTER JOIN Contractor.ParentContractor as PARENT
	--	ON DUNS.ParentID = PARENT.ParentID
	--left outer join location.CountryCodes as ParentISO
	--	on Parent.topISO3countrycode =ParentISO.[alpha-3]


	
--TransactionID
--Block of CSISIDjoins
left outer join contract.PrimeAwardReportID u
on c.PrimeAwardReportID=u.PrimeAwardReportID
	--left join contract.csistransactionid as CTID
	--	on c.CSIStransactionID=ctid.CSIStransactionID
	--left join contract.CSISidvmodificationID as idvmod
	--	on ctid.CSISidvmodificationID=idvmod.CSISidvmodificationID
	--left join contract.CSISidvpiidID as idv
	--	on idv.CSISidvpiidID=idvmod.CSISidvpiidID
--CCC vendor matching
	--left outer join location.CCCmatchingCSIScontractIDtoSupplier ccid2supplier
	--	on ctid.csiscontractid=ccid2supplier.csiscontractid
	--left outer join location.CCCmatchingCSISidvpiidIDtoSupplier idv2supplier
	--	on idv.csisidvpiidid=idv2supplier.csisidvpiidid	

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


