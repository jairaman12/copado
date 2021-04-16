/**************************************************************************************************
Apex Class Name  : DocusignEnvelopeTrigger_CLM
Version          : 1.0  
Functionality    : This trigger is for 'Docusign Envelope' object.
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Chaitanya Motupalli        08/19/2019              PPN-54084,PPN-51538                    
***************************************************************************************************/
trigger DocusignEnvelopeTrigger_CLM on Apttus_DocuApi__DocuSignEnvelope__c (after insert, 
                                                                            after update,
                                                                            before insert, 
                                                                            before update
                                                                           ) 
{
    
     if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
      {
       DocusignEnvelopeHandler_CLM.UpdateAgreementEsignatureStatus(Trigger.new);
      }
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
      {
       DocusignEnvelopeHandler_CLM.ClearAgreementEsignatureStatus(Trigger.new);
      }
     
    
}