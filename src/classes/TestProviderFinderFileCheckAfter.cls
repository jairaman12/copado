@isTest
public class TestProviderFinderFileCheckAfter
{
    static testMethod void testBatch() 
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.name = 'PFFileRecieved';
        gs.PFFileRecieved__c = false;
        insert gs;
        
        Test.startTest();
        ProviderFinderFileCheckAfter obj = new ProviderFinderFileCheckAfter();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        ProviderFinderFileCheckAfter sh1 = new ProviderFinderFileCheckAfter();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test scheduler Check', sch, sh1); 
        Test.stopTest(); 
    }
}