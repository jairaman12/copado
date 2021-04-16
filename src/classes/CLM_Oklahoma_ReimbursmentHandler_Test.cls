@isTest
public class CLM_Oklahoma_ReimbursmentHandler_Test {
    static testMethod void testData() {
  
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_OK';  
      acc.CM_Corporate_Entity_Code__c   = 'OK1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
      
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
  
     
        user u=[select Id from user where userrole.Name in ('CLM Oklahoma' ,'Oklahoma Supervisor') AND user.IsActive = true limit 1];
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Oklahoma';
      agrmt.Provider_Networks__c='OK BCBS Medicare Advantage HMO Provider network; OK BCBS Medicare Advantage PPO Provider network';
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Provider_Service_Type__c= null;
      agrmt.Percent_of_Covered_Charges__c= 10;
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Oklahoma';
      
      agrmt2.Provider_Networks__c='OK BCBS Medicare Advantage HMO Provider network; OK BCBS Medicare Advantage PPO Provider network';
       
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Prof-HCP;Prof-PCP';
      agrmt2.Percent_of_Covered_Charges__c= 10;
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c=  'Prof-HCP';
      update agrmt;
      agrmt2.Provider_Service_Type__c=  null;
      update agrmt2;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
     
      Test.startTest();
      CLM_Oklahoma_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
    
    static testMethod void testData2() {
  
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_OK';  
      acc.CM_Corporate_Entity_Code__c   = 'OK1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Medical Group').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
       user u=[select Id from user where userrole.Name in ('CLM Oklahoma' ,'Oklahoma Supervisor') AND user.IsActive = true limit 1];
      
        
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Oklahoma';
      agrmt.Provider_Networks__c=  'OK BCBS Medicare Advantage HMO Provider network ; OK BCBS Medicare Advantage PPO Provider network';
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Provider_Service_Type__c= null;
      agrmt.Percent_of_Covered_Charges__c= 10;
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Oklahoma';
      agrmt2.Provider_Networks__c= 'OK BCBS Medicare Advantage HMO Provider network ;OK BCBS Medicare Advantage PPO Provider network';
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Speech Therapist;Chiropractor';
      agrmt2.Percent_of_Covered_Charges__c= 10;
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c=  'Speech Therapist;Chiropractor';
      update agrmt;
      agrmt2.Provider_Service_Type__c=  null;
      update agrmt2;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      Test.startTest();
      CLM_Oklahoma_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
    
    static testMethod void testData3() {
  
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_OK';  
      acc.CM_Corporate_Entity_Code__c   = 'OK1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
       
     user u=[select Id from user where userrole.Name in ('CLM Oklahoma' ,'Oklahoma Supervisor') AND user.IsActive = true limit 1];
      
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Oklahoma';
      agrmt.Provider_Networks__c='OK BCBS Medicare Advantage HMO Provider network; OK BCBS Medicare Advantage PPO Provider network; OK Blue Advantage PPO Provider Network; OK Blue Choice PPO Provider Network;OK Blue Preferred PPO Provider Network;OK BlueLincs HMO Provider Network;OK BlueTraditional Provider Network;OK Blue Plan65 Select Provider Network';
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Provider_Service_Type__c= null;
      agrmt.Percent_of_Covered_Charges__c= 10;
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Oklahoma';
      agrmt2.Provider_Networks__c=  'OK BCBS Medicare Advantage HMO Provider network; OK BCBS Medicare Advantage PPO Provider network; OK Blue Advantage PPO Provider Network; OK Blue Choice PPO Provider Network;OK Blue Preferred PPO Provider Network;OK BlueLincs HMO Provider Network;OK BlueTraditional Provider Network;OK Blue Plan65 Select Provider Network';
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Facility-LTAC;Psych;RTC;Facility -Acute Care';
      agrmt2.Percent_of_Covered_Charges__c= 10;
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c='Facility-LTAC;Psych;RTC;Facility -Acute Care';
      update agrmt;
      agrmt2.Provider_Service_Type__c=  null;
      update agrmt2;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
     
      
      Test.startTest();
      CLM_Oklahoma_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
 
    
    static testMethod void testData4() {
  
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_OK';  
      acc.CM_Corporate_Entity_Code__c   = 'OK1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Non-ASC Ancillary').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
      user u=[select Id from user where userrole.Name in ('CLM Oklahoma' ,'Oklahoma Supervisor') AND user.IsActive = true limit 1];
            
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Oklahoma';
      agrmt.Provider_Networks__c=  'OK BCBS Medicare Advantage HMO Provider network; OK BCBS Medicare Advantage PPO Provider network; OK Blue Advantage PPO Provider Network; OK Blue Choice PPO Provider Network;OK Blue Preferred PPO Provider Network;OK BlueLincs HMO Provider Network;OK BlueTraditional Provider Network;OK Blue Plan65 Select Provider Network';
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Provider_Service_Type__c= null;
      agrmt.Percent_of_Covered_Charges__c= 10;
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Oklahoma';
      agrmt2.Provider_Networks__c=  'OK BCBS Medicare Advantage HMO Provider network; OK BCBS Medicare Advantage PPO Provider network; OK Blue Advantage PPO Provider Network; OK Blue Choice PPO Provider Network;OK Blue Preferred PPO Provider Network;OK BlueLincs HMO Provider Network;OK BlueTraditional Provider Network;OK Blue Plan65 Select Provider Network';
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Provider_Service_Type__c='DME;SNF;Lab';
      agrmt2.Percent_of_Covered_Charges__c= 10;
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c='DME;SNF;Lab';
      update agrmt;
      agrmt2.Provider_Service_Type__c=  null;
      update agrmt2;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
     
      Test.startTest();
      CLM_Oklahoma_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
        static testMethod void testData5() {
  
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_OK1';  
      acc.CM_Corporate_Entity_Code__c   = 'OK1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
           
                 
  user u=[select Id from user where userrole.Name in ('CLM Oklahoma' ,'Oklahoma Supervisor') AND user.IsActive = true limit 1];
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Oklahoma';
      agrmt.Provider_Networks__c=  null;
      agrmt.recordtypeId=professionalRecordTypeId ;
      //agrmt.Percent_of_Covered_Charges__c= 10;
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Oklahoma';
      agrmt2.Provider_Networks__c= 'OK BCBS Medicare Advantage HMO Provider network';
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Percent_of_Covered_Charges__c= 10;
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      
      
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      Test.startTest();
      CLM_Oklahoma_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
  
}