@isTest
public class updateOMNIQueueTest {

    @isTest
    static void test_updateOMNIQueue()
    {
        List<User>  userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
        
        List<User>  dataRepUserlist =   TestCaseUtil.createUser('Provider Data Rep','Provider Data Rep- IL',1);
        insert dataRepUserlist;
        
        List<id> idList = new List<id>();
        idList.add(userList[0].Id);
        idList.add(dataRepUserlist[0].Id);
        
        User usr                =   [Select Id,Name from User where Id =:userList[0].Id];
        Group testGroup = new Group(Name='Illinois Queue1', Type='Queue');
        insert testGroup;

        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
        insert testQueue;
        
        QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Omni_Queue__C');
        insert testQueue1;
        
        System.debug('testQueue==>>'+testQueue.SObjectType);
        
         System.runAs(new User(Id = UserInfo.getUserId())){
             omni_queue__C queueRec            =    new omni_queue__C();        
            queueRec.Case_Type__c              =   'Demographics';
            queueRec.Request_Type_s__c         =   'NPI Tax Id Change; Administrative Change';
            queueRec.Plan_Id__c                =   'IL1';
            queueRec.Queue_Priority__c         =   '5';
            queueRec.Name                       =   'Test queue uewyrewr';
            insert queueRec; 
            Test.startTest();
              System.enqueueJob(new updateOMNIQueue(idList,testGroup.Id,queueRec.Id));
            Test.stopTest();
        }
    }
}