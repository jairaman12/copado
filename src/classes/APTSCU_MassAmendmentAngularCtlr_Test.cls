/**
 * Test class for APTSCU_MassAmendmentAngularController.
 * Created By - Kushal Bhalodiya
 * Created Date - 16th Oct, 2018
 * Modified By - 
 * Modified Date - 
 */
@isTest
private class APTSCU_MassAmendmentAngularCtlr_Test {

    @testSetup 
    static void setup() 
    {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Apttus__ComplySystemProperties__c sysProp = APTS_CLMTestUtility.createComplySystemProp();
        insert sysProp; 
        Account accSO = APTS_CLMTestUtility.createAccount();
        accSO.Name = Label.APTS_Mass_Amend_Agreement;
        insert accSO;
        Contact conSO = APTS_CLMTestUtility.createContact();
        insert conSO;
        
        List<Apttus__APTS_Agreement__c> agreementList = APTS_CLMTestUtility.createAgreement(conSO.ID, accSO.ID, 1);
        insert agreementList;
        List<Attachment> attachList = APTS_CLMTestUtility.createAttachmentWithBody(agreementList, 'ASC - Agreement - BCBS');
        insert attachList;
        
        Apttus__APTS_Template__c templateSO = APTS_CLMTestUtility.createTemplate();
        templateSO.Use_for_MassAmend__c = TRUE;
        insert templateSO;
        Attachment templateAtt = APTS_CLMTestUtility.createTemplateAttachmentWithBody(templateSO.ID, 'Amendment Template');
        insert templateAtt;
        
    }
    
    private static testMethod void testSetConstructor()
    {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        Account accSO = [Select ID from Account];
	    Contact conSO = [Select ID from Contact];
	    
        List<Apttus__APTS_Agreement__c> agreementSOList = APTS_CLMTestUtility.createAgreement(conSO.ID, accSO.ID, 1);
        insert agreementSOList;
        Test.startTest();
        PageReference pageRef = Page.APTSCU_MassAmendmentAngular;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', agreementSOList[0].ID);
        ApexPages.currentPage().getHeaders().put('Referer',''+System.Url.getSalesforceBaseUrl().toExternalForm());
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(agreementSOList);
        sc.setSelected(agreementSOList);
        APTSCU_MassAmendmentAngularController controller = new APTSCU_MassAmendmentAngularController(sc);
        sc = new ApexPages.StandardSetController(agreementSOList);
        APTSCU_MassAmendmentAngularController controller1 = new APTSCU_MassAmendmentAngularController(sc);
        controller1.doMassAmend();
        Test.stopTest();
    }
    
    private static testMethod void testConstructor()
    {
        
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        Account accSO = [Select ID from Account];
	    Contact conSO = [Select ID from Contact];
	    
        List<Apttus__APTS_Agreement__c> agreementSOList = APTS_CLMTestUtility.createAgreement(conSO.ID, accSO.ID, 1);
        insert agreementSOList;
        Test.startTest();
        PageReference pageRef = Page.APTSCU_MassAmendmentAngular;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', agreementSOList[0].ID);
        ApexPages.StandardController sc = new ApexPages.StandardController(agreementSOList[0]);
        APTSCU_MassAmendmentAngularController controller = new APTSCU_MassAmendmentAngularController(sc);
        controller.onClickAmend();
        Test.stopTest();
    }
    
    private static testMethod void testdeleteAgreement()
    {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Account accSO = [Select ID from Account];
	    Contact conSO = [Select ID from Contact];
	    
        List<Apttus__APTS_Agreement__c> agreementSOList = APTS_CLMTestUtility.createAgreement(conSO.ID, accSO.ID, 1);
        agreementSOList[0].Selected__c = true;
        insert agreementSOList;
        Test.startTest();
        PageReference pageRef = Page.APTSCU_MassAmendmentAngular;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', agreementSOList[0].ID);
        ApexPages.currentPage().getParameters().put('myParam',JSON.serialize(agreementSOList));
        ApexPages.currentPage().getHeaders().put('Referer',''+System.Url.getSalesforceBaseUrl().toExternalForm());
        ApexPages.StandardController sc = new ApexPages.StandardController(agreementSOList[0]);
        APTSCU_MassAmendmentAngularController controller = new APTSCU_MassAmendmentAngularController(sc);
        controller.deleteAgreement();
        
        Test.stopTest();
    }
    
    private static testMethod void testdoMassAmend()
    {
       
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Account accSO = [Select ID from Account];
	    Contact conSO = [Select ID from Contact];
	    
        List<Apttus__APTS_Agreement__c> agreementSOList = APTS_CLMTestUtility.createAgreement(conSO.ID, accSO.ID, 1);
        insert agreementSOList;
        Test.startTest();
        PageReference pageRef = Page.APTSCU_MassAmendmentAngular;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', agreementSOList[0].ID);
        ApexPages.currentPage().getParameters().put('myEffectiveDate', '2018-10-10');
        ApexPages.currentPage().getParameters().put('myAgmtName', 'ASC - Agreement - BCBS');
        ApexPages.currentPage().getParameters().put('myDesc', 'Desc');
        ApexPages.currentPage().getHeaders().put('Referer',''+System.Url.getSalesforceBaseUrl().toExternalForm());
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(agreementSOList);
        sc.setSelected(agreementSOList);
        APTSCU_MassAmendmentAngularController controller = new APTSCU_MassAmendmentAngularController(sc);
        controller.doMassAmend();
        Test.stopTest();
    }
    
    private static testMethod void testpopulateNewAgreementList()
    {
        
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Account accSO = [Select ID from Account];
	    Contact conSO = [Select ID from Contact];
	    
        List<Apttus__APTS_Agreement__c> agreementSOList = APTS_CLMTestUtility.createAgreement(conSO.ID, accSO.ID, 1);
        agreementSOList[0].Amended_Terms__c = 'Amended Terms';
        insert agreementSOList;
        Test.startTest();
        PageReference pageRef = Page.APTSCU_MassAmendmentAngular;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(agreementSOList[0]);
        APTSCU_MassAmendmentAngularController controller = new APTSCU_MassAmendmentAngularController(sc);
        controller.finalDisplayIds.add(agreementSOList[0].ID);
        controller.populateNewAgreementList();
        controller.agreementIdsToGenerate.add(agreementSOList[0].ID);
        controller.contactSet.add(conSO.ID);
        controller.agreementNames.add(agreementSOList[0].Name);
        controller.doGenerate();
        Test.stopTest();
    }
    
    private static testMethod void testgetObjectFields()
    {
        
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Test.startTest();
        
        APTSCU_MassAmendmentAngularController.getObjectFields('Apttus__APTS_Agreement__c');
        
        Test.stopTest();
    }
    private static testMethod void testgetPicklistValues()
    {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Test.startTest();
        
        APTSCU_MassAmendmentAngularController.getPicklistValues('Apttus__APTS_Agreement__c', 'Apttus__Agreement_Category__c');
        APTSCU_MassAmendmentAngularController.getReferenceRecords('Apttus__APTS_Agreement__c');
        APTSCU_MassAmendmentAngularController.getAgmtsAsPerCondition('ID != null', [Select ID from Apttus__APTS_Agreement__c LIMIT 1].ID);
        Test.stopTest();
    }

}