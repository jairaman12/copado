@isTest
public class CLM_AgreementPlanAutoPopulateTest {
    
    /*
		Need to create sample records of Apttus__APTS_Agreement__c object and Account object records
	*/
	@testsetup
    public static void setupData(){
         List<Account> testAccounts = new List<Account>();
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;          

        Account personAccount 						= new Account();
        personAccount.LastName 						= 'Test Account CLM_Plan_IL';  
        personAccount.CM_Corporate_Entity_Code__c 	= Label.CLM_Plan_IL;
        personAccount.RecordTypeId					= [SELECT Id, Name FROM RecordType WHERE Name = 'Physician'].Id;
        testAccounts.add(personAccount);
        
        Account entityAccount 								= new Account();
        entityAccount.Name 							= 'Test Account CLM_Plan_NM';  
        entityAccount.CM_Corporate_Entity_Code__c 	= Label.CLM_Plan_NM;
        entityAccount.RecordTypeId					= [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
        testAccounts.add(entityAccount);
        
        // Master Entity Account with no affiliations, and therefore there will be no associated pfins
        Account meAccountNoAff 								= new Account();
        meAccountNoAff.Name 						= 'Test Account CLM_Plan_MT';  
        meAccountNoAff.CM_Corporate_Entity_Code__c 	= Label.CLM_Plan_MT;
        meAccountNoAff.RecordTypeId					= [SELECT Id, Name FROM RecordType WHERE Name = 'Master Entity Account'].Id;
        testAccounts.add(meAccountNoAff);
        
        // Master Entity Account with 1 affiliation
        Account meAccountWithAff 								= new Account();
        meAccountWithAff.Name 							= 'Test Account CLM_Plan_OK';  
        meAccountWithAff.CM_Corporate_Entity_Code__c 	= Label.CLM_Plan_OK;
        meAccountWithAff.RecordTypeId					= meAccountNoAff.RecordTypeId;
        testAccounts.add(meAccountWithAff);
        
          Account meAccountWithAff2								= new Account();
        meAccountWithAff2.Name 							= 'Test Account CLM_Plan_TX';  
        meAccountWithAff2.CM_Corporate_Entity_Code__c 	= Label.CLM_Plan_TX;
        meAccountWithAff2.RecordTypeId					= meAccountNoAff.RecordTypeId;
        testAccounts.add(meAccountWithAff2);
        
        insert testAccounts; 
        
       
        
	}
	
	@isTest
	public static void InvokeAutoPopulateProcessTest(){
        List<Apttus__APTS_Agreement__c> agreementList =new List<Apttus__APTS_Agreement__c>();

        List<Account> accList = [Select Id,CM_Corporate_Entity_Code__c FROM Account];
		 Apttus__APTS_Agreement__c agreement1 = new Apttus__APTS_Agreement__c();
        	agreement1.Apttus__Account__c = accList[0].Id;
        	agreement1.Name = 'Test Name 1';
      	 agreementList.add(agreement1);
        
         Apttus__APTS_Agreement__c agreement2 = new Apttus__APTS_Agreement__c();
        	agreement2.Apttus__Account__c = accList[1].Id;
        	agreement2.Name = 'Test Name 2';
      	 agreementList.add(agreement2);
        
         Apttus__APTS_Agreement__c agreement3 = new Apttus__APTS_Agreement__c();
        	agreement3.Apttus__Account__c = accList[2].Id;
        	agreement3.Name = 'Test Name 3';
      	 agreementList.add(agreement3);
        
         Apttus__APTS_Agreement__c agreement4 = new Apttus__APTS_Agreement__c();
        	agreement4.Apttus__Account__c = accList[3].Id;
        	agreement4.Name = 'Test Name 4';
      	 agreementList.add(agreement4);
        
         Apttus__APTS_Agreement__c agreement5 = new Apttus__APTS_Agreement__c();
        	agreement5.Apttus__Account__c = accList[4].Id;
        	agreement5.Name = 'Test Name 5';
      	 agreementList.add(agreement5); 
        insert agreementList; 
        
	}
    
}