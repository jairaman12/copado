@isTest
public class EmailMessageTriggerHandler_test {
    
    @testSetup static void prepareData() {
        GlobalSettings__c gs				= new GlobalSettings__c();
        gs.name 							= 'PFFileRecieved';
        gs.PFFileRecieved__c				= false;
        gs.EmailMessage_Trigger_Switch__c	= false;
        insert gs;
	}
    
    static testMethod void testEmailTriggerHandler() {
        
        EmailMessageTriggerHandler emth = new EmailMessageTriggerHandler();
        
        EmailMessage em1 = new EmailMessage();
        EmailMessage em2 = new EmailMessage();
        
        Test.startTest();
        
            insert em1;
            insert em2;
            
            update em1;
            
            emth.beforeUpdate(em1, em2);
            
            emth.afterDelete(em1);
            
            try {
                delete em1;
            } catch(Exception e) {
                System.debug('EXCEPTION WHEN DELETING EMAILMESSAGE: '  + e);
            }
        
        Test.stopTest();
        
    }

}