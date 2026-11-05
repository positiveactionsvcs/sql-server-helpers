Declare @SQL nvarchar(max)
While Exists(Select *  From sysobjects where name like 'DF%' and parent_obj = object_id('Assessments'))
Begin
 Set @SQL = 'ALTER TABLE [dbo].[Assessments] DROP CONSTRAINT [' + (Select Top 1 Name From sysobjects where name like 'DF%' and parent_obj = object_id('Assessments')) + ']'
 Exec (@SQL)
End