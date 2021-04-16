public with sharing class TaxIdReport {
	public transient List<Account> accounts	{ get; set; }
	public string taxId	{ get; set; }    
    public TaxIdReport(){

    }
    
    public  void getAccounts(){
        system.debug('taxId'+taxId);
		
         /* Use the below Query to get the cases for the Account which has one of the entered Tax IDs, This is suitable for CRM Cases where they Tax_ID_Number__c is not always mandatory 
       			*/
         if(taxId!=''){
   
        Accounts = [SELECT Name, 
                    (SELECT Id, AccountId, CaseNumber,Origin,Reason,Case_Entity__c,Description,Subject,OwnerId FROM Cases),
                    (SELECT Id, AccountId, CaseNumber,Origin,Reason,Case_Entity__c,Description,Subject,OwnerId FROM Cases__r) 
                    FROM Account 
                    WHERE Id IN (SELECT CM_PTI_Prov_Name_From__c FROM CM_Provider_Tax_Id__c where CM_PTI_Tax_Id__c =:taxId) LIMIT 1000];
   		 
        
        /* Use the below Query to get the cases for the entered Tax ID for an account. For this to always return values , Tax_ID_Number__c field should be mandatory in all the Case Page Layouts 
        */
        /*Accounts = [SELECT Name, 
        			(SELECT Id, AccountId, CaseNumber,Origin,Reason,Case_Entity__c,Description,Subject,OwnerId FROM Cases where Tax_ID_Number__c=:taxId), 
					(SELECT Id, AccountId, CaseNumber,Origin,Reason,Case_Entity__c,Description,Subject,OwnerId FROM Cases__r where Tax_ID_Number__c=:taxId)  
					FROM Account 
					WHERE Id IN (SELECT CM_PTI_Prov_Name_From__c FROM CM_Provider_Tax_Id__c where CM_PTI_Tax_Id__c =:taxId)];
    */
          
                 
              system.debug('Accounts'+Accounts);
         }
        
           else
               
               Accounts = null;
}  
    
    public pagereference downloadReport(){
        
         PageReference report= new PageReference('/apex/TaxIdReportPDF'); 
        
        return report;
    }
}