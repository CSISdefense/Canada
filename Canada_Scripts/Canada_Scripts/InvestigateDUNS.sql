USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_InvestigateDunsnumber]
		@dunsnumber = N'836415851'

SELECT	'Return Value' = @return_value

GO
	