/**************************************************************************************************
Apex Class Name  : updateExistingCases
Version          : 1.0  
Functionality    : Add users specified on OMNI_User_Group__c to corresponding Queue
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Sep 8,2017              Code Logic For PPN-5272
* Jacquline                  April 20, 2018          Code Logic For PPN-11726
* Sreekanth K				 Sep 07, 2018            Code logic for PPN-22916 
***************************************************************************************************/
public class updateExistingCases implements Queueable {
    list<case> flist;
    Id id;
    list<Id> prosIds;
    Id omniRecId;
    String caseType;

    public updateExistingCases(List<Id> prosIds, Id id, Id omniRecId,list<Case> flist) {
         system.debug('-----start of updateExistingCases 0000----------' + flist);
        this.flist = flist;
        this.Id = id;
         this.prosIds = prosIds;
        this.omniRecId = omniRecId;
    }
    
    public void execute(QueueableContext qc) {
        system.debug('-----start of updateExistingCases----------' + id + ':' + flist);
        List<case> scope = new list<case>();
        scope = [select id,ownerid from case where id in :flist];
        system.debug('--------scope-------' + scope);
        for(Case c:scope){
            c.ownerid = id;
        }
        if(scope.size() > 0)
        	update scope;
       if(!Test.isRunningTest())
       {
        ID jobID = System.enqueueJob(new updateOMNIQueue(prosIds,Id,omniRecId));
       }
    }
    
}