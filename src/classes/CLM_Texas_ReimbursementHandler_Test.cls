// Created by - Piyush Bhardwaj
//Test Class written to satisfy the code coverage for the CLM_Texas_ReimbursementHandler
@isTest
public class CLM_Texas_ReimbursementHandler_Test
{

// Method to satisfy the code coverage for defaulting the values for the fields mediation city, arbitration city, NPI type
// and termination without cause notice for professional Record Type and Medical Record Type
	static testMethod void testData() 
    {
  
       // Global Settings needed for using account object in test method advised by the contact team
       // This part needs to be uncommented out in SIT , UAT and Prod environments
       GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_TX';  
      acc.CM_Corporate_Entity_Code__c   = 'TX1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
        
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
      //Finiding the appropriate user to create an agreement for Texas Plan based on the role
      user u=[select Id from user where userrole.Name in ('CLM Texas', 'Texas Supervisor' ) AND user.IsActive = true limit 1];
      
      //agrmt will be using professional record type which will test if the default values are getting populated
      Apttus__APTS_Agreement__c agrmt = new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c = acc.Id;
      agrmt.OwnerId = u.Id;
      agrmt.Plan__c = 'Texas';
      agrmt.recordtypeId = CLM_ReimbursementModel.professionalRecordTypeId ;
      agrmt.CLM_Standard_or_Non_Standard_Base_Lan__c = null;
      agrmtList.add(agrmt);
      
      // agrmt2 will be using medical record type which will test if the default values are getting removed 
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Texas';       
      agrmt2.recordtypeId=CLM_ReimbursementModel.medicalRecordTypeId ;
      agrmt2.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      agrmtList.add(agrmt2);
      
      // agrmt3 will be using medical record type which will test if the default values are getting populated
      Apttus__APTS_Agreement__c agrmt3=new Apttus__APTS_Agreement__c();
      agrmt3.Apttus__Account__c=acc.Id;
      agrmt3.OwnerId=u.Id;
      agrmt3.Plan__c='Texas';       
      agrmt3.recordtypeId=CLM_ReimbursementModel.medicalRecordTypeId ;
      agrmt3.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Non-Standard';
      agrmtList.add(agrmt3);
        
      // agrmt4 will be using professional record type which will test if the default values are getting removed 
      Apttus__APTS_Agreement__c agrmt4=new Apttus__APTS_Agreement__c();
      agrmt4.Apttus__Account__c=acc.Id;
      agrmt4.OwnerId=u.Id;
      agrmt4.Plan__c='Texas';       
      agrmt4.recordtypeId=CLM_ReimbursementModel.professionalRecordTypeId ;
      agrmt4.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      agrmtList.add(agrmt4);
      insert agrmtList;
      
      // updating fields in the agreements created to test the desired changes
      agrmt.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      update agrmt;
      agrmt2.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Non-Standard';
      update agrmt2;
      agrmt3.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      update agrmt3;
      agrmt4.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Non-Standard';
      update agrmt4;
      
      //adding the agreements to the old map and new map
      oldMapAgrmt.put(agrmt4.Id,agrmt4);
      oldMapAgrmt.put(agrmt3.Id,agrmt3);
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt4.Id,agrmt4);
      newMapAgrmt.put(agrmt3.Id,agrmt3);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      //Running the test class with the target apex class
      Test.startTest();
      CLM_Texas_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
    
    // the following test method covers the code coverage for the story PPN-48834 on the field Percentage of Medicaid fee schedule
    static testMethod void testData2() 
    {
  
       // Global Settings needed for using account object in test method advised by the contact team
       // This part needs to be uncommented out in SIT , UAT and Prod environments
       GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_TX';  
      acc.CM_Corporate_Entity_Code__c   = 'TX1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
        
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
      //Finiding the appropriate user to create an agreement for Texas Plan based on the role
      user u=[select Id from user where userrole.Name in ('CLM Texas', 'Texas Supervisor' ) AND user.IsActive = true limit 1];
      
      //agrmt will be using professional record type which will test if the default values are getting populated
      Apttus__APTS_Agreement__c agrmt = new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c = acc.Id;
      agrmt.OwnerId = u.Id;
      agrmt.Plan__c = 'Texas';
      agrmt.recordtypeId = CLM_ReimbursementModel.professionalRecordTypeId ;
      agrmt.Provider_Networks__c='CHIP Provider Network; STAR Kids Provider Network';
      agrmt.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      agrmtList.add(agrmt);
      
      // agrmt2 will be using medical record type which will test if the default values are getting removed 
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Texas';       
      agrmt2.recordtypeId=CLM_ReimbursementModel.medicalRecordTypeId ;
      agrmt2.Provider_Networks__c='CHIP Provider Network; STAR Kids Provider Network';
      agrmt2.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      agrmtList.add(agrmt2);
      
      // agrmt3 will be using medical record type which will test if the default values are getting populated
      Apttus__APTS_Agreement__c agrmt3=new Apttus__APTS_Agreement__c();
      agrmt3.Apttus__Account__c=acc.Id;
      agrmt3.OwnerId=u.Id;
      agrmt3.Plan__c='Texas';       
      agrmt3.recordtypeId=CLM_ReimbursementModel.medicalRecordTypeId ;
      agrmt3.Provider_Networks__c='CHIP Provider Network; STAR Kids Provider Network';
      agrmt3.CLM_Standard_or_Non_Standard_Base_Lan__c = null;
      agrmtList.add(agrmt3);
        
      // agrmt4 will be using professional record type which will test if the default values are getting removed 
      Apttus__APTS_Agreement__c agrmt4=new Apttus__APTS_Agreement__c();
      agrmt4.Apttus__Account__c=acc.Id;
      agrmt4.OwnerId=u.Id;
      agrmt4.Plan__c='Texas';       
      agrmt4.recordtypeId=CLM_ReimbursementModel.professionalRecordTypeId ;
      agrmt4.Provider_Networks__c=null;
      agrmt4.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      agrmtList.add(agrmt4);
      insert agrmtList;
      
      // updating fields in the agreements created to test the desired changes
      agrmt.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Non-Standard';
      agrmt.Provider_Networks__c=null;
      update agrmt;
      agrmt2.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Non-Standard';
      update agrmt2;
      agrmt3.CLM_Standard_or_Non_Standard_Base_Lan__c = 'Standard';
      update agrmt3;
      agrmt4.Provider_Networks__c='STAR Plus Provider Network';
      update agrmt4;
      
      //adding the agreements to the old map and new map
      oldMapAgrmt.put(agrmt4.Id,agrmt4);
      oldMapAgrmt.put(agrmt3.Id,agrmt3);
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt4.Id,agrmt4);
      newMapAgrmt.put(agrmt3.Id,agrmt3);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      //Running the test class with the target apex class
      Test.startTest();
      CLM_Texas_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
    
    
}