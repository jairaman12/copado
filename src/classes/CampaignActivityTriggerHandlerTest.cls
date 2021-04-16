/**
 * This is the test class for the Campaign Activity Trigger and Handler
 * <p/><p/>
 * @author Travis Self
 */
@isTest
public class CampaignActivityTriggerHandlerTest {

	@testSetup static void createTestData() {
        
        TestDataFactory tdf = new TestDataFactory();
        TestDataFactory.prepareData();
        
        // Create a non-rolodex account
        Account testAccount = TestDataFactory.CreateAccount('IL1');
        
        // Create 3 service & payee locations
        List<CM_SPL_Addr__c> lstServiceAndPayee = new List<CM_SPL_Addr__c>();
        CM_SPL_Addr__c svp = new CM_SPL_Addr__c();
        svp.CM_Corporate_Entity_Code__c = 'IL1';
        svp.CM_SPL_PFIN_No__c = '0IL12345';
        svp.Bill_PFIN__c = '0IL12345';
        svp.CM_SPL_Prov__r = testAccount;
        svp.CM_SPL_Addr_Type__c = 'Service';
        svp.CM_SPL_Email__c = 'travis_self@bcbsok.com';
        lstServiceAndPayee.add(svp);
        lstServiceAndPayee.add(svp.clone());
        lstServiceAndPayee.add(svp.clone());
        insert lstServiceAndPayee;
        
        // Create a rolodex account
        Account rolodexAcc = new Account();
        rolodexAcc.LastName = 'Test';
        rolodexAcc.PersonEmail = 'travis_self@bcbsok.com';
        rolodexAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rolodex').getRecordTypeId();
        rolodexAcc.Phone = '9185512503';
        rolodexAcc.Type = 'Individual';
        rolodexAcc.Tax_Id__c = '123456789';
        rolodexAcc.NPI__c = '0123456789';
        rolodexAcc.CM_Corporate_Entity_Code__c = 'IL1';
        insert rolodexAcc;
        
        // Create a campaign
        Campaign testCampaign = new Campaign();
        testCampaign.Name = 'IL Blue Review';
        testCampaign.Description = 'This is a test campaign.';
        testCampaign.CorporateEntityCode__c = 'IL1';
        testCampaign.IsActive = true;
        testCampaign.StartDate = Date.today();
        testCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('MarketingCloud').getRecordTypeId();
        insert testCampaign;
    }
    
    @isTest
    static void campaignActivityCloneTest() {
        
        List<CampaignActivity__c> lstCampaignActivities = createCampaignActivities(1);
        
        Test.startTest();
        
        	insert lstCampaignActivities;
        
        Test.stopTest();
        
        System.assertEquals(4, [SELECT count() FROM CampaignActivity__c]);
        
        delete lstCampaignActivities;
    }
    
    @isTest
    static void campaignActivityBulkTriggerTest() {
        
        List<CampaignActivity__c> lstCampaignActivities = createCampaignActivities(1000);
        
        Test.startTest();
        
        	insert lstCampaignActivities;
        
        Test.stopTest();
        
        System.assertEquals(1000, [SELECT count() FROM CampaignActivity__c WHERE CreatedFromMarketingCloud__c = true]);
    }
    
   /**
    * This method will start the creation of campaign history activities
    * 
    * @param numToCreate Number of campaign activities to create
    * @return List of campaign activities
    */ 
    static List<CampaignActivity__c> createCampaignActivities(Integer numToCreate) {
        
        Account testAccount = [SELECT Id FROM Account WHERE NOT(RecordType.DeveloperName = 'Rolodex') LIMIT 1];
        CM_SPL_Addr__c testServiceAndPayee = [SELECT Id FROM CM_SPL_Addr__c LIMIT 1];
        Campaign testCampaign = [SELECT Id FROM Campaign LIMIT 1];
        
        List<CampaignActivity__c> lstCampaignActivities = new List<CampaignActivity__c>();
        
        for(Integer i=0; i < numToCreate; i++) {
            CampaignActivity__c testCampaignActivity = new CampaignActivity__c();
            testCampaignActivity.ActivityDescription__c = 'Email Sent' + i;
            testCampaignActivity.CorporateEntityCode__c = 'IL1';
            testCampaignActivity.CampaignActivityLevel__c = 'Service & Payee Location Address';
            testCampaignActivity.CampaignName__c = testCampaign.Id;
            testCampaignActivity.Date__c = Date.today();
            testCampaignActivity.SentTo__c = 'travis_self@bcbsok.com';
            testCampaignActivity.CreateAtRolodexAcctwithSameEmail__c = true;
            testCampaignActivity.CreateAtServiceLocWithSameEmail__c = true;
            testCampaignActivity.CreatedFromMarketingCloud__c = true;
            testCampaignActivity.AccountName__c = testAccount.Id;
            testCampaignActivity.ServiceAndPayeeLocationAddress__c = testServiceAndPayee.Id;
            lstCampaignActivities.add(testCampaignActivity);
        }
        
        return lstCampaignActivities;
    }   
}