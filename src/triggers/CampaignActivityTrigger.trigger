/**
 * This is a trigger for the Campaign Activity object.
 * <p/><p/>
 * @author Travis Self
 */
trigger CampaignActivityTrigger on CampaignActivity__c (after insert) {

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            CampaignActivityTriggerHandler.onAfterInsert(Trigger.New);
        }
    }  
}