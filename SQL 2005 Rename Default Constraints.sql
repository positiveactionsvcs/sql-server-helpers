declare @defaultName varchar(255)
declare @tableName varchar(255)
declare @columnName varchar(255)
declare @newDefaultName varchar(255)

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

Open curDefaultList

fetch next from curDefaultList into @defaultName, @tableName, @columnName
while @@fetch_status = 0
begin
	select @newDefaultName = 'DF_' + @tableName + '_' + @columnName
	exec sp_rename @defaultName, @newDefaultName, 'OBJECT'
	fetch next from curDefaultList into @defaultName, @tableName, @columnName
end

close curDefaultList
deallocate curDefaultList