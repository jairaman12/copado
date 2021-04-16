/******************************
Apex Class Name     : CLM_Illinois_ReimbursementHandler
Version             : 1.0
Function            : This is a handler class for CLM_Reimbursement trigger which handles the defaulting and removal
                      of default values in the reimbursement section when the conditions meet and when they are no longer
                      satisfied respectively


Developer                  Date                                
------------------------------------------------------------------------------------- 
Piyush Bhardwaj           6/26/2019  

******************************/

public class CLM_Illinois_ReimbursementHandler 
{   
    //Method that takes in a list of agreements and Agreements old Map and Agreements new map
    public static void beforeUpdate(List<Apttus__APTS_Agreement__c>agreementList ,Map<Id,Apttus__APTS_Agreement__c> agreementOldMap,Map<Id,Apttus__APTS_Agreement__c> agreementNewMap)
    { 
        List<Apttus__APTS_Agreement__c> illinoisAgreementLis = new List<Apttus__APTS_Agreement__c>();
        //Running the loop to go through all the agreements
        for(Apttus__APTS_Agreement__c  agreementObj : agreementList)
        {
            Apttus__APTS_Agreement__c agreementObjOld = agreementOldMap.get(agreementObj.Id);
            
            //Checking if agreement plan belongs to Illiinois
            if(agreementObj.Plan__c == CLM_ReimbursementModel.Illinois_PLAN)
            {
                // Logic to Default the value for Percent of Covered Charge Field
                if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_HMO_Provider_Network) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_PPO_Provider_Network)))
                {
                    if(agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_HMO_Provider_Network) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_PPO_Provider_Network)))
                    {
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = false;
                           agreementObj.Percent_of_Covered_Charges__c = 100;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;
                    }
                }
            
            
                // Logic to Clear field values for Percent of Covered Charges Field  
                if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_HMO_Provider_Network) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_PPO_Provider_Network)))
                {
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)                       
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_HMO_Provider_Network) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.IL_Medicare_Advantage_PPO_Provider_Network)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c))
                    {                         
                           agreementObj.Percent_of_Covered_Charges__c = null;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;                          
                    }
                }    
            }

 /*********************************************
 Function            : This part of the code updated the Agreement E-signature status based on recall eSignature

Developer                  Date                                
------------------------------------------------------------------------------------- 
Chaitanya Motupalli        08/20/2019 
**********************************************/                
             if(agreementObj.Apttus__Status__c!='Other Party Signatures') 
            {
                agreementObj.CLM_Agr_E_Signature_Status__c=null;
            }    
		}
    }
}