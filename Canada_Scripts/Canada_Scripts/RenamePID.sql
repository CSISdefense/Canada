USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = [Vendor].[SP_RenameParentID]
		@oldparentid = N'ULTRA ELECTRONICS ADVANCED TACTICAL SYSTEMS',
		@newparentid = N'ULTRA ELECTRONICS'

SELECT	'Return Value' = @return_value

GO
