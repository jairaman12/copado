@isTest
public class MCCProcessFlagUpdateBatchTest {

    static testmethod void finishMethod_NetworkRecruitment(){
    
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
        
        List<MCC_Data_Object__c> mccObjList = [SELECT Name FROM MCC_Data_Object__c limit 5];
        set<String> mccNameSet = new Set<String>();
        if(mccObjList!=null && mccObjList.size()>0){ 
            for(MCC_Data_Object__c mccO:mccObjList){
                mccNameSet.add(mccO.Name);
            }
            system.debug('*****************'+mccObjList);
            system.debug('*****************'+mccNameSet);        
            Test.startTest();
                MCCProcessFlagUpdateBatch  bt = new MCCProcessFlagUpdateBatch(mccNameSet);
                Database.executeBatch( bt );
           Test.stopTest();
       } 
    }
    

}