USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_InvestigateParentID]
		@parentid = N'ULTRA ELECTRONICS'

SELECT	'Return Value' = @return_value

GO

--CAE