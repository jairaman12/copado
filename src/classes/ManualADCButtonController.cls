/*
* This class is used to build the URL to launch Manual ADC in Lightning Experience.
* Developer: Travis Self
*/
public class ManualADCButtonController {
    @AuraEnabled
    public static String getManualADCUrl(Id userId, Id recordId, String objType){
        /* Method to check whether the logged in User should be able to create Manual ADC Cases */
        if(!isValidUserRole(userId)) {
            return 'errorMessage1';
        }
        System.debug('Building the Manual ADC URL...');
        String urlForManualADC = '/apex/PFINSelection?isdtp=vw';    /* Base Visualforce Page URL */
        Account acctRecord;
        CM_SPL_Addr__c serviceAndPayeeRecord;
        Case caseRecord;
        
        /* Build the URL based on where the Manual ADC Button was clicked (Account, Service & Payee Location Address, or Email-to-Case) */
        /* These URLs were taken from the Salesforce Classic custom Javascript buttons. */
        if(objType == 'Account') {
            acctRecord = [SELECT Id, CM_Corporate_Entity_Code__c, Name, recordType.DeveloperName, isPersonAccount FROM Account WHERE Id= :recordId LIMIT 1];
            urlForManualADC += '&accountId=' + acctRecord.Id + '&accountType=' + acctRecord.IsPersonAccount + '&name=' + '{URLENCODE(' + acctRecord.Name + ')}' + '&planId=' + acctRecord.CM_Corporate_Entity_Code__c + '&from=Account';
        } else if(objType == 'CM_SPL_Addr__c') {
            serviceAndPayeeRecord = [SELECT Id, CM_Corporate_Entity_Code__c, CM_SPL_PFIN_No__c, Bill_PFIN__c, CM_SPL_Prov__c, CM_SPL_Prov__r.Id, CM_SPL_Prov__r.Name, recordType.DeveloperName FROM CM_SPL_Addr__c WHERE Id= :recordId LIMIT 1];
            urlForManualADC += '&accountId=' + serviceAndPayeeRecord.CM_SPL_Prov__r.Id + '&name=' + '{URLENCODE(' + serviceAndPayeeRecord.CM_SPL_Prov__r.Name+ ')}' + '&planId=' + serviceAndPayeeRecord.CM_Corporate_Entity_Code__c+ '&from=Account';
            urlForManualADC += '&pfinaddressId=' + serviceAndPayeeRecord.Id + '&urlPFIN=' + serviceAndPayeeRecord.Bill_PFIN__c + '&urlNonBillPfin=';
            if(serviceAndPayeeRecord.Bill_PFIN__c != serviceAndPayeeRecord.CM_SPL_PFIN_No__c) {
                urlForManualADC += serviceAndPayeeRecord.CM_SPL_PFIN_No__c;
            } else {
                urlForManualADC += 'NULL';
            }
        } else if(objType == 'Case') {
            caseRecord = [SELECT Id, AccountId, Account.Name, Case_Entity__r.Id, Case_Entity__r.Name, Plan_Id__c, Origin, recordType.DeveloperName, isClosed FROM CASE WHERE Id= :recordId LIMIT 1];
            urlForManualADC += '&parentId=' + caseRecord.Id + '&caseorg=' + caseRecord.Origin + '&planId=' + caseRecord.Plan_Id__c + '&from=Case';
            if(caseRecord.AccountId != null) {
                urlForManualADC += '&accountId=' + caseRecord.AccountId;
            }
            if(caseRecord.Case_Entity__r.Id != null) {
                urlForManualADC += '&caseEntity=' + caseRecord.Case_Entity__c;
            }
            if(caseRecord.isClosed) {
                return 'errorMessage2';	
            } else if(caseRecord.AccountId == null && caseRecord.Case_Entity__r.Id == null) {
                return 'errorMessage3';
            } else if(caseRecord.AccountId != null && caseRecord.Case_Entity__r.Id != null) {
                return 'errorMessage4';
            }
        }
        
        System.debug('MANUAL ADC URL: ' + urlForManualADC);
        
        /* This is being returned to the Client-Side Controller that is part of the lightning component. */
        return urlForManualADC;        
    }
    
    @AuraEnabled
    public static Boolean isValidUserRole(String userId) {
        System.debug('Checking Current User Role Info...');
        Set<String> invalidUserRoles = new Set<String>{'Texas_Supervisor', 'Texas_PNC', 'Provider_Data_Rep_TX'};
        
        List<User> loggedInUser = [SELECT Id, UserRole.DeveloperName FROM USER WHERE Id=: userId LIMIT 1];    
        
        System.debug('Current User Role: ' + loggedInUser[0].UserRole.DeveloperName);
        
        /* Texas Users shouldn't have the ability to create Manual ADC cases */
        if(invalidUserRoles.contains(loggedInUser[0].UserRole.DeveloperName)) {
           System.debug('Invalid User for Manual ADC');
           return false;
        }
        
        return true;
        
    }
}