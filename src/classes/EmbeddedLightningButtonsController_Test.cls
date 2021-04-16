/*
* This is the test class of EmbeddedLightningButtonsController.apxc
* Developer: Travis Self
* Date: 04/08/2019
*/
@isTest
public class EmbeddedLightningButtonsController_Test {
    
    private static Account testAccount;
    
    @testSetup static void createTestData() { 
        
    	TestDataFactory tdf = new TestDataFactory();
        
        // Create test Account
        TestDataFactory.prepareData();
        TestDataFactory.CreateRecordTypeSettings();
        testAccount = TestDataFactory.CreateAccount('IL1');
        
        // Create test Case
        List<Case> caseRecs = tdf.OnCreateCaseData(1,'IL1');
        caseRecs[0].RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Email' LIMIT 1].Id;
        caseRecs[0].AccountId = testAccount.Id;
        insert caseRecs;

    }

    static testmethod void buttonsTest() {
      	
        // Create test User
        List<User> illinoisUser = TestCaseUtil.createUser('Supervisor', 'Illinois Supervisor', 1);
        insert illinoisUser;
        
        // Get created test Case
        List<Case> caseRecs = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        
        	EmbeddedLightningButtonsController.getUrlBasedOnButtonSelected(caseRecs[0].Id, 'Case', illinoisUser[0].Id, 'CRM');				//CRM Button Clicked Test
        	EmbeddedLightningButtonsController.getUrlBasedOnButtonSelected(caseRecs[0].Id, 'Case', illinoisUser[0].Id, 'Manual ADC');		//Manual ADC Button Clicked Test
        	EmbeddedLightningButtonsController.getUrlBasedOnButtonSelected(caseRecs[0].Id, 'Case', illinoisUser[0].Id, ' ');				//null 
        
        Test.stopTest();
        
    }
    
}