public class CLM_Oklahoma_ReimbursementHandler {
	public static void beforeUpdate(List<Apttus__APTS_Agreement__c>agreementList ,Map<Id,Apttus__APTS_Agreement__c> agreementOldMap,Map<Id,Apttus__APTS_Agreement__c> agreementNewMap){ 
        List<Apttus__APTS_Agreement__c> oklahomaAgreementLis = new List<Apttus__APTS_Agreement__c>();
        for(Apttus__APTS_Agreement__c  agreementObj : agreementList){
           Apttus__APTS_Agreement__c agreementObjOld = agreementOldMap.get(agreementObj.Id);  
            
            
            if(agreementObj.Plan__c == CLM_ReimbursementModel.OKLAHOMA_PLAN){
              // Deafulting Percent of Covered Charges Field 
                if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                    if(agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = false;
                           agreementObj.Percent_of_Covered_Charges__c = 100;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;
                       }
                }     
                
              // Clear field values for Percent of Covered Charges Field
                   
                if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)                       
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){                         
                           agreementObj.Percent_of_Covered_Charges__c = null;
                           agreementObj.CLM_Bypass_PercentCoveredCharges__c = true;                          
                       }
                }
              // Common logic start
            
            if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Service_Type__c != null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId )){
                // HMO Advantage Start
                if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK)){
                    if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK))
                       || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && agreementObjOld.Provider_Service_Type__c == null)){
                           if (agreementObj.recordTypeId == CLM_ReimbursementModel.ANCRecordTypeId){
                                 agreementObj.CLM_Bypass_MaHmoLesserOfCovered__c = false;
                                 agreementObj.CLM_Bypass_MaHmoLesserOfMedicAllo__c = false;
                               }
                           agreementObj.MA_HMO_lesser_of_of_Medicare_allowed__c = 100;
                           agreementObj.MA_HMO_lesser_of_of_Covered__c = 100;
                       }
                }
                // HMO Advantage End
                
                // PPO Advantage Start
                if(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)){
                    if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))
                       || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && agreementObjOld.Provider_Service_Type__c == null) ){
                           if (agreementObj.recordTypeId == CLM_ReimbursementModel.ANCRecordTypeId){
                                 agreementObj.CLM_Bypass_MaPpoLesserOfMedicareAl__c = false;
                                 agreementObj.CLM_Bypass_MaPpoLesserOfCovered__c = false;
                               }    
                           agreementObj.MA_PPO_lesser_of_of_Medicare_allowed__c = 100;                            
                           agreementObj.MA_PPO_lesser_of_of_Covered__c = 100;
                       }
                 }
             }
                // PPO Advantage End
             
            // 
            // Clear values
            // HMO Advantage Starts
              if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK)){
                  if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId)) 
                            ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)
                            || (agreementObj.Provider_Networks__c != null &&  !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId))){
                                agreementObj.MA_HMO_lesser_of_of_Medicare_allowed__c = null;
                                agreementObj.MA_HMO_lesser_of_of_Covered__c = null;
                                if (agreementObj.recordTypeId == CLM_ReimbursementModel.ANCRecordTypeId){
                                 agreementObj.CLM_Bypass_MaHmoLesserOfCovered__c = true;
                                 agreementObj.CLM_Bypass_MaHmoLesserOfMedicAllo__c = true;
                               }      
                  }
              }
            // HMO Advantage ends
            
            // PPO Advantage Starts
                
               if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)){ 
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId)) 
                          ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c) 
                          ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c && ( agreementObjOld.Provider_Service_Type__c !=null || agreementObj.recordTypeId == CLM_ReimbursementModel.ASCRecordTypeId ))){
                              agreementObj.MA_PPO_lesser_of_of_Medicare_allowed__c = null;
                              agreementObj.MA_PPO_lesser_of_of_Covered__c = null;
                              if (agreementObj.recordTypeId == CLM_ReimbursementModel.ANCRecordTypeId){
                                 agreementObj.CLM_Bypass_MaPpoLesserOfMedicareAl__c = true;
                                 agreementObj.CLM_Bypass_MaPpoLesserOfCovered__c = true;
                               }       
                       }
                     }
             // PPO Advantage Ends
                   
               // OK Facility Record type - Reimbursement start
              // 
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.facilityRecordTypeId){
                    
                    // Facility - LTAC service type
                    // Facility - LTAC IP Max Reimbursement Allowance Per Diem FIELD
                     if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC)){
                         
                          if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK))){
                              
                            if((agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK)))
                              || ((agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC)))){
                               agreementObj.IP_Max_Reimbursement_Allowance_Per_Diem__c  = 1350;
                               
                             }
                               
                          }
                        // Facility LTAC BA IP Max Reimb. Allowance Per Diem FIELD
                      if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC))){
                                 agreementObj.BA_IP_Max_Reimb_Allowance_Per_Diem__c	 = 1250.00;
                            }
                        
                         }
                     }
                       
                        // Facility LTAC record type end
                    
                        
                   
                     
                        // Facility RTC record type start
                        // Blue Choice Network
                    if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)){
                         if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK))
                              || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK)  && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)))){
                                 agreementObj.BChoice_Max_Reimb_Allow_Resid_Treat_Srvc__c = 364;                       
                            }           
                         }
                         
                        //Blue Preferred Network
                          if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) )
                              || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)  && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)))){
                                 agreementObj.BPref_Max_Reimb_Allowed_Resid_Treat_Srvc__c = 309;
                                 
                            }
                        
                         }
                         
                           
                        // Facility RTC Traditional Network
                        if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK))
                              || (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)))){
                                 agreementObj.BT_Network_Max_Reimbursement_Allowance__c = 419;
                                 
                            }
                        
                         }
                    }
                        // Facility RTC record type end
                        
                       // Facility PSYCH record type start
                if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_PSYCH)){
                         if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK))){
                            if((agreementObjOld.Provider_Service_Type__c == null || agreementObjOld.Provider_Networks__c == null || ((agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)) && !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_PSYCH))) 
                               || (agreementObjOld.Provider_Service_Type__c == null || agreementObjOld.Provider_Networks__c == null || ((!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_PSYCH)))){
                                 agreementObj.BA_BP_IP_Hospital_Services_per_diem__c = 554;
                                 agreementObj.BA_BP_Residential_Treat_Srvcs_per_diem__c = 362;
                            }
                         }
                        // Facility PSYCH record type end
                    }
                    
                      // Clear values for Facility LTAC - BA IP Max Reimb. Allowance Per Diem FIELD
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){           
                                   	agreementObj.BA_IP_Max_Reimb_Allowance_Per_Diem__c	 = null;           		 
                           }
                    }
                    
                    // Clear values for Fac LTAC - IP Max Reimbursement Allowance Per Diem FIELD
                    /*if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK))){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c)
                       ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)){
                                   agreementObj.IP_Max_Reimbursement_Allowance_Per_Diem__c = null;
                            }
                    } */
                   if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC)){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c)
                       ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                       ||(!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_LTAC) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                                   agreementObj.IP_Max_Reimbursement_Allowance_Per_Diem__c = null;
                            }
                    }
                    
                    // Clear values for Facility PSYCH 
                        if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK))&& agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_PSYCH)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_PSYCH) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              
                                 agreementObj.BA_BP_IP_Hospital_Services_per_diem__c = null;
                                 agreementObj.BA_BP_Residential_Treat_Srvcs_per_diem__c = null;
                                     		 
                           }
                     }
                               
                    // Clear values for Facility RTC
                    // Blue choice clear values
                        if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK)  && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK)  && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              
                                agreementObj.BChoice_Max_Reimb_Allow_Resid_Treat_Srvc__c = null;        		 
                           }
                     }
                    
                     // Blue choice preffered clear values
                        if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)  && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)  && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              
                                agreementObj.BPref_Max_Reimb_Allowed_Resid_Treat_Srvc__c = null;            		 
                           }
                     }
                    
                      // Blue Traditional preffered clear values
                        if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)  && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)  && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.FACILITY_RTC) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              
                                agreementObj.BT_Network_Max_Reimbursement_Allowance__c = null;             		 
                           }
                     }
                // OK Facility REcord type - Reimbursement end                                        
               }
                
                // OK ANC record type start
                if(agreementObj.recordTypeId == CLM_ReimbursementModel.ANCRecordTypeId){
                    
                    // In Agreement Detail page, 
                    // rest of the other Fields which is not part of Service Type and Provider Networks combination selected by user will not be Editable
                    //  i.e. if user tries to edit and then clicks on save button an error message
                    //   ‘For the Provider Service Type and Provider Networks selected this field cannot be edited’ is displayed next to the field
                   
                  // Defaulting Values  
                  // Oklahoma ANC Lab Starts
                    if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)){ 
                  // Oklahoma ANC Lab Blue Advantage PPO Lab Conversion Factor field starts
                    	if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB))){
                                  agreementObj.CLM_Bypass_PpoLabConversionFactor__c	 = false;
                                  agreementObj.Blue_Advantage_PPO_Lab_Conversion_Factor__c	 = 'nineteen dollars and forty-eight cents ($19.48)';
                            }
                        
                         }
                   //Oklahoma ANC Lab Blue Advantage PPO Lab Conversion Factor field ends
                        
                   //Oklahoma ANC Lab BlueLincs HMO Lab Conversion Factor field starts
                   if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB))){
                                  agreementObj.CLM_Bypass_BlueLincsHmoLabConversionFact__c = false;
                                  agreementObj.BlueLincs_HMO_Lab_Conversion_Factor__c = 'nineteen dollars and forty-eight cents ($19.48)';
                            }
                        
                         }
                   // Oklahoma ANC Lab BlueLincs HMO Lab Conversion Factor field ends
                   
                   // Oklahoma ANC Lab Blue Traditional Lab Conversion Factor field starts    
                   if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB))){
                                 agreementObj.CLM_Bypass_BlueTraditionalLabConverFacto__c = false;
                                 agreementObj.Blue_Traditional_Lab_Conversion_Factor__c	 = 'twenty-five dollars and twenty-nine cents ($25.29)';
                            }
                        
                         }
                   // Oklahoma ANC Lab Blue Traditional Lab Conversion Factor field ends
                   
                   //Oklahoma ANC Lab BlueChoice PPO Lab Conversion Factor field starts
                   if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB))){
                                 agreementObj.CLM_Bypass_BlueChoicePpoLabConversionFac__c = false;
                                 agreementObj.BlueChoice_PPO_Lab_Conversion_Factor__c = 'twenty-four dollars and seventy six cents ($24.76)';
                            }
                        
                         }
                   // Oklahoma ANC Lab BlueChoice PPO Lab Conversion Factor field ends
                   
                   // Oklahoma ANC Lab BluePreferred PPO Lab Conversion Factor Field starts
                   if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK)){
                            if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK))
                              || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB))){
                                 agreementObj.CLM_Bypass_BluePreferredPpoLabConverFac__c = false;
                                 agreementObj.BluePreferred_PPO_Lab_Conversion_Factor__c = 'twenty-three dollars and seventeen cents ($23.17)';
                            }
                        
                         }
                   // Oklahoma ANC Lab BluePreferred PPO Lab Conversion Factor Field ends
                   
                  // Oklahoma Anc Lab RBRVS Publication Location field starts
                  if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                              
                            if((agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                          !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)))
                              || ((agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)))){
                               agreementObj.CLM_Bypass_RbrvsPublicationLocation__c  = false;
                               agreementObj.RBRVS_Publication_Location__c  = 'Federal Register Volume 80 No. 220 (dated November 16, 2015)';
                             }   
                          }
                    }
                  // Oklahoma Anc Lab RBRVS Publication Location field ends
                  
                  // Oklahoma ANC DME fields starts
                 if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME)){
                     if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                              agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                              agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK))){
                                  
                                if((agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                              !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                              !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)))
                                  || ((agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                              agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                              agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME)))){
                                   agreementObj.CLM_Bypass_DmeRentalFeePreAuthCapAmoun__c  = false;
                                   agreementObj.CLM_Bypass_DmePurchasePreAuthCapAmount__c  = false;
                                   agreementObj.DME_Purchase_pre_auth_cap_amount__c  = 'four thousand dollars ($4,000.00)';
                                   agreementObj.DME_Rental_Fee_pre_auth_cap_amount__c  = 'four thousand dollars ($4,000.00)';
                                 }
                      }         
                   }
                // Oklahoma ANC DME Fields ends
                
                // Oklahoma ANC SNF Starts
                // Oklahoma ANC SNF BlueLincs HMO SNF Max Per Diem Field starts
               if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)){
                   if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK)){
                        if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK))
                           || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF))){
                               agreementObj.CLM_Bypass_BlueLincsHmoSnfMaxPerDiem__c = false;
                               agreementObj.BlueLincs_HMO_SNF_Max_Per_Diem__c = 'three hundred sixty-five dollars ($365.00)';
                           }
                     }
               }
                // Oklahoma ANC SNF BlueLincs HMO SNF Max Per Diem Field ends
                
                // Oklahoma ANC SNF BlueTrad,Choice,Pref SNF Max Per Diem Field Starts
                if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)){
                         if(agreementObj.Provider_Networks__c != null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) || agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK))){
                            if((agreementObjOld.Provider_Service_Type__c == null || agreementObjOld.Provider_Networks__c == null || ((agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)) && !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF))) 
                               || (agreementObjOld.Provider_Service_Type__c == null || agreementObjOld.Provider_Networks__c == null || ((!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) && !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)))){
                                 agreementObj.CLM_Bypass_BlueTradChoicePrefSnfMaxPer__c = false;
                                 agreementObj.BlueTrad_Choice_Pref_SNF_Max_Per_Diem__c = 'four hundred twenty-five dollars ($425.00)';
                            }
                         }
                 }
                // Oklahoma ANC SNF BlueTrad,Choice,Pref SNF Max Per Diem Field Ends
                
                // Oklahoma ANC SNF Blue Advantage PPO SNF Max Per Diem Field Starts
                if(agreementObj.Provider_Service_Type__c != null &&  agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)){
                    if(agreementObj.Provider_Networks__c != null && agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK)){
                        if((agreementObjOld.Provider_Networks__c == null || !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK))
                           || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c && (agreementObjOld.Provider_Service_Type__c == null || !agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF))){
                               agreementObj.CLM_Bypass_BlueAdvantagePpoSnfMaxPerDiem__c = false;
                               agreementObj.Blue_Advantage_PPO_SNF_Max_Per_Diem__c= 'three hundred forty dollars ($340.00)';
                           }       
                    }
                }
                // Oklahoma ANC  Blue Advantage PPO SNF Max Per Diem Field Ends
                  
                  // clear values for Oklahoma Anc Sarts
                  // Clear values for Oklahoma Lab Starts
                  // clear value for Oklahoma ANC Lab Blue Advantage PPO Lab Conversion Factor field starts
                  if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                                  agreementObj.Blue_Advantage_PPO_Lab_Conversion_Factor__c = null;
                                  agreementObj.CLM_Bypass_PpoLabConversionFactor__c	 = true;   		 
                           }
                    }
                   // clear value for Oklahoma ANC Lab Blue Advantage PPO Lab Conversion Factor field ends
                   
                   // clear value for Oklahoma ANC Lab BlueLincs HMO Lab Conversion Factor field starts
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                                agreementObj.BlueLincs_HMO_Lab_Conversion_Factor__c = null;
                              	agreementObj.CLM_Bypass_BlueLincsHmoLabConversionFact__c = true;	 
                           }
                    }
                    // clear value for Oklahoma ANC Lab BlueLincs HMO Lab Conversion Factor field ends
                    
                    // Clear values for Oklahoma ANC Lab Blue Traditional Lab Conversion Factor field starts 
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                              agreementObj.Blue_Traditional_Lab_Conversion_Factor__c = null; 
                              agreementObj.CLM_Bypass_BlueTraditionalLabConverFacto__c = true;
                           }
                    }
                    // Clear values for Oklahoma ANC Lab Blue Traditional Lab Conversion Factor field ends
                    
                    // clear values for Oklahoma ANC Lab BlueChoice PPO Lab Conversion Factor field starts
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                      		   agreementObj.BlueChoice_PPO_Lab_Conversion_Factor__c = null;
                               agreementObj.CLM_Bypass_BlueChoicePpoLabConversionFac__c = true;
                           }
                    }
                    //clear values for Oklahoma ANC Lab BlueChoice PPO Lab Conversion Factor field ends
                    
                    // Clear values for Oklahoma ANC Lab BluePreferred PPO Lab Conversion Factor Field starts          
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.LAB) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                           agreementObj.BluePreferred_PPO_Lab_Conversion_Factor__c = null; 
                           agreementObj.CLM_Bypass_BluePreferredPpoLabConverFac__c = true;
                           }
                    }
                    //Clear values for Oklahoma ANC Lab BluePreferred PPO Lab Conversion Factor Field ends
                    
                    // Clear Values for Oklahoma Anc Lab RBRVS Publication Location field starts
                    if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.Lab)){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c)
                       ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                          !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                          !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c) 
                      || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.Lab) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                               agreementObj.RBRVS_Publication_Location__c  = null;
                               agreementObj.CLM_Bypass_RbrvsPublicationLocation__c  = true;
                          }
                    } 
                    // Clear Values for Oklahoma Anc Lab RBRVS Publication Location field ends
                    // Clear Values for Oklahoma ANC Ends
                    
                    // Clear Value for OK - DME starts
                    if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) ||
                          agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME)){
                    if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c)
                       ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                       ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) &&
                          !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK ) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK) &&
                          !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                       || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.DME) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                               agreementObj.DME_Purchase_pre_auth_cap_amount__c  = null;
                               agreementObj.DME_Rental_Fee_pre_auth_cap_amount__c  = null;
                               agreementObj.CLM_Bypass_DmeRentalFeePreAuthCapAmoun__c  = true;
                               agreementObj.CLM_Bypass_DmePurchasePreAuthCapAmount__c  = true;
                          }
                    } 
                    // Clear Value for OK - DME ends
                    
                    // Clear Values for OK SNF BlueLincs HMO SNF Max Per Diem Field Starts
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUELINES_HMO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                           	   agreementObj.BlueLincs_HMO_SNF_Max_Per_Diem__c = null;
                               agreementObj.CLM_Bypass_BlueLincsHmoSnfMaxPerDiem__c = true;
                           }
                    }
                    // Clear Values for OK SNF BlueLincs HMO SNF Max Per Diem Ends
                    
                    // Clear Values for OK SNF BlueTrad,Choice,Pref SNF Max Per Diem Field Starts
                    if(agreementObjOld.Provider_Networks__c <> null && (agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) || agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK))&& agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUECHOICE_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK) && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUETRADITIONAL_PROVIDER_NETWORK)) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                               agreementObj.BlueTrad_Choice_Pref_SNF_Max_Per_Diem__c = null;  
                               agreementObj.CLM_Bypass_BlueTradChoicePrefSnfMaxPer__c = true;       		 
                           }
                     }
                    // Clear Values for OK SNF BlueTrad,Choice,Pref SNF Max Per Diem Field Ends
                    
                    // Clear Values for OK SNF Blue Advantage PPO SNF Max Per Diem Starts
                    if(agreementObjOld.Provider_Networks__c <> null && agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObjOld.Provider_Service_Type__c != null && agreementObjOld.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF)){
                        if((agreementObj.Provider_Networks__c == null && agreementObjOld.Provider_Networks__c <> agreementObj.Provider_Networks__c && agreementObjOld.Provider_Networks__c <> null)
                           ||  (agreementObj.Provider_Service_Type__c == null && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c ) 
                           ||  (agreementObj.Provider_Networks__c != null && !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK) && agreementObj.Provider_Networks__c <> agreementObjOld.Provider_Networks__c)
                           || (!agreementObj.Provider_Service_Type__c.contains(CLM_ReimbursementModel.SNF) && agreementObjOld.Provider_Service_Type__c <> agreementObj.Provider_Service_Type__c)){
                           	   agreementObj.Blue_Advantage_PPO_SNF_Max_Per_Diem__c= null; 
                               agreementObj.CLM_Bypass_BlueAdvantagePpoSnfMaxPerDiem__c = true;
                           }
                    }
                    // Clear Values for OK SNF Blue Advantage PPO SNF Max Per Diem Ends
                  
                    
                }
              // Oklahoma Plan end
            } 
            
        }
        
    }

}