/*
* This is the test class of ManualADCButtonController.apxc
* Developer: Travis Self
* Date: 01/14/2019
*/
@isTest
public class ManualADCButtonController_Test {
    
    private static Account testAccount;

	@testSetup static void createTestData() {
        
    	TestDataFactory tdf = new TestDataFactory();
        
        TestDataFactory.prepareData();
        TestDataFactory.CreateRecordTypeSettings();
        testAccount = TestDataFactory.CreateAccount('IL1');
        
        List<CM_SPL_Addr__c> serviceAndPayeeRecs = new List<CM_SPL_Addr__c>();
        CM_SPL_Addr__c svp1 = new CM_SPL_Addr__c();
        CM_SPL_Addr__c svp2 = new CM_SPL_Addr__c();
        svp1.CM_Corporate_Entity_Code__c = 'IL1';
        svp1.CM_SPL_PFIN_No__c = '0IL12345';
        svp1.Bill_PFIN__c = '0IL12345';
        svp1.CM_SPL_Prov__r = testAccount;
        svp2.CM_Corporate_Entity_Code__c = 'IL1';
        svp2.CM_SPL_PFIN_No__c = '0IL12345';
        svp2.Bill_PFIN__c = '0IL111111';
        svp2.CM_SPL_Prov__r = testAccount;
        serviceAndPayeeRecs.add(svp1);
        serviceAndPayeeRecs.add(svp2);
        insert serviceAndPayeeRecs;
        
        List<Case> caseRecs = tdf.OnCreateCaseData(2,'IL1');
        caseRecs[0].RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Email' LIMIT 1].Id;
        caseRecs[0].AccountId = testAccount.Id;
        caseRecs[1].RecordTypeId = caseRecs[0].RecordTypeId;
        caseRecs[1].Case_Entity__c = testAccount.Id;
        insert caseRecs;
    }
    
    static testmethod void manualADCTest() {
        
        List<User> illinoisUser = TestCaseUtil.createUser('Supervisor', 'Illinois Supervisor', 1);
        insert illinoisUser;
        List<User> texasUser = TestCaseUtil.createUser('Supervisor', 'Texas Supervisor', 1);
        insert texasUser;
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<CM_SPL_Addr__c> serviceAndPayeeRecs = [SELECT Id FROM CM_SPL_Addr__c];
        List<Case> caseRecs = [SELECT Id FROM Case LIMIT 2];
        
        Test.startTest();
        
        	ManualADCButtonController.getManualADCUrl(illinoisUser[0].Id, acc.Id, 'Account');							//Test Manual ADC From Account w/ non-Texas Role
            ManualADCButtonController.getManualADCUrl(texasUser[0].Id, acc.Id, 'Account');								//Test Manual ADC From Account w/ Texas Role
        	ManualADCButtonController.getManualADCUrl(illinoisUser[0].Id, serviceAndPayeeRecs[0].Id, 'CM_SPL_Addr__c');	//Test Manual ADC From Service & Payee Location Address
        	ManualADCButtonController.getManualADCUrl(illinoisUser[0].Id, serviceAndPayeeRecs[1].Id, 'CM_SPL_Addr__c');	//Test Manual ADC From Service & Payee Location Address where pfin != bill pfin
        	ManualADCButtonController.getManualADCUrl(illinoisUser[0].Id, caseRecs[0].Id, 'Case');						//Test Manual ADC From Email-to-Case w/ Physician Account
        	ManualADCButtonController.getManualADCUrl(illinoisUser[0].Id, caseRecs[1].Id, 'Case');						//Test Manual ADC From Email-to-Case w/ Entity Account
        
        Test.stopTest();
        
    }
}