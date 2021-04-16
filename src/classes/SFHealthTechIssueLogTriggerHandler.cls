/**
* Handles trigger logic for SFHealthTechIssueLog__c.
* <p /><p />
* @author Josh McGhee
*/
public with sharing class SFHealthTechIssueLogTriggerHandler {
    
    /**
	* Method is used to handle the Before Insert event on SFHealthTechIssueLog Trigger.
	* Finds the ID for the SFHealthTechIssueLog Queue and assigns ownership of the record 
	* to that queue.
	*
	* @param lstInsertedLog indicates the Trigger.New list from the trigger
	*/
    public static void beforeInsert(List<SFHealthTechIssueLog__c> lstInsertedLog) {

        Id idQueue = [SELECT DeveloperName,Id,Name,Type FROM Group WHERE 
                                 Type = 'Queue' and DeveloperName = 'SFHealthTechIssueLog' LIMIT 1].Id;
     
        for (SFHealthTechIssueLog__c objNewLog : lstInsertedLog) {
            objNewLog.OwnerId = idQueue;
        }
    }    

    /**
	* Method is used to handle the Before Update event on SFHealthTechIssueLog Trigger.
	* Creates new SFHealthTechIssueLogHistory records for each update to the Issue 
	* Summary field, and prevents changes to fields without proper permissions.
	*
	* @param lstUpdatedLog and mapTrigger indicate the Trigger.New list and Trigger.oldMap map
	* from the trigger, respectively.
	*/
    public static void beforeUpdate(List<SFHealthTechIssueLog__c> lstUpdatedLog, Map<Id, SFHealthTechIssueLog__c> mapTrigger) {
        
        String strRecordTypeDeveloperName;
        String strProfileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
        String strPermissionError = 'You do not have permission to change this field.';
        List<SFHealthTechIssueLogHistory__c> lstHistoryToInsert = new List<SFHealthTechIssueLogHistory__c>();
        Map<ID, Schema.RecordTypeInfo> mapRecordType = Schema.SObjectType.SFHealthTechIssueLog__c.getRecordTypeInfosById();
        
        //Loops through the list of updated Issue Logs passed to the method.
        for (SFHealthTechIssueLog__c objNewLog : lstUpdatedLog) {
            
            //Access the "old" record by its ID in mapTrigger.
            SFHealthTechIssueLog__c objOldLog = mapTrigger.get(objNewLog.Id);
            
            //Gets the Record Type Name of the current Issue Log. 
            strRecordTypeDeveloperName = mapRecordType.get(objNewLog.RecordTypeId).getDeveloperName();
            
            //Checks that the Record Type Name is correct and that the old record exists.
            if(strRecordTypeDeveloperName == 'SFHealthTechIssueLog' && objOldLog != null) {
                
                //Only runs the following block of code if the user is neither SysAdmin nor Integration.
                if (strProfileName != 'System Administrator' && strProfileName != 'Integration') {
                    
                    //Checks whether the user attempted to change any fields for which they lack permissions.
                    if(objOldLog.IssueType__c != objNewLog.IssueType__c) {
                        objNewLog.IssueType__c.addError(strPermissionError);
                    }
                    if(objOldLog.OwnerId != objNewLog.OwnerId) {
                        objNewLog.OwnerId.addError(strPermissionError);
                    }
                    if(objOldLog.ReportedState__c != objNewLog.ReportedState__c) {
                        objNewLog.ReportedState__c.addError(strPermissionError);
                    }
                    if(objOldLog.ImpactedAreas__c != objNewLog.ImpactedAreas__c) {
                        objNewLog.ImpactedAreas__c.addError(strPermissionError);
                    }
                    if(objOldLog.Status__c != objNewLog.Status__c) {
                        objNewLog.Status__c.addError(strPermissionError);
                    }
                    if(objOldLog.JiraURL__c != objNewLog.JiraURL__c) {
                        objNewLog.JiraURL__c.addError(strPermissionError);
                    }
                    if(objOldLog.RecordTypeId != objNewLog.RecordTypeId) {
                        objNewLog.RecordTypeId.addError(strPermissionError);
                    }
                    if(objOldLog.Impact__c != objNewLog.Impact__c) {
                        objNewLog.Impact__c.addError(strPermissionError);
                    }
                }
                
                //If the new Issue Summary contents do not match the old contents, a history is created
                if(objOldLog.IssueSummary__c != objNewLog.IssueSummary__c){
                    SFHealthTechIssueLogHistory__c objHistory = new SFHealthTechIssueLogHistory__c();
                    
                    objHistory.Name = objNewLog.Name;
                    objHistory.Date__c = System.now();
                    objHistory.Field__c = 'Issue Summary';
                    objHistory.User__c = UserInfo.getUserId();
                    objHistory.OriginalValue__c = objOldLog.IssueSummary__c;
                    objHistory.NewValue__c = objNewLog.IssueSummary__c;
                    objHistory.SFHealthTechIssueLog__c = objNewLog.Id;
                    
                    lstHistoryToInsert.add(objHistory);
                }
            }
        }
        
        //Inserts SF Health Tech Issue Log History object if available.
        if(!lstHistoryToInsert.isEmpty()) {
            insert lstHistoryToInsert;
        }
    }
}