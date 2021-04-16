/*
* This is the test class to covor the code coverage for the class EscalateButtonController.apxc 
* Developer	: Sreekanth Kalluru
* Date		: 02/03/2019
*/
@isTest
public class EscalateButtonControllerTest 
{
	@testSetup static void createTestData() 
    {
        List<DefaultQueueSettings__c> defaultQueueSettingsList = TestDataFactory.insertDefaultQueueSettings();
    	TestDataFactory tdf = new TestDataFactory();
        List<GlobalSettings__c> glbalsettingsList = tdf.InsertGlobalsetting();
        TestDataFactory.CreateRecordTypeSettings();
    }
	
    static testmethod void escalateButton_Test1()
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
             EscalateButtonController.getEscalateCaseOwnerUpdate(childCase.Id);
         }
         Test.stopTest();
    } 
    
    static testmethod void escalateButton_Test2()
    {
         //insert new parent and child cases
        List<Group> grpList =[Select DeveloperName,Name,Id from Group where Type='Queue' and DeveloperName='Illinois_Queue'];
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
        childCase.Origin						=	'Web-Demographics';
        childCase.Plan_Id__C					=	'IL1';
        insert childCase; 
      	
        
        Case childCase1 = TestCaseUtil.CreateCase();   
        childCase1.ParentId = parentCase.id;        
        childCase1.Email_Address_Submitter__c 	= 'test3@test.com';
        childCase1.Govt_Programs__c = true;
        childCase1.Origin						=	'Web-Demographics';
        childCase1.Plan_Id__C					=	'IL1';
        insert childCase1;  
        
         Test.startTest();
         System.runAs(new User(Id = UserInfo.getUserId()))
         {
             Case cs = new Case(Id=childCase.Id);
             cs.Status	=	'Closed Processed';
             update cs;
             
             EscalateButtonController.getEscalateCaseOwnerUpdate(childCase.Id);
             
             Case cs1 = new Case(Id=childCase1.Id);
             cs1.ownerId	=	grpList[0].Id;
             update cs1;
             
             EscalateButtonController.getEscalateCaseOwnerUpdate(childCase.Id);
         } 
        Test.stopTest();
    } 
}