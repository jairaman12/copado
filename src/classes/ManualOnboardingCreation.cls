public without sharing class ManualOnboardingCreation
{
    public List<SelectOption> listOfRecordTypes{get;set;}
    public String selectedType{get;set;}
    public Boolean isEdit{get;set;}
    public Case newCase{get;set;}
    public Account newAccount{get;set;}
    public string  accPlanId {get;set;}
    public List<Schema.FieldSetMember> listOfFields{get;set;}
    public List<String> listOfSectionNames{get;set;}
    public Map<String,List<Schema.FieldSetMember>> mapOfSectionNameAndItsFieldSets{get;set;}
    public Id accountId;
    Public Id businessAcntId;
    public boolean isPersonAccount;
    public boolean isfecilityAccount;//sujatha G
    public list<Providerwrapper> providerwrapperList {get;set;}
    public Integer countOfProviderDetails{get;set;}
    public List<Provider_Networks__c> ProviderDetailList = new List<Provider_Networks__c>();
    public Boolean isEditRow {get;set;}
    public boolean fromIndvPfin    {get;set;}
    public boolean isFromGroup  {get;set;}
    public string provId;
    public Boolean provcheck;
    public string selectedPlan {get;set;}
    //public boolean showCredStatus {get;set;}  //Sujatha PPN-30261   commented By Suman for PPN-39574
    public boolean isAncillaryAccount;
    
    
    public ManualOnboardingCreation(ApexPages.StandardController controller) 
    {
       // newCase = new Case();
        
        //newAccount = (Account)controller.getRecord();
        providerwrapperList = new list<Providerwrapper>();
        ProviderDetailList = new List<Provider_Networks__c>();
        provcheck = false;
        isEditRow = false;
        isFromGroup  = false;
        countOfProviderDetails = 0;
        mapOfSectionNameAndItsFieldSets = new Map<String,List<Schema.FieldSetMember>>();
        listOfSectionNames = new List<String>();
        selectedType='';
        listOfRecordTypes = new List<SelectOption>();
        listOfFields = new List<Schema.FieldSetMember>();
        listOfRecordTypes.add(new SelectOption('','--None--'));
        accountId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('accountId ----'+accountId);
        isPersonAccount=false;
        isfecilityAccount = false;
        isAncillaryAccount = false;
        
        
        
        
        if(accountId == null)
        {
            Map<String,RoleAndPlanId_Settings__c> roleMap   =   RoleAndPlanId_Settings__c.getAll();
            Map<Id,String> roleIdWithPlanMap                =   new Map<Id,String>();
            Id uRoleId                                      =   UserInfo.getUserRoleId();
            // PlanId based on logged in User user 
            for( RoleAndPlanId_Settings__c record : roleMap.values() )
            {
                roleIdWithPlanMap.put( record.Role_Id__c , record.PlanId__c );
            }
            if(!roleIdWithPlanMap.isEmpty())
            {
                accPlanId  = roleIdWithPlanMap.get(uRoleId);  
            }
        }           
        
        
        
        for(Account acc : [SELECT Id, isPersonAccount,Class__c,CM_Corporate_Entity_Code__c,Organization_Type__c, Prov_ID__c FROM Account WHERE Id =: accountId]){
            //if(acc.size()>0){
                provId =acc.Prov_ID__c;
           // }
           
            
            if(acc != null){
                accPlanId = acc.CM_Corporate_Entity_Code__c;
            }    
            if(acc.isPersonAccount){
                isPersonAccount = true;
            }            
            else{
                isPersonAccount= false;
            }
            // PPN-36045
           system.debug('isPersonAccount +++'+isPersonAccount );
            if(isPersonAccount == false && acc.Class__c != null && acc.Class__c == 'F'){             
              isfecilityAccount = true;              
            }
            if(isPersonAccount == false && acc.Class__c != null && acc.Organization_Type__c != null && acc.Class__c == 'C' && acc.Organization_Type__c == 'ANCMEDGP'){             
              isAncillaryAccount = true;
            }
        }
        system.debug('isfecilityAccount+++'+isfecilityAccount);
        system.debug('isAncillaryAccount+++'+isAncillaryAccount);
        system.debug('isPersonAccount +++'+isPersonAccount );
        for(ManualOnboardingCaseWithFieldSets__mdt newMdt:[Select RecordType__c,FieldSets__c From ManualOnboardingCaseWithFieldSets__mdt ORDER BY RecordType__c])
        {  
            system.debug('newMdt+++++'+newMdt);           
            system.debug('RecordType__c+++'+newMdt.RecordType__c);
            if(accountId != NULL){
                if(!isPersonAccount && isfecilityAccount){
                    if(newMdt.recordType__c.contains('Facility')){
                        listOfRecordTypes.add(new SelectOption(newMdt.RecordType__c,newMdt.RecordType__c));
                    }
                }
            
                if(isAncillaryAccount){
                    if(newMdt.recordType__c.contains('Ancillary')){
                        listOfRecordTypes.add(new SelectOption(newMdt.RecordType__c,newMdt.RecordType__c));
                    }
                }
            }
            
            if(newMdt.recordType__c != 'Provider Group On-boarding Credentialing' && isfecilityAccount == false && isAncillaryAccount == false && newMdt.recordType__c != 'Provider On-boarding Credentialing - Facility' && newMdt.recordType__c != 'Provider On-boarding Credentialing - Ancillary'){
                if(accountId != NULL){                   
                    if(isPersonAccount ){
                        if(!newMdt.recordType__c.contains('Group')){
                            listOfRecordTypes.add(new SelectOption(newMdt.RecordType__c,newMdt.RecordType__c));
                        }
                    }
                    else{
                        if(newMdt.recordType__c.contains('Group')){
                            listOfRecordTypes.add(new SelectOption(newMdt.RecordType__c,newMdt.RecordType__c));
                        }
                    }
                }
                else{
                    if(newMdt.RecordType__c == 'Provider On-boarding Data Entry' || newMdt.RecordType__c == 'Provider Group On-boarding Data Entry'){
                        listOfRecordTypes.add(new SelectOption(newMdt.RecordType__c,newMdt.RecordType__c));
                    }
                }
            }
        }
        system.debug('listOfRecordTypes+'+listOfRecordTypes);
          
           providerWrapper providerWrap = new providerWrapper();
           providerWrap.curCase = new Case();
           countOfProviderDetails ++;
           if(isPersonAccount == true || isfecilityAccount == true || isAncillaryAccount == true)
           {
               providerWrap.curCase.Prov_ID__c = provId ;
           }           
           providerWrap.counterWrap = countOfProviderDetails ;
           providerWrap.curCase.Plan_ID__c = accplanId;
           providerwrapperList.add(providerWrap );
        
        
        isEdit = false;
        newCase = new Case();
        
        newAccount = (Account)controller.getRecord();
        
        populateProvider();
    }
    /*public ManualOnboardingCreation(ApexPages.StandardsetController con)
    {
        providerwrapperList = new list<Providerwrapper>();
        providerWrapper providerWrap = new providerWrapper();
        countOfProviderDetails = 0;
        providerWrap.curCase = new Case();
       countOfProviderDetails ++;
       providerWrap.counterWrap = countOfProviderDetails ;
       providerWrap.curCase.Prov_ID__c = provId ;
       providerwrapperList.add(providerWrap );
       system.debug(countOfProviderDetails+'countOfProviderDetails'); 
       selectedType='';
        newCase = new Case();
        newCase = (Case)con.getRecord();      
    }*/

    public PageReference proceed()
    {
        System.debug('What is in selectedType'+selectedType);
        newCase = new Case();
        mapOfSectionNameAndItsFieldSets = new Map<String,List<Schema.FieldSetMember>>();
        GlobalSettings__c objshow = GlobalSettings__c.getValues('Ancillary FacilityPage Navigation');
        listOfSectionNames = new List<String>();
        if(selectedType =='' || selectedType==NULL)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select recordtype to proceed'));
            return null;            
        }
        else if (selectedType !=NULL)
        {
            List<String> listOfFieldSets = new List<String>();
            for(ManualOnboardingCaseWithFieldSets__mdt newMdt:[Select RecordType__c,FieldSets__c From ManualOnboardingCaseWithFieldSets__mdt where RecordType__c =:selectedType])
            {
                listOfFieldSets = newMdt.FieldSets__c.split(';');
            }
            for(String fieldSetName:listOfFieldSets)
            {
                listOfSectionNames.add(Schema.SObjectType.Case.fieldSets.getMap().get(fieldSetName).getLabel());  
                mapOfSectionNameAndItsFieldSets.put(Schema.SObjectType.Case.fieldSets.getMap().get(fieldSetName).getLabel(),Schema.SObjectType.Case.fieldSets.getMap().get(fieldSetName).getFields());  
                newCase.status='New';
            }            
        } 
        if(selectedType == 'Provider On-boarding Data Entry')
        {         
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Data_Entry_Provider_On_boarding' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id;
            newCase.Source__c = 'Provider On-boarding Data Entry';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Individual Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding individual provider';
            newCase.Completing_the_form_for__c='Individual';
            fromIndvPfin = true;            
            if(isPersonAccount)
                newCase.accountId = accountId;
            else 
                newCase.case_entity__c = accountId;           
            isEdit=true;           
            return NULL;   
            
        }             
        else if(selectedType == 'Provider On-boarding Contracting')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Contracting_Provider_On_boarding' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider On-boarding Contracting';
            newCase.origin='Manual On-boarding';
            newCase.Priority = 'Medium';
            newCase.subject='Manual On-boarding Individual Provider';
            newCase.description='Creating an application to on boarding individual provider';
            newCase.Priority = 'Medium';
            newCase.Completing_the_form_for__c='Individual';
            fromIndvPfin = false; 
            if(isPersonAccount)
            {
                newCase.accountId = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select firstName,lastName from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName;
                    populateProvider();
                }
            }
            else 
            {
                newCase.case_entity__c = accountId;
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                 }
            }           
            isEdit=true;
            return NULL;
        }
        else if(selectedType =='Provider On-boarding Credentialing')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_On_boarding_Credentialing' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider On-boarding Credentialing';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Individual Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding individual provider';
            newCase.Completing_the_form_for__c='Individual'; 
            fromIndvPfin = false;           
            if(isPersonAccount)
            {
                newCase.accountId = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select firstName,lastName from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName;
                    populateProvider();
                }
            }
            else 
            {
                newCase.case_entity__c = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();     
                }   
            }
            
            isEdit=true;
            
            return NULL;
        } 
        else if(selectedType =='Provider On-boarding Counter sign')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_On_boarding_Counter_Sign' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider On-boarding Counter sign';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Individual Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding individual provider';
            newCase.Completing_the_form_for__c='Individual';
            fromIndvPfin = false; 
             if(isPersonAccount)
            {
                newCase.accountId = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select firstName,lastName from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName;
                    populateProvider();
                }
            }
            else 
            {
                newCase.case_entity__c = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();     
                }   
            }           
            isEdit=true;
            return NULL;
        } 
        //Sujatha PPN - 36045 -Starts
        else if(selectedType =='Provider On-boarding Credentialing - Facility')
        {
            if(objshow.Enable_Ancillary_Facility__c == True) {
                PageReference pageRef = new PageReference('/apex/ShowMaintenance');
                system.debug('pageRef'+pageRef);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else{
                List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_On_boarding_Credentialing_Facility' Limit 1];
                newCase.RecordtypeId = listOftype[0].Id; 
                newCase.Source__c = 'Provider On-boarding Credentialing - Facility';
                newCase.origin='Manual On-boarding';
                newCase.subject='Manual On-boarding Facility Provider';
                newCase.Priority = 'Medium';
                newCase.description='Creating an application to on board facility provider';
                newCase.Completing_the_form_for__c='Facility'; 
                newCase.Prov_ID__c  =   provId;
                fromIndvPfin = false;           
                if(isfecilityAccount){
                    //newCase.accountId = accountId;
                    newCase.case_entity__c = accountId; 
                    if(accountId !=NULL)
                    {
                        Account newAccount = [Select firstName,lastName from Account Where Id=:accountId];
                        newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName;
                        populateProvider();
                    }
                }
               else {
                    newCase.case_entity__c = accountId; 
                    if(accountId != NULL)
                    {
                        Account newAccount = [Select Name from Account Where Id=:accountId];
                        newCase.Name_of_Provider_Group__c=newAccount.Name;   
                        populateProvider();        
                     } 
                }        
                isEdit=true;
                return NULL;
            }
        } 
        // Sujatha PPN-36045 -Ends
        else if(selectedType =='Provider Group On-boarding Data Entry')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Data_Entry_Group_Provider_On_boarding' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider On-boarding Counter sign';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Group Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding Group provider';
            newCase.Completing_the_form_for__c='Group'; 
            newCase.Prov_ID__c  =   provId;
            fromIndvPfin = true;
            isFromGroup  = true; 
            if(isPersonAccount){
                newCase.accountId = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select firstName,lastName from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName;
                    populateProvider();
                }
            }
            else {
                newCase.case_entity__c = accountId; 
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                 } 
            }        
            isEdit=true;
            return NULL;
        } 
        else if(selectedType =='Provider Group On-boarding Contracting')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_Group_Onboarding_Contracting' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider Group On-boarding Contracting';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Group Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding Group provider';
            newCase.Completing_the_form_for__c='Group';
            fromIndvPfin = false; 
            isFromGroup  = true; 
            //showCredStatus = true;  //Sujatha PPN-30261 commented By Suman for PPN-39574
            /* if(isPersonAccount)
                newCase.accountId = accountId;
            else 
                newCase.case_entity__c = accountId;*/
           //PPN-29277-Sujatha G. Starts     
           if(isPersonAccount)
            {
                newCase.accountId = accountId;
                if(accountId !=NULL)
                {
                    Account newAccount = [Select firstName,lastName from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName;
                    populateProvider();
                }
            }
            else 
            {
                newCase.case_entity__c = accountId;
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                 }
            } 
            //PPN-29277-Sujatha G. Ends
    
            isEdit=true;
            return NULL;
        } 
        else if(selectedType =='Provider Group On-boarding Credentialing')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_Group_On_boarding_Credentialling' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider Group On-boarding Credentialing';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Group Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding Group provider';
            newCase.Completing_the_form_for__c='Group';
            fromIndvPfin = false;
            isFromGroup  = true;  
            if(isPersonAccount){
                newCase.accountId = accountId;
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                 }
            }
            else {
                newCase.case_entity__c = accountId;
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                 }
            }
            isEdit=true;
            return NULL;
        } 
        else if(selectedType =='Provider Group On-boarding Counter sign')
        {
            List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_Group_On_boarding_Counter_Sign' Limit 1];
            newCase.RecordtypeId = listOftype[0].Id; 
            newCase.Source__c = 'Provider Group On-boarding Counter sign';
            newCase.origin='Manual On-boarding';
            newCase.subject='Manual On-boarding Group Provider';
            newCase.Priority = 'Medium';
            newCase.description='Creating an application to on boarding Group provider';
            newCase.Completing_the_form_for__c='Group';
            fromIndvPfin = false;
            isFromGroup  = true;  
             if(isPersonAccount){
                newCase.accountId = accountId;
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                 }
            }else{ 
                newCase.case_entity__c = accountId;
                if(accountId != NULL)
                {
                    Account newAccount = [Select Name from Account Where Id=:accountId];
                    newCase.Name_of_Provider_Group__c=newAccount.Name;   
                    populateProvider();        
                }
            }
            isEdit=true;
            return NULL;
        } 
        else if(selectedType =='Provider On-boarding Credentialing - Ancillary')
        {
             if(objshow.Enable_Ancillary_Facility__c == True) {          
               
                PageReference pageRef = new PageReference('/apex/ShowMaintenance');
                system.debug('pageRef'+pageRef);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else {
                List<RecordType> listOfType = [Select Id From RecordType where DeveloperName='Provider_On_boarding_Credentialing_Ancillary' Limit 1];
                newCase.RecordtypeId = listOftype[0].Id; 
                newCase.Source__c = 'Provider On-boarding Credentialing - Ancillary';
                newCase.origin='Manual On-boarding';
                newCase.subject='Manual On-boarding Ancillary Provider';
                newCase.Priority = 'Medium';
                newCase.description='Creating an application to on board ancillary provider';
                newCase.Completing_the_form_for__c='Ancillary';
                fromIndvPfin = false;
                if(isAncillaryAccount){
                    
                    newCase.case_entity__c = accountId;
                    if(accountId != NULL)
                    {
                        Account newAccount = [Select Name from Account Where Id=:accountId];
                        newCase.Name_of_Provider_Group__c=newAccount.Name;   
                        populateProvider();        
                    }
                }
                isEdit=true;
                return NULL;
            }
        } 
        
        return NULL;
    }
    
      public boolean Validate()
      { 
        boolean error = false; 
         provcheck = false;
         
        Set<String> setValidCRMCases = new Set<String>();
        String strCRMRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CRM').getRecordTypeId();
        
        for(Case crmCase : [SELECT Id, caseNumber FROM Case WHERE caseNumber!= Null AND recordTypeId =: strCRMRecTypeId AND CaseNumber =: newCase.CRM_Case_Number__c]){
            setValidCRMCases.add(crmCase.CaseNumber);
        }
         
         
         if (newCase.Corporate_Received_Date_Time__c == null){
            newCase.Corporate_Received_Date_Time__c.addError('Corporate received date should not be empty');
            error = true;
        }if (newCase.Corporate_Received_Date_Time__c != null && newCase.Corporate_Received_Date_Time__c > DateTime.NOW()){
            newCase.Corporate_Received_Date_Time__c.addError(Label.CorpVal);
            error = true;
        } /*
        if (newCase.Plan_ID__c == null){
            newCase.Plan_ID__c.addError('Plan Id Should not be empty');
            error = true;
        }*/
        if((newCase.CAQH_Number__c!= null) && (!newCase.CAQH_Number__c.isNumeric())){
            newCase.CAQH_Number__c.addError('CAQH Number should be numeric only');
            error = true;
        }
        
        if(selectedType == 'Provider On-boarding Credentialing'){
            if((newCase.CRM_Case_Number__c != null)&& !setValidCRMCases.contains(newCase.CRM_Case_Number__c)){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the correct CRM Case Number.'));
                 error = true;
             }
        }
         system.debug('TaxId######'+newCase.Tax_ID_Number__c);
         if( selectedType != 'Provider On-boarding Credentialing - Ancillary' && selectedType != 'Provider On-boarding Credentialing - Facility'){
             if((newCase.Tax_ID_Number__c != null)){
                 if((!newCase.Tax_ID_Number__c.isNumeric()) || (newCase.Tax_ID_Number__c.isNumeric() && newCase.Tax_ID_Number__c.length() != 9)){
                    system.debug('TaxId'+newCase.Tax_ID_Number__c);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid TAX ID - Must be 9 digits'));
                    error = true;
                 }
            }
        }
        if(providerwrapperList.isEmpty()  && (selectedType == 'Provider On-boarding Contracting' || selectedType == 'Provider On-boarding Credentialing')){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Provider Details Should not be Empty'));
             error = true;
        }
        if( selectedType != 'Provider On-boarding Credentialing - Ancillary' && selectedType != 'Provider On-boarding Credentialing - Facility'){
            if(selectedType.contains('Group') && accountId == NULL && newCase.accountId == NULL && newCase.case_Entity__c == NULL && newCase.Billing_NPI_Number__c == NULL){
                 newCase.Billing_NPI_Number__c.addError('Please Enter Billing NPI number.');
                 error = true;
            }
            if(selectedType.contains('Group') && accountId == NULL && newCase.accountId == NULL && newCase.case_Entity__c == NULL && newCase.Tax_ID_Number__c == NULL){
                 newCase.Tax_ID_Number__c.addError('Please Enter Tax ID number.');
                 error = true;
            }
        }
        //Removing validations, As per US:PPN-29697 This fields are Optional.
        /* if(providerwrapperList.size() >0 && providerwrapperList[0].curCase.Prov_ID__c == null )
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Prov Id Should not be Empty'));
             error = true;
        }
        if(providerwrapperList.size() >0 && providerwrapperList[0].curCase.MC_PFIN__c == null )
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'PFIN Id Should not be Empty'));
             error = true;
        }*/
        //Sujatha PPN-30263 - starts And PPN-30261
        if(providerwrapperList.size() >0  && newCase.Out_of_Network__c== false && (selectedType == 'Provider On-boarding Contracting' || selectedType == 'Provider On-boarding Credentialing' 
                                                                                   || selectedType == 'Provider On-boarding Counter Sign' || selectedType == 'Provider Group On-boarding Contracting'|| selectedType == 'Provider Group On-boarding Counter sign'
                                                                                   || selectedType == 'Provider On-boarding Credentialing - Ancillary'|| selectedType == 'Provider On-boarding Credentialing - Facility'))
        {
             for(Integer i=0;i<providerwrapperList .size();i++)
             {
             if(providerwrapperList[i].curCase.Network_Name_Copy__c == null){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Network Name Should not be Empty'));
              error = true;
             }
             }
                         
        }
         //system.debug('provcheck fisrrt'+provcheck );
            //PPN-36706 -starts
         if(providerwrapperList.size() >0  )
        {
             for(Integer i=0;i<providerwrapperList .size();i++)
             {
             if(providerwrapperList[i].curCase.Prov_ID__c != null  && (selectedType == 'Provider Group On-boarding Contracting' ||
              selectedType == 'Provider Group On-boarding Counter sign' || selectedType == 'Provider On-boarding Contracting' || 
              selectedType == 'Provider On-boarding Counter Sign' || selectedType == 'Provider Group On-boarding Data Entry' || 
              selectedType == 'Provider On-boarding Credentialing - Ancillary' || selectedType == 'Provider On-boarding Credentialing - Facility' || 
              selectedType == 'Provider On-boarding Data Entry'|| selectedType == 'Provider On-boarding Credentialing')){
             // system.debug('providerwrapperList[i].curCase.Prov_ID__c ++++'+providerwrapperList[i].curCase.Prov_ID__c);
                  if(!providerwrapperList[i].curCase.Prov_ID__c.isNumeric() || providerwrapperList[i].curCase.Prov_ID__c.length()>9){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the valid 9 digit Prov ID'));
                      provcheck = true;
                      //system.debug('provcheck  valid 9 digit Prov I'+provcheck );
                      error = true;
                   }
        }
             }
                         
        }
         
         if(providerwrapperList.size() >0  )
        {
             for(Integer i=0;i<providerwrapperList .size();i++)
             {
             if(providerwrapperList[i].curCase.MC_PFIN__c != null){
             // system.debug('providerwrapperList[i].curCase.MC_PFIN__c ++++'+providerwrapperList[i].curCase.MC_PFIN__c );
                  if(!providerwrapperList[i].curCase.MC_PFIN__c .isAlphaNumeric() || providerwrapperList[i].curCase.MC_PFIN__c.length()>10){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter valid PFIN'));
                      error = true;
                   }
             }
         }
                         
        }
        //PPN-36706 -ends
        
        
        if(providerwrapperList.size() >0  )
        {
             for(Integer i=0;i<providerwrapperList .size();i++)
             {
             if(providerwrapperList[i].curCase.Prov_ID__c == null  && (selectedType == 'Provider Group On-boarding Contracting'|| selectedType == 'Provider On-boarding Contracting'|| selectedType == 'Provider On-boarding Credentialing' || selectedType == 'Provider On-boarding Counter Sign' || selectedType == 'Provider Group On-boarding Counter sign'
                 || selectedType == 'Provider On-boarding Credentialing - Ancillary'|| selectedType == 'Provider On-boarding Credentialing - Facility')){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'ProvId Should not be Empty'));              
              provcheck = true;
              //system.debug('provcheck  should not empty'+provcheck );
              error = true;
             }
             }
                         
        }
        if(providerwrapperList.size() >0  )
        {
             for(Integer i=0;i<providerwrapperList .size();i++)
             {
             if(providerwrapperList[i].curCase.MC_PFIN__c == null  && (selectedType == 'Provider On-boarding Contracting'|| selectedType == 'Provider On-boarding Credentialing' || selectedType == 'Provider On-boarding Counter Sign' || selectedType == 'Provider Group On-boarding Contracting'|| selectedType == 'Provider Group On-boarding Counter sign'
                 || selectedType == 'Provider On-boarding Credentialing - Ancillary'|| selectedType == 'Provider On-boarding Credentialing - Facility')){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'PFIN Should not be Empty'));
              error = true;
             }
             }
                         
        }
        //Sujatha PPN-30263 - ends
         // PPN - 31082 Starts
          if(ValidateProvIdInGroupContract()== true){
                error= true;
            }
         // PPN - 31082 Ends
         // PPN - 30306 Starts
         if(ValidateDuplicateCredentialingCase() == true){
            error = true;
         }
         // PPN - 30306 Ends
         if(validateNPILicenseInFacilityAndAncillary() == true){ // PPN - 41650
             error = true;
         }
         if(DuplicateCredentialingCaseCheck() == true){ // PPN - 42940
             error = true;
         }
         
        if(selectedType == 'Provider On-boarding Contracting' || selectedType == 'Provider On-boarding Counter Sign')
        {
            List<Account> acc = [SELECT Id, Prov_ID__c FROM Account WHERE Id =: newCase.accountId Limit 1];
            if(acc.size()>0){
                if(!providerwrapperList.isEmpty()){
                        if(provcheck != true && providerwrapperList[0].curCase.Prov_ID__c != null && providerwrapperList[0].curCase.Prov_ID__c != acc[0].Prov_ID__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Prov ID'));
                        error = true;   
                    }
                }
            }
        }
        if(selectedType == 'Provider On-boarding Credentialing - Facility' || selectedType == 'Provider On-boarding Credentialing - Ancillary' )
        {
            
            List<Account> acc = [SELECT Id, Prov_ID__c FROM Account WHERE Id =: newCase.case_entity__c Limit 1];
            
            if(acc.size()>0){
                if(!providerwrapperList.isEmpty()){
                
                        if(provcheck != true && providerwrapperList[0].curCase.Prov_ID__c != null && providerwrapperList[0].curCase.Prov_ID__c != acc[0].Prov_ID__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Prov ID'));
                        error = true;   
                    }
                }
            }
        }
        system.debug('provcheck  value+++'+provcheck );
      return error;
      }
      
    
    public PageReference saveRecord()
    {
        System.debug('plan'+ newCase.Plan_ID__c);
        system.debug('***** accPlanId ***' + accPlanId );
         if (Validate()){
            return null;
        }
         newCase.Govt_Programs__c = newCase.OnboardingGovtProgram__c;
         newCase.Plan_ID__c = accplanId; 
        Id masterCaseId = insertMasterAndChild();
        System.debug('What is in this '+masterCaseId);
        if(masterCaseId != null){
        PageReference pageRef = new PageReference('/'+masterCaseId);
        pageRef.setRedirect(true);
        return pageRef;
        }       
        return null;
        
    }
    
    public PageReference saveAndNew()
    {
        if (Validate()){
            return null;
        }
         newCase.Govt_Programs__c = newCase.OnboardingGovtProgram__c;
        insertMasterAndChild();
        Case clonedCase = new Case();
        clonedCase = newCase.clone(false);
        newCase = clonedCase;
        return NULL;
        
    }
    
    public PageReference cancel()
    {
        GlobalSettings__c objshow = GlobalSettings__c.getValues('Ancillary FacilityPage Navigation');
        if(objshow.Enable_Ancillary_Facility__c == True){
         
            Schema.DescribeSObjectResult AccountDescribe = Account.sObjectType.getDescribe();
            String keyPrefix = AccountDescribe.getKeyPrefix();
            return new PageReference('/'+keyPrefix+'/o');
        }       
        if(accountId!= Null){
            return new PageReference('/lightning/r/Account/'+accountId+'/view');
        }
        else{
            Schema.DescribeSObjectResult caseDescribe = Case.sObjectType.getDescribe();
            String keyPrefix = caseDescribe.getKeyPrefix();
            return new PageReference('/'+keyPrefix+'/o');
        }
    }
    
    public Id insertMasterAndChild()
    {
         
        Case masterCase = new Case();
        boolean firstCounterSignCase  = false;
        system.debug('MasterCase Creation'+providerwrapperList );
        try
        {
            masterCase = newCase.clone(false);
            Id dataEntryId,MasterId, pFinId, contractId,credentialingId, countersignId,facilityId ;                 
            for(Recordtype newType:[Select Id, DeveloperName From RecordType where SobjectType  = 'Case' and ( DeveloperName='Data_Entry_Provider_On_boarding' or DeveloperName='Provider_On_boarding')])
            {
                if(newType.DeveloperName=='Provider_On_boarding')
                {
                    masterId = newType.Id;
                }               
                else
                {
                    dataEntryId=newType.Id;                 
                }
            } 
           for(RecordType pdRecordtype : [Select Id, DeveloperName From RecordType where SobjectType ='Provider_Networks__c'])
            {
                
                 if(pdRecordtype.DeveloperName=='PFIN_Onboarding')
                {
                    pFinId = pdRecordtype.Id;
                }
                else if (pdRecordtype.DeveloperName =='Contracting_Onboarding'){
                    contractId = pdRecordtype.Id;
                }
                 //PPN-30263 Sujatha
                 else if (pdRecordtype.DeveloperName =='Credentialing'){
                    credentialingId = pdRecordtype.Id;
                }
                else if (pdRecordtype.DeveloperName =='CounterSign'){
                    countersignId = pdRecordtype.Id;
                }
                else if (pdRecordtype.DeveloperName =='Facility'){
                    facilityId = pdRecordtype.Id;
                }
            }
            masterCase.recordTypeId = masterId;
            masterCase.status='In Progress';
            masterCase.origin='Manual On-boarding';            
            insert masterCase;
            system.debug('masterCase+++++++'+masterCase);
            system.debug('masterCase.Id++++++'+masterCase.Id);
            newCase.origin='Manual On-boarding';
            newCase.parentId = masterCase.Id;                        
            newCase.Network_Name_Copy__c = newCase.Network_Name_Copy__c;
            
            newCase.status='In Progress';             
            insert newCase; 
            system.debug('newCase+++++++'+newCase);
            Id groupCredentialRtype = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider Group On-boarding Credentialling').getRecordTypeId();
            system.debug('newCase.RecordtypeId++++++++++++'+newCase.RecordtypeId);
            system.debug('groupCredentialRtype ++++++++++++'+groupCredentialRtype );
            if(providerwrapperList .size()>0 && providerwrapperList[0].curCase.Prov_ID__c!= null)  
            {
                for(Integer i=0;i<providerwrapperList .size();i++)
                 {
                     String str ='';
                     Provider_Networks__c ProviderDetail = new Provider_Networks__c();
                     system.debug('providerwrapperList[i].curCase.Prov_ID__c value'+providerwrapperList[i].curCase.Prov_ID__c);
                     ProviderDetail.Prov_ID__c =providerwrapperList[i].curCase.Prov_ID__c;
                     ProviderDetail.PFIN_onBoarding__c=providerwrapperList[i].curCase.MC_PFIN__c;
                     providerDetail.Network_Load_Plan_Id__c = providerwrapperList[i].curCase.Plan_ID__c;
                     system.debug('providerwrapperList[i].curCase.Network_Name=====>>> '+providerwrapperList[i].curCase.Network_Name__c);
                     providerDetail.Network_Code_Name__c     = providerwrapperList[i].curCase.Network_Name_Copy__c;  
                     if(providerwrapperList[i].curCase.Network_Name_Copy__c!= NULL){                
                         for(String s : providerwrapperList[i].curCase.Network_Name_Copy__c.split(';')){
                             str = str != NULL ? str + '\r\n' + s: s;
                         }
                     }
                     providerDetail.Network_Code_Name_Detail__c =str;
                     providerDetail.Networks_Effective_Date__c= providerwrapperList[i].curCase.Network_Effective_Date__c;
                     providerDetail.Roles_Code__c    = providerwrapperList[i].curCase.Role_Code__c;
                     providerDetail.Panel_code__c = providerwrapperList[i].curCase.Panel_code__c;
                     providerDetail.Comp_Grid_Code__c = providerwrapperList[i].curCase.Comp_Grid_Code_new__c;
                     providerDetail.Designation_Code__c = providerwrapperList[i].curCase.Designation_Code__c;
                     providerDetail.cred_Status__c = providerwrapperList[i].curCase.cred_Status__c;  //Sujatha PPN-30261
                     if(selectedType == 'Provider On-boarding Data Entry' || selectedType == 'Provider Group On-boarding Data Entry')
                     {
                        ProviderDetail.RecordTypeId = pFinId;
                        ProviderDetail.PFIN_Case__c = newCase.Id;
                     }
                     //Sujatha PPN-30261
                     else if(selectedType == 'Provider On-boarding Contracting' || selectedType == 'Provider Group On-boarding Contracting' )
                     {
                        ProviderDetail.RecordTypeId = contractId;
                        providerDetail.Contracting_Case__c = newCase.Id;
                       //Sujatha PPN-30261 Starts   
                        if(selectedType == 'Provider Group On-boarding Contracting' && firstCounterSignCase == false && providerwrapperList[i].curCase.cred_Status__c != null){
                            providerDetail.countersignGroupManual__c = true;
                            firstCounterSignCase = true;
                            newCase.GroupCounterSignCreated__c = true;
                        }
                         //Sujatha PPN-30261 Ends
                     }
                    
                     //PPN-30263 Sujatha
                     else if(selectedType == 'Provider On-boarding Credentialing' || selectedType == 'Provider On-boarding Credentialing - Ancillary' || selectedType == 'Provider On-boarding Credentialing - Facility')
                     {
                     system.debug('credentialingId'+credentialingId);
                     system.debug('newCase.Id'+newCase.Id);

                        ProviderDetail.RecordTypeId = credentialingId;
                        providerDetail.Credentialing_Case__c = newCase.Id;
                     }
                     else if(selectedType == 'Provider On-boarding Counter Sign'  || selectedType == 'Provider Group On-boarding Counter sign')
                     {
                        ProviderDetail.RecordTypeId = countersignId;
                        providerDetail.CounterSign__c = newCase.Id;
                      
                        
                     }                     
                     ProviderDetailList.add(ProviderDetail);
                     
                 }
                 system.debug('ProviderDetail'+ProviderDetailList);
                 update newCase;
                 insert  ProviderDetailList ;
                 //update newCase;
             }
             return masterCase.Id; 
                  
        }
        catch(Exception exceptional)
        {
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,exceptional.getMessage()));
            system.debug('URL exp'+exceptional.getMessage() );
            system.debug('URL Line'+exceptional.getLineNumber());
            return NULL;
        }
    }
    
     
    public PageReference addRow()
      {     
          
          system.debug('Wrap Info' + providerwrapperList);
          String firstprovid;
          if(!providerwrapperList.isempty()){
          firstprovid = providerwrapperList[0].curCase.Prov_ID__c;
          }
          system.debug('**** selectedPlan ***' +selectedPlan);
          providerWrapper providerWrap = new providerWrapper();
          providerWrap.curCase = new Case();
          countOfProviderDetails++;
          providerWrap.counterWrap=countOfProviderDetails;
          if(!isFromGroup)
          //providerWrap.curCase.Prov_ID__c = provId ;
          if(provId != Null){
              providerWrap.curCase.Prov_ID__c = provId ;
          }
          else{
              providerWrap.curCase.Prov_ID__c = firstprovid;
          }
          providerWrap.curCase.Plan_ID__c = newCase.Plan_Id__c;
          providerWrap.curCase.Network_Name__c = NULL;
          providerWrap.curCase.Network_Name_Copy__c = NULL;                   
          //providerWrap.curCase =  newCase;
          providerwrapperList.add(providerWrap);
           system.debug('newCase'+newCase);
           if(countOfProviderDetails>1){
               isEditRow =True;
           }
            system.debug(countOfProviderDetails+'countOfProviderDetails'); 
          return null;    
      }
     
     public PageReference removingRow()
      {   
        Integer param = Integer.valueOf(Apexpages.currentpage().getParameters().get('index'));
        string recId = ApexPages.currentpage().getParameters().get('providerId');
        system.debug(providerwrapperList +'recId'); 
       // if(providerwrapperList.size() > 1)
        //{
            for(Integer i=0;i<providerwrapperList .size();i++)
            {
                    if(providerwrapperList [i].counterWrap == param ){
                    providerwrapperList.remove(i);     
                }

            }
            countOfProviderDetails--;
             system.debug(countOfProviderDetails+'countOfProviderDetails'); 
            
              for(Integer i=0;i<providerwrapperList .size();i++)
            {
                  providerwrapperList [i].counterWrap = i+1;    
                  providerwrapperList[i].curCase.Plan_ID__c=newCase.Plan_ID__c;        

            } 
       // }
        return null;    

    }
    
    public PageReference UpdateProvId()
    {
        system.debug(providerwrapperList.size() +'lst size');
        for(Integer i=0;i<providerwrapperList .size();i++)
        {
           if(i !=0){
            providerwrapperList[i].curCase.Prov_ID__c=providerwrapperList[0].curCase.Prov_ID__c;     
            }
        }
        return null;
    
    }
    
    public void populateProvider()
    {
        system.debug('calling provider '+ selectedPlan);
        Boolean isAccount = false;
        Account newAccount = new Account();
        List<CM_Provider_Identification__c>  listIdentification = new List<CM_Provider_Identification__c>();
        List<CM_Provider_Tax_Id__c> listProviderTax = new List<CM_Provider_Tax_Id__c>(); 
        if(newCase.AccountId !=NULL)
        { 
            system.debug('newCase.AccountId @@@'+newCase.AccountId );
            newAccount = [Select Id,firstName,lastName, Prov_ID__c  from Account Where Id=:newCase.AccountId];
            //PPN-PPN-38066 Starts ADDED AS PER 5.37 conversion with BA 
            listProviderTax = [Select CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Prov_Name_From__c =: newCase.AccountId Limit 1];
            listIdentification = [Select CM_Issu_Ident_Nmbr__c From CM_Provider_Identification__c Where CM_PI_Prov__c=:newCase.AccountId and CM_Prvdr_Iden_Typ_Cd__c='NPI' Limit 1];            
            if(!listIdentification.isempty()){
                newCase.Rendering_NPI__c = listIdentification[0].CM_Issu_Ident_Nmbr__c;
            }
            else{
                newCase.Rendering_NPI__c = '';
            }
            /*if(!listProviderTax.isempty()){
                newCase.Tax_ID_Number__c  = listProviderTax[0].CM_PTI_Tax_Id__c;
            }
            else{
                newCase.Tax_ID_Number__c  = '';
            }*/
            //PPN-PPN-38066 Ends
                       
            newCase.Name_of_Provider_Group__c=newAccount.lastName+','+newAccount.firstName; 
            provId =newAccount.Prov_ID__c;          
            isAccount = true;
           
           if(selectedType == 'Provider On-boarding Data Entry' || selectedType == 'Provider On-boarding Contracting'|| selectedType == 'Provider On-boarding Credentialing' || selectedType == 'Provider On-boarding Counter Sign')
           {
                for(Integer i=0;i<providerwrapperList .size();i++)
                {           
                     providerwrapperList[i].curCase.Prov_ID__c=provId;             
                }  
           }   
        }
        else if(newCase.Case_Entity__c !=NULL)
        {
            newAccount = [Select Id, Name, Prov_ID__c  from Account Where Id=:newCase.Case_Entity__c];
            newCase.Name_of_Provider_Group__c=newAccount.Name;
            provId =newAccount.Prov_ID__c;                     
            isAccount = true;
           /* for(Integer i=0;i<providerwrapperList .size();i++)
            {           
                 providerwrapperList[i].curCase.Prov_ID__c=provId;
            }*/
            system.debug('isAccount+++'+isAccount);
            if(isAccount)
            {
                List<CM_Provider_Identification__c> listOfIdentification= [Select CM_Issu_Ident_Nmbr__c From CM_Provider_Identification__c Where CM_PI_Prov__c=:newAccount.Id and CM_Prvdr_Iden_Typ_Cd__c='NPI' Limit 1];            
                if(!listOfIdentification.isEmpty())
                {
                    newCase.Billing_NPI_Number__c=listOfIdentification[0].CM_Issu_Ident_Nmbr__c;
                }
                else{
                    newCase.Billing_NPI_Number__c = '';
                
                }
                system.debug('newCase.Billing_NPI_Number__c++'+newCase.Billing_NPI_Number__c);
            }
            if(isAccount)
            {
                List<CM_Provider_Tax_Id__c> listOfProviderTax = [Select CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Prov_Name_From__c =: newAccount.Id Limit 1];
                if(!listOfProviderTax.isEmpty())
                {
                   newCase.Tax_ID_Number__c = listOfProviderTax[0].CM_PTI_Tax_Id__c ;
                   system.debug('listOfProviderTax[0].CM_PTI_Tax_Id__c++++'+listOfProviderTax[0].CM_PTI_Tax_Id__c);
                }
                else{
                    newCase.Tax_ID_Number__c = '';
                
                }
            }
        }
        
        if(selectedType == 'Provider On-boarding Credentialing - Ancillary' || selectedType == 'Provider On-boarding Credentialing - Facility')
        {
            Set<String> setOfNPI = new Set<String>();   
            Set<String> setOfTAX = new Set<String>();
            string strNPI ='';
            string strTax ='';
            
            List<CM_Provider_Identification__c> listOfIdentification= [Select CM_Issu_Ident_Nmbr__c From CM_Provider_Identification__c Where CM_PI_Prov__c=:newAccount.Id and CM_Prvdr_Iden_Typ_Cd__c='NPI'and CM_PI_License_Status__c = 'Active'];            
            System.Debug('&&&listOfIdentification'+listOfIdentification); 
            if(listOfIdentification.size() >0 )
            {
                for(Integer i=0;i<listOfIdentification.size();i++){
                    if(listOfIdentification[i].CM_Issu_Ident_Nmbr__c != NULL  )
                    {
                        setOfNPI.add(listOfIdentification[i].CM_Issu_Ident_Nmbr__c);
                    }
                }
                System.Debug('&&&setOfNPI'+setOfNPI);
                for(String s : setOfNPI){
                    strNPI = strNPI+ s +  '\r\n';
                }
                System.Debug('&&&1strNPI'+strNPI);
                newCase.Billing_NPI_Number_long__c = strNPI;
                
            }
            else{
                newCase.Billing_NPI_Number_long__c = '';
        
            }        
            
            List<CM_Provider_Tax_Id__c> listOfProviderTax = [Select CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Prov_Name_From__c =: newAccount.Id and (CM_PTI_Prov_Id_End_Date__c = Null  OR CM_PTI_Prov_Id_End_Date__c > TODAY)];
            System.Debug('&&&listOfProviderTax'+listOfProviderTax); 
            if(listOfProviderTax.size() >0 )
            {
                for(Integer i=0;i<listOfProviderTax.size();i++){
                    if(listOfProviderTax[i].CM_PTI_Tax_Id__c != NULL  )
                    {
                        setOfTAX.add(listOfProviderTax[i].CM_PTI_Tax_Id__c);
                    }
                }
                System.Debug('&&&setOfTAX'+setOfTAX);
                for(String s : setOfTAX){
                    strTax = strTax + s +  '\r\n';
                }
                System.Debug('&&&2strTax'+strTax);
                newCase.Tax_ID_Number_long__c = strTax;
            }
            else{
                newCase.Tax_ID_Number_long__c = '';
            }
        
        
        }        
        
        system.debug('***** newCase.Plan_ID__c ***' + accPlanId );
        newCase.Plan_ID__c = accplanId; 
        
         for(Integer i=0;i<providerwrapperList.size();i++)
        {
            providerwrapperList [i].curCase.Plan_ID__c= accplanId;

        }
        
    }
    
    public class Providerwrapper{

        public Integer counterWrap{get;set;} 
        public Case curCase {get;set;}  

    }
    
      public Boolean ValidateProvIdInGroupContract()
      {
            Id physicianId,entityId;          
            Boolean isAvailable = true;
            Boolean error = false;            
            Set<String> setOfProvId = new Set<String>();
            Set<String> setOfProvIdFromAccount = new Set<String>();
            system.debug('Coming inside before update');           
          
            
            if(!providerwrapperList.isEmpty() && (selectedType == 'Provider Group On-boarding Contracting' || selectedType == 'Provider Group On-boarding Counter sign'))
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
                
                
             if(providerwrapperList.size() >0  )
                {
                    for(Integer i=0;i<providerwrapperList .size();i++)
                    {
                        if(providerwrapperList[i].curCase.Prov_ID__c != NULL  )
                        {
                            setOfProvId.add(providerwrapperList[i].curCase.Prov_ID__c);
                        }
                    }
                }
               
                for(Account accountToVerify : [Select Id, Name, Prov_Id__c From Account where (RecordTypeId =: entityId OR RecordTypeId =: physicianId) and  Prov_Id__c  IN : setOfProvId ])
                {
                         system.debug('accountToVerify'+ accountToVerify.Prov_Id__c);                  
                         isAvailable = true;
                         setOfProvIdFromAccount.add(accountToVerify.Prov_Id__c);                     
                }
               
                if(setOfProvIdFromAccount.ContainsAll(setOfProvId ) == false)
                {
                    isAvailable = false; 
                }                
              
               if(provcheck != true && !isAvailable)
               {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Prov ID'));
                    error = true;
                                            
               } 
            }        
            return error; 

           
    }
    
    
    Public Boolean ValidateDuplicateCredentialingCase()
     {
        Set<String> setOfProvId = new Set<String>();
        Set<String> setOfAccount = new Set<String>();
        Id physicianId; 
        Id IndvCredRecordTypeId;
        Id groupCredRecordTypeId;
        Id ManualgroupCredRecordTypeId;
        Id grpContractRecordTypeId;
        Boolean error;
        Boolean isNPIAvailable = false;
        Map<Id, String> mapofAccountAndDOB = new Map<Id, String>();//PPN - 39252
        Set<String> setOfProviderWithoutNPI = new Set<String>(); //PPN - 40160
        
        if(selectedType == 'Provider On-boarding Credentialing' || selectedType == 'Provider Group On-boarding Credentialing' || selectedType =='Provider Group On-boarding Contracting')
        {    
                IndvCredRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
                groupCredRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
                ManualgroupCredRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Manual_Group_On_boarding_Credentialling').getRecordTypeId();
                grpContractRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeID();
            
             if(providerwrapperList.size() >0 && (selectedType == 'Provider On-boarding Credentialing' || selectedType == 'Provider Group On-boarding Credentialing') )
             {
                 for(Integer i=0;i<providerwrapperList .size();i++)
                 {
                      if(providerwrapperList[i].curCase.Prov_ID__c != NULL)
                      {
                        setOfProvId.add(providerwrapperList[i].curCase.Prov_ID__c);
                      }
                 }
             }
             if(providerwrapperList.size() >0 && selectedType == 'Provider Group On-boarding Contracting' )
             {
                 for(Integer i=0;i<providerwrapperList .size();i++)
                 {
                      if(providerwrapperList[i].curCase.Prov_ID__c != NULL && providerwrapperList[i].curCase.cred_Status__c == 'Needs Credentialing' )
                      {
                        setOfProvId.add(providerwrapperList[i].curCase.Prov_ID__c);
                      }
                 }
             }
             system.debug('setOfProvId'+ setOfProvId);
            /*for(RecordType newType:[Select Id,Name From RecordType Where sObjectType='Account' and (Name='Physician')])
            {
                if(newType.Name=='Physician')
                {
                    physicianId=newType.Id;
                }
                
            }*/
            physicianId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();
            if(!setOfProvId.iSEmpty())
            {
                for(Account accountToVerify : [Select Id, Name, Prov_Id__c, Date_of_Birth__c From Account where  RecordTypeId =: physicianId and  Prov_Id__c  IN : setOfProvId ])
                {
                    if(accountToVerify.Id != NULL)    {
                        setOfAccount.add(accountToVerify.Id);
                        mapofAccountAndDOB.put(accountToVerify.Id, String.valueOf(accountToVerify.Date_of_Birth__c));
                    }
                }
            }
            if(!mapofAccountAndDOB.iSEmpty())
            {
                
                for(String key : mapofAccountAndDOB.keySet())
                {
                   
                    if(mapofAccountAndDOB.get(key) == null || mapofAccountAndDOB.get(key) == '')
                    {
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'DOB missing for Account. Please update the DOB for provider to create the credentialing case'));
                          error = true; 
                    }
                   
                     System.debug('Key - '+key+'Value '+mapofAccountAndDOB.get(key));
                    system.debug('Key'+mapofAccountAndDOB.get(key));
                                       
                }
            }
             system.debug('setOfAccount'+ setOfAccount);
            if(!setOfAccount.isEmpty())
            {
              
                for(CM_Provider_Identification__c actNPI : [select Id,  CM_Prvdr_Iden_Typ_Cd__c, CM_Issu_Ident_Nmbr__c, CM_PI_Prov__c, CM_PI_Prov__r.Prov_ID__c From CM_Provider_Identification__c where CM_PI_Prov__c IN : setOfAccount AND (CM_Prvdr_Iden_Typ_Cd__c =: 'License' OR  CM_Prvdr_Iden_Typ_Cd__c =: 'NPI') AND (CM_Issu_Ident_Nmbr__c != '' OR CM_Issu_Ident_Nmbr__c != NULL)])
                {
                     system.debug('CM_Prvdr_Iden_Typ_Cd__c '+ actNPI.CM_Prvdr_Iden_Typ_Cd__c );
                     system.debug('actNPI.CM_Issu_Ident_Nmbr__c'+actNPI.CM_Issu_Ident_Nmbr__c);
                     setOfProviderWithoutNPI.add(actNPI.CM_PI_Prov__r.Prov_ID__c);
                  
                }
                
                if((setOfProviderWithoutNPI.isEmpty()) || (setOfProviderWithoutNPI.size() != setOfProvId.size()))
                {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'NPI/License # missing for account. Please update at least one of the following NPI/License # for provider to create the credentialing case'));
                          error = true; 
                }
            }
            
            for(Case credCase : [SELECT ID, ACCOUNTID,  Account.Prov_ID__c , STATUS, ISCLOSED  FROM CASE WHERE ACCOUNTID IN : setOfAccount AND (ISCLOSED = FALSE OR (STATUS IN('Admin Denial' , 'Application Returned') AND     Check_for_90_days__c = FALSE) )  AND (RecordTypeId = : IndvCredRecordTypeId OR RecordTypeId = : groupCredRecordTypeId OR RecordTypeId = : ManualgroupCredRecordTypeId) ])
            {
            system.debug('Inside credCase-------');
                if(credCase.AccountId != NULL)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Duplicate credentialing case in existence for the entered Prov ID '  ));
                        error = true; 
                }
                
            }
        }
        return error;
    
    }
    
     /*
     * Author : Subhashini R
     * Date   : 06/03/2019
     * US     : PPN - 41650
     * Business purpose : SF-Credentialing Integration - On boarding Facility/Ancillary - NPI and License number validations  
     */
    public Boolean validateNPILicenseInFacilityAndAncillary(){
    
        Set<String> setOfProvId = new Set<String>();
        Set<String> setOfAccount = new Set<String>();
        Id entityId;
        Boolean error; 
        Set<String> setOfProviderWithoutLicense = new Set<String>();
        Set<String> setOfProviderWithoutNPI = new Set<String>();
        
        if(selectedType == ('Provider On-boarding Credentialing - Facility') || selectedType == ('Provider On-boarding Credentialing - Ancillary')){
            
             if(providerwrapperList.size() >0 ) {
                 for(Integer i=0;i<providerwrapperList .size();i++) 
                 {
                      if(providerwrapperList[i].curCase.Prov_ID__c != NULL) {
                          setOfProvId.add(providerwrapperList[i].curCase.Prov_ID__c);
                      }
                 }
             }
             entityId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Entity_Account').getRecordTypeId();
         }
        if(!setOfProvId.iSEmpty()) {
            for(Account accountToVerify : [Select Id, Name, Prov_Id__c From Account where  RecordTypeId =: entityId and  Prov_Id__c  IN : setOfProvId ])
            {
                if(accountToVerify.Id != NULL)    {
                    setOfAccount.add(accountToVerify.Id);                       
                }
            }
        }
            
        if(!setOfAccount.isEmpty())  {
            if(selectedType ==  ('Provider On-boarding Credentialing - Ancillary')){
            
                for(CM_Provider_Identification__c actNPI : [select Id,  CM_Prvdr_Iden_Typ_Cd__c, CM_Issu_Ident_Nmbr__c, CM_PI_Prov__c, CM_PI_Prov__r.Prov_ID__c From CM_Provider_Identification__c where CM_PI_Prov__c IN : setOfAccount AND (CM_Prvdr_Iden_Typ_Cd__c =: 'NPI') AND (CM_Issu_Ident_Nmbr__c != '' OR CM_Issu_Ident_Nmbr__c != NULL)])
                {
                     system.debug('CM_Prvdr_Iden_Typ_Cd__c '+ actNPI.CM_Prvdr_Iden_Typ_Cd__c );
                     system.debug('actNPI.CM_Issu_Ident_Nmbr__c'+actNPI.CM_Issu_Ident_Nmbr__c);
                     setOfProviderWithoutLicense.add(actNPI.CM_PI_Prov__r.Prov_ID__c);                      
                }
                
                if((setOfProviderWithoutLicense.isEmpty()) || (setOfProviderWithoutLicense.size() != setOfProvId.size()))  {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'NPI# missing for account. Please update NPI# for Ancillary provider to create the credentialing case'));
                          error = true; 
                }
                
            }
           
            if(selectedType ==  ('Provider On-boarding Credentialing - Facility')){
            
                for(CM_Provider_Identification__c actNPI : [select Id,  CM_Prvdr_Iden_Typ_Cd__c, CM_Issu_Ident_Nmbr__c, CM_PI_Prov__c, CM_PI_Prov__r.Prov_ID__c From CM_Provider_Identification__c where CM_PI_Prov__c IN : setOfAccount AND (CM_Prvdr_Iden_Typ_Cd__c =: 'License' OR  CM_Prvdr_Iden_Typ_Cd__c =: 'NPI') AND (CM_Issu_Ident_Nmbr__c != '' OR CM_Issu_Ident_Nmbr__c != NULL)])
                {
                     system.debug('CM_Prvdr_Iden_Typ_Cd__c '+ actNPI.CM_Prvdr_Iden_Typ_Cd__c );
                     system.debug('actNPI.CM_Issu_Ident_Nmbr__c'+actNPI.CM_Issu_Ident_Nmbr__c);
                     if(actNPI.CM_Prvdr_Iden_Typ_Cd__c == 'License'){
                         setOfProviderWithoutLicense.add(actNPI.CM_PI_Prov__r.Prov_ID__c); 
                     } 
                      if(actNPI.CM_Prvdr_Iden_Typ_Cd__c == 'NPI'){
                         setOfProviderWithoutNPI.add(actNPI.CM_PI_Prov__r.Prov_ID__c); 
                     }                
                }
                
                if(setOfProviderWithoutLicense.isEmpty() || setOfProviderWithoutNPI.isEmpty() || (setOfProviderWithoutLicense.size() != setOfProvId.size() && setOfProviderWithoutNPI.size() != setOfProvId.size()))  {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' NPI/License # missing for account. Please update for provider to create the credentialing case'));
                          error = true; 
                }
                
            }
        }
                
        return error;
    }
    
    
     Public Boolean  DuplicateCredentialingCaseCheck(){
        Set<String> setOfProvId = new Set<String>();
        Set<String> setOfAccount = new Set<String>();
        Id entityId;
        Boolean error;         
        Id AncillaryRecordTypeId ;
        Id FacilityRecordTypeId ;
        system.debug('Inside credCase-------');
        AncillaryRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing_Ancillary').getRecordTypeId();
        FacilityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing_Facility').getRecordTypeId();
        
        if(selectedType == ('Provider On-boarding Credentialing - Facility') || selectedType == ('Provider On-boarding Credentialing - Ancillary')){
            
             if(providerwrapperList.size() >0 ) {
                 for(Integer i=0;i<providerwrapperList .size();i++) 
                 {
                      if(providerwrapperList[i].curCase.Prov_ID__c != NULL) {
                          setOfProvId.add(providerwrapperList[i].curCase.Prov_ID__c);
                      }
                 }
             }
             entityId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Entity_Account').getRecordTypeId();
         }
        if(!setOfProvId.iSEmpty()) {
            for(Account accountToVerify : [Select Id, Name, Prov_Id__c From Account where  RecordTypeId =: entityId and  Prov_Id__c  IN : setOfProvId ])
            {
                if(accountToVerify.Id != NULL)    {
                    setOfAccount.add(accountToVerify.Id);                       
                }
            }
        }
        system.debug('setOfAccount-------'+setOfAccount);
        if(!setOfAccount.isEmpty())
        {
            system.debug('Inside credCase124-------');
             for(Case credCase : [SELECT ID, ACCOUNTID,Case_Entity__c , Account.Prov_ID__c , Account.Date_of_Birth__c, STATUS, ISCLOSED  FROM CASE WHERE Case_Entity__c IN : setOfAccount AND (ISCLOSED = FALSE  OR
              (STATUS IN('Admin Denial' ,'Application Returned') AND   Check_for_90_days__c = FALSE))  AND (RecordTypeId = : AncillaryRecordTypeId OR RecordTypeId = : FacilityRecordTypeId )])
             {
            system.debug('credCase'+credCase);
                if(credCase.Case_Entity__c != NULL)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Duplicate credentialing case in existence for the Provider '  ));
                    error = true; 
                }
                
            }
        }
        return error;
        
        
    }
    
   

}