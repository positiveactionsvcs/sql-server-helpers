-- Drop all Constraints, Primary and Foreign Keys and Indexes.  Requires correct prefixes!!

Declare @SQL nvarchar(max)
Declare @tableName nvarchar(50)

Declare curTableList Cursor Local For
	Select name From sysobjects Where xtype='U' And Name not in ('dtproperties','sysdiagrams') Order By name

Print ''
Print 'Dropping Defaults'
Print ''

Open curTableList

Fetch Next From curTableList Into @tableName
While @@Fetch_Status = 0
Begin
	While Exists(Select *  From sysobjects where name like 'DF%' and parent_obj = object_id(@tableName))
	Begin
		Set @SQL = 'ALTER TABLE [dbo].['+@tableName+'] DROP CONSTRAINT [' + (Select Top 1 Name From sysobjects where name like 'DF%' and parent_obj = object_id(@tableName)) + ']'
		Print (@SQL)
		Exec (@SQL)
	End
	Fetch Next From curTableList Into @tableName
End

Close curTableList

Print ''
Print 'Dropping Foreign Keys'
Print ''

Open curTableList

Fetch Next From curTableList Into @tableName
While @@Fetch_Status = 0
Begin
	While Exists(Select *  From sysobjects where name like 'FK%' and parent_obj = object_id(@tableName))
	Begin
		Set @SQL = 'ALTER TABLE [dbo].['+@tableName+'] DROP CONSTRAINT [' + (Select Top 1 Name From sysobjects where name like 'FK%' and parent_obj = object_id(@tableName)) + ']'
		Print (@SQL)
		Exec (@SQL)
	End
	Fetch Next From curTableList Into @tableName
End

Close curTableList

Print ''
Print 'Dropping Primary Keys'
Print ''

Open curTableList

Fetch Next From curTableList Into @tableName
While @@Fetch_Status = 0
Begin
	While Exists(Select *  From sysobjects where name like 'PK%' and parent_obj = object_id(@tableName))
	Begin
		Set @SQL = 'ALTER TABLE [dbo].['+@tableName+'] DROP CONSTRAINT [' + (Select Top 1 Name From sysobjects where name like 'PK%' and parent_obj = object_id(@tableName)) + ']'
		Print (@SQL)
		Exec (@SQL)
	End
	Fetch Next From curTableList Into @tableName
End

Close curTableList

Print ''
Print 'Dropping Indexes'
Print ''

Open curTableList

Fetch Next From curTableList Into @tableName
While @@Fetch_Status = 0
Begin
	While Exists(Select *  From sysindexes where name is not null and id = object_id(@tableName) and status & 64=0)
	Begin
		Set @SQL = 'DROP INDEX ' + (Select Top 1 Name From sysindexes where  name is not null and id = object_id(@tableName) and status & 64=0) + ' ON [dbo].['+@tableName+']'
		Print (@SQL)
		Exec (@SQL)
	End
	Fetch Next From curTableList Into @tableName
End

Close curTableList
Deallocate curTableList
