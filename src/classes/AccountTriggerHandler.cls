/****************************************************************
@Author      : Provider Intake Salesforce team 
@Date        : 28/06/2018
@Description : Handler class for Account Trigger
*******************************************************
SI.No       Author                Modification Comments
1          Saravana Bharathi      Userstory PPN-13033 Changes
2          Saravana Bharathi      User STory PPN-17584 Changes
3          Saravana Bharathi      Bug PPN-21894ory 
4          Ashok N               Used to capture the history(Refer the CommentHistoryTracking())
5          Laxman Vattam          PPN-30575 - Update Network Load case Account based on Prov id
6          Ashok N                PPN-30357 
7         Ashok N                 PPN-34061 
******************************************************************/
public class AccountTriggerHandler implements ITrigger 
{  
    public AccountTriggerHandler () 
    {        
        intializeData();             
    }
    
    public void intializeData()
    {}
    public void bulkBefore() {
        ValidatePhoneFormat( );//PPN-10605
    }
    public void bulkAfter() 
    {
        insertAffiliation();   
        //R4_Changes_PPN-17584
        linkCase(); 
    }
  
  
 /*
* Author : U393129
* Date  :01/18/2019
* Ver :1.0
* Business purpouse : Used to track the history of the fields on Account and insert in Credentialing_Comments_History__c object
* 
*/

    
   /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Laxman Vattam             01/29/2019             PPN-30575 - When New account is created, check for any network load cases to update the account
*/ 
    public void updateAccountonNetworkLoadCases(Map<Id,Account> newMapAccountValues,list<account> newListAccount )
    {
        list<Account> listOfAccount = (list<account>)newListAccount;
        map<Id,Account> mapOfAccount = (Map<Id,Account>)newMapAccountValues;
        map<string, Id> mapOfProvAccId = new map<string, Id>();
        set<Id> allAccs = mapOfAccount.keySet();
        list<Case> grpCases = new list<Case>();
        list<Case> indCases = new list<Case>();
        set<string> provIds = new set<string>();
        list<account> newAccountswithProvId = new list<account>();
        for(Account acc:listOfAccount){
            if(acc.Prov_ID__c != null && acc.Prov_ID__c != '' && acc.recordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rolodex').getRecordTypeId()){
                provIds.add(acc.Prov_ID__c);
                mapOfProvAccId.put(acc.Prov_ID__c,acc.Id);
                newAccountswithProvId.add(acc);
            }
        }
        if(provIds.size() > 0){
            for(Case caseIte: [select id,accountid,Prov_ID__c from case where recordtype.developername = 'Provider_Group_On_boarding_Network_Load' and status != 'Closed Processed' and Prov_ID__c in :provIds]){
                system.debug('caseIte:' + caseIte);
               
                if(mapOfProvAccId.get(caseIte.Prov_ID__c) != null){
                    caseIte.AccountId = mapOfProvAccId.get(caseIte.Prov_ID__c);
                    grpCases.add(caseIte);   
                }
            }
            if(grpCases.size() > 0)
                update grpCases;
            
            list<Provider_Networks__c> pns = new list<Provider_Networks__c>();
            pns = [select id,Case_Number__c from Provider_Networks__c where Prov_id__c in :provIds];
            list<Id> caseIdList = new list<Id>();
            map<string,Id> casePFINMap = new map<string,Id>();
            for(Provider_Networks__c plist:[select id,Case_Number__r.id,Prov_ID__c from Provider_Networks__c where Prov_id__c in :provIds 
                                            and Case_Number__r.status != 'Closed Processed' ]){
                caseIdList.add(plist.Case_Number__r.id);
                if(plist.Prov_id__c != null && plist.Case_Number__r.id != null)
                     casePFINMap.put(plist.Prov_id__c,plist.Case_Number__r.id);
            }
            map<id,case> caseMap = new map<id,Case>();
            list<case> caseList = new list<case>();
            for(Case caseIter: [select id,accountid from case where id in :caseIdList]){
                caseMap.put(caseIter.id,caseIter);
                caseList.add(caseIter);
            }
            list<case> updateCase = new list<case>();
            for(account acco:newAccountswithProvId){
                if(caseMap.get(casePFINMap.get(acco.prov_id__c)) != null){
                    case c = caseMap.get(casePFINMap.get(acco.prov_id__c));
                    c.accountid = acco.Id;
                    updateCase.add(c);
                }
            }
            if(updateCase.size() > 0){
                update updateCase; 
            }
        }
    }
    
    /*PPN-10605 STARTS*/
    
    public void ValidatePhoneFormat()
    {
        SYSTEM.DEBUG('ValidatePhoneFormat');
        List<RecordType> listRecordType = [Select Id,Name From RecordType Where sObjectType='Account' and Name='Rolodex'];
        for(Account acc : (List<Account>)Trigger.new){
            if(!listRecordType .isEmpty() && acc.RecordTypeId == listRecordType [0].Id){
                string phone = acc.Phone!= NULL ? acc.Phone.replaceAll( '[^0-9]' , '' ) : NULL;
                string mobilePhone = acc.PersonMobilePhone!= NULL ? acc.PersonMobilePhone.replaceAll( '[^0-9]' , '' ): NULL ;
                string fax = acc.Fax != NULL ? acc.Fax.replaceAll( '[^0-9]' , '' ) : NULL;
                
                if(phone != NULL && (!Phone.isNumeric() || phone.length() != 10)){
                    acc.Phone.addError('Invalid Phone number or format');
                }
                if(mobilePhone != NULL && (!mobilePhone.isNumeric() || mobilePhone.length() != 10)){
                    acc.PersonMobilePhone.addError('Invalid Mobile number or format');
                }
                if(fax != NULL && (!fax.isNumeric() || fax.length() != 10)){
                    acc.Fax.addError('Invalid Fax number or format');
                }
            }
        }
    }
    /*PPN-10605 ENDS*/
    
    public void insertAffiliation()
    {
        // List<RecordType> listOfType = [Select Id,Name From RecordType Where sObjectType='Account' and Name='Rolodex'];
        Id rolodexRecTypeId         =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rolodex').getRecordTypeId();
        
        List<Account> listOfRolodexAccount  =   new List<Account>();
        List<String> listOfRTaxIds          =   new List<String>();
        List<String> listOfRNpiNumbers      =   new List<String>();
        Set<String>  planIdSet              =   new Set<String>();
        
        for(Account newAccount:(List<Account>)Trigger.new)
        {
            if( rolodexRecTypeId != null && 
               newAccount.RecordTypeId == rolodexRecTypeId && 
               newAccount.NPI__c !=NULL && 
               newAccount.Tax_Id__c !=NULL
              )
            {
                listOfRolodexAccount.add(newAccount);    
                listOfRTaxIds.add(newAccount.Tax_Id__c);
                listOfRNpiNumbers.add(newAccount.NPI__c);
                planIdSet.add( newAccount.CM_Corporate_Entity_Code__c );
            }           
        }
        System.debug('List '+listOfRTaxIds+'-'+listOfRNpiNumbers+'-'+listOfRolodexAccount);
        Map<Id,List<String>>mapOfAccountIdAndItsTaxId   =   new Map<Id,List<String>>();
        Map<Id,String> mapOfAccountAndItsCode           =   new Map<Id,String>();
        
        if( !listOfRTaxIds.isEmpty() &&  !planIdSet.isEmpty() )
        {
            for(CM_Provider_Tax_Id__c newTaxId:[Select CM_PTI_Prov_Name_From__c,CM_PTI_Prov_Name_From__r.CM_Corporate_Entity_Code__c,CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Tax_Id__c In:listOfRTaxIds and CM_Corporate_Entity_Code__c IN: planIdSet ])
            {
                List<String> listOfTaxIds = new List<String>();
                mapOfAccountAndItsCode.put(newTaxId.CM_PTI_Prov_Name_From__c,newTaxId.CM_PTI_Prov_Name_From__r.CM_Corporate_Entity_Code__c);
                if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL && mapOfAccountIdAndItsTaxId.containsKey(newTaxId.CM_PTI_Prov_Name_From__c))
                {
                    listOfTaxIds = mapOfAccountIdAndItsTaxId.get(newTaxId.CM_PTI_Prov_Name_From__c);
                }
                if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL)
                {
                    listOfTaxIds.add(newTaxId.CM_PTI_Tax_Id__c);
                    mapOfAccountIdAndItsTaxId.put(newTaxId.CM_PTI_Prov_Name_From__c,listOfTaxIds);
                }
            }  
        }
        
        
        System.debug('Map '+mapOfAccountIdAndItsTaxId);
        Map<Id,List<String>>mapOfAccountIdAndItsNPI = new Map<Id,List<String>>();
        for(CM_Provider_Identification__c newIdentification:[Select CM_Issu_Ident_Nmbr__c,CM_PI_Prov__c,CM_Prvdr_Iden_Typ_Cd__c From CM_Provider_Identification__c Where CM_Issu_Ident_Nmbr__c In:listOfRNpiNumbers and CM_Prvdr_Iden_Typ_Cd__c ='NPI'])
        {
            List<String> listOfNPIIds = new List<String>();
            if(newIdentification.CM_Issu_Ident_Nmbr__c !=NULL && mapOfAccountIdAndItsNPI.containsKey(newIdentification.CM_PI_Prov__c))
            {
                listOfNPIIds = mapOfAccountIdAndItsNPI.get(newIdentification.CM_PI_Prov__c);
            }
            if(newIdentification.CM_Issu_Ident_Nmbr__c !=NULL)
            {
                listOfNPIIds.add(newIdentification.CM_Issu_Ident_Nmbr__c);
                mapOfAccountIdAndItsNPI.put(newIdentification.CM_PI_Prov__c,listOfNPIIds);
            }    
        }
        System.debug('Map '+mapOfAccountIdAndItsNPI);
        Map<String,Id> mapOfKeyAndItsId = new Map<String,Id>();
        for(Id newId:mapOfAccountIdAndItsNPI.keyset())
        {
            for(String npiNo:mapOfAccountIdAndItsNPI.get(newId))
            {
                if(mapOfAccountIdAndItsTaxId.containsKey(newId))
                {
                    for(String taxNo:mapOfAccountIdAndItsTaxId.get(newId))
                    {
                        if(npiNo !=NULL && npiNo !='' && taxNo !=NULL && taxNo !='')
                        {
                            mapOfKeyAndItsId.put(npiNo+'@'+taxNo,newId);
                        }
                    }
                }
            }
        } 
        System.debug('Map '+mapOfKeyAndItsId);       
        List<Affiliations__c> listOfAffiliationToCreate = new List<Affiliations__c>();
        
        List<RecordType> listOfAffiliationType = [Select Id From RecordType Where sObjectType='Affiliations__c' and Name='Affiliation'];       
        for(Account newAccount:listOfrolodexAccount)
        {
            if(newAccount.NPI__c !=NULL && newAccount.Tax_Id__c !=NULL && mapOfKeyAndItsId.containsKey(newAccount.NPI__c+'@'+newAccount.Tax_Id__c))
            {
                Affiliations__c newAffiliation = new Affiliations__c();
                if(!listOfAffiliationType.isEmpty())
                {
                    newAffiliation.recordTypeId = listOfAffiliationType[0].Id;
                }
                if(mapOfAccountAndItsCode !=NULL && mapOfAccountAndItsCode.containsKey(mapOfKeyAndItsId.get(newAccount.NPI__c+'@'+newAccount.Tax_Id__c)))
                {
                    newAffiliation.CM_Corporate_Entity_Code__c = mapOfAccountAndItsCode.get(mapOfKeyAndItsId.get(newAccount.NPI__c+'@'+newAccount.Tax_Id__c));
                }
                newAffiliation.Account__c=mapOfKeyAndItsId.get(newAccount.NPI__c+'@'+newAccount.Tax_Id__c);
                newAffiliation.CM_Affiliated_Provider_Name__c=newAccount.Id;
                listOfAffiliationToCreate.add(newAffiliation);
            }
        }
        System.debug('List'+listOfAffiliationToCreate);
        insert listOfAffiliationToCreate;        
    }
    //R4_Changes_PPN-17584
    /*        public void linkCase(){        
Id physicianId,entityId;
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
List<Account> listOfPhysicianAccount = new List<Account>();
List<String> listOfTaxIds = new List<String>();
List<String> listOfNpiNumbers = new List<String>();
Map<String,Account> mapOfKeyAndItsAccount = new Map<String,Account>();
Set<Id> setOfEntityAccount = new Set<Id>();
for(Account newAccount:(List<Account>)Trigger.new)
{
if(newAccount.RecordTypeId == physicianId && newAccount.NPI__c !=NULL && newAccount.Tax_Id__c !=NULL)
{
listOfPhysicianAccount.add(newAccount);    
listOfTaxIds.add(newAccount.Tax_Id__c);
listOfNpiNumbers.add(newAccount.NPI__c);
String Key='';
if(newAccount.NPI__c !=NULL)
{
key = newAccount.NPI__c+'&';
}
if(newAccount.Tax_Id__c !=NULL)
{
key=key+newAccount.Tax_Id__c+'&';
}
mapOfKeyAndItsAccount.put(key,newAccount);                                              
}
else if(newAccount.RecordTypeId == entityId && newAccount.NPI__c !=NULL && newAccount.Tax_Id__c !=NULL)
{
setOfEntityAccount.add(newAccount.Id);
listOfTaxIds.add(newAccount.Tax_Id__c);
listOfNpiNumbers.add(newAccount.NPI__c);
String Key='';
if(newAccount.NPI__c !=NULL)
{
key = newAccount.NPI__c+'&';
}
if(newAccount.Tax_Id__c !=NULL)
{
key=key+newAccount.Tax_Id__c+'&';
}  
mapOfKeyAndItsAccount.put(key,newAccount);                              
}
}
Map<String,List<Case>> mapOfKeyAndItsCases = new Map<String,List<Case>>();
for(Case newCase:[Select Id,AccountId,Billing_NPI_Number__c,Tax_ID_Number__c From Case Where Billing_NPI_Number__c In:listOfNpiNumbers and Tax_ID_Number__c In:listOfTaxIds and (Recordtype.Name='Provider On-boarding Data Entry' or Recordtype.Name='Provider On-boarding')])
{
String key = '';
if(newCase.Billing_NPI_Number__c !=NULL)
{
key = newCase.Billing_NPI_Number__c+'&';
}
if(newCase.Tax_Id_Number__c !=NULL)
{
key=key+newCase.Tax_Id_Number__c+'&';
}
List<Case> listOfCases = new List<Case>();
if(mapOfKeyAndItsCases.containsKey(key))
{
listOfCases = mapOfKeyAndItsCases.get(key);
}
listOfCases.add(newCase);
mapOfKeyAndItsCases.put(key,listOfCases);
}
List<Case> listOfCasetoUpdate = new List<Case>();
for(String key:mapOfKeyAndItsCases.keySet())
{
for(Case newCase:mapOfKeyAndItsCases.get(key))
{
if(mapOfKeyAndItsAccount.containsKey(key))
{
Account newAccount = mapOfKeyAndItsAccount.get(key);

if(!setOfEntityAccount.contains(newAccount.Id))
{
newCase.AccountId = newAccount.Id;
}
else
{
newCase.Case_Entity__c= newAccount.Id;  
}
listOfCasetoUpdate.add(newCase);                 
}
}
}
update listOfCasetoUpdate;
}

*/ 
    
     public void linkCase(){        
        Id physicianId,entityId;
       /* for(RecordType newType:[Select Id,Name From RecordType Where sObjectType='Account' and (Name='Physician' OR Name='Entity Account')])
        {
            if(newType.Name=='Physician')
            {
                physicianId=newType.Id;
            }
            else
            {
                entityId=newType.Id;
            }
        }*/
        physicianId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();
        entityId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Entity_Account').getRecordTypeId();
        List<Account> listOfPhysicianAccount = new List<Account>();
        //List<String> listOfProviderIds = new List<String>();
        Map<String,Account> mapOfKeyAndItsAccount = new Map<String,Account>();
        Set<Id> setOfEntityAccount = new Set<Id>();
        for(Account newAccount:(List<Account>)Trigger.new)
        {
            if(newAccount.RecordTypeId == physicianId && newAccount.Prov_ID__c !=NULL)
            {
                listOfPhysicianAccount.add(newAccount);
                //listOfProviderIds.add(newAccount.Prov_Id__c);
                mapOfKeyAndItsAccount.put(newAccount.Prov_ID__c,newAccount);                                                  
            }
            else if(newAccount.RecordTypeId == entityId && newAccount.Prov_ID__c !=NULL)
            {
                setOfEntityAccount.add(newAccount.Id); 
                //listOfProviderIds.add(newAccount.Prov_Id__c);
                mapOfKeyAndItsAccount.put(newAccount.Prov_ID__c,newAccount);                             
            }
           
        }
        
        Map<Id,case> listOfCaseToUpdate = new Map<Id,Case>();
        Set<Case> setOfCases = new Set<Case>();
        Map<Id, Provider_Networks__c> ProviderMaptoUpdate = new Map<Id, Provider_Networks__c>();
        if(mapOfKeyAndItsAccount != NULL && !mapOfKeyAndItsAccount.isEmpty()){
            for(Provider_Networks__c newNetwork:[Select Prov_ID__c,PFIN_Case__c,PFIN_Case__r.parentId, Contracting_Case__c, Contracting_Case__r.parentId, isFromIndividual__c From Provider_Networks__c Where Prov_ID__c In: mapOfKeyAndItsAccount.keySet() And (PFIN_Case__c !=NULL or Contracting_Case__c != NULL)  AND Prov_ID__c != NULL ])
            {
                system.debug('**** Inside For loop of Provider ***' + newNetwork.Prov_ID__c);
                Case newCase = new Case();
                Case parentCase  = new Case();
                Provider_Networks__c provNet = new Provider_Networks__c(Id = newNetwork.Id);
    
                if(mapOfKeyAnditsAccount.containsKey(newNetwork.prov_Id__c) && 
                   setOfEntityAccount.contains(mapOfKeyAnditsAccount.get(newNetwork.prov_Id__c).Id))
                {
                    system.debug('**** Inside If - For loop of Provider ***' + newNetwork.Prov_ID__c);
                    if(newNetwork.PFIN_Case__c !=NULL || newNetwork.PFIN_Case__c != '')
                    {
                        newCase = new Case(id=newNetwork.PFIN_Case__c);
                        newCase.Case_Entity__c = mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id;
                        listOfCasetoUpdate.put(newCase.Id,newCase); // Added for -> PPN-37089
                        setOfCases.add(newCase);
                        
                        parentCase = new Case(id=newNetwork.PFIN_Case__r.parentId);
                        System.debug('parentCase .parentId'+parentCase.parentId);                
                        parentCase.Case_Entity__c = mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id;
                        listOfCasetoUpdate.put(parentCase.Id,parentCase);
                        setOfCases.add(parentCase);
                    }
                    system.debug('newNetwork.Contracting_Case__c'+newNetwork.Contracting_Case__c);
                    if(newNetwork.Contracting_Case__c != NULL || newNetwork.Contracting_Case__c != '')
                    {
                        System.debug('newCase'+newCase);
                        System.debug('newCase.parentId'+newCase.parentId); 
                        newCase = new Case(id=newNetwork.Contracting_Case__c);
                        newCase.Case_Entity__c = mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id;
                        listOfCasetoUpdate.put(newCase.Id,newCase); // Added for -> PPN-37089
                        setOfCases.add(newCase);
                        
                        parentCase = new Case(id=newNetwork.Contracting_Case__r.parentId);
                        System.debug('parentCase .parentId'+parentCase.parentId);                
                        parentCase.Case_Entity__c = mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id;
                        listOfCasetoUpdate.put(parentCase.Id,parentCase);
                        setOfCases.add(parentCase);
                        provNet.ProviderName__c = mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Name;
                        ProviderMaptoUpdate.put(newNetwork.Id, provNet);
    
                    }
                    
                    
                }
                else if(mapOfKeyAnditsAccount.containsKey(newNetwork.prov_Id__c))
                {
                    system.debug('**** Inside ElseIF - For loop of Provider ***' + newNetwork.Prov_ID__c);
                    System.debug('newCase'+newCase);
                    System.debug('newCase.parentId'+newCase.parentId); 
                    if(newNetwork.PFIN_Case__c !=NULL || newNetwork.PFIN_Case__c != '')
                    {
                        if(newNetwork.isFromIndividual__c){
                            newCase = new Case(id=newNetwork.PFIN_Case__c);                                                     
                            newCase.AccountId= mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id;                
                            listOfCasetoUpdate.put(newCase.Id,newCase); // Added for -> PPN-37089
                            setOfCases.add(newCase);
                            
                            parentCase = new Case(id=newNetwork.PFIN_Case__r.parentId);
                            System.debug('parentCase .parentId'+parentCase.parentId);
                            parentCase.AccountId= mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id; 
                            listOfCasetoUpdate.put(parentCase.Id,parentCase);
                            setOfCases.add(parentCase);
                        }
                    }
                    if(newNetwork.Contracting_Case__c != NULL || newNetwork.Contracting_Case__c != '')
                    {             
                        if(newNetwork.isFromIndividual__c){
                            newCase = new Case(id=newNetwork.Contracting_Case__c );                                                     
                            newCase.AccountId= mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id;                
                            listOfCasetoUpdate.put(newCase.Id,newCase); // Added for -> PPN-37089
                            setOfCases.add(newCase);
                            
                            parentCase = new Case(id=newNetwork.Contracting_Case__r.parentId);
                            System.debug('parentCase .parentId'+parentCase.parentId);
                            parentCase.AccountId= mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Id; 
                            listOfCasetoUpdate.put(parentCase.Id,parentCase);
                            setOfCases.add(parentCase);
                        }
                        
                        provNet.ProviderName__c = mapOfKeyAndItsAccount.get(newNetwork.prov_Id__c).Name;
                        ProviderMaptoUpdate.put(newNetwork.Id, provNet);
    
                    }
                    
                }
            }
        }
        //listOfCasetoUpdate.addall(setOfCases);
        system.debug('**** listOfCasetoUpdate ***' + listOfCasetoUpdate);
        if(listOfCasetoUpdate.size()>0)
         {
             try{
                 database.update(listOfCasetoUpdate.values(), false);
        
             }catch(DmlException e)
             {
                 system.debug('**** Exception Occured ***' + e.getmessage());
             }
         }
         
          if(!ProviderMaptoUpdate.isEmpty()){
             try{
                 database.update(ProviderMaptoUpdate.values(), false);
             }
             catch(DmlException e)
             {
                 system.debug('**** Exception Occured ***' + e.getmessage());
             }
         }

        
        
    }
    
    public void beforeInsert(SObject so) {}
    public void beforeUpdate(SObject oldSo, SObject so) {}
    public void beforeDelete(SObject so) {}
    public void afterInsert(SObject so) {}
    public void afterUpdate(SObject oldSo, SObject so) {}
    public void afterDelete(SObject so) {}
    public void andFinally() {}
    
       /*
* Author : Ashok N
* Date  :01/18/2019
* Ver :1.0
* Business purpouse : Used to track the history of the fields on Account and insert in Credentialing_Comments_History__c object
* PPN-30357 

*Author : Ashok N
* Date  :02/28/2019
* Ver :1.0

PPN-34061 
*/
    
    public void CommentHistoryTracking(Map<id,Account> OldMapAccountValues, Map<Id,Account> newMapAccountValues)
    {
        MassCreationDataObjectQuery MassCreationQuery = new MassCreationDataObjectQuery();
        List<Credentialing_Comments_History__c> List_InsertCredentialingCommentsHistory = new List<Credentialing_Comments_History__c>();
        Map<Id,Account> AccountOldMapValues = new Map<id,Account>();
        List<Credentialing_Comments_History__c> List_InsertCredentialing_Comments_History = new List<Credentialing_Comments_History__c>();
        Map<Id,String> Map_Cred_Status= new Map<id,String>();
        Map<Id,Date> Map_Cred_Status_Date = new Map<id,Date>();
        Map<Id,Date> Map_Re_Credentialing_date = new Map<id,Date>();
        Map<Id,String> Map_Comments = new Map<id,String>();
        Map<Id,String> Map_Cred_Cycle = new Map<id,String>();
        Boolean ToCreateHistory= false; 
        Set<Id> Set_UserId= new Set<Id>();
        map<Id,String> Map_UserAlias = new Map<Id,String>();
        Set_UserId.add(UserInfo.getUserId());
        Map<Id,user> GetUserValues= MassCreationQuery.getUserDetails(Set_UserId);
        for(User UserValues :GetUserValues.values())
        {
          Map_UserAlias.put(UserValues.Id,Uservalues.Alias);            
        }
        if(Map_UserAlias.get(Userinfo.getUserId())=='prov')
        {
            for(Account AccountValues : newMapAccountValues.values())
            {
                Credentialing_Comments_History__c Insert_Credentialing_Comments_History = new Credentialing_Comments_History__c(); 
                Insert_Credentialing_Comments_History.Cred_Status__c=AccountValues.Cred_Status__c;
                Insert_Credentialing_Comments_History.Cred_Status_Date__c=AccountValues.Cred_Status_Date__c;
                Insert_Credentialing_Comments_History.Comments_History__c=AccountValues.Comments__c;
                Insert_Credentialing_Comments_History.Re_Cred_Date__c=AccountValues.Re_Credentialing_date__c;
                Insert_Credentialing_Comments_History.Cred_Cycle__c=AccountValues.Cred_Cycle__c;
                Insert_Credentialing_Comments_History.Account__c=AccountValues.Id;
                List_InsertCredentialing_Comments_History.add(Insert_Credentialing_Comments_History);
                
            }
            if(List_InsertCredentialing_Comments_History.size()>0)
            {
                try{
                    insert List_InsertCredentialing_Comments_History;
                }catch(DmlException e)
                {
                    system.debug('Excpetion===e'+e.getMessage());
                }
            }
        }
          
        
    }  
}