@isTest
public class TestProviderCaseManagement {

    static testMethod void insertAcc() 
    {
        Test.startTest();
        
        GlobalSettings__c gs              = new GlobalSettings__c();
        gs.name                             = 'PFFileRecieved';
        gs.PFFileRecieved__c                = false;
        gs.Affiliation_Trigger_Switch__c    = false;
        gs.Record_Type_Names__c = 'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Id personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Physician').getRecordTypeId();
        Account Accnt = new Account(
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678',
            CM_Corporate_Entity_Code__c = 'IL1',
            recordTypeId = personRecordTypeId 
        );
        insert accnt;
        
         CM_Provider_Identification__c provIden = new CM_Provider_Identification__c();        
        provIden.CM_PI_Prov__c = Accnt.Id;
        provIden.CM_PI_Current_Status__c = 'New';
        provIden.CM_Corporate_Entity_Code__c = 'IL1';
        provIden.CM_Issu_Ident_Nmbr__c ='4331231232';
        insert provIden;  
                
         CM_Provider_Tax_Id__c provTaxIden = new CM_Provider_Tax_Id__c();        
        provTaxIden.CM_PTI_Prov_Name_To__c = Accnt.ID;
        provTaxIden.CM_PTI_Prov_Name_From__c = Accnt.Id;
        provTaxIden.CM_PTI_Tax_Id__c = 'Tax';
        provTaxIden.CM_Corporate_Entity_Code__c = 'IL1';             
         provTaxIden.CM_PTI_Tax_Id__c = '431231231';
         insert provTaxIden;
            Test.StopTest(); 
        
    }
 static testMethod void testPostMethod1() 
 {
  // create test data here
 TestContractingProviderDetailExt.createCustomSettingData();
  RestRequest req = new RestRequest();
  RestResponse res = new RestResponse();
  req.requestUri ='/services/apexrest/ProviderCaseManagement';
  req.httpMethod = 'POST';
    String JSONMsg = '{"Origin": "Web On-boarding","Priority": "Medium","Completing_the_form_for__c": "Individual","Name_Submitter__c": "Test","Title_Submitter__c": "Mr.","Telephone_Number_Submitter__c": 3122345678,"Email_Address_Submitter__c" : "avinash_kirnelli1@bcbsil.com","Name_of_Provider_Group__c": "Advocate","Tax_ID_Number__c": "431231231","Rendering_NPI__c": "1231231231","Billing_NPI_Number__c" : "4331231232","Bill_NPI_Type__c":"Type 1(Individual)","Plan_ID__c": "IL1","Subject":"Test Subject","Description":"Test Description","Review_URL__c": "www.google.com","Govt_Programs__c": false}'; 
      req.requestBody= Blob.valueof(JSONMsg);
  RestContext.request = req;
   RestContext.response= res;
    insertAcc();
   ResponseHandler testResp= ProviderCaseManagement.doPost();
 }
 static testMethod void testPostMethod2() 
 {
  // create test data here
 // createCustomSettings();
  TestContractingProviderDetailExt.createCustomSettingData();
  RestRequest req = new RestRequest();
  RestResponse res = new RestResponse();
  req.requestUri ='/services/apexrest/ProviderCaseManagement';
  req.httpMethod = 'POST';
    String JSONMsg = '{"Origin": "Web On-boarding","Priority": "Medium","Completing_the_form_for__c": "Individual","Name_Submitter__c": "Test","Title_Submitter__c": "Mr.","Telephone_Number_Submitter__c": 3122345678,"Email_Address_Submitter__c" : "avinash_kirnelli1@bcbsil.com","Name_of_Provider_Group__c": "Advocate","Tax_ID_Number__c": "431231231","Rendering_NPI__c": "1231231231","Billing_NPI_Number__c" : "4331231232","Bill_NPI_Type__c":"Type 1 (Individual)","Plan_ID__c": "IL1","Subject":"Test Subject","Description":"Test Description","Review_URL__c": "www.google.com","Govt_Programs__c": false}'; 
      req.requestBody= Blob.valueof(JSONMsg);
  RestContext.request = req;
   RestContext.response= res;
     insertAcc();
   ResponseHandler testResp= ProviderCaseManagement.doPost();
 }
static testMethod void testPostMethod3() 
 {
  // create test data here
  TestContractingProviderDetailExt.createCustomSettingData();
  RestRequest req = new RestRequest();
  RestResponse res = new RestResponse();
  req.requestUri ='/services/apexrest/ProviderCaseManagement';
  req.httpMethod = 'POST';
    String JSONMsg = '{"Origin": "Web On-boarding","Priority": "Medium","Completing_the_form_for__c": "Individual","Name_Submitter__c": "Test","Title_Submitter__c": "Mr.","Telephone_Number_Submitter__c": 3122345678,"Email_Address_Submitter__c" : "avinash_kirnelli1@bcbsil.com","Name_of_Provider_Group__c": "Advocate","Tax_ID_Number__c": "431231231","Rendering_NPI__c": "1231231231","Billing_NPI_Number__c" : "4331231232","Bill_NPI_Type__c":"Type 1 (Individual)","Plan_ID__c": "ILwrongvalue","Subject":"Test Subject","Description":"Test Description","Review_URL__c": "www.google.com","Govt_Programs__c": false}'; 
      req.requestBody= Blob.valueof(JSONMsg);
  RestContext.request = req;
   RestContext.response= res;
     insertAcc();
   ResponseHandler testResp= ProviderCaseManagement.doPost();
 }
    static testMethod void testPostMethod4() 
 {
  // create test data here
 TestContractingProviderDetailExt.createCustomSettingData();
  RestRequest req = new RestRequest();
  RestResponse res = new RestResponse();
  req.requestUri ='/services/apexrest/ProviderCaseManagement';
  req.httpMethod = 'POST';
    String JSONMsg = '{"Origin": "Email","Priority": "Medium","Completing_the_form_for__c": "Individual Providerwrongvalue","Name_Submitter__c": "Test","Title_Submitter__c": "Mr.","Telephone_Number_Submitter__c": 3122345678,"Email_Address_Submitter__c" : "avinash_kirnelli1@bcbsil.com","Name_of_Provider_Group__c": "Advocate","Tax_ID_Number__c": "431231231","Rendering_NPI__c": "1231231231","Billing_NPI_Number__c" : "4331231232","Bill_NPI_Type__c":"Type 1 (Individual)wrongvalue","Plan_ID__c": "IL1","Subject":"Test Subject","Description":"Test Description","Review_URL__c": "www.google.com","Govt_Programs__c": false}'; 
      req.requestBody= Blob.valueof(JSONMsg);
  RestContext.request = req;
   RestContext.response= res;
     insertAcc();
   ResponseHandler testResp= ProviderCaseManagement.doPost();
 }
    
        static testMethod void testPostMethod5() 
 {
  // create test data here
 TestContractingProviderDetailExt.createCustomSettingData();
  RestRequest req = new RestRequest();
  RestResponse res = new RestResponse();
  req.requestUri ='/services/apexrest/ProviderCaseManagement';
  req.httpMethod = 'POST';
    String JSONMsg = '{}'; 
      req.requestBody= Blob.valueof(JSONMsg);
  RestContext.request = req;
   RestContext.response= res;
     insertAcc();
   ResponseHandler testResp= ProviderCaseManagement.doPost();
 }
}