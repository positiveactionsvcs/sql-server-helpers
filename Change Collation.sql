declare
    @NewCollation varchar(255)
    ,@Stmt nvarchar(4000)
    ,@DBName sysname
set @NewCollation = 'Latin1_General_CI_AS' -- change this to the collation that you need
set @DBName = DB_NAME()
 
declare
    @CName varchar(255)
    ,@TName sysname
    ,@OName sysname
    ,@Sql varchar(8000)
    ,@Size int
    ,@Status tinyint
    ,@Colorder int
 
-- And fix DB collation alsos
Set @SQL = 'ALTER DATABASE ' + @DBName + ' COLLATE '+ @NewCollation
Exec (@sql)

declare curcolumns cursor read_only forward_only local
for select
       QUOTENAME(C.Name)
      ,T.Name
      ,QUOTENAME(U.Name) + '.' +QUOTENAME(O.Name)
      ,C.Prec
      ,C.isnullable
      ,C.colorder
    from syscolumns C
      inner join systypes T on C.xtype=T.xtype
      inner join sysobjects O on C.ID=O.ID
      inner join sysusers u on O.uid = u.uid
    where T.Name in ('varchar', 'char', 'text', 'nchar', 'nvarchar', 'ntext')
      and O.xtype in ('U')
	  and O.Name not in ('sysdiagrams')
      and C.collation != @NewCollation
    and objectProperty(O.ID, 'ismsshipped')=0
    order by 3, 1
 
open curcolumns
SET XACT_ABORT ON
begin tran
fetch curcolumns into @CName, @TName, @OName, @Size, @Status, @Colorder
while @@FETCH_STATUS =0
begin
  set @Sql='ALTER TABLE '+@OName+' ALTER COLUMN '+@CName+' '+@TName+ isnull ('('
+convert(varchar,@Size)+')', '') +' COLLATE '+ @NewCollation
+' '+case when @Status=1 then 'NULL' else 'NOT NULL' end
  exec(@Sql) -- change this to print if you need only the script, not the action
  fetch curcolumns into @CName, @TName, @OName, @Size, @Status, @Colorder
end
close curcolumns
deallocate curcolumns
commit tran