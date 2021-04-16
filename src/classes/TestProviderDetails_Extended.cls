@isTest
public class TestProviderDetails_Extended
{
    @testSetup static void prepareData() {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM;Provider Group Onboarding Data Entry;Provider On-boarding Data Entry;Provider On-boarding;Entity Account';
        insert gs;   
    }
    
    static testMethod void testPage() 
    {
        Test.startTest();
        List<Account> listofAccounts = new List<Account>();
        List<Id> listOfAccountIdIds = new List<Id>();
        
        Account acc1 = new Account();
        acc1 = TestClassData.CreateAccount();        
        listofAccounts.add(acc1);
        listOfAccountIdIds.add(acc1.Id);
        
        Account acc = new Account();
        acc = TestClassData.CreateAccount();
        listOfAccountIdIds.add(acc.Id);
       
        CM_Provider_Identification__c provIden = new CM_Provider_Identification__c();
        provIden = TestClassData.CreateProviderIdentification(acc.Id);        
        provIden.CM_PI_Prov__c = acc.Id;
        provIden.CM_Prvdr_Iden_Typ_Cd__c = 'NPI';
        
        CM_Provider_Tax_Id__c provTaxIden = new CM_Provider_Tax_Id__c();        
        provTaxIden = TestClassData.CreateProviderTaxIdentification(acc.Id);
        provTaxIden.CM_PTI_Prov_Name_From__c = acc.Id;
        provTaxIden.CM_PTI_Tax_Id__c = '123456789';
        update provTaxIden;
       
        provIden.CM_PI_Prov__c = provTaxIden.CM_PTI_Prov_Name_From__c;
        update provIden;
        
        CM_Provider_Identification__c provIden2 = new CM_Provider_Identification__c();
        provIden2 = TestClassData.CreateProviderIdentification(acc.Id);        
        provIden.CM_PI_Prov__c = acc.Id;
        provIden2.CM_Prvdr_Iden_Typ_Cd__c = 'NPI';
        provIden2.CM_PI_Prov__c = provTaxIden.CM_PTI_Prov_Name_From__c;
        update provIden2;
        
        
        listOfAccountIdIds.add(provTaxIden.CM_PTI_Prov_Name_From__c);
       
        Affiliations__c affi = new Affiliations__c();
        affi = TestClassData.CreateAffiliation(acc.Id);
        
        case c = new Case();
        c = TestClassData.CreateChildCase(acc.Id);
        c.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider Group Onboarding Data Entry').getRecordTypeId();
		c.Billing_NPI_Number__c = '1234567890';
        c.Tax_Id_Number__c = '123456789';
        c.Case_Entity__c = acc.Id;
        CM_SPL_Addr__c sploc = new CM_SPL_Addr__c();
        sploc = TestClassData.CreateServicePayeeLocationAddress(provTaxIden.Id);
        
        CM_Network__c net = new CM_Network__c();
        net = TestClassData.CreateNetwork(sploc.Id);
        
        CM_Specialty__c accspl = new CM_Specialty__c();        
        CM_Specialty__c netSpl = new CM_Specialty__c();        
        CM_Specialty__c spl2 = new CM_Specialty__c();
        accspl = TestClassData.CreateSpecialty(acc.Id,sploc.Id,net.Id);
        spl2 = TestClassData.CreateSpecialty(acc.Id,sploc.Id,net.Id);
        netspl = TestClassData.CreateSpecialty(acc.Id,sploc.Id,net.Id);
        
        CM_Hours_of_Operation__c hoo = new CM_Hours_of_Operation__c();
        hoo = TestClassData.CreateHoursofOperation(sploc.Id);
        
        
        pagereference pageref = page.providerdetails_extended;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('id' , acc.Id);        
       
        providerdetails_extended controller = new providerdetails_extended();   
        CM_Provider_Tax_Id__c provTaxIden2 = new CM_Provider_Tax_Id__c();
        provTaxIden2 = TestClassData.CreateProviderTaxIdentificationForDelete(acc.Id);        
        delete provTaxIden2;
        
        CM_Provider_Identification__c pridenti = new CM_Provider_Identification__c();
        pridenti = TestClassData.CreateProviderIdentificationDelete(acc.Id);
        delete pridenti;
        
        Test.StopTest();
        
    }
    /*static testmethod void testing(){
        
        Account acc1 = new Account();
        acc1 = TestClassData.CreateAccount();
        acc1.Tax_Id__c='123456789';
        acc1.NPI__c='1234567890';
        update acc1;
        
        case c2 = new Case();
        c2 = TestClassData.CreateChildCase(acc1.Id);
        c2.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider Group Onboarding Data Entry').getRecordTypeId();
		c2.Billing_NPI_Number__c = '1234567890';
        c2.Tax_Id_Number__c = '123456789';
        c2.Case_Entity__c = acc1.Id;
        update c2;
        
        case c3 = new Case();
        c3 = TestClassData.CreateChildCase(acc1.Id);
        c3.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider On-boarding').getRecordTypeId();
		c3.Billing_NPI_Number__c = '1234567890';
        c3.Tax_Id_Number__c = '123456789';
        c3.Case_Entity__c = acc1.Id;
        update c3;
    }*/
    
}