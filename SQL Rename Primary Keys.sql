declare @tableName sysname
declare @columnName sysname
declare @oldName sysname
declare @newName sysname

declare curDefaultList cursor local for
	select
		s.name, t.name
	from
		sysobjects s
	inner join
		sysobjects t on t.id = s.parent_obj
	where
		s.xtype = 'PK'

open curDefaultList
fetch next from curDefaultList into @oldName, @tableName

while @@fetch_status = 0
begin
	select @newName = 'PK_' + @tableName

	if @oldName != @newName
	begin
		print 'Rename ' + @oldName + ' to ' + @newName
		exec sp_rename @oldName, @newName, 'OBJECT'
	end

	fetch next from curDefaultList into @oldName, @tableName
end

close curDefaultList
deallocate curDefaultList