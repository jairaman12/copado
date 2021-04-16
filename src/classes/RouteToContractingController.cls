public class RouteToContractingController 
{
    @AuraEnabled
    public Static String getContractingCaseOwnerUpdate(Id caseRecId)
    {
        Map<String,DefaultQueueSettings__c> defaultQueueSettingsMap =   new Map<String,DefaultQueueSettings__c>();
        String statusString     =   '';
        Case recToUpdate;
        //Set<String> profileSet  =   new Set<String>{'Supervisor','Provider Data Rep','PNC Profile','System Administrator','Montana Supervisor'};
        Id userprofileId        =   UserInfo.getProfileId();
        String profileName      =   [Select Id,Name from Profile where Id=:userprofileId].Name;
        Set<String> profileSet	=	new Set<String>();
        
        // Preparing Contracting queues data from custom seetings
        for( DefaultQueueSettings__c queueSetting : DefaultQueueSettings__c.getall().values() )
        {
            if(queueSetting.IsContractingQueue__c)
            {
                defaultQueueSettingsMap.put( queueSetting.PlanId__c,queueSetting );
            } 
        }
        
        // Getting authorized users profile information from GlobalSettings custom setting object
         GlobalSettings__c gs	=   GlobalSettings__c.getValues('PFFileRecieved');
         profileSet.addAll(gs.Authorized_Profiles_To_Route_Contracting__c.split(';'));
        
         System.debug('caseId===>>>>'+caseRecId);
         System.debug('profileName===>>>'+profileName);
         System.debug('defaultQueueSettingsMap===>>>'+defaultQueueSettingsMap);
         //System.debug(defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c +'#####'+caseRecord.OwnerId);
        
        Case caseRecord         =   [ Select CaseNumber,Id,Origin,OwnerId,Owner.Name,Plan_Id__c,Status,IsClosed from Case where Id=:caseRecId ];
        if( caseRecord!=null && profileSet.contains( profileName ) ) // contion to validate whether the user can change the case owner to contracting Queue or  not 
        {
            // Condition to validate the case staus 
            if( !defaultQueueSettingsMap.isEmpty()
                && defaultQueueSettingsMap.containsKey( caseRecord.Plan_Id__c ) 
                && defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c != caseRecord.OwnerId
                && !caseRecord.IsClosed
                && caseRecord.Status!= 'Prod Verification'
              )
            {
                System.debug('In side Case update===>>>'+caseRecord.Id);
                recToUpdate             	=   new Case( Id = caseRecord.Id );
                recToUpdate.OwnerId     	=   defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c;
                
            }else if( caseRecord.IsClosed && caseRecord.Status!= 'Prod Verification' )
            {
                System.debug('In side Closed case condition===>>>'+caseRecord.Id);
                statusString				=	System.Label.Contracting_Case_Closed_Satus_Validation;
            }else if(defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c != caseRecord.OwnerId
                    && caseRecord.Status	==	'Prod Verification')
            {
                System.debug('In side Prod verification condition===>>>'+caseRecord.Id);
                statusString				=	System.Label.Contracting_Case_Prod_Verification_Qeueue;   
            }else if (defaultQueueSettingsMap.containsKey( caseRecord.Plan_Id__c ) 
                      && defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c == caseRecord.OwnerId 
                      && !caseRecord.IsClosed )
            {
                statusString				=	System.Label.Contracting_Case_Queue_Validation;
            }
            
        }else{
            System.debug('In side user validation condtion===>>>');
            statusString = 	System.Label.Contracting_Case_User_Validation;
        }
        
        System.debug('recToUpdate===>>>'+recToUpdate);
        if(recToUpdate!= null){
            try{
                Database.SaveResult sr  =   Database.update( recToUpdate );
                if(sr.isSuccess()){
                    statusString 		=	'Success';
                }
            }Catch(Exception e){
                statusString			=	System.Label.Status_Failed_Error_Message +e.getMessage();
            }
        }
        
        return statusString;
    }
}