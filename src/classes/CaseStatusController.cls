/********************************************************************************
Apex Class Name - CaseStatusController
Version - 1.0
Created Date - May 24, 2019
Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Laxman Vattam           May 24, 2019         PPN-40804,PPN-40809,PPN-41166 Original Version.
* Suman Gavini            June 03, 2019        PPN-40808,PPN-40807,PPN-40810( line:44-50,66-89)
********************************************************************************/
global without sharing class CaseStatusController {
    
    /*        
    * Method Name: fetchData
    * Description: Method to get case information based on case number
    */
    @AuraEnabled
    public static CaseStatusValues fetchData(integer caseNumberInput){  
        
        string caseNo = string.valueof(caseNumberInput);
        caseStatusValues returnValue = new caseStatusValues();        
        List<case> caseList = new List<case>();
        
        
        system.debug('caseNo:' + caseNo);
        if(caseNo.length() < 8){
            caseNo = caseNo.leftPad(8, '0');
        }
        system.debug('caseNo:' + caseNo);
        caseList = [select id,status,caseNumber,Subject,Origin,RecordType.name,account.name,case_entity__r.name,Corporate_Received_Date_Time__c,
                    Plan_ID__c,type from case where caseNumber = :caseNo AND parentId = null limit 1];
        
               
        if(caseList != null && caseList.size() > 0){
            system.debug('caseList:' + caseList[0]);
            returnValue.caseNumber = caseList[0].caseNumber ;
            if(caseList[0].account.name != null){
                returnValue.providerName = caseList[0].account.name;
            }else{
                returnValue.providerName = caseList[0].case_entity__r.name;
            }
            
            if(caseList[0].status == 'Closed Processed'){
                returnValue.caseStatus = 'Closed Processed. Notification has been sent to submitter.';
            } else if(caseList[0].status == 'Closed Rejected'){
                returnValue.caseStatus = 'Closed Rejected. Notification has been sent to submitter.';
            } else if(caseList[0].status == 'Closed'){
                returnValue.caseStatus = 'Closed. Notification has been sent to submitter.';
            } else{
                returnValue.caseStatus = 'In progress';
            }
     
            if(caseList[0].Plan_ID__c == 'IL1'){
              returnValue.caseState = 'Illinois';
            } else if(caseList[0].Plan_ID__c == 'TX1'){
                returnValue.caseState = 'Texas';
            } else if(caseList[0].Plan_ID__c == 'NM1'){
                returnValue.caseState = 'New Mexico';
            } else if(caseList[0].Plan_ID__c == 'MT1'){
                returnValue.caseState = 'Montana';
            } else if(caseList[0].Plan_ID__c == 'OK1'){
                returnValue.caseState = 'Oklahoma';   
            }
            
            //Replace number with X in subject field
            if(String.isNotBlank(caseList[0].Subject)){
                String regExp = '[0-9]';
                returnValue.caseSubject = caseList[0].Subject.replaceAll(regExp,'X');
            }
            
            if(caseList[0].Corporate_Received_Date_Time__c!=null){
                Datetime corpReceivedDate = (Datetime) caseList[0].Corporate_Received_Date_Time__c; 
                returnValue.CorporateReceivedDate = corpReceivedDate.format('MM/dd/yyyy');
            }
                      
            string recTypeDevName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseList[0].recordtypeId).getDeveloperName();
            
            if(recTypeDevName == 'Master_Provider_Case_data') {
                returnValue.caseType = 'Demographic Updates';
            }else if(recTypeDevName == 'Charge_Increase') {
                returnValue.caseType = 'Email';    
            }else {
                returnValue.caseType = recTypeDevName.replaceAll('_',' ');
            }
            
                        
            if(recTypeDevName=='Email' || recTypeDevName=='Charge_Increase') {
                
                Map<String,String> originEmailMap= new Map<String,string>(); 
                List<Confirm_Email_Settings__c> conEmailList = Confirm_Email_Settings__c.getall().values();
               
                for(Confirm_Email_Settings__c conEmail: conEmailList){
                    originEmailMap.put(conEmail.case_Origin__c,conEmail.Email__c);
                }
                
                string emailStr = originEmailMap.get(caseList[0].Origin);
                if(emailStr!=null && emailStr!=''){
                    returnValue.contactInfo = emailStr; 
                }else{
                     returnValue.contactInfo = '';
                }
                  
                       
            } else if(recTypeDevName=='Provider_On_boarding') {
                
                List<Contact_Info_based_on_Record_Type__mdt> contInfoMetaList = [SELECT Contact_Info__c,Id,Label,MasterLabel,State__c FROM Contact_Info_based_on_Record_Type__mdt 
                                                                                 where Label=:recTypeDevName AND State__c=:caseList[0].Plan_ID__c];
                if(contInfoMetaList!=null && contInfoMetaList.size()>0 ){
                     returnValue.contactInfo = contInfoMetaList[0].Contact_Info__c;
                }       
            } else if(recTypeDevName=='Master_Provider_Case_data') {
                
                List<Contact_Info_based_on_Record_Type__mdt> contInfoMetaDataList = [SELECT Contact_Info__c,Id,Label,MasterLabel,State__c FROM Contact_Info_based_on_Record_Type__mdt 
                                                                                     where Label=:recTypeDevName AND State__c=:caseList[0].Plan_ID__c];
                if(contInfoMetaDataList!=null && contInfoMetaDataList.size()>0 ){
                     returnValue.contactInfo = contInfoMetaDataList[0].Contact_Info__c;
                }       
            }
                             
            system.debug('ret:' + returnValue);   
            Public_search_history_tracking__c trackingRecord = new Public_search_history_tracking__c();
            trackingRecord.Case_Displayed__c               =   caseList[0].Id;
            trackingRecord.Search_Date_and_Time__c         =   System.now();
            trackingRecord.Case_Status__c                  =   returnValue.caseStatus;            
            insert trackingRecord;
        }  
        return returnValue;        
    }
    
}