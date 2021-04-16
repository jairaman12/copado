trigger ProviderTaxTrigger on CM_Provider_Tax_Id__c (before insert,before update, after insert, after update,before delete,after delete) 
{
    TriggerFactory.createHandler(CM_Provider_Tax_Id__c.sObjectType);
}