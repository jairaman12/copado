/**************************************************************************************************
Apex Class Name  : UpdatePendingServiceRequestRecord
Version          : 1.0  
Functionality    : This class used to update for updating the case creation date on 
                   PendingServiceRouting object to flip the Queue Priority based on CaseCreation date 
                   but not the case when it enters into Queue
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru           04/05/2019              Fixed FIFO of Cases to OMNI channel
***************************************************************************************************/
public class UpdatePendingServiceRequestRecord 
{
     @InvocableMethod(label='UpdatePendingServiceRequestRecord' description='UpdatePendingServicerequest record with Case creation date.')
    public static void updateEmailCaseOwner( List<PendingServiceRouting> pendingServiceRoutingList )
    {
        Set<Id> caseIdSet                               =   new Set<Id>();
        List<PendingServiceRouting> psrRecordsToUpdate  =   new List<PendingServiceRouting>();
        
        System.debug('pendingServiceRoutingList===>'+pendingServiceRoutingList);
        if(!pendingServiceRoutingList.isEmpty()){
            for(PendingServiceRouting psr:pendingServiceRoutingList)
            {
                caseIdSet.add(psr.WorkItemId);
                System.debug(psr.CustomRequestedDateTime+'psr===>>>'+psr.WorkItemId);
            }
            if(!caseIdSet.isEmpty() && !pendingServiceRoutingList.isEmpty())
            {
                Map<Id,Case> caseMap    =   new Map<Id,Case>([SELECT Id,CaseNumber,Plan_Id__c,createdDate FROM Case where Id IN :caseIdSet]);
                for( PendingServiceRouting psrRecord : pendingServiceRoutingList )
                {
                    if( caseMap.containsKey( psrRecord.WorkItemId ) 
                       && caseMap.get(psrRecord.WorkItemId).createdDate!= psrRecord.CustomRequestedDateTime
                      ){
                          PendingServiceRouting psrRec      =   new PendingServiceRouting( id = psrRecord.Id );
                          psrRec.CustomRequestedDateTime    =   caseMap.get(psrRecord.WorkItemId).createdDate;
                          psrRecordsToUpdate.add( psrRec );
                      }
                }
            }
        }
        
        if(!psrRecordsToUpdate.isEmpty()){
            try{
                update psrRecordsToUpdate;
            }catch(Exception e){
                System.debug('Error message in PendingServiceRequest'+e.getMessage());
            }
        }
    }
}