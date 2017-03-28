USE [DIIG]
GO

/****** Object:  View [Location].[CanadaRelatedFPDSpartial]    Script Date: 3/25/2017 7:54:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [Location].[CanadaRelatedFPDSpartial]
AS
SELECT 
C.fiscal_year
,ctid.CSIScontractID
,ccid.IDVpiid
,ccid.PIID
,c.descriptionofcontractrequirement
,getdate() AS Query_Run_Date
,A.Customer
,A.SubCustomer 
,PSC.ProductServiceOrRnDarea
,PSC.Simple
,psc.ProductOrServiceCode
,psc.ProductOrServiceCodeText
,NAICS.principalnaicscodeText
,CASE
WHEN PSC.CanadaSector = 'C4ISR'
THEN  'C4ISR'
WHEN CPC.CanadaSector IS NOT NULL
THEN CPC.CanadaSector
ELSE  PSC.CanadaSector
END as CanadaSector

,isnull(PSC.PlatformPortfolio,PSC.PlatformPortfolio) as PlatformPortfolio
,c.isforeignownedandlocated
,c.isforeigngovernment
,c.isinternationalorganization
,c.organizationaltype
,PlaceISO.IsForeign as PlaceIsForeign
,PlaceISO.name as PlaceCountryText
,OriginISO.IsForeign as OriginIsForeign
,OriginISO.name as OriginCountryText
,VendorISO.IsForeign as VendorIsForeign
,VendorISO.name as VendorCountryText
,DUNSISO.IsForeign as DUNSIsForeign
,DUNSISO.name as DUNSCountryText
,ParentISO.IsForeign as ParentIsForeign
,ParentISO.name as ParentCountryText
,iif(PlaceISO.[alpha-3] = 'CAN' ,1,0) as IsPlaceCanada
		,iif(OriginISO.[alpha-3] = 'CAN' ,1,0) IsOriginCanada
		,iif(VendorISO.[alpha-3] = 'CAN' or
			DunsISO.[alpha-3] ='CAN' or
			ParentISO.[alpha-3] ='CAN' or
			CCC.Is_CCC_Vendor=1,1,0) as IsVendorCanadianClassic
		,iif(VendorISO.[alpha-3] = 'CAN' or
			DunsISO.[alpha-3] ='CAN' or
			ParentISO.[alpha-3] ='CAN' or
			ParentHQISO.[alpha-3]='CAN' or
			CCC.Is_CCC_Vendor=1,1,0) as IsVendorCanadian
,iif(ParentHQISO.[alpha-3]='CAN',1,0) as IsParentHQCanadian
,pom.placeofmanufactureText
,CCC.Is_CCC_Vendor as IsCCCvendor
,C.dunsnumber
,C.parentdunsnumber
	,C.streetaddress
,DUNS.StandardizedTopContractor
,isnull(ccid2supplier.Supplier,idv2supplier.Supplier) as Supplier
,isnull(ccid2supplier.Supplier_id,idv2supplier.Supplier_id) as Supplier_id
,CASE 
	WHEN PARENT.ParentID is not null and PARENT.ParentID<>'CANADIAN COMMERCIAL CORPORATION'
	THEN PARENT.ParentID
	WHEN PARENT.ParentID='CANADIAN COMMERCIAL CORPORATION'
	THEN coalesce(ccid2supplier.ParentID,ccid2supplier.Supplier,
	idv2supplier.ParentID,idv2supplier.Supplier,'Unmatched CCC')
	ELSE DUNS.StandardizedTopContractor
END as ParentIDsupplier
,PARENT.ParentID
,PARENT.isforeign
,PARENT.parentheadquarterscountrycode
,C.obligatedAmount
,C.numberOfActions

FROM Contract.FPDS as C
	LEFT OUTER JOIN FPDSTypeTable.AgencyID AS A 
		ON C.contractingofficeagencyid = A.AgencyID
	LEFT JOIN FPDSTypeTable.ProductOrServiceCode AS PSC
		ON C.productorservicecode=PSC.ProductOrServiceCode
	LEFT JOIN FPDSTypeTable.PrincipalNaicsCode AS NAICS
		ON C.principalnaicscode = NAICS.principalnaicscode
	left outer join FPDSTypeTable.ClaimantProgramCode as cpc 
		on cpc.ClaimantProgramCode=c.claimantprogramcode


	--Location Code
	--*State Code	
	LEFT JOIN FPDStypeTable.StateCode as StateCode
		ON c.StateCode= StateCode.StateCode
	--*PlaceOfPerformanceCountryCode
	LEFT JOIN FPDSTypeTable.Country3lettercode as PlaceCountryCode
		ON C.placeofperformancecountrycode=PlaceCountryCode.Country3LetterCode
	left outer join location.CountryCodes as PlaceISO
		on PlaceCountryCode.ISOcountryCode =placeiso.[alpha-2]
	--*OriginCountryCode
	LEFT JOIN FPDSTypeTable.Country3lettercode as OriginCountryCode
		ON C.countryoforigin=OriginCountryCode.Country3LetterCode
	left outer join location.CountryCodes as OriginISO
		on OriginCountryCode.ISOcountryCode =OriginISO.[alpha-2]
	--*VendorCountryCode 
	LEFT JOIN FPDSTypeTable.vendorcountrycode as VendorCountryCodePartial
		ON C.vendorcountrycode=VendorCountryCodePartial.vendorcountrycode
	LEFT JOIN FPDSTypeTable.Country3lettercode as VendorCountryCode
		ON vendorcountrycode.Country3LetterCode=VendorCountryCodePartial.Country3LetterCode
	left outer join location.CountryCodes as VendorISO
		on VendorCountryCode.ISOcountryCode=VendorISO.[alpha-2]
	--*PlaceOfManufacture
	left outer join FPDSTypeTable.placeofmanufacture as PoM
		on c.placeofmanufacture=pom.placeofmanufacture

	--Dunsnumber
	LEFT OUTER JOIN Contractor.DunsnumbertoParentContractorHistory as DUNS
		ON C.fiscal_year = DUNS.FiscalYear 
		AND C.DUNSNumber = DUNS.DUNSNUMBER
	LEFT OUTER JOIN (SELECT DISTINCT DUNSNumber, Is_CCC_Vendor FROM Location.CCC_DUNS_to_StdTopContractor) AS CCC
		ON C.dunsnumber = CCC.DUNSNumber
	left outer join location.CountryCodes as DunsISO
		on Duns.topISO3countrycode =DunsISO.[alpha-3]


	--Parent
	LEFT OUTER JOIN Contractor.ParentContractor as PARENT
		ON DUNS.ParentID = PARENT.ParentID
	left outer join location.CountryCodes as ParentISO
		on Parent.topISO3countrycode =ParentISO.[alpha-3]
			left outer join location.CountryCodes as ParentHQISO
		on Parent.parentheadquarterscountrycode =ParentHQISO.[alpha-3]


	
--TransactionID
--Block of CSISIDjoins
	left join contract.csistransactionid as CTID
		on c.CSIStransactionID=ctid.CSIStransactionID
	left join contract.CSIScontractID as CCID
		on ctid.CSIScontractID=CCID.CSIScontractID
	left join contract.CSISidvmodificationID as idvmod
		on ctid.CSISidvmodificationID=idvmod.CSISidvmodificationID
	left join contract.CSISidvpiidID as idv
		on idv.CSISidvpiidID=idvmod.CSISidvpiidID
--CCC vendor matching
	left outer join Contract.CSIScontractIDtoSupplierID as ccid2supplier
		on ccid2supplier.csiscontractid = ctid.csiscontractid
	left outer join Contract.CSISidvpiidIDtoSupplierID as idv2supplier
		on idv2supplier.csisidvpiidid = idv.csisidvpiidid



	--WHERE
	--C.fiscal_year >=2000
	--AND (PlaceISO.[alpha-3] = 'CAN' OR 
	--	OriginISO.[alpha-3] = 'CAN' OR
	--	VendorISO.[alpha-3] = 'CAN' OR
	--	DunsISO.[alpha-3] ='CAN' OR
	--	ParentISO.[alpha-3]  ='CAN' OR
	--	CCC.Is_CCC_Vendor =1
	--	)






























GO


