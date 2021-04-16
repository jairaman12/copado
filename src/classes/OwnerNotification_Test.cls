/****************************************************************
@Author      : Provider Intake Salesforce team 
@Date        : 23/05/2018
@Description : Test class is created for sending email notification to owner about email message added to case.
*******************************************************
SI.No       Author                Modification Comments
1          Saravana Bharathi      Userstory PPN-15181 Changes
******************************************************************/
@isTest
public class OwnerNotification_Test {
    
    public static testmethod void ownerNotificationTesting()
    {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.CRM_Case_record_Type_Id__c = Utils.GetRecordTypeId('Case','CRM');
        insert gs;
        
        List<Case> masterCase   =   new List<Case>();
        Case  mCase             =   new Case();
        mCase.Status='new';
        mCase.Origin='Web';
        mCase.Subject='Testing';
        mcase.Corporate_received_date__c=System.today();
        mcase.Plan_ID__c='IL1';
        mCase.OwnerId=Userinfo.getUserId();
        List<RecordType> listOfType = [Select Id From RecordType Where sObjectType='Case' Limit 1];
        mCase.RecordTypeId=listOfType[0].Id;
        masterCase.add ( mCase );
        insert masterCase;
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = masterCase[0].Id)); 
        insert newEmail;
        OwnerNotification.ownerNotify(newEmail);
        
    }
}