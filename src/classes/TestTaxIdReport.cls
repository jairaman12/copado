/*******************************************
@Author Avinash KR 
@Date   10/17/2017
@Description methods and properties related to test code coverage for TaxIdReportController 
********************************************/

@isTest
private class TestTaxIdReport{
  
  
    
  @testSetup
  static void setupTestData(){
      
     GlobalSettings__c gs   =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs; 
    test.startTest();
    Account account_Obj = new Account(Name = 'Name209', Directory_Exclusion__c = false, CM_Corporate_Entity_Code__c='IL1');
    Insert account_Obj; 
    Case case_Obj = new Case(AccountId = account_Obj.id, Reason = 'User didt attend training', Origin = 'Email', Subject = 'Subject505', Description = '21', IsEscalated = false, Administrative_Address_Telephone_Fax_Ema__c = false, Billing_Address_Telephone_Fax_Email_Chan__c = false, Credentialing_Address_Telephone_Fax_Emai__c = false, NPI_Tax_Id_Change__c = false, Name_Change__c = false, Office_Physical_Address_Telephone_Fax_Em__c = false, Open_24__c = false, Other_provider_Info__c = false, Tax_ID_Number__c = 'Tax_I362', Remove_From_All_Locations__c = false, MC_Add__c = false, Remove_Provider_from_Group_Location__c = false, MC_Delete__c = false, Attestation__c = false, Add_Provider_Accepting_New_Patients__c = false, Exam_Room__c = false, Office_Reception_Area__c = false, Add_Provider_from_Group_Location__c = false, MC_Change__c = false, Do_Not_Add_List__c = false, Add_Another_Location_For_Removal__c = false, Excel_Attached__c = false, Plan_Id_Validation_By_Pass__c = false, CS_Benefits__c = false, CS_Case_Status_Check__c = false, CS_Complaints__c = false, CS_Contracting__c = false, CS_Credentialing_Status_Check__c = false, CS_Ecommerce__c = false, CS_Network_Status_Check__c = false, CS_Retroactive_Claim_Check__c = false, CS_Pre_determination_Check__c = false, CS_Pre_authorization_Check__c = false, CS_Claims__c = false, CS_Paper_Payment_Status_Check__c = false, Network_Change__c = false, Accepting_New_Patients_add_prov_Phy__c = false, CS_Fee_Schedule__c = false, CS_Provider_Roster_Report__c = false, CS_Claims_Project__c = false, CS_Retro_Requests__c = false, Govt_Programs__c = false, Open_24_7_Curr__c = false);
    Insert case_Obj; 
    CM_Provider_Tax_Id__c cm_provider_tax_id_Obj = new CM_Provider_Tax_Id__c(CM_PTI_Prov_Name_From__c = account_Obj.id, CM_PTI_Tax_Id__c = 'CM_PT410', CM_PTI_Tax_Shared_Ind__c = false, CM_Corporate_Entity_Code__c = 'MT1');
    Insert cm_provider_tax_id_Obj; 
    test.stopTest();
  }
    

  Public static testMethod void testgetAccounts_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,Name from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Case> case_Obj  =  [SELECT Id,CaseNumber,AccountId,Reason,Origin,Subject,Description,Case_Entity__c,Tax_ID_Number__c,Plan_Id_Validation_By_Pass__c,Govt_Programs__c,Open_24_7_Curr__c from Case];
    System.assertEquals(true,case_Obj.size()>0);
    List<CM_Provider_Tax_Id__c> cm_provider_tax_id_Obj  =  [SELECT CM_PTI_Prov_Name_From__c,CM_PTI_Tax_Id__c from CM_Provider_Tax_Id__c];
    System.assertEquals(true,cm_provider_tax_id_Obj.size()>0);
    TaxIdReport obj01 = new TaxIdReport();
    obj01.accounts = account_Obj;
    obj01.taxId = cm_provider_tax_id_Obj[0].CM_PTI_Tax_Id__c;
    obj01.getAccounts();
  }
    
  Public static testMethod void testdownloadReport_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,Name from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Case> case_Obj  =  [SELECT Id,CaseNumber,AccountId,Reason,Origin,Subject,Description,Case_Entity__c,Tax_ID_Number__c,Plan_Id_Validation_By_Pass__c,Govt_Programs__c,Open_24_7_Curr__c from Case];
    System.assertEquals(true,case_Obj.size()>0);
    List<CM_Provider_Tax_Id__c> cm_provider_tax_id_Obj  =  [SELECT CM_PTI_Prov_Name_From__c,CM_PTI_Tax_Id__c from CM_Provider_Tax_Id__c];
    System.assertEquals(true,cm_provider_tax_id_Obj.size()>0);
    TaxIdReport obj01 = new TaxIdReport();
    obj01.accounts = account_Obj;
    obj01.taxId = cm_provider_tax_id_Obj[0].CM_PTI_Tax_Id__c;
    obj01.downloadReport();
  }
}