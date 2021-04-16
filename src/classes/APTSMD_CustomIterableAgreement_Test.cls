@istest

public class APTSMD_CustomIterableAgreement_Test{
  
  static testmethod void testData(){
      
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
  
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_IL';  
      acc.CM_Corporate_Entity_Code__c   = 'IL1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      //agrmt.OwnerId=u.Id;
      //agrmt.Plan__c='Illinois';
      agrmt.Provider_Networks__c=  null;
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Percent_of_Covered_Charges__c= 10;
      
      insert agrmt;
      APTSMD_AgreementWrapper wrap=new APTSMD_AgreementWrapper(agrmt,true);
      
     List<APTSMD_AgreementWrapper> lstAccWr=new List<APTSMD_AgreementWrapper>();
     APTSMD_CustomIterableAgreement ctrl=new APTSMD_CustomIterableAgreement(lstAccWr);
     ctrl.hasNext();
     ctrl.hasPrevious();
     ctrl.next();
     ctrl.previous();
  }
  
  static testmethod void testData2(){
      
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
  
      Account acc= new Account();
      acc.Name               = 'Test Account CLM_Plan_IL';  
      acc.CM_Corporate_Entity_Code__c   = 'IL1';
      acc.RecordTypeId          = [SELECT Id, Name FROM RecordType WHERE Name = 'Entity Account'].Id;
      insert acc;
      
      Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      //agrmt.OwnerId=u.Id;
      //agrmt.Plan__c='Illinois';
      agrmt.Provider_Networks__c=  null;
      agrmt.recordtypeId=professionalRecordTypeId ;
      agrmt.Percent_of_Covered_Charges__c= 10;
      
      insert agrmt;
      APTSMD_AgreementWrapper wrap=new APTSMD_AgreementWrapper(agrmt,true);
      
     List<APTSMD_AgreementWrapper> lstAccWr=new List<APTSMD_AgreementWrapper>();
     APTSMD_CustomIterableAgreement ctrl=new APTSMD_CustomIterableAgreement(lstAccWr);
     ctrl.i=5;
     ctrl.setPageSize=2;
     ctrl.hasNext();
     ctrl.hasPrevious();
     ctrl.next();
     ctrl.previous();
  }
  
  
}