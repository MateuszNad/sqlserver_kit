# # # # # # Links - - [Safely Dropping Unused SQL Server Indexes](
    https: / / www.mssqltips.com / sqlservertip / 5202 / safely - dropping - unused - sql - server - indexes /
): Ciekawy wpis kt ó ry porusza kwestie usuwania nieu ż ywanych indeks ó w i problem ó w z kt ó rymi trzeba si ę zmierzy ć    i.[name],
    i.index_id,
    i.[type_desc],
    i.is_primary_key,
    i.is_unique,
    i.is_unique_constraint,
    iu.user_seeks,
    iu.user_scans,
    iu.user_lookups,
    iu.user_updates,
    iu.user_seeks + iu.user_scans + iu.user_lookups AS total_uses,
    CASE WHEN (iu.user_seeks + iu.user_scans + iu.user_lookups) > 0
        THEN iu.user_updates/( iu.user_seeks + iu.user_scans + iu.user_lookups )
        ELSE iu.user_updates END AS update_to_use_ratio
FROM sys.dm_db_index_usage_stats iu
    RIGHT JOIN sys.indexes i ON iu.index_id = i.index_id AND iu.[object_id] = i.[object_id]
WHERE 
   OBJECTPROPERTY(iu.[object_id], 'IsUserTable') = 1
    AND iu.database_id = DB_ID()
ORDER BY 
   CASE WHEN (iu.user_seeks + iu.user_scans + iu.user_lookups) > 0
        THEN iu.user_updates/( iu.user_seeks + iu.user_scans + iu.user_lookups )
        ELSE iu.user_updates END DESC 