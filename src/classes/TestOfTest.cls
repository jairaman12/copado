@isTest
private class TestOfTest {  
    @testSetup static void prepareData() {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        List<RecordType_settings__c> rtsList    =    new List<RecordType_settings__c>();
        List<RecordType> recordTypeList = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType];
        for( RecordType recType : recordTypeList  )
        {
            RecordType_settings__c rts  =   new RecordType_settings__c();
            rts.name                    =   recType.Id;
            rts.DeveloperName__c        =   recType.DeveloperName;
            rts.Name__c                 =   recType.Name;
            rts.Record_type_Id__c       =   recType.Id;
            rts.sObject_Type__c         =   recType.SobjectType;
            rtsList.add(rts);
        }
        insert rtsList;
        
    }  

   public static testMethod void testCloseParent() {
        Test.startTest();
        Case  mCase = TestCaseUtil.CreateCase();
        insert mCase;

        Test.stopTest();
    }
}