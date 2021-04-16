/**************************************************************************************************
Apex Class Name  : MCCLoadStatusUpdateBatch_Test
Version          : 1.0  
Functionality    : Test class for MCCLoadStatusUpdateBatch
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                  
* Saravana Bharathi           05/21/2018              PPN-16156
  SethuRaman                  06/05/2018              PPN-17298
***************************************************************************************************/
@isTest
public class MCCLoadStatusUpdateBatch_Test 
{
     @testSetup static void prepareData() {
         
         GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;';  
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        gs.MCC_trigger_switch__c    =   false;
        insert gs;
         
         List<MCC_Report_Users__c> mccUsersList =  new List<MCC_Report_Users__c>();
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='TX1';
        
    mccUsersList.add(objreportUser);
        
        MCC_Report_Users__c objreportUser1=new MCC_Report_Users__c();           
        objreportUser1.Email__c='test1@bcbsil.com';
        objreportUser1.name='test user1';
        objreportUser1.Plan_Id__c='IL1';
        
        mccUsersList.add(objreportUser1);
        
        MCC_Report_Users__c objreportUser2=new MCC_Report_Users__c();           
        objreportUser2.Email__c='test2@bcbsil.com';
        objreportUser2.name='test user2';
        objreportUser2.Plan_Id__c='MT1';
        mccUsersList.add(objreportUser2);
        
        MCC_Report_Users__c objreportUser3=new MCC_Report_Users__c();           
        objreportUser3.Email__c='test3@bcbsil.com';
        objreportUser3.name='test user3';
        objreportUser3.Plan_Id__c='OK1';
        
        mccUsersList.add(objreportUser3);
        
         MCC_Report_Users__c objreportUser4 = new MCC_Report_Users__c();           
        objreportUser4.Email__c='test4@bcbsil.com';
        objreportUser4.name='test user4';
        objreportUser4.Plan_Id__c='NM1';
         mccUsersList.add(objreportUser4);
        
        insert mccUsersList;
     }
    
   
   static testmethod void finishMethod_OnboardingCredMassStatusUpdate()
    {
       
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'TX1'); 
        insert acct;
        
      
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='TX1';
        insert cs;
             
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
        mcc.MCC_Case_Type__c = 'CRM';
        mcc.MCC_File_Type__c = 'Onboarding Cred Mass Status Update';  
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'TX1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.MCC_Case_Id__c  =cs.id; 
          insert mcc; 
         
         List<case> caseList = [Select Id,MCC_Record_Name__c from Case limit 5];    
         List<MCC_Data_Object__c > mccList = [Select Id,Name from MCC_Data_Object__c where Id=:mcc.Id];       
         
         if(caseList!=null && caseList.size()>0){
         
         for(Case cas:caseList){
             if(mccList!=null && mccList.size()>0){
                 cas.MCC_Record_Name__c = mccList[0].Name;
             }         
         }         
         
         update caseList;
         system.debug('*****************'+caseList);
               
        
            Test.startTest();
            MCCLoadStatusUpdateBatch bt = new MCCLoadStatusUpdateBatch(caseList);
            Database.executeBatch( bt );
            Test.stopTest(); 
       }
        
   }
   
    static testmethod void finishMethod_onBoardingCredRequestType()
    {
       
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'TX1'); 
        insert acct;
        
      
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='TX1';
        cs.status ='New';
        insert cs;
             
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
        mcc.MCC_Case_Type__c = 'CRM';
        mcc.MCC_File_Type__c = 'onBoardingCredRequestType';  
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'TX1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.MCC_Case_Id__c  =cs.id; 
          insert mcc; 
         
         List<case> caseList = [Select Id,MCC_Record_Name__c,status from Case limit 5];    
         List<MCC_Data_Object__c > mccList = [Select Id,Name from MCC_Data_Object__c where Id=:mcc.Id];       
         
         if(caseList!=null && caseList.size()>0){
         
         for(Case cas:caseList){
             if(mccList!=null && mccList.size()>0){
                 cas.MCC_Record_Name__c = mccList[0].Name;
                 cas.Status = 'New';
             }
         }         
         
         update caseList;
         system.debug('*****************'+caseList);
               
        
            Test.startTest();
            MCCLoadStatusUpdateBatch bt = new MCCLoadStatusUpdateBatch(caseList);
            Database.executeBatch( bt );
            Test.stopTest(); 
       }
        
   }
   
   static testmethod void finishMethod_ADCMassStatus()
    {
       
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'TX1'); 
        insert acct;
        
      
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='TX1';
        cs.status ='New';
        insert cs;
             
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
        mcc.MCC_Case_Type__c = 'CRM';
        mcc.MCC_File_Type__c = 'ADC Mass Status';  
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'TX1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.MCC_Case_Id__c  =cs.id; 
          insert mcc; 
         
         List<case> caseList = [Select Id,MCC_Record_Name__c,status from Case limit 5];    
         List<MCC_Data_Object__c > mccList = [Select Id,Name from MCC_Data_Object__c where Id=:mcc.Id];       
         
         if(caseList!=null && caseList.size()>0){
         
         for(Case cas:caseList){
             if(mccList!=null && mccList.size()>0){
                 cas.MCC_Record_Name__c = mccList[0].Name;
             }
         }         
         
         update caseList;
         system.debug('*****************'+caseList);
               
        
            Test.startTest();
            MCCLoadStatusUpdateBatch bt = new MCCLoadStatusUpdateBatch(caseList);
            Database.executeBatch( bt );
            Test.stopTest(); 
       }
        
   }
}