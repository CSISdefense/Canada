/****** Script for SelectTopNRows command from SSMS  ******/
Alter View Contract.ContractCanadaRelatedFPDSandFSRS as
SELECT f.[CSIScontractID]
      ,f.[IDVpiid]
      ,f.[PIID]
      ,[MinOfPrimeAwardDateSubmitted]
      ,[MaxOfPrimeAwardDateSubmitted]
      ,[MinOfPrimeAwardReportYear]
      ,[MaxOfPrimeAwardReportYear]
      ,[MinOfPrimeAwardDateSigned]
      ,[MaxOfPrimeAwardDateSigned]
      ,[PrimeAwardAmount]
      ,[ObligatedAmount]
      ,[SubAwardAmount]
      ,[CountOfPrimeAwardReportID]
	  ,c.MinOfFiscalYear as CanadaMinOfFiscalYear
	  ,c.CanadaSector
	  --FPDS
	  ,c.MaxOfIsPlaceCanada
	  ,c.MaxOfIsOriginCanada
	  ,c.MaxOfIsCCCvendor
	  ,c.ParentIDsupplier
	  --FSRS
	  ,MaxOfIsPrimePlaceCanada
,MaxOfIsSubPlaceCanada
,MaxOfIsSubVendorCanadian
from Contract.ContractMergerFPDSandFSRS f
left outer join (SELECT CSIScontractID
,min([fiscal_year]) as MinOfFiscalYear
,iif(min(CanadaSector)=max(CanadaSector),
	max(CanadaSector),NULL) as CanadaSector
,max(IsPlaceCanada) as MaxOfIsPlaceCanada
,max(IsOriginCanada) as MaxOfIsOriginCanada
,max(IsVendorCanadian) as MaxOfIsVendorCanadian
,max(cast(IsCCCvendor as tinyint)) as MaxOfIsCCCvendor
,iif(min([ParentIDsupplier])=max([ParentIDsupplier]),
	max([ParentIDsupplier]),NULL) as ParentIDsupplier
  FROM [DIIG].[Location].CanadaRelatedFPDS
  where CSIScontractID in (Select distinct CSIScontractID from Contract.PrimeAwardReportID)
  group by CSIScontractID
  ) as c
on c.CSIScontractID=f.CSIScontractID
left outer join (SELECT CSIScontractID
--,min([fiscal_year]) as MinOfFiscalYear
,max(IsPrimePlaceCanada) as MaxOfIsPrimePlaceCanada
,max(IsSubPlaceCanada) as MaxOfIsSubPlaceCanada
,max(IsSubVendorCanadian) as MaxOfIsSubVendorCanadian
--,max(cast(IsCCCvendor as tinyint)) as MaxOfIsCCCvendor
--,iif(min([ParentIDsupplier])=max([ParentIDsupplier]),
	--max([ParentIDsupplier]),NULL) as ParentIDsupplier
  FROM [DIIG].[Location].CanadaRelatedFSRS
  group by CSIScontractID
  ) as s
on s.CSIScontractID=f.CSIScontractID
