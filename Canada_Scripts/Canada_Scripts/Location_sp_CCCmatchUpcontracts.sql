USE [DIIG]
GO

/****** Object:  StoredProcedure [Location].[sp_CCCmatchUpcontracts]    Script Date: 9/22/2016 8:15:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
ALTER PROCEDURE [Location].[sp_CCCmatchUpcontracts]
	-- Add the parameters for the stored procedure here
	--@parentid nvarchar(255)
	--,@IsSiliconValley bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Find complete IDVpiid match and mismatches
select w.ExtractedWo_Extref
--,w.CSIScontractID
--,w.CSISidvpiidID
,c.CSIScontractID
,c.CSISidvpiidID
,i.csisIDVpiidid
from Location.CCCwo_refExtraction w
inner join location.CCCContractIDtoVendorName c
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.csisidvpiidid i
on i.idvpiid= w.ExtractedWo_Extref
where c.CSISidvpiidID<>i.CSISidvpiidID or c.CSISidvpiidID is null

--Assign IDVpiid updates.
update c
set CSISidvpiidID=i.CSISidvpiidID
from location.CCCContractIDtoVendorName c
inner join Location.CCCwo_refExtraction w
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.csisidvpiidid i
on i.idvpiid= w.ExtractedWo_Extref
where c.CSISidvpiidID is null



--Find partial IDVpiid match and mismatches
select w.ExtractedWo_Extref
,i.idvpiid
,i.csisIDVpiidid
--,w.CSIScontractID
--,w.CSISidvpiidID
,c.CSIScontractID
,c.CSISidvpiidID
from Location.CCCwo_refExtraction w
inner join location.CCCContractIDtoVendorName c
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.csisidvpiidid i
on i.idvpiid= left(w.ExtractedWo_Extref,len(i.idvpiid))
where (c.CSISidvpiidID<>i.CSISidvpiidID or c.CSISidvpiidID is null )
and i.idvpiid<>'' and (len(i.idvpiid) < len(w.ExtractedWo_Extref)) and len(i.idvpiid)>3

--Update partial matches IDV piid
update c
set CSISidvpiidID=i.CSISidvpiidID
from location.CCCContractIDtoVendorName c
inner join Location.CCCwo_refExtraction w
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.csisidvpiidid i
on i.idvpiid= left(w.ExtractedWo_Extref,len(i.idvpiid))
where c.CSISidvpiidID is null and i.idvpiid<>'' and (len(i.idvpiid) < len(w.ExtractedWo_Extref)) and len(i.idvpiid)>3




--List PIIDs for partial IDV piid
Update c
set CSIScontractID=p.CSIScontractID
from location.CCCContractIDtoVendorName c
inner join Location.CCCwo_refExtraction w
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.csisidvpiidid i
on i.CSISidvpiidID= c.CSISidvpiidID
inner join contract.CSIScontractID p
on p.CSISidvpiidID=i.CSISidvpiidID
and p.piid=substring(w.ExtractedWo_Extref,len(i.idvpiid)+1,99)
where c.CSISidvpiidID is not null and c.CSIScontractID is null and
	len(w.ExtractedWo_Extref )>len(i.idvpiid)



--Checking PIID matches
select w.ExtractedWo_Extref
,c.CSIScontractID
,p.CSIScontractID
from Location.CCCwo_refExtraction w
inner join location.CCCContractIDtoVendorName c
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.CSIScontractid p
on p.piid= w.ExtractedWo_Extref
where c.CSIScontractID<>p.CSIScontractID or c.CSIScontractID is null

--PIID
update c
set CSIScontractID=p.CSIScontractID
from location.CCCContractIDtoVendorName c
inner join Location.CCCwo_refExtraction w
on c.WO_Extref=w.OriginalWo_Extref
inner join contract.CSIScontractid p
on p.piid= w.ExtractedWo_Extref
where c.CSIScontractID is null


--Select all unmatched contracts
 SELECT
      c.[idvpiid]
       ,c.[piid]
	   --,vc.ContractNumber
	     ,c.[CSISidvpiidID]
      ,c.[CSIScontractID]
   ,ObligatedAmount as SumOfObligatedAmount
  FROM [DIIG].[Location].[CCCidvpiidPIID] c
  left outer join [DIIG].[Location].CCCmatchingCSIScontractIDtoSupplier vc
  on c.CSIScontractID=vc.CSIScontractID
  --and isnull(c.CSISidvpiidID,23356) = isnull(vn.CSISidvpiidID,23356)
  left outer join [DIIG].[Location].CCCmatchingCSISidvpiidIDtoSupplier vi
  on c.csisidvpiidid = vi.csisidvpiidid 
  where vc.CSIScontractID is null  and vi.CSISidvpiidID is null
	order by obligatedAmount desc

--Select all unmatched IDVs
 SELECT
      c.[idvpiid]
	     ,c.[CSISidvpiidID]
   ,ObligatedAmount 
  FROM [DIIG].[Location].[CCCidvpiid] c
	left outer join [DIIG].[Location].CCCmatchingCSISidvpiidIDtoSupplier vi
  on c.csisidvpiidid = vi.csisidvpiidid 
  where vi.CSISidvpiidID is null and  idvpiid<>''
	order by obligatedAmount desc

--Select all unmatched
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
[CSIScontractID]
      ,[CSISidvPIIDid]
      ,[ContractNumber]
	  ,ExtractedContractnumber
	  ,suffix
      ,[Supplier]
      ,[Supplier_ID]
  FROM [DIIG].[Location].[CCCcontractNumber] c
where CSIScontractID is null and CSISidvpiidID is null
order by [ContractNumber]


END











GO


