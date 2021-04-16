global class MCCCaseProviderUpdatebatch implements Database.Batchable<sobject>
{
     public MCCCaseProviderUpdatebatch( List<Case> caseList,List<MCC_Data_Object__c> mccdataList )
    {
    }
    
     global Database.QueryLocator start( Database.BatchableContext BC ) 
    {
        return null;
    }
    
     global void execute( Database.BatchableContext BC,List<MCC_Data_Object__c> mccList ) 
    {
    }
    
    global void finish( Database.BatchableContext BC )
    {
    }   
}