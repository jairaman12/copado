/*
* This is the test class to covor the code coverage for the class UpdatePendingServiceRequestRecord.apxc 
* Developer : Sreekanth Kalluru
* Date      : 04/10/2019
*/
@isTest
public class UpdatePendingServiceRequestRecordTest 
{
    
    @testSetup static void createTestData() 
    {
        List<DefaultQueueSettings__c> defaultQueueSettingsList = TestDataFactory.insertDefaultQueueSettings();
        TestDataFactory tdf = new TestDataFactory();
        List<GlobalSettings__c> glbalsettingsList = tdf.InsertGlobalsetting();
        TestDataFactory.CreateRecordTypeSettings(); 
    }
    
    static testmethod void UpdatePendingServiceRequestRecord()
    {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) 
        {
        List<Case> childCaseList    =   new List<Case>();
        
        Case parentCase = TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c   =   'test@test.com';
        parentCase.Govt_Programs__c             =   true;
        parentCase.Origin                       =   'Web-Demographics';
        ParentCase.Plan_Id__C                   =   'IL1';
        insert parentCase;
        
        
        List<QueueRoutingConfig> qrcfList = [SELECT DeveloperName,Id,RoutingPriority FROM QueueRoutingConfig limit 1];
        System.debug('qrcfList===>>>'+qrcfList);
        
        Group g     =   new Group();
        g.name      =   'OMNI_IL_TestQueue';
        g.Type      =   'Queue';
        if(!qrcfList.isEmpty())
        {
           g.QueueRoutingConfigId      =  qrcfList[0].Id ;
        }
        insert g;
        
         QueuesObject q1 = new QueueSObject(QueueID = g.id, SobjectType = 'Case');
        insert q1;
        
        Group g1     =   new Group();
        g1.name      =   'OMNI_IL_TestQueue1';
        g1.Type      =  'Queue';
        if(!qrcfList.isEmpty())
        {
           g1.QueueRoutingConfigId      =  qrcfList[0].Id ;
        }
        insert g1;
        
        QueuesObject q2 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
        insert q2;

       /* for(Integer i=0;I<=10;i++)
        { */
            Case childCase2                         =   TestCaseUtil.CreateCase();   
            childCase2.ParentId                     =   parentCase.id;        
            childCase2.Email_Address_Submitter__c   =   'testi@test.com';
            childCase2.Govt_Programs__c             =   true;
            childCase2.Origin                       =   'Web-Demographics';
            childCase2.OwnerId                      =   g1.Id;
            childCase2.Plan_Id__C                   =   'IL1';
            childCaseList.add( childCase2 ); 
       // }
        
        insert childCaseList;
        Test.startTest();
        Case tempCase   =    new Case(Id=childCaseList[0].Id);
        tempCase.OwnerId    = g1.id;
        update tempCase;
        Test.stopTest();
        List<PendingServiceRouting> psrList     =   [SELECT CapacityPercentage,CapacityWeight,CustomRequestedDateTime,Id,IsDeleted,IsPushAttempted,
                                                            IsPushed,IsReadyForRouting,IsTransfer,LastDeclinedAgentSession,LastModifiedById,LastModifiedDate,
                                                         Name,OwnerId,PushTimeout,QueueId,RoutingModel,RoutingPriority,RoutingType,Serial,ServiceChannelId,
                                                         SystemModstamp,WorkItemId FROM PendingServiceRouting where workItemId=: tempCase.Id];
        
        
        UpdatePendingServiceRequestRecord.updateEmailCaseOwner( psrList ); 
            
        PendingServiceRouting psr   =   [SELECT CustomRequestedDateTime,Id,WorkItemId FROM PendingServiceRouting where workItemId=: tempCase.Id limit 1];
       System.debug('psr.CustomRequestedDateTime===>>>'+psr.CustomRequestedDateTime);
       Case csRecord        =  [Select ID,CreatedDate from Case where id=: tempCase.Id limit 1];
        System.debug(csRecord.CreatedDate+'psrList===>'+psrList.size());
       System.assertEquals( csRecord.CreatedDate, psr.CustomRequestedDateTime);
        }
    }
    
}