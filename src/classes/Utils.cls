public without sharing class Utils {
    
    /**
     * Comparing the old record changes and new record changes. Checking whether record is changed .
     * @param  oldMap is a map.
     * @param  newMap is a map.
     * @param  fieldName is a string.
     * @return boolean.
     */
    public static boolean isValueChanged(SObject OldRecord , SObject newRecord, String fieldName) {
        boolean isChanged = false;
        if (fieldName != null) {
            if (OldRecord.get(fieldName) == null && newRecord.get(fieldName) != null) {
                isChanged = true;
            } else if (OldRecord.get(fieldName) != null && newRecord.get(fieldName) == null) {
                isChanged = true;
            } else if (OldRecord.get(fieldName) != newRecord.get(fieldName)) {
                isChanged = true; 
            }
           // else if (OldRecord.get(fieldName) == newRecord.get(fieldName)) {
           //     isChanged = true; 
           // }
        }
        return isChanged;
    } 
    
    /***********************************************************************************************************
     * Function     : This function will check if any field on case has changed excepting few editable fields
     * Return type  : Boolean
     ***********************************************************************************************************/
    public static boolean hasRecordChanged(SObject OldRecord , SObject newRecord) {
        boolean isChanged = false;  
        Schema.SObjectType objType = OldRecord.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap(); 
        for (String str : M.keyset()) { 
            try { 
                System.debug('Field name: '+str +'. New value: ' + newRecord.get(str) +'. Old value: '+OldRecord.get(str)); 
                if(M.get(str).getDescribe().isUpdateable() &&
                   str != 'OwnerId'              && 
                   str != 'External_Comments__c' &&
                   str != 'Priority'             &&
                   str != 'Status'               &&
                   str != 'Number_of_PFINs__c'   &&
                   str != 'Case_Entity__c'       &&
                   str != 'AccountId'            &&
                   str != 'Pending_Reason__c'    &&
                   str != 'Description'          &&
                   str != 'ContactId'          &&                   
                   str != 'Comments'             &&
                   str != 'last_case_comment_author__c' &&
                   str != 'last_case_comment__c' &&
                   str != 'plan_id_validation_by_pass__c' &&
                   str != 'Contract_PFIN__c'     &&//R4_Changes_PPN-19079
                   str != 'Contract_ProvID__c'   &&//R4_Changes_PPN-19079
                   //R4_Changes_PPN-17311,PPN_22088
                   str != 'Network_Name__c'   && //PPN-17311
                   str != 'Network_Name_Detail__c' && //PPN-22088
                   str != 'recordTypeId' && //PPN-22088
                   str != 'Master_Entity_Name__c' &&
                   str != 'Master_Entity_ProvID__c' &&
                   str != 'Paper_Cred_Indicator__c' &&
                   str != 'CAQH_Number__c' &&
                   str != 'Contracting_Status__c' && //PPN-30177                   
                   OldRecord.get(str) != newRecord.get(str)){ 
                        system.debug('******The value has changed!!!! ' + str); 
                        isChanged = true; 
                        break;
                } 
            } catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
        return isChanged;
    } 
    
    /***********************************************************************************************************
     * Function     : This function will check if any field on case has changed excepting few editable fields fro networkload case
     * Return type  : Boolean
     ***********************************************************************************************************/
    public static boolean hasRecordChangednetwork(SObject OldRecord , SObject newRecord) {
        boolean isChanged = false;  
        Schema.SObjectType objType = OldRecord.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap(); 
        for (String str : M.keyset()) { 
            try { 
                System.debug('Field name: '+str +'. New value: ' + newRecord.get(str) +'. Old value: '+OldRecord.get(str)); 
                if(M.get(str).getDescribe().isUpdateable() &&
                   str != 'OwnerId'              && 
                   str != 'External_Comments__c' &&
                   str !='Plan_Id_Validation_By_Pass__c'&&
                   str != 'last_case_comment_author__c' &&
                   str != 'last_case_comment__c' &&
                   str != 'Network_Effective_Date__c' &&
                   str != 'Priority'             &&
                   str != 'Status'               &&
                   str != 'Number_of_PFINs__c'   &&
                   str != 'Case_Entity__c'       &&
                   str != 'AccountId'            &&
                   str != 'Contract_PFIN__c'     &&//R4_Changes_PPN-19079
                   str != 'Contract_ProvID__c'   &&//R4_Changes_PPN-19079    
                   str != 'Master_Entity_ProvID__c' &&                             
                   OldRecord.get(str) != newRecord.get(str)){ 
                        system.debug('******The value has changed!!!! ' + str); 
                        isChanged = true; 
                        break;
                } 
            } catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
        return isChanged;
    } 
    
    
     /***********************************************************************************************************
     * Function     : This function will check if any field on case has changed excepting few editable fields  for Credentialing case
     * Return type  : Boolean
     ***********************************************************************************************************/
    public static boolean hasRecordChangedCRMCase(SObject OldRecord , SObject newRecord) {
        boolean isChanged = false;  
        Schema.SObjectType objType = OldRecord.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap(); 
        for (String str : M.keyset()) { 
            try { 
                System.debug('Field name: '+str +'. New value: ' + newRecord.get(str) +'. Old value: '+OldRecord.get(str)); 
                if(M.get(str).getDescribe().isUpdateable() &&
                   str != 'OwnerId'              && 
                   str != 'External_Comments__c' &&
                   str != 'CRM_Case_Number__c' &&
                   str != 'Priority'             &&
                   str != 'Status'               &&
                   str != 'Number_of_PFINs__c'   &&
                   str != 'Case_Entity__c'       &&
                   str != 'AccountId'            &&
                   str != 'Pending_Reason__c'    &&
                   str != 'Description'          &&
                   str != 'ContactId'          &&                   
                   str != 'Comments'             &&
                   str != 'last_case_comment_author__c' &&
                   str != 'last_case_comment__c' &&
                   str != 'plan_id_validation_by_pass__c' &&
                   str != 'Contract_PFIN__c'     &&//R4_Changes_PPN-19079
                   str != 'Contract_ProvID__c'   &&//R4_Changes_PPN-19079
                   //R4_Changes_PPN-17311,PPN_22088
                   str != 'Network_Name__c'   && //PPN-17311
                   str != 'Network_Name_Detail__c' && //PPN-22088
                   str != 'recordTypeId' && //PPN-22088
                   str != 'Master_Entity_Name__c' &&
                   str != 'Master_Entity_ProvID__c' &&
                   str != 'Paper_Cred_Indicator__c' &&
                   str != 'CAQH_Number__c' &&
                   str != 'Contracting_Status__c' && //PPN-30177                   
                   OldRecord.get(str) != newRecord.get(str)){ 
                        system.debug('******The value has changed!!!! ' + str); 
                        isChanged = true; 
                        break;
                } 
            } catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
        return isChanged;
    } 
    
    
    /************************************************
     * Inputs       : Object name and developer name of Record type
     * Return type  : Record Id
     ************************************************/
    public static Map<String,Map<String,Id>> recordTypeMap = new Map<String,Map<String,Id>>();
    public static Id GetRecordTypeId(String SobjectType, String RecordTypeName) 
    {
        if(recordTypeMap.isEmpty()) 
        {
            List<RecordType> recordTypeList = [SELECT Id, Name,DeveloperName,SobjectType FROM RecordType WHERE IsActive = true ORDER BY SobjectType];
            for(RecordType recordType : recordTypeList) {
                if(recordTypeMap.containsKey(recordType.SobjectType)) 
                {
                    recordTypeMap.get(recordType.SobjectType).put(recordType.DeveloperName,recordType.Id);
                } else 
                {
                    recordTypeMap.put(recordType.SobjectType, new Map<String,Id>{recordType.DeveloperName => recordType.Id});
                }
            }   
        }
        if(recordTypeMap.containsKey(SobjectType)) {        
            return recordTypeMap.get(SobjectType).get(RecordTypeName);
        } else {
            return null;
        } 
    }
    /*************************************************
     * Input : Object Name
     * ouput : Object related API names as a string
     *************************************************/
     public static string getObjectFieldList ( string ObjectName )
     {
        string retString                = '';
        SObjectType objToken            =   Schema.getGlobalDescribe().get( ObjectName );
        DescribeSObjectResult objDef    =   objToken.getDescribe();
        Map<String, SObjectField> fields    =   objDef.fields.getMap(); 
       
        Set<String> fieldSet = fields.keySet();
         
        for(String s : fieldSet)
        {
            SObjectField fieldToken     = fields.get(s);
            DescribeFieldResult selectedField   = fieldToken.getDescribe();
            retString += selectedField.getName() + ',' ;
        }
        
        return retString.substring(0, retString.length()-1);
    }
    /*************************************************
     * Input : object ,picklist feild Name
     * ouput : picklist field values
     *************************************************/
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

            List<String> lstPickvals=new List<String>();
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
            Sobject Object_name = targetType.newSObject();
             Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
             Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
                Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
                List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
                for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
             lstPickvals.add(a.getValue());//add the value  to our final list
   }

         return lstPickvals;
        
    }
    
    public static boolean canBypassValidationsForClosedCase(String status){                           
        /* PPN-4971
        * 
        * If
        * 1.) Check to see if the Case status is one of the Closed Status values.                
        * 2.) If the user is a Supervisor allow Case Comment edit on closed case
        */        
        
        String closedCaseStatuses;       
        String closedCaseBypassProfile;  
        String[] tArray;
        boolean foundClosedCaseStatusMatch = false;
        boolean foundClosedCaseProfileMatch = false;
        
        
        /*
         * Add Custom Setting lookups for use with Closed Case Comment 
         * bypass for Supervisor roles.
         * i.e. Supervisors can add comments to Cases.
         */     
        CaseLockStatus__c clsObj = CaseLockStatus__c.getValues('ClosedCaseStatuses');            
        if(clsObj != null){
            closedCaseStatuses = clsObj.Status__c; 
            System.debug('Case Closed Statuses = ' + closedCaseStatuses);
        }  
        
        CaseProfile__c cpObj = CaseProfile__c.getValues('ClosedCaseBypass');            
        if(cpObj != null){
            closedCaseBypassProfile = cpObj.ProfileName__c; 
            System.debug('Closed Case Bypass Profile = ' + closedCaseBypassProfile);
        }     
        
        foundClosedCaseStatusMatch = valueInStringArray(status, closedCaseStatuses.split(','));
        foundClosedCaseProfileMatch= valueInStringArray(returnProfileName(), closedCaseBypassProfile.split(','));
        
        System.debug('Status and Profile compares = ' + foundClosedCaseStatusMatch + ' --- ' + foundClosedCaseProfileMatch);
        
        System.debug('Closed Case returns = ' + (foundClosedCaseStatusMatch && foundClosedCaseProfileMatch));
        return (foundClosedCaseStatusMatch && foundClosedCaseProfileMatch);
        
    }
    private static String returnProfileName(){        
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];           
        return profile[0].name;        
    }  
    
    private static boolean valueInStringArray(String value, String[] tArray){
        
        boolean foundMatch = false;
        
        for(String tString: tArray){
            
            System.debug('Data = ' + tString + ' = ' + value + '?');
            if(tString.equals(value)){                
                System.debug('Match = ' + tString + ' = ' + value  + '!');
                foundMatch = true;
            }                        
        }        
        
        return foundMatch;
               
    }    
    
    
    
    
    
    
}