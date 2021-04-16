/**************************************************************************************************
Apex Class Name  : addProcessorsToQueue
Version          : 1.0  
Functionality    : Add users specified on OMNI_User_Group__c to corresponding Queue
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Sep 8,2017              Code Logic For PPN-5272
***************************************************************************************************/
public class addProcessorsToQueue implements Queueable {
    list<Id> prosIds;
    Id omniRecId;
    Id id;
    
    public addProcessorsToQueue(List<Id> prosIds, Id id, Id omniRecId) {
        this.prosIds = prosIds;
        this.omniRecId = omniRecId;
        this.Id = id;
    }
    
    public void execute(QueueableContext qc) {
        List<sobject> scope = new list<sobject>();
        sobject s = (sobject)[select id,ownerid from omni_queue__C where id = :omniRecId];
        scope.add(s);
        system.debug('s:' + s);
        Database.BatchableContext BC;
        OMNIUserRecalculation cls = new OMNIUserRecalculation();
        cls.execute(BC, scope);
    }
    
}