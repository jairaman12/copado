/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Laxman Vattam             01/29/2019             PPN-30575 
* Subhashini             03/19/2019             PPN-30306
*
*/


public   class ProviderDetailsTriggerHandler {
/*
-----------------------------------------------------------------------------
* Developer Name :Laxman Vattam   
Date     01/29/2019              
Description :PPN-30575 - Update Network Load case Account based on Prov id On Provider Details
ver 1.0
  
*/
 public Boolean ValidateCredStatus  = true;

    public void updateAccountonNetworkLoadCases(list<Provider_Networks__c> newList)
    {
        system.debug('ProviderDetailsTrigger: Laxman: Start');
        list<Provider_Networks__c> newprovdetList = new list<Provider_Networks__c>();
        newprovdetList = (list<Provider_Networks__c>)newList;
        Map<Id,RecordType> Map_RecordTypeValues = new map<Id,RecordType>([SELECT Id,sobjectType, Name,developerName FROM recordType WHERE 
                                                                      sObjectType ='Provider_Networks__c' AND developerName = 'Network']);
       
        Map<Integer,Id> Map_RecordTypeName= new Map<Integer,Id>();
        for(RecordType RecordTypeValues : Map_RecordTypeValues.values())
        {
            if(RecordTypeValues.developerName=='Network')
            {
               Map_RecordTypeName.put(0,RecordTypeValues.Id);
            }
           
        }
        //Id networkRtypeId = rType.Id;
        list<Id> caseIdList = new list<Id>();
        set<string> setOfProvId = new set<string>();
        map<string,Id> casePFINMap = new map<string,Id>();
        for(Provider_Networks__c pList : newprovdetList){
            system.debug('pList.RecordTypeId'+pList.RecordTypeId);
            if(pList.RecordTypeId == Map_RecordTypeName.get(0)){
                system.debug('netoekcases');
                caseIdList.add(plist.Case_Number__c);
                setOfProvId.add(plist.Prov_id__c);
                casePFINMap.put(plist.Prov_id__c,plist.Case_Number__c);
            }           
        }
        system.debug('caseIdList:' + caseIdList);
        system.debug('setOfProvId:' + setOfProvId);
        system.debug('casePFINMap:' + casePFINMap);
        map<id,case> caseMap = new map<id,Case>();
        list<case> caseList = new list<case>();
        for(Case c: [select id,accountid from case where id in :caseIdList]){
            caseMap.put(c.id,c);
            caseList.add(c);
        }
        system.debug('caseMap:' + caseMap);
        system.debug('caseList:' + caseList);
        Set<Case> updateCaseSet = new Set<Case>();
        list<case> updateCase = new list<case>();
        for(account a:[select id,prov_id__c from account where prov_id__c in :setOfProvId]){
            case c = caseMap.get(casePFINMap.get(a.prov_id__c));
            c.accountid = a.Id;
            //updateCase.add(c);
            updateCaseSet .add(c);
        }
        system.debug('updateCaseSet :' + updateCaseSet );
        updateCase.addall(updateCaseSet);
        if(updateCase.size() > 0)
            update updateCase;       
        system.debug('ProviderDetailsTrigger: Laxman: End');
    }
    
  
    /*
-----------------------------------------------------------------------------
* Developer Name :Subhashini 
Date     03/19/2019              
Description :PPN-30306 - Update Network Load case Account based on Prov id On Provider Details
ver 1.0

*/
    
    
    /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Subhashini             03/19/2019             PPN-30306 ValidateDuplicateCredentialingCase
  Subhashini             05/02/2019                PPN - 39252 Validate DOB for ProviderAccount                                           
*/ 
   Public  Void ValidateDuplicateCredentialingCase(List<Provider_Networks__c> newTrigger, Map<Id, Provider_Networks__c>  oldMap)
    {
         
        ValidateCredStatus  =false;
        Set<String> setOfProvId = new Set<String>();
        Set<String> setOfAccount = new Set<String>();
        Set<String> setOfProviderWithoutNPI = new Set<String>();
        Map <string , Id> mapofContractCaseAndAccount =new Map<string, Id >();
       
        Id  physicianId; 
        Id IndvCredRecordTypeId;
        Id groupCredRecordTypeId;
        Id ManualgroupCredRecordTypeId;
        Map<String, String> mapofAccountAndDOB = new Map<String, String>();
        List<CM_Provider_Identification__c> lstAccoutNPI = new List<CM_Provider_Identification__c>();
        
        system.debug('coming inside ValidateDuplicateCredentialingCase');
        IndvCredRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        groupCredRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
        ManualgroupCredRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Manual_Group_On_boarding_Credentialling').getRecordTypeId();
        /* Comments by u393129  Let's keep that you have right now just for learing purposue 
        Map<Id,RecordType> Map_QueryRecordType= new Map<Id,RecordType>();
        Map_QueryRecordType=[select Id,DeveloperName,Name from recordtype where sobjectType='']
       */

        for(Provider_Networks__c  providerDetails : newTrigger)
            {    
               system.debug('!!!!!!!providerDetails'+providerDetails);
               if(ProviderDetails.Prov_Id__c != NULL && ProviderDetails.Contracting_Case__c != NULL  && ProviderDetails.isFromIndividual__c == false )
               {                
                    if(ProviderDetails.Cred_Status__c == 'Needs Credentialing')
                    setOfProvId.add(ProviderDetails.Prov_Id__c);
                   
                }
            }
            physicianId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();
          
            if(!setOfProvId.isEmpty())
            {
                for(Account accountToVerify : [Select Id, Name, Prov_Id__c, Date_of_Birth__c  From Account where  RecordTypeId =: physicianId and  Prov_Id__c  IN : setOfProvId ])
                {
                    if(accountToVerify.Id != NULL)    {
                        setOfAccount.add(accountToVerify.Id);
                        mapofAccountAndDOB.put(accountToVerify.Prov_Id__c, String.valueOf(accountToVerify.Date_of_Birth__c));                       
                        //mapofAccountAndDOB.put(accountToVerify.Id, accountToVerify));                     
                    }
                }
            }
            if(!setOfAccount.isEmpty())
            {
                for(Case credCase : [SELECT ID, ACCOUNTID,  Account.Prov_ID__c , STATUS, ISCLOSED  FROM CASE WHERE ACCOUNTID IN : setOfAccount AND (ISCLOSED = FALSE OR (STATUS IN('Admin Denial' , 'Application Returned') AND     Check_for_90_days__c = FALSE) ) AND  (RecordTypeId = : IndvCredRecordTypeId OR RecordTypeId = : groupCredRecordTypeId OR RecordTypeId = : ManualgroupCredRecordTypeId) ])
                {
                    if(credCase.AccountId != NULL)
                    {
                        if(!mapofContractCaseAndAccount.containsKey(credCase.Id))
                        {
                            mapofContractCaseAndAccount.put( credCase.Account.Prov_ID__c, credCase.Id );
                        }              
                    }
                }
            }
            system.debug('mapofContractCaseAndAccount'+mapofContractCaseAndAccount);
            system.debug('oldMap ****' +oldMap);
            system.debug('setOfAccount'+setOfAccount);
            if(!setOfAccount.isEmpty())
            {
              
                for(CM_Provider_Identification__c actNPI : [select Id,  CM_Prvdr_Iden_Typ_Cd__c, CM_Issu_Ident_Nmbr__c, CM_PI_Prov__c, CM_PI_Prov__r.Prov_ID__c From CM_Provider_Identification__c where CM_PI_Prov__c IN : setOfAccount AND (CM_Prvdr_Iden_Typ_Cd__c =: 'License' OR  CM_Prvdr_Iden_Typ_Cd__c =: 'NPI') AND (CM_Issu_Ident_Nmbr__c != '' OR CM_Issu_Ident_Nmbr__c != NULL)])
                {

                    setOfProviderWithoutNPI.add(actNPI.CM_PI_Prov__r.Prov_ID__c);
                    
                }
            }
           system.debug('setOfProviderWithoutNPI'+setOfProviderWithoutNPI);
            for(Provider_Networks__c  providerDetails : newTrigger)
            {    
               if(ProviderDetails.Prov_Id__c != NULL && mapofContractCaseAndAccount.ContainsKey(providerDetails.Prov_Id__c) && ProviderDetails.Contracting_Case__c != NULL  && ProviderDetails.isFromIndividual__c == False && ProviderDetails.Cred_Status__c == 'Needs Credentialing' && ((oldMap == NULL || oldMap.isEmpty()) || (oldMap != NULL && oldMap.get(providerDetails.Id).Cred_Status__c != ProviderDetails.Cred_Status__c)))
               {                
                   system.debug('ProviderDetails.Cred_Status__c '+ProviderDetails.Cred_Status__c ); 
                   providerDetails.adderror('Duplicate credentialing case in existence for the entered Prov ID'  );
                                     
                }
                if(ProviderDetails.Prov_Id__c != NULL  && ProviderDetails.Contracting_Case__c != NULL && ProviderDetails.Cred_Status__c == 'Needs Credentialing' && ((oldMap == NULL || oldMap.isEmpty()) || (oldMap != NULL && oldMap.get(providerDetails.Id).Cred_Status__c != ProviderDetails.Cred_Status__c)) )
                {
                    if(mapofAccountAndDOB.containsKey(ProviderDetails.Prov_Id__c)  &&( mapofAccountAndDOB.get(ProviderDetails.Prov_Id__c)== null || mapofAccountAndDOB.get(ProviderDetails.Prov_Id__c)== '')) 
                    {
                         providerDetails.adderror('DOB missing for Account. Please update the DOB for provider to create the credentialing case'  );
                    }
                }
                if(setOfProviderWithoutNPI.isEmpty() )
                {
                    if(ProviderDetails.Prov_Id__c != NULL  && ProviderDetails.Contracting_Case__c != NULL && ProviderDetails.Cred_Status__c == 'Needs Credentialing' && ((oldMap == NULL || oldMap.isEmpty()) || (oldMap != NULL && oldMap.get(providerDetails.Id).Cred_Status__c != ProviderDetails.Cred_Status__c))  )
                    {
                         providerDetails.adderror('NPI/License # missing for account. Please update at least one of the following NPI/License # for provider to create the credentialing case');
                    }
                }
                
                system.debug('###### setOfProviderWithoutNPI ######' + setOfProviderWithoutNPI);
                system.debug('###### setOfProvId ######' + setOfProvId);
                
                if(!setOfProviderWithoutNPI.isEmpty() )
                {
                    if(ProviderDetails.Prov_Id__c != NULL  && ProviderDetails.Contracting_Case__c != NULL && ProviderDetails.Cred_Status__c == 'Needs Credentialing' && ((oldMap == NULL || oldMap.isEmpty()) || (oldMap != NULL && oldMap.get(providerDetails.Id).Cred_Status__c != ProviderDetails.Cred_Status__c))  )
                    {
                        if(setOfProviderWithoutNPI.size()  != setOfProvId.size() )
                        {
                           providerDetails.adderror('NPI/License # missing for account. Please update at least one of the following NPI/License # for provider to create the credentialing case');   
                        }
                       
                    }
                }
            }
           
            
    }
    
    /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Saravana             03/19/2019            Linking Account Name Based on ProvID In case creation Starts.
*/ 
  Public Void LinkAccBasedOnProvID(List<Provider_Networks__c> newprovdetList, Map<Id, Provider_Networks__c> oldMap)
    {
        Id physicianId,entityId;
            system.debug('Coming inside before update');
            physicianId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();
            entityId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Entity_Account').getRecordTypeId();
            List<Account> listOfPhysicianAccount = new List<Account>();
            List<String> listOfProviderIds = new List<String>();
            Map<String,Case> mapOfKeyAndItsCase = new Map<String,Case>();
            Set<Id> setOfEntityAccount = new Set<Id>();
        
        List<case> listOfCaseToUpdate = new List<Case>();
        List<Id> listOfCaseIds = new List<Id>();
        for(Provider_Networks__c newNetwork : newprovdetList)
        {
            if(newNetwork.Prov_Id__c !=NULL && newNetwork.PFIN_Case__c !=NULL )
            {
                listOfCaseIds.add(newNetwork.PFIN_Case__c);
            }
        }
        Set<Id> setOfCase = new Set<Id>();
        Map<Id,Id> mapOfchildandParentCase = new Map<Id,Id>();
        if(!listOfCaseIds.isEmpty())
        {
            for(Case newCase:[Select Id,ParentId from Case Where Completing_the_form_for__c='Individual' And Id In:listOfCaseIds And (Recordtype.Name='Provider On-boarding Data Entry')])
            {
                SetOfCase.add(newCase.Id);
                setOfCase.add(newCase.ParentId);            
                mapOfchildandParentCase.put(newCase.Id,newCase.ParentId);
            }
        }
        Map<String,List<Id>> mapOfProvIdAndItsCase = new Map<String,List<Id>>();
        for(Provider_Networks__c newNetwork : newprovdetList)
        {
            List<Id> listOfCaseId = new List<Id>();
            if(newNetwork.Prov_Id__c !=NULL && newNetwork.PFIN_Case__c !=NULL && (setOfCase.contains(newNetwork.PFIN_Case__c))) 
            {
                if(mapOfProvIdandItsCase.containsKey(newNetwork.Prov_Id__c))
                {
                    listOfCaseId = mapOfProvIdAndItsCase.get(newNetwork.Prov_Id__c);
                }
                listOfCaseId.add(newNetwork.PFIN_case__c);
                listOfCaseId.add(mapOfchildandParentCase.get(newNetwork.PFIN_Case__c));
                mapOfProvIdAndItsCase.put(newNetwork.Prov_Id__c,listOfCaseId);
            }
        }
        Map<String,Id> mapOfProvIdAndItsId = new Map<String,Id>();
        if(!mapOfProvIdAndItsCase.isEmpty()){
            for(Account newAccount:[Select Id,RecordTypeId,Prov_Id__c From Account where Prov_Id__c In:mapOfProvIdAndItsCase.keyset()])
            {
                if(newAccount.RecordTypeId == entityId && newAccount.Prov_ID__c !=NULL)
                {
                    setOfEntityAccount.add(newAccount.Id);                              
                }
                mapOfProvIdAndItsId.put(newAccount.Prov_Id__c,newAccount.Id);
            }
        }
        Set<Case> caseSet = new Set<Case>();
        for(Provider_Networks__c newNetwork : newprovdetList)
        {
            if(mapOfProvIdAndItsCase.containsKey(newNetwork.Prov_Id__c) && mapOfProvIdAndItsId.containsKey(newNetwork.Prov_Id__c))
            {
                for(Id newCaseId:mapOfProvIdAndItsCase.get(newNetwork.Prov_Id__c))
                {
                    Case newCase = new Case(Id=newCaseId);
                    if(setOfEntityAccount.contains(mapOfProvIdAndItsId.get(newNetwork.Prov_Id__c)))
                    {
                        newCase.Case_Entity__c=mapOfProvIdAndItsId.get(newNetwork.Prov_Id__c);
                    }                    
                    else
                    {
                        newCase.AccountId = mapOfProvIdAndItsId.get(newNetwork.Prov_Id__c);
                    }
                    caseSet.add(newCase);
                }
            }
        }
        listOfCasetoUpdate.addall(caseSet);
        update listOfCasetoUpdate;
    }
    /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Subhashini                10/19/2018            Adding Provider Name in the provider details section
*/ 
  Public void AddProviderName(List<Provider_Networks__c> newprovdetList, Map<Id, Provider_Networks__c> oldMap)
    {
        List<Provider_Networks__c> listProviderNetwork = new List<Provider_Networks__c>();//PPN-26580
        List<String> listOfProviderName = new List<String>();//PPN-26580
        for(Provider_Networks__c provNetList : newprovdetList){
                if(provNetList .Prov_Id__c != NULL)
                listOfProviderName.add(provNetList .Prov_Id__c);
        }
        Map<String,String> mapOfProvIdAndItsAccountId = new Map<String,String>();
        if(!listOfProviderName.isEmpty()){
            for(Account newAccount:[SELECT Id,Prov_Id__c,Name FROM Account where Prov_ID__c IN: listOfProviderName])
            {
                mapOfProvIdAndItsAccountId.put(newAccount.Prov_Id__c,newAccount.Name);
            }
        }
        system.debug('mapOfProvIdAndItsAccountId'+mapOfProvIdAndItsAccountId);
            
            for (Provider_Networks__c provNet : newprovdetList) 
            {
                system.debug('provNet.Id'+provNet.Id);
                if(mapOfProvIdAndItsAccountId.containsKey(provNet.Prov_Id__c))
                {
                    provNet.ProviderName__c =mapOfProvIdAndItsAccountId.get(provNet.Prov_Id__c);
                }
                listProviderNetwork.add(provNet);
            }
            system.debug('listProviderNetwork'+listProviderNetwork);
    }
  /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Sujatha               10/19/2018            Validate deleting the counter sign record.
*/ 
  Public void ProviderIsBeforeIsDelete(List<Provider_Networks__c> newprovdetList)
    {

        Id counterSignRtypeId;
        counterSignRtypeId =  Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('CounterSign').getRecordTypeId();
        
        system.debug('counterSignRtypeId '+counterSignRtypeId);
        for(Provider_Networks__c pList : newprovdetList   ){
            system.debug('pList.RecordTypeId'+pList.RecordTypeId);
            if(pList.RecordTypeId == counterSignRtypeId){
                pList.adderror('We Cannot delete Provider Details Under Counter Sign Case');
            }
        }
    }
   /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Sethu              
*/ 
  Public void ProviderIsBeforeIsUpdate(Map<Id, Provider_Networks__c> newMap, Map<Id, Provider_Networks__c>  oldMap)
    {
         for(Provider_Networks__c newNetwork:oldMap.Values())
            {
                if(newNetwork.Prov_Id__c != NewMap.get(newNetwork.Id).Prov_Id__c)
                {
                    NewMap.get(newNetwork.Id).ProviderName__c ='';                    
                }
            }
    }   
     /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Sethu              
*/ 
  Public void ProviderIsAfterIsInsert(List<Provider_Networks__c> newprovdetList, List<Provider_Networks__c> oldList)
    {
        Set<Id> parentCaseIdSet = new Set<Id>();
        List<Provider_Networks__c> providerNetworkList = new List<Provider_Networks__c>();
        string isFirstRecord;
        
        for(Provider_Networks__c provNet : trigger.isInsert ? newprovdetList : oldList){
            if(provNet.PFIN_Case__c != NULL)
                parentCaseIdSet.add(provNet.PFIN_Case__c);
            else if(provNet.Contracting_Case__c != NULL)
                parentCaseIdSet.add(provNet.Contracting_Case__c);
            else if(provNet.Credentialing_Case__c != NULL)
                parentCaseIdSet.add(provNet.Credentialing_Case__c);
            else if(provNet.CounterSign__c != NULL)
                parentCaseIdSet.add(provNet.CounterSign__c);
            else if(provNet.Case_Number__c != NULL)
                parentCaseIdSet.add(provNet.Case_Number__c);
        }
        
        system.debug('******* parentCaseIdSet *****' + parentCaseIdSet);
        
        for(Provider_Networks__c prov : [SELECT Id, Prov_Id__c, isFirstProvider__c FROM Provider_Networks__c WHERE (PFIN_Case__c IN: parentCaseIdSet OR Contracting_Case__c IN: parentCaseIdSet
                                         OR Credentialing_Case__c IN: parentCaseIdSet OR CounterSign__c IN: parentCaseIdSet OR Case_Number__c IN: parentCaseIdSet) ORDER BY CreatedDate ASC]){
        
            system.debug('***** Inside Query ***' + isFirstRecord);
            Provider_Networks__c provNet = new Provider_Networks__c(Id = prov.Id);
            if(isFirstRecord == NULL || isFirstRecord == ''){
                provNet.isFirstProvider__c = true;
                isFirstRecord = prov.Id;
            }else{ 
                provNet.isFirstProvider__c = false;
            }
            providerNetworkList.add(provNet);
        }
        
        system.debug('***** providerNetworkList ***' + providerNetworkList);
        
        if(!providerNetworkList.isEmpty()){
            ContractingProviderDetailExt.isRunProviderTrigger = false;
           // if(ValidateCredStatus ==false){ 
                Update providerNetworkList;
           // }
        }
    }
    
    
     /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Sethu              
*/ 
  Public void ProviderIsAfterIsUpdate(Map<Id, Provider_Networks__c> newMap, Map<Id, Provider_Networks__c>  oldMap)
    {
         List<String> listOfProviderId = new List<String>();
        List<Provider_Networks__c> providerListToUpdate = new List<Provider_Networks__c>();
        for(Provider_Networks__c provNetwork : newMap.Values()){
            if(!provNetwork.isFromIndividual__c &&
                (provNetwork.Prov_ID__c != oldMap.get(provNetwork.Id).Prov_ID__c) ||
                (provNetwork.PFIN_onBoarding__c != oldMap.get(provNetwork.Id).Prov_ID__c) ||  
                (provNetwork.Cred_Status__c != oldMap.get(provNetwork.Id).Cred_Status__c) ||
                (provNetwork.Panel_code__c != oldMap.get(provNetwork.Id).Panel_code__c ) ||
                (provNetwork.Network_Code_Name_Detail__c != oldMap.get(provNetwork.Id).Network_Code_Name_Detail__c) ||
                (provNetwork.Designation_Code__c != oldMap.get(provNetwork.Id).Designation_Code__c) ||
                (provNetwork.Comp_Grid_Code__c != oldMap.get(provNetwork.Id).Comp_Grid_Code__c) ||
                (provNetwork.Roles_Code__c != oldMap.get(provNetwork.Id).Roles_Code__c) ||
                (provNetwork.Networks_Effective_Date__c != oldMap.get(provNetwork.Id).Networks_Effective_Date__c))
            {
                listOfProviderId.add(String.valueOf(provNetwork.Id).substring(0,15));
            }
        }
        
        system.debug('##### After Update providerId  ####' + listOfProviderId);
        system.debug('###### trigger.newMap ####' + trigger.newMap);
        
        if(listOfProviderId != NULL && !listOfProviderId.isEmpty()){
            for(Provider_Networks__c provNetwork : [SELECT Id, Name,PFIN_onBoarding__c,Prov_ID__c,Prior_Provider_Id__c,Panel_code__c,Networks_Effective_Date__c,Designation_End_Date__c,Cred_Status__c, Roles_Code__c, Comp_Grid_Code__c, Network_Code_Name_Detail__c, Designation_Code__c,Comp_Grid_Effective_Date__c, Network_Code_Name__c FROM Provider_Networks__c WHERE Prior_Provider_Id__c IN: listOfProviderId]){
                string provId = (provNetwork.Prior_Provider_Id__c).substring(0,15);
                if(trigger.newMap.containsKey(provId)){
                    Provider_Networks__c prov = new Provider_Networks__c(Id = provNetwork.Id);
                    prov.PFIN_onBoarding__c = Newmap.get(provId).PFIN_onBoarding__c;
                    prov.Prov_ID__c = NewMap.get(provId).Prov_ID__c;
                    prov.Cred_Status__c = NewMap.get(provId).cred_Status__c;
                    prov.Comp_Grid_Code__c = NewMap.get(provId).Comp_Grid_Code__c;
                    prov.Comp_Grid_Effective_Date__c = NewMap.get(provId).Comp_Grid_Effective_Date__c;
                    prov.Designation_Code__c = NewMap.get(provId).Designation_Code__c;
                    prov.Designation_End_Date__c = NewMap.get(provId).Designation_End_Date__c;
                    prov.Network_Code_Name_Detail__c = NewMap.get(provId).Network_Code_Name_Detail__c;
                    prov.Network_Code_Name__c = NewMap.get(provId).Network_Code_Name__c;
                    prov.Networks_Effective_Date__c = NewMap.get(provId).Networks_Effective_Date__c;
                    prov.Roles_Code__c = NewMap.get(provId).Roles_Code__c;
                    prov.Panel_code__c = NewMap.get(provId).Panel_code__c;
                    providerListToUpdate.add(prov);
                }
            }
            
            system.debug('##### After Update providerListToUpdate  ####' + providerListToUpdate);
            if(!providerListToUpdate.isEmpty()){
                Update providerListToUpdate;
            } 
            
        }
    }

}