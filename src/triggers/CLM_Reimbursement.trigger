/******************************
Apex Trigger Name   : CLM_Reimbursement
Version             : 1.0
Function            : This is a trigger which runs everytime an agreement is created or edited and runs different trigger
                      handlers in order to default values and also remove the values from the fields based on the changes
                      being made in the UI of the agreement


Developer                  Date                                
------------------------------------------------------------------------------------- 
Bharathi Malempati         5/23/2019  
Piyush Bhardwaj            5/30/2019
******************************/

trigger CLM_Reimbursement on Apttus__APTS_Agreement__c (before update, Before insert,after insert, after update)
{
     //System.debug('is trigger*******'+AgreementHelper_PRM.isFirstRun);
    //Different trigger handler classes methods are called before updates are made to the agreement
     if(trigger.isBefore &&  trigger.isUpdate)
      {   
        System.debug('is Update trigger@@@@@');
        CLM_NewMexico_ReimbursementHandler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap); 
        CLM_Oklahoma_ReimbursementHandler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap);
        CLM_Illinois_ReimbursementHandler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap);
        CLM_Montana_ReimbursementHandler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap);
        CLM_Texas_ReimbursementHandler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap);
        //CLM_AmendmentNumberAutoPopulate_Handler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap);
        CLM_Agreement_Change_ownerHandler.beforeUpdate(Trigger.new,trigger.OldMap,trigger.NewMap);  
      }
     /* if(Trigger.isAfter &&  trigger.isUpdate && AgreementHelper_PRM.isFirstRun)
      {
          System.debug('is update trigger');
          AgreementHelper_PRM.isFirstRun = false;
          AgreementHelper_PRM.agreementTracking(trigger.NewMap, trigger.OldMap);
          AgreementHelper_PRM.caseStatusUpdateBasedOnApptusAgreementStatus(trigger.NewMap, trigger.OldMap);   
          AgreementHelper_PRM.updateCaseStatusInContract(trigger.NewMap, trigger.OldMap);
      }  */
}