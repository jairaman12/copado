@isTest
public class TestAffiliationTrigger {
    
    @testSetup static void prepareData() {
        GlobalSettings__c gs				= new GlobalSettings__c();
        gs.name 							= 'PFFileRecieved';
        gs.PFFileRecieved__c				= false;
        gs.Affiliation_Trigger_Switch__c	= false;
        insert gs;
	}

    public static testmethod void testAffTrigger() {
        
        Affiliations__c aff1 = new Affiliations__c();
        
        Test.startTest();
        
        	insert aff1;
        
        	update aff1;
        
        	delete aff1;
        
        	undelete aff1;
        
        Test.stopTest();
        
    }
    
}