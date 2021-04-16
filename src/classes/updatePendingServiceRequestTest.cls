@isTest
public class updatePendingServiceRequestTest {

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
    @isTest
    static void test_updatePendingServiceRequest(){
        
       
         List<User>  userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
       System.runAs(new User(Id = UserInfo.getUserId()))
       {
        /*List<User>  userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
        
        List<User>  dataRepUserlist =   TestCaseUtil.createUser('Provider Data Rep','Provider Data Rep- IL',1);
        insert dataRepUserlist;*/
        
        GlobalSettings__c gs    =   new GlobalSettings__c();
            gs.name                 =   'PFFileRecieved';
            gs.PFFileRecieved__c    =   false;
            gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
            gs.CRM_Case_record_Type_Id__c = Utils.GetRecordTypeId('Case','CRM');
            insert gs;
            List<RecordType> recType    =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE Name In ('Master Provider Case data','Name Change Request')];
            Case parentCase             =  TestCaseUtil.CreateCase();   
            parentCase.Email_Address_Submitter__c   =   'test@test.com';
            parentCase.RecordTypeId     =   recType[0].id;
            parentCase.Plan_ID__c       =   'IL1';
            parentCase.Status           =   'New';
            parentCase.Subject          =   'Test Email';
            parentCase.Origin           =   'PNC NetOps Inquiries';
            insert parentCase;
            
            Case childCase              =   TestCaseUtil.CreateCase();   
            childCase.ParentId          =   parentCase.id; 
            childCase.Email_Address_Submitter__c    =   'test3@test.com';
            childCase.RecordTypeId  =   recType[1].id;
            childCase.Govt_Programs__c  =   true;
            childCase.Plan_ID__c        =   'IL1';
            childCase.Status            =   'New';
            List<case> flist            =   new List<case>();
            flist.add(childCase);
            insert flist; 
            
           
            
            QueueRoutingConfig qrc  =   [Select Id,DeveloperName,RoutingPriority from QueueRoutingConfig limit 1 ];
            
            User usr                =   [Select Id,Name from User where Id =:userList[0].Id];
            Group testGroup         = new Group(Name='Illinois Queue1', Type='Queue',QueueRoutingConfigId=qrc.Id);
            
            insert testGroup;
            QueuesObject testQueue  = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Omni_Queue__C');
            insert testQueue1;
            
                        
            omni_queue__C queueRec            =    new omni_queue__C();        
            queueRec.Case_Type__c              =   'Demographics';
            queueRec.Request_Type_s__c         =   'NPI Tax Id Change; Administrative Change; Name Change Request';
            queueRec.Plan_Id__c                =   'IL1';
            queueRec.Queue_Priority__c         =   '5';
            queueRec.Name                       =   'Test queue uewyrewr11';
            insert queueRec; 
            
            
            Test.startTest();
            Case cs = new Case(Id=flist[0].id);
            cs.OwnerId  =testGroup.Id;
            Update cs;
            
            Set<id> workItems = new Set<Id>();
            workItems.add(cs.Id);

               System.enqueueJob(new updatePendingServiceRequest(workItems));               
            Test.stopTest(); 
       }
        
    }
}