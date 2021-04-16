/*
 * This controller is used with ProviderNetworkLoadEditPage.vfp
 * which is a custom edit page on the Network Load page layout
 * in the provider details related list
 * 10/16/2018
*/ 
public class ProviderNetworkLoadEditPageController {
    
    public Provider_Networks__c provNetObj      {get; set;}
    public String str ='';
    String providerNetworkId = '';
    
    public ProviderNetworkLoadEditPageController(ApexPages.StandardController controller) {
        
        providerNetworkId = ApexPages.currentPage().getParameters().get('Id');
        
        provNetObj = new Provider_Networks__c();
        
        provNetObj = [SELECT Id, Name, Case_Number__c, Plan_Id__c,PFIN_Case__c, ProviderName__c, Contracting_Case__c, Network_Code_Name__c, Prov_ID__c, PFIN_onBoarding__c, Network_Load_Plan_Id__c, Network_Code_Name_Detail__c, Networks_Effective_Date__c, Designation_Code__c, Comp_Grid_Code__c, Panel_code__c, Roles_Code__c
                     FROM Provider_Networks__c WHERE Id= :providerNetworkId LIMIT 1];
        
        provNetObj.Plan_Id__c = provNetObj.Network_Load_Plan_Id__c;          
        
        //provNetObj.Network_Code_Name_Detail__c = provNetObj.Network_Code_Name__c ;
        
       
    }
    
    public PageReference save() {
        
            if(provNetObj.Network_Code_Name__c != NULL){                
                    for(String s : provNetObj.Network_Code_Name__c.split(';')){
                        str = str != NULL ? str + '\r\n' + s: s;
                    }
                }
        provNetObj.Network_Code_Name_Detail__c = str;
        
        update provNetObj;
        
        return (new PageReference ( '/' + providerNetworkId ).setRedirect(true) );
    }
    
    public PageReference cancel() {
        
        return (new PageReference ( '/' + providerNetworkId ).setRedirect(true) );
    }
    
}