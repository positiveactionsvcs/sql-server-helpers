ALTER PROCEDURE [dbo].[usp_TrainingRequestUsers_UpdateMultiple]
	@pTrainingRequestUserList ntext
AS
	set nocount on

	/* Store handles to XML document */
	declare @TrainingRequestUsersXML int

	/* Prepare documents to OpenXML */
	exec sp_xml_preparedocument @TrainingRequestUsersXML output, @pTrainingRequestUserList

	/* Insert users if the TrainingRequestID/UserID combination does not exist already */
	insert into
		tblTrainingRequestUsers
	select 
		TrainingRequestID, UserID, LocationID, '1', CacheData 
			from openxml (@TrainingRequestUsersXML, '/TrainingRequestUsers/TrainingRequestUser', 2)
	with (
		TrainingRequestID int 'TrainingRequestID/@ID', 
		UserID varchar(32) 'UserID/@ID',
		LocationID int 'LocationID/@ID',
		CacheData varchar(100) 'CacheData/@value') TRU
	where not exists
		(select * from tblTrainingRequestUsers 
			where TrainingRequestID = TRU.TrainingRequestID
			and UserID = TRU.UserID)
	
	/* Update data already where TrainingRequestID/UserID combination already exists */
	update
		tblTrainingRequestUsers
	set
		tblTrainingRequestUsers.LocationID = TRU.LocationID,
		tblTrainingRequestUsers.CacheData = TRU.CacheData
	from 
		openxml (@TrainingRequestUsersXML, '/TrainingRequestUsers/TrainingRequestUser', 2)
	with (
		TrainingRequestID int 'TrainingRequestID/@ID', 
		UserID varchar(32) 'UserID/@ID',
		LocationID int 'LocationID/@ID',
		CacheData varchar(100) 'CacheData/@value') TRU
	where
		tblTrainingRequestUsers.TrainingRequestID = TRU.TrainingRequestID
	and
		tblTrainingRequestUsers.UserID = TRU.UserID

	/* Clean up */
	exec sp_xml_removedocument @TrainingRequestUsersXML