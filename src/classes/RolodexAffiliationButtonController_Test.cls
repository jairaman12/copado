/*
* This is the test class of RolodexAffiliationButtonController.apxc
* Developer: Laxman Vattam
* Date: 04/12/2019
*/
@isTest
public class RolodexAffiliationButtonController_Test {
  
    private static Account testAccount;

    @testSetup static void createTestData() {        
    	TestDataFactory tdf = new TestDataFactory();        
        TestDataFactory.prepareData();
        TestDataFactory.CreateRecordTypeSettings();
        testAccount = TestDataFactory.CreateAccount('IL1'); 
        
        affiliations__c aff = new affiliations__c(); 
        aff.CM_Affiliated_Provider_Name__c      = testAccount.Id;
        insert aff;
    }
    
    static testmethod void RolodexAffiliationTest() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Affiliations__c aff = [SELECT Id FROM affiliations__c LIMIT 1];
        List<User> illinoisUser = TestCaseUtil.createUser('Supervisor', 'Illinois Supervisor', 1);
        insert illinoisUser;
        Test.startTest();        
        RolodexAffiliationButtonController.getRolodexAffiliationUrl(illinoisUser[0].Id, acc.Id, 'Account');
        RolodexAffiliationButtonController.getRolodexAffiliationUrl(illinoisUser[0].Id, aff.Id, 'Affiliations__c');
        Test.stopTest();
        
    }
    
}