@isTest
public class Utils_Test {
    
    static testmethod void hasRecordChanged_test() {
        
        TestDataFactory tdf = new TestDataFactory();
        
        TestDataFactory.prepareData();
        
        Id caseRecordId =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId();
        
        List<Case> testCases = tdf.OnCreateCaseData(2, 'IL1');
        
        testCases[0].Description = 'Description 1';
        testCases[1].Description = 'Description 2';
        
        testCases[0].RecordTypeId = caseRecordId;
        testCases[1].RecordTypeId = caseRecordId;
        
        insert testCases;
        
        Test.startTest();
        
        	Utils.hasRecordChanged(testCases[0], testCases[1]);
        
        Test.stopTest();
        
    }
    
}