@isTest
public class TestEMReply{

    @isTest
    public static void test_EMReply(){
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        Confirm_Email_Settings__c ces    =   new Confirm_Email_Settings__c();
        ces.name                 =   'PFFileRecieved';
        ces.case_Origin__c    =   'Ancillary Gov Expansion';
        ces.Contact_Info__c =   'contact 888-888-8888';
        insert ces;
        
        EmailToCaseRoutingAddresses__c routingSettings = new    EmailToCaseRoutingAddresses__c();
        routingSettings.RoutingName__c                  =       'ancillarygovexpansiontest@bcbsil.com';
        routingSettings.Name                            =       'Ancillary Gov Expansion';
        insert routingSettings;
        
        Email_Settings__c       emailSettings           =   new Email_Settings__c(Name='OrgWideEmailIL',State__c='intaketeampiermailboxuat@bcbsil.com');
        insert emailSettings;
        
        Email_Settings__c       emailSettings1          =   new Email_Settings__c(Name='URL',State__c='http://hcscproviderintake.force.com');
        insert emailSettings1;
        
         Email_Settings__c      emailSettings2          =   new Email_Settings__c(Name='IL',State__c='Netops_Provider_Update@bcbsil.com');
        insert emailSettings2;
        
         Confirm_Email_Settings__c cnfrmEmail = new Confirm_Email_Settings__c();
        cnfrmEmail.name = 'testEmail@bcbsil.com';
        cnfrmEmail.email__c = 'testEmail@bcbsil.com';
        insert cnfrmEmail;
        
        Case nc = TestCaseUtil.CreateCase();
        nc.Plan_ID__c = 'IL1';
        nc.Name_Submitter__c = 'swati';
        nc.origin    = 'Ancillary Gov Expansion';
        
        insert nc;
        
        
        insert
            ( 
                new Email_Settings__c
                (
                    name='OrgWideEmailIL', state__c = 'intaketeampiermailboxuat@bcbsil.com'
                )
            );    
        /*
        OrgWideEmailAddress owea =new OrgWideEmailAddress();
        owea.address = 'intaketeampiermailboxuat@bcbsil.com';
        insert owea;
        */
        
        List<EmailMessage> eml = new List<EmailMessage>();   
        
        EmailMessage em = new EmailMessage();
        em.fromAddress = 'Test@test.com';
        em.RelatedToId = nc.id;
        em.Subject = 'This is the subject';
        
        eml.add(em);        
        // start the test execution context
        Test.startTest();
        //Call methods to test on CaseCommentTrigerHandler
        EMReply.caseEmailReply(eml);
        EMReply.getWebUrl();
        //EMReply.getContactDetails('IL','Netops_Provider_Update@bcbsil.com');
        EMReply.getLocation(nc.Plan_Id__c);
        EMReply.getState(nc.Plan_Id__c);
         EMReply.getState('TX1');
          EMReply.getState('MT1');
          EMReply.getState('OK1');
         EMReply.getState('NM1');
        // stop the test        
        Test.stopTest();
        
    }
    
     @isTest
    public static void test_ownerNotification(){
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        EmailToCaseRoutingAddresses__c routingSettings = new    EmailToCaseRoutingAddresses__c();
        routingSettings.RoutingName__c                  =       'ancillarygovexpansiontest@bcbsil.com';
        routingSettings.Name                            =       'Ancillary Gov Expansion';
        insert routingSettings;
        
        Email_Settings__c       emailSettings           =   new Email_Settings__c(Name='OrgWideEmailIL',State__c='intaketeampiermailboxuat@bcbsil.com');
        insert emailSettings;
        
        Email_Settings__c       emailSettings1          =   new Email_Settings__c(Name='URL',State__c='http://hcscproviderintake.force.com');
        insert emailSettings1;
        
        Email_Settings__c      emailSettings2          =   new Email_Settings__c(Name='IL',State__c='Netops_Provider_Update@bcbsil.com');
        insert emailSettings2;
        
        Confirm_Email_Settings__c cnfrmEmail = new Confirm_Email_Settings__c();
        cnfrmEmail.name = 'testEmail@bcbsil.com';
        cnfrmEmail.email__c = 'testEmail@bcbsil.com';
        insert cnfrmEmail;
        
        Case nc = TestCaseUtil.CreateCase();
        nc.Plan_ID__c = 'IL1';
        nc.Name_Submitter__c = 'swati';
        nc.origin    = 'Ancillary Gov Expansion';
        
        insert nc;
        
        insert
            ( 
                new Email_Settings__c
                (
                    name='OrgWideEmailIL', state__c = 'intaketeampiermailboxuat@bcbsil.com'
                )
            );    
        
        nc.ownerId = userInfo.getUserId();
        update nc;
     
        List<EmailMessage> eml = new List<EmailMessage>();   
        
        EmailMessage em = new EmailMessage();
        em.fromAddress = 'Test@test.com';
        em.RelatedToId = nc.id;
        em.Subject = 'This is the subject';
        
        eml.add(em);        
        // start the test execution context
        Test.startTest();
        
        
        OwnerNotification.ownerNotify(eml);
        
        Test.stopTest();
        
    }
}