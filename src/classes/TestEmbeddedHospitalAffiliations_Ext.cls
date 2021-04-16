/**************************************************************************************************
Apex Class Name  : TestEmbeddedHospitalAffiliations_Ext 
Version          : 1.0  
Functionality    : 
Modification Log : 07/02/2018 Created by  SethuRaman
****************************************************************************************************/

@isTest
public class TestEmbeddedHospitalAffiliations_Ext{
public static List<Account> accountList;
    public static testmethod void createTestData()
    {
        GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.List_size__c			=	10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;  
        
        Id entityRecTypeId = [SELECT Id, Name FROM RecordType WHERE developerName = 'Entity_Account' LIMIT 1].Id;
        Id physicianRecTypeId = [SELECT Id, Name FROM RecordType WHERE developerName = 'Person_Account' LIMIT 1].Id;
        
        accountList = new List<Account>();        
        Account entityAcct = new Account(name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1', recordtypeid = entityRecTypeId ); //recordtypeid is for entity account 
        accountList.add(entityAcct);
        Account physicianAcct = new Account(name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1',Class__c='P', recordtypeid = physicianRecTypeId); //recordtypeid is for person account 
        accountList.add(physicianAcct);        
        insert accountList;        
        
        List<Affiliations__c> affList = new List<Affiliations__c>();
        Affiliations__c aff1 = new Affiliations__c(CM_Affiliated_Provider_Name__c = entityAcct.Id, Account__c = physicianAcct.Id);
        affList.add(aff1);
        Affiliations__c aff2 = new Affiliations__c(CM_Affiliated_Provider_Name__c = physicianAcct.Id, Account__c = entityAcct.Id);
        affList.add(aff2);
        insert affList;
    }
    
    public static testmethod void defaultLoad(){
        
        GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.List_size__c			=	10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;  
        
        createTestData();        
        ApexPages.StandardController sc = new ApexPages.StandardController(accountList[0]);
        EmbeddedHospitalAffiliations_Ext extension = new EmbeddedHospitalAffiliations_Ext(sc);        
        PageReference pageRef = Page.embeddedHospitalAffiliations;
        Test.setCurrentPage(pageRef);
        extension.getItems();
        extension.getType();
        extension.setType('All');
        extension.selectedTypeList();
    }
    
    public static testmethod void onchange(){
        GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.List_size__c			=	10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;  
        createTestData();        
        ApexPages.StandardController sc = new ApexPages.StandardController(accountList[1]);
        EmbeddedHospitalAffiliations_Ext extension = new EmbeddedHospitalAffiliations_Ext(sc);        
        PageReference pageRef = Page.embeddedHospitalAffiliations;
        Test.setCurrentPage(pageRef);
        extension.getItems();
        extension.getType();
        extension.setType('Rolodex');
        extension.selectedTypeList();
    }
}