/**************************************************************************************************
@Apex Class Name  : updatePendingServiceRequest
@Version          : 1.0  
@Functionality    : update case creation date on PendingServiceRouting
@Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru           02/26/2018             Code Logic For PPN-12332
***************************************************************************************************/
public class updatePendingServiceRequest implements Queueable{
    
    Set<id> workitemIds;
    private static Set<Id> processedRecords              =   new Set<Id>();
    public updatePendingServiceRequest( Set<id> workitemIds ){
        this.workitemIds    =   workitemIds;
    }
  
     public void execute(QueueableContext qc) {
       System.debug('QueueableContext====>>>>'+qc);
       Map<Id,Case> caseMap                     =   new Map<Id,Case>([Select id,CaseNumber,CreatedDate,OwnerId from case where Id IN: workItemIds]);
       List<PendingServiceRouting> newList  =   [Select Id,WorkItemId from PendingServiceRouting Where WorkItemId IN: workItemIds ];  
       List<PendingServiceRouting> recordsToUpdated = new List<PendingServiceRouting>();     
        
        for( PendingServiceRouting psr : newList ){
            if(caseMap.containsKey(psr.WorkItemId)){
                PendingServiceRouting psr1      =   new PendingServiceRouting( Id = psr.Id );
                psr1.CustomRequestedDateTime    =   caseMap.get(psr.WorkItemId).CreatedDate;
                recordsToUpdated.add( psr1 );
            }
        }
       System.debug('Inside Pending ServiceRequest====>>>>'+recordsToUpdated.size());
       if(!recordsToUpdated.isEmpty()){
            update recordsToUpdated;
        }    
    }
}