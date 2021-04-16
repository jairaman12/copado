/**
* Serves as test class for RoutingButtonsController.
* <p /><p />
* @author Josh McGhee
*/
@isTest
public class RoutingButtonsControllerTest {
    
    //Private constants
    private static final Integer INT_CONTRACTING = 0;
    private static final Integer INT_DATA_ENTRY = 1;
    private static final Integer INT_ESCALATE = 2;
    private static final Integer INT_TEST_CS1 = 3;
    private static final Integer INT_TEST_CS2 = 4;
    
    /**
	* Creates test data
	*/
    @testSetup 
    static void createTestData() {
        
        TestDataFactory objTdf = new TestDataFactory();
        List<DefaultQueueSettings__c> lstDefaultQueueSettings = TestDataFactory.insertDefaultQueueSettings();
        List<GlobalSettings__c> lstGlobalSettings = objTdf.InsertGlobalsetting();
        TestDataFactory.CreateRecordTypeSettings();
    }
    
    /**
	* Tests getContracting, getDataEntry, and getEscalateCaseOwnerUpdate, and asserts that showEscalate, 
	* showDataEntry, and showContracting all return the correct values given certain variables.
	*/
    @isTest
    static void routingButtons_Test1() {
        
        Id idRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PDM').getRecordTypeId();
        List<User> lstSystemAdministrator = TestCaseUtil.createUser('System Administrator', 'Illinois Supervisor', 1);
        
        Test.startTest();
        System.runAs(lstSystemAdministrator[0]) {
            
            //insert new parent and child cases
            Case objParentCase = TestCaseUtil.CreateCase();
            Case objChildCase = TestCaseUtil.CreateCase();
            Case objChildPDMCase = TestCaseUtil.CreateCase();
            objParentCase.Email_Address_Submitter__c 	=	'test@test.com';
            objParentCase.Govt_Programs__c 				=	true;
            objParentCase.Origin						=	'Web-Demographics';
            objParentCase.Plan_Id__c					=	'IL1';
            insert objParentCase;
            
            objChildCase.ParentId = objParentCase.id;        
            objChildCase.Email_Address_Submitter__c 	= 	'test3@test.com';
            objChildCase.Govt_Programs__c 				= 	true;
            objParentCase.Origin						=	'Web-Demographics';
            objParentCase.Plan_Id__c					=	'IL1';
            insert objChildCase; 
            
            objChildPDMCase.ParentId = objParentCase.id;        
            objChildPDMCase.Email_Address_Submitter__c 	= 	'test3@test.com';
            objChildPDMCase.Govt_Programs__c 			= 	true;
            objChildPDMCase.RecordTypeId				=	idRecordType;
            objParentCase.Origin						=	'Web-Demographics';
            objParentCase.Plan_Id__c					=	'IL1';
            insert objChildPDMCase;
            
            RoutingButtonsController.getContracting(objChildCase.Id);
            RoutingButtonsController.getDataEntry(objChildCase.Id);
            RoutingButtonsController.getEscalateCaseOwnerUpdate(objChildCase.Id);
            
            System.assert(RoutingButtonsController.showEscalate(objChildCase.Id) == false);
            System.assert(RoutingButtonsController.showEscalate(objChildPDMCase.Id) == true);
            System.assert(RoutingButtonsController.showDataEntry(objChildCase.Id) == true);
            System.assert(RoutingButtonsController.showDataEntry(objChildPDMCase.Id) == false);
            System.assert(RoutingButtonsController.showContracting(objChildCase.Id) == true);
            System.assert(RoutingButtonsController.showContracting(objChildPDMCase.Id) == true);
        }
        Test.stopTest();
    } 
    
    /**
	* Asserts that showEscalate and showContracting return 'false' without the correct profile.
	*/
    @isTest
    static void routingButtons_Test2() {
        
        
        Id idRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PDM').getRecordTypeId();
        List<User> lstEnterpriseProfile = TestCaseUtil.createUser('Enterprise Profile', 'Illinois Supervisor', 1);
        
        Test.startTest();
        System.runAs(lstEnterpriseProfile[0]){
            
            //insert new parent and child cases
            Case objParentCase = TestCaseUtil.CreateCase();
            Case objChildPDMCase = TestCaseUtil.CreateCase();
            
            objParentCase.Email_Address_Submitter__c 	=	'test@test.com';
            objParentCase.Govt_Programs__c 				=	true;
            objParentCase.Origin						=	'Web-Demographics';
            objParentCase.Plan_Id__c					=	'IL1';
            insert objParentCase;
            
            objChildPDMCase.ParentId = objParentCase.id;        
            objChildPDMCase.Email_Address_Submitter__c 	= 	'test3@test.com';
            objChildPDMCase.Govt_Programs__c 			= 	true;
            objChildPDMCase.RecordTypeId				=	idRecordType;
            objParentCase.Origin						=	'Web-Demographics';
            objParentCase.Plan_Id__c					=	'IL1';
            insert objChildPDMCase;
            
            System.assert(RoutingButtonsController.showEscalate(objChildPDMCase.Id) == false);
            System.assert(RoutingButtonsController.showContracting(objChildPDMCase.Id) == false);
        }
        Test.stopTest();
    }
    
    /**
	* Tests getContracting, getDataEntry, and getEscalateCaseOwnerUpdate with different queue types.
	*/
    @isTest
    static void routingButtons_Test3() {
        
        //insert new parent and child cases
        Case objParentCase = TestCaseUtil.CreateCase();
        List<Case> lstChildCase = new List<Case>();
        
        List<Group> lstGroupContracting =[Select DeveloperName,Name,Id from Group where Type='Queue' and DeveloperName='OMNI_IL_Contracting_Queue'];
        List<Group> lstGroupDataEntry =[Select DeveloperName,Name,Id from Group where Type='Queue' and DeveloperName IN ('OMNI_IL_Data_Entry_Queue')];
        List<Group> lstGroupEscalate =[Select DeveloperName,Name,Id from Group where Type='Queue' and DeveloperName='Illinois_Queue'];
        
        objParentCase.Email_Address_Submitter__c 	=	'test@test.com';
        objParentCase.Govt_Programs__c 				=	true;
        objParentCase.Origin						=	'Web-Demographics';
        objParentCase.Plan_Id__c					=	'IL1';
        insert objParentCase;
        
        for(Integer intCounter=0; intCounter<5; intCounter++) {
            lstChildCase.add(TestCaseUtil.CreateCase());
            lstChildCase[intCounter].ParentId = objParentCase.id;        
            lstChildCase[intCounter].Email_Address_Submitter__c = 'test3@test.com';
            lstChildCase[intCounter].Govt_Programs__c = true;
            lstChildCase[intCounter].Origin						=	'Web-Demographics';
            lstChildCase[intCounter].Plan_Id__c					=	'IL1';
            
        }
        lstChildCase[INT_CONTRACTING].OwnerId = lstGroupContracting[0].Id;
        lstChildCase[INT_DATA_ENTRY].OwnerId = lstGroupDataEntry[0].Id;
        lstChildCase[INT_ESCALATE].OwnerId = lstGroupEscalate[0].Id;
        
        insert lstChildCase;
                
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            
            Case cs = new Case(Id=lstChildCase[INT_CONTRACTING].Id);
            cs.Status	=	'Closed Processed';
            update cs;
            RoutingButtonsController.getContracting(lstChildCase[INT_CONTRACTING].Id);
            
            cs = new Case(Id=lstChildCase[INT_DATA_ENTRY].Id);
            cs.Status	=	'Closed Processed';
            update cs;
            RoutingButtonsController.getDataEntry(lstChildCase[INT_DATA_ENTRY].Id);
            
            cs = new Case(Id=lstChildCase[INT_ESCALATE].Id);
            cs.Status	=	'Closed Processed';
            update cs;
            RoutingButtonsController.getEscalateCaseOwnerUpdate(lstChildCase[INT_ESCALATE].Id);
            
            
            Case cs1 	=	new Case(Id=lstChildCase[INT_TEST_CS1].Id);
            cs1.OwnerId	=	lstGroupContracting[0].Id;
            update cs1;
            RoutingButtonsController.getContracting(cs1.Id);
            
            cs1.OwnerId	=	lstGroupDataEntry[0].Id;
            update cs1;
            RoutingButtonsController.getDataEntry(cs1.Id);
            
            cs1.OwnerId	= lstGroupEscalate[0].Id;
            update cs1;
            RoutingButtonsController.getEscalateCaseOwnerUpdate(cs1.Id);
            
            
            Case cs2 	=	new Case(Id=lstChildCase[INT_TEST_CS2].Id);
            cs2.Status	=	'Prod Verification';
            update cs2;
            RoutingButtonsController.getContracting(cs2.Id); 
        } 
        Test.stopTest();
    }
}