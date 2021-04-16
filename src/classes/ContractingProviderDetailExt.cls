public without Sharing class ContractingProviderDetailExt{

    public string contractingCase  {get; set;}
    public string masterEntityCase {get;set;}
    public string credentialingCase {get;set;}
    //public string counterSignCaseProv{get;set;}
    public string planId           {get;set;}
    public string providerId       {get;set;}
    public boolean showContracting {get;set;}  
    public boolean credCounterCase{get;set;} 

    public boolean contractGroup   {get;set;}  
    public boolean counterSignCase {get;set;}
    public boolean counterSignGroup ;
    public boolean credGroupManual {get;set;}
    public string counterSign      {get;set;}
    public string fromPFIN         {get;set;}
    public string pfincase         {get;set;}
    public string casePlanId       {get;set;}
    public boolean networkLoad ;
    public boolean masterEntity    {get;set;}
    public string provId           {get;set;}       
    public boolean fromIndvPfin    {get;set;}
    public boolean fromIndvContract {get;set;}
    public boolean credentialing   {get;set;}
    public string returnCase;
    public Provider_Networks__c providerNetwork   {get;set;} 
    public string isFirstPFIN ;
    public static boolean isRunProviderTrigger = True;
    public boolean isFirstContract {get;set;}
     public string providerName    {get;set;} //PPN-26580
    public Id CaseId;    
    public list<case> flagCase = new list<Case>();
    public String idValue;
    public String network{get;set;}
    public boolean providernetworkload{get;set;}
    public boolean manualcredindividual{get;set;}
    
    //public ContractingProviderDetailExt(ApexPages.StandardController std) {}
    
      public ContractingProviderDetailExt(ApexPages.StandardSetController std) {
       credCounterCase = true;
       providernetworkload = false;
       manualcredindividual  = false;
      idValue = ApexPages.currentPage().getParameters().get('Id');
     // System.debug('Id value '+idValue+'substring '+idValue.substring(0,3));
      if(idValue !=NULL && case.sobjecttype.getDescribe().getKeyPrefix()==idValue.substring(0,3))
      {
          caseId = idValue;
      }
      else
      {
          providerId = idValue;
      }
      System.debug('caseId----'+caseId);
      String completingTheForm;    
      List<Case> casePlanInfo =[Select Id, status,Completing_the_form_for__c,Plan_ID__c , recordTypeId,Source__c  from Case where Id =: caseId ];
      system.debug('casePlanInfo.size()'+casePlanInfo.size());
        if(casePlanInfo.size() > 0 && (casePlanInfo[0].status == 'Closed Processed' || casePlanInfo[0].status == 'Closed Rejected')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create new Provider record under Closed Case.'));
            credCounterCase = false;
        }
        if(casePlanInfo.size() > 0){        
            planId  = casePlanInfo[0].Plan_ID__c;
            completingTheForm = casePlanInfo[0].Completing_the_form_for__c;
        }      
         List<RecordType> providerdetailRecordType = [SELECT Id, Name FROM RecordType WHERE sObjectType='Provider_Networks__c' limit 1] ;
         if(providerdetailRecordType[0].Name == 'PFIN Onboarding'){
                 pfincase = ApexPages.currentPage().getParameters().get('Id'); 
                 fromPFIN = 'true';  
        
         }
        else if(providerdetailRecordType[0].name == 'Contracting Onboarding'){
                contractingCase =ApexPages.currentPage().getParameters().get('Id');
                fromPFIN= 'false';
        }
        else if(providerdetailRecordType[0].name == 'Credentialing'){
                system.debug('coming credentialing');
                if(completingTheForm  == 'Individual'){
                system.debug('coming credentialing indivual');
                manualcredindividual = true;
                }
                credentialingCase =ApexPages.currentPage().getParameters().get('Id');
                fromPFIN= 'false';
        }
        else if(providerdetailRecordType[0].name == 'CounterSign'){
                counterSign =ApexPages.currentPage().getParameters().get('Id');
                fromPFIN= 'false';
        }
        else if(providerdetailRecordType[0].name == 'Network'){
                system.debug('network load case provider+++');
                network =ApexPages.currentPage().getParameters().get('Id');                
                providernetworkload = true;
                fromIndvPfin = false;
        }
     
       List<RecordType> caseRecordType = new List<RecordType>();
       if(casePlanInfo.size() > 0){
           caseRecordType = [Select Id, DeveloperName From RecordType where SobjectType ='Case' and Id= : casePlanInfo[0].recordTypeId limit 1] ;
       
       if(caseRecordType[0].DeveloperName == 'Data_Entry_Provider_On_boarding' || caseRecordType[0].DeveloperName == 'Data_Entry_Group_Provider_On_boarding' ){
              pfincase = ApexPages.currentPage().getParameters().get('Id'); 
              fromPFIN = 'true';   
              system.debug('pfincase ----'+pfincase );

        }
        else if(caseRecordType[0].DeveloperName == 'Contracting_Provider_On_boarding' || caseRecordType[0].DeveloperName == 'Provider_Group_Onboarding_Contracting'){        
            contractingCase =ApexPages.currentPage().getParameters().get('Id');
            system.debug('contracting ----'+contractingCase);

        }
       
        else if(caseRecordType[0].DeveloperName == 'Provider_On_boarding_Credentialing_Ancillary' || caseRecordType[0].DeveloperName == 'Provider_On_boarding_Credentialing_Facility' || caseRecordType[0].DeveloperName == 'Provider_On_boarding_Credentialing' || caseRecordType[0].DeveloperName == 'Provider_Group_On_boarding_Credentialling'){   
              credentialingCase=ApexPages.currentPage().getParameters().get('Id');
              system.debug('credentialingCase+'+credentialingCase);
              system.debug('casePlanInfo[0].Source__c++'+casePlanInfo[0].Source__c);
              if((casePlanInfo[0].Source__c != 'Provider On-boarding Credentialing - Ancillary' && casePlanInfo[0].Source__c != 'Provider On-boarding Credentialing - Facility' && casePlanInfo[0].Source__c != 'Provider On-boarding Credentialing')){ 
                    credCounterCase = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create new record Under Credentialing Case'));
               }
              system.debug('credentialingCase----'+credentialingCase);
        }
        else if(caseRecordType[0].DeveloperName == 'Provider_On_boarding_Counter_Sign' || caseRecordType[0].DeveloperName == 'Provider_Group_On_boarding_Counter_Sign'){     
             counterSign = ApexPages.currentPage().getParameters().get('Id');
             system.debug('@@casePlanInfo[0].Source__c----'+casePlanInfo[0].Source__c);
             if((casePlanInfo[0].Source__c != 'Provider On-boarding Counter sign')&&(casePlanInfo[0].Source__c != 'Provider Group On-boarding Counter sign')){ 
                    system.debug('credentialingCase----'+credentialingCase);
                    credCounterCase = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create new record Under CounterSign Case'));
               }            
            system.debug('counterSign ----'+counterSign);
        
        }
        else if(caseRecordType[0].DeveloperName == 'Provider_Group_Onboarding_Master_Entity'){
            masterEntitycase = ApexPages.currentPage().getParameters().get('Id');
            system.debug('masterEntitycase ----'+masterEntitycase);
        }
        else if(caseRecordType[0].DeveloperName == 'Network_Load'){ 
              system.debug('network case+++++++');  
              network =ApexPages.currentPage().getParameters().get('Id');
              providernetworkload = true;
              system.debug('network ----'+network );
              fromIndvPfin = false;
        }
       }
        
       if(contractingCase != null)
        caseId = contractingCase;        
       else if(credentialingCase != null)
        caseId = credentialingCase;
       else if(counterSign!= null)
        caseId = counterSign;
       else if(masterEntitycase != null)
        caseId = masterEntitycase;
       else if(network != null)
        caseId = network;
        
        system.debug('providerId:' + providerId);
        system.debug('CaseId:' + CaseId);
        system.debug('stdController.getId():' + std.getRecords());
        System.debug('fromPFIN===>>>'+fromPFIN);
        if(caseId != null){
            system.debug('inside 1');            
        }else if(std.getRecords() != null && providerId != NULL){
            Provider_Networks__c p = new Provider_Networks__c();
            p = [select id,Contracting_Case__c,CounterSign__c,Credentialing_Case__c,PFIN_Case__c,Case_Number__c from Provider_Networks__c where id = :std.getRecords()];
            if(p.Contracting_Case__c != null)
                caseId = p.Contracting_Case__c;            
            else if(p.Credentialing_Case__c != null)
                caseId = p.Credentialing_Case__c; 
            else if(p.CounterSign__c != null)
                caseId = p.CounterSign__c; 
            else if(p.Case_Number__C != null)
                caseId = p.Case_Number__c;           
        }
        
        flagCase = [select id,Out_of_Network__c from case where Id = :CaseId];
        
        /* PPN-27887 Changes End */
        system.debug('flagCasezzz:' + flagCase);
        system.debug('*** master entity ***' +masterEntityCase);       
        Id contractRecTypeId;
        Id pfinRecTypeId;
        Id counterSignTypeId;
        Id masterEntityRecType;
        Id credentialingRecTypeId;
        id networkRectype;
        casePlanId = planId;
        fromIndvPfin = false;
        networkLoad = false;
        counterSignCase = false;
        counterSignGroup = false;
        masterEntity = false;
        fromIndvContract = false;
        isFirstContract = false;
        credentialing = false;
        contractGroup = false;
        credGroupManual = false;
        for(RecordType rType : [SELECT Id, Name FROM RecordType WHERE sObjectType='Provider_Networks__c' AND (Name = 'Contracting Onboarding' OR Name = 'PFIN Onboarding' OR Name = 'CounterSign' OR Name='Master Entity' OR Name = 'Credentialing')]){
            if(rType.name == 'Contracting Onboarding')
                contractRecTypeId = rtype.Id;
            else if(rtype.name == 'CounterSign')
                counterSignTypeId = rtype.Id;                
            else if(rtype.name == 'Master Entity')
                masterEntityRecType = rType.Id;
            else if(rType.name == 'Credentialing')
                credentialingRecTypeId = rtype.Id;
            else if(rType.name == 'Network')
                networkRectype = rtype.Id;    
            
            else
                pfinRecTypeId = rtype.Id;
        }
        if(fromPFIN != 'true'){            
            showContracting = true;
            masterEntity = false;
        }else{
            showContracting = false; 
        }
        
        if(masterEntityCase != NULL)
            masterEntity = true;
        else
            masterEntity = false;
        system.debug('####### counterSignTypeId  #######' +counterSignTypeId);       
        if(providerId == NULL || providerId == ''){
            providerNetwork   = new Provider_Networks__c();
            if(masterEntityCase != NULL){
                system.debug('%%% Inside masterEntityCase Logic %%');
                providerNetwork.Master_Entity_Case__c = masterEntityCase;            
                providerNetwork.Network_Load_Plan_Id__c = planId;
                providerNetwork.recordtypeId = masterEntityRecType; 
            }
            else if(credentialingCase != NULL){
                system.debug('%%%% Inside Credentialing Case Logic %%%');                
                for(Case credGroup : [SELECT Id, recordType.Name FROM Case WHERE Id =: credentialingCase]){
                    if(credGroup.recordType.Name.contains('Manual Group')){
                        credGroupManual = true;
                    }
                }                
                List<Provider_Networks__c> provNetworkList = [SELECT Id,Prov_Id__c, ProviderName__c   FROM Provider_Networks__c WHERE credentialing_Case__c =: credentialingCase AND (credentialing_case__r.Completing_the_form_for__c = 'Individual'OR credentialing_case__r.Completing_the_form_for__c = 'Facility' OR credentialing_case__r.Completing_the_form_for__c = 'Ancillary') ORDER BY createdDate ASC];
                system.debug('### provNetworkList ### ' + provNetworkList);
                if(provNetworkList != NULL && provNetworkList.size() > 0){
                    for(Provider_Networks__c provNetwork : provNetworkList){     
                        if(provId == NULL){     
                            provId = provNetwork.Prov_Id__c; 
                            providerName    = provNetwork.providerName__c;       
                            fromIndvPfin = true;       
                        }
                        else       
                            break;          
                    }
                }
                else{
                    fromIndvPfin = true; 
                    showContracting = true;
                    isFirstContract = true;
                }
                providerNetwork.credentialing_Case__c = credentialingCase;
                providerNetwork.Network_Load_Plan_Id__c = planId;
                providerNetwork.recordtypeId = credentialingRecTypeId;
                providerNetwork.Prov_Id__c = provId ;
                providerNetwork.providerName__c = providerName;
                credentialing = true;
                manualcredindividual = true;   
            }
            else if(counterSign != NULL){
                system.debug('%%%% Inside CounterSign Case Logic %%%');
                List<Provider_Networks__c> provNetworkList = [SELECT Id,Prov_Id__c, ProviderName__c    FROM Provider_Networks__c WHERE counterSign__c =: counterSign AND counterSign__r.Completing_the_form_for__c = 'Individual' ORDER BY createdDate ASC];
                system.debug('### provNetworkList ### ' + provNetworkList);
                if(provNetworkList != NULL && provNetworkList.size() > 0){
                    for(Provider_Networks__c provNetwork : provNetworkList){     
                        if(provId == NULL){     
                            provId = provNetwork.Prov_Id__c;
                            providerName    = provNetwork.providerName__c;         
                            fromIndvPfin = true;       
                        }
                        else       
                            break;          
                    }
                }
                else{
                    fromIndvPfin = true; 
                    showContracting = true;
                    isFirstContract = true;
                }
                providerNetwork.CounterSign__c = counterSign;
                providerNetwork.Network_Load_Plan_Id__c = planId;
                providerNetwork.recordtypeId = counterSignTypeId;
                providerNetwork.Prov_Id__c = provId ;
                providerNetwork.providerName__c = providerName;
                counterSignCase = true;
                
            }
            else if(fromPFIN != 'true'){
                system.debug('%%% Inside ContractingCase Logic %%');
                for(Case curCase : [SELECT Id, recordType.Name FROM Case WHERE Id =: contractingCase]){
                    if(curCase.recordType.Name.contains('Group'))
                        contractGroup = true;
                    else
                        contractGroup = false;
                }
                List<Provider_Networks__c> provNetworkList = [SELECT Id,Prov_Id__c, ProviderName__c     FROM Provider_Networks__c WHERE contracting_case__c =: contractingCase AND contracting_case__r.Completing_the_form_for__c = 'Individual' ORDER BY createdDate ASC];
                system.debug('### provNetworkList ### ' + provNetworkList);
                if(provNetworkList != NULL && provNetworkList.size() > 0){
                    for(Provider_Networks__c provNetwork : provNetworkList){     
                        if(provId == NULL){     
                            provId = provNetwork.Prov_Id__c;  
                            providerName    = provNetwork.providerName__c;       
                            fromIndvPfin = true;       
                        }
                        else       
                            break;          
                    }
                }
                else{
                    if(contractGroup == false){                    
                        fromIndvPfin = true; 
                        showContracting = true;
                        isFirstContract = true;
                    }
                }
                providerNetwork.Contracting_case__c = contractingCase;            
                providerNetwork.Network_Load_Plan_Id__c = planId;
                providerNetwork.recordtypeId = contractRecTypeId;
                providerNetwork.Prov_Id__c = provId ;
                providerNetwork.providerName__c = providerName;
                masterEntity = false;
            }
            else if(providernetworkload == true){
                system.debug('network load case');
                 fromIndvPfin = false; 
            
            }
            else{
                system.debug('%%% Inside DataEntry Logic %%');
                for(Provider_Networks__c provNetwork : [SELECT Id,Prov_Id__c, ProviderName__c      FROM Provider_Networks__c WHERE PFIN_case__c =: pfincase AND PFIN_case__r.Completing_the_form_for__c = 'Individual']){
                    if(provId == NULL){
                        provId = provNetwork.Prov_Id__c; 
                        providerName    = provNetwork.providerName__c;  
                        fromIndvPfin = true;
                    }else 
                        break;     
                }
                providerNetwork.PFIN_case__c = pfincase;
                providerNetwork.recordtypeId = pfinRecTypeId;
                providerNetwork.Prov_Id__c = provId;
                providerNetwork.providerName__c = providerName;
            }   
            system.debug('##### provId #####' + provId); 
            system.debug('*** fromIndvPfin ***' + fromIndvPfin);  
            system.debug('*** showContracting ***' + showContracting); 
            system.debug('*** providernetworkload***' + providernetworkload);  
            system.debug('+++++credentialing+++++'+credentialing);
            system.debug('masterEntity+++++'+masterEntity);
            system.debug('+++++manualcredindividual+++'+manualcredindividual);
 
        }
        else{
            system.debug('**** Inside Else Block ****' + providerId);
            Id pfinCaseId; 
            Id firstPfinId;
            for(Provider_Networks__c prov : [SELECT Id, PFIN_Case__c FROM Provider_Networks__c WHERE Id =: providerId AND recordtypeId =: pfinRecTypeId]){
                pfinCaseId = prov.PFIN_Case__c;
            }
            if(pfinCaseId != NULL){
                for(Provider_Networks__c provNet : [SELECT Id, Prov_Id__c FROM Provider_Networks__c WHERE PFIN_Case__c =: pfinCaseId ORDER BY CreatedDate ASC LIMIT 1 ]){
                    firstPfinId = provNet.Id;
                }
            }
            for(Provider_Networks__c provDetail : [SELECT Id, Name, Status__c, ProviderName__c,  Network_Load_Plan_Id__c,recordTypeId, Case_Number__c,Network_Code_Name__c, Prov_Id__c, PFIN_onBoarding__c, Roles_Code__c, 
                                                   Panel_code__c, Master_Entity_Case__c, Networks_Effective_Date__c, Cred_Status__c, Contracting_Case__c, Designation_Code__c, PFIN_Case__c,
                                                   Credentialing_Case__c, CounterSign__c, CounterSign__r.source__c, Credentialing_Case__r.Source__c, Contracting_Case__r.Source__c,isFirstProvider__c, 
                                                   Credentialing_Case__r.recordType.name, Case_Number__r.Id,isFromIndividual__c, Contracting_Case__r.Completing_the_form_for__c,PFIN_case__r.Completing_the_form_for__c, Comp_Grid_Code__c , Comp_Grid_Effective_Date__c 
                                                   FROM Provider_Networks__c WHERE Id =: providerId ]){
                                                       system.debug('#### provDetail RecTypeId ####' + provDetail.recordtypeId);
                                                       providerNetwork = new Provider_Networks__c(Id = provDetail.Id);
                                                       providerNetwork.Network_Load_Plan_Id__c = provDetail.Network_Load_Plan_Id__c;
                                                       providerNetwork.Prov_Id__c = provDetail.Prov_Id__c;
                                                       providerNetwork.PFIN_onBoarding__c = provDetail.PFIN_onBoarding__c;
                                                       providerNetwork.Roles_Code__c = provDetail.Roles_Code__c;
                                                       providerNetwork.Panel_code__c = provDetail.Panel_code__c;
                                                       providerNetwork.Network_Code_Name__c = provDetail.Network_Code_Name__c;
                                                       providerNetwork.Networks_Effective_Date__c = provDetail.Networks_Effective_Date__c;
                                                       providerNetwork.Cred_Status__c = provDetail.Cred_Status__c;
                                                       providerNetwork.Contracting_Case__c = provDetail.Contracting_Case__c;
                                                       providerNetwork.Comp_Grid_Code__c = provDetail.Comp_Grid_Code__c;
                                                       providerNetwork.Comp_Grid_Effective_Date__c = provDetail.Comp_Grid_Effective_Date__c ;
                                                       providerNetwork.Designation_Code__c = provDetail.Designation_Code__c;   
                                                       providerNetwork.PFIN_Case__c = provDetail.PFIN_case__c;
                                                       providerNetwork.Network_Load_Plan_Id__c = provDetail.Network_Load_Plan_Id__c;
                                                       providerNetwork.Master_Entity_Case__c = provDetail.Master_Entity_Case__c;
                                                       providerNetwork.Credentialing_Case__c = provDetail.Credentialing_Case__c;
                                                       providerNetwork.CounterSign__c = provDetail.CounterSign__c;
                                                       providerNetwork.ProviderName__c =ProvDetail.ProviderName__c;
                                                       providerNetwork.Status__c = provDetail.Status__c;
                                                       casePlanId = provDetail.Network_Load_Plan_Id__c;
                                                       planId = provDetail.Network_Load_Plan_Id__c;
                                                       contractingCase = provDetail.Contracting_Case__c;
                                                       pfincase = provDetail.PFIN_case__c;
                                                       masterEntityCase = provDetail.Master_Entity_Case__c;
                                                       credentialingCase = provDetail.Credentialing_Case__c;
                                                       counterSign = provDetail.counterSign__c;
                                                       network  = provDetail.Case_Number__c;
                                                       providerNetwork.Case_Number__c = provDetail.Case_Number__c;

                                                       system.debug('####### provDetail.Credentialing_Case__r.recordType.name ##' + provDetail.Credentialing_Case__r.recordType.name);          
                                                       system.debug('####### provDetail.isFromIndividual__c ##' + provDetail.isFromIndividual__c);
                                                       
                                                       if(provDetail.Contracting_Case__r.Completing_the_form_for__c == 'Individual'){
                                                           fromIndvPfin = true;
                                                           if(provDetail.Contracting_Case__r.Source__c != 'Provider On-boarding Contracting')
                                                               fromIndvContract = true;
                                                       }
                                                       if(provDetail.recordTypeId == contractRecTypeId && provDetail.isFirstProvider__c){
                                                           isFirstContract = true;
                                                       }
                                                       if(fromPFIN =='true' || provDetail.recordTypeId == pfinRecTypeId){
                                                           showContracting = False;
                                                           fromPFIN = 'true';
                                                           masterEntity = false;
                                                           system.debug('### firstPfinId ### ' + firstPfinId );
                                                           system.debug('### providerId ###' + providerId);
                                                           if(provDetail.PFIN_case__r.Completing_the_form_for__c == 'Individual' && firstPfinId != NULL && firstPfinId != providerId)
                                                               fromIndvPfin = true;                       
                                                           system.debug('*** inside PFIN ***');
                                                       }
                                                       else if(provDetail.recordTypeId == contractRecTypeId){ 
                                                           showContracting = True;
                                                           masterEntity = false;
                                                           fromPFIN = 'false';
                                                           system.debug('*** inside Contracting ***');
                                                       }     
                                                       else if(provDetail.recordTypeId == credentialingRecTypeId && provDetail.Credentialing_Case__r.Source__c == 'Provider On-boarding Credentialing' && provDetail.isFromIndividual__c){
                                                           system.debug('#### Inside Credentialing Edit Logic ####');
                                                           credentialing = true;
                                                           manualcredindividual = true;
                                                           if(!provDetail.isFirstProvider__c){
                                                               fromIndvPfin = true;
                                                               isFirstContract = false;
                                                           } 
                                                           else{
                                                               fromIndvPfin = true;
                                                               isFirstContract = true;
                                                           }                       
                                                       }
                                                       else if(provDetail.recordTypeId == credentialingRecTypeId && provDetail.Credentialing_Case__r.Source__c == 'Provider Group On-boarding Credentialing' && !provDetail.isFromIndividual__c){
                                                           system.debug('#### Inside Credentialing group Manual onboard Edit Logic ####');
                                                           credentialing = true;
                                                           fromIndvPfin = true;
                                                           isFirstContract = true; 
                                                           if(provDetail.Credentialing_Case__r.recordType.name.contains('Manual Group')){
                                                               credGroupManual = true;
                                                           }                                     
                                                       }
                                                       else if(provDetail.recordTypeId == counterSignTypeId && provDetail.CounterSign__r.source__c == 'Provider On-boarding Counter Sign' && provDetail.isFromIndividual__c){
                                                           system.debug('#### Inside CounterSign Edit Logic ####');
                                                           counterSignCase = true;                    
                                                           if(!provDetail.isFirstProvider__c){
                                                               fromIndvPfin = true;
                                                               isFirstContract = false;
                                                           }                    
                                                       }
                                                       else if(provDetail.recordTypeId == counterSignTypeId && provDetail.CounterSign__r.source__c == 'Provider Group On-boarding Counter Sign' && !provDetail.isFromIndividual__c){
                                                           system.debug('## Inside CounterSign Group Edit Logic ###');
                                                           counterSignCase = true;
                                                       }
                                                       else if(provDetail.recordTypeId == masterEntityRecType){
                                                           showContracting = true;
                                                           masterEntity = true;                    
                                                       }
                                                       else{
                                                           networkLoad = true;
                                                           //returnCase = provDetail.Case_Number__c;
                                                       }
                                                       system.debug('### fromIndvPfin ####' + fromIndvPfin);
                                                       system.debug('### isFirstContract ####' + isFirstContract );
                                                       system.debug('### counterSignGroup ####' + counterSignGroup);
                                                       system.debug('#### showContracting ####' + showContracting);
                                                       system.debug('#### counterSignCase ####' + counterSignCase);
                                                       system.debug('#### networkLoad ####' + networkLoad );
                                                       system.debug('+++++manualcredindividual ++++'+manualcredindividual );
                                                   }
        }
        

    }

public pageReference SaveAndNewAction(){    
        try{
            String str ='';
            //PPN-24092 Starts
            
            Boolean okayToSave = true;
            if(providerNetwork.Prov_Id__c == NULL ){
                providerNetwork.Prov_Id__c.addError('Please enter PROV ID');
                okayToSave = false;
            }            
            /* PPN-27887 Changes Start */
            if(providerNetwork.Network_Code_Name__c == NULL && flagCase.size() > 0 && flagCase[0].Out_of_Network__c == false && fromPFIN != 'true'){
                providerNetwork.Network_Code_Name__c.addError('Network Name is required');
                okayToSave = false;
            }  
            /* PPN-27887 Changes End */
            if( providerNetwork.PFIN_onBoarding__c == NULL){
                providerNetwork.PFIN_onBoarding__c.addError('Please enter  PFIN');
                okayToSave = false;
            }
            string strProvID = providerNetwork.Prov_Id__c;
            if(providerNetwork.Prov_Id__c!= NULL &&( !providerNetwork.Prov_Id__c.isNumeric() || strProvID .length() >9) ){
                providerNetwork.Prov_Id__c.addError('Invalid Provider ID: Must be maximum of 9 numeric characters');
                okayToSave = false;
            }
            
            string strPFIN = providerNetwork.PFIN_onBoarding__c ;
            if(providerNetwork.PFIN_onBoarding__c != NULL &&( !providerNetwork.PFIN_onBoarding__c .isAlphanumeric () || strPFIN .length() >10) ){
                providerNetwork.PFIN_onBoarding__c.addError('Invalid PFIN Key ID: Must be maximum of 10 alpha numeric characters');
                okayTosave = false;
            }
            // PPN - 31082 Starts
              String CompletingTheForm ;
            String CaseEntity ;
             for(Case contractCase : [SELECT Id,Completing_the_form_for__c,Case_Entity__c   FROM Case WHERE Id =: providerNetwork.Contracting_Case__c ]){
                CompletingTheForm = contractCase.Completing_the_form_for__c ;
                CaseEntity  = contractCase.Case_Entity__c ;
            }
            if(providerNetwork.Contracting_Case__c != NULL   && CompletingTheForm == 'Group'){                
                if( CaseEntity  == NULL){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Case Entity is mandatory. Kindly update Case Entity under Case details section'));
                    okayToSave = false;
                }
            }
            if(ValidateProvIdInGroupContract()== false){
                okayToSave = false;
            }
           // PPN - 31082 Ends
            
            /* if(((providerNetwork.Designation_Code__c != NULL ||  providerNetwork.Comp_Grid_Code__c !=NULL) || (providerNetwork.Designation_Code__c != NULL &&  providerNetwork.Comp_Grid_Code__c !=NULL)) && ( providerNetwork.Networks_Effective_Date__c==NULL) ){
providerNetwork.Networks_Effective_Date__c.addError('Please enter "Network Effective Date');
okayToSave = false;
}*/
            if( !okayToSave ) {
                return null;
            }
            //PPN-24092 Ends
            
            if(fromPFIN != 'true'){
                if(providerNetwork.Network_Code_Name__c != NULL){                
                    for(String s : providerNetwork.Network_Code_Name__c.split(';')){
                        str = str != NULL ? str + '\r\n' + s: s;
                    }
                }               
            }
            providerNetwork.Network_Code_Name_Detail__c = str;
            upsert providerNetwork;
            if(masterEntity)
                return (new PageReference ('/apex/ContractingProviderDetail?id='+idValue+'&masterEntitycase='+masterEntityCase+'&planId='+planId).setRedirect(true));
            else if(credentialing)
                return (new PageReference ('/apex/ContractingProviderDetail?id='+idValue+'&credentialingCase='+credentialingCase+'&planId='+planId).setRedirect(true));
            else if(counterSigncase)
                return (new PageReference ('/apex/ContractingProviderDetail?id='+idValue+'&counterSignCase='+counterSign+'&planId='+planId).setRedirect(true));  
            else if(fromPFIN!='true')        
                return (new PageReference ('/apex/ContractingProviderDetail?id='+idValue+'&contractingcase='+contractingCase+'&planId='+planId).setRedirect(true));
           
            else
                return (new PageReference ('/apex/ContractingProviderDetail?id='+idValue+'&PFINcase='+pfincase+'&fromPFIN=true&planId='+planId).setRedirect(true));
        }
        //PPN - 31138 Starts
        catch(Exception e){
            system.debug('## Exception Occured ##' + e.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            if(e.getMessage() !=NULL && e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,'))
            {
                String splitMessage = e.getMessage().subStringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,splitMessage );  
                //return NULL;                  
            }
             if(e.getMessage() !=NULL && e.getMessage().contains('Duplicate credentialing case in existence for the entered Prov ID'))
            {
                   return NULL;                 
            }
            if(e.getMessage() !=NULL && e.getMessage().contains('DOB missing for Account. Please update the DOB for provider to create the credentialing case'))
            {
                   return NULL;                 
            }
            ApexPages.addMessage(myMsg);
            return NULL;
        }  //PPN - 31138 Ends  
    }  
 public pageReference SaveAction(){
        try{
            String str ='';
            //PPN-24092 Starts
            
            Boolean okayToSave = true;
            /* PPN-27887 Changes Start */
            if(providerNetwork.Network_Code_Name__c == NULL && flagCase.size() > 0 && flagCase[0].Out_of_Network__c == false && fromPFIN != 'true'){
                providerNetwork.Network_Code_Name__c.addError('Network Name is required');
                okayToSave = false;
            }  
            /* PPN-27887 Changes End */
            if(providerNetwork.Prov_Id__c == NULL ){
                providerNetwork.Prov_Id__c.addError('Please enter PROV ID');
                okayToSave = false;
            }            
            
            if( providerNetwork.PFIN_onBoarding__c == NULL){
                providerNetwork.PFIN_onBoarding__c.addError('Please enter  PFIN');
                okayToSave = false;
            }
            string strProvID = providerNetwork.Prov_Id__c;
            if(providerNetwork.Prov_Id__c!= NULL &&( !providerNetwork.Prov_Id__c.isNumeric() || strProvID .length() >9) ){
                providerNetwork.Prov_Id__c.addError('Invalid Provider ID: Must be maximum of 9 numeric characters');
                okayToSave = false;
            }
            
            string strPFIN = providerNetwork.PFIN_onBoarding__c ;
            if(providerNetwork.PFIN_onBoarding__c != NULL &&( !providerNetwork.PFIN_onBoarding__c .isAlphanumeric () || strPFIN .length() >10) ){
                providerNetwork.PFIN_onBoarding__c.addError('Invalid PFIN Key ID: Must be maximum of 10 alpha numeric characters');
                okayTosave = false;
            }
            
            // PPN - 31082 Starts
              String CompletingTheForm ;
            String CaseEntity ;
             for(Case contractCase : [SELECT Id,Completing_the_form_for__c,Case_Entity__c   FROM Case WHERE Id =: providerNetwork.Contracting_Case__c ]){
                CompletingTheForm = contractCase.Completing_the_form_for__c ;
                CaseEntity  = contractCase.Case_Entity__c ;
            }
            if(providerNetwork.Contracting_Case__c != NULL   && CompletingTheForm == 'Group'){                
                if( CaseEntity  == NULL){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Case Entity is mandatory. Kindly update Case Entity under Case details section'));
                    okayToSave = false;
                }
            }
            if(ValidateProvIdInGroupContract()== false){
                okayToSave = false;
            }
           // PPN - 31082 Ends
            
            /* if(((providerNetwork.Designation_Code__c != NULL ||  providerNetwork.Comp_Grid_Code__c !=NULL) || (providerNetwork.Designation_Code__c != NULL &&  providerNetwork.Comp_Grid_Code__c !=NULL)) && ( providerNetwork.Networks_Effective_Date__c==NULL) ){
providerNetwork.Networks_Effective_Date__c.addError('Please enter "Network Effective Date');
okayToSave = false;
}*/
            if( !okayToSave ) {
                return null;
            }
            //PPN-24092 Ends
            
            if(fromPFIN != 'true'){
                if(providerNetwork.Network_Code_Name__c != NULL){                
                    for(String s : providerNetwork.Network_Code_Name__c.split(';')){
                        str = str != NULL ? str + '\r\n' + s: s;
                    }
                }
            }
            
            providerNetwork.Network_Code_Name_Detail__c = str;
           // try{
                        upsert providerNetwork;
                        
              /*  }catch(Exception e){
                system.debug('## Exception Occured ##' + e.getMessage());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                if(e.getMessage() !=NULL && e.getMessage().contains('Duplicate credentialing case in existence for the entered Prov ID'))
                {
                    return NULL;                 
                }
                ApexPages.addMessage(myMsg);
                return NULL;
                }*/
            
            if(masterEntity){
                system.debug('**** Redirect to Master Entity Case ****'+ masterEntitycase);
                return (new PageReference ('/'+masterEntitycase).setRedirect(true));
            }
            else if(credentialing){
                system.debug('**** Redirect to Credentialing Case ****'+ credentialingcase);
                return (new PageReference ('/'+credentialingcase).setRedirect(true));
            }
            else if(counterSignCase){
                system.debug('**** Redirect to Credentialing Case ****'+ credentialingcase);
                return (new PageReference ('/'+counterSign).setRedirect(true));
            }
            else if(fromPFIN == 'true')
            {
                system.debug('**** Redirect to PFIN Case ****'+ pfinCase);
                return (new PageReference ( '/'+pfinCase).setRedirect(true));
            }
            else if(providernetworkload == true){
                system.debug('**** Redirect to network Case ****'+ Network);
                return (new PageReference ('/'+Network).setRedirect(true));
            }
            else
            {
                system.debug('**** Redirect to Contracting Case ****' + contractingCase);
                return (new PageReference ( '/'+contractingCase).setRedirect(true)); 
            }
        }
        //PPN - 31138 Starts
        catch(Exception e){
            system.debug('## Exception Occured ##' + e.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            if(e.getMessage() !=NULL && e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,'))
            {
                String splitMessage = e.getMessage().subStringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,splitMessage ); 
               // return NULL;                   
            }
            if(e.getMessage() !=NULL && e.getMessage().contains('Duplicate credentialing case in existence for the entered Prov ID'))
                {
                    return NULL;                 
                }
                if(e.getMessage() !=NULL && e.getMessage().contains('DOB missing for Account. Please update the DOB for provider to create the credentialing case'))
            {
                   return NULL;                 
            }
            ApexPages.addMessage(myMsg);
            return NULL;
        }//PPN - 31138 Ends
    }
    
    public pageReference backTocase(){ 
        system.debug('*** fromPFIN ****' + fromPFIN  );   
        system.debug('*** contractingCase****' + contractingCase);    
        if(masterEntity)
            return (new PageReference ('/'+masterEntitycase).setRedirect(true));
        else if(credentialing)
            return (new PageReference ('/'+credentialingcase).setRedirect(true));
        else if(counterSignCase)
            return (new PageReference ('/'+counterSign).setRedirect(true));
         else if(contractingCase != null && fromPFIN != 'true')
            return (new PageReference ('/'+contractingCase).setRedirect(true));
        else if(providernetworkload == true)
            //system.debug('**** Redirect backtocase network Case ****'+ Network);
            return (new PageReference ('/'+Network).setRedirect(true));
        else
            return (new PageReference ('/'+pfinCase).setRedirect(true));     
    }
    public pageReference pageRedirect(){
        //if(networkLoad)
        //return (new PageReference ('/'+providerId+'/e?nooverride=1&retURL='+returnCase));
        if (counterSignGroup || networkLoad)
            return (new PageReference ('/'+providerId));
        else
            return NULL;
    }
    public Boolean ValidateProvIdInGroupContract()
    {
            Id physicianId,entityId;          
            Boolean okayToSave;
            Boolean isAvailable = False;
            Set<String> setOfProvId = new Set<String>();
            system.debug('Coming inside before update');
            if(providerNetwork.Prov_Id__c != NULL && (providerNetwork.Contracting_Case__c != NULL || providerNetwork.CounterSign__c != NULL ) )
            {
                for(RecordType newType:[Select Id,Name From RecordType Where sObjectType='Account' and (Name='Physician' OR Name='Entity Account')])
                {
                    if(newType.Name=='Physician')
                    {
                        physicianId=newType.Id;
                    }
                    else
                    {
                        entityId=newType.Id;
                    }
                }
                String CompletingTheForm ;
                 for(Case contractCase : [SELECT Id,Completing_the_form_for__c FROM Case WHERE (Id =: providerNetwork.Contracting_Case__c OR Id =: providerNetwork.CounterSign__c) ]){
                    CompletingTheForm = contractCase.Completing_the_form_for__c ;
                }
                If(CompletingTheForm  == 'Group')
                {
                    for(Account accountToVerify : [Select Id, Name, Prov_Id__c From Account where (RecordTypeId =: entityId OR RecordTypeId =: physicianId) and  Prov_Id__c  = : providerNetwork.Prov_Id__c ])
                    {
                        isAvailable =True;
                    }           
                    if(!isAvailable)
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the valid 9 digit Prov ID'));
                        okayToSave = false;                                  
                    } 
                }
            }
            
            return okayToSave; 
           
    }
   






}