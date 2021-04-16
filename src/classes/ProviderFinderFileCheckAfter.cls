/**************************************************************************************************
Apex Class Name  : ProviderFinderFileCheckAfter
Version          : 1.0  
Functionality    : Daily job to be run after the predicted time of PF file being sent to Salesforce. It will 
verify the flag on custom setting and if it is still false, it will send an email
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Oct 4, 2017            Code Logic For PPN-7236
***************************************************************************************************/

//Batch Job for Processing the Records
Public class ProviderFinderFileCheckAfter implements Database.Batchable<sobject>,Schedulable{
    Public String [] email = new String[] {Label.PFEmailNotification};
        Public String name = 'PFFileRecieved';
        
        //Start Method
        Public Database.Querylocator start (Database.BatchableContext BC) {
            return Database.getQueryLocator('select PFFileRecieved__c from GlobalSettings__c where Name = :name');
        }
    
    //Execute method
    Public void execute (Database.BatchableContext BC, List<sobject> scope) {              
        list<GlobalSettings__c> flag = (list<GlobalSettings__c>)scope;  
        system.debug('flag[0].PFFileRecieved__c:' + flag[0].PFFileRecieved__c);
        if(flag[0].PFFileRecieved__c == false){
            system.debug('Inside:');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            
            mail.setToAddresses(email);
            mail.setReplyTo(email[0]);//Add here your email address
            mail.setSenderDisplayName('Salesforce Admin');
            mail.setSubject('Prod : Salesforce: No Provider Finder Daily File received');
            mail.setPlainTextBody('Salesforce did not process a Provider Finder Daily File in the past 24 hours.');
            Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
        }
        
    }
    
    //Finish Method
    Public void finish(Database.BatchableContext BC){
        
    }
    
    Public void execute(SchedulableContext sc) {
        ProviderFinderFileCheckAfter b1 = new ProviderFinderFileCheckAfter();
        ID batchprocessid = Database.executeBatch(b1);           
    }
}