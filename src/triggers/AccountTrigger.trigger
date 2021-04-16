/****************************************************************
@Author      : Provider Intake Salesforce team 
@Date        : 28/06/2018
@Description : Account Trigger
*******************************************************
SI.No       Author                Modification Comments
1          Saravana Bharathi      Userstory PPN-13033 Changes
2          Laxman Vattam          PPN-30575 - Update Network Load case Account based on Prov id
3          Ashok N                PPN-30357 
******************************************************************/
trigger AccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{  
     Boolean isTriggerOff = GlobalSettings__c.getvalues('PFFileRecieved').Account_Trigger_Switch__c;
     AccountTriggerHandler AccountHandler = new AccountTriggerHandler();
        if( isTriggerOff == false )
        {
            TriggerFactory.createHandler(Account.sObjectType);
        }
    
     if(Trigger.Isinsert && Trigger.isAfter)
        {
            if(AvoidRecursion.isaccTriggerfirstRun())
              AccountHandler.updateAccountonNetworkLoadCases(Trigger.NewMap, Trigger.New);        
        }

/*
Author :Ashok N
@date : 2.25.2019
Business purpouse : to create the comments in history tracking
PPN-30357 
*/
if(Trigger.Isupdate && Trigger.isAfter)
{
//AccountHandler.CommentHistoryTracking(Trigger.OldMap, Trigger.NewMap);        
}  
}