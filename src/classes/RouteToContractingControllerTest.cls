/*
* This is the test class to covor the code coverage for the class RouteToContractingController.apxc 
* Developer	: Sreekanth Kalluru
* Date		: 02/03/2019
*/
@isTest
public class RouteToContractingControllerTest 
{
	@testSetup static void createTestData() 
    {
        List<DefaultQueueSettings__c> defaultQueueSettingsList = TestDataFactory.insertDefaultQueueSettings();
    	TestDataFactory tdf = new TestDataFactory();
        List<GlobalSettings__c> glbalsettingsList = tdf.InsertGlobalsetting();
        TestDataFactory.CreateRecordTypeSettings();
    }
    
    static testmethod void routeToContractingButton_Test1()
    {
        //insert new parent and child cases
        Case parentCase = TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c 	=	'test@test.com';
        parentCase.Govt_Programs__c 			=	true;
        parentCase.Origin						=	'Web-Demographics';
        ParentCase.Plan_Id__C					=	'IL1';
        insert parentCase;
        
         Case childCase = TestCaseUtil.CreateCase();   
        childCase.ParentId = parentCase.id;        
        childCase.Email_Address_Submitter__c = 'test3@test.com';
        childCase.Govt_Programs__c = true;
        parentCase.Origin						=	'Web-Demographics';
        ParentCase.Plan_Id__C					=	'IL1';
        insert childCase; 
        
         Test.startTest();
         System.runAs(new User(Id = UserInfo.getUserId()))
         {
             RouteToContractingController.getContractingCaseOwnerUpdate(childCase.Id);
         }
         Test.stopTest();
    } 
    
    static testmethod void routeToContractingButton_Test2()
    {
         //insert new parent and child cases
        List<Group> grpList =[Select DeveloperName,Name,Id from Group where Type='Queue' and DeveloperName='OMNI_IL_Contracting_Queue'];
        Case parentCase = TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c 	=	'test@test.com';
        parentCase.Govt_Programs__c 			=	true;
        parentCase.Origin						=	'Web-Demographics';
        ParentCase.Plan_Id__C					=	'IL1';
        insert parentCase;
        
        Case childCase1 = TestCaseUtil.CreateCase();   
        childCase1.ParentId = parentCase.id;        
        childCase1.Email_Address_Submitter__c 	= 'test3@test.com';
        childCase1.Govt_Programs__c = true;
        childCase1.Origin						=	'Web-Demographics';
        childCase1.Plan_Id__C					=	'IL1';
        insert childCase1;  
         
         Case childCase = TestCaseUtil.CreateCase();   
        childCase.ParentId = parentCase.id;        
        childCase.Email_Address_Submitter__c = 'test3@test.com';
        childCase.Govt_Programs__c = true;
        childCase.Origin						=	'Web-Demographics';
        childCase.Plan_Id__C					=	'IL1';
        childCase.OwnerId						=	grpList[0].Id;
        insert childCase; 
        
        Case childCase2 = TestCaseUtil.CreateCase();   
        childCase2.ParentId = parentCase.id;        
        childCase2.Email_Address_Submitter__c 	= 'test3@test.com';
        childCase2.Govt_Programs__c = true;
        childCase2.Origin						=	'Web-Demographics';
        childCase2.Plan_Id__C					=	'IL1';
        insert childCase2;  
        
         Test.startTest();
         System.runAs(new User(Id = UserInfo.getUserId()))
         {
             Case cs = new Case(Id=childCase.Id);
             cs.Status	=	'Closed Processed';
             update cs;
             
             RouteToContractingController.getContractingCaseOwnerUpdate(childCase.Id);
             
             Case cs1 	=	new Case(Id=childCase1.Id);
            cs1.OwnerId	=	grpList[0].Id;
            update cs1;
            RouteToContractingController.getContractingCaseOwnerUpdate(cs1.Id); 
             
             Case cs2 	=	new Case(Id=childCase2.Id);
            cs2.Status	=	'Prod Verification';
            update cs2;
            RouteToContractingController.getContractingCaseOwnerUpdate(cs2.Id); 
         } 
        Test.stopTest();
    } 

}