public class CLM_Montana_ReimbursementHandler {
    public static void beforeUpdate(List<Apttus__APTS_Agreement__c>agreementList ,Map<Id,Apttus__APTS_Agreement__c> agreementOldMap,Map<Id,Apttus__APTS_Agreement__c> agreementNewMap){ 
        List<Apttus__APTS_Agreement__c> montanaAgreementLis = new List<Apttus__APTS_Agreement__c>();
        for(Apttus__APTS_Agreement__c  agreementObj : agreementList){
           Apttus__APTS_Agreement__c agreementObjOld = agreementOldMap.get(agreementObj.Id);  
            
            // Defaulting the value for Percent of covered charge field
            if(agreementObj.Plan__c == CLM_ReimbursementModel.Montana_PLAN){
                if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_HMO_Provider_Network) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_PPO_Provider_Network))){
                    if(agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_HMO_Provider_Network) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_PPO_Provider_Network))){
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = false;
                           agreementObj.Percent_of_Covered_Charges__c = 100;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;
                       }
                }
            
            
                     // Clear field values for Percent of Covered Charges Field  
                if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_HMO_Provider_Network) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_PPO_Provider_Network))){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)                       
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_HMO_Provider_Network) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.MT_Medicare_Advantage_PPO_Provider_Network)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){                         
                           agreementObj.Percent_of_Covered_Charges__c = null;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;                          
                       }
                }
            }

		}
    }
}