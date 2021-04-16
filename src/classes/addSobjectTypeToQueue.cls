/**************************************************************************************************
Apex Class Name  : addSobjectTypeToQueue
Version          : 1.0  
Functionality    : Add required Sobject types to corresponding Queue
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Sep 8,2017              Code Logic For PPN-5272
* Jacquline                  April 20,2018           Code Logic For PPN-11726
* Sreekanth 				 Sep 07,2018				 Code logic for PPN-22916 
***************************************************************************************************/
public class addSobjectTypeToQueue implements Queueable {
    list<Id> prosIds;
    Id omniRecId;
    Id id;
    list<Case> flist;
   // String caseType;
    
    public addSobjectTypeToQueue(List<Id> prosIds, Id id, Id omniRecId,list<Case> flist ) {
        this.prosIds = prosIds;
        this.omniRecId = omniRecId;
        this.Id = id;
        this.flist = flist;
        //this.caseType = caseType;
    }
    
    public void execute(QueueableContext qc) {
        List<QueuesObject> qSobjectList     =   new List<QueuesObject>();
        QueuesObject  qSobject              =   new QueuesObject (SobjectType ='Case', QueueId=id);
        qSobjectList.add(qSobject);
        QueuesObject  qSobject2             =   new QueuesObject (SobjectType ='OMNI_Queue__c', QueueId=id);
        qSobjectList.add(qSobject2);     
        insert qSobjectList;  
         if(!Test.isRunningTest())
       {
        ID jobID = System.enqueueJob(new updateExistingCases(prosIds,Id,omniRecId,flist)); 
       }
    }
    
}