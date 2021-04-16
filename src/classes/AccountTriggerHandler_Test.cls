/**
 * This is the test class for the Account Trigger and Handler
 * <p/><p/>
 * @author Travis Self
 */
@isTest
public class AccountTriggerHandler_Test  {
    
    @testSetup static void createTestData() {
        
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.name = 'PFFileRecieved';
        gs.PFFileRecieved__c = false;
        gs.List_size__c = 10;
        gs.Account_trigger_switch__c = false;
        gs.Record_Type_Names__c = 'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        testclassdata.CreateCustomSettingData('Case');
        testclassdata.CreateCustomSettingData('Provider_Networks__c');
    
        Case netwkLoadCase = new Case();
        netwkLoadCase.recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
        netwkLoadCase.Plan_ID__c = 'IL1';
        netwkLoadCase.Status = 'New';
        netwkLoadCase.Prov_ID__c = '985415357';
        insert netwkLoadCase;
        
        Account newPhysicianAccount = new Account();
        newPhysicianAccount.LastName = 'Physician Account';
        newPhysicianAccount.recordTypeId=  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();
        newPhysicianAccount.CM_Corporate_Entity_Code__c = 'IL1';
        newPhysicianAccount.Prov_ID__c = '985415357';
        newPhysicianAccount.Class__c = 'P';
        
        insert newphysicianAccount;
        
        CM_Provider_Tax_Id__c newTax = new CM_Provider_Tax_Id__c();
        newTax.CM_PTI_Tax_Id__c = '123456789';
        newTax.CM_Corporate_Entity_Code__c = 'IL1';
        newTax.CM_PTI_Prov_Name_From__c = newPhysicianAccount.Id;
        
        CM_Provider_Identification__c newNPI = new CM_Provider_Identification__c();
        newNPI.CM_Prvdr_Iden_Typ_Cd__c = 'NPI';
        newNPI.CM_Issu_Ident_Nmbr__c ='1234567890';
        newNPI.CM_Corporate_Entity_Code__c = 'IL1';
        newNPI.CM_PI_Prov__c = newPhysicianAccount.Id;
        
        CM_SPL_Addr__c serviceAndPayeAddr = new CM_SPL_Addr__c();
        serviceAndPayeAddr.CM_Corporate_Entity_Code__c = 'IL1';
        serviceAndPayeAddr.CM_SPL_Addr_Type__c = 'Service';
        serviceAndPayeAddr.CM_SPL_Prov_Tax_ID__c = newTax.Id;
        serviceAndPayeAddr.CM_SPL_PFIN_No__c = '0IL6647980';
        serviceAndPayeAddr.Bill_PFIN__c = '0IL6647980';
        serviceAndPayeAddr.CM_SPL_Prov__c = newPhysicianAccount.Id;
                
        insert newTax;
        insert newNPI;
        insert serviceAndPayeAddr;
        createCaseTestData(newPhysicianAccount);
    }

    @isTest
    static void insertAndUpdateNonRolodexAccountsTest() {
        
        List<User> integrationUser = TestCaseUtil.createUser('Integration', 'Business Admin', 1);
        integrationUser[0].Alias = 'prov';
        
        insert integrationUser[0];
        
        List<Account> lstAccountsToInsert = new List<Account>();
        
        Account newPhysicianAccount = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Physician' LIMIT 1];
        lstAccountsToInsert.add(newPhysicianAccount);
        
        Account newEntityAccount = new Account();
        newEntityAccount.Name = 'Entity Account';
        newEntityAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Entity_Account').getRecordTypeId();
        newEntityAccount.CM_Corporate_Entity_Code__c = 'IL1';
        newEntityAccount.Prov_ID__c = '887744298';
        lstAccountsToInsert.add(newEntityAccount);
        
        Test.startTest();
        	System.runAs(integrationUser[0]) {
        		upsert lstAccountsToInsert;
    		}
        Test.stopTest();
    }
    
    @isTest
    static void insertAndUpdateRolodexAccountTest() {
        
        Account newRolodex = new Account();
        newRolodex.Rolodex_Account_for__c = 'Individual';
        newRolodex.FirstName = 'Rolodex';
        newRolodex.lastName = 'Account';
        newRolodex.Phone = '9185512503';
        newRolodex.PersonEmail = 'testemail@email.com';
        newRolodex.Tax_Id__c = '123456789';
        newRolodex.NPI__c = '1234567890';
        newRolodex.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rolodex').getRecordTypeId();
        newRolodex.CM_Corporate_Entity_Code__c = 'IL1';
        
        Test.startTest();
        	insert newRolodex;
        	
        	try {
                // Give bad data to test phone validations
                newRolodex.Phone = '1';
                newRolodex.Fax = '1';
                newRolodex.PersonMobilePhone = '1';
                update newRolodex;
            } catch (DmlException e) {
                System.assert(e != null);
            }
		Test.stopTest();
    }
   
    static void createCaseTestData(Account accToLink) {
        
        List<Case> lstOtherCasesToInsert = new List<Case>();
        
        Case onBoardingParentCase = new Case();
        onBoardingParentCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding').getRecordTypeId();
        onBoardingParentCase.AccountId = accToLink.Id;
        onBoardingParentCase.Corporate_Received_Date_Time__c = System.now();
        insert onBoardingParentCase;
        
        Case onBoardingCase = new Case();
        onBoardingCase.Billing_NPI_Number__c = '1234567890';
        onBoardingCase.Tax_Id_Number__c = '123456789';
        onBoardingCase.recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId();
        onBoardingCase.Plan_ID__c = 'IL1';
        onBoardingCase.ParentId = onBoardingParentCase.Id;
        onBoardingCase.AccountId = accToLink.Id;
        insert onBoardingCase;
        
        Provider_Networks__c prvDetail = new Provider_Networks__c();
        prvDetail.PFIN_Case__c = onBoardingCase.Id;
        prvDetail.Prov_ID__c = '985415357';
        prvDetail.Plan_Id__c = 'IL1';
        insert prvDetail;
        
        onBoardingCase.Status = 'Closed Processed';
        
        update onBoardingCase;
        
        Case contractingCase = new Case();
        contractingCase.Billing_NPI_Number__c = '1234567890';
        contractingCase.Tax_Id_Number__c = '123456789';
        contractingCase.recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
        contractingCase.Plan_ID__c = 'IL1';
        contractingCase.ParentId = onBoardingParentCase.Id;
        contractingCase.AccountId = accToLink.Id;
        insert contractingCase;
        
    }
    
}