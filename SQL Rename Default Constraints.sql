declare @tableName sysname
declare @columnName sysname
declare @oldName sysname
declare @newName sysname

declare curDefaultList cursor local for
	select 
		s.name, t.name, c.name
	from 
		sysobjects s 
	inner join
		sysobjects t on t.id = s.parent_obj
	inner join
		syscolumns c on c.cdefault = s.id
	where 
		s.xtype = 'D' 
	and 
		s.parent_obj 
	in 
		(select id from sysobjects Where xtype = 'U')

open curDefaultList

fetch next from curDefaultList into @oldName, @tableName, @columnName
while @@fetch_status = 0
begin
	select @newName = 'DF_' + @tableName + '_' + @columnName

	if @oldName != @newName
	begin
		print 'Rename ' + @oldName + ' to ' + @newName
		exec sp_rename @oldName, @newName, 'OBJECT'
	end

	fetch next from curDefaultList into @oldName, @tableName, @columnName
end

close curDefaultList
deallocate curDefaultList