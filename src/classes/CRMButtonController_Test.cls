/*
* Used to test the desktop version of the Lightning CRM Creation button.
* Developer: Travis Self
* Date: 01/29/2019
*/
@isTest
public class CRMButtonController_Test {
    
    private static Account testAccount;

	@testSetup static void createTestData() {
        
    	TestDataFactory tdf = new TestDataFactory();
        
        TestDataFactory.prepareData();
        
        testAccount = TestDataFactory.CreateAccount('IL1');
        
        CM_SPL_Addr__c serviceAndPayee = new CM_SPL_Addr__c();
        serviceAndPayee.CM_Corporate_Entity_Code__c = 'IL1';
        serviceAndPayee.CM_SPL_PFIN_No__c = '0IL12345';
        serviceAndPayee.Bill_PFIN__c = '0IL12345';
        serviceAndPayee.CM_SPL_Prov__r = testAccount;
        insert serviceAndPayee;
      
        List<Case> caseRecs = tdf.OnCreateCaseData(5,'IL1');
        caseRecs[0].RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Email' LIMIT 1].Id;	//Test CRM From Email-to-Case w/ Physician Account	
        caseRecs[0].AccountId = testAccount.Id;
        caseRecs[1].RecordTypeId = caseRecs[0].RecordTypeId;		//Test CRM From Email-to-Case w/ Entity Account	& Case Closed
        caseRecs[1].Case_Entity__c = testAccount.Id;
        caseRecs[1].Status = 'Closed';
        caseRecs[2].RecordTypeId = caseRecs[0].RecordTypeId;		//Test CRM From Email-to-Case w/o any account attached
        caseRecs[3].AccountId = testAccount.Id;						//Test CRM From Email-to-Case w/o both a Physician and Entity attached
        caseRecs[3].Case_Entity__c = testAccount.Id;
        caseRecs[4].Case_Entity__c = testAccount.Id; 				//Test CRM From Email-to-Case w Entity Account
        insert caseRecs; 
		
    }
    
    static testmethod void CRMTest() {
        
        List<User> supUser = TestCaseUtil.createUser('Supervisor', 'Illinois Supervisor', 1);
        insert supUser;
        List<User> dataRepUser = TestCaseUtil.createUser('Provider Data Rep', 'Provider Data Rep- IL', 1);
        insert dataRepUser;
        Account acc = [SELECT Id FROM Account LIMIT 1];
        CM_SPL_Addr__c serviceAndPayee = [SELECT Id, Bill_PFIN__c FROM CM_SPL_Addr__c LIMIT 1];
        List<Case> caseRecs = [SELECT Id FROM Case LIMIT 5];
        
        Test.startTest();
        
        	LtngCtrlCRMCase.getCRMUrl(acc.Id, 'Account', supUser[0].Id);						//Test CRM From Account w/ valid Role
            LtngCtrlCRMCase.getCRMUrl(acc.Id, 'Account', dataRepUser[0].Id);					//Test CRM From Account w/ invalid Role
        	LtngCtrlCRMCase.getCRMUrl(serviceAndPayee.Id, 'CM_SPL_Addr__c',supUser[0].Id);		//Test CRM From Service & Payee Location Address
        
            /* Testing all the different combinations of cases manual adc can be launched from */
            for(Case caseRec : caseRecs) {
                LtngCtrlCRMCase.getCRMUrl(caseRec.Id, 'Case', supUser[0].Id);	
            }				
        	
        Test.stopTest();
        
    }
}