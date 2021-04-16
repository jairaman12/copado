/**************************************************************************************************
Apex Class Name  : DocuSignEVPRecipientStatusHandler_CLM
Version          : 1.0  
Functionality    : This class serves as a Handler class for "DocuSignEVPRecipientStatusTrigger_CLM" Trigger.
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Chaitanya Motupalli        08/19/2019              PPN-54085,PPN-53513                     
***************************************************************************************************/
public class DocuSignEVPRecipientStatusHandler_CLM
{
    
    /****
    * @input: List of DocuSignEnvelopeRecipientStatus object records
    * @output: Map of DocuSignEnvelope records updated
    * Business Purpose: update the fields on DocuSignEnvelope object based on DocuSignEnvelopeRecipientStatus object.
    * Story Number : PPN-54085,PPN-53513 
    * param : lstDocSRS
    ****/
    public static void UpdateEsignatureStatus(List<Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c >lstDocSRS)
    {     
        Map<ID, Apttus_DocuApi__DocuSignEnvelope__c> mapDocuSEVP = new Map<ID, Apttus_DocuApi__DocuSignEnvelope__c>(); 
        set<Id> setIds = new set<Id>();
        for (Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c relRec: lstDocSRS) 
        {
            setIds.add(relRec.Apttus_DocuApi__DocuSignEnvelopeId__c);
        }
        if(!setIds.isEmpty())
        {
            mapDocuSEVP = new Map<Id, Apttus_DocuApi__DocuSignEnvelope__c>([SELECT id,name,Apttus_DocuApi__Status__c,CLM_E_Signature_Status__c FROM
                                                                            Apttus_DocuApi__DocuSignEnvelope__c WHERE
                                                                            ID IN :setIds]);
        }
        for (Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c DocSRS: lstDocSRS)
        {
           Apttus_DocuApi__DocuSignEnvelope__c docusEVP = mapDocuSEVP.get(DocSRS.Apttus_DocuApi__DocuSignEnvelopeId__c);
           if(DocSRS.Apttus_DocuApi__RoleName__c=='Signer 3' && DocSRS.Apttus_DocuApi__Status__c=='completed')
            {
                docusEVP.CLM_E_Signature_Status__c=DocSRS.CLM_E_Signature_Status__c;
            }else if(DocSRS.Apttus_DocuApi__RoleName__c=='Signer 2' && DocSRS.Apttus_DocuApi__Status__c=='completed')
            {
                docusEVP.CLM_E_Signature_Status__c=DocSRS.CLM_E_Signature_Status__c;
            }
            else if(DocSRS.Apttus_DocuApi__RoleName__c=='Signer 1' && DocSRS.Apttus_DocuApi__Status__c=='completed')
            {
                docusEVP.CLM_E_Signature_Status__c=DocSRS.CLM_E_Signature_Status__c;
            }else if(DocSRS.Apttus_DocuApi__RoleName__c=='Signer 1' && DocSRS.Apttus_DocuApi__Status__c=='sent')
            {
                docusEVP.CLM_E_Signature_Status__c=DocSRS.CLM_E_Signature_Status__c;
            }  
         }
        if(!mapDocuSEVP.isEmpty())
        {
           update mapDocuSEVP.values();
        }
    }
}