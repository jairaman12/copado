@isTest
public class CasetriggerHandlerTest1 

{
    
     @testSetup static void prepareData() 
     {
        TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
         
        testclassdata.CreateCustomSettingData('Case');
        testclassdata.CreateCustomSettingData('Provider_Networks__c');
        
    }
    /************* case Owner change ************/
    @isTest
    static void test_caseOwnerChange(){
        
        List<User>  userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
        
        List<User>  dataRepUserlist =   TestCaseUtil.createUser('Provider Data Rep','Provider Data Rep- IL',1);
        insert dataRepUserlist;

        System.runAs(userList[0]){
            CaseOwnerUpdate__c caseOwner1 = new CaseOwnerUpdate__c(Name='PNC Profile',Profile__c='PNC Profile');
        insert caseOwner1;
        
        CaseOwnerUpdate__c caseOwner2 = new CaseOwnerUpdate__c(Name='Provider Data Rep',Profile__c='Provider Data Rep');
        insert caseOwner2;
       
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
        try
        {
            insert childCase;
        }
            Catch(Exception ex)
            {
                
            }
         Test.startTest();
            Case tempcase = new Case(Id=childCase.Id);
           tempcase.OwnerId =dataRepUserlist[0].Id;
            update tempcase;
         Test.stopTest();
        }
    }
    
    /************* case Queue change ************/
    @isTest
     static void test_caseQueueChange(){
        List<User>  userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
         
        Group testGroup = new Group(Name='Illinois Queue', Type='Queue');
        insert testGroup;
         
        UserRole r = new UserRole(DeveloperName = 'Illinois_Supervisor1', Name = 'Illinois Supervisor');
        insert r; 
         
        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
        insert testQueue;

        System.runAs(userList[0]){
            CaseOwnerUpdate__c caseOwner1 = new CaseOwnerUpdate__c(Name='PNC Profile',Profile__c='PNC Profile');
        insert caseOwner1;
        
        CaseOwnerUpdate__c caseOwner2 = new CaseOwnerUpdate__c(Name='Provider Data Rep',Profile__c='Provider Data Rep');
        insert caseOwner2;
       
        List<RecordType> recType =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE Name In ('Master Provider Case data','Name Change Request')];
        Case parentCase          =  TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c   =   'test@test.com';
        parentCase.RecordTypeId =   recType[0].id;
        parentCase.Plan_ID__c   =   'IL1';
        parentCase.Status       =   'New';
         parentCase.Subject     =   'Test Email';
         parentCase.Origin      =   'PNC NetOps Inquiries';
            try
            {
        insert parentCase;
            }
            Catch(Exception ex)
            {}
        
        Case childCase          =   TestCaseUtil.CreateCase(); 
            if(parentCase !=NULL && parentCase.id !=NULL)
            {
        childCase.ParentId      =   parentCase.id; 
        }
        childCase.Email_Address_Submitter__c    =   'test3@test.com';
        childCase.RecordTypeId  =   recType[1].id;
        childCase.Govt_Programs__c              =   true;
        childCase.Plan_ID__c                    =   'IL1';
        childCase.Status                        =   'New';
        insert childCase;
            
            Test.startTest();            
                Case tempcase = new Case(Id=childCase.Id);
                tempcase.OwnerId    =testGroup.Id;
                update tempcase;
            Test.stopTest();
        }
    }
     Static testmethod void  coverlinkRolodexAccount(){
         Test.startTest();         
         RecordType rolodexType = [Select Id From RecordType Where sObjectType='Account' and Name='Rolodex'];
         Account newRolodex = new Account();
         newRolodex.lastName='testing1';
         newRolodex.Tax_Id__c='123654789';
         newRolodex.NPI__c='1236547896';
         newRolodex.Phone = '2145369875';
         newRolodex.RecordTypeId = rolodexType.Id;
         newRolodex.PersonEmail = 'Test1@mail.com';
         newRolodex.CM_Corporate_Entity_Code__c = 'IL1';
         insert newRolodex;
          RecordType CRMType = [Select Id From RecordType Where sObjectType='Case' and Name='CRM'];
         List<Case> listOfCases = new List<Case> ();
         Case c1 = new Case();
         c1.NPI_Tax_Id_Change__c  =   true; 
         c1.Tax_Id_Number__c   ='123654789';
         c1.Billing_NPI_Number__c ='1236547891';
         c1.Telephone_Number_Submitter__c  = '2145369834';
         c1.Email_Address_Submitter__c    ='Test1@testmail.com';
         c1.Name_Submitter__c   = 'testing';
         c1.RecordTypeId  = CRMType.Id;   
         c1.origin = 'Web-Demographics';
         c1.plan_id__c = 'IL1';
         listofCases.add(c1);
         Case c2 = new Case();
         c2.NPI_Tax_Id_Change__c  =   true; 
         c2.Tax_Id_Number__c   ='123654789';
         c2.Billing_NPI_Number__c ='1236547896';
         c2.Telephone_Number_Submitter__c  = '2145369875';
         c2.Email_Address_Submitter__c    ='Test1@mail.com';
         c2.Name_Submitter__c   = 'testing';
         c2.origin = 'Web On-boarding';
         c2.RecordTypeId  = CRMType.Id;   
         c2.plan_id__c = 'IL1';
         listofCases.add(c2);
         insert listofCases; 
         List<Case> ucase = new List<Case>();
         case nCase = new Case();
         nCase.Status = c2.status;
         nCase.Bill_PFIN__c = c2.Bill_PFIN__c;       
         
         ucase.add(nCase);
         upsert ucase;
         Test.stopTest();
        
    }
    Static testmethod void coverallmethods(){
         test.startTest();
         List<User> userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
         insert userList;
        System.runAs(userList[0])
        {
         //CaseTriggerHandler.validateUserRole(userList[0].id, 'IL1');
         //CaseTriggerHandler.validateUserRole(userList[0].id, 'OK1');
         CaseTriggerHandler.profileIsInExclusionList();
         //CaseTriggerHandler.getCaseProfile();
         CaseTriggerHandler.getCaseStatus('Pending'); 
         list<OMNI_Queue__c> listoQueue = new List<OMNI_Queue__c>();
         OMNI_Queue__c  oQueue = new OMNI_Queue__c ();
         oQueue.Case_Type_Name_Origin__c = 'CRM';
         oQueue.Case_Type__c = 'Govt Cases';
         oQueue.Plan_Id__c = 'IL1';
         oQueue.Queue_Priority__c = '5';
         oQueue.Request_Type_s__c  = 'Govt Cases';
         listoQueue.add(oQueue);        
         insert listoQueue;
        RecordType massCaseILRosterType = [Select Id From RecordType Where sObjectType='Case' and developername ='Child_Mass_Case_IL_Roster'];
         List<Case> listOfCases = new List<Case> ();
         Case c4 = new Case();
         c4.NPI_Tax_Id_Change__c  =   true; 
         c4.Tax_Id_Number__c   ='123654789';
         c4.Billing_NPI_Number__c ='1236547891';
         c4.Telephone_Number_Submitter__c  = '2145369834';
         c4.Email_Address_Submitter__c    ='Test1@testmail.com';
         c4.Name_Submitter__c   = 'testing';
         c4.RecordTypeId  = massCaseILRosterType.Id;   
         c4.origin = 'Web-Demographics';
         c4.Govt_Programs__c = true;
         c4.Plan_ID__c = 'IL1';
         c4.SkipOmniRouting__c = '';
         insert c4;
         //insert new parent and child cases
         DataSupportForCaseTriggerHandler ds = new DataSupportForCaseTriggerHandler();
            Case pc = ds.insertDataForParentCases();  
            Case cc = ds.insertDataForChildCases(pc);            
            
            List<Case> cl = new List<Case>();
            cl.add(pc);
            cl.add(cc);
         CaseTriggerHandler.UpdateCaseOwner(cl);
        }
         test.stopTest();
        
        
    }
    
    Static testmethod void coverEmailtoCaseOwnerUpdate(){
         test.startTest();
         List<User>  userList  =  TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
         insert userList;
        System.runAs(userList[0])
        {
         //CaseTriggerHandler.validateUserRole(userList[0].id, 'IL1');
         //CaseTriggerHandler.validateUserRole(userList[0].id, 'OK1');
         CaseTriggerHandler.profileIsInExclusionList();
         //CaseTriggerHandler.getCaseProfile();
         CaseTriggerHandler.getCaseStatus('Pending'); 
         list<OMNI_Queue__c> listoQueue = new List<OMNI_Queue__c>();
         OMNI_Queue__c  oQueue = new OMNI_Queue__c ();
         oQueue.Case_Type_Name_Origin__c = 'Email';
         oQueue.Case_Type__c = 'Email';
         oQueue.Plan_Id__c = 'IL1';
         oQueue.Queue_Priority__c = '5';
         oQueue.Request_Type_s__c  = 'Govt Cases';
         listoQueue.add(oQueue);        
         insert listoQueue;
        RecordType eMailType = [Select Id From RecordType Where sObjectType='Case' and developername ='Email'];
         List<Case> listOfCases = new List<Case> ();
         Case c4 = new Case();
         c4.NPI_Tax_Id_Change__c  =   true; 
         c4.Tax_Id_Number__c   ='123654789';
         c4.Billing_NPI_Number__c ='1236547891';
         c4.Telephone_Number_Submitter__c  = '2145369834';
         c4.Email_Address_Submitter__c    ='Test1@testmail.com';
         c4.Name_Submitter__c    = 'testing';
         c4.RecordTypeId  = eMailType.Id;   
         c4.origin = 'Email';
         c4.Govt_Programs__c = true;
         c4.Plan_ID__c = 'IL1';
         c4.SkipOmniRouting__c = '';
         insert c4;
         //insert new parent and child cases
         DataSupportForCaseTriggerHandler ds = new DataSupportForCaseTriggerHandler();
            Case pc = ds.insertDataForParentCases();  
            Case cc = ds.insertDataForChildCases(pc);            
            
            List<Case> cl = new List<Case>();
            cl.add(pc);
            cl.add(cc);
         CaseTriggerHandler.UpdateCaseOwner(cl);
        }
         test.stopTest();
        
        
    }

}