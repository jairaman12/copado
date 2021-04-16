trigger CaseTrigger on Case (after delete, 
                             after insert, 
                             after undelete, 
                             after update, 
                             before delete, 
                             before insert, 
                             before update) 
                             {
    
                                 
        CaseTriggerHandler TriggerHandler = new CaseTriggerHandler();
        Boolean isTriggerOff = GlobalSettings__c.getvalues('PFFileRecieved').Case_Trigger_Switch__c;
        if( isTriggerOff == false )
        {
            // As trigger is not optimised to handle bulk records, this is a temporary fix to avoid trigger run for bulk record updates
            if((Trigger.isUpdate || Trigger.isInsert) && Trigger.new.size() > 20 && (Label.doNotRunCaseTrigger == 'true' || Test.isrunningTest())){
                return;
            }                     
            TriggerFactory.createHandler(Case.sObjectType);
        }
                                 
                                  /*
     * Author : Ashok N
     * Date  :01/18/2019
     * Ver :1.0
     * Business purpouse : Used to track the history of the fields on Case and insert in Credentialing_Comments_History__c object
     * PPN-30357 
     */
       
                                 
                                 if(Trigger.Isupdate && Trigger.isAfter)
                                 {
                                     //TriggerHandler.CommentHistoryTracking(Trigger.OldMap, Trigger.NewMap);        
                                 }

                                  if(Trigger.isInsert && Trigger.isAfter)
                                 {
                                     TriggerHandler.UpdateCRMCaseNumber(Trigger.New, Trigger.OldMap);        
                                 }
                                  if(Trigger.isUpdate && Trigger.isAfter)
                                 {
                                     TriggerHandler.UpdateCredentialingCaseNumber(Trigger.New, Trigger.OldMap);        
                                 }
                                   if(Trigger.isUpdate && Trigger.isBefore)
                                 {
                                     TriggerHandler.NetworkEffDateCheck(Trigger.New, Trigger.OldMap);   //PPN-46322     
                                 }


}