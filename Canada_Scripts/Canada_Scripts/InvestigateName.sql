USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_InvestigateStandardizedTopContractor]
		@StandardizedTopContractor = N'Space Systems'

SELECT	'Return Value' = @return_value

GO

