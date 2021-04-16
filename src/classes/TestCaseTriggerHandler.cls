/*******************************************
@Author Intake team (Andrew M)
@Date   10/19/17
@Description methods and properties related to test code coverage for CaseTriggerHandler
********************************************/
@isTest
private class TestCaseTriggerHandler
{
    
    public static DataSupportForCaseTriggerHandler ds = new DataSupportForCaseTriggerHandler();
    
    @testSetup static void prepareData() {
        string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();

        /*GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Credentialing_record_types__c = strIndvCredRecTypeId;
        insert gs;*/
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
        casetList[2].ownerId ='00G41000001U0qKEAS';
        casetList[2].parentId=casetList[0].Id;
        
        List<User> userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
        System.runAs(userList[0]){
            test.startTest();
            update casetList;
            test.stopTest();
        }        
    }    
    
     @isTest static void testMethod_3_1()
    {
        list<case> casetlist = new list<case>();
        casetList = [select id,status,plan_id__c from case];
        casetList[2].plan_id__c = 'TX1';
        casetList[2].ownerId ='00G41000001U0qKEAS';
        
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
        string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();

        TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        
        Test.startTest();
        Account newAccount = TestCaseUtil.createAccount();
        CM_Provider_Identification__c provIdentification = new CM_Provider_Identification__c();
        provIdentification.CM_PI_Prov__c = newAccount.Id;
        provIdentification.CM_Prvdr_Iden_Typ_Cd__c = 'License'; 
        provIdentification.CM_Issu_Ident_Nmbr__c = '12345';
        insert provIdentification;         
        List<Case> listOfCases = new List<Case>();
        List<Case> listOfCases1 = new List<Case>();
        Id grpDataEntry,groupContracting,groupOnboarding,indvNetworking,indvCredentialing,groupCredentialing,groupNetworking,contractingRecType,countersignRecType,countergrpsignRecType,masterentityRecType; 
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_Group_Onboarding_Contracting' OR DeveloperName='Provider_On_boarding' OR DeveloperName = 'Contracting_Provider_On_boarding' OR
                                                                               DeveloperName='Data_Entry_Group_Provider_On_boarding' OR  DeveloperName='Provider_On_boarding_Credentialing' OR DeveloperName='Network_Load' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Credentialling' OR DeveloperName='Provider_Group_On_boarding_Counter_Sign' OR DeveloperName='Provider_Group_Onboarding_Master_Entity' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Network_Load' OR DeveloperName='Provider_On_boarding_Counter_Sign') AND SObjecttype='Case'])
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
            if(newType.developerName=='Network_Load')
            {
                indvNetworking =newType.Id;
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
        counterCase.case_Entity__c = newAccount.Id;
        
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
        Provider_Networks__C newNetwork = new Provider_Networks__c();
        newNetwork.Contracting_Case__c=counterCase.Id;
        newNetwork.Prov_ID__c='5324525';
        newNetwork.Cred_Status__c='Needs Credentialing';
        try{
            insert newNetwork;
        }
        catch(Exception e){
        
        }
        
       
        newNetwork = new Provider_Networks__c();
        newNetwork.Contracting_Case__c=counterCase.Id;
        newNetwork.Prov_ID__c='5324525';
        newNetwork.Cred_Status__c='No Credentialing Needed';
        insert newNetwork;       
                
        
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
            newNetworking.Completing_the_form_for__c='Group';        
            newNetworking.RecordTypeId=groupCredentialing; 
            listOfCases.add(newNetworking);
        }
        insert listOfCases;
        Case newCase=[Select status from Case Where RecordTypeId=:groupCredentialing and ParentId=:parentCase.Id];
        newCase.status='Cred Approved';
        update newCase;
        
        Case newNetworking2 = new Case();
        newNetworking2.Plan_ID__c='IL1';
        newNetworking2.origin   ='Web On-boarding';
        newNetworking2.parentId=parentCase.Id;
        newNetworking2.status='New';
        newNetworking2.subject='Test';
        newNetworking2.Description='Test';
        newNetworking2.Network_Name__c ='a-b,b-c,c-d'; 
        newNetworking2.Completing_the_form_for__c='Individual';        
        newNetworking2.RecordTypeId=indvNetworking; 
        //insert newNetworking2;
        Test.stopTest(); 
        case caseList = [Select status from Case Where RecordTypeId=:groupNetworking and ParentId=:parentCase.Id];
        //if(!caseList.isEmpty()){
           Case newNetworkCase = new Case(Id=caseList.Id) ;
            newNetworkCase.status='Closed Processed';
            newNetworkCase.Completing_the_form_for__c='Group';
            newNetworkCase.Network_name__c = 'Network1;Network2;Network3';
            newNetworkCase.External_Comments__c = 'External Comments';
            newNetworkCase.Contract_PFIN__c='test';
            newNetworkCase.Network_Effective_Date__c	=	 System.today();
            newNetworkCase.accountId=newAccount.Id;
            update newNetworkCase;  
       // }
       
        
       
    }
    
 static testmethod void updateMasterCaseForPedi1()
    {
        test.startTest();
         TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        Account newAccount = TestCaseUtil.createAccount();        
        List<Case> listOfCases = new List<Case>();
        Id groupOnboarding,groupOnboarding1,pfinProviderRectypeId;       
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_On_boarding'OR DeveloperName='Provider_On_boarding_Counter_Sign'OR DeveloperName='PFIN_Onboarding') AND SObjecttype='Case'])
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
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='PFIN_Onboarding') AND SObjecttype='Provider_Networks__c'])
        {
        
          if(newType.developerName=='PFIN_Onboarding')
            {
                pfinProviderRectypeId =newType.Id;
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
        counterCase.RecordTypeId=groupOnboarding; 
        counterCase.Billing_NPI_Number__c = '0123456789';
        counterCase.Telephone_Number_Submitter__c ='(987) 456-1230';
        counterCase.Tax_Id_Number__c ='012345689';
        counterCase.Email_Address_Submitter__c ='test@gmail.com';
        counterCase.Name_Submitter__c='testjohn';
        counterCase.Title_Submitter__c='Mr';
        counterCase.Plan_ID__c='012';
        counterCase.accountId = newAccount.Id;
        
        insert counterCase;       
      
        
        Provider_Networks__C newNetwork1 = new Provider_Networks__c();
        newNetwork1.Contracting_Case__c=counterCase.Id;
        newNetwork1.Prov_ID__c='5324525';
        newNetwork1.RecordTypeId=pfinProviderRectypeId;
        insert newNetwork1;
        
        test.StopTest();
      
    }
    
    public static testMethod void insertEntityCase(){
        
        string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
    
        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Credentialing_record_types__c = strIndvCredRecTypeId;
        insert gs;
        Test.startTest();
        Account newAccount = TestCaseUtil.createAccount();
        
        
        List<Case> listOfCases1 = new List<Case>();
        Id grpDataEntry,groupContracting,groupOnboarding,indvNetworking,indvCredentialing,groupCredentialing,groupNetworking,contractingRecType,countersignRecType,countergrpsignRecType,masterentityRecType; 
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_Group_Onboarding_Contracting' OR DeveloperName='Provider_On_boarding' OR DeveloperName = 'Contracting_Provider_On_boarding' OR
                                                                               DeveloperName='Data_Entry_Group_Provider_On_boarding' OR  DeveloperName='Provider_On_boarding_Credentialing' OR DeveloperName='Network_Load' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Credentialling' OR DeveloperName='Provider_Group_On_boarding_Counter_Sign' OR DeveloperName='Provider_Group_Onboarding_Master_Entity' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Network_Load' OR DeveloperName='Provider_On_boarding_Counter_Sign') AND SObjecttype='Case'])
        {
          
            if(newType.developerName=='Provider_On_boarding')
            {
                groupOnboarding=newType.Id;
            }            
            if(newType.developerName=='Provider_Group_On_boarding_Counter_Sign')
            {
                countergrpsignRecType =newType.Id;
            }
            if(newType.developerName=='Provider_Group_Onboarding_Master_Entity')
            {
                masterentityRecType =newType.Id;
            }
            if(newType.developerName=='Data_Entry_Group_Provider_On_boarding')
            {
                grpDataEntry =newType.Id;
            }
            if(newType.developerName=='Provider_On_boarding_Credentialing')
            {
                indvCredentialing =newType.Id;
            }
            if(newType.developerName == 'Contracting_Provider_On_boarding'){
                contractingRecType = newType.Id;
            }
        }
      
    
    
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=groupOnboarding; 
    Insert masterCase;       
    
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Individual';
    contractCase .ParentId =masterCase.Id;
    contractCase .recordtypeid=contractingRecType;
    Insert contractCase ;   
    
     Case entityCase =TestCaseUtil.CreateCase();
    entityCase .Completing_the_form_for__c='Group';
    entityCase .ParentId =masterCase.Id;
    entityCase .recordtypeid=masterentityRecType;
    Insert entityCase ;   
       
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase .Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
    insert providerNetwork2 ;
    
    
    
}
    
    
  
      static testmethod void updateMasterCaseForPedi3()
    {       
        List<User> userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
        System.runAs(userList[0]){
         TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        Test.startTest();
        //Account newAccount = TestCaseUtil.createAccount();  
        
        Id accRectypeId = [Select Id,developerName from RecordType where DeveloperName='Physician'].Id;
        
        Account newAccount  = new Account( Lastname = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1',  recordtypeid = accRectypeId ); 
        insert  newAccount; 
        CM_Provider_Identification__c provIdentification = new CM_Provider_Identification__c();
        provIdentification.CM_PI_Prov__c = newAccount.Id;
        provIdentification.CM_Prvdr_Iden_Typ_Cd__c = 'License'; 
        provIdentification.CM_Issu_Ident_Nmbr__c = '12345';
        insert provIdentification;      
        List<Case> listOfCases = new List<Case>();
        List<Case> listOfCases1 = new List<Case>();
        Id grpDataEntry,groupContracting,groupOnboarding,indvNetworking,indvCredentialing,groupCredentialing,groupNetworking,contractingRecType,countersignRecType,countergrpsignRecType,masterentityRecType; 
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_Group_Onboarding_Contracting' OR DeveloperName='Provider_On_boarding' OR DeveloperName = 'Contracting_Provider_On_boarding' OR
                                                                               DeveloperName='Data_Entry_Group_Provider_On_boarding' OR  DeveloperName='Provider_On_boarding_Credentialing' OR DeveloperName='Network_Load' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Credentialling' OR DeveloperName='Provider_Group_On_boarding_Counter_Sign' OR DeveloperName='Provider_Group_Onboarding_Master_Entity' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Network_Load' OR DeveloperName='Provider_On_boarding_Counter_Sign') AND SObjecttype='Case'])
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
            if(newType.developerName=='Network_Load')
            {
                indvNetworking =newType.Id;
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
        parentCase.Completing_the_form_for__c='Individual';
        parentCase.accountId = newAccount.Id;
        //parentCase.ownerId = userList[1].id;
        insert parentCase;       
        
        
        Case counterCase = new Case();
        counterCase.Plan_ID__c='IL1';
        counterCase.Email_Address_Submitter__c = 'test@hcsc.net';
        counterCase.origin   ='Manual On-boarding';
        counterCase.parentId=parentCase.Id;
        counterCase.status='New';
        counterCase.subject='Test';
        counterCase.Description='Test';
        counterCase.Network_Name__c ='a-b,b-c,c-d'; 
        counterCase.Completing_the_form_for__c='Individual';        
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
        contractCase.Completing_the_form_for__c='Individual';        
        contractCase.RecordTypeId=contractingRecType;
        contractCase.accountId=newAccount.Id;
        //contractCase.ownerId = userList[0].id;
        
        insert contractCase;
        
        contractCase.status = 'InProgress';
        update contractCase;        
        Provider_Networks__C newNetwork = new Provider_Networks__c();
        newNetwork.Contracting_Case__c=counterCase.Id;
        newNetwork.Prov_ID__c='5324525';
        newNetwork.Cred_Status__c='Needs Credentialing';
        try{
            insert newNetwork;
        }
        catch(Exception e){
        
        }
        
       
        newNetwork = new Provider_Networks__c();
        newNetwork.counterSign__c=counterCase.Id;
        newNetwork.Prov_ID__c='5324525';
        newNetwork.Cred_Status__c='No Credentialing Needed';
        insert newNetwork;       
                
        
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
            newNetworking.Completing_the_form_for__c='Group';        
            newNetworking.RecordTypeId=groupCredentialing; 
            listOfCases.add(newNetworking);
        }
        insert listOfCases;
        Case newCase=[Select status from Case Where RecordTypeId=:groupCredentialing and ParentId=:parentCase.Id];
        newCase.status='Cred Approved';
        update newCase;
        Test.stopTest(); 


        Case newNetworking2 = new Case();
        newNetworking2.Plan_ID__c='IL1';
        newNetworking2.origin   ='Web On-boarding';
        newNetworking2.parentId=parentCase.Id;
        newNetworking2.status='New';
        newNetworking2.subject='Test';
        newNetworking2.Description='Test';
        newNetworking2.Network_Name__c ='a-b,b-c,c-d'; 
        newNetworking2.Completing_the_form_for__c='Individual';        
        newNetworking2.RecordTypeId=indvNetworking; 
        insert newNetworking2;
        
        List<case> caseList = [Select status from Case Where RecordTypeId=:groupNetworking and ParentId=:parentCase.Id];
        if(!caseList.isEmpty()){
           Case newNetworkCase = new Case(Id=caseList[0].Id) ;
            newNetworkCase.status='Closed Processed';
            newNetworkCase.Completing_the_form_for__c='Group';
            newNetworkCase.Network_name__c = 'Network1;Network2;Network3';
            newNetworkCase.External_Comments__c = 'External Comments';
            newNetworkCase.Contract_PFIN__c='test';
            newNetworkCase.Network_Effective_Date__c = System.today();
            newNetworkCase.accountId=newAccount.Id;
            update newNetworkCase;  
        }
       
        
     }  
        
     }
     
       static testmethod void updateMasterCaseForPedi4()
    {
        
        string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
		 TestDataFactory tdf = new TestDataFactory();
        tdf.InsertGlobalsetting();
        Test.startTest();
        Account newAccount = TestCaseUtil.createAccount();
        
        
        List<Case> listOfCases1 = new List<Case>();
        Id grpDataEntry,groupContracting,groupOnboarding,indvNetworking,indvCredentialing,groupCredentialing,groupNetworking,contractingRecType,countersignRecType,countergrpsignRecType,masterentityRecType; 
        for(RecordType newType:[Select Id,developerName from RecordType where (DeveloperName='Provider_Group_Onboarding_Contracting' OR DeveloperName='Provider_On_boarding' OR DeveloperName = 'Contracting_Provider_On_boarding' OR
                                                                               DeveloperName='Data_Entry_Group_Provider_On_boarding' OR  DeveloperName='Provider_On_boarding_Credentialing' OR DeveloperName='Network_Load' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Credentialling' OR DeveloperName='Provider_Group_On_boarding_Counter_Sign' OR DeveloperName='Provider_Group_Onboarding_Master_Entity' OR
                                                                               DeveloperName='Provider_Group_On_boarding_Network_Load' OR DeveloperName='Provider_On_boarding_Counter_Sign') AND SObjecttype='Case'])
        {
          
            if(newType.developerName=='Provider_On_boarding')
            {
                groupOnboarding=newType.Id;
            }            
            if(newType.developerName=='Provider_Group_On_boarding_Counter_Sign')
            {
                countergrpsignRecType =newType.Id;
            }
            if(newType.developerName=='Provider_Group_Onboarding_Master_Entity')
            {
                masterentityRecType =newType.Id;
            }
            if(newType.developerName=='Data_Entry_Group_Provider_On_boarding')
            {
                grpDataEntry =newType.Id;
            }
            if(newType.developerName=='Provider_On_boarding_Credentialing')
            {
                indvCredentialing =newType.Id;
            }
            if(newType.developerName == 'Contracting_Provider_On_boarding'){
                contractingRecType = newType.Id;
            }
        }
      
        
        Case parentCase1 = new Case();
        parentCase1.Plan_ID__c='IL1';
        parentCase1.RecordTypeId=groupOnboarding;
        parentCase1.subject='Testing';
        parentCase1.Description='Testing';
        parentCase1.status='New';           
        parentCase1.Email_Address_Submitter__c = 'test@hcsc.net';
        parentCase1.origin   ='Web-Onboarding';
        parentCase1.Completing_the_form_for__c='Group';
        parentCase1.accountId = newAccount.Id;
        //parentCase.ownerId = userList[1].id;
        insert parentCase1;
        
        Case entryCase1 = new Case();
        entryCase1.Plan_ID__c='IL1';
        entryCase1.Email_Address_Submitter__c = 'test@hcsc.net';
        entryCase1.origin   ='Web On-boarding';
        entryCase1.parentId=parentCase1.Id;
        entryCase1.status='New';
        entryCase1.subject='Test';
        entryCase1.Description='Test';
        entryCase1.Network_Name__c ='a-b,b-c,c-d'; 
        entryCase1.Completing_the_form_for__c='Group';        
        entryCase1.RecordTypeId=grpDataEntry; 
        entryCase1.accountId = newAccount.Id;
        
        insert entryCase1;
        
        Case counterCase1 = new Case();
        counterCase1.Plan_ID__c='IL1';
        counterCase1.Email_Address_Submitter__c = 'test@hcsc.net';
        counterCase1.origin   ='Web On-boarding';
        counterCase1.parentId=parentCase1.Id;
        counterCase1.status='New';
        counterCase1.subject='Test';
        counterCase1.Description='Test';
        counterCase1.Network_Name__c ='a-b,b-c,c-d'; 
        counterCase1.Completing_the_form_for__c='Group';        
        counterCase1.RecordTypeId=countergrpsignRecType; 
        counterCase1.accountId = newAccount.Id;
        
        insert counterCase1;
        
        Case contractCase1 = new Case();
        contractCase1.Plan_ID__c='IL1';
        contractCase1.Email_Address_Submitter__c = 'test@hcsc.net';
        contractCase1.origin   ='Web On-boarding';
        contractCase1.parentId=parentCase1.Id;
        contractCase1.status='New';
        contractCase1.subject='Test';
        contractCase1.Description='Test';
        contractCase1.Network_Name__c ='a-b,b-c,c-d'; 
        contractCase1.Completing_the_form_for__c='Group';        
        contractCase1.RecordTypeId=contractingRecType;
        contractCase1.accountId=newAccount.Id;
        //contractCase1.ownerId = userList[0].id;
        
        insert contractCase1;
        
        
        Case counterCase2 = new Case();
        counterCase2.Plan_ID__c='IL1';
        counterCase2.Email_Address_Submitter__c = 'test@hcsc.net';
        counterCase2.origin   ='Web On-boarding';
        counterCase2.parentId=parentCase1.Id;
        counterCase2.status='New';
        counterCase2.subject='Test';
        counterCase2.Description='Test';
        counterCase2.Network_Name__c ='a-b,b-c,c-d'; 
        counterCase2.Completing_the_form_for__c='Group';        
        counterCase2.RecordTypeId=masterentityRecType; 
        counterCase2.accountId = newAccount.Id;
        
        insert counterCase2;
        
        contractCase1.status = 'InProgress';
        update contractCase1;
        Provider_Networks__C newNetwork1 = new Provider_Networks__c();
        newNetwork1.Contracting_Case__c=counterCase2.Id;
        newNetwork1.Prov_ID__c='5324525';
        //newNetwork1.Cred_Status__c='Needs Credentialing';
        insert newNetwork1;        
       
      
        
       for(Integer count=0;count<1;count++)
        {
        Case newNetworking1 = new Case();
        newNetworking1.Plan_ID__c='IL1';
        newNetworking1.origin   ='Web On-boarding';
        newNetworking1.parentId=parentCase1.Id;
        newNetworking1.status='New';
        newNetworking1.subject='Test';
        newNetworking1.Description='Test';
        newNetworking1.Network_Name__c ='a-b,b-c,c-d'; 
        newNetworking1.Completing_the_form_for__c='Individual';        
        newNetworking1.RecordTypeId=indvCredentialing; 
        listOfCases1.add(newNetworking1); 
        }       
        insert listOfCases1;       
        
        Test.stopTest();
        Case newCase1=[Select status from Case Where RecordTypeId=:indvCredentialing and ParentId=:parentCase1.Id];
        newCase1.status='Cred Approved';
        update newCase1;
        
        List<case> caseList1 = [Select status from Case Where RecordTypeId=:indvNetworking and ParentId=:parentCase1.Id];
        if(!caseList1.isEmpty()){
            Case newNetworkCase1 = new Case(Id=caseList1[0].Id) ;
            newNetworkCase1.status='Closed Processed';
            newNetworkCase1.Completing_the_form_for__c='Individual';
            newNetworkCase1.Network_name__c = 'Network1;Network2;Network3';
            newNetworkCase1.External_Comments__c = 'External Comments';
            newNetworkCase1.Contract_PFIN__c='test';
            newNetworkCase1.accountId=newAccount.Id;
            update newNetworkCase1;  
        }

       
        
      
      
    }
    
         
   
  
}