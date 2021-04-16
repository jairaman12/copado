public class RouteToDataEntryController 
{
	@AuraEnabled
    public static String getCaseMessage(Id caseRecId)
    {
        Map<String,DefaultQueueSettings__c> defaultQueueSettingsMap	=	new Map<String,DefaultQueueSettings__c>();
        String statusString	=	'';
        Case recToUpdate;
        
        for( DefaultQueueSettings__c queueSetting : DefaultQueueSettings__c.getall().values() )
        {
            if(queueSetting.IsDataEntryQueue__c)
            {
                defaultQueueSettingsMap.put( queueSetting.PlanId__c,queueSetting );
            } 
        }
        
        System.debug('caseId===>>>>'+caseRecId);
        Case caseRecord = [ Select CaseNumber,Id,Origin,OwnerId,Owner.Name,Plan_Id__c,Status,IsClosed from Case where Id=:caseRecId ];
        
        if(caseRecord != null && !defaultQueueSettingsMap.isEmpty())
        {
            if( defaultQueueSettingsMap.containsKey( caseRecord.Plan_Id__c ) 
                && defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c != caseRecord.OwnerId
                && !caseRecord.IsClosed
              )
            {
                recToUpdate				=	new Case( Id = caseRecord.Id );
                recToUpdate.OwnerId		=	defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c;
            }else if( defaultQueueSettingsMap.containsKey( caseRecord.Plan_Id__c ) 
                      && defaultQueueSettingsMap.get( caseRecord.Plan_Id__c ).QueueId__c == caseRecord.OwnerId 
                      && !caseRecord.IsClosed
                    )      
            {
                statusString			=	System.Label.DataEntryString; //Alert the user if case is already in a data netry Queue
            }else if ( caseRecord.IsClosed )
            {
                statusString			=	System.Label.DataEntry_Closed_Case;// Alert the user if a case already in a cloased status	 
            }
        }
        System.debug('recToUpdate===>>>'+recToUpdate);
        if(recToUpdate!= null){
            try{
                Database.SaveResult sr	=	Database.update( recToUpdate );
                if(sr.isSuccess()){
                    statusString 		= 	'Success';
                }
            }Catch(Exception e){
                statusString			=	System.Label.Status_Failed_Error_Message +e.getMessage();
            }
        }
       return statusString;
        
    }
}