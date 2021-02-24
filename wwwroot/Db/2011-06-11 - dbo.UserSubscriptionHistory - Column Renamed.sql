

/*

Date:        2011-06-11

Description: Renaming column Id to SubscriptionHistoryId in table dbo.UserSubscriptionHistory.

*/

EXEC sp_rename 
    @objname = 'dbo.UserSubscriptionHistory.Id', 
    @newname = 'SubscriptionHistoryId', 
    @objtype = 'COLUMN'

go

