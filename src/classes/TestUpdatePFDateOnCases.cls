@isTest
public class TestUpdatePFDateOnCases {
    
     @testSetup static void prepareData() {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
    }
    
    static testMethod void TestinBoundEmail()
    {
        //Create a parent case.
        Case p = new Case();
        p.Status='New';
        p.subject='Parent'; 
        p.Billing_NPI_Number__c = '1234567890';        
        p.Tax_ID_Number__c = '123456789';
        p.Plan_Id__c = 'IL1';
        insert p;           
                
        //Create a child case
        Case c = new Case();
        c.Status='New';
        c.subject='Child'; 
        c.Billing_NPI_Number__c = '1234567890';
        c.Rendering_NPI__c = '1234567895';
        c.Provider_Finder_Close_Date__c = null;
        c.ParentId = p.Id;
        c.Plan_Id__c = 'IL1';
        c.Status='Closed Processed'; 
        c.Email_Address_Submitter__c = 'test@test.com';
        insert c;           
        
        Case c2 = new Case();
        c2.Status='New';
        c2.subject='Child'; 
        c2.Billing_NPI_Number__c = '1234567899';
        c2.Rendering_NPI__c = '1234567899';
        c2.Provider_Finder_Close_Date__c = null;
        c2.ParentId = p.Id;
        c2.Plan_Id__c = 'IL1';
        c2.Status='Closed Processed'; 
        c2.Email_Address_Submitter__c = 'test@test.com';
        insert c2;
        
        Case c3 = new Case();
        c3.Status='New';
        c3.subject='Child'; 
        c3.Billing_NPI_Number__c = '1234567888';
        c3.Provider_Finder_Close_Date__c = null;
        c3.ParentId = p.Id;
        c3.Plan_Id__c = 'IL1';
        c3.Status='Closed Processed'; 
        c3.Email_Address_Submitter__c = 'test@test.com';
        insert c3;
        
        Test.startTest();
        
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = 'Update Cases';
        email.fromAddress = 'xxx@bcbsxx.com';
        email.plainTextBody = 'email body';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        string str = 'NPI,Date Available\n1234567890,' + String.valueof(Date.Today()) + '\n1234567895,' + String.valueof(Date.Today()) + '\n1234567888,' + String.valueof(Date.Today()) + '\n1234567899,2017-07-01\n1234567891,2017-07-01\n12345,2017-07-01\n1,2017-a-01';
        system.debug('Str:' + str);
        attachment.body = blob.valueOf(str);
        attachment.fileName = 'textfileone.csv';
        // attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };            
        // call the email service class and test it with the data in the testMethod
        UpdatePFDateOnCases  testInbound=new UpdatePFDateOnCases();
        testInbound.handleInboundEmail(email, env); 
        
        Test.stopTest();
        system.debug('c:' + c);
        case tc = [select Provider_Finder_Close_Date__c from case where id =:c.Id];
        system.assert(tc.Provider_Finder_Close_Date__c == Date.Today(), 'PF Date is not as expected on child');         
    }
    
    static testMethod void TestinBoundEmailWithBadHeaders()
    {               
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = 'Update Cases';
        email.fromAddress = 'xxx@bcbsxx.com';
        email.plainTextBody = 'email body';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('NP,Data Available\n1234567890,2017-07-01\n1234567891,2017-07-01\n12345,2017-07-01\n12345,abcd-0a-01');
        attachment.fileName = 'textfileone.csv';
        // attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };            
            
        // call the email service class and test it with the data in the testMethod
        UpdatePFDateOnCases  testInbound=new UpdatePFDateOnCases();
        testInbound.handleInboundEmail(email, env);   
    }
    
    static testMethod void TestinBoundEmailWithNoAttachment()
    {               
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = 'Update Cases';
        email.fromAddress = 'xxx@bcbsxx.com';
        email.plainTextBody = 'email body';      
            
        // call the email service class and test it with the data in the testMethod
        UpdatePFDateOnCases  testInbound=new UpdatePFDateOnCases();
        testInbound.handleInboundEmail(email, env);   
    }
    
    static testMethod void TestinBoundEmailWithBadData()
    {               
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = 'Update Cases';
        email.fromAddress = 'xxx@bcbsxx.com';
        email.plainTextBody = 'email body';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('NPI,Date Available\n\n,\n1111111111,\n1234567991,a019-07-01\n1111111111,20171020\n1234567991,2019-070-1\n1234567999,2015-07-01\n1234567890,2017-07-01\n1234567891,2017-07-01\n12345,2017-07-01\n12345,abcd-0a-01');
        attachment.fileName = 'textfileone.csv';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };            
            
        // call the email service class and test it with the data in the testMethod
        UpdatePFDateOnCases  testInbound=new UpdatePFDateOnCases();
        testInbound.handleInboundEmail(email, env);        
    }
    
    static testMethod void TestinBoundEmailWithBadFormat()
    {               
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = 'Update Cases';
        email.fromAddress = 'xxx@bcbsxx.com';
        email.plainTextBody = 'email body';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('NPI,Date Available\n\n,\n1111111111,\n,2017-10-20\n1234567991,a019-07-01\n1111111111,20171020\n1234567991,2019-070-1\n1234567999,2015-07-01\n1234567890,2017-07-01\n1234567891,2017-07-01\n12345,2017-07-01\n12345,abcd-0a-01');
        attachment.fileName = 'textfileone.xlsx';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };            
            
        // call the email service class and test it with the data in the testMethod
        UpdatePFDateOnCases  testInbound=new UpdatePFDateOnCases();
        testInbound.handleInboundEmail(email, env);        
    }
    
}