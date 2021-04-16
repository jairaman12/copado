/**
 * This class serves as a Handler for the Campaign Activity Trigger.
 * <p/><p/>
 * @author Travis Self
 */
public with sharing class CampaignActivityTriggerHandler {
    
   /**
    * This method is used to handle the after insert event on the Campaign Activity Trigger.
    * 
    * @param lstCampaignActivitiesTriggerNew List of new campaign activites
    */ 
    public static void onAfterInsert(List<CampaignActivity__c> lstCampaignActivitiesTriggerNew) {
        
        List<String> lstEmails = new List<String>();
        List<String> lstPlanIds = new List<String>();
        List<Id> lstServiceAndPayeeLocationsToIgnore = new List<Id>();
        List<Id> lstAccountsToIgnore = new List<Id>();
        List<CM_SPL_Addr__c> lstServiceAndPayeeAddressesWithSharedEmail = new List<CM_SPL_Addr__c>();
        List<Account> lstRolodexAccountsWithSharedEmail = new List<Account>();
        List<CampaignActivity__c> lstNewCampaignActivities = new List<CampaignActivity__c>();
        
        for(CampaignActivity__c ca : lstCampaignActivitiesTriggerNew) {
            if(ca.CreatedFromMarketingCloud__c) {
                lstNewCampaignActivities.add(ca);
                lstPlanIds.add(ca.CorporateEntityCode__c);
                if(ca.SentTo__c != null) {
                    lstEmails.add(ca.SentTo__c);
                }
                if(ca.ServiceAndPayeeLocationAddress__c != null) {
                    lstServiceAndPayeeLocationsToIgnore.add(ca.ServiceAndPayeeLocationAddress__c);
                }
                if(ca.AccountName__c != null) {
                    lstAccountsToIgnore.add(ca.AccountName__c);
                }
            }
    	}
        
        if(!lstNewCampaignActivities.isEmpty()) {
            
            // Get all the Service & Payee Locations that share the same email address of the original email send.
            // Exclude the Service & Payee Locations where a new Campaign Activity was already created from Marketing Cloud.
            lstServiceAndPayeeAddressesWithSharedEmail = [SELECT Id, CM_SPL_Email__c, CM_SPL_Prov__c FROM CM_SPL_Addr__c 
                                                                WHERE CM_SPL_Email__c IN: lstEmails AND CM_SPL_Addr_Type__c = 'Service' AND CM_Corporate_Entity_Code__c IN: lstPlanIds AND Id NOT IN: lstServiceAndPayeeLocationsToIgnore];
         
            // Get all the Rolodex Account that share the same email address of the original email send. 
            // Exclude the Rolodex Accounts where a new Campaign Activity was already created from Marketing Cloud.
            lstRolodexAccountsWithSharedEmail = [SELECT Id, PersonEmail FROM Account WHERE PersonEmail IN: lstEmails AND RecordType.DeveloperName = 'Rolodex' AND CM_Corporate_Entity_Code__c IN: lstPlanIds AND Id NOT IN: lstAccountsToIgnore];
            
            if(!lstServiceAndPayeeAddressesWithSharedEmail.isEmpty()) {
                createCampaignActivitesOnAddressesWithSameEmail(lstNewCampaignActivities, lstServiceAndPayeeAddressesWithSharedEmail);
            }
            if(!lstRolodexAccountsWithSharedEmail.isEmpty()) {
                createCampaignActivitesOnAccountsWithSameEmail(lstNewCampaignActivities, lstRolodexAccountsWithSharedEmail);
            }
        }
    }

   /**
    * This method will create campaign history activities on service & payee location records that share the same email address as the original email send from Marketing Cloud.
    * 
    * @param lstActivities List of new campaign activites
    * @param lstServiceAndPayeeLocations List of service & payee location addresses
    */ 
    private static void createCampaignActivitesOnAddressesWithSameEmail (List<CampaignActivity__c> lstActivities, List<CM_SPL_Addr__c> lstServiceAndPayeeLocations) {
        
        List<CampaignActivity__c> lstActivitiesToInsert = new List<CampaignActivity__c>();
        
        for(CampaignActivity__c ca : lstActivities) {
            if(ca.CreateAtServiceLocWithSameEmail__c) {
                for(CM_SPL_Addr__c sAndP : lstServiceAndPayeeLocations) {
                    CampaignActivity__c newCampaignActivity = ca.clone();
                    newCampaignActivity.ServiceAndPayeeLocationAddress__c = sAndP.Id;
                    newCampaignActivity.AccountName__c = sAndP.CM_SPL_Prov__c;
                    newCampaignActivity.CreatedFromMarketingCloud__c = false;
                    lstActivitiesToInsert.add(newCampaignActivity);
                }
            }
        }
        
        Database.insert(lstActivitiesToInsert, false);
    }
    
   /**
    * This method will create campaign history activities on rolodex account records that share the same email address as the original email send from Marketing Cloud.
    * 
    * @param lstActivities List of new campaign activites
    * @param lstRolodexAccounts List of rolodex accounts
    */ 
    private static void createCampaignActivitesOnAccountsWithSameEmail (List<CampaignActivity__c> lstActivities, List<Account> lstRolodexAccounts ) {
        
        List<CampaignActivity__c> lstActivitiesToInsert = new List<CampaignActivity__c>();
        
        for(CampaignActivity__c ca : lstActivities) {
            if(ca.CreateAtRolodexAcctwithSameEmail__c) {
                for(Account acct : lstRolodexAccounts) {
                    CampaignActivity__c newCampaignActivity = ca.clone();
                    newCampaignActivity.ServiceAndPayeeLocationAddress__c = null;
                    newCampaignActivity.AccountName__c = acct.Id;
                    newCampaignActivity.CreatedFromMarketingCloud__c = false;
                    lstActivitiesToInsert.add(newCampaignActivity);
                }
            }
        }
        
        Database.insert(lstActivitiesToInsert, false);
    }
}