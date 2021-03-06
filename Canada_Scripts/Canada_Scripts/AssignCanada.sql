USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_AssignParentHeadquartersCountry]
		@parentid = N'MDA',
		@parentheadquarterscountrycodetext = N'Canada'

SELECT	'Return Value' = @return_value



GO
/*
							
							imt defense 5
*/

select *
from contractor.ParentContractor p
where p.parentheadquarterscountrycode='CAN'

select pid.parentid
,sum(iif(pid.topISO3countrycode='CAN' or dtpch.topISO3countrycode='CAN' or duns.topISO3countrycode='CAN',ObligatedAmount,NULL)) as DefinitelyOriginallyCaptured
,sum(iif(pid.topISO3countrycode='CAN' or dtpch.topISO3countrycode='CAN' or duns.topISO3countrycode='CAN',NULL,ObligatedAmount)) as MightBeUncaptured
,sum(iif(pid.topISO3countrycode='CAN' or dtpch.topISO3countrycode='CAN' or duns.topISO3countrycode='CAN',ObligatedAmount,NULL)) /sum(ObligatedAmount) as OriginalPercent
,count(*) as DUNScount--, dtpch.obligatedamount
,min(fiscalyear) as MinOfFiscalYear, max(fiscalYear) as MaxOfFiscalYear
,sum(ObligatedAmount) as SumOfObligatedAmount
from contractor.DunsnumberToParentContractorHistory dtpch
inner join contractor.ParentContractor pid
on pid.parentid=dtpch.parentid
inner join contractor.Dunsnumber duns
on dtpch.DUNSnumber=duns.DUNSnumber
where pid.parentheadquarterscountrycode='CAN'
group by pid.parentid
order by pid.parentid