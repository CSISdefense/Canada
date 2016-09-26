USE [DIIG]
GO

/****** Object:  StoredProcedure [Location].[sp_CanadaRelated]    Script Date: 9/23/2016 9:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
ALTER PROCEDURE [Location].[sp_CanadaRelated]
	-- Add the parameters for the stored procedure here
	--@parentid nvarchar(255)
	--,@IsSiliconValley bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  [fiscal_year]
      ,[Query_Run_Date]
      ,[Customer]
      ,[SubCustomer]
      ,[ProductServiceOrRnDarea]
      ,[PlatformPortfolio]
      ,[Simple]
      ,[ProductOrServiceCode]
      ,[ProductOrServiceCodeText]
      ,[principalnaicscodeText]
      ,[CanadaSector]
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
      ,[placeofmanufactureText]
      ,[Is_CCC_Vendor]
      ,[dunsnumber]
      ,[parentdunsnumber]
      ,[streetaddress]
      ,[StandardizedTopContractor]
      ,[Supplier]
      ,[Supplier_id]
      ,[ParentID]
      ,[isforeign]
      ,[parentheadquarterscountrycode]
      ,[obligatedAmount]
      ,[numberOfActions]
  FROM [DIIG].[Location].[CCCVendorIdentification]


  SELECT [fiscal_year]
      ,[Customer]
	   ,CASE
		WHEN [NewCanadaSector] in ('Air','C4ISR','Land',
			'Sea','Space','Weapons, Ammunition and Missiles')
		THEN [NewCanadaSector] 
		ELSE 'Other Products, Services and R&D'
		END AS CanadaSectorSimple
      ,[ParentIDsupplier]
      ,sum([obligatedAmount]) as [obligatedAmount]
      ,sum([numberOfActions]) as [numberOfActions]
  FROM [DIIG].[Location].[CanadaRelatedFPDS]
  where Customer='Defense'
  group by  [fiscal_year]
      ,[Customer]
      ,CASE
		WHEN [NewCanadaSector] in ('Air','C4ISR','Land',
			'Sea','Space','Weapons, Ammunition and Missiles')
		THEN [NewCanadaSector] 
		ELSE 'Other Products, Services and R&D'
		END
      ,[ParentIDsupplier]
  order by CanadaSectorSimple
  ,fiscal_year
  ,obligatedAmount desc
END


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [PrimeAwardReportID],
count(distinct FPDS.CSIStransactionID) as CIDonlyCSIStransactionIDcount,
count(distinct Multimatch.CSIStransactionID) as MultimatchCSIStransactionIDcount,
max(fsrs.PrimeAwardAmount) as PrimeAwardAmount,
max(fsrs.MaxOfPrimeAwardDateSigned) as MaxOfPrimeAwardDateSigned,
max(fsrs.MinOfPrimeAwardDateSigned) as MinOfPrimeAwardDateSigned,
max(fsrs.[PrimeAwardDateSubmitted]) as [PrimeAwardDateSubmitted]
  FROM [DIIG].[Contract].[FSRSprime] fsrs
  left outer join contract.FPDScontractsInFSRS  as fpds
  on fsrs.CSIScontractID=fpds.CSIScontractID
  left outer join contract.FPDScontractsInFSRS as multimatch
  on multimatch.CSIScontractID=fsrs.CSIScontractID
  and multimatch.ObligatedAmount =fsrs.PrimeAwardAmount
  --and multimatch.descriptionofcontractrequirement= fsrs.PrimeAwardProjectDescription
  and multimatch.signeddate=fsrs.MaxOfPrimeAwardDateSigned 
  group by [PrimeAwardReportID]



--Total spending by contracts present 
SELECT sum(ObligatedAmount) as ObligatedAmount
,count(distinct CSIScontractID) as CountOfContracts
,f.fiscal_year
,a.customer
FROM Contract.FPDScontractsInFSRS f
left outer join FPDSTypeTable.AgencyID a
on a.agencyid=f.agencyid
group by f.fiscal_year, a.customer






GO


