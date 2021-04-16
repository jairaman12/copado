@isTest
public class TestCaseCommentTriggerHandler{
    
    static user u;
    
    @testSetup static void prepareData() {
        
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
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
        
        CaseProfile__c cp    =    new CaseProfile__c();
        cp.Name              =    'Supervisor';
        cp.ProfileName__c    =    'Supervisor';
        insert cp;
        
        CaseLockStatus__c cls     =    new CaseLockStatus__c();
        cls.Status__c             =    'Prod Verification';
        cls.Name                  =    'Prod Verification';
        insert cls;
    }
	 
    public static testMethod void test1_CaseCommentTriggerHandler() {      
        
        Account acc = new Account();
        acc.RecordTypeId = [SELECT Id, DeveloperName From RecordType WHERE RecordType.DeveloperName = 'Entity_Account'].Id;
        acc.Name = 'Test Entity';
        acc.CM_Corporate_Entity_Code__c = 'IL1';
        insert acc;
        
        Case  mCase = TestCaseUtil.CreateCase();
        mCase.Status = 'Prod Verification';
        mCase.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE RecordType.DeveloperName = 'Email' and sobjectType='Case' limit 1].Id;
        mCase.Origin = 'Ancillary Gov Expansion';
        mCase.Case_Entity__c = acc.Id;
        mCase.AccountId = null;
        insert mCase;
        
        User u = [SELECT Id, Name FROM User WHERE UserRole.DeveloperName = 'Illinois_Supervisor' AND Profile.Name = 'Supervisor' AND isActive = true LIMIT 1];
        
        Test.startTest();
        
            System.runAs(u) {
                
                CaseComment cc = new CaseComment();
                cc.CommentBody = 'test';
                cc.ParentId = mCase.Id;
            
                insert cc;
                update cc;
                delete cc;
            }
        
        Test.stopTest();

    }
}