USE [DIIG]
GO

DECLARE	@return_value int

EXEC	 [Vendor].[sp_AssignParentID]
		@dunsnumber = N'836415851',
		@parentid = N'ULTRA ELECTRONICS',
		@startyear = 2009,
		@endyear = 2016

--EXEC	[Vendor].[sp_AssignParentID]
--		@dunsnumber = N'95015933F',
--		@parentid = N'UNISYS',
--		@startyear = 1990,
--		@endyear = 1995

		
--EXEC	[Vendor].[sp_AssignParentID]
--		@dunsnumber = N'00924173J',
--		@parentid = N'LOCKHEED MARTIN',
--		@startyear = 1996,
--		@endyear = 2016

		

SELECT	'Return Value' = @return_value

GO
