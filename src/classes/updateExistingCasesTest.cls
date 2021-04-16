@isTest
public class updateExistingCasesTest {
   
    
    @testSetup static void prepareData() {
	   
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
    static void test_updateExistingCases(){
        
        system.debug('1Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
        
        List<User>  userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
        
        system.debug('2Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
        List<User>  dataRepUserlist =   TestCaseUtil.createUser('Provider Data Rep','Provider Data Rep- IL',1);
        insert dataRepUserlist;
        system.debug('3Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            //testclassdata.CreateCustomSettingData('case');
        	//testclassdata.CreateCustomSettingData('Provider_Networks__c');
            GlobalSettings__c gs    =   new GlobalSettings__c();
            gs.name                 =   'PFFileRecieved';
            gs.PFFileRecieved__c    =   false;
            gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
            insert gs;
            system.debug('4Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            List<RecordType> recType =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE Name In ('Master Provider Case data','Name Change Request')];
            Case parentCase          =  TestCaseUtil.CreateCase();   
            parentCase.Email_Address_Submitter__c   =   'test@test.com';
            parentCase.RecordTypeId =   recType[0].id;
            parentCase.Plan_ID__c   =   'IL1';
            parentCase.Status       =   'New';
            parentCase.Subject     =   'Test Email';
            parentCase.Origin      =   'PNC NetOps Inquiries';
            insert parentCase;
            system.debug('5Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            
            Case childCase          =   TestCaseUtil.CreateCase();   
            childCase.ParentId      =   parentCase.id; 
            childCase.Email_Address_Submitter__c    =   'test3@test.com';
            childCase.RecordTypeId  =   recType[1].id;
            childCase.Govt_Programs__c              =   true;
            childCase.Plan_ID__c                    =   'IL1';
            childCase.Status                        =   'New';
            List<case> flist    = new List<case>();
            flist.add(childCase);
            insert flist;
            system.debug('6Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            
            
            List<id> idList = new List<id>();
            idList.add(userList[0].Id);
            idList.add(dataRepUserlist[0].Id);
            
            User usr                =   [Select Id,Name from User where Id =:userList[0].Id];
            Group testGroup = new Group(Name='Illinois Queue1', Type='Queue');
            insert testGroup;
            
            system.debug('Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
            system.debug('7Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Omni_Queue__C');
            insert testQueue1;
            
            system.debug('8Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            omni_queue__C queueRec            =    new omni_queue__C();        
            queueRec.Case_Type__c              =   'Demographics';
            queueRec.Request_Type_s__c         =   'NPI Tax Id Change; Administrative Change';
            queueRec.Plan_Id__c                =   'IL1';
            queueRec.Queue_Priority__c         =   '5';
            queueRec.Name                       =   'Test queue uewyrewr';
            insert queueRec; 
			
            list<RecordType_settings__c> rs = new list<RecordType_settings__c>();
            RecordType_settings__c temprs = new RecordType_settings__c();
            //Add values to Custom Setting Record Type Settings
            /*for(recordtype r:[select id,sobjecttype,DeveloperName,name from recordtype where isactive = true]){
                	temprs = new RecordType_settings__c();	
                	temprs.Name 				= r.Id;
                    temprs.DeveloperName__c 	= r.DeveloperName;
                    temprs.Name__c				= r.Name;
                    temprs.Record_type_Id__c	= r.Id;
                    temprs.sObject_Type__c		= 'Case';
                	rs.add(temprs);
            }
            insert rs; */
            system.debug('9Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            system.debug('10Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            Test.startTest();
            system.debug('1***Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            System.enqueueJob(new updateExistingCases(idList,testGroup.Id,queueRec.Id,flist));
            system.debug('2***Limits ' + Limits.getDmlStatements() + ' --- ' + Limits.getQueries() + '---' + Limits.getQueueableJobs());
            Test.stopTest();
        }
        
    }
}