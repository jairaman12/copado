/**************************************************************************************************
Apex Class Name  : DocuSignEVPRecipientStatusTrigger_CLM
Version          : 1.0  
Functionality    : This trigger is for 'Docusign Envelope recipient status' object.
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Chaitanya Motupalli        08/19/2019              PPN-54085,PPN-53513                    
***************************************************************************************************/
trigger DocuSignEVPRecipientStatusTrigger_CLM on Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c (after insert, 
                                                                                                     after update
                                                                                                     ) 
{
     if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
      {
          DocuSignEVPRecipientStatusHandler_CLM.UpdateEsignatureStatus(Trigger.new);
      }   
}