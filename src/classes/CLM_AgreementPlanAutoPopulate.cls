public class CLM_AgreementPlanAutoPopulate {

    @InvocableMethod
    public static void StatePlan(List<Apttus__APTS_Agreement__c> agreementRecords){
        
        Set<Id> accountIds=new Set<Id>();
        for(Apttus__APTS_Agreement__c agreement:agreementRecords){
            if(agreement <> null && agreement.Apttus__Account__c <> null){
                accountIds.add(agreement.Apttus__Account__c);   
            }
        }
        
        Apttus__APTS_Agreement__c UpdatableAggrement;
        List<Apttus__APTS_Agreement__c> AgreementList=new List<Apttus__APTS_Agreement__c>();
        
        if(!AccountIds.isEmpty()){
            
            Map<Id,Account> AccountMap=new Map<Id,Account>([Select Id,CM_Corporate_Entity_Code__c FROM Account where Id IN:AccountIds]);

            for(Apttus__APTS_Agreement__c agreement:agreementRecords){
                
                if(AccountMap.containsKey(agreement.Apttus__Account__c)){
                    
                        UpdatableAggrement=new Apttus__APTS_Agreement__c(Id=agreement.Id);
                    if((AccountMap.get(agreement.Apttus__Account__c)).CM_Corporate_Entity_Code__c==Label.CLM_Plan_IL){
                        UpdatableAggrement.Plan__c='Illinois';
                    }else if((AccountMap.get(agreement.Apttus__Account__c)).CM_Corporate_Entity_Code__c==Label.CLM_Plan_NM){
                        UpdatableAggrement.Plan__c='New Mexico';
                        
                    }else if((AccountMap.get(agreement.Apttus__Account__c)).CM_Corporate_Entity_Code__c==Label.CLM_Plan_MT){
                        UpdatableAggrement.Plan__c='Montana';
                        
                    }else if((AccountMap.get(agreement.Apttus__Account__c)).CM_Corporate_Entity_Code__c==Label.CLM_Plan_OK){
                        
                        UpdatableAggrement.Plan__c='Oklahoma';
                    }else if((AccountMap.get(agreement.Apttus__Account__c)).CM_Corporate_Entity_Code__c==Label.CLM_Plan_TX){
                        
                        UpdatableAggrement.Plan__c='Texas';
                    }
                    
                    AgreementList.add(UpdatableAggrement);
                }
            }

        }
        
        if(!AgreementList.isEmpty()){
            try{
                update AgreementList;
            } Catch(Exception e){
                System.debug(e.getMessage());
            }
        }

    }

}