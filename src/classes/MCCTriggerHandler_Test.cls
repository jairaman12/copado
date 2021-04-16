/*
Apex Class Name  : To pass the values to the TestFactory class
Version          : 1.0  
Functionality    : To run the classes in bulk and in large volume
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ashok N                    11/19/2018             Test class to cover the MCCTriggerHandler 
 Saravana Bharathi           11/29/2018             Test Class to cover MCCTriggerHandler
******************************************************************************
*/

@Istest

public class MCCTriggerHandler_Test {
       
    static testMethod void credentialingMassUpdate()
    {
        TestDataFactory.prepareData();
        Account accountInsert= new Account();        
        accountInsert.FirstName='TEst';
        accountInsert.LastName='test';
        accountInsert.Prov_ID__c='Testing';
        accountInsert.CM_Corporate_Entity_Code__c='IL1';
        Id newId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();                
        accountInsert.RecordTypeId=newId;
        insert accountInsert;
        List<Case> caseList = new List<Case>();
        for(Integer check=0;check<10;check++)
        {
            Case newCase = new Case();
            newCase.accountId = accountInsert.Id;
            newCase.status = 'Opened';
            newCase.Origin='Web-Onboarding';
            caseList.add(newCase);
        }
        insert caseList;
        
        List<String> listOfCaseNumbers = new List<String>();
        for(Case newCase:[Select CaseNumber from Case where Id=:caseList])
        {
            listOfCaseNumbers.add(newCase.CaseNumber);
        }
        List<MCC_Data_Object__c> listOfMCCRecords = new List<MCC_Data_Object__c>();
        for(Integer check=0;check<10;check++)
        {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='Onboarding Cred Mass Status Update';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.Onboarding_Case_ID__c=listOfCaseNumbers[check];
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.Cred_Status_Date__c=System.today();
            listOfMCCRecords.add(newObject);
        }
        insert listOfMCCRecords;
        
        MCCTriggerHandler newTrigger = new MCCTriggerHandler();
        newTrigger.getProviderMap(new Set<String>{'Testing'});
        newTrigger.projectNumbers(listOfMCCRecords);
        
    }
    
    
     static testMethod void deathFileMassUpdate()
    {
        TestDataFactory.prepareData();
        Account accountInsert= new Account();        
        accountInsert.FirstName='TEst';
        accountInsert.LastName='test';
        accountInsert.Prov_ID__c='Testing';
        accountInsert.CM_Corporate_Entity_Code__c='IL1';
        Id newId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();                
        accountInsert.RecordTypeId=newId;
        insert accountInsert;
        
        List<Case> caseList = new List<Case>();
        
        for(Integer check=0;check<10;check++)
        {
            Case newCase = new Case();
            newCase.accountId = accountInsert.Id;
            newCase.status = 'Opened';
            newCase.Origin='Web-Onboarding';
            caseList.add(newCase);
        }
        
        insert caseList;
        List<String> listOfCaseNumbers = new List<String>();
        for(Case newCase:[Select CaseNumber from Case Where Id=:caseList ])
        {
            listOfCaseNumbers.add(newCase.CaseNumber);
        }
        List<MCC_Data_Object__c> listOfMCCRecords = new List<MCC_Data_Object__c>();
        Id deathFileId =Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Death_File').getRecordTypeId();  
        for(Integer check=0;check<10;check++)
        {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='Mass CRM Creation';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.Onboarding_Case_ID__c=listOfCaseNumbers[check];
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.Cred_Status_Date__c=System.today();
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.RecordTypeId=deathFileId ;
            listOfMCCRecords.add(newObject);
        }
        insert listOfMCCRecords;
        
        MCCTriggerHandler newTrigger = new MCCTriggerHandler();
        newTrigger.getProviderMap(new Set<String>{'Testing'});
        newTrigger.projectNumbers(listOfMCCRecords);
        
    }
    
     static testMethod void networkLoadMassUpdate()
    {
        TestDataFactory.prepareData();
        Account accountInsert= new Account();        
        accountInsert.FirstName='TEst';
        accountInsert.LastName='test';
        accountInsert.Prov_ID__c='Testing';
        accountInsert.CM_Corporate_Entity_Code__c='IL1';
        Id newId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();                
        accountInsert.RecordTypeId=newId;
        insert accountInsert;
        
        List<Case> caseList = new List<Case>();
        
        for(Integer check=0;check<10;check++)
        {
            Case newCase = new Case();
            newCase.accountId = accountInsert.Id;
            newCase.status = 'Opened';
            newCase.Origin='Web-Onboarding';
            caseList.add(newCase);
        }
        
        insert caseList;
        List<String> listOfCaseNumbers = new List<String>();
        List<String> listOfCaseIds = new List<String>();
        for(Case newCase:[Select Id, CaseNumber from Case Where Id=:caseList ]) {
            listOfCaseNumbers.add(newCase.CaseNumber);
            listOfCaseIds.add(newCase.Id);
        }
        List<MCC_Data_Object__c> listOfMCCRecords = new List<MCC_Data_Object__c>();
        Id deathFileId =Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Death_File').getRecordTypeId();  
        for(Integer check=0;check<10;check++) {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='Network Load Mass Status';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.Onboarding_Case_ID__c=listOfCaseNumbers[check];
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.Cred_Status_Date__c=System.today();
            newObject.RecordTypeId=deathFileId ;
            listOfMCCRecords.add(newObject);
        }
        
        for(Integer check=0;check<10;check++) {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='ADC Mass Status';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.Onboarding_Case_ID__c=listOfCaseNumbers[check];
            newObject.MCC_Case_Id__c=listOfCaseIds[check];
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.Cred_Status_Date__c=System.today();
            newObject.RecordTypeId=deathFileId ;
            newObject.MCC_Project_Number__c = 'Testing';
            listOfMCCRecords.add(newObject);
        }
        
        for(Integer check=0;check<10;check++) {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='CRM Mass Status';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.Onboarding_Case_ID__c=listOfCaseNumbers[check];
            newObject.MCC_Case_Id__c=listOfCaseIds[check];
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.Cred_Status_Date__c=System.today();
            newObject.RecordTypeId=deathFileId ;
            newObject.MCC_Project_Number__c = 'Testing';
            listOfMCCRecords.add(newObject);
        }
        insert listOfMCCRecords;
        
        MCCTriggerHandler newTrigger = new MCCTriggerHandler();
        newTrigger.getProviderMap(new Set<String>{'Testing'});
        newTrigger.projectNumbers(listOfMCCRecords);
        
    }
    
    
    
     static testMethod void roseterLoadMassUpdate()
    {
        TestDataFactory.prepareData();
        Account accountInsert= new Account();        
        accountInsert.FirstName='TEst';
        accountInsert.LastName='test';
        accountInsert.Prov_ID__c='Testing';
        accountInsert.CM_Corporate_Entity_Code__c='IL1';
        Id newId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();                
        accountInsert.RecordTypeId=newId;
        insert accountInsert;
        
        List<MCC_Data_Object__c> listOfMCCRecords = new List<MCC_Data_Object__c>();
        Id deathFileId =Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Roster').getRecordTypeId();  
        for(Integer check=0;check<10;check++)
        {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='ILR';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.Onboarding_Case_ID__c=null;
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.Cred_Status_Date__c=System.today();
            newObject.RecordTypeId=deathFileId ;
            newObject.MCC_Project_Number__c = 'Testing';
            listOfMCCRecords.add(newObject);
        }
        insert listOfMCCRecords;
        
        MCCTriggerHandler newTrigger = new MCCTriggerHandler();
        newTrigger.getProviderMap(new Set<String>{'Testing'});
        newTrigger.projectNumbers(listOfMCCRecords);
        
    }
    
       static testMethod void acctCaseCredStatusLoadMassUpdate()
    {
        TestDataFactory.prepareData();
        Account accountInsert= new Account();        
        accountInsert.FirstName='TEst';
        accountInsert.LastName='test';
        accountInsert.Prov_ID__c='Testing';
        accountInsert.CM_Corporate_Entity_Code__c='IL1';
        Id newId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();                
        accountInsert.RecordTypeId=newId;
        insert accountInsert;
        
        List<MCC_Data_Object__c> listOfMCCRecords = new List<MCC_Data_Object__c>();
        Id deathFileId =Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Roster').getRecordTypeId();  
        for(Integer check=0;check<10;check++)
        {
            MCC_Data_Object__c newObject = new MCC_Data_Object__c();
            newObject.MCC_File_Type__c='Onboarding Cred Mass Status Update';
            newObject.MCC_File_Id__c='Test1';
            newObject.MCC_Prov_ID__c='Testing';
            newObject.MCC_Plan_ID__c='IL1';
            newObject.MCC_Comments__c='Testing';
            newObject.Cred_Cycle__c='I';
            newObject.Cred_Status__c='In Progress';
            newObject.MCC_Grouping_ID__c='Testing HCSC';
            newObject.Cred_Status_Date__c=System.today();
            newObject.RecordTypeId=deathFileId ;
            newObject.MCC_Project_Number__c = 'Testing';
            listOfMCCRecords.add(newObject);
        }
        
        insert listOfMCCRecords;
        
        MCCTriggerHandler newTrigger = new MCCTriggerHandler();
        newTrigger.getProviderMap(new Set<String>{'Testing'});
        newTrigger.projectNumbers(listOfMCCRecords);
        
    }
    
}