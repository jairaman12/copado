/**************************************************************************************************
Apex Class Name  : OMNIUserRecalculation
Version          : 1.0  
Functionality    : Daily job to go through the users for OMNI rules available on OMNI_Queue__c object
and assign them to corresponding Queues
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Sep 8, 2017            Code Logic For PPN-5272
* Sreekanth Kalluru(i364191) March 21, 2019         PPN - 29304
***************************************************************************************************/
//Batch Job for Processing the Records
global class OMNIUserRecalculation implements Database.Batchable<sobject>
{
        global String [] email          =       new String[] {'ProviderIntakeDev@bcbstx.com'};//Add here your email address here
        public Map<Id,User> userMap     =       new Map<Id,User>();
        
        public OMNIUserRecalculation()
        {
            for(User userRecord : [Select Id,isActive,Name from User where isActive=true])
            {
                userMap.put(userRecord.id, userRecord);
            }
        }
        
        //Start Method
        global Database.Querylocator start (Database.BatchableContext BC) 
       {
            return Database.getQueryLocator('select id,OwnerId from OMNI_Queue__c');
       }
    
    //Execute method
    global void execute (Database.BatchableContext BC, List<sobject> scope) 
    {
        list<OMNI_Queue__c> OMNIq   =   (list<OMNI_Queue__c>)scope;        
        list<OMNI_Queue__c> qlist   =   [select id,OwnerId from OMNI_Queue__c where Id in :OMNIq];  
        set<id> qids                =   new set<id>();
        
        for(OMNI_Queue__c o: qlist)
        {
            qids.add(o.ownerid);
        }  
        list<Group> queueIds        =   [select id from Group where id in :qids];
        /*set<Id> dids              =   new set<Id>();
        
        for(Group g: DeleteQueue)
        {
            dids.add(g.id);
        } */
        list<GroupMember> queueMembers  =   [select id from GroupMember where GroupId IN :queueIds]; 
        try{
            system.debug('About to be deleted: queueMembers:' + queueMembers);
            Delete queueMembers;  
        }catch(exception e){
            system.debug('Exception:' + e);
        }
        
        String[] splitvalue;
        List<OMNI_User_Group__c> OMNIg      =   new List<OMNI_User_Group__c>();
        Datetime GMTDate                    =   system.now();
        String strConvertedDate             =   GMTDate.format('yyyy-MM-dd','America/Chicago');
        String strConvertedDate2            =   GMTDate.format('yyyy-MM-dd HH:mm:ss','America/Chicago');
        Datetime dttm                       =   DateTIME.valueof(strConvertedDate2);
        Date dt                             =   Date.valueof(strConvertedDate);
        List<GroupMember> memToBeAdded      =   new List<GroupMember>();
        GroupMember tempmem                 =   new GroupMember();
        
        system.debug('OMNIq:' + OMNIq);
        for(OMNI_Queue__c q: OMNIq)
        {
            OMNIg       =   new list<OMNI_User_Group__c>();
            OMNIg       =   [Select id, Selected_User_Ids__c From OMNI_User_Group__c where  Group__c = :q.id and Active__c = true 
                             and Start_Date__c <= :dt and End_Date__c >= :dt and Week_Days__c includes (:dttm.format('EEEE'))]; 
            system.debug('q.id:' + q.id);
            system.debug('OMNIg:' + OMNIg);
            for(OMNI_User_Group__c g:OMNIg)
            {
                splitvalue      =   g.Selected_User_Ids__c.split(','); 
                system.debug('splitvalue:' + splitvalue);
                for(string s:splitvalue)
                {
                    id userId               =   (id)s;
                    if(userMap.containsKey( userId ) && userMap.get(userId).isActive )
                    {
                        System.debug(userId+'<<<===id===>>>'+s);
                        tempmem                 =   new GroupMember();
                        tempmem.UserOrGroupId   =   userId;
                        tempmem.GroupId         =   q.ownerid;
                        memToBeAdded.add( tempmem );   
                        system.debug('memToBeAdded:' + memToBeAdded);
                    }
                }
            }
        }
        try{
            system.debug('about to be inserted' + memToBeAdded);
            insert memToBeAdded;            
        } catch(exception e){
            system.debug('Exception:' + e);
        }
        
        
        
    }
    
    //Finish Method
    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Below code will fetch the job Id
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];//get the job Id
        System.debug('$$$ Jobid is'+BC.getJobId());
        
        //below code will send an email to User about the status
        mail.setToAddresses(email);
        mail.setReplyTo('laxman_rao_vattam@bcbsil.com');//Add here your email address
        mail.setSenderDisplayName('Apex Batch Processing Module');
        mail.setSubject('UAT : OMNI Batch Processing '+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures '+'Job Item processed are '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }
}