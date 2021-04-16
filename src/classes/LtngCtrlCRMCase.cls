/********************************************************************************
Apex Class Name - LtngCtrlCRMCase
Version - 1.0
Created Date - Sep 17, 2018
Function 1 - Apex Class for creating CRM Case from Mobile
Function 2 - Apex Class for launching CRM Case Creation from Desktop

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Laxman Vattam           Sep 17, 2018         Original Version
* Travis Self             Feb 2019             Added Desktop CRM Launching Methods
********************************************************************************/
public class LtngCtrlCRMCase {    
    
    /*        
    * Method Name: getInitial
    * Description: Method to fetch Plan Id and Account/Entity info during launch of component
    */
    @AuraEnabled
    public static String getInitial(Id objId, string sobj){      
        String acctId = objId;                       
        String sObjName             = sobj;
        system.debug('sObjName:' + sObjName);
        system.debug('acctId:' + acctId );
        Account parentAccount = [SELECT RecordType.Name,Name,CM_Corporate_Entity_Code__c FROM Account WHERE Id =: acctId];
        if(parentAccount.RecordType.Name == 'Entity Account' || parentAccount.RecordType.Name == 'Master Entity Account')
            return 'Entity:' + parentAccount.CM_Corporate_Entity_Code__c + parentAccount.name;
        else
            return 'Account:' + parentAccount.CM_Corporate_Entity_Code__c + parentAccount.name;
    }
    
    /*        
    * Method Name: saveData
    * Description: Method to get create master and child CRM cases when save button is clicked from component
    */
    @AuraEnabled
    public static Id saveData(case casere,List<CM_SPL_Addr__c> spl, Id accId,sObject parId,sObject conId)        
    {
        system.debug('Savedata:casere:' + casere);
        system.debug('savedata:spl:' + spl);
        system.debug('accId:' + accId); 
        //system.debug('caseRe.ContactId' + caseRe.Contact.Id);
        //system.debug('parId:' + parId);
        //system.debug('conId:' + conId);
        
        Set<String>  CRM_RECORDS            =   new Set<String>{'CRM','Master_CRM_Case_Data'};
            string parentId = '';
        if(String.isBlank(String.valueOf(parId)) && parId != null)
            parentId = parId.Id;
        account acc = [SELECT Id, RecordType.Name, CM_Corporate_Entity_Code__c, IsPersonAccount FROM Account WHERE Id =: accId];
        
        List<Case> crmrecordsForInsert  =   new List<case>();
        Map<String,Id> recTypeNamesMap  =   new Map<String,Id>();
        List<recordType> recTypeList    =   [Select Id,DeveloperName,Name from RecordType where developerName IN: CRM_RECORDS];
        
        /************ Case recordtype Map ******/ 
        for(RecordType recType : recTypeList)
        {
            recTypeNamesMap.put(recType.DeveloperName,recType.Id);
        }
        
        /************ Insert master case ******/
        Boolean goodToInsert            =   true;
        if( casere!= null ) 
        {
            if(parentId == null || parentId == '')
            {
                Case masterCase                         =   new Case();
                masterCase.Status                       =   casere.Status;
                if(acc.RecordType.Name.contains('Entity'))
                    masterCase.Case_Entity__c               =   accId;
                else
                    masterCase.AccountId                    =   accId;
                if(conId != null)
                    masterCase.ContactId                    =   conId.Id;
                mastercase.RecordTypeId                 =   recTypeNamesMap.get('Master_CRM_Case_Data');
                mastercase.Plan_ID__c                   =   acc.CM_Corporate_Entity_Code__c;
                mastercase.Priority                     =   caseRe.Priority; 
                masterCase.type                         =   caseRe.Type;
                masterCase.Reason                       =   caseRe.Reason;
                masterCase.Origin                       =   caseRe.Origin;
                masterCase.Email_Address_Submitter__c   =   casere.Email_Address_Submitter__c;
                masterCase.Corporate_received_date__c   =   caseRe.Corporate_received_date__c;
                masterCase.OwnerId                      =   UserInfo.getUserId();
                masterCase.PFIN_Numbers_Long__c         = '';
                
                for(Integer i=0; i<spl.size(); i++) {
                    masterCase.PFIN_Numbers_Long__c += spl[i].CM_SPL_PFIN_No__c + ', ';
                }
                
                if(masterCase.PFIN_Numbers_Long__c != '')
                    masterCase.PFIN_Numbers_Long__c = masterCase.PFIN_Numbers_Long__c.substring(0, masterCase.PFIN_Numbers_Long__c.length()-2);
                system.debug('masterCase:' + masterCase);                
                crmrecordsForInsert.add(mastercase);
                
                Database.SaveResult[] reults     =   Database.Insert( crmrecordsForInsert , false ) ;
                system.debug('results:mastercase:' + reults);
                for(Database.SaveResult sr : reults ){
                    if (sr.isSuccess())
                    {
                        parentId    =   sr.getId();
                    }else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Fields that affected this error: ' + err.getFields());
                            throw new AuraHandledException(err.getStatusCode() + ' : ' + err.getMessage());
                        }
                    }                    
                }
                crmrecordsForInsert.clear();
            }  
            if(parentId != null || parentId != '')
            {
                Case childCrmCase = new Case();
                if(acc.RecordType.Name.contains('Entity'))
                    childCrmCase.Case_Entity__c             =   accId;
                else
                    childCrmCase.AccountId                  =   accId; 
                if(conId != null)
                    childCrmCase.ContactId                  =   conId.Id;
                childCrmCase.Plan_ID__c                 =   acc.CM_Corporate_Entity_Code__c;
                childCrmCase.Type                       =   caseRe.Type;
                childCrmCase.Email_Address_Submitter__c     =   casere.Email_Address_Submitter__c;
                childCrmCase.Corporate_received_date__c =   caseRe.Corporate_received_date__c;
                childCrmCase.OwnerId                    =   UserInfo.getUserId(); 
                childCrmCase.Origin                     =   caseRe.Origin;
                childCrmCase.Priority                   =   casere.Priority;
                childCrmCase.CRM_Comments__c            =   casere.CRM_Comments__c;
                childCrmCase.Status                     =   casere.status;                
                childCrmCase.parentId                   =   parentId;
                childCrmCase.RecordTypeId               =   recTypeNamesMap.get('CRM');
                childCrmCase.CRM_Types__c               =   casere.CRM_Types__c;
                if(casere.Outcome__c != '' && casere.Outcome__c != '--- None ---' && casere.Outcome__c != null)
                    childCrmCase.Outcome__c                 =   casere.Outcome__c;
                childCrmCase.SkipOmniRouting__c         =   'true';
                childCrmCase.PFIN_Numbers_Long__c       = '';
                
                for(Integer i=0; i<spl.size(); i++) {
                    childCrmCase.PFIN_Numbers_Long__c += spl[i].CM_SPL_PFIN_No__c + ', '; 
                }
                
                if(childCrmCase.PFIN_Numbers_Long__c != '')
                    childCrmCase.PFIN_Numbers_Long__c = childCrmCase.PFIN_Numbers_Long__c.substring(0, childCrmCase.PFIN_Numbers_Long__c.length()-2);
                
                childCrmCase.Other_Reason_Description__c     = casere.Other_Reason_Description__c; 
                crmrecordsForInsert.add( childCrmCase );
                system.debug('child case:' + crmrecordsForInsert);                
            }
            
            if( !crmrecordsForInsert.isEmpty() ){
                Database.SaveResult[] reults2     =   Database.Insert( crmrecordsForInsert , false ) ;
                system.debug('results:childcase:' + reults2);
                for(Database.SaveResult sr : reults2 ){
                    if (sr.isSuccess())
                    {
                        //Do Nothing
                    }else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Fields that affected this error: ' + err.getFields());
                            throw new AuraHandledException(err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }                    
                }
            }             
            system.debug('child case2:' + crmrecordsForInsert);            
        }              
        return parentId;
    }
    
    /*        
    * Method Name: getPFINS
    * Description: Method to fetch PFINs when component is launched
    */    
    @AuraEnabled
    public static List<CM_SPL_Addr__c> getPFINS(Id accountId)
    {        
        List<CM_SPL_Addr__c> allPfins = new List<CM_SPL_Addr__c>(); 
        string planId = '';
        Integer numberOfPfinOptions     ;
        List<Id> tempIDList;
        String soql;        
        try {           
            numberOfPfinOptions = 0;
            String entityType = '';
            account acc = [SELECT Id, RecordType.Name, CM_Corporate_Entity_Code__c, IsPersonAccount FROM Account WHERE Id =: accountId];
            entityType = acc.RecordType.Name;
            
            List<CM_SPL_Addr__c> tempList = new List<CM_SPL_Addr__c>();
            Set<String> pfinNumberSet = new Set<String>();
            tempIDList = new List<Id>();
            PlanId = acc.CM_Corporate_Entity_Code__c;
            Id entityId = acc.Id;
            
            if(!entityType.contains('Master')) {                    
                soql    = 'SELECT Id, CM_SPL_PFIN_No__c, CM_SPA_Tax_ID__c, CM_County__c,Bill_PFIN__c, CM_SPL_Prov__r.Prov_ID__c, CM_SPL_Prov__c, CM_SPL_Prov__r.Name FROM CM_SPL_Addr__c WHERE'; 
                soql    +=   ' (CM_SPL_Prov__c=:accountId) AND';
                soql += ' CM_Corporate_Entity_Code__c=:planId ORDER BY CM_SPL_PFIN_No__c LIMIT 999';                
            } else if(entityType.contains('Master')) {                
                for(Affiliations__c a : [SELECT Id, Affiliated_to_Service_PFIN__c, CM_Corporate_Entity_Code__c FROM Affiliations__c WHERE Account__c=:accountId AND CM_Corporate_Entity_Code__c=:planId ORDER BY Affiliated_to_Service_PFIN__c] ) {
                    tempIDList.add(a.Affiliated_to_Service_PFIN__c);
                }
                System.debug('--------------------> # of Affiliations: ' + tempIDList.size() );
                soql  = 'SELECT Id, CM_SPL_PFIN_No__c, CM_SPA_Tax_ID__c, CM_County__c,Bill_PFIN__c, CM_SPL_Prov__r.Prov_ID__c, CM_SPL_Prov__c, CM_SPL_Prov__r.Name FROM CM_SPL_Addr__c WHERE';
                soql += ' (CM_SPL_Prov__c=:accountId OR CM_SPL_Prov__c IN:tempIDList)';
                soql += ' AND CM_Corporate_Entity_Code__c=:planId ORDER BY CM_SPL_PFIN_No__c LIMIT 999';                
            }
            tempList = Database.query(soql);
            allPfins = new List<CM_SPL_Addr__c>();
            
            System.debug('SOQL STATEMENT: ' + soql );
            System.debug('LIST SIZE WITH DUPLICATES: ' + tempList.size() );
            
            for(Integer i=0; i<tempList.size(); i++) {                
                if(i == 0) {   
                    numberOfPfinOptions++;
                    allPfins.add(tempList[i]);                    
                } else if( i>=1 ) {                    
                    String prevPfin = tempList[i-1].CM_SPL_PFIN_No__c;
                    String currPfin = tempList[i].CM_SPL_PFIN_No__c;
                    
                    if( !currPfin.equalsIgnoreCase(prevPfin) ) {
                        numberOfPfinOptions++;                      
                        allPfins.add(tempList[i]);
                    }                     
                }                
            }
            System.debug('List SIZE WITHOUT DUPLICATES: ' + numberOfPfinOptions );
        } catch(Exception e) {
            System.debug('EXCEPTION: ' + e);
        } 
        system.debug('getPFINS:end');
        return allPfins;        
    }
    
    /*        
    * Method Name: getselectOptions
    * Description: Method to fetch picklist values to be populated on component
    */    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        if(string.valueof(objObject) == 'Case:{}' && fld == 'CRM_Types__c'){
            allOpts = getcrmRequestTypes();
            return allOpts; 
        }else if(string.valueof(objObject) == 'Case:{}' && fld == 'Status'){
            allOpts = getcrmCaseStatus();
            return allOpts; 
        }else if(string.valueof(objObject) == 'Case:{}' && fld == 'Origin'){
            allOpts = getcrmCaseOrigin();
            return allOpts; 
        }else if(string.valueof(objObject) == 'Case:{}' && fld == 'Outcome__c'){
            allOpts = getOutcome();
            return allOpts; 
        }
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    /*        
    * Method Name: getcrmRequestTypes
    * Description: Supporting method for getselectOptions to fetch values for CRM Types
    */
    public static List<String> getcrmRequestTypes()
    {                
        List<String> crmRequestTypes                                     =   new List<String>();
        Schema.DescribeFieldResult crmCaseTypeField         =   Case.CRM_Types__c.getDescribe();
        List<Schema.PicklistEntry> crmTypes                 =   crmCaseTypeField.getPickListValues();
        for( Schema.PicklistEntry crmType : crmTypes )
        {
            crmRequestTypes.add(crmType.getValue());                    
        }            
        crmRequestTypes.sort();
        return crmRequestTypes;       
    }
    
    /*        
    * Method Name: getcrmCaseStatus
    * Description: Supporting method for getselectOptions to fetch values for Status
    */
    public static List<String> getcrmCaseStatus()
    {  
        List<String> crmCaseStatus       =   New List<String>();
        String csStatus = GlobalSettings__c.getValues('PFFileRecieved').CRM_Case_Status_fields__c;
        for(String csStat : csStatus.split(',') ){
            crmCaseStatus.add( csStat);
        }           
        return crmCaseStatus;       
    }
    
    /*        
    * Method Name: getcrmCaseOrigin
    * Description: Supporting method for getselectOptions to fetch values for Origin
    */
    public static List<String> getcrmCaseOrigin()
    {       
        List<String> crmCaseOrigin       =   New List<String>();
        String csStatus = GlobalSettings__c.getValues('PFFileRecieved').CRM_Case_Origin_Values__c;
        for(String csStat : csStatus.split(',') ){
            crmCaseOrigin.add( csStat);
        }           
        return crmCaseOrigin;       
    }
    
    /*        
    * Method Name: getcrmCaseOrigin
    * Description: Supporting method for getselectOptions to fetch values for Origin
    */
    public static List<String> getOutcome()
    {      
        List<String> crmCaseOrigin       =   New List<String>();
        String csStatus = GlobalSettings__c.getValues('PFFileRecieved').CRM_Case_Origin_Values__c;
        for(String csStat : csStatus.split(',') ){
            crmCaseOrigin.add( csStat);
        }           
        return crmCaseOrigin;       
    }
    
    /*        
    * Method Name: getDependentMap
    * Description: Method to handle dependant picklist values
    */    
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {        
        return dependentPicklistController.getDependentMap(objDetail,contrfieldApiName,depfieldApiName);        
    }
    
    /* This section is for the Desktop CRM Button 
     * Developer: Travis S.
     */    
    @AuraEnabled
    public static String getCRMURL(Id recordId, String objType, String userId){
        
        if(!isValidUserRole(userId)) {
            return 'errorMessage1';
        }
        System.debug('Building the CRM URL...');
        String urlForCRM = '/apex/CRMCaseCreationPage?isdtp=vw';    /* Base Visualforce Page URL */
        Account acctRecord;
        CM_SPL_Addr__c serviceAndPayeeRecord;
        Case caseRecord;
        
        /* Build the URL based on where the New CRM Case Button was clicked (Account, Service & Payee Location Address, or Email-to-Case) */
        /* These URLs were taken from the Salesforce Classic custom Javascript buttons. */
        if(objType == 'Account') {
            acctRecord = [SELECT Id, CM_Corporate_Entity_Code__c, Name, recordType.DeveloperName, isPersonAccount FROM Account WHERE Id= :recordId LIMIT 1];
            urlForCRM += '&accountId=' + acctRecord.Id + '&planId=' + acctRecord.CM_Corporate_Entity_Code__c + '&from=Account' + '&inConsole=true';
        } else if(objType == 'CM_SPL_Addr__c') {
            
            serviceAndPayeeRecord = [SELECT Id, CM_Corporate_Entity_Code__c, CM_SPL_PFIN_No__c, Bill_PFIN__c, CM_SPL_Prov__c, CM_SPL_Prov__r.Id, CM_SPL_Prov__r.Name, recordType.DeveloperName FROM CM_SPL_Addr__c WHERE Id= :recordId LIMIT 1];
            urlForCRM += '&accountId=' + serviceAndPayeeRecord.CM_SPL_Prov__r.Id + '&planId=' + serviceAndPayeeRecord.CM_Corporate_Entity_Code__c + '&pfinNumber=' + serviceAndPayeeRecord.CM_SPL_PFIN_No__c + '&recordId=' + serviceAndPayeeRecord.Id;
            urlForCRM += '&from=ServiceAndPayee&inConsole=true';
            
        } else if(objType == 'Case') {
            
            caseRecord = [SELECT Id, status, Check_for_90_days__c, AccountId, Account.Name, Case_Entity__r.Id, Case_Entity__r.Name, Plan_Id__c, Origin, recordType.DeveloperName, isClosed FROM CASE WHERE Id= :recordId LIMIT 1];
            urlForCRM += '&parentId=' + caseRecord.Id + '&planId=' + caseRecord.Plan_Id__c + '&Origin=' + caseRecord.Origin + '&from=Case&inConsole=true';
            System.debug('Validating parent case...');
            if((caseRecord.isClosed && caseRecord.status != 'Application Returned' && caseRecord.status != 'Admin Denial') || 
               ((caseRecord.status == 'Application Returned' || caseRecord.status == 'Admin Denial') && caseRecord.Check_for_90_days__c)){
                return 'errorMessage2';                                                             /* Can't create child cases when the parent case is closed */
            } else if(caseRecord.AccountId == null && caseRecord.Case_Entity__r.Id == null) {
                return 'errorMessage3';                                                             /* Either Account Name or Case Entity needs to be filled */
            } else if(caseRecord.AccountId != null && caseRecord.Case_Entity__r.Id != null && caseRecord.recordType.DeveloperName != 'Provider_Group_On_boarding_Credentialling') {
                return 'errorMessage4';                                                             /* Account Name and Case Entity cannot both have a value */
            }
            if(caseRecord.AccountId != null) {
                urlForCRM += '&accountId=' + caseRecord.AccountId;
            } else {
                urlForCRM += '&caseEntityId=' + caseRecord.Case_Entity__r.Id;
            }
            
            System.debug('Parent Case passed CRM validation...');
        }
        
        System.debug('CRM URL: ' + urlForCRM);
        
        /* This is being returned to the Client-Side Controller that is part of the lightning component. */
        return urlForCRM;        
    }
    
    /* Method to check whether the logged in User should be able to create CRM Cases */
    //PPN-39570 removed enterprice profile
    public static Boolean isValidUserRole(String userId) {
        System.debug('Checking Current User Role Info...');
        Set<String> invalidUsers = new Set<String>{'Provider_Data_Rep_IL', 'Provider_Data_Rep_MT', 'Provider_Data_Rep_NM', 'Provider_Data_Rep_OK', 'Provider_Data_Rep_TX'};
        
        List<User> loggedInUser = [SELECT Id, UserRole.DeveloperName, Profile.Name FROM USER WHERE Id=: userId LIMIT 1];    
        
        System.debug('Current User Role: ' + loggedInUser[0].UserRole.DeveloperName);
        
        /* Only Supervisors or PNC Users should be able to create new CRM Cases */
        if(invalidUsers.contains(loggedInUser[0].UserRole.DeveloperName) || invalidUsers.contains(loggedInUser[0].Profile.Name)) {
           System.debug('Invalid User for CRM');
           return false;
        }
        
        return true;
        
    }
    /* END DESKTOP CRM */
}