USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_CreateParentIDstandardizedVendorName]
		@standardizedVendorName = N'DigitalGlobe',
		@parentid = N'DigitalGlobe',
		@startyear = 1990,
		@endyear = 2016

SELECT	'Return Value' = @return_value

GO
