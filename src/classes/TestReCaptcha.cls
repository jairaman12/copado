@isTest
private class TestReCaptcha 
{
	  
	/* https://github.com/scolladon/Apex_reCaptcha/blob/master/classes/Test_reCaptcha.cls */
	
	@testSetup static void init() 
	{
    	List<Web2Case__c> w2cList   =   new List<Web2Case__c>();
        Web2Case__c w2c         =   new Web2Case__c();
        w2c.Name                =   'CaptchaPrivateKey';
        w2c.CaseObjectValues__c =   '6LfkKxkUAAAAAGDfThUtKMPgV-T9qJAsUj9losTx'; 
        w2cList.add( w2c );
        
        Web2Case__c w2c1            =   new Web2Case__c();
        w2c1.Name                   =   'CaptchaPublicKey';
        w2c1.CaseObjectValues__c    =   '6LfkKxkUAAAAAPNtG_UB6LGrxqLKEdWiuVAXnDUi'; 
        w2cList.add( w2c1 );
        
        Web2Case__c w2c2            =   new Web2Case__c();
        w2c2.Name                   =   'isCaptchaEnabled';
        w2c2.CaseObjectValues__c    =   'true'; 
        w2cList.add( w2c2 );
        
        insert w2cList;
  	}
	
	
     @isTest static void testCaptcha() 
     {	
     	
     	Test.startTest();
         
     	reCaptcha rc			=	new reCaptcha();
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseGenerator() );
     	PageReference pgRef 	= 	Page.ILDemoGraphUpdate;
        System.Test.setCurrentPage( pgRef );
        ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','Salesforce');
        String remoteHost 		= rc.remoteHost;
		rc.reset();
        rc.verify(); 
     	Test.stopTest();
     }
    
    
     @isTest static void testCaptcha_1() 
     {	
     	
     	Test.startTest();
     	reCaptcha rc			=	new reCaptcha();
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseGenerator() );
     	PageReference pgRef 	= 	Page.ILDemoGraphUpdate;
        System.Test.setCurrentPage( pgRef );
        ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','Salesforce');
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','response');
        String remoteHost 		= rc.remoteHost;
         try{ 
        rc.verify();
         } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
		rc.reset();
         
     	Test.stopTest();
     }
     
     
   
}