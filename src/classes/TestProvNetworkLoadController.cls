@isTest
public class TestProvNetworkLoadController {
    
    @testSetup static void setup() {
        Provider_Networks__c p = new Provider_Networks__c();
        p.Network_Load_Plan_Id__c = 'IL1';
        p.Network_Code_Name_Detail__c = 'ADV - Blue Advantage HMO';
        insert p;
    }
    
    static testMethod void testProviderNetworkLoadEditPageController() {
        
        Provider_Networks__c testProviderDetail = [SELECT Id FROM Provider_Networks__c LIMIT 1];
        
        Provider_Networks__c pn = new Provider_Networks__c();
        PageReference pageRef = Page.ProviderNetworkLoadEditPage;
        pageRef.getParameters().put('Id', testProviderDetail.id );
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc 					= new ApexPages.StandardController(pn);
        ProviderNetworkLoadEditPageController controller 	= new ProviderNetworkLoadEditPageController(sc);
        
        Test.startTest();
        
        	controller.save();
        
        	controller.cancel();
        
        Test.stopTest();
    }

}