/* Author - SETHURAMAN
08/10/2018 - Created by Sethuraman for PPN-20984 
09/04/2018 - PPN-23521 by Sethuraman 
09/07/2018 - PPN-24816 by Sethuraman  
10/19/2018 - PPN-26580 by Subhashini 
10/19/2018 - PPN-26583 by Subhashini
11/15/2018 - PPN-27887 by Laxman
*/
public without Sharing class ContractingDetailsEditPageLigh{

   
    public string contractingCase  {get; set;}
    public string masterEntityCase {get;set;}
    public string credentialingCase {get;set;}
    public string planId           {get;set;}
    public string providerId       {get;set;}
    public boolean groupData       {get;set;}
    public boolean showContracting {get;set;}  
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
    public Id caseId;
    public list<case> flagCase = new list<Case>();
    public String idValue;
    //sujatha ncase
    Public String network {get; set;}
    public boolean providernetworkload {get; set;}
    public boolean showerror {get;set;}
    public boolean showPaperCredIndicator {get;set;}
    
    
    public ContractingDetailsEditPageLigh(ApexPages.StandardController std){
    
      idValue = ApexPages.currentPage().getParameters().get('Id');
      providernetworkload = false;
      showerror = false;
     
      system.debug('idvalue---'+idvalue);
      if(idValue !=NULL && case.sobjecttype.getDescribe().getKeyPrefix()==idValue.substring(0,3))
      {
          caseId = idValue;
          system.debug('caseId '+caseId );
      }
      else
      {
          providerId = idValue;
          system.debug('providerId '+providerId );
      }
      
    
     // if(providerId == null || providerId ==''){
      List<Provider_Networks__c> curCaseId = [SELECT Id,PFIN_Case__c,Contracting_Case__c FROM Provider_Networks__c where Id =: providerId];
      List<Case> casePlanInfo = new List<Case>();
      if(curCaseId!=null && curCaseId.size() > 0){
          casePlanInfo =[Select Id, status, Plan_ID__c , recordTypeId,Completing_the_form_for__c from Case where Id =: curCaseId[0].PFIN_Case__c];
      }
        
        /* PPN-40403, PPN-41871 Changes Start *///if possible merge above query and below query. 
        List<Case> caseCompletingList = new List<Case>();
        if(curCaseId!=null && curCaseId.size() > 0){
          caseCompletingList =[Select Id, status, Plan_ID__c , recordTypeId,Completing_the_form_for__c from Case where Id =: curCaseId[0].PFIN_Case__c OR Id =: curCaseId[0].Contracting_Case__c];
        }

        
        if(caseCompletingList.size() > 0 && caseCompletingList[0].Completing_the_form_for__c  == 'Group'){
             showPaperCredIndicator =true;
        }
        
        if(casePlanInfo.size() > 0 && (casePlanInfo[0].status == 'Closed Processed' || casePlanInfo[0].status == 'Closed Rejected')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create new Provider record under Closed Case.'));
            showerror = true;
        }
        if(casePlanInfo.size() > 0){        
            planId  = casePlanInfo[0].Plan_ID__c;
        }      
         List<RecordType> providerdetailRecordType = [SELECT Id, Name FROM RecordType WHERE sObjectType='Provider_Networks__c' limit 1] ;
         if(providerdetailRecordType[0].Name == 'PFIN Onboarding'){
                 pfincase = caseId; 
                 fromPFIN = 'true';  
        
         }
        else if(providerdetailRecordType[0].name == 'Contracting Onboarding'){
                contractingCase = caseId ;
                fromPFIN= 'false';
        }
      
       
      
       List<Provider_Networks__c> provDetailCaseInfo = [SELECT Id, Name,recordtypeId,Contracting_Case__c,CounterSign__c,Case_Number__c,PFIN_Case__c,Case_Number__r.id,Case_Number__r.Plan_Id__c,
                                                       Contracting_Case__r.id,CounterSign__r.id,Contracting_Case__r.Plan_ID__c,CounterSign__r.Plan_ID__c,PFIN_case__r.Plan_ID__c 
                                                       FROM Provider_Networks__c 
                                                       WHERE Id =: providerId limit 1 ] ;
       Id providerDContRtype= Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Contracting Onboarding').getRecordTypeId();
       Id providerDPFINRtype= Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('PFIN Onboarding').getRecordTypeId();
       Id providerDCredRtype= Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Credentialing').getRecordTypeId();
       Id providerCounterSignRtype= Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('CounterSign').getRecordTypeId();
       //netwcase change
       Id providerNetworkLoadRtype= Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Network').getRecordTypeId();


       system.debug('providerDPFINRtype'+providerDPFINRtype);
       system.debug('providerDContRtype'+providerDContRtype);
       system.debug('providerDCredRtype'+providerDCredRtype);
       //system.debug('provDetailCaseInfo[0].recordtypeId'+provDetailCaseInfo[0].recordtypeId);

     if(provDetailCaseInfo .size()>0 && provDetailCaseInfo[0].recordtypeId == providerDPFINRtype){
      caseId  = provDetailCaseInfo[0].PFIN_Case__r.id;
      planId   = provDetailCaseInfo[0].PFIN_Case__r.Plan_ID__c;
      pfincase = caseID; 
      fromPFIN = 'true'; 
      fromIndvContract = true;
      showContracting = true;
      system.debug('casePlanInfo.size()'+caseId  );
      system.debug('planId'+planId );
      }   
      else if(provDetailCaseInfo .size()>0 && provDetailCaseInfo[0].recordtypeId == providerDContRtype){       
                  
            system.debug('inside else if contracting');  
            caseId  = provDetailCaseInfo[0].Contracting_Case__r.id;
            planId   = provDetailCaseInfo[0].Contracting_Case__r.Plan_ID__c;
            contractingCase = caseId;
            fromPFIN= 'false';
            fromIndvContract = true;
            showContracting =true;
            system.debug('casePlanInfo.size()'+caseId  );
            system.debug('planId'+planId );
        }           
        else if(provDetailCaseInfo .size()>0 && provDetailCaseInfo[0].recordtypeId == providerDCredRtype){       
                  
            system.debug('inside else if credentialing');  
            caseId  = provDetailCaseInfo[0].Contracting_Case__r.id;
            planId   = provDetailCaseInfo[0].Contracting_Case__r.Plan_ID__c;
            credentialingCase   = caseId;
            //credentialing = true;
            fromPFIN= 'false';
            fromIndvContract = false;
           // fromIndvContract = true;
            system.debug('casePlanInfo.size()'+caseId  );
            system.debug('planId'+planId );
        }      
        else if(provDetailCaseInfo .size()>0 && provDetailCaseInfo[0].recordtypeId == providerCounterSignRtype){       
                  
            system.debug('inside else if CounterSign');  
            caseId  = provDetailCaseInfo[0].CounterSign__r.id;
            planId   = provDetailCaseInfo[0].CounterSign__r.Plan_ID__c;
            counterSign   = caseId;
            fromPFIN= 'false';
            fromIndvContract = false;    
            fromIndvPfin = false; 
            counterSignGroup = true;       
            system.debug('casePlanInfo.size()'+caseId  );
            system.debug('planId'+planId );
        }               
        else if(provDetailCaseInfo .size()>0 && provDetailCaseInfo[0].recordtypeId == providerNetworkLoadRtype){       
                  
            system.debug('inside else if network');  
            caseId  = provDetailCaseInfo[0].Case_Number__r.id;
            planId   = provDetailCaseInfo[0].Case_Number__r.Plan_ID__c;
            network  = caseId;
            fromIndvContract = false;  
            providernetworkload = true;
            fromIndvPfin = true;
            isFirstContract = false;
            system.debug('casePlanInfo.size()'+caseId  );
            system.debug('planId'+planId );
        }
            system.debug('network ++++++ '+network );

        
        if(providerId == NULL || providerId == '')
        {
            providerId = ApexPages.currentPage().getParameters().get('Id');
        }
        
        /* PPN-27887 Changes Start */
        if(contractingCase != null)
            caseId = contractingCase;        
        else if(credentialingCase != null)
            caseId = credentialingCase;
        else if(counterSign!= null)
            caseId = counterSign;
        else if(network != null)
            caseId = network;
       
        
        system.debug('providerId:' + providerId);
        system.debug('CaseId:' + CaseId);
        system.debug('stdController.getId():' + std.getId());
        System.debug('fromPFIN===>>>'+fromPFIN);
        if(caseId != null){
            system.debug('inside 1');            
        }else if(std.getId() != null){
            Provider_Networks__c p = new Provider_Networks__c();
            p = [select id,Contracting_Case__c,CounterSign__c,Credentialing_Case__c,PFIN_Case__c,Case_Number__c from Provider_Networks__c where id = :std.getID()];
            if(p.Contracting_Case__c != null)
                caseId = p.Contracting_Case__c;            
            else if(p.Credentialing_Case__c != null)
                caseId = p.Credentialing_Case__c; 
            else if(p.CounterSign__c!= null)
                caseId = p.CounterSign__c;    
            else if(p.Case_Number__c != null)
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
        isFirstContract = false;
        credentialing = false;
        contractGroup = false;
        credGroupManual = false;
        for(RecordType rType : [SELECT Id, Name FROM RecordType WHERE sObjectType='Provider_Networks__c' AND 
                               (Name = 'Network' OR Name = 'Contracting Onboarding' OR Name = 'PFIN Onboarding' OR Name = 'CounterSign' OR Name='Master Entity' OR Name = 'Credentialing')]){
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
                List<Provider_Networks__c> provNetworkList = [SELECT Id,Prov_Id__c, ProviderName__c FROM Provider_Networks__c WHERE credentialing_Case__c =: credentialingCase AND 
                                                              credentialing_case__r.Completing_the_form_for__c = 'Individual' ORDER BY createdDate ASC];
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
            }
            else if(counterSign != NULL){
                system.debug('%%%% Inside CounterSign Case Logic %%%');
                List<Provider_Networks__c> provNetworkList = [SELECT Id,Prov_Id__c, ProviderName__c,CounterSign__c FROM Provider_Networks__c WHERE counterSign__c =: counterSign AND 
                                                              counterSign__r.Completing_the_form_for__c = 'Individual' ORDER BY createdDate ASC];
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
                system.debug('contractGroup +++'+contractGroup );
                List<Provider_Networks__c> provNetworkList = [SELECT Id,Prov_Id__c, ProviderName__c     FROM Provider_Networks__c WHERE contracting_case__c =: contractingCase AND 
                                                              contracting_case__r.Completing_the_form_for__c = 'Individual' ORDER BY createdDate ASC];
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
            system.debug('*** fromIndvPfin ***' + fromIndvPfin); 
            system.debug('*** providernetworkload ***' + providernetworkload);  
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
                                                   Panel_code__c, Master_Entity_Case__c, Networks_Effective_Date__c, Cred_Status__c, Contracting_Case__c, Designation_Code__c, PFIN_Case__c,Paper_Cred_Indicator__c,
                                                   Credentialing_Case__c, CounterSign__c,CounterSign__r.source__c, Credentialing_Case__r.Source__c, Contracting_Case__r.Source__c,isFirstProvider__c, 
                                                   Credentialing_Case__r.recordType.name, isFromIndividual__c,Case_Number__R.id, Contracting_Case__r.Completing_the_form_for__c,PFIN_case__r.Completing_the_form_for__c,
                                                   Comp_Grid_Code__c , Comp_Grid_Effective_Date__c 
                                                   FROM Provider_Networks__c WHERE Id =: providerId ]){
                                                       system.debug('#### provDetail RecTypeId ####' + provDetail.recordtypeId);
                                                       providerNetwork = new Provider_Networks__c(Id = provDetail.Id);
                                                       providerNetwork.Network_Load_Plan_Id__c = provDetail.Network_Load_Plan_Id__c;
                                                       providerNetwork.Prov_Id__c = provDetail.Prov_Id__c;
                                                       providerNetwork.PFIN_onBoarding__c = provDetail.PFIN_onBoarding__c;
                                                       providerNetwork.Roles_Code__c = provDetail.Roles_Code__c;
                                                       providerNetwork.Panel_code__c = provDetail.Panel_code__c;
                                                       providerNetwork.Network_Code_Name__c = provDetail.Network_Code_Name__c;
                                                       System.debug('Contarcting Network Name ======>>>>'+providerNetwork.Network_Code_Name__c);
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
                                                       providerNetwork.Paper_Cred_Indicator__c = provDetail.Paper_Cred_Indicator__c;                                                       
                                                       casePlanId = provDetail.Network_Load_Plan_Id__c;
                                                       planId = provDetail.Network_Load_Plan_Id__c;
                                                       contractingCase = provDetail.Contracting_Case__c;
                                                       pfincase = provDetail.PFIN_case__c;
                                                       masterEntityCase = provDetail.Master_Entity_Case__c;
                                                       credentialingCase = provDetail.Credentialing_Case__c;
                                                       counterSign = provDetail.CounterSign__c;
                                                       network  = provDetail.Case_Number__c;
                                                       providerNetwork.Case_Number__c = provDetail.Case_Number__c;
                                                       system.debug('providerNetwork.Case_Number__c++++++++'+providerNetwork.Case_Number__c);
                                                       system.debug('provDetail.Prov_Id__c'+provDetail.Prov_Id__c);
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
                                                            system.debug('credentialing @@@@@'+credentialing );
                                                           credentialing = true;                                                          
                                                           system.debug('credentialing @@@@@'+credentialing );
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
                                                       else if(provDetail.recordTypeId == credentialingRecTypeId && (provDetail.Credentialing_Case__r.Source__c == 'Provider On-boarding Credentialing - Ancillary' || provDetail.Credentialing_Case__r.Source__c == 'Provider On-boarding Credentialing - Facility')){
                                                           
                                                           credentialing = true;
                                                           if(!provDetail.isFirstProvider__c){
                                                               fromIndvPfin = true;
                                                               isFirstContract = false;
                                                           } 
                                                           else{
                                                               fromIndvPfin = true;
                                                               isFirstContract = true;
                                                           }                                                                                                    
                                                       }
                                                       else if(provDetail.recordTypeId == counterSignTypeId && provDetail.CounterSign__r.source__c == 'Provider Group On-boarding Counter Sign' && !provDetail.isFromIndividual__c){
                                                           system.debug('## Inside CounterSign Group Edit Logic ###');
                                                           counterSignCase = true;
                                                       }
                                                        else if(provDetail.recordTypeId == counterSignTypeId && provDetail.CounterSign__r.source__c != 'Provider Group On-boarding Counter Sign' && !provDetail.isFromIndividual__c){
                                                           system.debug('## Inside CounterSign Group Edit Logic ###');
                                                           counterSignGroup = true;
                                                       }
                                                        else if(provDetail.recordTypeId == counterSignTypeId && provDetail.CounterSign__r.source__c != 'Provider On-boarding Counter Sign' && provDetail.isFromIndividual__c){
                                                           counterSignGroup = true;              
                                                       }
                                                       else if(provDetail.recordTypeId == credentialingRecTypeId && provDetail.Credentialing_Case__r.Source__c != 'Provider On-boarding Credentialing' && provDetail.isFromIndividual__c){
                                                           counterSignGroup = true;              
                                                       }
                                                       else if(provDetail.recordTypeId == masterEntityRecType){
                                                           showContracting = true;
                                                           masterEntity = true;                    
                                                       }
                                                       else if(provDetail.recordTypeId == networkRectype){
                                                               fromIndvPfin = true;
                                                               isFirstContract = false;
                                                       
                                                       }
                                                       else{
                                                           networkLoad = true; 
                                                       }
                                                       system.debug('### fromIndvPfin ####' + fromIndvPfin);
                                                       system.debug('### isFirstContract ####' + isFirstContract );
                                                       system.debug('### counterSignGroup ####' + counterSignGroup);
                                                       system.debug('#### showContracting ####' + showContracting);
                                                       system.debug('#### counterSignCase ####' + counterSignCase);
                                                       system.debug('#### networkLoad ####' + networkLoad );
                                                       system.debug('### providernetworkload ###'+providernetworkload);
                                                   }
        }
    }
    
    public pageReference pageRedirect(){
        
        if (counterSignGroup){
            return (new PageReference ('/'+providerId));
        }else{
            return NULL;
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
            
          
            if( !okayToSave ) {
                return null;
            }
            //PPN-24092 Ends
            
            if(fromPFIN != 'true'){
                if(providerNetwork.Network_Code_Name__c != NULL)
                {  
                    System.debug('providerNetwork.Network_Code_Name__c===>>>>'+providerNetwork.Network_Code_Name__c);
                    for(String s : providerNetwork.Network_Code_Name__c.split(';')){
                        str = str != NULL ? str + '\r\n' + s: s;
                    }
                }               
            }
            providerNetwork.Network_Code_Name_Detail__c = str;
            upsert providerNetwork;
            
           
            
            if(masterEntity)
                return (new PageReference ('/apex/ContractingProviderDetail?id='+caseId+'&masterEntitycase='+masterEntityCase+'&planId='+planId).setRedirect(true));
            else if(credentialing)
                return (new PageReference ('/apex/ContractingProviderDetail?id='+caseId+'&credentialingCase='+credentialingCase+'&planId='+planId).setRedirect(true));
            else if(counterSigncase)
                return (new PageReference ('/apex/ContractingProviderDetail?id='+caseId+'&counterSignCase='+counterSign+'&planId='+planId).setRedirect(true));  
            else if(fromPFIN!='true')        
                return (new PageReference ('/apex/ContractingProviderDetail?id='+caseId+'&contractingcase='+contractingCase+'&planId='+planId).setRedirect(true));
           
            else
                return (new PageReference ('/apex/ContractingProviderDetail?id='+caseId+'&PFINcase='+pfincase+'&fromPFIN=true&planId='+planId).setRedirect(true));
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
          
            ApexPages.addMessage(myMsg);
            return NULL;
        }   //PPN - 31138 Ends   
    }    
    
    public pageReference SaveAction(){
        try{
            String str ='';
            //PPN-24092 Starts
            
            Boolean okayToSave = true;
            
            /* PPN-40403, PPN-41871 Changes Start */
            if(providerNetwork.Paper_Cred_Indicator__c==true){
                            
                List<ContentDocumentLink> contDocLinkList =  [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId=:providerNetwork.Id];
                system.debug('**********'+contDocLinkList);
                if(contDocLinkList==null || contDocLinkList.size()==0){
                    providerNetwork.Paper_Cred_Indicator__c.addError('Please attach the paper credentialing application to the case.');
                    return null;
                }
            }
            
             if(providerNetwork.Paper_Cred_Indicator__c==false && providerNetwork.Contracting_Case__c!=null){
             
                List<Case> parentCaseList = [Select Id,ParentId from Case Where Id=:providerNetwork.Contracting_Case__c]; 
                system.debug('**********'+parentCaseList[0].ParentId);
                String groupDataEntryRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Group_Provider_On_boarding').getRecordTypeId();
                List<Case> dataEntryCaseList = [Select Id from Case Where ParentId =:parentCaseList[0].ParentId  AND RecordTypeId=:groupDataEntryRecTypeId ];
                system.debug('**********'+dataEntryCaseList);
                if(dataEntryCaseList!=null && dataEntryCaseList.size()>0){
                            
                    List<Provider_Networks__c> provNetList = [SELECT Id,Paper_Cred_Indicator__c,Contracting_Case__c,Prov_Id__c,PFIN_Case__c,PFIN_onBoarding__c
                                                            FROM Provider_Networks__c WHERE 
                                                            Paper_Cred_Indicator__c = true AND PFIN_Case__c=:dataEntryCaseList[0].Id AND Prov_Id__c=:providerNetwork.Prov_Id__c AND PFIN_onBoarding__c=:providerNetwork.PFIN_onBoarding__c AND PFIN_Case__c!=NULL];
                    system.debug('**********'+provNetList );
                    if(provNetList!=null && provNetList.size()>0){
                        providerNetwork.Paper_Cred_Indicator__c.addError('You cant uncheck paper credentialing indicator.');
                        return null;
                    }
                
                }
            }
   
            /* PPN-40403, PPN-41871 Changes End */
           
              
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
                        
            string strPFIN = providerNetwork.PFIN_onBoarding__c ;
            if(providerNetwork.PFIN_onBoarding__c != NULL &&( !providerNetwork.PFIN_onBoarding__c .isAlphanumeric () || strPFIN .length() >10) ){
                providerNetwork.PFIN_onBoarding__c.addError('Invalid PFIN Key ID: Must be maximum of 10 alpha numeric characters');
                okayTosave = false;
            }
            
                       
            if( !okayToSave ) {
                return null;
            }
            //PPN-24092 Ends
            
            if(fromPFIN != 'true'){
                if(providerNetwork.Network_Code_Name__c != NULL)
                {   
                    System.debug('providerNetwork.Network_Code_Name__c1111====>>>'+providerNetwork.Network_Code_Name__c);
                    for(String s : providerNetwork.Network_Code_Name__c.split(';')){
                        str = str != NULL ? str + '\r\n' + s: s;
                    }
                }
            }
            
            providerNetwork.Network_Code_Name_Detail__c = str;
            upsert providerNetwork;
            
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
                String splitMessage1 = splitMessage.RemoveEnd(': []');
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,splitMessage1);
               // return NULL; 
                
            }
            if(e.getMessage() !=NULL && e.getMessage().contains('Duplicate credentialing case in existence for the entered Prov ID'))
            {
                   return NULL;                 
            }         
            //ApexPages.addMessage(myMsg); //Commented by Ashok N for the defects PPN-48606 on 07/12/2019
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
        else if(contractingCase != null && fromPFIN  !=null && fromPFIN != 'true')
            return (new PageReference ('/'+contractingCase).setRedirect(true));
        else if(providernetworkload == true)
            //system.debug('**** Redirect backtocase network Case ****'+ Network);
            return (new PageReference ('/'+Network).setRedirect(true));
        else
            return (new PageReference ('/'+pfinCase).setRedirect(true));     
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