@isTest
public class ProviderNetworkCls_Test
{
    public static testmethod void saveMethod()
    {
        PageReference pageRef = Page.ProviderNetworkPage; 
        pageRef.getParameters().put('planId', 'IL1');            
        pageRef.getParameters().put('mode', 'create');            
        System.test.setCurrentPage(pageRef);
        ApexPages.standardController newController = new ApexPages.standardController(new Provider_Networks__c());
        ProviderNetworkCls newClass = new ProviderNetworkCls(newController);
        newClass.providerNetwork.Name__c='Test';
        newClass.providerNetwork.Network__c='Testing';
        newClass.saveAction();
        
		newClass.providerNetwork = [Select Id From Provider_Networks__c Limit 1];
		newClass.providerNetwork.Name__c='Test';
        newClass.providerNetwork.Network__c='Testing';        
        update newClass.providerNetwork;
        pageRef = Page.ProviderNetworkPage; 
        pageRef.getParameters().put('planId', 'IL1');            
        pageRef.getParameters().put('networkId', newClass.providerNetwork.Id);            
        pageRef.getParameters().put('mode', 'edit');            
        System.test.setCurrentPage(pageRef);
        newController = new ApexPages.standardController(new Provider_Networks__c());
        newClass = new ProviderNetworkCls(newController);
        newClass.displayNetworkNames();
        newClass.networkName='Testing';
        newClass.displayNetworkNames();
        newClass.displayNetworks();
        newClass.saveAction();
        newClass.saveAndNewAction();
        newClass.backToCase();
    }
}