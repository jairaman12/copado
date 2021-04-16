@isTest
public class TestAddSobjectTypeToQueue 
{
	public static testmethod void testQueueable()
    {
        Group newGroup = new Group();
        newGroup.Name='Test Queue';
        newGroup.Type='Queue';
        insert newGroup;
        Test.startTest();
        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        Case newCase = new Case();
        newCase.subject = 'Test';
        newCase.Status='New';
        newCase.Origin='Web';
        //newCase.Request_type__c=Case.sObjectType.Request_Type__c.getDescribe().getPicklistValues()[0].getLabel();
        newCase.RecordTypeId=[Select Id From RecordType where sObjectType='Case' and Name='CRM' Limit 1].Id;
        insert newCase;
        List<Case> listOfCase = new List<Case>();
        listOfCase.add(newCase);
        OMNI_Queue__c newQueue = new OMNI_Queue__c();
        newQueue.name='Testing';
        newQueue.Case_Type__c='CRM';
        newqueue.Case_Type_Name_Origin__c='Roster;CRM';
        newQueue.Request_Type_s__c='Roster;CRM';
        insert newQueue;
        List<Id> listOfIds = new List<Id>();
        listOfIds.add(Userinfo.getUserId());
        addSobjectTypeToQueue queueableMethod = new addSobjectTypeToQueue(listOfIds,newGroup.Id,newQueue.id,listOfCase);
        System.enqueueJob(queueableMethod);
        OMNICriteriaTable newTable = new OMNICriteriaTable();
        newTable.queue = new OMNI_Queue__c();
        newTable.userGroup = new OMNI_User_Group__c();
        Test.stopTest();
    }
}