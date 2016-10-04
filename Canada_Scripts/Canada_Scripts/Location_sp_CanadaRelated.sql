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

	SELECT TOP 1000 [fiscal_year]
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
		WHEN [CanadaSector] in ('Air','C4ISR','Land',
			'Sea','Space','Weapons, Ammunition and Missiles')
		THEN [CanadaSector] 
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
		WHEN [CanadaSector] in ('Air','C4ISR','Land',
			'Sea','Space','Weapons, Ammunition and Missiles')
		THEN [CanadaSector] 
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
      --,[PrimeAwardPIID]
      --,[PrimeAwardIDVPIID]
      --,[PrimeAwardFederalAwardID]
      --,[TypeOfSpending]
      --,[PrimeAwardDateSubmitted]
      --,[PrimeAwardReportMonth]
      --,[PrimeAwardReportYear]
      --,[PrimeAwardReportType]
      --,[PrimeAwardPrincipalPlaceStreet]
      --,[PrimeAwardPrincipalPlaceCity]
      --,[PrimeAwardPrincipalPlaceState]
      --,[PrimeAwardPrincipalPlaceZIP]
      --,[PrimeAwardPrincipalPlaceDistrict]
      --,[PrimeAwardPrincipalPlaceCountry]
      --,[PrimeAwardeeParentDuns]
      --,[PrimeAwardeeParentContractorName]
      --,[PrimeAwardContractingAgencyID]
      --,[PrimeAwardContractingAgencyName]
      --,[PrimeAwardContractingOfficeID]
      --,[PrimeAwardContractingOfficeName]
      --,[PrimeAwardFundingAgencyID]
      --,[PrimeAwardFundingAgencyName]
      --,[PrimeAwardFundingOfficeID]
      --,[PrimeAwardFundingOfficeName]
      --,[PrimeAwardProgramSourceAgency]
      --,[PrimeAwardProgramSourceAccount]
      --,[PrimeAwardProgramSourceSubaccount]
      --,[PrimeAwardeeExecutive1]
      --,[PrimeAwardeeExecutive1Compensation]
      --,[PrimeAwardeeExecutive2]
      --,[PrimeAwardeeExecutive2Compensation]
      --,[PrimeAwardeeExecutive3]
      --,[PrimeAwardeeExecutive3Compensation]
      --,[PrimeAwardeeExecutive4]
      --,[PrimeAwardeeExecutive4Compensation]
      --,[PrimeAwardeeExecutive5]
      --,[PrimeAwardeeExecutive5Compensation]
      --,[PrimeAwardPrincipalNaicsCode]
      --,[PrimeAwardPrincipalNaicsDesc]
      --,[PrimeAwardCFDAprogramNumberTitleCodes]
      --,[PrimeAwardAmount]
      --,[MinOfPrimeAwardDateSigned]
      --,[MaxOfPrimeAwardDateSigned]
      --,[PrimeAwardProjectDescription]
      --,[PrimeAwardTransactionType]
      --,[PrimeAwardProgramTitle]
      --,[PrimeAwardeeRecoveryModelQ1]
      --,[PrimeAwardeeRecoveryModelQ2]
      --,[PrimeAwardContractingMajorAgencyID]
      --,[PrimeAwardContractingMajorAgencyName]
      --,[PrimeAwardFundingMajorAgencyID]
      --,[PrimeAwardFundingMajorAgencyName]
      --,[PrimeAwardAgencyID]
      --,[PrimeAwardIDVagencyID]
  FROM [DIIG].[Contract].[FSRSprime] fsrs
  left outer join contract.FPDScontractsInFSRS  as fpds
  on fsrs.CSIScontractID=fpds.CSIScontractID
  left outer join contract.FPDScontractsInFSRS as multimatch
  on multimatch.CSIScontractID=fsrs.CSIScontractID
  and multimatch.ObligatedAmount =fsrs.PrimeAwardAmount
  --and multimatch.descriptionofcontractrequirement= fsrs.PrimeAwardProjectDescription
  and multimatch.signeddate=fsrs.MaxOfPrimeAwardDateSigned 
  group by [PrimeAwardReportID]



--Toplines
SELECT [SubawardReportYear]
      ,[Customer]
      ,[SubCustomer]
	  	      ,[CanadaSector]

      ,sum(f.[SubawardAmount]) as [SubawardAmount]
	  	  ,count(Distinct f.CSIScontractID) as NumberOfContracts
  FROM [DIIG].[Location].[CanadaRelatedFSRSpartial] f
  left outer join Contract.ContractCanadaRelatedFPDSandFSRS c
  on f.CSIScontractID=c.CSIScontractID
  group by [SubawardReportYear]
      ,[Customer]
      ,[SubCustomer]
	  	      ,[CanadaSector]


SELECT  f.[fiscal_year]
      ,f.[Customer]
      ,f.[SubCustomer]
      ,f.[CanadaSector]
	  , iif(c.CSIScontractID is not null,1,0) as IsSubcontractReportingContract
      ,sum(f.[obligatedAmount]) as [obligatedAmount]
      ,sum(f.[numberOfActions]) as numberOfActions
	  ,count(Distinct f.CSIScontractID) as NumberOfContracts
  FROM [DIIG].[Location].[CanadaRelatedFPDSpartial] f
  left outer join Contract.ContractCanadaRelatedFPDSandFSRS c
  on f.CSIScontractID=c.CSIScontractID
  group by f.[fiscal_year]
      ,f.[Customer]
      ,f.[SubCustomer]
      ,f.[CanadaSector]
	  , iif(c.CSIScontractID is not null,1,0)







GO


