/*******************************************
@Author Intake team (Andrew M)
@Date   10/19/17
@Description methods and properties related to test code coverage for CaseTriggerHandler
********************************************/
@isTest
private class TestCaseTriggerHandler1
{
    
    public static DataSupportForCaseTriggerHandler ds = new DataSupportForCaseTriggerHandler();
    
    @testSetup static void prepareData() {
        /*string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();

        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Credentialing_record_types__c = strIndvCredRecTypeId;
        insert gs; */
        
        TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        
        
        //do inserts to initalize custom settings
        ds.insertDataForCustomSettings();
        
        testclassdata.CreateCustomSettingData('case');
        testclassdata.CreateCustomSettingData('Provider_Networks__c');    
        
        List<case> casetList = new List<Case>();
        
        for(Integer i = 1; i <=5; i++){
            Case tCase = TestCaseUtil.CreateCase();
            casetList.add(tCase);
        }        
        insert casetList;
    }
    
    @isTest static void testMethod_1()
    {
        
        //Create supervisor test user
        List<User> userList    =   TestCaseUtil.createUser('PNC Profile','Illinois Supervisor',1);
        insert userList;
        System.runAs(userList[0]){        
            
            
            //insert new parent and child cases
            Case pc = ds.insertDataForParentCases();  
            Case cc = ds.insertDataForChildCases(pc);            
            
            List<Case> cl = new List<Case>();
            cl.add(pc);
            cl.add(cc);            
            
            Set<Id> parentCaseIdSet =  new Set<Id>();
            parentCaseIdSet.add(pc.id);
            parentCaseIdSet.add(cc.id);
            
            /*
* execute some stand alone methods
*/ 
            Test.StartTest();           
            CaseTriggerHandler.caseStatusUpdate(parentCaseIdSet);
            CaseTriggerHandler.UpdateCaseOwner(cl);
            //CaseTriggerHandler.validateUserRole(userList[0].id, 'IL1');
            //CaseTriggerHandler.validateUserRole(userList[0].id, 'OK1');
            CaseTriggerHandler.getChildCasesByParentStatus(parentCaseIdSet);
            CaseTriggerHandler.getChildCasesByParent(parentCaseIdSet);
            CaseTriggerHandler.casePriorityUpdate(parentCaseIdSet);  
               
            
            CaseComment casec = new CaseComment
                (
                    CommentBody = 'This is my test comment',
                    ParentId = pc.id,
                    IsPublished = true               
                );
            insert casec;            
            CaseTriggerHandler.getComments(pc,casec);
            ds.updateCase(cc,'status','Closed Processed');          
            ds.updateCase(pc, 'status', 'Closed Processed');
            ds.updateCase(cc, 'origin', 'Web On-boarding');
            ds.updateCase(pc, 'origin', 'Web On-boarding');   
            ds.updateCase(cc, 'ownerid', '0053C000000Fl9hQAC');
            ds.updateCase(pc, 'ownerid', '0053C000000Fl9hQAC');             
            ds.updateCase(pc, 'priority', 'High');
            Test.StopTest(); 
            
            //insert new parent and child cases
        }        
    }   
    
    static testmethod void createCase(){
        
        List<case> caseList = new List<Case>();
        List<User> userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
       
        System.runAs(userList[0]){
        
            //for(Integer i = 1; i <=5; i++){
                Case curCase = TestCaseUtil.CreateCase();
                caseList.add(curCase);
            //}
            
            insert caseList;
            
            list<case> casetlist = new list<case>();
            casetList = [select id,status,plan_id__c from case];
            casetList[0].status = 'Closed Processed';
            casetList[1].status = 'Closed Rejected';
            casetList[2].plan_id__c = 'TX1';
            
            
            test.startTest();
            update casetList;
            test.stopTest();
        }        
    }
    
    @isTest static void testMethod_3()
    {
        list<case> casetlist = new list<case>();
        casetList = [select id,status,plan_id__c from case];
        casetList[0].status = 'Closed Processed';
        casetList[1].status = 'Closed Rejected';
        casetList[2].plan_id__c = 'TX1';
        
        List<User> userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
        System.runAs(userList[0]){
            test.startTest();
            update casetList;
            test.stopTest();
        }        
    }
    
    @isTest static void testMethod_4()
    {
        List<case> caseList = new List<Case>();
        
        for(Integer i = 1; i <=2; i++){
            Case curCase = TestCaseUtil.CreateCase();
            caseList.add(curCase);      
        }
        insert caseList;
        caseList[0].parentId = caseList[1].Id;
        caseList[0].status = 'Closed Processed';
            test.startTest();
            update caseList;
            test.stopTest();
                
    }
    
    @isTest static void testMethod_5()
    {
        
        //Create supervisor test user
        List<User> userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
        System.runAs(userList[0]){        
            
            
            //insert new parent and child cases
            Case pc = ds.insertDataForParentCases();  
            Case cc = ds.insertDataForChildCases(pc);            
            
            List<Case> cl = new List<Case>();
            cl.add(pc);
            cl.add(cc);
            
            Set<Id> parentCaseIdSet =  new Set<Id>();
            parentCaseIdSet.add(pc.id);
            parentCaseIdSet.add(cc.id);
            
            /*
* execute some stand alone methods
*/ 
            Test.StartTest();           
            CaseTriggerHandler.caseStatusUpdate(parentCaseIdSet);
            CaseTriggerHandler.UpdateCaseOwner(cl);
            //CaseTriggerHandler.validateUserRole(userList[0].id, 'IL1');
            //CaseTriggerHandler.validateUserRole(userList[0].id, 'OK1');
            CaseTriggerHandler.getChildCasesByParentStatus(parentCaseIdSet);
            CaseTriggerHandler.getChildCasesByParent(parentCaseIdSet);
            CaseTriggerHandler.casePriorityUpdate(parentCaseIdSet);    
            
            CaseComment casec = new CaseComment
                (
                    CommentBody = 'This is my test comment',
                    ParentId = pc.id,
                    IsPublished = true               
                );
            insert casec;            
            CaseTriggerHandler.getComments(pc,casec);
            ds.updateCase(cc,'status','Closed Processed');          
            ds.updateCase(pc, 'status', 'Closed Processed');
            ds.updateCase(cc, 'origin', 'Web On-boarding');
            ds.updateCase(pc, 'origin', 'Web On-boarding');   
            ds.updateCase(cc, 'ownerid', '0053C000000Fl9hQAC');
            ds.updateCase(pc, 'ownerid', '0053C000000Fl9hQAC');             
            ds.updateCase(pc, 'priority', 'High');
            Test.StopTest(); 
            
            //insert new parent and child cases
        }        
    }   
    
    static testmethod void updateMasterCaseForPedi()
    {
        /*string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();

        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Credentialing_record_types__c = strIndvCredRecTypeId;
        insert gs; */
         TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        
        Account newAccount = TestCaseUtil.createAccount();  
        CM_Provider_Identification__c provIdentification = new CM_Provider_Identification__c();
        provIdentification.CM_PI_Prov__c = newAccount.Id;
        provIdentification.CM_Prvdr_Iden_Typ_Cd__c = 'License'; 
        provIdentification.CM_Issu_Ident_Nmbr__c = '12345';
        insert provIdentification; 
        List<Case> listOfCases = new List<Case>();
        Id groupContracting,groupOnboarding,groupCredentialing,groupNetworking,contractingRecType,countersignRecType;       
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_Group_Onboarding_Contracting' OR DeveloperName='Provider_On_boarding' OR DeveloperName = 'Contracting_Provider_On_boarding' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Credentialling' OR DeveloperName='Provider_Group_On_boarding_Network_Load' OR DeveloperName='Provider_On_boarding_Counter_Sign') AND SObjecttype='Case'])
        {
            if(newType.developerName=='Provider_Group_Onboarding_Contracting')
            {
                groupContracting=newType.Id;
            }
            if(newType.developerName=='Provider_On_boarding')
            {
                groupOnboarding=newType.Id;
            }
            if(newType.developerName=='Provider_Group_On_boarding_Credentialling')
            {
                groupCredentialing=newType.Id;
            }
            if(newType.developerName=='Provider_Group_On_boarding_Network_Load')
            {
                groupNetworking=newType.Id;
            }
            if(newType.developerName == 'Contracting_Provider_On_boarding'){
                contractingRecType = newType.Id;
            }
            if(newType.developerName=='Provider_On_boarding_Counter_Sign')
            {
                countersignRecType =newType.Id;
            }
        }
        Case parentCase = new Case();
        parentCase.Plan_ID__c='IL1';
        parentCase.RecordTypeId=groupOnboarding;
        parentCase.subject='Testing';
        parentCase.Description='Testing';
        parentCase.status='New';           
        parentCase.Email_Address_Submitter__c = 'test@hcsc.net';
        parentCase.origin   ='Web-Onboarding';
        parentCase.Completing_the_form_for__c='Group';
        parentCase.accountId = newAccount.Id;
        //parentCase.ownerId = userList[1].id;
        insert parentCase;
        
        
        
        Case counterCase = new Case();
        counterCase.Plan_ID__c='IL1';
        counterCase.Email_Address_Submitter__c = 'test@hcsc.net';
        counterCase.origin   ='Web On-boarding';
        counterCase.parentId=parentCase.Id;
        counterCase.status='New';
        counterCase.subject='Test';
        counterCase.Description='Test';
        counterCase.Network_Name__c ='a-b,b-c,c-d'; 
        counterCase.Completing_the_form_for__c='Group';        
        counterCase.RecordTypeId=groupContracting; 
        counterCase.accountId = newAccount.Id;
        
        insert counterCase;

        Case contractCase = new Case();
        contractCase.Plan_ID__c='IL1';
        contractCase.Email_Address_Submitter__c = 'test@hcsc.net';
        contractCase.origin   ='Web On-boarding';
        contractCase.parentId=parentCase.Id;
        contractCase.status='New';
        contractCase.subject='Test';
        contractCase.Description='Test';
        contractCase.Network_Name__c ='a-b,b-c,c-d'; 
        contractCase.Completing_the_form_for__c='Group';        
        contractCase.RecordTypeId=contractingRecType;
        contractCase.accountId=newAccount.Id;
        //contractCase.ownerId = userList[0].id;
        
        insert contractCase;
        
        contractCase.status = 'InProgress';
        update contractCase;
        Test.startTest();
       
        Provider_Networks__c newNetwork = new Provider_Networks__c();
        newNetwork.Contracting_Case__c= contractCase.Id;
        newNetwork.Prov_ID__c='5324525';
        newNetwork.Cred_Status__c='Needs Credentialing';
        //insert newNetwork;
        
       
        Provider_Networks__C newNetwork2 = new Provider_Networks__c();
        newNetwork2.Contracting_Case__c=contractCase.Id;
        newNetwork2.Prov_ID__c='5324525';
        newNetwork2.Cred_Status__c='No Credentialing Needed';
        //insert newNetwork2;       
        
        
        
        for(Integer count=0;count<1;count++)
        {
            Case newNetworking = new Case();
            newNetworking.Plan_ID__c='IL1';
            //newNetworking.Email_Address_Submitter__c = 'test@hcsc.net';
            newNetworking.origin   ='Web On-boarding';
            newNetworking.parentId=parentCase.Id;
            newNetworking.status='New';
            newNetworking.subject='Test';
            newNetworking.Description='Test';
            newNetworking.Network_Name__c ='a-b,b-c,c-d'; 
            newNetworking.Network_Effective_Date__c = system.today(); 
            newNetworking.Completing_the_form_for__c='Group';        
            newNetworking.RecordTypeId=groupCredentialing; 
            listOfCases.add(newNetworking);
        }
        insert listOfCases;
        Case newCase=[Select status from Case Where RecordTypeId=:groupCredentialing and ParentId=:parentCase.Id];
        newCase.status='Cred Approved';
        update newCase;
        
        List<case> caseList = [Select status from Case Where RecordTypeId=:groupNetworking and ParentId=:parentCase.Id];
        if(!caseList.isEmpty()){
           Case newNetworkCase = new Case(Id=caseList[0].Id) ;
            newNetworkCase.status='Closed Processed';
            newNetworkCase.Completing_the_form_for__c='Group';
            newNetworkCase.Network_name__c = 'Network1;Network2;Network3';
            newNetworkCase.External_Comments__c = 'External Comments';
            newNetworkCase.Contract_PFIN__c='test';
            newNetworkCase.accountId=newAccount.Id;
            newNetworkCase.Network_Effective_Date__c = Date.newInstance(2016, 12, 9);
            update newNetworkCase;  
        }
        
     Test.stopTest();   
    }
    
 static testmethod void updateMasterCaseForPedi1()
    {
       
        /*test.startTest();
        /*string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();

        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Credentialing_record_types__c = strIndvCredRecTypeId;
        insert gs; 
         TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        Account newAccount = TestCaseUtil.createAccount();        
        List<Case> listOfCases = new List<Case>();
        Id groupOnboarding,groupOnboarding1,pfinProviderRectypeId, contProviderRecType ;       
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_On_boarding'OR DeveloperName='Data_Entry_Group_Provider_On_boarding') AND SObjecttype='Case'])
        {
            
            if(newType.developerName=='Data_Entry_Group_Provider_On_boarding')
            {
                groupOnboarding1=newType.Id;
            }
            if(newType.developerName=='Provider_On_boarding')
            {
                groupOnboarding=newType.Id;
            }
           
        }
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='PFIN_Onboarding' or DeveloperName = 'Contracting_Onboarding') AND SObjecttype='Provider_Networks__c'])
        {
        
          if(newType.developerName =='PFIN_Onboarding')
            {
                pfinProviderRectypeId =newType.Id;
            }
          else if(newType.developerName == 'Contracting_Onboarding'){
                contProviderRecType = newType.Id;
            }
        }
        Case parentCase = new Case();
        parentCase.Plan_ID__c='IL1';
        parentCase.RecordTypeId=groupOnboarding;
        parentCase.subject='Testing';
        parentCase.Description='Testing';
        parentCase.status='New';           
        parentCase.Email_Address_Submitter__c = 'test@hcsc.net';
        parentCase.origin   ='Web-Onboarding';
        parentCase.Completing_the_form_for__c='Group';
        parentCase.accountId = newAccount.Id;
        insert parentCase;
        
        Case pfinCase= new Case();
        pfinCase.Plan_ID__c='IL1';
        pfinCase.Email_Address_Submitter__c = 'test@hcsc.net';
        pfinCase.origin   ='Web On-boarding';
        pfinCase.parentId=parentCase.Id;
        pfinCase.status='New';
        pfinCase.subject='Test';
        pfinCase.Description='Test';
        pfinCase.Network_Name__c ='a-b,b-c,c-d'; 
        pfinCase.Completing_the_form_for__c='Group';        
        pfinCase.RecordTypeId=groupOnboarding1; 
        pfinCase.Billing_NPI_Number__c = '0123456789';
        pfinCase.Telephone_Number_Submitter__c ='(987) 456-1230';
        pfinCase.Tax_Id_Number__c ='012345689';
        pfinCase.Email_Address_Submitter__c ='test@gmail.com';
        pfinCase.Name_Submitter__c='testjohn';
        pfinCase.Title_Submitter__c='Mr';
        pfinCase.Plan_ID__c='012';
        pfinCase.accountId = newAccount.Id;        
        insert pfinCase;
        
        pfinCase.paper_cred_indicator__c = true;
        update pfinCase;
        
        Provider_Networks__C newNetwork1 = new Provider_Networks__c();
        newNetwork1.PFIN_Case__c=pfinCase.Id;
        newNetwork1.Prov_ID__c='5324525';
        newNetwork1.RecordTypeId=pfinProviderRectypeId;
        insert newNetwork1;
        
        pfinCase.status='Closed Processed';
        update pfinCase;
        
        List<Provider_Networks__c> provList = new List<Provider_Networks__c>();
        for(Provider_Networks__c pfinNet : [SELECT Id, Cred_Status__c, PFIN_onBoarding__c, Network_Code_Name__c, Prov_ID__c, PFIN__c FROM Provider_Networks__c WHERE contracting_Case__r.parentId =: parentCase.Id AND recordTypeId =: contProviderRecType]){
            Provider_Networks__c prov = new Provider_Networks__c(Id = pfinNet.Id);
            prov.PFIN_onBoarding__c = '1234';
            prov.Network_Code_Name__c = 'Network Name';
            prov.Cred_Status__c = 'No Credentialing Needed';
            provList.add(prov);
        }
        
        update provList;
        
        test.StopTest();
*/
      
    }
    
     @isTest static void testMethod_6()
    {
       
        
        RoleAndPlanId_Settings__c   Rp =   new RoleAndPlanId_Settings__c();
        Rp.Name = 'Illinois Supervisor';
        Rp.Role_Id__c =   '00E41000000bXVsEAM';
        Rp.PlanId__c =   'IL1';
        insert Rp;  
        
        QueueIds__c   Q =   new QueueIds__c();
        Q.Name = 'IL Queue';
        Q.QueueId__c = '00G41000001U0qKEAS';
        Q.PlanId__c =  'IL1';
        insert Q;    
        
        /*string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();

        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Credentialing_record_types__c = strIndvCredRecTypeId;
        insert gs; */
         TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
      
        
           List<Case> caseList = new List<Case>();
            Case curCase = TestCaseUtil.CreateCase();
            caseList.add(curCase);
            
            
            insert caseList;
            
            list<case> casetlist = new list<case>();
            casetList = [select id,status,plan_id__c,OwnerId from case];
            casetList[0].OwnerId = '00G41000001U0qKEAS';
            casetList[0].status = 'Closed Processed';
            casetList[1].status = 'Closed Rejected';
            casetList[1].ParentId= casetList[0].Id;
            casetList[1].plan_id__c= 'IL1';
            casetList[1].OwnerId = '00G41000001U0qKEAS';
            casetList[2].plan_id__c = 'IL1';
            
            
            test.startTest();
            update casetList;
            test.stopTest();
       
           }    
   
    
   
    
    
}