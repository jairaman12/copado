@isTest
Private class TestAttachment 
{
    @testSetup static void prepareData() 
    {
        GlobalSettings__c gs			=	new GlobalSettings__c();
        gs.name 						=	'PFFileRecieved';
        gs.PFFileRecieved__c			=	false;
        gs.Record_Type_Names__c			=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Attachment_Trigger_Switch__c = 	false;
        insert gs;
        
        CaseProfile__c cp    =    new CaseProfile__c();
        cp.Name              =    'System Administrator';
        cp.ProfileName__c    =    'System Administrator';
        insert cp;
        
        CaseLockStatus__c cls     =    new CaseLockStatus__c();
        cls.Status__c             =    'Prod Verification';
        cls.Name                  =    'Prod Verification';
        insert cls;
        
        CaseLockStatus__c cls1     =    new CaseLockStatus__c();
        cls1.Status__c             =    'Closed Processed';
        cls1.Name                  =    'Closed Processed';
        insert cls1;
        
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
        
        /*
        List<RoleAndPlanId_Settings__c> lst = new List<RoleAndPlanId_Settings__c>();
        
        RoleAndPlanId_Settings__c rp    =   new RoleAndPlanId_Settings__c( Name='Illinois_Supervisor',PlanId__c='IL1',Role_Id__c='00E41000000bXVs' );
        lst.add(rp);
        RoleAndPlanId_Settings__c rp1   =   new RoleAndPlanId_Settings__c( Name='Montana_Supervisor',PlanId__c='MT1',Role_Id__c='00E41000000bXVt' );
        lst.add(rp1);
        RoleAndPlanId_Settings__c rp2   =   new RoleAndPlanId_Settings__c( Name='New_Mexico_Supervisor',PlanId__c='NM1',Role_Id__c='00E41000000bXVu' );
        lst.add(rp2);
        RoleAndPlanId_Settings__c rp3   =   new RoleAndPlanId_Settings__c( Name='Oklahoma_Supervisor',PlanId__c='OK1',Role_Id__c='00E41000000bXVv' );
        lst.add(rp3);
        RoleAndPlanId_Settings__c rp4   =   new RoleAndPlanId_Settings__c( Name='Texas_Supervisor',PlanId__c='TX1',Role_Id__c='00E41000000bXW1' );
        lst.add(rp4);
        
        insert lst;
        */
    }
    
   public static testMethod void createAtt()
    {
        Account acc = new Account();
        acc.RecordTypeId = [SELECT Id, DeveloperName From RecordTYpe WHERE IsPersonType = TRUE AND RecordType.DeveloperName = 'Rolodex'].Id;
        acc.LastName = 'LastNameGoesHere';
        acc.CM_Corporate_Entity_Code__c = 'IL1';
        acc.NPI__c = '1234567890';
        acc.Phone = '9185512503';
        acc.Tax_Id__c = '123456789';
        acc.PersonEmail = 'testemail@email.com';
        insert acc;
        
        Case  mCase = TestCaseUtil.CreateCase();
        mCase.Status = 'Prod Verification';
        mCase.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE RecordType.DeveloperName = 'Email' and sobjectType='Case' limit 1].Id;
        mCase.Origin = 'Ancillary Gov Expansion';
        mCase.Plan_ID__c	=	'IL1';
        insert mCase;
        
        Attachment attach = new Attachment(); 
        attach.Name = 'Unit Test Attachment'; 
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body'); 
        attach.body = bodyBlob; attach.parentId=mCase.id;
        
        Test.startTest();
        
            insert attach;
            
            attach.Name = 'Unit Test 2';
            
            update attach;
            
            delete attach;
        
        Test.stopTest();
    }
}