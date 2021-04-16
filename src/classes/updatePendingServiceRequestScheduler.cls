/**************************************************************************************************
@Apex Class Name  : updatePendingServiceRequestScheduler
@Version          : 1.0  
@Functionality    : update case creation date on PendingServiceRouting
@Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/01/2018           Code Logic For PPN-16605
***************************************************************************************************/
public class updatePendingServiceRequestScheduler implements Schedulable
{
    Set<id> workitemIds;
    public updatePendingServiceRequestScheduler(Set<id> caseIds){
        this.workitemIds= caseIds;
    }   
    
    public void execute(System.SchedulableContext qc) 
    {
        System.enqueueJob(new updatePendingServiceRequest(workitemIds));
        // Abort the job once Queuabale class scheduled
        System.abortJob(qc.getTriggerId());
    }
}