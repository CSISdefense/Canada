/****** Script for SelectTopNRows command from SSMS  ******/

alter View Contract.ContractMergerFPDSandFSRS as
Select u.CSIScontractID
,IDVpiid
      ,PIID
      ,min([PrimeAwardDateSubmitted]) as [MinOfPrimeAwardDateSubmitted]
	  ,max([PrimeAwardDateSubmitted]) as [MaxOfPrimeAwardDateSubmitted]
      ,min([PrimeAwardReportYear]) as [MinOfPrimeAwardReportYear]
      ,max([PrimeAwardReportYear]) as [MaxOfPrimeAwardReportYear]
      ,min(MinOfPrimeAwardDateSigned) as MinOfPrimeAwardDateSigned
	  ,max(MaxOfPrimeAwardDateSigned) as MaxOfPrimeAwardDateSigned
	  
	  ,sum( [PrimeAwardAmount]) as [PrimeAwardAmount]
	  ,sum(ObligatedAmount) as ObligatedAmount
	  ,sum(SubAwardAmount) as SubAwardAmount
	  ,count(distinct PrimeAwardReportID) as CountOfPrimeAwardReportID
From (select CSIScontractID
,idvpiid
,PIID
,signeddate
	  ,fiscal_year
	  ,effectivedate
, NULL as [PrimeAwardDateSubmitted]
      ,NULL as [PrimeAwardReportYear]
      ,NULL as  [PrimeAwardAmount]
      ,NULL as MinOfPrimeAwardDateSigned
	  ,NULL as MaxOfPrimeAwardDateSigned
	  ,obligatedamount
	  ,NULL as SubawardAmount
	  ,NULL as PrimeAwardReportID
from Contract.FPDScontractsInFSRS
UNION ALL
SELECT  p.CSIScontractID
,[PrimeAwardIDVPIID] as IDVpiid
      ,[PrimeAwardPIID] as PIID
	  ,NULL as signeddate
	  ,NULL as fiscal_year
	  ,NULL as effectivedate
      ,[PrimeAwardDateSubmitted]
      ,[PrimeAwardReportYear]
      , [PrimeAwardAmount]
      ,MinOfPrimeAwardDateSigned
	  ,MaxOfPrimeAwardDateSigned
	  ,NULL as  ObligatedAmount
	  ,NULL as SubawardAmount
	  ,PrimeAwardReportID
  FROM Contract.FSRSprime p
  where p.PrimeAwardReportYear<=(select max(fiscal_year) from Contract.FPDScontractsInFSRS)
UNION All
select u.CSIScontractID
,[PrimeAwardIDVPIID] as IDVpiid
      ,[PrimeAwardPIID] as PIID
	  ,NULL as signeddate
	  ,NULL as fiscal_year
	  ,NULL as effectivedate
      ,[PrimeAwardDateSubmitted]
      ,[PrimeAwardReportYear]
      , [PrimeAwardAmount]
      ,PrimeAwardDateSigned
	  ,PrimeAwardDateSigned
	  ,NULL as  ObligatedAmount
	  ,SubawardAmount
	  ,f.PrimeAwardReportID
from Contract.FSRS f
inner join Contract.PrimeAwardReportID u
on f.PrimeAwardReportID = u.PrimeAwardReportID
where f.SubawardReportYear=(select max(fiscal_year) from Contract.FPDScontractsInFSRS)
) u

group by CSIScontractID
,IDVpiid
  ,PIID
      
	  