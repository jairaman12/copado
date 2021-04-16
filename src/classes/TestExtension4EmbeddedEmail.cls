@isTest
public class TestExtension4EmbeddedEmail {
    
    @testSetup static void prepareData() {
	    GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
    }
    
    public static testMethod void test_Extension4EmbeddedEmail(){
     	PageReference pgRef 	= 	Page.EmbeddedEmail;
        System.Test.setCurrentPage( pgRef );
       insert
      ( 
          	new EmailToCaseRoutingAddresses__c
        	(
            	name='Ancillary Networks', RoutingName__c = 'test@test.com'
            )
        );        
        Case testCase = TestCaseUtil.CreateCase();   
        testCase.Origin = 'Ancillary Networks';
        testCase.Fax_Administrative_New__c = '9999990999';
        testCase.Fax_Billing_New__c = '9999990999';
        testCase.Fax_Credential_New__c = '9999990999';
        testCase.Fax_Physical_New__c = '9999990999';
        

        
        insert testCase;
        ApexPages.currentPage().getParameters().put('id', testCase.id); 
		ApexPages.StandardController sc = new ApexPages.StandardController(testCase);                                                   
         // start the test execution context
        Test.startTest();
        Extension4EmbeddedEmail e4ee = new Extension4EmbeddedEmail(sc);                
        String eh = e4ee.getFromAddress_hold();
       // System.assert(eh.contains('test@test.com'), 'Hold email address not found.');
        String e = e4ee.getFromAddress();
        //System.assert(e.contains('test@test.com'), 'Actual email address not found.'); 
        // stop the test
        Test.stopTest();

    }
  
}