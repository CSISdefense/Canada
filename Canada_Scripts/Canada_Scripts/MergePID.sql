USE [DIIG]
GO

DECLARE	@return_value int

EXEC	@return_value = vendor.SP_MergeParentId
		@oldParentID = N'ULTRA ELECTRONICS HOLDINGS PLC',
		@mergedParentID = N'ULTRA ELECTRONICS ADVANCED TACTICAL SYSTEMS'

SELECT	'Return Value' = @return_value

GO
