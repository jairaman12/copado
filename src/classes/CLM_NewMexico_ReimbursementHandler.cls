public class CLM_NewMexico_ReimbursementHandler {
    
    
    
    public static void beforeUpdate(List<Apttus__APTS_Agreement__c>agreementList ,Map<Id,Apttus__APTS_Agreement__c> agreementOldMap,Map<Id,Apttus__APTS_Agreement__c> agreementNewMap){ 
        List<Apttus__APTS_Agreement__c> mexicoAgreementLis = new List<Apttus__APTS_Agreement__c>();
        for(Apttus__APTS_Agreement__c  agreementObj : agreementList){
           Apttus__APTS_Agreement__c agreementObjOld = agreementOldMap.get(agreementObj.Id);
            
          if(agreementObj.Plan__c == CLM_ReimbursementModel.NEW_MEXICO_PLAN){
            if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Service_Type__c != null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId )){
                // HMO Advantage Start
                if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK)){
                    if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK))
                       || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && agreementObjOld.Provider_Service_Type__c == null)){
                           agreementObj.MA_HMO_lesser_of_of_Medicare_allowed__c = 100;
                           agreementObj.MA_HMO_lesser_of_of_Covered__c = 100;
                       }
                }
                // HMO Advantage End
                
                // PPO Advantage Start
                if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)){
                    if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))
                       || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && agreementObjOld.Provider_Service_Type__c == null) ){   
                           agreementObj.MA_PPO_lesser_of_of_Medicare_allowed__c = 100;                            
                           agreementObj.MA_PPO_lesser_of_of_Covered__c = 100;
                       }
                 }
             }
                // PPO Advantage End
             
            // 
            // Clear values
            // HMO Advantage Starts
              if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK)){
                  if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId)) 
                            ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)
                            || (agreementObj.Provider_Networks__c != null &&  !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId))){
                                agreementObj.MA_HMO_lesser_of_of_Medicare_allowed__c = null;
                                agreementObj.MA_HMO_lesser_of_of_Covered__c = null;      
                  }
              }
            // HMO Advantage ends
            
            // PPO Advantage Starts
                
               if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)){ 
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId)) 
                          ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c) 
                          ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId ))){
                              agreementObj.MA_PPO_lesser_of_of_Medicare_allowed__c = null;
                              agreementObj.MA_PPO_lesser_of_of_Covered__c = null;       
                       }
                     }
             // PPO Advantage Ends
          }              
            
            //  Common logic end
            
            // Specific to New Mexicon plan
            if(agreementObj.Plan__c == CLM_ReimbursementModel.NEW_MEXICO_PLAN){
                
              // Deafulting Percent of Covered Charges List  
                if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                    if(agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = false;
                           agreementObj.Percent_of_Covered_Charges__c = 100;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;
                       }
                } 
                
               // Clear field values for Percent of Covered Charges Field  
                if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)                       
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){                         
                           agreementObj.Percent_of_Covered_Charges__c = null;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;                          
                       }
                }
                
                // Common logic for 
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.facilityRecordTypeId){
                    
                            
                            
                    // Medicaid Start - Rehab
                    if( agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObj.Provider_Service_Type__c != null && agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_REHAB)){
                        if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK))
                           || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_REHAB))) ){
                               // Reimbursement section start
                               //if(agreementObj.Acute_Inpatient_Rehab_Per_Diem__c == null)
                               agreementObj.Acute_Inpatient_Rehab_Per_Diem__c = 785.00;
                               // Payment section start
                               //if(agreementObj.Excluded_Services_Per_Treatment_Amount__c  == null)
                               agreementObj.Excluded_Services_Per_Treatment_Amount__c = 375.00;
                               //if(agreementObj.Single_Outpatient_Rehab_per_unit__c == null)     
                               agreementObj.Single_Outpatient_Rehab_per_unit__c = 20.9;
                           }
                    }
                    // Medicaid End - Rehab
                      
                   
                   // Medicaid Start - Facility Acute care 
                    if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE)){
                        if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.startsWith('NM')){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.startsWith('NM') )
                              || agreementObjOld.Provider_Networks__c.startsWith('NM') && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE))){
                         // Reimbursement section start for all the facility provider networks of New Mexico
                         		//if(agreementObj.Charge_Master_Max_Increase_percent__c  == null)
                                	agreementObj.Charge_Master_Max_Increase_percent__c = 'five percent (5%)';
                            }
  
                        }
                        
                        if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE))){
                             // Reimbursement section start 
                             	
                                	agreementObj.Stoploss_Reimbursement_Rate__c = 41;
                             // Payment section start 
                          
                                	agreementObj.Stoploss_Threshold__c = 100000;
                          
                                	agreementObj.Blue_Salud__c = 3313.59;
                            
                                    agreementObj.ICR__c = 1872.13;
                            }
                        
                        }
                        
                    }
                   
                    //  Medicaid End - Facility Acute care 
                    
                    // Clear values for rehab
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_REHAB)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_REHAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              
                               
                                        agreementObj.Acute_Inpatient_Rehab_Per_Diem__c = null;
                                        agreementObj.Excluded_Services_Per_Treatment_Amount__c = null;
                                        agreementObj.Single_Outpatient_Rehab_per_unit__c = null;
                           }
                    }
                    
                  // Clear values for Acute
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              
                               
                              
                                   			agreementObj.Stoploss_Reimbursement_Rate__c = null;
                                     		agreementObj.Stoploss_Threshold__c = null;
                                            agreementObj.Blue_Salud__c = null;
                                            agreementObj.ICR__c = null;  
                           }
                    }
                    
				/*if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.startsWith('NM')){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c)
                       ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                       ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.startsWith('NM') && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){
                                    agreementObj.Charge_Master_Max_Increase_percent__c = null;

                    }
                }*/
 
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.startsWith('NM') && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE)){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c)
                       ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                       ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.startsWith('NM') && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                       ||  (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_ACUTE_CARE) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                                    agreementObj.Charge_Master_Max_Increase_percent__c = null;

                    }
                }
                }
                
                // Non-ASC Ancillary Record type - Reimbursement
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.ANCRecordTypeId){
                    if(agreementObj.Provider_Service_Type__c != null &&
                            (agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.BIRTHING_CENTER)
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME_W_POWER_MOBILITY)
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME_WO_POWER_MOBILITY)
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)
                             /* 
                             ( agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DIALYSIS) 
                                  ||  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.HOME_HEALTH)
                                  ||  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.HOSPICE)
                                  ||  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)
                                  ||  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.HOME_INFUSION)
                                  ||  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.HOME_HEALTH_AND_HOSPICE))*/
                            )){
                                 
                         if(agreementObj.Provider_Networks__c != null){
                            
                         
                            // ANC - Medicaid Start
                            if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){
                                if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK))
                                  || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || (!agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.BIRTHING_CENTER) && !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME_W_POWER_MOBILITY) && !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME_WO_POWER_MOBILITY) && !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB))   )) {
                            // Reimbursement section start
                                 
                                    agreementObj.of_Medicaid_fee_schedule__c = 100;
                                
                                }
                            }
                             
                           // ANC - Medicaid End
                                 
                         }
                      }              
                    
                        
                     // Clear values
                     // 
                   if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){  
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c ) 
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           ||  (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.BIRTHING_CENTER) && !agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME_W_POWER_MOBILITY) && !agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME_WO_POWER_MOBILITY) && !agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                                     agreementObj.of_Medicaid_fee_schedule__c = null;
    
                        }
                   }      
                 
               
                       
            }
                
                // ASC Record type - Reimbursement
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId){
                                                
                     
                           
                        
                    
                }
                
                // MG Record type - Reimbursement
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.medicalRecordTypeId){
                    if(agreementObj.Provider_Service_Type__c != null &&  
                            (agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.MG_ANESTHESIA) 
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.MG_BEHAVIORAL) 
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.MG_CHIROPRACTIC) 
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.MG_PCP))){
                          
                         if(agreementObj.Provider_Networks__c != null){
                            // MG - Medicaid Start
                            if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){
                                if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK))
                                  || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && agreementObjOld.Provider_Service_Type__c == null) ){
                                 // Reimbursement section start
                                // if(agreementObj.of_Medicaid_fee_schedule__c == null)
                                    	agreementObj.of_Medicaid_fee_schedule__c = 100;
                                
                                }
                            }
                             
                           // MG - Medicaid End
                            
                         }
                                 
                      }  
                                 
               
                    
                     // Clear values
                     // 
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){  
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c ) 
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){
                                     agreementObj.of_Medicaid_fee_schedule__c = null;
    
                        } 
                    }
                   
                 
                    
                }
                
                // Professional Record type - Reimbursement
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.professionalRecordTypeId ){
                         if(agreementObj.Provider_Service_Type__c != null &&  
                            (agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.PROF_ANESTHESIA) 
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.PROF_BEHAVIORAL) 
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.PROF_CHIROPRACTIC) 
                             || agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.PROF_PCP))){
                          
                         if(agreementObj.Provider_Networks__c != null){
                            
                           // Professional - Medicaid Start
                            if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){
                                if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK))
                                  || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c) && agreementObjOld.Provider_Service_Type__c == null){
                                 // Reimbursement section start0
                                 // if(agreementObj.of_Medicaid_fee_schedule__c == null)
                                    	agreementObj.of_Medicaid_fee_schedule__c = 100;
                                
                                }
                            }
                             
                           // Professional - Medicaid End
                            
                        }
                        
                                 
                     }
                    
                     // Clear values
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK)){ 
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c ) 
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.NM_MEDICAID_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){
                                     agreementObj.of_Medicaid_fee_schedule__c = null;
     
                        } 
                    }
                    
                }
        } 
            // Oklahoma Plan start
            
            
                    

            }
        }
}