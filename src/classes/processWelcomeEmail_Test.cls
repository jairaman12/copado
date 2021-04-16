/*
* This is the test class of processWelcomeEmail.apxc
* Developer: Laxman Vattam
* Date: 04/15/2019
*/
@isTest
public class processWelcomeEmail_Test {    
    @testSetup static void createTestData() {
        /*
        Folder f = new Folder();
        f = [select id from folder where DeveloperName = 'Provider_PIER_Network'];
        EmailTemplate e = new EmailTemplate (developerName = 'WelcomeEmailTemplateIL', Body = 'refid  ProviderName NetworkNameNetworkEffectiveDate', FolderId = f.Id, TemplateType= 'Text', Name = 'test'); 
        insert e;        
		*/
        TestDataFactory t = new TestDataFactory();
        TestDataFactory.CreateRecordTypeSettings();
        TestDataFactory.CreateEmailSettings();
        t.InsertGlobalsetting();
        
    }
    
     static testmethod void welcomeEmailTest() {
         list<case> cases = new list<case>();
         cases =  TestDataFactory.NetworkCaseCreation(null,'IL1','grp');  
         cases.addall(TestDataFactory.NetworkCaseCreation(null,'TX1','grp'));
         cases.addall(TestDataFactory.NetworkCaseCreation(null,'MT1','grp'));
         cases.addall(TestDataFactory.NetworkCaseCreation(null,'NM1','grp'));
         //cases.addall(TestDataFactory.NetworkCaseCreation(null,'OK1','grp'));
         Test.startTest();
         	processWelcomeEmail.welcomeEmailCreation(cases);
         Test.stopTest();
     }
    
    static testmethod void welcomeEmailTest2() {
         TestDataFactory.NetworkCaseCreation(null,'IL1','ind');
         list<case> cases = new list<case>();
         cases.addall(TestDataFactory.NetworkCaseCreation(null,'IL1','ind'));
         Test.startTest();
         	processWelcomeEmail.welcomeEmailCreation(cases);
         Test.stopTest();
     }
    
}