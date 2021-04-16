/******************************
Apex Class Name   : TestDataFactory_CLM
Version           : 1.0
Function          : This class contains the data to be used in all the test classes written by Contract team for 
                    Agreement Object and other related objects to agreements 

Developer                  Date                                
-------------------------------------------------------------------------------------  
Piyush Bhardwaj            8/20/2019
chaitana Motupalli         8/21/2019
******************************/
@isTest
public class TestDataFactory_CLM 
{ 
	
    //Method to create accounts for test classes
    //This method takes in 1 arguments, CorporateEntityCode of the account
    public static account  CreateAccount(string CorporateEntityCode)
    {    
        Account acc= new Account();
        acc.Name                          = 'Test Account1 CLM_Plan_NM';  
        acc.CM_Corporate_Entity_Code__c   = CorporateEntityCode;
        acc.RecordTypeId                  = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
        insert acc;
        return acc;
    }
    
    //Method to Create an agreement for test classes
    //The method takes in 3 arguments, recordtype of the agreement, plan of the agreement and owner of the agreement
    public static Apttus__APTS_Agreement__c  CreateAgreement(String recordType, String plan, String role)
    {    
        Apttus__APTS_Agreement__c agg = new Apttus__APTS_Agreement__c();
        user u=[select Id from user where userrole.Name=:role AND user.IsActive = true limit 1];
        agg.OwnerId=u.Id;
        Id aggRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        agg.recordtypeId = aggRecordTypeId;
        agg.plan__c=plan;
        insert agg;
        return agg; 
    }
    
    
    //Test data for 'Docusign recipients' 
    public static  list<Apttus_DocuApi__DocuSignDefaultRecipient2__c>  CreateDocusignRecipients()
    {    
       list<Apttus_DocuApi__DocuSignDefaultRecipient2__c>reclist= new List<Apttus_DocuApi__DocuSignDefaultRecipient2__c>();
       Apttus_DocuApi__DocuSignDefaultRecipient2__c reci1=new Apttus_DocuApi__DocuSignDefaultRecipient2__c();
       reci1.Apttus_DocuApi__Email__c='chaitu863@gmail.com';
       reci1.Apttus_DocuApi__FirstName__c='set';
       reci1.Apttus_DocuApi__LastName__c='sdfs';
       reci1.Apttus_DocuApi__SigningOrder__c=1;
       reclist.add(reci1);
       Apttus_DocuApi__DocuSignDefaultRecipient2__c reci2=new Apttus_DocuApi__DocuSignDefaultRecipient2__c();
       reci2.Apttus_DocuApi__Email__c='chaitu863@gmail.com';
       reci2.Apttus_DocuApi__FirstName__c='set';
       reci2.Apttus_DocuApi__LastName__c='sdfs';
       reci2.Apttus_DocuApi__SigningOrder__c=2;
       reclist.add(reci2);
       Apttus_DocuApi__DocuSignDefaultRecipient2__c reci3=new Apttus_DocuApi__DocuSignDefaultRecipient2__c();
       reci3.Apttus_DocuApi__Email__c='chaitu863@gmail.com';
       reci3.Apttus_DocuApi__FirstName__c='set';
       reci3.Apttus_DocuApi__LastName__c='sdfs';
       reci3.Apttus_DocuApi__SigningOrder__c=3;
       reclist.add(reci3);
       insert reclist;
       return reclist; 
    }
    
 
    //Method to create the global settings for creating accounts and aggreements and values to be assigned to the 
    //varibales are provided by the contact team 
      public static GlobalSettings__c  InsertGlobalsetting()
    {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        return gs;
    }
    

}