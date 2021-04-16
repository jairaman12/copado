/***************************************************************************
Name : ProviderCaseManagement
Created By : INtake Dev team
Description : Custom REST API to handle Provider Cases
*-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth K            11/07/2018                 PPN-23441      
* Sreekanth K            06/04/2019                 PPN-41745
***************************************************************************/
@RestResource(urlMapping='/ProviderCaseManagement/*')
global class ProviderCaseManagement 
{
    @HttpPost
    global static ResponseHandler doPost() 
    {                
        RestRequest req                         =   RestContext.request;
        RestResponse res                        =   RestContext.response;  
        Id physicianAcctId                      =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();
        Case intCase                            =   (Case)JSON.deserialize(req.requestBody.toString(),Case.class);
        ResponseHandler response                =   new ResponseHandler();
        intCase.Original_Creation_Date__c       =   datetime.now();
        intCase.Plan_Id_Validation_By_Pass__c   =   True;
        Set<String> pediRTNames                 =   new Set<String>{ 'Data_Entry_Provider_On_boarding'}; 
        String taxIDNumber                      =   intCase.Tax_ID_Number__c; //PPN_22954
        String billNPINum                       =   intCase.Billing_NPI_Number__c; //PPN_22954
      
        //Validation variables
        boolean pediValidated                   =   true;
        boolean validated                       =   true;
        Boolean isContractingCase               =   false; // PPN-41745
        Set<String> completingFormPLValues      =   new Set<String>(Utils.getPicklistValues('Case','Completing_the_form_for__c')); 
        Set<String> npiTypePLValues             =   new Set<String>(Utils.getPicklistValues('Case','Bill_NPI_Type__c')); 
        Set<String> nplanIDPLValues             =   new Set<String>(Utils.getPicklistValues('Case','Plan_ID__c')); 
        Set<String> originValues                =   new Set<String>(Utils.getPicklistValues('Case','Origin')); 
       
        //Common Validation    
    
        if (!nplanIDPLValues.contains(intCase.Plan_ID__c) )
        {  
                response.ErrorCode              =   'IntakeError-002';
                response.Status                 =   'Failed';
                response.Message                =   'The Plan ID value should be IL1 or TX1 or MT1 or OK1 or NM1 for Case Creation'; 
                validated                       =   false;
                return response; 
         }  
       
         if (((intCase.Completing_the_form_for__c!=null)&&(!completingFormPLValues.contains(intCase.Completing_the_form_for__c)))
             ||((intCase.Bill_NPI_Type__c!=null)&&(!npiTypePLValues.contains(intCase.Bill_NPI_Type__c)))
             ||((intCase.origin!=null)&&(!originValues.contains(intCase.origin)))
            ){
                response.ErrorCode              =   'IntakeError-003';
                response.Status                 =   'Failed';
                response.Message                =   'Check the  values for origin,Completing the form,Billing NPI Type'; 
                validated                       =   false;
                return response; 
            } 
        //assigning values for PEDI
        if (intCase.origin=='Web On-boarding')
        {  
            intCase.RecordTypeId                    =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding').getRecordTypeId(); 
        }
    /*PPN_22954 starts*/
    
        List<CM_Provider_Tax_Id__c> accTaxId        = [select id,CM_PTI_Prov_Name_From__r.CM_Corporate_Entity_Code__c,CM_PTI_Prov_Name_From__r.IsPersonAccount,
                                                       CM_PTI_Prov_Name_From__c,CM_PTI_Prov_Name_To__c,CM_PTI_Tax_Id__c,CM_PTI_Tax_Shared_Ind__c from 
                                                       CM_Provider_Tax_Id__c where CM_PTI_Tax_Id__c=:taxIDNumber and 
                                                       CM_PTI_Prov_Name_From__r.recordtypeId=:physicianAcctId 
                                                      ];
        
        List<CM_Provider_Identification__c> accNPI  = [select id,CM_PI_Prov__r.CM_Corporate_Entity_Code__c,CM_PI_Prov__r.IsPersonAccount,CM_PI_Prov__c,
                                                       CM_Issu_Ident_Nmbr__c,CM_Prvdr_Iden_Typ_Cd__c from CM_Provider_Identification__c where 
                                                       CM_Issu_Ident_Nmbr__c=:billNPINum and CM_PI_Prov__r.IsPersonAccount=true and 
                                                       CM_PI_Prov__r.RecordTypeId=:physicianAcctId
                                                      ];
            List<Id> listOfAccountIdIds                         = new List<Id>();
            Map<Id,List<String>> mapOfAccountIdIdAndItsNPI      = new Map<Id,List<String>>();
            Map<Id,List<String>> mapOfAccountIdIdAndItsTaxId    = new Map<Id,List<String>>();
            Map<Id,String> mapOfAccountIdAndItsType             = new Map<Id,String>();
        
            for( CM_Provider_Tax_Id__c newTaxId : accTaxId )
            {
                List<String> listOfTaxIds           = new List<String>();
                if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL && mapOfAccountIdIdAndItsTaxId.containsKey( newTaxId.CM_PTI_Prov_Name_From__c ))
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
           // for(CM_Provider_Identification__c newIdentification:[Select CM_Issu_Ident_Nmbr__c,CM_PI_Prov__c,CM_Prvdr_Iden_Typ_Cd__c From CM_Provider_Identification__c Where CM_PI_Prov__c In:listOfAccountIdIds and CM_Prvdr_Iden_Typ_Cd__c ='NPI' ])
            for(CM_Provider_Identification__c newIdentification : accNPI  )
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
        system.debug('mapOfKeyAndItsId'+mapOfKeyAndItsId);
        system.debug('accTaxId1'+accTaxId);
        system.debug('accNPI1'+accNPI);
       
        if (accTaxId.size()>=1 
            && accNPI.size()>=1 
            && accTaxId[0].CM_PTI_Prov_Name_From__r.IsPersonAccount
           ){
            system.debug('accTaxId[0].CM_PTI_Prov_Name_From__c'+ accTaxId[0].CM_PTI_Prov_Name_From__c);
            system.debug('accNPI[0].CM_PI_Prov__c'+ accNPI[0].CM_PI_Prov__c);                     
             for(integer i = 0 ; i<accTaxId.size() ; i++)
             {            
                 for( integer j = 0 ; j<accNPI.size() ; j++)
                 {
                     if(accTaxId[i].CM_PTI_Prov_Name_From__c == accNPI[j].CM_PI_Prov__c)
                     {    
                         isContractingCase      =   true;
                         intCase.AccountId      =   accNPI[j].CM_PI_Prov__c;
                     }
                 }
             }
        }
    /*PPN_22954 Ends*/
        if(validated)
        {
            Id masterCaseId;
            /*
            * Jira #     : PPN-41745
            * Description: Below code added added to secure the error messages and to
            *              insert the master Case.
            */
            List<Case> casesForInsertList       =   new List<Case>();
             Database.SaveResult[] resultList;
            casesForInsertList.add( intCase );
            try{
                  resultList =   Database.insert( casesForInsertList , false );
            }catch(Exception e){
                System.debug('error message'+e.getMessage());
            }
            
            for( Database.SaveResult saveRel : resultList )
            {
                    if (!saveRel.isSuccess())
                    {
                        for( Database.Error err : saveRel.getErrors() ) 
                        { 
                            //Custom error when the intCase insertion fails
                            response.ErrorCode          =   'IntakeError-DML';
                            response.Status             =   'Failed';
                            response.Message            =   err.getMessage();
                            
                            Error_Message__c errorMsg   =    new Error_Message__c();
                            errorMsg.Class_Name__c      =    'ProviderCaseManagement.cls';
                            errorMsg.Error_Cause__c     	=   	'An Error has been occured while creating the Pedi Web onboarding parent case and the error code '+err.getStatusCode()+'.'+err.getFields();
                            errorMsg.Exception_Message__c   = 		err.getMessage(); 
                            errorMsg.PEDI_Application_Id__c	=		intCase.Application_Id__c;
                            errorMsg.Running_user__c	=   UserInfo.getName();
                            Insert errorMsg; 
                        }
                    }else{
                      masterCaseId      =   saverel.getId();  
                    }
            }
            if(resultList[0].isSuccess())
            {
                    Case insertedintCase = [Select Id,CaseNumber from Case Where Id =:masterCaseId]; 
                    if(pediValidated && (intCase.origin=='Web On-boarding'))
                    {
                        List<Case> childintCasesList            =   new List<Case>();
                        for(String recType : pediRTNames)
                        {
                            Case childintCases                          =   new Case();
                            childintCases.Plan_ID__c                    =   intCase.Plan_ID__c;
                            childintCases.Plan_Id_Validation_By_Pass__c =   True; 
                            /**
                             * Jira # : PPN-41745 
                             * Description: Assigning the child case record type based on the
                             *              field Completing_the_form_fo__c 
                             **/
                            if( isContractingCase && intCase.Completing_the_form_for__c == 'Individual'  )
                            {
                                childintCases.RecordTypeId              =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
                            }else if ( isContractingCase && intCase.Completing_the_form_for__c == 'Group'  )
                            {
                                childintCases.RecordTypeId              =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeId();
                            }else if(!isContractingCase && intCase.Completing_the_form_for__c == 'Individual'  )
                            {
                                childintCases.RecordTypeId              =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId();
                            }else if(!isContractingCase && intCase.Completing_the_form_for__c == 'Group' )
                            {
                                childintCases.RecordTypeId              =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Group_Provider_On_boarding').getRecordTypeId();
                            }
                            
                            childintCases.ParentId                      =   intCase.Id;
                            childintCases.Origin                        =   intCase.Origin;
                            childintCases.Completing_the_form_for__c    =   intCase.Completing_the_form_for__c;
                            childintCases.Name_Submitter__c             =   intCase.Name_Submitter__c;
                            childintCases.Telephone_Number_Submitter__c =   String.valueOf(intCase.Telephone_Number_Submitter__c);
                            childintCases.Email_Address_Submitter__c    =   intCase.Email_Address_Submitter__c;
                            childintCases.Name_of_Provider_Group__c     =   intCase.Name_of_Provider_Group__c;
                            childintCases.Tax_ID_Number__c              =   intCase.Tax_ID_Number__c;
                            childintCases.Rendering_NPI__c              =   intCase.Rendering_NPI__c;
                            childintCases.Billing_NPI_Number__c         =   intCase.Billing_NPI_Number__c;
                            childintCases.Title_Submitter__c            =   intCase.Title_Submitter__c;
                            childintCases.Bill_NPI_Type__c              =   intCase.Bill_NPI_Type__c;
                            childintCases.Priority                      =   intCase.Priority;
                            childintCases.Subject                       =   intCase.Subject;
                            childintCases.Description                   =   intCase.Description;
                            childintCases.Original_Creation_Date__c     =   datetime.now();
                             childintCases.Application_Review_URL__c    =   intCase.Application_Review_URL__c;
                            childintCases.Govt_Programs__c              =   intCase.Govt_Programs__c;
                            childintCases.Application_Id__c             =   intCase.Application_Id__c;
                            childintCases.Attachment_Indicator__c       =   intCase.Attachment_Indicator__c;
                            childintCases.Attachment_Review_URL__c      =   intCase.Attachment_Review_URL__c;
                            childintCases.Do_Not_Add_List__c            =   intCase.Do_Not_Add_List__c;
                            childintCases.Out_of_Network__c             =   intCase.Out_of_Network__c;
                           if (accTaxId.size()>=1 && accNPI.size()>=1 && accTaxId[0].CM_PTI_Prov_Name_From__r.IsPersonAccount)
                            {
                                system.debug('accTaxId[0].CM_PTI_Prov_Name_From__c'+ accTaxId[0].CM_PTI_Prov_Name_From__c);
                                system.debug('accNPI[0].CM_PI_Prov__c'+ accNPI[0].CM_PI_Prov__c);                     
                                for(integer i =0 ; i<accTaxId.size() ; i++)
                                {            
                                    for( integer j =0 ; j<accNPI.size() ; j++)
                                        {
                                        if(accTaxId[i].CM_PTI_Prov_Name_From__c == accNPI[j].CM_PI_Prov__c)
                                        {
                                            if(intCase.Completing_the_form_for__c == 'Individual')
                                            {
                                                pediRTNames =   new Set<String>{ 'Contracting_Provider_On_boarding'};                         
                                            }                          
                                            intCase.AccountId    =   accNPI[j].CM_PI_Prov__c;
                                            childintCases.AccountId =  accNPI[j].CM_PI_Prov__c;
                                        }
                                    }
                                }
                            }
                           
                            childintCasesList.add( childintCases );
                        }
                        
                        Database.SaveResult[] childResultList;
                        
                        if(!childintCasesList.isEmpty())
                        {
                            try{
                                childResultList   =   Database.insert( childintCasesList ,false);
                            }catch(Exception e){
                                system.debug('Error Message in child creation===>>>>'+e.getMessage());
                            }
                          
                        }
                        
                        for( Database.SaveResult saveRel : childResultList )
                        {
                                if (!saveRel.isSuccess())
                                {
                                    for( Database.Error err : saveRel.getErrors() ) 
                                    { 
                                        //Custom error when the intCase insertion fails
                                        response.ErrorCode          =   'IntakeError-DML';
                                        response.Status             =   'Failed';
                                        response.Message            =   err.getMessage();
                                        
                                        Error_Message__c errorMsg   =    new Error_Message__c();
                                        errorMsg.Class_Name__c      =    'ProviderCaseManagement.cls';
                                        errorMsg.Error_Cause__c     =   'An Error has been occured while creating the PEDI Web onboarding Child case and the error code '+err.getStatusCode()+'.'+err.getFields();
                                        errorMsg.Exception_Message__c   = err.getMessage(); 
                                        errorMsg.PEDI_Application_Id__c	= intCase.Application_Id__c;	
                                        errorMsg.Running_user__c	=   UserInfo.getName();
                                        Insert errorMsg; 
                                    }
                                }else{
                                    List<sObject> thesObjectList        =   new List<sObject>();
                                    thesObjectList.add((sObject)insertedintCase);
                                    response.Data                   =   thesObjectList;
                                    response.Status                 =   'Success';
                                    response.ErrorCode              =   null;
                                    response.Message                =   null;
                                }
                        }
                    }
                return response; 
            }
        }
       return response; 
  }  
}