@isTest
public class TestCreateChildCase {
    
    @testSetup static void prepareData() {
        GlobalSettings__c gs			=	 new GlobalSettings__c();
        gs.name 						=	'PFFileRecieved';
        gs.PFFileRecieved__c			=	 false;
        gs.CRM_Case_Status_fields__c 	= 	'New,In Progress,Waiting for Internal Response,Waiting for External Response,Closed';
        gs.Record_Type_Names__c			=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.Acceptable_Plan_Ids__c		= 	'IL1,MT1,NM1,OK1,TX1';
        gs.Physician_record_id__c		= 	[SELECT Id, Name, SObjectType FROM RecordType WHERE SObjectType='Account' AND Name = 'Physician'].Id;
        gs.Entity_record_type_id__c		= 	[SELECT Id, Name, SObjectType FROM RecordType WHERE SObjectType='Account' AND Name = 'Entity Account'].Id;
        gs.CRM_Master_Record_Type_Id__c	= 	[SELECT Id, Name, SObjectType FROM RecordType WHERE SObjectType='Case' AND Name like 'Master CRM%'].Id;
        gs.CRM_Case_record_Type_Id__c	= 	[SELECT Id, Name, SObjectType FROM RecordType WHERE SObjectType='Case' AND Name = 'CRM'].Id;
        gs.Integration_Profile_Id__c	= 	[SELECT Id, Name FROM Profile WHERE Name = 'Integration'].Id;
        gs.Fake_Email__c				= 	'fakeemail@bcbsil.com';
        gs.MCC_Case_Origin__c			= 	'Mass Case Creation';
        insert gs;
    }
    
    static testMethod void testCases() {    
        
        List<case> testChild = new List<case>();  
        
        Case  mCase = TestCaseUtil.CreateCase();
        
        //insert mCase;
        
        testChild.add(mCase);
        
        Test.startTest();
        
        	CreateChildCase.createChildCaseMethod(testChild);
        
        Test.stopTest();
        
        //System.assertEquals(0,[SELECT count() FROM Case]);
        
    }  
}