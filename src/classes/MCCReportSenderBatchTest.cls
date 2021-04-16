@isTest
public class MCCReportSenderBatchTest 
{
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
    
    static testmethod void finishMethod_NetworkRecruitment()
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;';
        gs.MCC_trigger_switch__c    =   false;
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1';    
        insert gs;
        
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1'); 
        insert acct;  
        
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='TX1';
        insert cs; 
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='TX1';
        insert objreportUser;          
        
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Network_recruitment'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test001';
        mcc.MCC_Grouping_ID__c = 'G001';
        mcc.MCC_Case_Type__c = 'CRM;';
        mcc.MCC_Request_Type__c = 'Network Recruitment';  
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'TX1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File001'; 
        mcc.File_Count__c  = 1.0;
        mcc.MCC_Case_Id__c  =cs.id;               
        insert mcc;  
        
        Test.startTest();
            MCCReportSenderBatch bt = new MCCReportSenderBatch();
            Database.executeBatch( bt );
            System.Schedule('MCCreportSenderBatch', '0 0 * * * ?', new MCCReportSenderBatch());
       Test.stopTest(); 
    }
    
    
    
    static testmethod void finishMethod_RosterFile()
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;'; 
        gs.MCC_trigger_switch__c    =   false;
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        insert gs;
        
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1'); 
        insert acct;
        
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='IL1';
        insert cs;  
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='IL1';
        insert objreportUser;            
        
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
        mcc.MCC_Case_Type__c = 'CRM';
        mcc.MCC_File_Type__c = 'ILR';  
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'IL1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.File_Count__c  = 1.0;
         mcc.MCC_Case_Id__c  =cs.id;                
        insert mcc;    
        
         
        Test.startTest();
            MCCReportSenderBatch bt = new MCCReportSenderBatch();
            Database.executeBatch( bt );
            System.Schedule('MCCreportSenderBatch', '0 0 * * * ?', new MCCReportSenderBatch());
       Test.stopTest(); 
        
   }
    static testmethod void finishMethod_masscaseCLose()
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;'; 
        gs.MCC_trigger_switch__c    =   false;
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        insert gs;
        
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'TX1'); 
        insert acct;             
        
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='TX1';
        insert cs;
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='TX1';
        insert objreportUser; 
        
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        //mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
        mcc.MCC_Case_Type__c = 'CRM';
        mcc.MCC_File_Type__c = 'ADC Mass Status';  
        mcc.MCC_Case_Status__c = 'Closed Processed';   
        mcc.MCC_Plan_ID__c = 'TX1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File004';
        mcc.File_Count__c  = 1.0;
        mcc.MCC_Case_Id__c  =cs.id;              
        insert mcc;
        
         
        Test.startTest();
            MCCReportSenderBatch bt = new MCCReportSenderBatch();
            Database.executeBatch( bt );
            System.Schedule('MCCreportSenderBatch', '0 0 * * * ?', new MCCReportSenderBatch());
       Test.stopTest(); 
        
   }
    
    static testmethod void finishMethod_CredCase()
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;'; 
        gs.MCC_trigger_switch__c    =   false;
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        insert gs;
        
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1'); 
        insert acct;
        
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='IL1';
        insert cs;  
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='IL1';
        insert objreportUser;            
        
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
       mcc.MCC_File_Type__c = 'Onboarding Cred Mass Status Update';  
        mcc.MCC_Case_Status__c = 'Cred Denied'; 
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'IL1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.File_Count__c  = 1.0;
         mcc.MCC_Case_Id__c  =cs.id;                
        insert mcc;    
        
         
        Test.startTest();
            MCCReportSenderBatch bt = new MCCReportSenderBatch();
            Database.executeBatch( bt );
            System.Schedule('MCCreportSenderBatch', '0 0 * * * ?', new MCCReportSenderBatch());
       Test.stopTest(); 
        
   }
   
   static testmethod void finishMethod_NetworkLoadMassStatus()
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;'; 
        gs.MCC_trigger_switch__c    =   false;
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        insert gs;
        
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1'); 
        insert acct;
        
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='IL1';
        insert cs;  
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='IL1';
        insert objreportUser;            
        
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
       mcc.MCC_File_Type__c = 'Network Load Mass Status';  
        mcc.MCC_Case_Status__c = 'Cred Denied'; 
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'IL1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.File_Count__c  = 1.0;
         mcc.MCC_Case_Id__c  =cs.id;                
        insert mcc;    
        
         
        Test.startTest();
            MCCReportSenderBatch bt = new MCCReportSenderBatch();
            Database.executeBatch( bt );
            System.Schedule('MCCreportSenderBatch', '0 0 * * * ?', new MCCReportSenderBatch());
       Test.stopTest(); 
        
   }
   
   
   static testmethod void finishMethod_MassCRMCreation()
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;'; 
        gs.MCC_trigger_switch__c    =   false;
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        insert gs;
        
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1'); 
        insert acct;
        
        Case cs=new Case();
        cs.status='New';
        cs.Plan_ID__c='IL1';
        insert cs;  
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='IL1';
        insert objreportUser;            
        
        MCC_Data_Object__c mcc = new MCC_Data_Object__c();
        mcc.recordTypeId = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'MCC_Data_Object__c' and DeveloperName =: 'Roster'].Id;
        mcc.MCC_Prov_ID__c = acct.Id;
        mcc.MCC_Project_Number__c = 'Test003';
        mcc.MCC_Grouping_ID__c = 'G003';
       mcc.MCC_File_Type__c = 'Mass CRM Creation';  
        mcc.MCC_Case_Status__c = 'Cred Denied'; 
        mcc.MCC_Case_Status__c = 'New';   
        mcc.MCC_Plan_ID__c = 'IL1';
        mcc.MCC_Priority__c = 'High'; 
        mcc.MCC_File_Id__c = 'File003';
        mcc.File_Count__c  = 1.0;
         mcc.MCC_Case_Id__c  =cs.id;                
        insert mcc;    
        
         
        Test.startTest();
            MCCReportSenderBatch bt = new MCCReportSenderBatch();
            Database.executeBatch( bt );
            System.Schedule('MCCreportSenderBatch', '0 0 * * * ?', new MCCReportSenderBatch());
       Test.stopTest(); 
        
   }
    
}