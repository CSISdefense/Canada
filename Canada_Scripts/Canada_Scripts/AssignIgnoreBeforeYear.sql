USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_AssignIgnoreBeforeYear]
		@dunsnumber = N'18858569K',
		@ignorebeforeyear = 1996,
		@ignorebeforeyearurl = N'https://en.wikipedia.org/wiki/Loral_Corporation'

SELECT	'Return Value' = @return_value

GO
