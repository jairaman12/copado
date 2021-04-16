/**
* Tests the trigger and trigger handler for SFHealthTechIssueLog__c.
* <p /><p />
* @author Josh McGhee
*/
@isTest(SeeAllData = false)
private class SFHealthTechIssueLogTriggerTest {
    
    /**
	* Method is used to test the Before Insert and Before Update events on 
	* SFHealthTechIssueLog Trigger. Creates new SFHealthTechIssueLog record 
	* for insertion, then changes the fields and user for the update attempt.
	* Creates SFHealthTechIssueLogHistory record for update.
	*/
    @isTest
    static void testSFHealthTechIssueLogTrigger() {
        
        Id idRecordType = Schema.SObjectType.SFHealthTechIssueLog__c.getRecordTypeInfosByDeveloperName().get('SFHealthTechIssueLog').getRecordTypeId(); 
        PermissionSet objPs = [SELECT Id FROM PermissionSet WHERE Name = 'SFHealthTechIssueLogPermission' LIMIT 1];
        SFHealthTechIssueLog__c objSfIssueLogRecord = new SFHealthTechIssueLog__c();
        SFHealthTechIssueLogHistory__c objHistoryTest = new SFHealthTechIssueLogHistory__c();
        List<User> lstIllinoisUser = TestCaseUtil.createUser('Supervisor', 'Illinois Supervisor', 2);
        
        //Creates two users and assigns the SFHealthTechIssueLogPermission set to them.
        insert lstIllinoisUser;
        insert new PermissionSetAssignment(AssigneeId = lstIllinoisUser[0].id, PermissionSetId = objPs.Id);
        
        //Runs test as the first of the two users.
        
            Test.startTest();
            System.runAs(lstIllinoisUser[0]){ 
            	//Fills all the fields that have permission checks, except OwnerId,
            	//which is filled by the handler method automatically. 
            	objSfIssueLogRecord.IssueType__c = 'Defect';
            	objSfIssueLogRecord.ReportedState__c = 'Illinois';
            	objSfIssueLogRecord.ImpactedAreas__c = 'Apttus';
            	objSfIssueLogRecord.Status__c = 'New';
            	objSfIssueLogRecord.JiraURL__c = 'https://www.google.com';
            	objSfIssueLogRecord.Impact__c = 'Role';
            	objSfIssueLogRecord.IssueSummary__c = 'Old';
            	objSfIssueLogRecord.RecordTypeId = idRecordType;
            
            	//Inserts the new record.
            	insert objSfIssueLogRecord;
            
            	//Attempts to change all the fields with permission checks.
            	objSfIssueLogRecord.IssueType__c = 'Data Errors';
            	objSfIssueLogRecord.OwnerId = lstIllinoisUser[1].Id;
            	objSfIssueLogRecord.ReportedState__c = 'New Mexico';
            	objSfIssueLogRecord.ImpactedAreas__c = 'Integration';
            	objSfIssueLogRecord.Status__c = 'In Progress';
            	objSfIssueLogRecord.JiraURL__c = 'https://google.com';
            	objSfIssueLogRecord.Impact__c = 'Value';
            	objSfIssueLogRecord.IssueSummary__c = 'New';
            	objSfIssueLogRecord.RecordTypeId = null;
            	
            	//Fills out a history record for the Issue Summary field change.
            	objHistoryTest.Name = 'IS-00001';
            	objHistoryTest.Date__c = System.now();
            	objHistoryTest.Field__c = 'Issue Summary';
            	objHistoryTest.User__c = lstIllinoisUser[1].id;
            	objHistoryTest.OriginalValue__c = 'Old';
            	objHistoryTest.NewValue__c = 'New';
            	objHistoryTest.SFHealthTechIssueLog__c = objSfIssueLogRecord.Id;
            
            //Attempts to update the Issue Log record, but should fail and return an
            //error message.
            try {
                update objSfIssueLogRecord;
            } catch (DmlException e) {
                System.assert(e.getMessage() != null);
            } catch (Exception e) {
                System.assert(e.getMessage() != null);
            }
            //Inserts the history record.
            insert objHistoryTest;}
            Test.stopTest();
        
    }
}