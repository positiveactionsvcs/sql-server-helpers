SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER   Procedure [dbo].[sp_backupalldbs](@backuppath varchar(256), @dbnamefilter varchar(256)='%')
As
	Declare @dbname nvarchar(50)
	Declare @bakpath varchar(256)
	Declare @date varchar(30)
	Declare @SQL varchar(8000)

	Select	@bakpath=@backuppath+case when right(@backuppath,1)='\' then '' else '\' end,
			@date=right('0'+datename(d,getdate()),2)+'-'+left(datename(mm,getdate()),3)+'-'+datename(yyyy,getdate())

	Declare dblist cursor local for
		select 	name 
		from 	sysdatabases 
		where 	
			(((sid!=1) and (@dbnamefilter='%')) or 
			(@dbnamefilter<>'%')) and (name like @dbnamefilter)

	Open dblist

	Fetch Next From dblist into @dbname

	While @@fetch_status=0
	Begin
		
		print 'Backing up database ' + @dbname

		Set @SQL='backup database [' + @dbname + '] to '
		Set @SQL=@SQL+'disk=N'''+@bakpath+@dbname+' '+@date+'.bak'' with noformat, init, '
		Set @SQL=@SQL+' name=N''' + @dbname + ' - full backup '+@date + ''', skip, norewind, nounload, stats=10'

		print @sql

		exec (@SQL)

		Fetch Next From dblist into @dbname
	End

	close dblist

	deallocate dblist

	print 'Backup complete.'

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

