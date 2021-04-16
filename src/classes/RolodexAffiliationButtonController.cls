/*
* This class is used to build the URL to launch Rolodex Affiliation creation in Lightning Experience.
* Developer: Laxman Vattam
*/
public class RolodexAffiliationButtonController {
    @AuraEnabled
    public static String getRolodexAffiliationUrl(Id userId, Id recordId, String objType){        
        System.debug('Building the Rolodex Affiliation URL...');
        String urlForRolodexAffiliation = '/apex/RolodexAffiliationPage?isdtp=vw';    /* Base Visualforce Page URL */
        Account acctRecord = new Account();
        Affiliations__c affRecord = new Affiliations__c();
        system.debug('objType:' + objType);
        /* Build the URL based on where it is invoked  */
        /* These URLs were taken from the Salesforce Classic custom Javascript buttons. */
        if(objType == 'Account') {
            acctRecord = [SELECT Id, CM_Corporate_Entity_Code__c, Name, recordType.DeveloperName, isPersonAccount FROM Account WHERE Id= :recordId LIMIT 1];
            urlForRolodexAffiliation += '&id=' + acctRecord.Id + '&planId=' + acctRecord.CM_Corporate_Entity_Code__c + '&from=Account&isEditPage=false';
        } 
        
        if(objType == 'Affiliations__c') {
            affRecord = [SELECT Id, CM_Corporate_Entity_Code__c FROM Affiliations__c WHERE Id= :recordId LIMIT 1];
            urlForRolodexAffiliation += '&id=' + affRecord.Id + '&planId=' + acctRecord.CM_Corporate_Entity_Code__c + '&from=Affiliations__c&isEditPage=true';
        }
        
        System.debug('Rolodex Affiliation URL: ' + urlForRolodexAffiliation);
        
        /* This is being returned to the Client-Side Controller that is part of the lightning component. */
        return urlForRolodexAffiliation;        
    }
    
    
}