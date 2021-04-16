@isTest
private class CLM_NewMexico_ReimbursementHandler_Test{

  static testMethod void testData() {
  
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;

        Account acc= new Account();

        acc.Name               = 'Test Account CLM_Plan_NM';  
        acc.CM_Corporate_Entity_Code__c   = 'NM1';
        acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
        insert acc;
      
     
      Id facilityRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
      
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
     
      
      user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];

      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c='NM Medicare Advantage HMO Provider Network;NM Medicaid Provider Network';
      agrmt.recordtypeId=facilityRecordTypeId ;
      agrmt.Provider_Service_Type__c=null;//'Facility-Rehab';
      agrmt.Percent_of_Covered_Charges__c=10; 
          
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c= 'New Mexico';
      agrmt2.Provider_Networks__c='NM Medicare Advantage PPO Provider Network';
      agrmt2.recordtypeId=facilityRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Facility-Rehab';
      agrmt2.Percent_of_Covered_Charges__c=10;    
      agrmtList.add(agrmt2);
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c='Facility-Rehab';
      update agrmt;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
     
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
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

      acc.Name = 'Test Account CLM_Plan_NM';  
      acc.CM_Corporate_Entity_Code__c   = 'NM1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id facilityRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
    user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];
      
          
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c= 'NM Medicare Advantage PPO Provider Network';
      agrmt.recordtypeId=facilityRecordTypeId ;
      agrmt.Provider_Service_Type__c=null;//'Facility -Acute Care';
      agrmt.Percent_of_Covered_Charges__c=10; 
      agrmtList.add(agrmt);
      
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c= 'New Mexico';
      agrmt2.Provider_Networks__c='NM Medicaid Provider Network';
      agrmt2.recordtypeId=facilityRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Facility -Acute Care';
      agrmt2.Percent_of_Covered_Charges__c=10;
      
      agrmtList.add(agrmt2);
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c='Facility -Acute Care';
      update agrmt;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
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
      acc.Name= 'Test Account CLM_Plan_NM';  
      acc.CM_Corporate_Entity_Code__c   = 'NM1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id facilityRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
  user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c=  'NM Medicaid Provider Network';
      agrmt.recordtypeId=facilityRecordTypeId ;
      agrmt.Provider_Service_Type__c='Facility-Rehab';
      agrmt.Percent_of_Covered_Charges__c=10; 
      agrmt.Acute_Inpatient_Rehab_Per_Diem__c = 785.00;
      agrmt.Excluded_Services_Per_Treatment_Amount__c = 375.00;
      agrmt.Single_Outpatient_Rehab_per_unit__c = 20.9;
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='New Mexico';
      agrmt2.Provider_Networks__c= 'NM Medicaid Provider Network';
      agrmt2.recordtypeId=facilityRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Facility -Acute Care';
      agrmt2.Percent_of_Covered_Charges__c=10;
      agrmt2.Acute_Inpatient_Rehab_Per_Diem__c = 785.00;
      agrmt2.Excluded_Services_Per_Treatment_Amount__c = 375.00;
      agrmt2.Single_Outpatient_Rehab_per_unit__c = 20.9;
      
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c='Facility -Acute Care';
      update agrmt;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
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
      acc.Name= 'Test Account CLM_Plan_NM';  
      acc.CM_Corporate_Entity_Code__c   = 'NM1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id facilityRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
     
    user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c=  'NM Medicaid Provider Network';
      agrmt.recordtypeId=facilityRecordTypeId ;
      agrmt.Provider_Service_Type__c='Facility -Acute Care';
      agrmt.Percent_of_Covered_Charges__c=10; 
      agrmt.Acute_Inpatient_Rehab_Per_Diem__c = 785.00;
      agrmt.Excluded_Services_Per_Treatment_Amount__c = 375.00;
      agrmt.Single_Outpatient_Rehab_per_unit__c = 20.9;
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='New Mexico';
      agrmt2.Provider_Networks__c= 'NM Medicaid Provider Network';
      agrmt2.recordtypeId=facilityRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Facility-Rehab';
     agrmt2.Percent_of_Covered_Charges__c=10;
      agrmt2.Acute_Inpatient_Rehab_Per_Diem__c = 785.00;
      agrmt2.Excluded_Services_Per_Treatment_Amount__c = 375.00;
      agrmt2.Single_Outpatient_Rehab_per_unit__c = 20.9;
      
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c='Facility-Rehab';
      update agrmt;
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
     
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
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
      acc.Name = 'Test Account CLM_Plan_NM';  
      acc.CM_Corporate_Entity_Code__c   = 'NM1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id ANCRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Non-ASC Ancillary').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
    user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c=  'NM Medicaid Provider Network';
      agrmt.recordtypeId=ANCRecordTypeId ;
      agrmt.Provider_Service_Type__c= 'Facility-Rehab';
      agrmt.Percent_of_Covered_Charges__c=10; 
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='New Mexico';
      agrmt2.Provider_Networks__c= 'NM Medicaid Provider Network';
      agrmt2.recordtypeId=ANCRecordTypeId ;
      agrmt2.Provider_Service_Type__c='Facility-Rehab';
      agrmt2.Percent_of_Covered_Charges__c=10;
      
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c= 'Birthing Center';
      update agrmt;
      
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
     
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
  
  static testMethod void testData6() {
  
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name = 'Test Account CLM_Plan_NM';  
      acc.CM_Corporate_Entity_Code__c   = 'NM1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id medicalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Medical Group').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
    user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c=  'NM Medicaid Provider Network';
      agrmt.recordtypeId=medicalRecordTypeId ;
      agrmt.Provider_Service_Type__c= null;
      agrmt.Percent_of_Covered_Charges__c=10; 
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='New Mexico';
      agrmt2.Provider_Networks__c= 'NM Medicaid Provider Network';
      agrmt2.recordtypeId=medicalRecordTypeId ;
      agrmt2.Provider_Service_Type__c='MG-Anesthesia';
      agrmt2.Provider_Service_Type__c='MG-Behavioral';
      agrmt2.Provider_Service_Type__c='MG-Chiropractic';
      agrmt2.Provider_Service_Type__c='MG-PCP';
      agrmt2.Percent_of_Covered_Charges__c=10;
      
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c= 'MG-Anesthesia';
      update agrmt;
      
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
      
  }
  
  
  static testMethod void testData7() {
  
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_NM';  
      acc.CM_Corporate_Entity_Code__c   = 'NM1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      
     user u=[select Id from user where userrole.Name in('CLM New Mexico', 'New Mexico Supervisor') AND user.IsActive = true limit 1];
      
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='New Mexico';
      agrmt.Provider_Networks__c=  'NM Medicaid Provider Network';
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Provider_Service_Type__c= null;
      agrmt.Percent_of_Covered_Charges__c=10; 
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='New Mexico';
      agrmt2.Provider_Networks__c= 'NM Medicaid Provider Network';
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Provider_Service_Type__c= 'Prof-Anesthesia';
      agrmt2.Provider_Service_Type__c='Prof-Behavioral';
      agrmt2.Provider_Service_Type__c='Prof-Chiropractic';
      agrmt2.Provider_Service_Type__c='Prof-PCP';
      agrmt2.Percent_of_Covered_Charges__c=10;
      
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Service_Type__c=  'Prof-Anesthesia';
      update agrmt;
      
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
      
      Test.startTest();
      CLM_NewMexico_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
      
  }
  
}