CREATE view Errorlogging.PrimaryKeyList
as 

SELECT i.name AS pk_index_name,
	SCHEMA_NAME(schema_id) AS SchemaName,
	OBJECT_NAME(parent_object_id) AS TableName,
    c.name AS column_name,    
	t.DATA_TYPE,
	t.CHARACTER_MAXIMUM_LENGTH,
	c.is_identity
FROM sys.indexes i
    inner join sys.index_columns ic 
	 ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    inner join sys.columns c 
	ON ic.object_id = c.object_id AND c.column_id = ic.column_id
	inner join sys.objects s 
	ON i.name=OBJECT_NAME(s.OBJECT_ID)
	inner join INFORMATION_SCHEMA.COLUMNS t
on t.TABLE_SCHEMA=SCHEMA_NAME(schema_id) 
     and t.TABLE_NAME = OBJECT_NAME(parent_object_id)
	  AND COLUMN_NAME = OBJECT_NAME(parent_object_id)
WHERE i.is_primary_key = 1 and s.type_desc IN ('PRIMARY_KEY_CONSTRAINT')
    --and i.object_ID = OBJECT_ID('<schema>.<tablename>')
ORDER BY SchemaName,
pk_index_name,
column_name

--Source list
--http://stackoverflow.com/questions/13405572/sql-statement-to-get-column-type
--http://stackoverflow.com/questions/95967/how-do-you-list-the-primary-key-of-a-sql-server-table

GO
