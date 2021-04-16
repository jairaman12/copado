public class ProviderIdentificationHandler implements ITrigger
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
            linkCaseForUpdate((Map<Id,CM_Provider_Identification__c>)Trigger.newMap,(Map<Id,CM_Provider_Identification__c>)Trigger.oldMap);
            linkCaseForInsert(Trigger.new);
        }
        if(Trigger.isDelete && Trigger.isAfter)
        {
            linkCaseForDelete(Trigger.old);
        }        
    }
    
    public void linkCaseForInsert(List<CM_Provider_Identification__c> listOfIdentifications)
    {
        List<Id> listOfAccountIds = new List<Id>();
        Map<Id,List<String>> mapOfAccountIdAndItsNPI = new Map<Id,List<String>>();
        Map<Id,List<String>> mapOfAccountIdAndItsTaxId = new Map<Id,List<String>>();
        for(CM_Provider_Identification__c newIdentification:listOfIdentifications)
        {
            if(newIdentification.CM_PI_Prov__c !=NULL && newIdentification.CM_Prvdr_Iden_Typ_Cd__c =='NPI' && newIdentification.CM_Issu_Ident_Nmbr__c!=NULL)
            {
                listOfAccountIds.add(newIdentification.CM_PI_Prov__c);
            }    
        }
        for(CM_Provider_Tax_Id__c newTaxId:[Select CM_PTI_Prov_Name_From__c,CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Prov_Name_From__c In:listOfAccountIds and (CM_PTI_prov_Name_From__r.RecordType.Name='Entity Account' OR CM_PTI_prov_Name_From__r.RecordType.Name='Physician')])
        {
            List<String> listOfTaxIds = new List<String>();
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
        System.debug('map 1-'+mapOfAccountIdAndItsTaxId);
        for(CM_Provider_Identification__c newIdentification:[Select CM_Issu_Ident_Nmbr__c,CM_PI_Prov__c,CM_Prvdr_Iden_Typ_Cd__c From CM_Provider_Identification__c Where CM_PI_Prov__c In:listOfAccountIds and CM_Prvdr_Iden_Typ_Cd__c ='NPI' and (CM_PI_Prov__r.RecordType.Name='Entity Account' OR CM_PI_Prov__r.RecordType.Name='Physician')])
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
        System.debug('map 2-'+mapOfAccountIdAndItsNPI);
        Map<String,Id> mapOfKeyAndItsId = new Map<String,Id>();
        for(Id newId:mapOfAccountIdAndItsNPI.keyset())
        {
            for(String npiNo:mapOfAccountIdAndItsNPI.get(newId))
            {
                if(mapOfAccountIdAndItsTaxId !=NULL && mapOfAccountIdAndItsTaxId.containsKey(newId))
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
        System.debug('Map 3=-'+mapOfKeyAndItsId);
        List<Case> listOfCaseToUpdate = new List<Case>();
        List<String> listOfNpiIds = new List<String>();
        List<String> listOfTaxIds = new List<String>();
        for(List<String> listOfNpis:mapOfAccountIdAndItsNPI.values())
        {
            listOfNpiIds.addAll(listOfNpis);
        }
        for(List<String> listOfTaxId:mapOfAccountIdAndItsTaxId.values())
        {
            listOfTaxIds.addAll(listOfTaxId);
        }
        for(Case newCase:[Select Case_Entity__c,Billing_NPI_Number__c,Tax_ID_Number__c From Case Where ((RecordType.Name ='Provider Group Onboarding Data Entry' OR RecordType.Name ='Provider On-boarding Data Entry' OR RecordType.Name ='Provider On-boarding') AND Billing_NPI_Number__c In :listOfNpiIds  AND Tax_ID_Number__c In :listOfTaxIds) ])
        {
            if(newCase.Billing_NPI_Number__c !=NULL && newCase.Billing_NPI_Number__c !='' && newCase.Tax_Id_Number__c !=NULL && newCase.Tax_Id_Number__c !=''
                && mapOfKeyAndItsId.containsKey(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c))
            {
                newCase.Case_Entity__c = mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'@'+newCase.Tax_Id_Number__c);
            }
            listOfCaseToUpdate.add(newCase); 
        }
        System.debug('List = '+listOfCaseToUpdate);
        update listOfCaseToUpdate;
        
    }
    
    public void linkCaseForUpdate(Map<Id,CM_Provider_Identification__c>mapOfNewIdentifications, Map<Id,CM_Provider_Identification__c> mapOfOldIdentifications)
    {
        List<Id> listOfAccountIds = new List<Id>();
        List<Case> listOfCaseToUpdate = new List<Case>();
        for(Id newId:mapOfNewIdentifications.keyset())
        {
            if(mapOfNewIdentifications.get(newId).CM_PI_Prov__c !=mapOfOldIdentifications.get(newId).CM_PI_Prov__c || 
                mapOfNewIdentifications.get(newId).CM_Prvdr_Iden_Typ_Cd__c != mapOfOldIdentifications.get(newId).CM_Prvdr_Iden_Typ_Cd__c ||
                mapOfNewIdentifications.get(newId).CM_Issu_Ident_Nmbr__c != mapOfOldIdentifications.get(newId).CM_Issu_Ident_Nmbr__c ||
                (mapOfNewIdentifications.get(newId).CM_Prvdr_Iden_Typ_Cd__c =='NPI' || mapOfOldIdentifications.get(newId).CM_Prvdr_Iden_Typ_Cd__c =='NPI'))
            {
                listOfAccountIds.add(mapOfOldIdentifications.get(newId).CM_PI_Prov__c);
            }
        }
        for(Case oldCase:[Select Case_Entity__c From Case where (Case_Entity__c in:listOfAccountIds and (RecordType.Name ='Provider Group Onboarding Data Entry' OR RecordType.Name ='Provider On-boarding Data Entry' OR RecordType.Name ='Provider On-boarding'))])
        {
            oldCase.Case_Entity__c=NULL;
            listOfCaseToUpdate.add(oldCase);
        }
        update listOfCaseToUpdate;
    }
    
    public void linkCaseForDelete(List<CM_Provider_Identification__c> listOfIdentification)
    {
        List<Id> listOfAccountIds = new List<Id>();
        List<Case> listOfCaseToDelete = new List<Case>();
        for(CM_Provider_Identification__c newIdentification:listOfIdentification)
        {
            listOfAccountIds.add(newIdentification.CM_PI_Prov__c);
        }
        System.debug('List - '+listOfAccountIds);
        for(Case oldCase:[Select Case_Entity__c From Case where (Case_Entity__c in:listOfAccountIds and (RecordType.Name ='Provider Group Onboarding Data Entry' OR RecordType.Name ='Provider On-boarding Data Entry' OR RecordType.Name ='Provider On-boarding'))])
        {
            oldCase.Case_Entity__c=NULL;
            listOfCaseToDelete.add(oldCase);
        }
        System.debug('List - '+listOfCaseToDelete);
        update listOfCaseToDelete;
    }
}