trigger ProviderDetailsTrigger on Provider_Networks__c (before Delete,before Insert, before Update, after Update, after Insert, after delete) {
    
  // public  Boolean ValidateCredStatus  = true;
    ProviderDetailsTriggerHandler ProvDetHandler = new ProviderDetailsTriggerHandler();
     
    // PPN-30575 - Update Network Load case Account based on Prov id On Provider Details
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
     if(ProvDetHandler.ValidateCredStatus ==false){  ProvDetHandler.updateAccountonNetworkLoadCases(trigger.New);  }
        if(trigger.isUpdate){
           ProvDetHandler.ProviderIsAfterIsUpdate(Trigger.NewMap, Trigger.OldMap);
            
        }
             
    }
    
    if(trigger.isBefore && trigger.isdelete){   
       ProvDetHandler.ProviderIsBeforeIsDelete(Trigger.Old);
    }
    else if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) ){
         if(ProvDetHandler.ValidateCredStatus){ ProvDetHandler.ValidateDuplicateCredentialingCase(Trigger.New, Trigger.oldMap); }//PPN - 30306
    //Linking Account Name Based on ProvID In case creation Starts.
            ProvDetHandler.LinkAccBasedOnProvID(Trigger.New, Trigger.OldMap);
    //Linking Account Name Based on ProvID In case creation Ends.
  
     
        if(Trigger.isUpdate)
        {
          ProvDetHandler.ProviderIsBeforeIsUpdate(Trigger.NewMap, Trigger.OldMap);
        }
    // //PPN-26580 Starts
        ProvDetHandler.AddProviderName(Trigger.New, Trigger.OldMap);
    //PPN-26580 Ends
            
            
    }
    else if(trigger.isAfter && (trigger.isInsert || trigger.isDelete)){
        ProvDetHandler.ProviderIsAfterIsInsert(Trigger.New, Trigger.Old);
    }

  
    
    
    

    
}