/**************************************************************************************************
Apex Class Name  : updateOMNIQueue
Version          : 1.0  
Functionality    : Link OMNI_Queue__C record (OwnerID field) with corresponding Queue
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Sep 8,2017              Code Logic For PPN-5272
***************************************************************************************************/
public class updateOMNIQueue implements Queueable {
    list<Id> prosIds;
    Id omniRecId;
    Id id;
    public updateOMNIQueue (List<Id> prosIds, Id id, Id omniRecId) {      
        this.prosIds = prosIds;
        this.omniRecId = omniRecId;
        this.Id = id;
    }
    
    public void execute(QueueableContext qc) {
        OMNI_Queue__c omnirecForUpdate = new OMNI_Queue__c(Id=omniRecId);
        omnirecForUpdate.OwnerId       = id;
        update omnirecForUpdate; 
        if(prosids.size() > 0 && !Test.isRunningTest()){
            ID jobID = System.enqueueJob(new addProcessorstoQueue(prosIds,Id,omnirecId));
        }
    }

}