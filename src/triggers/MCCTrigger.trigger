/**************************************************************************************************
Apex Class Name  : MCCTrigger
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru,        05/17/2018               PPN-16123
* Travis Self                        
***************************************************************************************************/
trigger MCCTrigger on MCC_Data_Object__c ( before insert , 
                                          before update, 
                                          before delete,  
                                          after insert, 
                                          after update, 
                                          after delete, 
                                          after undelete
                                         ) 
{
    MCCTriggerHandler handler   =   new MCCTriggerHandler();
     Boolean isTriggerOff = GlobalSettings__c.getvalues('PFFileRecieved').MCC_trigger_switch__c;
    
    if( isTriggerOff == false )
    {
        if(Trigger.IsBefore)
        {
            System.debug('Beofre trigeer===>>>>'+Trigger.new);
        }
    
        if( Trigger.isAfter)
        {   
            if(Trigger.isInsert) 
            {
            handler.onAfterInsert(Trigger.new);
            }
        }
         if( Trigger.isBefore)
        {   
            if(Trigger.isInsert) 
            {
            handler.onBeforeInsert(Trigger.new);
            }
        }
    }
}