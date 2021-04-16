@isTest
public class CreateNetworkChildCls_Test
{
    public static testmethod void insertNetworkChildCase()
    {
        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        List<Case> listOfCases = new List<Case>();
        Id counterTypeId,onboardingTypeId;       
        counterTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Counter_Sign').getRecordTypeId();
        onboardingTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding').getRecordTypeId();
        Case parentCase = new Case();
        parentCase.Plan_ID__c='IL1';
        parentCase.RecordTypeId=onboardingTypeId;
        parentCase.subject='Testing';
        parentCase.Description='Testing';
        parentCase.status='New';           
        parentCase.Email_Address_Submitter__c = 'test@hcsc.net';
        parentCase.origin   ='Web';
        insert parentCase;

        for(Integer count=0;count<5;count++)
        {
            Case counterCase = new Case();
            counterCase.Plan_ID__c='IL1';
            counterCase.RecordTypeId=counterTypeId;           
            counterCase.Email_Address_Submitter__c = 'test@hcsc.net';
            counterCase.origin   ='Web';
            counterCase.parentId=parentCase.Id;
            counterCase.status='Closed Processed';
            counterCase.subject='Test'+count;
            counterCase.Description='Test'+count;
            counterCase.Network_Name__c ='a-b,b-c,c-d';
            listOfCases.add(counterCase);    
        }
        insert listOfCases;
        
        CreateNetworkChildCls.updateEmailCaseOwner(listOfCases);
    }
}