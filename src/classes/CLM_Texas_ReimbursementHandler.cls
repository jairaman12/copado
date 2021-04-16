/******************************
Apex Class Name     : CLM_Texas_ReimbursementHandler
Version             : 1.0
Function            : The following texas handler has been written in order to default the values for custom fields like Mediation city
 					  and Arbitration city. It also defaults and removes the default values for reimbursement field when a particular 
					  criteria is met and when that criteria is no longer being satisfied

Developer                  Date                                
------------------------------------------------------------------------------------- 
Piyush Bhardwaj           7/17/2019  
Sri Ram Adusumilli        8/21/2019 (PPN-52076)

*****************************/

public class CLM_Texas_ReimbursementHandler 
{
    // Method is invoked in the trigger for Reiumbursement where it intakes an agreement list, 
    // agreement old map and agreement new map
    public static void beforeUpdate(List<Apttus__APTS_Agreement__c>agreementList ,Map<Id,Apttus__APTS_Agreement__c> agreementOldMap,Map<Id,Apttus__APTS_Agreement__c> agreementNewMap)
    { 
        List<Apttus__APTS_Agreement__c> oklahomaAgreementLis = new List<Apttus__APTS_Agreement__c>();
        for(Apttus__APTS_Agreement__c  agreementObj : agreementList)
        {
           Apttus__APTS_Agreement__c agreementObjOld = agreementOldMap.get(agreementObj.Id);  
            // Testing to see if the agreement generated is for Texas Plan
           if(agreementObj.Plan__c == CLM_ReimbursementModel.Texas_PLAN)
           {
               // Logic for Populating the default values for the fields Arbitration City & Mediation City
               if(agreementObj.CLM_Tx_City_Check__c == false)
               {
                   agreementObj.Arbitration_City__c = 'Dallas, TX';
                   agreementObj.Mediation_City__c = 'Dallas, TX';
                   agreementObj.CLM_Tx_City_Check__c = true;
               }
               
               //Logic for Populating the default value for the field NPI Type,Termination Without Cause Notice & Perpetual
               if(agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard')
               {
                   if(agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c == null || agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c != 'Standard')
                   {
                       if(agreementObj.recordTypeId == CLM_ReimbursementModel.professionalRecordTypeId)
                       {
                           agreementObj.CLM_NPI_List_Type__c = 'Type 1';
                           agreementObj.Termination_Without_Cause_Notice__c = 'ninety (90) calendar days';
                           agreementObj.Apttus__Perpetual__c = true;
                       }
                
                       if(agreementObj.recordTypeId == CLM_ReimbursementModel.medicalRecordTypeId)
                       {
                           agreementObj.CLM_NPI_List_Type__c = 'Type 2';
                           agreementObj.Termination_Without_Cause_Notice__c = 'ninety (90) calendar days';
                           agreementObj.Apttus__Perpetual__c = true;
                           
                       }
                   }
               }
               
               //Logic for removing the default value for the field NPI Type,Termination without cause notice & Perpetual
               if(agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == null || agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c != 'Standard')
               {
                   if(agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard')
                   {
                       if(agreementObj.recordTypeId == CLM_ReimbursementModel.professionalRecordTypeId)
                       {
                           agreementObj.CLM_NPI_List_Type__c = null;
                           agreementObj.Termination_Without_Cause_Notice__c = null;
                           agreementObj.Apttus__Perpetual__c = false;
                          
                       }
                       if(agreementObj.recordTypeId == CLM_ReimbursementModel.medicalRecordTypeId)
                       {
                           agreementObj.CLM_NPI_List_Type__c = null;
                           agreementObj.Termination_Without_Cause_Notice__c = null;
                           agreementObj.Apttus__Perpetual__c = false;
                       }
                   }
               }
               
               // Populating the default value for the field % of Medicaid Fee schedule field
              if(agreementObj.recordTypeId == CLM_ReimbursementModel.professionalRecordTypeId || agreementObj.recordTypeId == CLM_ReimbursementModel.medicalRecordTypeId)
               {
                   //Logic for defaulting the value for the field
                   //1st scenerio standard was selected but networks were missing
                   //2nd scenerio networks were there but standard was missing
                   if((agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c <> null && agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard' &&
                        ((agreementObj.Provider_Networks__c<> null &&(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) || 
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  ||
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  ||
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network))) &&
                        (agreementObjOld.Provider_Networks__c == null || (!agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) && 
                        !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  &&
                        !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  &&
                        !agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network))))) ||   // 1st scenerio ends
                        ((agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c == null || agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c != 'Standard') &&
                        agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard' &&
                        (agreementObj.Provider_Networks__c<> null &&(agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) || 
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  ||
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  ||
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network)))))         // 2nd scenerio ends
                      {
                          agreementObj.CLM_Bypass_PercentofMedicaidFeeSchedule__c = false;
                          agreementObj.of_Medicaid_fee_schedule__c = 100;
                          agreementObj.CLM_Bypass_PercentofMedicaidFeeSchedule__c = true;
                      }
                   
                   
                   //Logic for removing the default value for the field % of medicaid fee schedule
                   //1st scenerio changed from standard but still has networks
                   //2nd scenerio standard but networks are removed 
                   //3rd scenerio both are removed
                   if(((agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == null || agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c != 'Standard') 
                        && agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c <> null && agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard' &&
                        (agreementObj.Provider_Networks__c <> null && (agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) || 
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  ||
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  ||
                        agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network)))) || //1st scenerio ends
                        ((agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c <> null && agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard') &&
                        (agreementObjOld.Provider_Networks__c <>null &&(agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) || 
                        agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  ||
                        agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  ||
                        agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network))) && 
                        (agreementObj.Provider_Networks__c == null || (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) && 
                        !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  &&
                        !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  &&
                        !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network)))) || //2nd scenerio ends
                        (agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c == null || agreementObj.CLM_Standard_or_Non_Standard_Base_Lan__c != 'Standard') 
                        && agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c <> null && agreementObjOld.CLM_Standard_or_Non_Standard_Base_Lan__c == 'Standard' &&
                        ((agreementObjOld.Provider_Networks__c <>null &&(agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) || 
                        agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  ||
                        agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  ||
                        agreementObjOld.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network))) && 
                        (agreementObj.Provider_Networks__c == null || (!agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_CHIP_Provider_Network) && 
                        !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Kids_Provider_Network)  &&
                        !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Medicaid_Provider_Network)  &&
                        !agreementObj.Provider_Networks__c.contains(CLM_ReimbursementModel.TX_STAR_Plus_Provider_Network)))))  // 3rd Scenerio Ends
                   {
                       agreementObj.CLM_Bypass_PercentofMedicaidFeeSchedule__c = true;
                       agreementObj.of_Medicaid_fee_schedule__c = null;
                   }  
               }
               
/******************************
				Function            : Code added to auto check the provider credentialed field according to specific 
                                      status values of associated provider onboarding individual case
                Story No.           : PPN-50822
				Developer                  Date                                
				------------------------------------------------------------------------------------- 
				Piyush Bhardwaj           8/19/2019  

*****************************/
               // Checking if the status of the associated contracting on-boarding individual case is one of the
               // status for which we need to check the checkbox of the field provider credentialed
              /* if(agreementObj.CLM_Credentialing_Case_Status__c != agreementObjOld.CLM_Credentialing_Case_Status__c)
               {
                   if(agreementObj.CLM_Credentialing_Case_Status__c == 'Cred Approved' || agreementObj.CLM_Credentialing_Case_Status__c == 'Delegated' || agreementObj.CLM_Credentialing_Case_Status__c == 'Provisionally Approved')
                   {
                       if((agreementObj.CLM_Credentialing_Case_Status__c == 'Cred Approved' && (agreementObjOld.CLM_Credentialing_Case_Status__c == 'Delegated' || agreementObjOld.CLM_Credentialing_Case_Status__c == 'Provisionally Approved')) ||
                          (agreementObj.CLM_Credentialing_Case_Status__c == 'Provisionally Approved' && (agreementObjOld.CLM_Credentialing_Case_Status__c == 'Delegated' || agreementObjOld.CLM_Credentialing_Case_Status__c == 'Cred Approved')) || 
                          (agreementObj.CLM_Credentialing_Case_Status__c == 'Delegated' && (agreementObjOld.CLM_Credentialing_Case_Status__c == 'Cred Approved' || agreementObjOld.CLM_Credentialing_Case_Status__c == 'Provisionally Approved')) ||
                          (agreementObjOld.CLM_Credentialing_Case_Status__c != 'Cred Approved' && agreementObjOld.CLM_Credentialing_Case_Status__c != 'Delegated' && agreementObj.CLM_Credentialing_Case_Status__c != 'Provisionally Approved'))
                       {
                           agreementObj.Provider_Credentialed__c= true;
                       }
                   }
               }
               
               // Checking if the status of the associated contracting on-boarding individual case is one of the
               // status for which the checkbox of the field provider credentialed is not checked
               if(agreementObj.CLM_Credentialing_Case_Status__c != agreementObjOld.CLM_Credentialing_Case_Status__c)
               {
                   if(agreementObj.CLM_Credentialing_Case_Status__c != 'Cred Approved' && agreementObj.CLM_Credentialing_Case_Status__c != 'Delegated' && agreementObj.CLM_Credentialing_Case_Status__c != 'Provisionally Approved')
                   {
                       if(agreementObjOld.CLM_Credentialing_Case_Status__c == 'Cred Approved' || agreementObjOld.CLM_Credentialing_Case_Status__c == 'Delegated' || agreementObjOld.CLM_Credentialing_Case_Status__c == 'Provisionally Approved')

                       agreementObj.Provider_Credentialed__c= false;
                   }
               }*/
           }
        }
    }                       
}