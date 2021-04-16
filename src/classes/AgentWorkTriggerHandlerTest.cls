@isTest
private class AgentWorkTriggerHandlerTest 
{ 
    
    @testSetup static void prepareData() {
	    GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
        List<RecordType_settings__c> rtsList	=	 new List<RecordType_settings__c>();
        List<RecordType> recordTypeList	= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType];
        for( RecordType recType : recordTypeList  )
        {
            RecordType_settings__c rts 	=	new RecordType_settings__c();
            rts.name					=	recType.Id;
            rts.DeveloperName__c	   	=	recType.DeveloperName;
            rts.Name__c					=	recType.Name;
            rts.Record_type_Id__c		=	recType.Id;
            rts.sObject_Type__c			=	recType.SobjectType;
            rtsList.add(rts);
        }
        insert rtsList;
    }
   /*public Static Id SChannelId;
    public static case childCase = new Case();
    public static List<User> usr = new List<User>();
    public static QueueRoutingConfig rconfig;
    
    private static void prepareData()
    {
        List<RecordType> recType =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE Name In ('Master Provider Case data','Name Change Request')];
        Case parentCase          =  TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c   =   'test@test.com';
        parentCase.RecordTypeId =   recType[0].id;
        parentCase.Plan_ID__c   =   'IL1';
        parentCase.Status       =   'New';
         parentCase.Subject     =   'Test Email';
         parentCase.Origin      =   'PNC NetOps Inquiries';
        insert parentCase;
        
        Case childCase          =   TestCaseUtil.CreateCase();   
        childCase.ParentId      =   parentCase.id; 
        childCase.Email_Address_Submitter__c    =   'test3@test.com';
        childCase.RecordTypeId  =   recType[1].id;
        childCase.Govt_Programs__c              =   true;
        childCase.Plan_ID__c                    =   'IL1';
        childCase.Status                        =   'New';
        insert childCase;
        
        SChannelId      =   [SELECT Id FROM ServiceChannel Where DeveloperName='Omni_Channel_for_Case' Limit 1].Id;
        //rconfig = new QueueRoutingConfig(DeveloperName='Priority_1',);
        ServiceChannel sChannel = new ServiceChannel(DeveloperName='Omni_Channel_for_Case',RelatedEntity='Case');
        insert sChannel; 
    }  */
     static testMethod void test_onAfterUpdate_UseCase1(){
        
         
        List<RecordType> recType =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE Name In ('Master Provider Case data','Name Change Request')];
        Case parentCase          =  TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c   =   'test@test.com';
        parentCase.RecordTypeId =   recType[0].id;
        parentCase.Plan_ID__c   =   'IL1';
        parentCase.Status       =   'New';
         parentCase.Subject     =   'Test Email';
         parentCase.Origin      =   'PNC NetOps Inquiries';
        insert parentCase;
        
        
        
         
         System.runAs(new User(Id = UserInfo.getUserId())){
             
            Group testGroup = new Group(Name='Omni queue', Type='Queue');
        insert testGroup;
     
        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
        insert testQueue;
         Id SChannelId      =   [SELECT Id FROM ServiceChannel Where DeveloperName='Omni_Channel_for_Case' Limit 1].Id;
         
        
           GroupMember gm = new GroupMember();
              gm.GroupId = testGroup.id;
              gm.UserOrGroupId = UserInfo.getUserId();
              insert gm;
         
            Test.startTest();
             Case childCase          				=   TestCaseUtil.CreateCase();   
            childCase.ParentId      				=   parentCase.id; 
            childCase.Email_Address_Submitter__c    =   'test3@test.com';
            childCase.RecordTypeId  				=   recType[1].id;
            childCase.Govt_Programs__c              =   true;
            childCase.Plan_ID__c                    =   'IL1';
            childCase.Status                        =   'New';
            childCase.OwnerId						=	testGroup.Id;
            insert childCase;
            
            AgentWorkTriggerHandler ath = new AgentWorkTriggerHandler();
            
            AgentWork awork = new AgentWork();
            awork.WorkItemId = childCase.Id;
            awork.ServiceChannelId = SChannelId;
            awork.UserId = UserInfo.getUserId();
            insert awork;
            AgentWork awork1 = new AgentWork(id=awork.Id); 
            update awork;
            Test.stopTest();
         }
     }
}