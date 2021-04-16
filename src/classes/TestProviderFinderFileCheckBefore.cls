@isTest
public class TestProviderFinderFileCheckBefore 
{
    static testMethod void testBatch() 
    {
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.name = 'PFFileRecieved';
        gs.PFFileRecieved__c = true;
        insert gs;
        
        Test.startTest();
        ProviderFinderFileCheckBefore obj = new ProviderFinderFileCheckBefore();
        DataBase.executeBatch(obj); 
        Test.stopTest();
        GlobalSettings__c gsafter = [select PFFileRecieved__c from GlobalSettings__c where Name = 'PFFileRecieved'];
        System.assertEquals(gsafter.PFFileRecieved__c,false);
    }
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        ProviderFinderFileCheckBefore sh1 = new ProviderFinderFileCheckBefore();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test scheduler Check', sch, sh1); 
        Test.stopTest(); 
    }
}