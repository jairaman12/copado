@isTest
public class ProviderDetailsTrigger_Test {
    
      @isTest
        static void test_caseOwnerChange(){
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        testclassdata.CreateCustomSettingData('Case');
        testclassdata.CreateCustomSettingData('Provider_Networks__c');
        
        
            List<RecordType> recType =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE DeveloperName In ('Master_Provider_Case_data','Network_Load')];
            Case parentCase          =  TestCaseUtil.CreateCase();   
            parentCase.Email_Address_Submitter__c   =   'test@test.com';
            parentCase.RecordTypeId =   recType[0].id;
            parentCase.Plan_ID__c   =   'IL1';
            parentCase.Status       =   'New';
            parentCase.Subject     =   'Test Email';
            parentCase.Origin      =   'PNC NetOps Inquiries';
            
            insert parentCase;
            
            Case childCase          =   TestCaseUtil.CreateCase();   
            childCase.ParentId      =   parentCase.id; 
            childCase.Email_Address_Submitter__c    =   'test3@test.com';
            childCase.RecordTypeId  =   recType[1].id;
            childCase.Govt_Programs__c              =   true;
            childCase.Plan_ID__c                    =   'IL1';
            childCase.Status                        =   'New';  
            childCase.Completing_the_form_for__c = 'Individual';
            
            insert childCase;
      
   
       // Integer MAX_QUERY = Limits.getLimitQueries(); 
       // Integer NUM_QUERY = MAX_QUERY - 1; 
           
            List<Provider_Networks__c> pns = new List<Provider_Networks__c>();       
            pns = testDataFactory.ProviderNetworkCreation(1,'IL1','01241000001h1Bw');         
            pns[0].Case_Number__c = childCase.Id;
            pns[0].Designation_Code__c = 'test';
            pns[0].Prior_Provider_Id__c = string.valueof(pns[0].Id).substring(0,15);
             Test.StartTest();
             // System.assertNotEquals(NUM_QUERY, Limits.getQueries()); 
           //update pns[0];
            pns[0].Comp_Grid_Code__c = 'test';          
             //update pns[0];
           delete pns[0];
          //  System.assertEquals(NUM_QUERY, Limits.getQueries()); 
         Test.StopTest();     
    }
}