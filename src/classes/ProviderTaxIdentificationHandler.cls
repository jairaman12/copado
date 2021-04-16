public class ProviderTaxIdentificationHandler implements ITrigger
{
    public void beforeInsert(SObject so) {}
    public void beforeUpdate(SObject oldSo, SObject so) {}
    public void beforeDelete(SObject so) {}
    public void afterInsert(SObject so) {}
    public void afterUpdate(SObject oldSo, SObject so) {}
    public void afterDelete(SObject so) {}
    public void andFinally() {}
    public void bulkBefore() {}
    public void bulkAfter() 
    {
        if(Trigger.isInsert && Trigger.isAfter)
        {
            linkCaseForInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate && Trigger.isAfter)
        {
            linkCaseForUpdate((Map<Id,CM_Provider_Tax_Id__c>)Trigger.newMap,(Map<Id,CM_Provider_Tax_Id__c>)Trigger.oldMap);
            linkCaseForInsert(Trigger.new);
        }
        if(Trigger.isDelete && Trigger.isAfter)
        {
            linkCaseForDelete(Trigger.old);
        }        
    }
    
    public void linkCaseForInsert(List<CM_Provider_Tax_Id__c> listOfIdentifications)
    {
        List<Id> listOfAccountIdIds = new List<Id>();
        Map<Id,List<String>> mapOfAccountIdIdAndItsNPI = new Map<Id,List<String>>();
        Map<Id,List<String>> mapOfAccountIdIdAndItsTaxId = new Map<Id,List<String>>();
        Map<Id,String> mapOfAccountIdAndItsType = new Map<Id,String>();
        for(CM_Provider_Tax_Id__c newIdentification:listOfIdentifications)
        {
            if(newIdentification.CM_PTI_Prov_Name_From__c !=NULL && newIdentification.CM_PTI_Tax_Id__c !=NULL)
            {
                listOfAccountIdIds.add(newIdentification.CM_PTI_Prov_Name_From__c );
            }    
        }
        for(Account newAccount:[Select Id,RecordType.Name From Account where Id In:listOfAccountIdIds])
        {
            mapOfAccountIdAndItsType.put(newAccount.Id,newAccount.RecordType.Name);
        }
        for(CM_Provider_Tax_Id__c newTaxId:[Select CM_PTI_Prov_Name_From__c,CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Prov_Name_From__c In:listOfAccountIdIds and (CM_PTI_Prov_Name_From__r.RecordType.Name='Entity Account' OR CM_PTI_Prov_Name_From__r.RecordType.Name='Physician')])
        {
            List<String> listOfTaxIds = new List<String>();
            if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL && mapOfAccountIdIdAndItsTaxId.containsKey(newTaxId.CM_PTI_Prov_Name_From__c))
            {
                listOfTaxIds = mapOfAccountIdIdAndItsTaxId.get(newTaxId.CM_PTI_Prov_Name_From__c);
            }
            if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL)
            {
                listOfTaxIds.add(newTaxId.CM_PTI_Tax_Id__c);
                mapOfAccountIdIdAndItsTaxId.put(newTaxId.CM_PTI_Prov_Name_From__c,listOfTaxIds);
            }
        }
        System.debug('Map 1-'+mapOfAccountIdIdAndItsTaxId);
        for(CM_Provider_Identification__c newIdentification:[Select CM_Issu_Ident_Nmbr__c,CM_PI_Prov__c,CM_Prvdr_Iden_Typ_Cd__c From CM_Provider_Identification__c Where CM_PI_Prov__c In:listOfAccountIdIds and CM_Prvdr_Iden_Typ_Cd__c ='NPI' and (CM_PI_Prov__r.RecordType.Name='Entity Account' OR CM_PI_Prov__r.RecordType.Name='Physician')])
        {
            List<String> listOfNPIIds = new List<String>();
            if(newIdentification.CM_Issu_Ident_Nmbr__c !=NULL && mapOfAccountIdIdAndItsNPI.containsKey(newIdentification.CM_PI_Prov__c))
            {
                listOfNPIIds = mapOfAccountIdIdAndItsNPI.get(newIdentification.CM_PI_Prov__c);
            }
            if(newIdentification.CM_Issu_Ident_Nmbr__c !=NULL)
            {
                listOfNPIIds.add(newIdentification.CM_Issu_Ident_Nmbr__c);
                mapOfAccountIdIdAndItsNPI.put(newIdentification.CM_PI_Prov__c,listOfNPIIds);
            }    
        }
        System.debug('Map 2'+mapOfAccountIdIdAndItsNPI);
        Map<String,Id> mapOfKeyAndItsId = new Map<String,Id>();
        for(Id newId:mapOfAccountIdIdAndItsTaxId.keyset())
        {
            for(String taxNo:mapOfAccountIdIdAndItsTaxId.get(newId))
            {
                if(mapOfAccountIdIdAndItsNPI !=NULL && mapOfAccountIdIdAndItsNPI.containsKey(newId))
                {
                    for(String npiNo:mapOfAccountIdIdAndItsNPI.get(newId))
                    {
                        if(npiNo !=NULL && npiNo !='' && taxNo !=NULL && taxNo !='')
                        {
                            mapOfKeyAndItsId.put(npiNo+'@'+taxNo,newId);
                        }
                    }
                }
            }
        }
        System.debug('Map 3'+mapOfKeyAndItsId);
        List<Case> listOfCaseToUpdate = new List<Case>();
        List<String> listOfNpiIds = new List<String>();
        List<String> listOfTaxIds = new List<String>();
        for(List<String> listOfNpis:mapOfAccountIdIdAndItsNPI.values())
        {
            listOfNpiIds.addAll(listOfNpis);
        }
        for(List<String> listOfTaxId:mapOfAccountIdIdAndItsTaxId.values())
        {
            listOfTaxIds.addAll(listOfTaxId);
        }
        for(Case newCase:[Select Case_Entity__c,Billing_NPI_Number__c,Tax_ID_Number__c From Case Where ((RecordType.Name ='Provider Group Onboarding Data Entry' OR RecordType.Name ='Provider On-boarding Data Entry' OR RecordType.Name ='Provider On-boarding') AND Billing_NPI_Number__c In :listOfNpiIds  AND Tax_ID_Number__c In :listOfTaxIds) ])
        {
            if(newCase.Billing_NPI_Number__c !=NULL && newCase.Billing_NPI_Number__c !='' && newCase.Tax_Id_Number__c !=NULL && newCase.Tax_Id_Number__c !=''
                && mapOfKeyAndItsId.containsKey(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c))
            {
                if(mapOfAccountIdAndItsType.containsKey(mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c)) &&
                mapOfAccountIdAndItsType.get(mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c))=='Entity Account')
                {
                    newCase.Case_Entity__c = mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c);
                }
                else
                {
                    newCase.AccountId=mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c);
                }
            }
            listOfCaseToUpdate.add(newCase); 
        }
        System.debug('Cases'+listOfCaseToUpdate);
        update listOfCaseToUpdate;
        
    }
    
    public void linkCaseForUpdate(Map<Id,CM_Provider_Tax_Id__c>mapOfNewIdentifications, Map<Id,CM_Provider_Tax_Id__c> mapOfOldIdentifications)
    {
        List<Id> listOfAccountIdIds = new List<Id>();
        Set<id> setOfAccountIdIds = new Set<Id>();
        List<Case> listOfCaseToUpdate = new List<Case>();
        for(Id newId:mapOfNewIdentifications.keyset())
        {
            if(mapOfNewIdentifications.get(newId).CM_PTI_Prov_Name_From__c !=mapOfOldIdentifications.get(newId).CM_PTI_Prov_Name_From__c || 
                mapOfNewIdentifications.get(newId).CM_PTI_Tax_Id__c!= mapOfOldIdentifications.get(newId).CM_PTI_Tax_Id__c)
            {
                listOfAccountIdIds.add(mapOfOldIdentifications.get(newId).CM_PTI_Prov_Name_From__c);
            }
        }
        setOfAccountIdIds.addAll(listOfAccountIdIds);
        System.debug('List '+listOfAccountIdIds);
        for(Case oldCase:[Select Case_Entity__c,AccountId From Case where ((Case_Entity__c in:listOfAccountIdIds OR AccountId In:listOfAccountIdIds) and (RecordType.Name ='Provider Group Onboarding Data Entry' OR RecordType.Name ='Provider On-boarding Data Entry' OR RecordType.Name ='Provider On-boarding'))])
        {
            if(oldCase.Case_Entity__c !=NULL && setOfAccountIdIds.contains(oldCase.Case_Entity__c))
            {
                oldCase.Case_Entity__c=NULL;
            }
            else
            {
                oldCase.AccountId=NULL;
            }
            listOfCaseToUpdate.add(oldCase);
        }
        System.debug('Cases'+listOfCaseToUpdate);
        update listOfCaseToUpdate;
    }
    
    public void linkCaseForDelete(List<CM_Provider_Tax_Id__c> listOfIdentification)
    {
        List<Id> listOfAccountIdIds = new List<Id>();
        List<Case> listOfCaseToDelete = new List<Case>();
        Set<Id> setOfAccountIdIds = new Set<Id>();
        for(CM_Provider_Tax_Id__c newIdentification:listOfIdentification)
        {
            listOfAccountIdIds.add(newIdentification.CM_PTI_Prov_Name_From__c);
        }
        setOfAccountIdIds.addAll(listOfAccountIdIds);
        System.debug('list - '+listOfAccountIdIds);
        for(Case oldCase:[Select Case_Entity__c,AccountId From Case where ((Case_Entity__c in:listOfAccountIdIds OR AccountId In:listOfAccountIdIds) and (RecordType.Name ='Provider Group Onboarding Data Entry' OR RecordType.Name ='Provider On-boarding Data Entry' OR RecordType.Name ='Provider On-boarding'))])
        {
            if(oldCase.Case_Entity__c !=NULL && setOfAccountIdIds.contains(oldCase.Case_Entity__c))
            {
                oldCase.Case_Entity__c=NULL;
            }
            else
            {
                oldCase.AccountId=NULL;
            }
            listOfCaseToDelete.add(oldCase);
        }
        System.debug('List - '+listOfCaseToDelete);
        update listOfCaseToDelete;
    }    
}