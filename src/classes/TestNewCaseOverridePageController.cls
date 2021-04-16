@isTest
public class TestNewCaseOverridePageController {

    static testMethod void testNewCaseOverride() {
        
        Case controlCase = new Case();
        PageReference pageRef = Page.NewCaseOverridePage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc 			= new ApexPages.StandardController(controlCase);
        NewCaseOverridePageController controller 	= new NewCaseOverridePageController(sc);
        
        Test.startTest();
        
            controller.newCase.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Email' LIMIT 1].Id;
            
            controller.createCase();
            
            controller.cancel();
        
        Test.stopTest();
    }
    
}