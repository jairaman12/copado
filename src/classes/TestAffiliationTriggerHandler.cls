@isTest
public class TestAffiliationTriggerHandler {
    
    static List<Account> testAccounts;
    static Id physAccountRecordType 	= [SELECT Id, Name FROM RecordType WHERE SObjectType='Account' AND Name='Physician'].Id;
    static Id entityAccountRecordType 	= [SELECT Id, Name FROM RecordType WHERE SObjectType='Account' AND Name='Entity Account'].Id;
    static Id MEAccountRecordType 		= [SELECT Id, Name FROM RecordType WHERE SObjectType='Account' AND Name='Master Entity Account'].Id;
    
    @testSetup static void prepareData() {
        GlobalSettings__c gs				= new GlobalSettings__c();
        gs.name 							= 'PFFileRecieved';
        gs.PFFileRecieved__c				= false;
        gs.Affiliation_Trigger_Switch__c	= false;
        insert gs;
	}

    static testMethod void testAffTriggerHandler() {
        
        testAccounts 			= new List<Account>();
        Account eAcc			= new Account();
        Account physAcc			= new Account();
        Account meAcc			= new Account();
        eAcc.Name				= 'Entity Account';
        eAcc.CM_Corporate_Entity_Code__c	= 'IL1';
        physAcc.LastName		= 'Physician';
        physAcc.CM_Corporate_Entity_Code__c	= 'IL1';
        meAcc.Name				= 'Master Entity Account';
        meAcc.CM_Corporate_Entity_Code__c	= 'IL1';
        eAcc.RecordTypeId		= entityAccountRecordType;
        physAcc.RecordTypeId	= physAccountRecordType;
        meAcc.RecordTypeId		= MEAccountRecordType;
        
        testAccounts.add(physAcc);
        testAccounts.add(eAcc);
        testAccounts.add(meAcc);
        
        insert testAccounts;
        
        Affiliations__c newAff 			= new Affiliations__c();
        Affiliations__c exisitingAff 	= new Affiliations__c();
        Affiliations__c newMEAff 		= new Affiliations__c();
        
        newAff.CM_Affiliated_Provider_Name__c		= physAcc.Id;
        newAff.Account__c							= eAcc.Id;
        newAff.CM_Corporate_Entity_Code__c			=	'IL1';
        
        
        exisitingAff.CM_Affiliated_Provider_Name__c		= eAcc.Id;
        exisitingAff.Account__c							= physAcc.Id;
        exisitingAff.CM_Affiliation_Code_Description__c	= 'Medical Group Participant (MGP)';
        
        newMEAff.CM_Affiliated_Provider_Name__c		= eAcc.Id;
        newMEAff.Account__c							= meAcc.Id;
        newMEAff.CM_Corporate_Entity_Code__c		= 'IL1';
        
        newAff.Roll_Down__c 	= true;
        newMEAff.Roll_Down__c 	= true;
        
        Test.startTest();
        
        	// Creates 1 Aff
        	insert exisitingAff;
        
        	// Creates 2 Aff, because of the rolldown
            insert newAff;
        
        	// Creates 1 Aff, because of the rolldown
        	newAff.Account__c	= meAcc.Id;
        	update newAff;
        	
        	// Creates 1 Aff
        	insert newMEAff;
        
        Test.stopTest();
        
        
       // System.assertEquals(5, [SELECT count() FROM Affiliations__c]);
        
    }
    
}