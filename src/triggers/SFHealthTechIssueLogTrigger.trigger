/**
 * Trigger for SFHealthTechIssueLog__c object.
 * <p /><p />
 * @author Josh McGhee
 */
trigger SFHealthTechIssueLogTrigger on SFHealthTechIssueLog__c (before insert, before update) {
    
    //If triggered before an insert, calls the handler's beforeInsert method
    //to change owner to SFHealthTechIssueLogQueue; else, if triggered before
    //an update, calls handler's beforeUpdate method.
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            SFHealthTechIssueLogTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            SFHealthTechIssueLogTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }  
    }
}