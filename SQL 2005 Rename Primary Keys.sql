declare @defaultName varchar(255)
declare @tableName varchar(255)
declare @columnName varchar(255)
declare @newDefaultName varchar(255)

declare curDefaultList cursor local for
	select 
		s.name, t.name
	from 
		sysobjects s 
	inner join
		sysobjects t on t.id = s.parent_obj
	where 
		s.xtype = 'PK' 

Open curDefaultList

fetch next from curDefaultList into @defaultName, @tableName
while @@fetch_status = 0
begin
	select @newDefaultName = 'PK_' + @tableName
	select @defaultName, @newDefaultName
	exec sp_rename @defaultName, @newDefaultName, 'OBJECT'
	fetch next from curDefaultList into @defaultName, @tableName
end

close curDefaultList
deallocate curDefaultList