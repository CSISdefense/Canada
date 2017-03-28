USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[sp_AssignSubsidiaryStatus]
		@parentidOfSubsidiary = N'EARTH SATELLITE',
		@MergerDate = N'2/01/2002',
		@MergerURL = N'http://www.defense-aerospace.com/articles-view/release/3/8512/mda-acquires-earth-satellite-corp-(feb.-4).html',
		@parentidOfOwner = N'MDA'

SELECT	'Return Value' = @return_value

GO
