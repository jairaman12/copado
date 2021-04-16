/**************************************************************************************************
Apex Class Name  : EmbeddedHospitalAffiliations_Ext 
Version          : 1.0  
Functionality    : 
Modification Log : 06/28/2018 Created by  SethuRaman
****************************************************************************************************/
public class EmbeddedHospitalAffiliations_Ext {
    String type;
    Public Boolean isEmptyList {get;set;}
    Public Boolean isOnchange {get;set;}
    Public Account acc {get;set;}
    Public List<Affiliations__c> affiliationList{get;set;}
    
    public embeddedHospitalAffiliations_Ext(ApexPages.StandardController controller) {
        this.acc = (Account)controller.getRecord();
        affiliationList = new List<Affiliations__c>();
        isEmptyList = false;
        isOnchange = false;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Physician','Physician'));
        options.add(new SelectOption('Entity','Entity'));
        options.add(new SelectOption('Rolodex','Rolodex'));
        return options;
    }
    
    public String getType() {
        return type;
    }
 
    public void setType(String type) {
        this.type= type;
    }
    
    public void selectedTypeList(){
         system.debug('****** Inside selectedTypeList type *****' + type);   
         if(type != NULL){
             affiliationList = new List<Affiliations__c>();
             isOnchange = true;
             if(type == 'All')
             {
                 affiliationList = [SELECT Id, Name, Role__c, Account__c, CM_Affiliated_Provider_Name__c, Account__r.name, CM_Affiliated_Provider_Name__r.RecordType.Name ,Account__r.RecordType.Name, CM_Affiliated_Provider_Name__r.name, Start_Date__c, End_Date__c, CM_Billing_PFIN__c, Type__c, CM_Affiliation_Code_Description__c FROM Affiliations__c WHERE (CM_Affiliated_Provider_Name__c =: acc.Id OR Account__c =: acc.Id )];
             }
             else
             {
                 affiliationList = [SELECT Id, Name, Role__c, Account__c, CM_Affiliated_Provider_Name__c, Account__r.name, CM_Affiliated_Provider_Name__r.RecordType.Name, CM_Affiliated_Provider_Name__r.name, Account__r.RecordType.Name, Start_Date__c, End_Date__c, CM_Billing_PFIN__c, Type__c, CM_Affiliation_Code_Description__c FROM Affiliations__c WHERE Type__c =: type AND (CM_Affiliated_Provider_Name__c =: acc.Id OR Account__c =: acc.Id)];
             }
             system.debug('##### affiliationList size #####' + affiliationList.size());
             system.debug('##### affiliationList #####' + affiliationList);
             if(affiliationList.size() == 0){
                 isEmptyList  = true;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'No records found.'));
             }
             else{
                 isEmptyList = false;
             }
             system.debug('##### isOnchange  #####' + isOnchange );
             system.debug('##### isEmptyList #####' + isEmptyList );
         }

    }

}