@isTest
public class CLM_Montana_ReimbursementHandler_Test {

    static testMethod void testData() {
  
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_MT';  
      acc.CM_Corporate_Entity_Code__c   = 'MT1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
       
      list<Apttus__APTS_Agreement__c> agrmtList=new list<Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> oldMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> newMapAgrmt=new Map<Id,Apttus__APTS_Agreement__c>();
        
   
        user u=[select Id from user where userrole.Name in('CLM Montana','Montana Supervisor') AND user.IsActive = true limit 1];
        
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Montana';
      agrmt.Provider_Networks__c=  'MT Medicare Advantage HMO Provider network';
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Percent_of_Covered_Charges__c= 10;
     
      agrmtList.add(agrmt);
      
      Apttus__APTS_Agreement__c agrmt2=new Apttus__APTS_Agreement__c();
      agrmt2.Apttus__Account__c=acc.Id;
      agrmt2.OwnerId=u.Id;
      agrmt2.Plan__c='Montana';
      agrmt2.Provider_Networks__c = 'MT Blue Focus Provider Network';
      agrmt2.recordtypeId=professionalRecordTypeId ;
      agrmt2.Percent_of_Covered_Charges__c= 10;
      agrmtList.add(agrmt2);
      
      
      
      insert agrmtList;
      agrmt.Provider_Networks__c = null;
      update agrmt;
      agrmt2.Provider_Networks__c = 'MT Medicare Advantage HMO Provider network';
      update agrmt2;
      
      
      oldMapAgrmt.put(agrmt2.Id,agrmt2);
      oldMapAgrmt.put(agrmt.Id,agrmt);
      newMapAgrmt.put(agrmt2.Id,agrmt2);
      newMapAgrmt.put(agrmt.Id,agrmt);
     
      
      Test.startTest();
      CLM_Montana_ReimbursementHandler.beforeUpdate(agrmtList,oldMapAgrmt,newMapAgrmt);
      Test.stopTest();
  }
}