declare @oldName sysname
declare @newName sysname

declare rename_cursor cursor for
with AllFKs as (
	select distinct constraint_object_id, parent_object_id, referenced_object_id, min(parent_column_id) parent_column_id
	from sys.foreign_key_columns
group by
	constraint_object_id, parent_object_id, referenced_object_id
),
Relations as (
	select
		FK.name as Relation,
		P.name as Parent,
		R.name as Referenced,
		row_number() over(partition by P.Name, R.Name order by P.Name, R.Name, AllFKs.parent_column_id) Prog
    from AllFKs inner join
         sys.objects AS FK ON FK.object_id = AllFKs.constraint_object_id inner join
         sys.objects AS P ON AllFKs.parent_object_id = P.object_id inner join
         sys.objects AS R ON AllFKs.referenced_object_id = R.object_id
),
Transforms as (
	select Relation AS OldName, 'FK_'+ Parent + '_' + Referenced +
	case
        when exists (select * from Relations R2 where Prog > 1 AND R2.Parent = R1.Parent and R2.Referenced = R1.Referenced)
		then cast(Prog as nvarchar(2))
        else ''
		end NewName
	from Relations R1
)

select * from Transforms where NewName not in (select OldName from Transforms)

open rename_cursor
fetch next from rename_cursor into @oldName, @newName

while @@FETCH_STATUS = 0
begin
	if @oldName != @newName
	begin
		print 'Rename ' + @oldName + ' to ' + @newName
		exec sp_rename @oldName, @newName, 'OBJECT'
	end

	fetch next from rename_cursor into @oldName, @newName
end

close rename_cursor
deallocate rename_cursor