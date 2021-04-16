/*
* This is the test class to covor the code coverage for the class CredentialingReport.apxc  
* Developer : Sreekanth Kalluru
* Date      : 02/03/2019
*/
@isTest
public class CredentialingReport_Test {
    
    @testSetup
    public static void prepareData() 
    {
        
        TestDataFactory tdf             =   new TestDataFactory();
        List<GlobalSettings__c> glbalsettingsList   =   tdf.InsertGlobalsetting();
        
       
        
        ReportConfig__mdt rc            =   new ReportConfig__mdt();
        rc                              =   [select MasterLabel,body__c,CaseStatusValues__c,FileName__c,HeaderListing__c,
                                             MainQuery__c,MainQuery2__c,RecipientEmailList__c,Record_Types__c,Record_types2__c,
                                             EmailSubject__c,Failures_Report_Recipents__c from ReportConfig__mdt limit 1];
       
        
        Id rectypefornet                =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Credentialing').getRecordTypeId();
        Id groupCredentialingCaserecId  =   Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
        Id individualCredCase           =   Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        
        List<Provider_Networks__c> pn   =   new List<Provider_Networks__c>();
        pn                              =   TestDataFactory.ProviderNetworkCreation(1,'IL1',recTypefornet);
        List<case> credCaseGroup        =   new list<case>();
        credCaseGroup                   =   TestDataFactory.CredCaseCreation(pn,'IL1','Ind',groupCredentialingCaserecId);
        
        List<Provider_Networks__c> pn1  =   new List<Provider_Networks__c>();
        pn1                             =   TestDataFactory.ProviderNetworkCreation(1,'IL1',recTypefornet);
        List<Case> credCaseIndividual   =   new List<Case>();
        credCaseIndividual              =   TestDataFactory.CredCaseCreation(pn1,'IL1','Ind',individualCredCase);
       
    }
    
    
     public static testMethod void test_CredentialingReport()
     {

        // start the test execution context
        Test.startTest();        
            CredentialingReport cr = new CredentialingReport();
            cr.initFromMetaData('ReportConfig__mdt.Credentialing_Report');       
            try{
                cr.callReport();
            } catch(Exception e) {
                System.debug('The following exception occured when sending credentialing report email: ' + e);
            }        
            // stop the test
        Test.stopTest();        
    }    
}