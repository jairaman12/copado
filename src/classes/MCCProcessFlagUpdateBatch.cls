/**************************************************************************************************
Apex Class Name  : MCCProcessFlagUpdateBatch
Version          : 1.0  
Functionality    : This batch class is used for to update processed records 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru           10/10/2018               
*******************************************************************************************************/
global class MCCProcessFlagUpdateBatch implements Database.Batchable<sobject>
{
    Set<String> mccRecordNameSetNew        =   new Set<String>();

    public MCCProcessFlagUpdateBatch( Set<String> mccRecordNameSet )
    {
        mccRecordNameSetNew.addAll( mccRecordNameSet );
    }
    
    global Database.QueryLocator start( Database.BatchableContext BC ) 
    {
        return DataBase.getQueryLocator([ SELECT Id,Name,RecordType.Name,MCC_Load_Status__c,Processed_for_reporting__c,MCC_File_Type__c,
                                         MCC_Case_Id__r.Plan_Id__c,MCC_Case_Id__c,MCC_Request_Type__c,MCC_File_Id__c,MCC_Plan_Id__c,mcc_case_status__c,
                                         File_Count__c FROM MCC_Data_Object__c where Name IN : mccRecordNameSetNew] ); 
    }
    
    
    global void execute( Database.BatchableContext BC,List<MCC_Data_Object__c> mccList ) 
    {
        List<MCC_Data_Object__c> mccRecordsProcessedForreporting		=	new List<MCC_Data_Object__c>();
        
        if( !mccList.isEmpty() )
        {
            for( MCC_Data_Object__c networkMCcRecord : mccList  )
            {
                MCC_Data_Object__c tempMCCNetworkRec 			=	new MCC_Data_Object__c( Id = networkMCcRecord.Id );
                tempMCCNetworkRec.Processed_for_reporting__c	=	true;
                mccRecordsProcessedForreporting.add( tempMCCNetworkRec ); 
            }
        }
        if(!mccRecordsProcessedForreporting.isEmpty())
        {
            update mccRecordsProcessedForreporting;
        }
    }
    
    global void finish( Database.BatchableContext BC )
    {
    }
}