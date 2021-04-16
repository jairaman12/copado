@isTest
public class CaseStatusController_test {
    
    private static Account testAccount;
    
    @testSetup static void createTestData(){        
        TestDataFactory tdf = new TestDataFactory();        
        TestDataFactory.prepareData();        
        testAccount = TestDataFactory.CreateAccount('IL1');  
        List<Case> caseRecs = tdf.OnCreateCaseData(3,'IL1');
        caseRecs[0].RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Email' LIMIT 1].Id;   //Test CRM From Email-to-Case w/ Physician Account  
        caseRecs[0].AccountId = testAccount.Id;
        caseRecs[0].Subject = 'test';
        caseRecs[0].Status = 'Closed';
        caseRecs[0].Plan_Id__c = 'IL1';
        caseRecs[1].RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Master_Provider_Case_data' LIMIT 1].Id;   //Test CRM From Email-to-Case w/ Physician Account  
        caseRecs[1].AccountId = testAccount.Id;
        caseRecs[1].Subject = 'test';
        caseRecs[1].Status = 'Closed Processed';
        caseRecs[1].Plan_Id__c = 'TX1';
        caseRecs[2].RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Provider_On_boarding' LIMIT 1].Id;    //Test CRM From Email-to-Case w/ Physician Account  
        caseRecs[2].AccountId = testAccount.Id;
        caseRecs[2].Subject = 'test';
        caseRecs[2].Status = 'Closed Rejected';
        caseRecs[2].Plan_Id__c = 'MT1';
        insert caseRecs;        
    }
    
    static testmethod void CaseStatusTest(){
        List<Case> caseRecs = [SELECT Id,casenumber FROM Case LIMIT 3];
        
        Test.startTest();
        CaseStatusController.fetchData(integer.valueof(caseRecs[0].casenumber));
        CaseStatusController.fetchData(integer.valueof(caseRecs[1].casenumber));
        CaseStatusController.fetchData(integer.valueof(caseRecs[2].casenumber));        
        Test.stopTest();
    }

}