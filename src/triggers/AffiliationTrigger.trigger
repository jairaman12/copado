/**************************************************************************************************
Apex Class Name  : AffiliationTrigger
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/11/2018             PPN-17862      
***************************************************************************************************/
trigger AffiliationTrigger on Affiliations__c (before insert , 
                                               before update, 
                                               before delete,  
                                               after insert, 
                                               after update, 
                                               after delete, 
                                               after undelete) 
{
	AffiliationTriggerHandler	handler	=	new AffiliationTriggerHandler();
    
    Boolean isTriggerOff = GlobalSettings__c.getvalues('PFFileRecieved').Affiliation_Trigger_Switch__c;
     if( isTriggerOff == false )
    {
        if( Trigger.isBefore)
        {  
            if(Trigger.isInsert) 
            {
                handler.onBeforeInsert(Trigger.new);
            }else if(Trigger.isUpdate){
                handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
}