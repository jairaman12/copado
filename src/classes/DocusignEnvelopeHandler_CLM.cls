/**************************************************************************************************
Apex Class Name  : DocusignEnvelopeHandler_CLM
Version          : 1.0  
Functionality    : This class serves as a Handler class for "DocusignEnvelopeTrigger_CLM" Trigger.
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Chaitanya Motupalli        08/19/2019              PPN-54084,PPN-51538                       
***************************************************************************************************/
public class DocusignEnvelopeHandler_CLM 
{
    /****
    * @input: List of DocuSignEnvelope object records
    * @output: Map of Agreement records updated
    * Business Purpose: update the fields on Agreement object based on DocuSignEnvelope object.
    * Story Number : PPN-54084,PPN-51538  
    * param : lstDocsignEnv
    ****/
    public static void UpdateAgreementEsignatureStatus(List<Apttus_DocuApi__DocuSignEnvelope__c >lstDocsignEnv)
    {  
        Map<ID, Apttus__APTS_Agreement__c> mapAgreements = new Map<ID, Apttus__APTS_Agreement__c>(); 
        set<Id> setIds = new set<Id>();
        for (Apttus_DocuApi__DocuSignEnvelope__c DocsEnv: lstDocsignEnv) 
        {
            setIds.add(DocsEnv.Apttus_CMDSign__Agreement__c);
        }
        if(!setIds.isEmpty())
        {
        mapAgreements = new Map<Id,Apttus__APTS_Agreement__c >([SELECT id,Apttus__Status__c,Apttus__Status_Category__c,name,CLM_Agr_E_Signature_Status__c FROM
                                                                Apttus__APTS_Agreement__c WHERE 
                                                                ID IN :setIds]);
        }
        for (Apttus_DocuApi__DocuSignEnvelope__c DocsEnv: lstDocsignEnv)
        {
            Apttus__APTS_Agreement__c agr = mapAgreements.get(DocsEnv.Apttus_CMDSign__Agreement__c);
            agr.CLM_Agr_E_Signature_Status__c=DocsEnv.CLM_E_Signature_Status__c;
        }
        if(!mapAgreements.isEmpty())
        {
          update mapAgreements.values();    
        }
    }
    public static void ClearAgreementEsignatureStatus(List<Apttus_DocuApi__DocuSignEnvelope__c >lstDocusigneve)
    {   
        for(Apttus_DocuApi__DocuSignEnvelope__c docu :lstDocusigneve)
        {
            if(docu.Agreement_status_CLM__c!='Other Party Signatures')
            {
                docu.CLM_E_Signature_Status__c=null;
            }
        }
    }
}