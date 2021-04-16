/**
* Serves as test class for RoutingButtonsController.
* <p /><p />
* @author Josh McGhee
*/
public class RoutingButtonsController {
    
    /**
	* Assigns Case to Data Entry Queue
	*
	* @param caseRecId The current Case's Record Id.
	* @return Returns a string saying whether the method was successful.
	*/
    @AuraEnabled
    public static String getDataEntry(Id caseRecId)
    {
        String strStatus	=	'';
        Case objCaseRecord;
        Case objRecToUpdate;
        Map<String,DefaultQueueSettings__c> mapDefaultQueueSettings = new Map<String,DefaultQueueSettings__c>();
        
        for(DefaultQueueSettings__c objQueueSetting : DefaultQueueSettings__c.getall().values())
        {
            if(objQueueSetting.IsDataEntryQueue__c)
            {
                mapDefaultQueueSettings.put( objQueueSetting.PlanId__c,objQueueSetting );
            } 
        }
        
        System.debug('caseId===>>>>' + caseRecId);
        objCaseRecord = [SELECT CaseNumber,Id,Origin,OwnerId,Owner.Name,Plan_Id__c,Status,IsClosed FROM Case WHERE Id=:caseRecId ];
        
        if(objCaseRecord != null && !mapDefaultQueueSettings.isEmpty()) {
            
            if(mapDefaultQueueSettings.containsKey(objCaseRecord.Plan_Id__c) && 
               mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c != objCaseRecord.OwnerId && 
               !objCaseRecord.IsClosed) {
                   
                   objRecToUpdate = new Case(Id = objCaseRecord.Id);
                   objRecToUpdate.OwnerId = mapDefaultQueueSettings.get( objCaseRecord.Plan_Id__c ).QueueId__c;
                   
               } else if(mapDefaultQueueSettings.containsKey(objCaseRecord.Plan_Id__c) && 
                         mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c == objCaseRecord.OwnerId && 
                         !objCaseRecord.IsClosed) {
                             
                             //Alert the user if case is already in a data entry Queue
                             strStatus = System.Label.DataEntryString; 
                             
                         } else if(objCaseRecord.IsClosed) {
                             
                             //Alert the user if case is already in a closed status
                             strStatus = System.Label.DataEntry_Closed_Case; 	 
                         }
        }
        
        System.debug('objRecToUpdate===>>>' + objRecToUpdate);
        
        if(objRecToUpdate!= null) {
            try {
                Database.SaveResult objSaveResult = Database.update(objRecToUpdate);
                if(objSaveResult.isSuccess()) {
                    strStatus = 'Success';
                }
            } catch(Exception e) {
                strStatus = System.Label.Status_Failed_Error_Message +e.getMessage();
            }
        }
        return strStatus;
    }
    
    /**
	* Assigns Case to Contracting Queue
	*
	* @param caseRecId The current Case's Record Id.
	* @return Returns a string saying whether the method was successful.
	*/
    @AuraEnabled
    public Static String getContracting(Id caseRecId)
    {
        Id idUserProfile = UserInfo.getProfileId();
        String strProfileName = [SELECT Id,Name FROM Profile WHERE Id=:idUserProfile].Name;
        String strStatus = '';
        Case objRecToUpdate;
        GlobalSettings__c objGlobalSettings;
        Set<String> setProfile = new Set<String>();
        Map<String,DefaultQueueSettings__c> mapDefaultQueueSettings = new Map<String,DefaultQueueSettings__c>();
        
        // Preparing Contracting queues data from custom seetings
        for(DefaultQueueSettings__c objQueueSetting : DefaultQueueSettings__c.getall().values()) {
            
            if(objQueueSetting.IsContractingQueue__c) {
                
                mapDefaultQueueSettings.put(objQueueSetting.PlanId__c,objQueueSetting);
                
            } 
        }
        
        // Getting authorized users profile information from GlobalSettings custom setting object
        objGlobalSettings = GlobalSettings__c.getValues('PFFileRecieved');
        setProfile.addAll(objGlobalSettings.Authorized_Profiles_To_Route_Contracting__c.split(';'));
        
        System.debug('caseId===>>>>'+caseRecId);
        System.debug('strProfileName===>>>'+strProfileName);
        System.debug('mapDefaultQueueSettings===>>>'+mapDefaultQueueSettings);
        //System.debug(mapDefaultQueueSettings.get( objCaseRecord.Plan_Id__c ).QueueId__c +'#####'+objCaseRecord.OwnerId);
        
        Case objCaseRecord = [SELECT CaseNumber,Id,Origin,OwnerId,Owner.Name,Plan_Id__c,Status,IsClosed FROM Case WHERE Id=:caseRecId];
        
        //Checks whether the user can change the case owner to Contracting Queue
        if(objCaseRecord!=null && setProfile.contains(strProfileName)) {
            
            // Condition to validate the case staus 
            if(!mapDefaultQueueSettings.isEmpty() && mapDefaultQueueSettings.containsKey(objCaseRecord.Plan_Id__c) && 
               mapDefaultQueueSettings.get( objCaseRecord.Plan_Id__c ).QueueId__c != objCaseRecord.OwnerId && 
               !objCaseRecord.IsClosed && objCaseRecord.Status!= 'Prod Verification') {
                   
                System.debug('In side Case update===>>>'+objCaseRecord.Id);
                objRecToUpdate = new Case(Id = objCaseRecord.Id);
                objRecToUpdate.OwnerId = mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c;
                
            } else if(objCaseRecord.IsClosed && objCaseRecord.Status!= 'Prod Verification') {
                
                System.debug('In side Closed case condition===>>>'+objCaseRecord.Id);
                strStatus = System.Label.Contracting_Case_Closed_Satus_Validation;
                
            } else if(mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c != objCaseRecord.OwnerId && 
                      objCaseRecord.Status	==	'Prod Verification') {
                          
                System.debug('In side Prod verification condition===>>>'+objCaseRecord.Id);
                strStatus = System.Label.Contracting_Case_Prod_Verification_Qeueue;
                          
            } else if (mapDefaultQueueSettings.containsKey(objCaseRecord.Plan_Id__c) && 
                       mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c == objCaseRecord.OwnerId && 
                       !objCaseRecord.IsClosed) {
                           
                strStatus = System.Label.Contracting_Case_Queue_Validation;
                           
            }
            
        } else {
            System.debug('In side user validation condition===>>>');
            strStatus = System.Label.Contracting_Case_User_Validation;
        }
        
        System.debug('objRecToUpdate===>>>'+objRecToUpdate);
        if(objRecToUpdate!= null){
            try{
                Database.SaveResult objSaveResult = Database.update(objRecToUpdate);
                if(objSaveResult.isSuccess()){
                    strStatus = 'Success';
                }
            } Catch(Exception e) {
                strStatus = System.Label.Status_Failed_Error_Message +e.getMessage();
            }
        }
        
        return strStatus;
    }
    
    /**
	* Sets the Case's status to "Escalated" and changes the Case Owner.
	*
	* @param caseRecId The current Case's Record Id.
	* @return Returns a string saying whether the method was successful.
	*/
    @AuraEnabled
    public static String getEscalateCaseOwnerUpdate(Id caseRecId)
    {
        Id idUserProfile = UserInfo.getProfileId();
        String strProfileName = [SELECT Id,Name FROM Profile WHERE Id=:idUserProfile].Name;
        String strStatus = '';
        Case objRecToUpdate;
        Set<String> setProfile = new Set<String>{'Provider Data Rep','System Administrator'};
        Map<String,DefaultQueueSettings__c> mapDefaultQueueSettings = new Map<String,DefaultQueueSettings__c>(); 
        
        
        // Preparing Contracting queues data from custom seetings
        for(DefaultQueueSettings__c objQueueSetting : DefaultQueueSettings__c.getall().values()) {
            if(objQueueSetting.IsEscalateQueue__c) {
                mapDefaultQueueSettings.put(objQueueSetting.PlanId__c,objQueueSetting);
            } 
        }
        
        // Getting authorized users profile information from GlobalSettings custom setting object
        GlobalSettings__c objGlobalSettings = GlobalSettings__c.getValues('PFFileRecieved');
        setProfile.addAll(objGlobalSettings.Authorised_Profiles_To_Escalate_Case__c.split(';'));
        
        Case objCaseRecord = [SELECT CaseNumber,Id,Origin,OwnerId,Owner.Name,Plan_Id__c,Status,IsClosed FROM Case WHERE Id=:caseRecId];
        
        //Checks whether the user can change the case owner to Contracting Queue
        if(objCaseRecord!=null && setProfile.contains(strProfileName)) {
            // Condition to validate the case staus 
            if(!mapDefaultQueueSettings.isEmpty() && mapDefaultQueueSettings.containsKey(objCaseRecord.Plan_Id__c) && 
               mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c != objCaseRecord.OwnerId && 
               !objCaseRecord.IsClosed && objCaseRecord.Status!= 'Prod Verification') {
                   
                System.debug('In side Case update===>>>'+ objCaseRecord.Id);
                objRecToUpdate = new Case(Id = objCaseRecord.Id);
                objRecToUpdate.OwnerId = mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c;
                objRecToUpdate.Status = 'Escalated';
                   
            } else if(mapDefaultQueueSettings.containsKey(objCaseRecord.Plan_Id__c) && 
                      mapDefaultQueueSettings.get(objCaseRecord.Plan_Id__c).QueueId__c == objCaseRecord.OwnerId && 
                      !objCaseRecord.IsClosed) {
                          
                strStatus = System.Label.EscalateValidationString;
                          
            } else if(objCaseRecord.IsClosed) {
                
                strStatus = System.Label.Escalated_Case_Closed_Satus_Validation;
            }
            
        } else {
            strStatus = System.Label.Escalated_Case_User_Validation;
        }
        
        System.debug('objRecToUpdate===>>>'+objRecToUpdate);
        if(objRecToUpdate!= null) {
            try{
                Database.SaveResult objSaveResult  =   Database.update( objRecToUpdate );
                if(objSaveResult.isSuccess()) {
                    strStatus  = 'Success';
                }
            } Catch(Exception e) {
                strStatus = System.Label.Status_Failed_Error_Message +e.getMessage();
            }
        }
        return strStatus;
    }
    
    /**
	* Tests whether the Escalate button should render.
	*
	* @param caseRecId The current Case's Record Id.
	* @return Returns true if button should render; else, returns false.
	*/
    @AuraEnabled
    public Static Boolean showEscalate(Id caseRecId)
    {
        String strProfileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
        String strRecordTypeName = [SELECT Id, RecordType.DeveloperName FROM Case WHERE Id=:caseRecId LIMIT 1].RecordType.DeveloperName;
        
        //If PDM Case, returns true if Profile is approved; else, false.
        //If not PDM Case, returns false.
        if(strRecordTypeName == 'PDM'){
            if(strProfileName == 'Provider Data Rep' || strProfileName == 'System Administrator') {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
    
    /**
	* Tests whether the Route to Data Entry button should render.
	*
	* @param caseRecId The current Case's Record Id.
	* @return Returns true if button should render; else, returns false.
	*/
    @AuraEnabled
    public Static Boolean showDataEntry(Id caseRecId)
    {
        String strRecordTypeName = [SELECT Id, RecordType.DeveloperName FROM Case WHERE Id=:caseRecId LIMIT 1].RecordType.DeveloperName;       
        
        //Button should not show up on PDM Cases, so returns false if PDM Case.
        if(strRecordTypeName == 'PDM'){
            return false;
        } else {
            return true;
        }
    }
    
    /**
	* Tests whether the Route to Contracting button should render.
	*
	* @param caseRecId The current Case's Record Id.
	* @return Returns true if button should render; else, returns false.
	*/
    @AuraEnabled
    public Static Boolean showContracting(Id caseRecId)
    {
        String strProfileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
        String strRecordTypeName = [SELECT Id, RecordType.DeveloperName FROM Case WHERE Id=:caseRecId LIMIT 1].RecordType.DeveloperName;      
        
        //If PDM Case, returns true if Profile is approved; else, false. 
        //If not PDM case, returns true because the Lightning page only renders component on approved record types.
        if(strRecordTypeName == 'PDM'){
            if(strProfileName == 'Provider Data Rep' || strProfileName == 'PNC Profile' ||
               strProfileName == 'System Administrator' || strProfileName == 'Supervisor') {
                   return true;
               } else {
                   return false;
               }            
        } else {
            return true;
        }
    }
}