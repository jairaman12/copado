/********************************************************************************
Apex Class Name - CaseStatusValues
Version - 1.0
Created Date - May 24, 2019
Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Laxman Vattam           May 24, 2019         PPN-40804,PPN-40809,PPN-41166 Original Version.
********************************************************************************/
global class CaseStatusValues {
    @AuraEnabled public string caseNumber;
    @AuraEnabled public string providerName;
    @AuraEnabled public string caseStatus;
    @AuraEnabled public string caseState;
    @AuraEnabled public string caseType;
    @AuraEnabled public string caseSubject;
    @AuraEnabled public string CorporateReceivedDate;
    @AuraEnabled public string contactInfo;
}