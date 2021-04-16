/*
* TThis is the test class for CRMCaseCreationController1.apxc
* Developer: Travis Self
*/
@isTest
public class TestCRMCaseCreationController {
    
    static Case controlCase, emailCase;
    static Account personAccount, entityAccount, meAccountWithAff, meAccountNoAff;
    static CM_SPL_Addr__c servicePay1, servicePay2;
    static List<Account> testAccounts;
    static List<CM_SPL_Addr__c> servPayeeLocations;
    static String planId = 'IL1';
    static Boolean runSaveAction	= true;
    
    // Custom settings record needed for CRM Case Creation
    @testSetup static void prepareData() {
        GlobalSettings__c gs					=	new GlobalSettings__c();
        gs.name 								=	'PFFileRecieved';
        gs.PFFileRecieved__c					=	false;
        gs.Record_Type_Names__c					=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.CRM_Case_Status_fields__c			=	'New,In Progress,Waiting for Internal Response,Waiting for External Response,Closed';
        gs.CRM_Master_Record_Type_Id__c			=	[SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Master_CRM_Case_Data'].Id;
        gs.CRM_Case_record_Type_Id__c			=	[SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'CRM'].Id;
        gs.Account_trigger_switch__c    		=   false;
        gs.Case_Attachment_Trigger_Switch__c 	= 	false;
        gs.CaseComment_Trigger_Switch__c     	= 	false;
        insert gs;
	}
    
    // New CRM cases can be created from:
    // 1. Physician Accounts
    // 2. Entity Accounts
    // 3. Master Entity Accounts
    // 5. Rolodex Accounts
    // 5. Email recordtype cases
    // 6. Service & Payee locations
    // 7. Rolodex Accounts
    static void createTestData() {
        
        testAccounts 		= new List<Account>();
        servPayeeLocations	= new List<CM_SPL_Addr__c>();
       
        personAccount 								= new Account();
        personAccount.LastName 						= 'Test Account';  
        personAccount.CM_Corporate_Entity_Code__c 	= planId;
        personAccount.RecordTypeId					= [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Physician'].Id;
        testAccounts.add(personAccount);
        
        entityAccount 								= new Account();
        entityAccount.Name 							= 'Test Account';  
        entityAccount.CM_Corporate_Entity_Code__c 	= planId;
        entityAccount.RecordTypeId					= [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Entity_Account'].Id;
        testAccounts.add(entityAccount);
        
        // Master Entity Account with no affiliations, and therefore there will be no associated pfins
        meAccountNoAff 								= new Account();
        meAccountNoAff.Name 						= 'Test Account';  
        meAccountNoAff.CM_Corporate_Entity_Code__c 	= planId;
        meAccountNoAff.RecordTypeId					= [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Master_Entity_Account'].Id;
        testAccounts.add(meAccountNoAff);
        
        // Master Entity Account with 1 affiliation
        meAccountWithAff 								= new Account();
        meAccountWithAff.Name 							= 'Test Account';  
        meAccountWithAff.CM_Corporate_Entity_Code__c 	= planId;
        meAccountWithAff.RecordTypeId					= meAccountNoAff.RecordTypeId;
        testAccounts.add(meAccountWithAff);
        
        insert testAccounts;
        
        servicePay1 							= new CM_SPL_Addr__c();
        servicePay1.CM_SPL_PFIN_No__c 			= '123456';
        servicePay1.CM_SPL_Prov__c 				= personAccount.Id;
        servicePay1.CM_Corporate_Entity_Code__c	= planId;
        servPayeeLocations.add(servicePay1);
        
        servicePay2 = new CM_SPL_Addr__c();
        servicePay2.CM_SPL_PFIN_No__c 			= '654321';
        servicePay2.CM_SPL_Prov__c 				= personAccount.Id;
        servicePay2.CM_Corporate_Entity_Code__c	= planId;
        servPayeeLocations.add(servicePay2);
        
        insert servPayeeLocations;
        
        // Affiliation attached to Master Entity Account
        Affiliations__c	aff 				= new Affiliations__c();
        aff.Account__c						= meAccountWithAff.Id;
        aff.Affiliated_to_Service_PFIN__c 	= servicePay1.id;
        aff.CM_Corporate_Entity_Code__c		= planId;
        aff.RecordTypeId					= [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName like 'Master_Entity%' AND SObjectType='Affiliations__c'].Id;
        insert aff;
        
        // Email case
        emailCase 				= new Case();
        emailCase.accountId		= personAccount.id;
        emailCase.Plan_ID__c	= planId;
        emailCase.Origin		= 'Email';
        emailCase.Status		= 'New';
        emailCase.RecordTypeId	= [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Email' AND SObjectType='Case'].Id;
        emailCase.OwnerId		= UserInfo.getUserId();
        insert emailCase;
    }
    
    
    static testMethod void crmTestMethod()
    {
        
        createTestData();
        
        Test.startTest();
        	
        	crmCreationFromPhysAccount();
        	crmCreationFromEntityAccount();
        	crmCreationFromMasterEntityAccount();
        	crmCreationFromCase();
        	crmCreationFromServicePayee();
                        
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Case WHERE recordtypeid=: GlobalSettings__c.getValues('PFFileRecieved').CRM_Master_Record_Type_Id__c]);
        //System.assertEquals(3, [SELECT count() FROM Case WHERE recordtypeid=: GlobalSettings__c.getValues('PFFileRecieved').CRM_Case_record_Type_Id__c]);
    }
    
    // CRM Case Creation launched from Account
    static void crmCreationFromPhysAccount() {
        
        controlCase 				= new Case();
        controlCase.Plan_ID__c 		= planId;
        
        PageReference pageRef = Page.CRMCaseCreationPage;
        
        pageRef.getParameters().put('accountId', personAccount.id );
        pageRef.getParameters().put('planId', planId);
        pageRef.getParameters().put('from','Account');
        pageRef.getParameters().put('inConsole','true');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(controlCase);
        CRMCaseCreationController1 CCC 	= new CRMCaseCreationController1(sc);
        
        List<SelectOption> tempList = CCC.crmRequestTypes;
        
        CCC.caseRec.Origin = 'Phone';
        CCC.selectedCrmTypes = '["AIM - RQI","ANSI 5010"]';
        CCC.selectedCrmTypesToController();
        
        for(Integer i=0; i<CCC.caseWrapList.size(); i++) {
            
            CCC.caseWrapList[i].caseRec.Status			= 'New';
            CCC.caseWrapList[i].caseRec.CRM_Comments__c	= 'Test comments...';
            CCC.caseWrapList[i].caseRec.Priority		= 'High';
            CCC.lookupValue								= CCC.caseWrapList[i].caseRec.CRM_Types__c;
            CCC.fieldName								= 'Priority';
            CCC.fieldValue								= CCC.caseWrapList[i].caseRec.Priority;
        }
        
        CCC.selectedCrmTypes = '["AIM - RQI","ANSI 5010","Annual Provider Training"]';
        
        CCC.updateSelectedCrmTypes();
        CCC.selectedCrmTypesToController();
        
        CCC.caseWrapList[CCC.caseWrapList.size()-1].caseRec.Status			= 'New';
        CCC.caseWrapList[CCC.caseWrapList.size()-1].caseRec.CRM_Comments__c	= 'Test comments...';
        CCC.caseWrapList[CCC.caseWrapList.size()-1].caseRec.Priority		= 'High';
        
        for(Integer i=0; i<CCC.allPfins.size(); i++) {
            
            CCC.allPfins[i].selected = true;
            
        }
        
        CCC.addPFINS	= '333';
        
        CCC.getPossibleCaseOwnersByUser();
        CCC.getPossibleCaseOwnersByQueue();
        
        CCC.saveAndCloneAction();
        
        Id newlyCreatedMasterCase = [SELECT Id FROM Case WHERE RecordType.DeveloperName = 'Master_CRM_Case_Data' LIMIT 1].Id;
        List<Case> newlyCreatedCRMCases = [SELECT Id FROM Case WHERE parentId =: newlyCreatedMasterCase];
        CCC.setMasterCaseStatus(newlyCreatedMasterCase, newlyCreatedCRMCases);
        
        // After Save & Clone is clicked, set new values for Account and Case Entity to test pfin table method
        CCC.caseRec.AccountId 		= personAccount.Id;
        CCC.caseRec.Case_Entity__c 	= entityAccount.Id;
        CCC.caseRec.Origin			= 'Phone';
        
        CCC.populatePfins();
        
        // Master Entity Account with 1 affiliation
        CCC.caseRec.Case_Entity__c 	= meAccountWithAff.Id;
        
        CCC.populatePfins();
        
        // Master Entity Account with no affiliations
        CCC.caseRec.Case_Entity__c 	= meAccountNoAff.Id;
        
        CCC.populatePfins();
        
        CCC.cancelAction();
        
        //CCC.saveAndNewAction();	
        
        //CCC.saveAction();
        
    }
    
    // CRM Case Creation launched from Entity Account
    static void crmCreationFromEntityAccount() {
        
        controlCase 				= new Case();
        controlCase.Plan_ID__c 		= planId;
        
        PageReference pageRef = Page.CRMCaseCreationPage;
        
        pageRef.getParameters().put('accountId', entityAccount.id );
        pageRef.getParameters().put('planId', planId);
        pageRef.getParameters().put('from','Account');
        pageRef.getParameters().put('inConsole','true');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(controlCase);
        CRMCaseCreationController1 CCC 	= new CRMCaseCreationController1(sc);
    }
    
    // CRM Case Creation launched from Master Entity Account
    static void crmCreationFromMasterEntityAccount() {
        
        controlCase 				= new Case();
        controlCase.Plan_ID__c 		= planId;
        
        PageReference pageRef = Page.CRMCaseCreationPage;
        
        pageRef.getParameters().put('accountId', meAccountWithAff.id );
        pageRef.getParameters().put('planId', planId);
        pageRef.getParameters().put('from','Account');
        pageRef.getParameters().put('inConsole','true');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(controlCase);
        CRMCaseCreationController1 CCC 	= new CRMCaseCreationController1(sc);
    }
    
    // CRM Case Creation launched from Case
    static void crmCreationFromCase() {
        
        controlCase 				= new Case();
        controlCase.Plan_ID__c 		= planId;
        
        PageReference pageRef = Page.CRMCaseCreationPage;
        
        pageRef.getParameters().put('parentId', String.valueOf(emailCase.id) );
        pageRef.getParameters().put('accountId', String.valueOf(emailCase.accountId) );
        //pageRef.getParameters().put('caseEntityId', '' );
        pageRef.getParameters().put('planId', planId );
        pageRef.getParameters().put('Origin', String.valueOf(emailCase.Origin) );
        pageRef.getParameters().put('from','Case');
        pageRef.getParameters().put('inConsole','true');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(controlCase);
        CRMCaseCreationController1 CCC 	= new CRMCaseCreationController1(sc);
        
        CCC.cancelAction();
    }
    
    // CRM Case Creation launched from a service & payee location address
    static void crmCreationFromServicePayee() {
        
        controlCase 				= new Case();
        controlCase.Plan_ID__c 		= planId;
        
        PageReference pageRef = Page.CRMCaseCreationPage;
        
        pageRef.getParameters().put('accountId', String.valueOf(servicePay1.CM_SPL_Prov__c) );
        pageRef.getParameters().put('planId', planId );
        pageRef.getParameters().put('pfinNumber', String.valueOf(servicePay1.CM_SPL_PFIN_No__c) );
        pageRef.getParameters().put('from','ServiceAndPayee');
        pageRef.getParameters().put('inConsole','true');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(controlCase);
        CRMCaseCreationController1 CCC 	= new CRMCaseCreationController1(sc);
        
        CCC.cancelAction();
    }
}