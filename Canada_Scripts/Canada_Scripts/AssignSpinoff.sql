USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_AssignSpinoffStatus]
		@parentid = N'RADARSAT INTERNATIONAL',
		@FirstDate = N'2/26/1999',
		@FirstURL = N'http://mdacorporation.com/news/pr/pr1999022601.html',
		@SpunOffFrom = N'MDA'

SELECT	'Return Value' = @return_value

GO
