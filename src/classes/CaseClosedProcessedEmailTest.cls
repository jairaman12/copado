/**
 * 
 * @Author Provider Intake Team
 * @Description - Test Class for Email Notification to Provider Whenever Parent Case is Closed Processed or Close Rejected.
 * @Date 10/11/2016
 * */
@isTest
private class CaseClosedProcessedEmailTest
{
  
     @testSetup static void prepareData() {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
    }
   static testMethod void emailTest()
    {
        Rec_Id__c rec           =   new Rec_Id__c();
        rec.Org_Wide_Email__c      =   'test@test.com';
        rec.Name                =   'Default Account';
        insert rec;
      
        List<Email_Settings__c> settingsList = new List<Email_Settings__c>();
        
        Email_Settings__c settings  =   new Email_Settings__c();
        settings.State__c           =   'https://provsit-providersit.cs60.force.com';
        settings.Name               =   'URL';
        settingsList.add( settings );
        
        Email_Settings__c settings1 =   new Email_Settings__c();
        settings1.State__c          =   'Netops_Provider_Update@bcbsil.com';
        settings1.Name              =   'IL';
        settingsList.add( settings1 );
        
        Email_Settings__c settings2 =   new Email_Settings__c();
        settings2.State__c          =   'Netops_Provider_Update@bcbsil.com';
        settings2.Name              =   'MT';
        settingsList.add( settings2 );
        
         Email_Settings__c settings3 =   new Email_Settings__c();
        settings3.State__c          =   'Netops_Provider_Update@bcbsil.com';       
        settings3.Name              =   'MN';
        settingsList.add( settings3 );
        
        Email_Settings__c settings4 =   new Email_Settings__c();
        settings4.State__c          =   'Netops_Provider_Update@bcbsil.com';
        settings4.Name              =   'NM';
        settingsList.add( settings4 );
        
        Email_Settings__c settings5 =   new Email_Settings__c();
        settings5.State__c          =   'Netops_Provider_Update@bcbsil.com';
        settings5.Name              =   'TX';
        settingsList.add( settings5 );
        
        Email_Settings__c settings6 =   new Email_Settings__c();
        settings6.State__c          =   'Netops_Provider_Update@bcbsil.com';
        settings6.Name              =   'OK';       
        settingsList.add( settings6 );
        
        Email_Settings__c settings7 =   new Email_Settings__c();
        settings7.State__c          =   'intaketeampiermailbox@bcbsil.com';
        settings7.Name              =   'OrgWideEmailIL';       
        settingsList.add( settings7);
        
        Email_Settings__c settings8 =   new Email_Settings__c();
        settings8.State__c          =   'okintaketeampiermailbox@bcbsok.com';
        settings8.Name              =   'OrgWideEmailOK';       
        settingsList.add( settings8);
        
        Email_Settings__c settings9 =   new Email_Settings__c();
        settings9.State__c          =   'mtintaketeampiermailbox@bcbsmt.com';
        settings9.Name              =   'OrgWideEmailMT';       
        settingsList.add( settings9);
        
         Email_Settings__c settings10 =   new Email_Settings__c();
        settings10.State__c          =   'nmintaketeampiermailbox@bcbsnm.com';
        settings10.Name              =   'OrgWideEmailNM';       
        settingsList.add( settings10);
        
         Email_Settings__c settings11 =   new Email_Settings__c();
        settings11.State__c          =   'txintaketeampiermailbox@bcbstx.com';
        settings11.Name              =   'OrgWideEmailTX';       
        settingsList.add( settings11);
        insert settingsList;
        sendEmail();
  }

   
    static void sendEmail(){
        List<String> planId = new List<String>();
        planId.add('IL1');
        planId.add('TX1');
        planId.add('NM1');
        planId.add('MT1');
        planId.add('OK1');
        List<String> RecordType = new List<String>();
        RecordType.add('Master_Provider_Case_data');
        RecordType.add('Email');
        RecordType.add('Provider_On_boarding');
        
      
        Test.startTest(); 
        String State = '';
        String orgWideEmail=' ';   
        boolean error = false;
        String caseType = null;
        String submitterbody = null;
        list<Case> caseList = new list<Case>(); 
        List<Case> listOfParentCase = new List<Case>();
        for(Integer iterate=0;iterate<3;iterate++)
        {
        Case parentCase = new Case();
        parentCase.Plan_ID__c='IL1';
        parentCase.Email_Address_Submitter__c = 'test@hcsc.net';
        parentCase.origin   ='Email-IL';
            listOfParentCase.add(parentCase);
        }
        for (String r:RecordType){
            for(Case newCase:listOfParentCase)
            {
        RecordType OnBoard = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'Case' and DeveloperName =:r];
        newCase.RecordTypeId = OnBoard.id;
        }   
        }
        Database.insert (listOfparentCase,false);
        
        List<Case> childCases = new List<Case>();
        Case childCase = new Case();
        childCase.Plan_ID__c = 'IL1';
        childCase.ParentId = listOfparentCase[0].id;
        //parentCase.Email_Address_Submitter__c = null;
        
        
        insert childCase;
        System.debug('childCases'+childCases.size());
        caseList.addAll(listOfparentCase);
        for (String p:planId){
        caseList.getSObjectType();
        CaseClosedProcessedEmail.caseEmailCreation(caseList);
            
        CaseClosedProcessedEmail.getWebUrl();
        CaseClosedProcessedEmail.getState(p);
        orgWideEmail= CaseClosedProcessedEmail.GetStateEmail(p);
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail];  
        
        CaseClosedProcessedEmail.getLocation(p);
        CaseClosedProcessedEmail.getContactDetails(p,caseList[0].origin);
        CaseClosedProcessedEmail.GetResourceURL('BCBS_LOGO');
        }
        Test.stopTest(); 
    }
    
 static void sendEmail_OriginalEmail(){
        List<String> planId = new List<String>();
        planId.add('IL1');
        planId.add('TX1');
        planId.add('NM1');
        planId.add('MT1');
        planId.add('OK1');
        List<String> RecordType = new List<String>();
        RecordType.add('Master_Provider_Case_data');
        RecordType.add('Email');
        //RecordType.add('Provider_On_boarding');
        
      
        Test.startTest(); 
        String State = '';
        String orgWideEmail=' ';   
        boolean error = false;
        String caseType = null;
        String submitterbody = null;
        list<Case> caseList = new list<Case>(); 
        Case parentCase = new Case();
        parentCase.Plan_ID__c='IL1';
        parentCase.Email_Address_Submitter__c = 'test@hcsc.net';
        parentCase.origin   ='testEmail@bcbsil.com';
        for (String r:RecordType){
        RecordType OnBoard = [Select RecordType.DeveloperName From RecordType  Where SobjectType = 'Case' and DeveloperName =:r];
        parentCase.RecordTypeId = OnBoard.id;
        }   
        insert parentCase;
        
        List<Case> childCases = new List<Case>();
        Case childCase = new Case();
        childCase.Plan_ID__c = 'IL1';
        childCase.ParentId = parentCase.id;
        childCase.origin   ='testEmail@bcbsil.com';
        //parentCase.Email_Address_Submitter__c = null;
        
        
        insert childCase;
        System.debug('childCases'+childCases.size());
        caseList.add(parentCase);
        for (String p:planId){
        caseList.getSObjectType();
        CaseClosedProcessedEmail.caseEmailCreation(caseList);
        CaseClosedProcessedEmail.getWebUrl();
        CaseClosedProcessedEmail.getState(p);
        orgWideEmail= CaseClosedProcessedEmail.GetStateEmail(p);
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail];  
        
        CaseClosedProcessedEmail.getLocation(p);
        CaseClosedProcessedEmail.getContactDetails(p,caseList[0].origin);
        CaseClosedProcessedEmail.GetResourceURL('BCBS_LOGO');
        }
        Test.stopTest(); 
    }
    
    static testMethod void emailTest2()
    {
        Rec_Id__c rec           =   new Rec_Id__c();
        rec.Org_Wide_Email__c      =   'test@test.com';
        rec.Name                =   'Default Account';
        insert rec;
        
        Confirm_Email_Settings__c cnfrmEmail = new Confirm_Email_Settings__c();
        cnfrmEmail.name = 'testEmail@bcbsil.com';
        cnfrmEmail.email__c = 'testEmail@bcbsil.com';
        cnfrmEmail.case_origin__c='testEmail@bcbsil.com';
        insert cnfrmEmail;      
        Email_Settings__c newSetting = new Email_Settings__c();
        newSetting.Name='URL';
        newSetting.State__c='IL1';
        insert newSetting;
        newSetting = new Email_Settings__c();
        newSetting.Name='testEmail@bcbsil.com';
        newSetting.State__c='IL1';
        insert newSetting;
        sendEmail_OriginalEmail();
  }
       
}