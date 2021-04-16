@isTest
private class OMNIQueueManagementTest1 {
@TestSetup
    public static void insertTestData()
    {
    	GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
    }
    static testMethod void test_DemographicCase(){
        List<User>  userList  =  TestCaseUtil.createUser('Supervisor','Illinois Supervisor',3);
        insert userList;
        System.runAs(new User (Id=UserInfo.getUserId()))
        {
        	insertTestData();
        }
        Set<Id>   userId    =  new Set<Id>();
        userId.add(userList[0].Id);
        userId.add(userList[1].Id); 
        userId.add(userList[2].Id);
        List<User> usrListTemp        =  [Select Id,Name from User where Id IN:userId];
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(usrListTemp[0].Id,usrListTemp[0].Name));
        options.add(new SelectOption(usrListTemp[1].Id,usrListTemp[1].Name));
        options.add(new SelectOption(usrListTemp[2].Id,usrListTemp[2].Name));
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            
            OMNIQueueManagementCls cls = new OMNIQueueManagementCls();
            PageReference pageRef = Page.OMNIQueueManagementPage;
            Test.setCurrentPage(pageRef);
            cls.requestTypeList        =  TestContextMetaDataSupportCls.requestTypes('IL1');
            cls.selectedProcessors = options;
            cls.updateProcessors();
            cls.selectedCaseType='Demographics';
            cls.planId='IL1';
            cls.rowToDelete=1;
            cls.displayCaseReqtypes();
            cls.displayProcessors();
            cls.doSave();
            cls.deleteCurrentRow();
            cls.doDisplayQueuerecords();
            cls.refreshPage();
            cls.openPage();
            cls.omniQueuePrev = new OMNI_Queue__c();
            cls.omniQueue = new OMNI_Queue__c();
            cls.omniQueuePrev.request_Type_s__c = 'CRM;Email;';
            cls.omniQueue.request_Type_S__c = 'CRM;';
            cls.handleEditRule();
            cls.omniQueuePrev.request_Type_s__c='CRM;';
            cls.omniQueue.request_Type_s__c='CRM;';
            cls.omniqueuePrev.case_Type__c='Email';
            cls.omniQueue.case_Type__c='Demographics';
            cls.handleEditRule();
            cls.omniQueuePrev.request_Type_s__c='CRM;';
            cls.omniQueue.request_Type_s__c='CRM;';
            cls.omniqueuePrev.case_Type__c='Demographics';
            cls.omniQueue.case_Type__c='Email';
            cls.handleEditRule();
            cls.omniQueuePrev.request_Type_s__c='CRM;';
            cls.omniQueue.request_Type_s__c='CRM1;';
            cls.omniqueuePrev.case_Type__c='Demographics';
            cls.omniQueue.case_Type__c='Email';
            cls.handleEditRule(); 
            cls.omniQueuePrev.request_Type_s__c='CRM;';
            cls.omniQueue.request_Type_s__c='CRM;';
            cls.omniqueuePrev.case_Type__c='Demographics';
            cls.omniQueue.case_Type__c='Demographics';
            cls.handleEditRule();
            cls.omniQueuePrev.request_Type_s__c='CRM;';
            cls.omniQueue.request_Type_s__c='Mass Case;';
            cls.omniqueuePrev.case_Type__c='Email';
            cls.omniQueue.case_Type__c='Email';
            cls.handleEditRule(); 
            cls.omniQueuePrev.request_Type_s__c='CRM;';
            cls.omniQueue.request_Type_s__c='Mass Case;';
            cls.omniqueuePrev.case_Type__c='Demographics';
            cls.omniQueue.case_Type__c='Demographics';
            cls.handleEditRule();
            
            cls.updateLeftOptions(new Set<String>());
            OMNI_Queue__c newQueue = new OMNI_Queue__c();
            newQueue.name='Testing';
            newQueue.Case_Type__c='CRM';
            newqueue.Case_Type_Name_Origin__c='Roster;CRM';
            newQueue.Request_Type_s__c='Roster;CRM';
            insert newQueue;

            ApexPages.currentPage().getParameters().put('oId',newQueue.Id);
            cls = new OMNIQueueManagementCls();
            cls.caseTypeWithrequestMap = new Map<String,List<String>>();
            cls.caseTypeWithrequestMap.put('Mass Case',new String[]{'ILRoster','Roster'});
            cls.caseTypeWithrequestMap.put('CRM',new String[]{'Roster'});
            cls.displayCaseReqtypes();
        }
    }
    
    static testMethod void test_DoSave()
    {
        List<User>  userList  =  TestCaseUtil.createUser('Supervisor','Illinois Supervisor',3);
        insert userList;
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
    		insertTestData();
		}
        Set<Id>   userId    =  new Set<Id>();
        userId.add(userList[0].Id);
        userId.add(userList[1].Id); 
        userId.add(userList[2].Id);
        List<User> usrListTemp        =  [Select Id,Name from User where Id IN:userId];
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(usrListTemp[0].Id,usrListTemp[0].Name));
        options.add(new SelectOption(usrListTemp[1].Id,usrListTemp[1].Name));
        options.add(new SelectOption(usrListTemp[2].Id,usrListTemp[2].Name));
        
        List<RecordType> recType =[SELECT DeveloperName,Id,Name FROM RecordType WHERE Name = 'Email'];

        System.runAs(new User(Id = UserInfo.getUserId())){
            
            Test.startTest();
            OMNIQueueManagementCls cls  =  new OMNIQueueManagementCls();
            PageReference pageRef     =  Page.OMNIQueueManagementPage;
            Test.setCurrentPage(pageRef);
            cls.requestTypeList        =  TestContextMetaDataSupportCls.requestTypes('IL1');
            
            Map<String,List<String>>     caseTypeWithrequestMapTemp  =   new Map<String,List<String>>();
            Map<String,String> caseTypeAndOrigMap                =   new Map<String,String>();
            
            for( Request_Types__mdt requestType :  cls.requestTypeList  )
            {
                caseTypeAndOrigMap.put(requestType.Request_Name__c, requestType.CaseType_Name_Origin__c);
                String planIds   =   requestType.Plan_Ids__c;
                if(caseTypeWithrequestMapTemp.containsKey( requestType.CaseType__c))
                {
                    caseTypeWithrequestMapTemp.get(requestType.CaseType__c).add(requestType.Request_Name__c);
                }else{
                    List<String> reqList = new List<String>();
                    reqList.add(requestType.Request_Name__c);
                    caseTypeWithrequestMapTemp.put(requestType.CaseType__c, reqList);
                }       
            } 
            cls.caseTypeWithrequestMap  =  caseTypeWithrequestMapTemp;
            cls.selectedProcessors = options;
            cls.updateProcessors();
            cls.selectedCaseType    =  'Demographics';
            cls.isEditPage        =  false;
            cls.planId          =  'IL1';
            
            cls.selectedRequests.add(new SelectOption('Administrative Change','Administrative Change'));
            cls.omniQueueObj.Case_Type__c              =   'Demographics';
            cls.omniQueueObj.Request_Type_s__c         =   'NPI Tax Id Change; Administrative Change';
            cls.omniQueueObj.Plan_Id__c                =   'IL1';
            cls.omniQueueObj.Queue_Priority__c         =   '5';
            cls.omniQueueObj.Name            =  'kjfhdkjsafhkjsdah';
            
            OMNI_User_Group__c usrGrouprec1        =   new OMNI_User_Group__c();
            usrGrouprec1.Start_Date__c         =   date.today();
            usrGrouprec1.End_Date__c           =   Date.Today().addDays(15);
            usrGrouprec1.Plan_Id__c            =   'IL1';
            usrGrouprec1.Active__c             =   true;
            usrGrouprec1.Week_Days__c          =   'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday';
            usrGrouprec1.Selected_User_Ids__c  =   usrListTemp[0].Id;
            usrGrouprec1.Selected_Users__c     =   usrListTemp[0].Name;
            cls.omniUserGrpList.add(usrGrouprec1);
            cls.doSave();
            
            List<QueuesObject> qSobjectList   =  new List<QueuesObject>();
            QueuesObject  qSobject         =  new QueuesObject (SobjectType ='Case', QueueId=cls.g.id);
            qSobjectList.add(qSobject);
            QueuesObject  qSobject2       =  new QueuesObject (SobjectType ='OMNI_Queue__c', QueueId=cls.g.id);
            qSobjectList.add(qSobject2);     
            insert qSobjectList;  
            OMNI_Queue__c o = [select id,ownerid from OMNI_Queue__c where id = :cls.omniQueue.id];
            o.ownerid = cls.g.id;
            update o;
      
            OMNIQueueManagementCls cls2  =  new OMNIQueueManagementCls(); 
            cls2.requestTypeList        =  TestContextMetaDataSupportCls.requestTypes('IL1');
             Map<String,List<String>>     caseTypeWithrequestMapTemp1    =   new Map<String,List<String>>();
             Map<String,String> caseTypeAndOrigMap1                    =   new Map<String,String>();
            
            for( Request_Types__mdt requestType :  cls2.requestTypeList  )
            {
                caseTypeAndOrigMap1.put(requestType.Request_Name__c, requestType.CaseType_Name_Origin__c);
                String planIds   =   requestType.Plan_Ids__c;
                if(caseTypeWithrequestMapTemp1.containsKey( requestType.CaseType__c))
                {
                    caseTypeWithrequestMapTemp1.get(requestType.CaseType__c).add(requestType.Request_Name__c);
                }else{
                    List<String> reqList = new List<String>();
                    reqList.add(requestType.Request_Name__c);
                    caseTypeWithrequestMapTemp1.put(requestType.CaseType__c, reqList);
                }       
            } 
            cls2.caseTypeWithrequestMap  =  caseTypeWithrequestMapTemp1;
            
            PageReference pageRef2       =  Page.OMNIQueueManagementPage;
            Test.setCurrentPageReference(pageRef2); 
            System.currentPageReference().getParameters().put('oId', cls.omniQueue.Id);   

            cls2.selectedCaseType    =  'Demographics';
            cls2.openPage();
            cls2.isDeleteMode         = false;
            cls2.isEditPage        =  true;
           
            cls2.processorsWrap.clear();
            cls2.userList          = usrListTemp;
            cls2.displayProcessors();
            cls2.doDisplayQueuerecords();
            cls2.omniQueueObj.Request_Type_s__c         =   'Billing Address Change';
            cls2.doSave(); 
            Test.stopTest();
        }
    }
    static testMethod void test_EditAndDoSave(){
        List<User>  userList  =  TestCaseUtil.createUser('Supervisor','Illinois Supervisor',3);
        insert userList;
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
    		insertTestData();
		}
        Set<Id>   userId    =  new Set<Id>();
        userId.add(userList[0].Id);
        userId.add(userList[1].Id); 
        userId.add(userList[2].Id);
        List<User> usrListTemp        =  [Select Id,Name from User where Id IN:userId];
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(usrListTemp[0].Id,usrListTemp[0].Name));
        options.add(new SelectOption(usrListTemp[1].Id,usrListTemp[1].Name));
        options.add(new SelectOption(usrListTemp[2].Id,usrListTemp[2].Name));
        
        List<RecordType> recType =[SELECT DeveloperName,Id,Name FROM RecordType WHERE Name = 'Email'];

        System.runAs(new User(Id = UserInfo.getUserId())){
            
            OMNIQueueManagementCls cls  =  new OMNIQueueManagementCls();
            PageReference pageRef     =  Page.OMNIQueueManagementPage;
            Test.setCurrentPage(pageRef);
            cls.requestTypeList        =  TestContextMetaDataSupportCls.requestTypes('IL1');
            
            Map<String,List<String>>     caseTypeWithrequestMapTemp  =   new Map<String,List<String>>();
            Map<String,String> caseTypeAndOrigMap                =   new Map<String,String>();
            
            for( Request_Types__mdt requestType :  cls.requestTypeList  )
            {
                caseTypeAndOrigMap.put(requestType.Request_Name__c, requestType.CaseType_Name_Origin__c);
                String planIds   =   requestType.Plan_Ids__c;
                if(caseTypeWithrequestMapTemp.containsKey( requestType.CaseType__c))
                {
                    caseTypeWithrequestMapTemp.get(requestType.CaseType__c).add(requestType.Request_Name__c);
                }else{
                    List<String> reqList = new List<String>();
                    reqList.add(requestType.Request_Name__c);
                    caseTypeWithrequestMapTemp.put(requestType.CaseType__c, reqList);
                }       
            } 
            cls.caseTypeWithrequestMap  =  caseTypeWithrequestMapTemp;
            cls.selectedProcessors = options;
            cls.updateProcessors();
            cls.selectedCaseType    =  'Demographics';
            cls.isEditPage        =  false;
            cls.planId          =  'IL1';
            
            cls.selectedRequests.add(new SelectOption('Administrative Change','Administrative Change'));
            cls.omniQueueObj.Case_Type__c              =   'Demographics';
            cls.omniQueueObj.Request_Type_s__c         =   'NPI Tax Id Change; Administrative Change';
            cls.omniQueueObj.Plan_Id__c                =   'IL1';
            cls.omniQueueObj.Queue_Priority__c         =   '5';
            cls.omniQueueObj.Name            =  'kjfhdkjsafhkjsdah';
                     
            OMNI_User_Group__c usrGrouprec1        =   new OMNI_User_Group__c();
            usrGrouprec1.Start_Date__c         =   date.today();
            usrGrouprec1.End_Date__c           =   Date.Today().addDays(15);
            usrGrouprec1.Plan_Id__c            =   'IL1';
            usrGrouprec1.Active__c             =   true;
            usrGrouprec1.Week_Days__c          =   'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday';
            usrGrouprec1.Selected_User_Ids__c  =   usrListTemp[0].Id;
            usrGrouprec1.Selected_Users__c     =   usrListTemp[0].Name;
            cls.omniUserGrpList.add(usrGrouprec1);
            cls.doSave();
            cls.omniUserGrpList[0].Start_Date__c=Date.Today().addDays(16);
            cls.omniUserGrpList[0].End_Date__c=Date.Today().addDays(15);
            cls.doSave();
            cls.omniUserGrpList[0].start_Date__c=Date.Today();
            cls.omniUserGrpList[0].End_Date__c=Date.Today().addDays(15);            
            cls.omniUserGrpList[0].Selected_Users__c=NULL;
            cls.doSave();
            cls.omniUserGrpList[0].selected_Users__c=usrListTemp[0].Name;
            cls.omniUserGrpList[0].start_Date__c=Date.Today();
            cls.omniUserGrpList[0].End_Date__c=Date.Today().addDays(15);             
            cls.isEditPage=true;
            cls.dosave();
            
            List<QueuesObject> qSobjectList   =  new List<QueuesObject>();
            QueuesObject  qSobject         =  new QueuesObject (SobjectType ='Case', QueueId=cls.g.id);
            qSobjectList.add(qSobject);
            QueuesObject  qSobject2       =  new QueuesObject (SobjectType ='OMNI_Queue__c', QueueId=cls.g.id);
            qSobjectList.add(qSobject2);     
            insert qSobjectList;  
            OMNI_Queue__c o = [select id,ownerid from OMNI_Queue__c where id = :cls.omniQueue.id];
            o.ownerid = cls.g.id;
            update o;
            cls.selectedCaseType='Demographics';
            cls.isEditPage=true;
            OMNI_Queue__c newqueue = [Select Id From OMNI_Queue__c Limit 1];
            ApexPages.currentPage().getParameters().put('oId',newQueue.Id);
            cls = new OMNIQueueManagementCls();
            cls.displayCaseReqtypes();
        } 
    }
}