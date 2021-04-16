@isTest(SeeAllData=false)
public class OMNIReservedQueueManagementClsTest {
    
    
    static testMethod void test_reservedQueues1() {
         List<User> userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
       
       // System.runAs(new user(id=UserInfo.getUserId())){
         
        System.runAs(userList[0]){
        Set<Id> userIds         =   new Set<Id>();
        userIds.add(userList[0].id);
       // userIds.add(userList[1].id);
       // userIds.add(userList[2].id); 
            
         List<user> userLst1        =   [Select id,Name from user where Id IN:userIds ];          
         OMNI_Queue__c queueRec             =   new OMNI_Queue__c();
         queueRec.Name                      =   'IL Reserved Highest Priority Queue 1';
         queueRec.Reserved_Queue_Users__c   =   userList[0].name;
         queueRec.Plan_Id__c                =   'IL1';
         queueRec.Queue_Priority__c         =   '1';
         insert queueRec;
         
         OMNI_Queue__c queueRec1            =   new OMNI_Queue__c();
         queueRec1.Name                     =   'IL Reserved Highest Priority Queue 2';
         queueRec1.Reserved_Queue_Users__c  =   userList[0].name;
         queueRec1.Plan_Id__c               =   'IL1';
         queueRec1.Queue_Priority__c        =   '2';
         insert queueRec1;
            
            PageReference pageRef           =   Page.OMNIQueueManagementPage;
            Test.setCurrentPage(pageRef);
            OMNIQueueManagementCls cls      =   new OMNIQueueManagementCls();
            OMNIReservedQueueManagementCls rCls = new OMNIReservedQueueManagementCls(cls);  
            rCls.planId                     =   'IL1';
            rCls.selectedReserveQueue       =   'IL Reserved Highest Priority Queue 1';
            List<SelectOption> rOptions = new List<SelectOption>();
            rOptions.add(new SelectOption(userLst1[0].id,userLst1[0].Name));
           // rOptions.add(new SelectOption(userLst1[1].id,userLst1[1].Name));
            List<SelectOption> lOptions = new List<SelectOption>();
            lOptions.add(new SelectOption(userLst1[0].id,userLst1[0].Name));
           // lOptions.add(new SelectOption(userLst1[1].id,userLst1[1].Name));
           // lOptions.add(new SelectOption(userLst1[2].id,userLst1[2].Name));

           
            rCls.leftOptions                =    lOptions;
            rCls.processorsForreservedQueue(); 
            rCls.rightOptions               =    rOptions;
            rcls.doSave1();
            rCls.refreshPage1();
        }
    }
    
    static testMethod void test_reservedQueues2() {
         List<User> userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
        List<User>  dataRepUserlist =   TestCaseUtil.createUser('Provider Data Rep','Provider Data Rep- IL',1);
        insert dataRepUserlist;
        System.runAs(userList[0]){
            
            PageReference pageRef           =   Page.OMNIQueueManagementPage;
            Test.setCurrentPage(pageRef);
            OMNIQueueManagementCls cls      =   new OMNIQueueManagementCls();
            OMNIReservedQueueManagementCls rCls = new OMNIReservedQueueManagementCls(cls);
            rcls.doSave1();
            rCls.planId                     =   'IL1';
            rCls.selectedReserveQueue       =   'IL Reserved Highest Priority Queue 3';
           
            
        }
    }
    
}