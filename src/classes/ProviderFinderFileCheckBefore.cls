/**************************************************************************************************
Apex Class Name  : ProviderFinderFileCheckBefore
Version          : 1.0  
Functionality    : Daily job to be run before the predicted time of PF file being sent to Salesforce 
It will set the flag on custom setting 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Oct 4, 2017       		Code Logic For PPN-7236
***************************************************************************************************/

//Batch Job for Processing the Records
Public class ProviderFinderFileCheckBefore implements Database.Batchable<sobject>,Schedulable{
    
    Public String name = 'PFFileRecieved';
        
    //Start Method
    Public Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator('select PFFileRecieved__c from GlobalSettings__c where Name = :name');
    }
    
    //Execute method
    Public void execute (Database.BatchableContext BC, List<sobject> scope) {              
        list<GlobalSettings__c> flag = (list<GlobalSettings__c>)scope;    
        flag[0].PFFileRecieved__c = false;
        update flag;
    }
    
    //Finish Method
    Public void finish(Database.BatchableContext BC){
        
    }
    
    Public void execute(SchedulableContext sc) {
        ProviderFinderFileCheckBefore b1 = new ProviderFinderFileCheckBefore();
        ID batchprocessid = Database.executeBatch(b1);           
    }
}