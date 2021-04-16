/**************************************************************************************************
Apex Class Name  : CaseTriggerHandler
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru         09/20/2018              PPN-25402 (Sprint 19)   
* Travis Self               09/21/2018              PPN-23115 (Sprint 19)
* Travis Self               11/09/2018              PPN-27413 (Sprint 23)
* U393129                   11/18/2019              Used to capture the Histrory CommentHistoryTracking PPN-27103
* Laxman Vattam             01/28/2019              PPN-30575 - Update Network Load case Account based on Prov id
* Travis Self               01/31/2019              PPN-30572
* * Ashok N                 01/18/2019              PPN-30357 
* Ashok N                   2/28/2019               PPN-34061
* Travis                    4/2/2019                Ignore Closed Case validation for Integration User
* Travis                    5/13/2019               PPN-39400
* Sethu                     5/29/2019               PPN-36046 & PPN-41941
* Sethu                     6/11/2019               PPN-39574, PPN-40399, PPN-40401
*Ashok                      6/11/2019               PPN-40802
***************************************************************************************************/
public class CaseTriggerHandler implements ITrigger 
{
   
    public static Map<Id,String> roleIdWithPlanMap      =   new Map<Id,String>();
    public static Set<Id> processedRecords              =   new Set<Id>();
    public static Set<String>  CASE_ORIGIN              =   new Set<String>{'Web-Demographics','Web-Demographic','Phone','Email','Voicemail','Mail','In Person','Fax'};
    public static Set<String>  PARENT_CASE_STATUS       =   new Set<String>{'Closed Processed','Closed Rejected','Cancelled','Pending','Closed','Closed Complete','Closed No-Action Needed','Closed Invalid'}; //PPN-18038
    public static String CASE_ORIGIN_PEDI               =   'Web On-boarding';
    public static String CASE_ORIGIN_MANUAL_ONBOARDING  =   'Manual On-boarding';
    public static String CASE_ORIGIN_W2C                =   'Web-Demographics';
    public static Set<String> CURRENT_USER              =    new Set<String>{'System Administrator', 'Integration'};
    public static String PNC_User                       =   'PNC Profile';
    public static List<Profile> currProfile             =   new List<Profile>();
    Public static List<RecordType> recordTypeList       =   new List<RecordType>();     Public static Set<Id> recordTypeSet                 =   new Set<Id>();  //PPN-16284 
    public static Set<String> supervisorProfiles        =   new Set<String>{ 'Supervisor','Montana Supervisor','PNC Profile'};
    public Set<String> dataRepProfile                   =   new Set<String>{ 'Provider Data Rep'};
    public static Map<String,Set<Id>> planIdWithQueues  =   new Map<String,Set<Id>>();
    public static Map<String,Id> DataRep_planIdWithQueues  =   new Map<String,Id>(); //PPN-17747
    public static Map<String,RoleAndPlanId_Settings__c> roleMap       = new Map<String,RoleAndPlanId_Settings__c>();
    public static Map<Id,String> queueIdWithPlan        =   new Map<Id,String>();
    public static Id EnterpriseProfileId;
    
     public static Map<id,RecordType_settings__c> recTypeMapbyId                    =   new Map<Id,RecordType_settings__c>();
     public static Map<String,RecordType_settings__c> recTypeMapbyDeveloperName     =   new Map<String,RecordType_settings__c>();
    //public static Set<Id> processedCaseRecords = new Set<Id>();   
    
    Public static list<Case> caseList;   
    Public static list<OMNICriteriaTable> criteria = new list<OMNICriteriaTable>();
    
   // PPN-22549
    public List<String> recTypeNames            =   new List<String>();
    public  Map<Id,String> recTypeMap           =   new Map<Id,String>();
    public static List<Group> g =new List<group>();
    public static List<OMNI_Queue__c> q = new List<OMNI_Queue__c>();
    public static List<OMNI_User_Group__c> UGlist = new  List<OMNI_User_Group__c> ();
    public static boolean CRMOwnerCheck ;
    
    private static Map<Id,Id> ownerIdWithRoleIdMap = new Map<Id,Id>();
    
     public CaseTriggerHandler() 
    {
        intializeData();             
    }
    
    
    public void intializeData()
    {
        Map<String,QueueIds__c> queueMap    =   QueueIds__c.getAll();
        for(QueueIds__c record : queueMap.values() )
        {
            if( planIdWithQueues.containsKey( record.PlanId__c ) )
            {
                planIdWithQueues.get(record.PlanId__c).add( record.QueueId__c );
            }else{
                planIdWithQueues.put( record.PlanId__c,new Set<Id>{record.QueueId__c});
            }
        }
        /* PPN-17747 starts */
       
        Set<String> queueNameSet       = new Set<String>{'NM Data Entry Queue','IL Data Entry Queue','MT Data Entry Queue','OK Data Entry Queue','TX Data Entry Queue'};
        for(QueueIds__c record: queueMap.values() )
        {
            if( planIdWithQueues.containsKey( record.PlanId__c ) && queueNameSet.contains( record.Name ) )
            {
                DataRep_planIdWithQueues.put(record.PlanId__c, record.QueueId__c);
            }
        }
        
        /* PPN-17747 Ends */
        // record types from custom settings
        Map<String,RecordType_settings__c> recordTypemap =   RecordType_settings__c.getAll();
        if(!recordTypemap.isEmpty())
        {
             for( RecordType_settings__c recType : recordTypemap.values()  )
             {
                recTypeMapbyId.put( recType.Record_type_Id__c , recType );
                recTypeMapbyDeveloperName.put(recType.DeveloperName__c, recType);
            }
        }
       
        //System.debug('recTypeMapbyDeveloperName====>>>'+recTypeMapbyDeveloperName.keySet());
        //PPN-22549
        GlobalSettings__c gs                =   GlobalSettings__c.getValues('PFFileRecieved');
        recTypeNames.addAll(gs.Record_Type_Names__c.split(';'));
        for(String recTypeName  : recTypeNames )
        {
            if(!recTypeMapbyDeveloperName.isEmpty() && recTypeMapbyDeveloperName.containsKey( recTypeName ))
                recTypeMap.put(recTypeMapbyDeveloperName.get( recTypeName ).Record_type_Id__c,recTypeMapbyDeveloperName.get( recTypeName ).DeveloperName__c);
        }
     
    }
    public void bulkBefore() 
    {
       //PPN-20009, PPN-20010 Change the record type of Death File cases from PPW to 'CRM'
            Id CRMCaseRTypeId = GlobalSettings__c.getvalues('PFFileRecieved').CRM_Case_record_Type_Id__c;
            currProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            EnterpriseProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Enterprise Profile' LIMIT 1].Id;
            
        
        Boolean hasRunAfter = true;
        hasRunAfter = AvoidRecursion.hasRunAfterAlready();
         
        if (Trigger.isInsert && Trigger.isBefore ) 
        {
        
            for(Case newCase:(List<Case>)Trigger.new)
            {
                if(newCase.Status=='Approved')
                {
                    newCase.status='Cred Approved';
                }
                if(newCase.Status=='Denied')
                {
                    newCase.status='Cred Denied';
                }
                
            /*
             * PPN-36640
             * Below code added to verify if Coroprate received date available on a case or not.
             * If datetime is empty the applying case creation datetime as default value
             */
                if( newCase.Corporate_Received_Date_Time__c == null )
                {
                    System.Debug('newCase.Corporate_received_date__c 22222====>>>>'+Datetime.now());
                    newCase.Corporate_Received_Date_Time__c = Datetime.now();
                }
            }
        
            /* Death Master File Decommisioned - Start
            for(Case c:(list<Case>)Trigger.new)
            {
                if(c.CRM_Types__c == 'Death File')
                {
                    c.recordtypeid = CRMCaseRTypeId;
                }            
            }
            Death Master File Decommisioned - End */
            
            System.debug('In side before trigger ======>>>>');
            
            /***** PPN-5272 ***************/  
            /*if(!hasRunAfter )
            { */
                System.debug('Status '+Trigger.new[0].get('status')); 
                linkRolodexAccount(Trigger.new);//PPN-443 Code 
                System.debug('Status '+Trigger.new[0].get('status'));
                OMNIQueueAssignmentForPEDI(Trigger.old, Trigger.new); // PPN-17747
                System.debug('Status '+Trigger.new[0].get('status'));
                OMNIChannelRouting(Trigger.new,Trigger.newMap);
                System.debug('Status '+Trigger.new[0].get('status'));
                assignOwnerForCRMchildCases(Trigger.new); //PPN-38678 
                OwnerChangeforOKPlan(Trigger.new); //PPN-32180
                linkExistingEntityAccount(Trigger.new);//PPN-22418
                System.debug('Status '+Trigger.new[0].get('status'));   
                updateNetworkName(Trigger.New, NULL); //PPN-20984 Changes  
                System.debug('Status '+Trigger.new[0].get('status'));
                updatePhysicianAcctOnGroupCredCase(trigger.new,new Map<Id,Case>()); //PPN-25402
                updateAccountOnNetworkLoadCases(trigger.new,new Map<Id,Case>()); //PPN-30575
                System.debug('Status '+Trigger.new[0].get('status'));
                
                
                
                
          //   }
            
             
        }
        system.debug('isUpdate1.a = ' + Trigger.isUpdate);
        system.debug('hasRunAfter = ' + hasRunAfter);
        
        Set<String> setCRMCaseNumber = new Set<String>();
        Set<String> setValidCRMCases = new Set<String>();
        String strCRMRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CRM').getRecordTypeId();

        if (!hasRunAfter)
        {
            if (Trigger.isUpdate)
            {
                for(Case newCase:(List<Case>)Trigger.New)
                {
                    if(newCase.Status=='Approved')
                    {
                        newCase.status='Cred Approved';
                    }
                    if(newCase.Status=='Denied')
                    {
                        newCase.status='Cred Denied';
                    }
                    if(newCase.CRM_Case_Number__c != NULL){
                        setCRMCaseNumber.add(newCase.CRM_Case_Number__c);
                    }  

                }   
                // PPN-43949 Code begin
                    if(!setCRMCaseNumber.isEmpty()){
                        for(Case crmCase : [SELECT Id, caseNumber FROM Case WHERE caseNumber IN: setCRMCaseNumber AND recordTypeId =: strCRMRecTypeId]){
                            setValidCRMCases.add(crmCase.CaseNumber);
                        }
                    
                        for(Case newCase:(List<Case>)Trigger.New){
                            if(newCase.CRM_Case_Number__c != NULL && !setValidCRMCases.contains(newCase.CRM_Case_Number__c)){
                                newCase.addError('Please enter the correct CRM Case Number.');
                            }
                        }
                    }
                //PPN-43949 Code End               
                
                
                
                validatePaperCredCheckbox (Trigger.new,Trigger.oldMap);  //PPN-36046 & PPN-41941
                
                if( UserInfo.getProfileId() != GlobalSettings__c.getValues('PFFileRecieved').Integration_Profile_Id__c )
                {
                    
                    //PPN-27889
                    System.debug('Status '+Trigger.new[0].get('status'));
                    validateProviderDetailsection(trigger.newMap,Trigger.OldMap);
                    System.debug('Status '+Trigger.new[0].get('status'));
                    linkRolodexAccount(Trigger.new);//PPN-443 Code 
                    System.debug('Status '+Trigger.new[0].get('status'));
                    updatePhysicianAcctOnGroupCredCase(trigger.new,Trigger.OldMap); //PPN-25402
                    updateAccountOnNetworkLoadCases(trigger.new,Trigger.OldMap);//PPN-30575
                    System.debug('Status '+Trigger.new[0].get('status'));
                    
                     /*******************************
                     * User story PPN-1645
                     *******************************/
                    validateUserGroup(Trigger.new,Trigger.oldMap);
                    //System.debug('Status '+Trigger.new[0].get('status'));
                    /************************************
                    * Restrict Sup and PNC user to close cases 
                    * without assigning on to their name
                    * **********************************/
                    validateSupAndPncUser(Trigger.new,Trigger.oldMap);
                    System.debug('Status '+Trigger.new[0].get('status'));
                    //PPN-20507 & PPN-20508
                    CreateGroupContractingCase(Trigger.new,Trigger.oldMap);
                    System.debug('Status '+Trigger.new[0].get('status'));
                    //PPN-16712 Changes
                    validateContractingCase(Trigger.new,Trigger.oldMap);
                    System.debug('Status '+Trigger.new[0].get('status'));
                    validateIndividualContractingCase(Trigger.new,Trigger.oldMap); //PPN_22954
                    ValidateDuplicateCredentialingCase(trigger.new, Trigger.oldMap); //PPN - 30306
                    System.debug('Status '+Trigger.new[0].get('status'));                    
                    System.debug('Status '+Trigger.new[0].get('status'));  
                    ValidateProvIdInGroupNetwork(Trigger.new, Trigger.oldMap);// PPN-31082
                    //DuplicateCredentialingCaseCheck(trigger.new, new Map<Id, Case>()); //PPN-42940
                    
                    
                    
                }
                updateNetworkName(Trigger.new,Trigger.oldMap); //PPN-22088 Changes
                checkFor90days(Trigger.new, Trigger.oldMap); // PPN-36039
                
                
                
                case newCase2 = (Case)Trigger.new[0];
                case oldCase2 = (Case)Trigger.old[0];               
                
                if((currProfile[0].Name).contains('Provider Data Rep') && newCase2.OwnerId != oldCase2.OwnerId ){                    
                    // newCase2.addError(Label.CaseOwner);                            
                }
                Case newCase = null;
                Case oldCase = null;
                
                Boolean onlyCRMChildCasesUpdated = true;    //PPN-37379, variable will hold if there were only child CRM cases updated
                
                Set<Id> parentCaseIdSet =  new Set<Id>();
                Set<Id> parentCaseIdStatusSet =  new Set<Id>();
                for (Id caseId : Trigger.OldMap.keySet()) 
                {
                    newCase = (Case)Trigger.NewMap.get(caseId);
                    oldCase = (Case)Trigger.OldMap.get(caseId);
                    
                    system.debug('oldCase.CaseComments = ' + oldCase.CaseComments + ' ---- newCase.CaseComments ' + newCase.CaseComments);
                    
                    if(newCase.OwnerId != oldCase.OwnerId)
                    {
                        System.debug('Line # 98');
                        newCase.Plan_Id_Validation_By_Pass__c   = TRUE;
                    }
                    
                    /* PPN-37379
                     * Check if only CRM child cases were updated
                     * Developer: Travis Self 
                    */ 
                    if(newCase.get('RecordTypeId') != GlobalSettings__c.getValues('PFFileRecieved').CRM_Case_record_Type_Id__c && onlyCRMChildCasesUpdated) {
                        System.debug('Trigger.IsUpdate: Case other than Child CRM Case edited...');
                        onlyCRMChildCasesUpdated = false;
                    }
                   
                    if (newCase.get('ParentId') == null) 
                    {                    
                        if(Utils.isValueChanged(Trigger.OldMap.get(caseId),newCase,'Priority'))
                        {
                            parentCaseIdSet.add(caseId);
                        }
                    }
                    if (newCase.get('ParentId') == null) 
                    {                   
                        
                        if(Utils.isValueChanged(Trigger.OldMap.get(caseId),newCase,'Status'))
                        {
                            if((newCase.get('Status') == 'Closed Rejected' || newCase.RecordType.Name=='Email') && newCase.External_Comments__c==null) 
                            {
                                if(newCase.Completing_the_form_for__c != null && newCase.Completing_the_form_for__c=='Individual' && (newCase.Origin==CASE_ORIGIN_PEDI || newCase.Origin==CASE_ORIGIN_MANUAL_ONBOARDING) ) 
                                {
                                    // continue; // Commented out for PPN-39005
                                } 
                                else 
                                {
                                  newCase.External_Comments__c.addError(Label.External_Comment_Reject);                           
                                }
                            }
                            if( PARENT_CASE_STATUS.contains(newCase.Status))
                            {
                                //system.debug('1:Laxman:trigger.new[0]:' + trigger.new[0]);
                                if(recTypeMapbyId.get( (Id)newCase.get('RecordTypeId') ).DeveloperName__c != 'Data_Entry_Provider_On_boarding' )
                                   // || (recTypeMapbyId.get( (Id)newCase.get('RecordTypeId') ).DeveloperName__c.contains('Contracting') && newCase.get('Status') == 'Needs Credentialing')
                                   
                                    parentCaseIdStatusSet.add(caseId);
                                //system.debug('1:Laxman:parentCaseIdStatusSet:' + parentCaseIdStatusSet);
                            }
                        }
                        
                        if(oldCase.Corporate_Received_Date_Time__c != newCase.Corporate_Received_Date_Time__c) {
                            validateCorpReceivedDate(newCase);
                        }
                    }
                    
                    
                    
                   //PPN-47602
                    String strnetworkgrpRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
                    String strnetworkIndvRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Network_Load').getRecordTypeId();                    
                    String strgrpcredRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
                    String strcredRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
                    
                    //if( !CURRENT_USER.contains( currProfile[0].Name ) && recordTypeList[0].Id != newcase.recordTypeId)
                    if( (!CURRENT_USER.contains( currProfile[0].Name )) && UserInfo.getProfileId() != EnterpriseProfileId &&(!recordTypeSet.contains(newcase.recordTypeId)))//PPN-16284
                    {   
                        system.debug('**** Inside first If ****' );
                        if (newCase.Origin== CASE_ORIGIN_PEDI || newCase.Origin==CASE_ORIGIN_W2C){
                        
                            if(newCase.RecordTypeId == strgrpcredRecTypeId || newCase.RecordTypeId == strcredRecTypeId){ 
                                system.debug('**** Inside Second  If ****' );
                                if((supervisorProfiles.contains( currProfile[0].Name ) 
                                    || (currProfile[0].Name).contains('Provider Data Rep')) 
                                    && Utils.hasRecordChangedCRMCase(Trigger.OldMap.get(caseId),newCase) 
                                    && !newCase.Status.contains('Closed') )
                                {
                                    system.debug('Label.FieldEdit has been triggered'); 
                                    newCase.addError(Label.FieldEditCRM);                            
                                    
                                }
                                if((supervisorProfiles.contains( currProfile[0].Name ) 
                                    || (currProfile[0].Name).contains('Provider Data Rep')) 
                                    && Utils.hasRecordChangedCRMCase(Trigger.OldMap.get(caseId),newCase) 
                                    && !newCase.Status.contains('Closed') 
                                    && newCase.AccountId == oldcase.AccountId 
                                    && newCase.ContactId != oldcase.ContactId )
                                {
                                    system.debug('Label.FieldEdit has been triggered');
                                    newCase.addError(Label.FieldEditCRM);
                                                                 
                                } 
                            }else if(newCase.RecordTypeId == strnetworkgrpRecTypeId || newCase.RecordTypeId == strnetworkIndvRecTypeId){
                                 system.debug('**** Inside Second  If ****' );
                                if((supervisorProfiles.contains( currProfile[0].Name ) 
                                    || (currProfile[0].Name).contains('Provider Data Rep')) 
                                    && Utils.hasRecordChangednetwork(Trigger.OldMap.get(caseId),newCase) 
                                    && !newCase.Status.contains('Closed') )
                                {
                                    system.debug('Label.FieldEdit has been triggered');                                    
                                    newCase.addError(Label.FieldEdit); 
                                }
                                if((supervisorProfiles.contains( currProfile[0].Name ) 
                                    || (currProfile[0].Name).contains('Provider Data Rep')) 
                                    && Utils.hasRecordChangednetwork(Trigger.OldMap.get(caseId),newCase) 
                                    && !newCase.Status.contains('Closed') 
                                    && newCase.AccountId == oldcase.AccountId 
                                    && newCase.ContactId != oldcase.ContactId )
                                {
                                    system.debug('Label.FieldEdit has been triggered');
                                    newCase.addError(Label.FieldEdit);                            
                                } 
                            
                            } 
                            else{                            
                                system.debug('**** Inside Second  If ****' );
                                if((supervisorProfiles.contains( currProfile[0].Name ) 
                                    || (currProfile[0].Name).contains('Provider Data Rep')) 
                                    && Utils.hasRecordChanged(Trigger.OldMap.get(caseId),newCase) 
                                    && !newCase.Status.contains('Closed') )
                                {
                                    system.debug('Label.FieldEdit has been triggered');                                    
                                    newCase.addError(Label.FieldEdit); 
                                }
                                if((supervisorProfiles.contains( currProfile[0].Name ) 
                                    || (currProfile[0].Name).contains('Provider Data Rep')) 
                                    && Utils.hasRecordChanged(Trigger.OldMap.get(caseId),newCase) 
                                    && !newCase.Status.contains('Closed') 
                                    && newCase.AccountId == oldcase.AccountId 
                                    && newCase.ContactId != oldcase.ContactId )
                                {
                                    system.debug('Label.FieldEdit has been triggered');
                                    newCase.addError(Label.FieldEdit);                            
                                }
                            }   
                        }  
                        
                        if(!newCase.Status.contains('Pending') && oldcase.Pending_Reason__c != newcase.Pending_Reason__c ){
                            newCase.addError('Pending Reason can only added for Pending Status');
                        }
                        
                        /****************
                         * The below code is used to restrict users from closing a closed case again 
                         ****************/
                        if((!((currProfile[0].Name).contains('Supervisor'))
                              && UserInfo.getProfileId() != GlobalSettings__c.getValues('PFFileRecieved').Integration_Profile_Id__c
                              && oldCase.OwnerId !=  newCase.OwnerId 
                              && newCase.Status.contains('Closed'))
                             || ( newCase.Status.contains('Closed') && oldCase.Status.contains('Closed')) && !newCase.Status.equals(oldCase.Status) ) 
                              
                          {
                            system.debug('*** Inside First Case Lock ***');
                            newCase.addError(Label.CaseLock);
                          }
                        
                        /* Prevent certain fields from being edited after a case is closed */
                        if(oldCase.Status.contains('Closed') && 
                           UserInfo.getProfileId() != GlobalSettings__c.getValues('PFFileRecieved').Integration_Profile_Id__c &&    /* Bypass validation for integration user */
                           (Utils.hasRecordChanged(Trigger.OldMap.get(caseId),newCase) ||                           
                            /*  oldcase.External_Comments__c != newcase.External_Comments__c || */   /* PPN-30572, Comments should be editable on closed cases */
                            oldcase.Priority !=  newcase.Priority                       ||
                            ((oldcase.Status != newcase.Status) && !onlyCRMChildCasesUpdated)             ||           /* PPN-37379: Case status can be edited ONLY on closed CRM cases */      
                            oldcase.Case_Entity__c !=  newcase.Case_Entity__c      ||
                            oldcase.AccountId != newcase.AccountId            ||
                            oldcase.Pending_Reason__c != newcase.Pending_Reason__c  ||
                            oldcase.Number_of_PFINs__c != newcase.Number_of_PFINs__c ||
                            oldcase.Description != newcase.Description
                           )){
                               system.debug('*** Inside Sec Case Lock ***');
                               newCase.addError(Label.CaseLock);
                           }
                    } 
                }
                
                             
                if (parentCaseIdSet != null && parentCaseIdSet.size() > 0) {
                    Map<Id,List<Case>> parentIdByChildrenMap =getChildCasesByParent(parentCaseIdSet);
                    system.debug('parentIdByChildrenMap==== '+parentIdByChildrenMap);
                    for (Case caseInfo : (List<Case>) Trigger.new) {
                        if (caseInfo.parentId == null) {
                            if (parentIdByChildrenMap.containsKey(caseInfo.Id) && parentIdByChildrenMap.get(caseInfo.Id).size() > 0) {
                                caseInfo.addError(Label.PriorityVal);
                            }
                        }
                    }
                }
                if (parentCaseIdStatusSet != null && parentCaseIdStatusSet.size() > 0) 
                {
                    Map<Id,List<Case>> parentIdByChildrenMap = getChildCasesByParentStatus(parentCaseIdStatusSet);
                    for (Case caseInfo : (List<Case>) Trigger.new) 
                    {
                        /*
                         * Master Case Status validations are NOT to be done on Individual Onboarding Cases (PPN-23112), because status should not be editable. It is being
                         * taken care of by a validation rule.
                         */
                        
                        if(parentIdByChildrenMap.containsKey(caseInfo.Id) && parentIdByChildrenMap.get(caseInfo.Id).size() > 0)
                        {
                            if(caseInfo.Status == 'Cancelled') {
                                system.debug('Status1==== '+parentIdByChildrenMap);
                                caseInfo.addError(Label.StatusCancelVal);
                            }
                            else if(caseInfo.Status == 'Pending') {
                                 system.debug('Status2==== '+parentIdByChildrenMap);
                                 caseInfo.addError(Label.PendingVal);
                            } 
                            else {
                                /* Error message when trying to close a Master Case without first closing all the child cases */
                                system.debug('**** Inside Status Val Error ***'+parentIdByChildrenMap);
                                caseInfo.addError(Label.StatusVal);
                            }
                        }
                    }
                }
            }         
        }
    }
    public void bulkAfter() 
    {
        
        Boolean hasRunBefore = true;
        hasRunBefore = AvoidRecursion.hasRunBeforeAlready();
        System.debug('hasRunBefore 111=====>>>>'+hasRunBefore);
        //PPN-20984 Changes
        //
         if(Trigger.isInsert)
        {
        System.debug('Status '+Trigger.new[0].get('status'));
            createProviderFromContracting(trigger.new);
            System.debug('Status '+Trigger.new[0].get('status'));
            createAttachmentsOnCase(trigger.new);  
            createAttachmentsOnGroupCredentailingCase(trigger.new);
           
        }
        
        if( trigger.isUpdate  && trigger.isAfter )
        {
             /*
              *PPN-12332 OMNI channel Case prioritise 
              */
            System.debug('Status '+Trigger.new[0].get('status'));  
           // omniCasePrioritize( Trigger.new,Trigger.oldMap );
            System.debug('Status '+Trigger.new[0].get('status'));
            System.debug('After update inside block=====>>>> #########');          
            System.debug('hasRunBefore 222=====>>>>'+hasRunBefore); 
            System.debug('Insert bulk After');
            Case oldCase = null;
            Case newCase = null;
            
            Set<Id> parentCaseIdStatusSet =  new Set<Id>();
            Set<Id> parentCaseIdCanStatusSet =  new Set<Id>();
            Set<Id> parentCaseIdPrioritySet =  new Set<Id>();
            List<Case> parentCasesWithUpdatedCorpReceivedDateList = new List<Case>();
            for (Id caseId : Trigger.OldMap.keySet()) 
            {
                oldCase = (Case)Trigger.OldMap.get(caseId);
                newCase = (Case)Trigger.NewMap.get(caseId); 
                
                System.debug('oldCase.Status====>>>>'+oldCase.Status);
                 System.debug('newCase.Status====>>>>'+newCase.Status);
                
                if (newCase.get('ParentId') != null) 
                {
                    if(Utils.isValueChanged(oldCase,newCase,'Priority'))
                    {
                        parentCaseIdPrioritySet.add((Id)newCase.get('ParentId'));  
                    }
                    /**
                     * Below code is to bi-pass the status update on a parent case
                     * status change when data entry case status is closed processed
                     **/
                    if(Utils.isValueChanged(oldCase,newCase,'Status') )
                    {
                        String recordTypeNameString =   recTypeMapbyId.get( (Id)newCase.get('RecordTypeId') ).DeveloperName__c;
                       // System.debug('recordTypeNameString===>>>'+recordTypeNameString);
                        if( (recordTypeNameString.equals('Data_Entry_Provider_On_boarding') 
                            && newCase.Status =='Closed Processed') ||
                            ( recordTypeNameString.equals('Data_Entry_Group_Provider_On_boarding') 
                            && newCase.Status =='Closed Processed')
                          )
                        {
                            // dont do nothing   
                        } else{
                            parentCaseIdStatusSet.add((Id)newCase.get('ParentId'));
                        }
                        
                        System.debug('parentCaseIdStatusSet===>>>'+parentCaseIdStatusSet);
                    }
                } else if (newCase.get('ParentId') == null && (oldCase.ParentId == newCase.ParentId) ) {
                    if( oldCase.Corporate_Received_Date_Time__c != newCase.Corporate_Received_Date_Time__c ) {
                        parentCasesWithUpdatedCorpReceivedDateList.add(newCase);
                    }
                }
            }
            
            if(parentCasesWithUpdatedCorpReceivedDateList != null && parentCasesWithUpdatedCorpReceivedDateList.size() > 0) {
                updateCorpReceivedDate(parentCasesWithUpdatedCorpReceivedDateList);
            }
            
            if (parentCaseIdPrioritySet != null && parentCaseIdPrioritySet.size() > 0) 
            {
                casePriorityUpdate( parentCaseIdPrioritySet );
            }
            system.debug(parentCaseIdStatusSet+'<<<*** hasRunBefore ***>>>' + hasRunBefore );

            //if( parentCaseIdStatusSet != null && !parentCaseIdStatusSet.isEmpty() && !hasRunBefore)
            if( parentCaseIdStatusSet != null && !parentCaseIdStatusSet.isEmpty())
            {
               // system.debug('*** Calling CaseStatus Update ***');
              //  System.debug('Status '+Trigger.new[0].get('status'));
               caseStatusUpdate(parentCaseIdStatusSet);
               System.debug('Status '+Trigger.new[0].get('status'));
            } 
        }
        
        System.debug('hasRunBefore 111=====>>>>'+hasRunBefore);
        system.debug('getLimitQueries()--No of Query -'+Limits.getQueries());
        if (Trigger.isUpdate && !hasRunBefore) 
        {
          
            /***** PPN-1758 ***************/   
            planIdUpdateToQueueChange(Trigger.new,Trigger.oldMap);
            System.debug(LoggingLevel.WARN,'Status '+Trigger.new[0].get('status'));
            UpdateProvIdInChildCase(Trigger.new,Trigger.oldMap);// PPN-31363
            if(!hasRunBefore)
            {
                System.debug('Status '+Trigger.new[0].get('status'));
                updateMasterCaseForGroup (Trigger.new, Trigger.oldMap);//PPN-21154
               
                System.debug('Status '+Trigger.new[0].get('status'));
            }
        }
    }
    
   /**
    * PPN-39400: User access on Corporate Received Date Part 2
    * This method validates whether the Corporate Received Date can be updated and throws various errors.
    * 
    * @param parentCase Parent case where Corporate Received Date was updated.
    */ 
    public void validateCorpReceivedDate(Case parentCase) {
        
        List<String> lstUneditableCaseOrigins = new List<String>{'Web-Demographics', 'Web On-boarding'};

        if(parentCase.Status != 'New' || parentCase.RecordType.DeveloperName == 'Email' || lstUneditableCaseOrigins.contains(parentCase.Origin)) {
            parentCase.Corporate_Received_Date_Time__c.addError('Corporate Received Date is not editable');
        } else if(parentCase.Corporate_Received_Date_Time__c > DateTime.NOW()) {
            parentCase.Corporate_Received_Date_Time__c.addError('Please select only current or past date');
        }
    }
    
   /**
    * PPN-39400: User access on Corporate Received Date Part 2
    * This method will update the Corporate Received Date based on the value of the parent case's recently updated Corporate Received Date.
    * 
    * @param parentCaseList list of parent cases that have had their Corporate Receieved Date updated.
    */ 
    public void updateCorpReceivedDate(List<Case> parentCaseList) {
        
        List<Case> childCasesToUpdateList = [SELECT Id, Corporate_Received_Date_Time__c, Parent.Corporate_Received_Date_Time__c FROM Case WHERE ParentId IN: parentCaseList];
        
        for(Case childCase : childCasesToUpdateList) {
            childCase.Corporate_Received_Date_Time__c = childCase.Parent.Corporate_Received_Date_Time__c;
        }
        
        update childCasesToUpdateList; 
    }
    
     /*
     * Author : Sethuraman E
     * Date   :  06/06/2019
     * Business purpose : Create Attachments on Contracting when closing DataEntry Case
                          Create Attachments on Credentialing when Contracting Case status is changed to Needs Credentialing       
       Us     :  PPN-39574, PPN-40399, PPN-40401
     */
         public void createAttachmentsOnCase (List<case> newList){
            
            string strIndvDataEntryRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId();
            string strIndvContractingRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
            string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
            
            Boolean isFromContracting = false;            
            string strDataEntryCase, strContractingCase, strdateEntryContentDocId;        
            set<Id> setParentCaseId = new set<Id>();
            set<Id> setDataEntryContentDocIds = new Set<Id>();
            set<Id> setContractingContentDocIds = new Set<Id>();
           
            List<ContentDocumentLink> contDocLinkList = new List<ContentDocumentLink>();
            
            for(Case curCase : newList){
                if((curCase.recordTypeId == strIndvContractingRecTypeId || curCase.recordTypeId == strIndvCredRecTypeId) && curCase.Paper_Cred_indicator__c){
                    setParentCaseId.add(curCase.parentId);
                    if(curCase.recordTypeId == strIndvContractingRecTypeId){
                        isFromContracting = true; // Determines whether it is from Contracting or Credentialing
                    }
                } 
            }
            
            if(!setParentCaseId.isEmpty()){
               for(Case childCase : [SELECT Id, recordTypeId FROM Case WHERE parentId IN: setParentCaseId AND (recordTypeId =: strIndvDataEntryRecTypeId or recordtypeId =: strIndvContractingRecTypeId)]){
                   if(childCase.recordTypeId == strIndvDataEntryRecTypeId){
                       strDataEntryCase = childCase.Id; // getting the DataEntryCaseId
                   }
                   else if(childCase.recordTypeId == strIndvContractingRecTypeId){                   
                      strContractingCase = childCase.Id; // getting the ContractingCaseId
                   }
               }
               
               // If the new Contracting Case is created with paper cred enabled, then we need to get the attachments from DataEntryCase
               // Else we need to get the attachments from Contracting Case 
               if(strDataEntryCase != NULL && isFromContracting){
                   for(ContentDocumentLink contentDocument : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: strDataEntryCase]){
                       setDataEntryContentDocIds.add(contentDocument.ContentDocumentId); //storing the content Document Ids related to DataEntryCase
                   }
               }
               else if(strContractingCase != NULL && !isFromContracting){
                   for(ContentDocumentLink contentDocument : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: strContractingCase]){
                       setContractingContentDocIds.add(contentDocument.ContentDocumentId); //storing the content Document Ids related to ContractingCase
                   }
               }
               
               Set<Id> setFinalIds = new Set<Id>();
               if(!setDataEntryContentDocIds.isEmpty()){
                   setFinalIds = setDataEntryContentDocIds;
               }
               else if(!setContractingContentDocIds.isEmpty()){
                   setFinalIds = setContractingContentDocIds;
               }
               
               if(!setFinalIds.isEmpty()){
                   for(Id conDocId : setFinalIds){
                        ContentDocumentLink newConDoc = new ContentDocumentLink();
                        newConDoc.ContentDocumentId = conDocId;
                        newConDoc.LinkedEntityId = newList[0].Id;
                        newConDoc.ShareType = 'I'; 
                        contDocLinkList.add(newConDoc);
                   }
               }
               
               try{
                   if(!contDocLinkList.isEmpty())
                       insert contDocLinkList;
               }
               catch(Exception e){
                   system.debug('#### Exception occured ####');
               }
            }
            
        }
    
    
   /*
     * Author : Suman Gavini
     * Date   :  06/18/2019
     * Business purpose : Create Attachments on Group Credentailing Case when closing Group Contracting Case
                          Create Attachments on Group Credentialing when Contracting Case status is changed to Needs Credentialing       
       Us     : PPN-39571
    */
         public void createAttachmentsOnGroupCredentailingCase (List<case> newList){
            
            string strGroupContractingRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeId();
            string strGroupCredentailingRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
          
            List<ContentDocumentLink> contDocLinkList = new List<ContentDocumentLink>();
            Map<Id,Id> mapParentCaseCredCaseId = new Map<Id,Id>();
            Map<Id,String> mapProvNetProvNum = New Map<Id,String>();
			Map<String,Id> mapProvNumParentCaseIds = New Map<String,Id>();
            
            for(Case curCase : newList){
                if(curCase.recordTypeId == strGroupCredentailingRecTypeId || curCase.Paper_Cred_Indicator__c == True){
                    mapParentCaseCredCaseId.put(curCase.parentId,curCase.Id);
					mapProvNumParentCaseIds.put(curCase.Contract_ProvID__c,curCase.Id);
					
                } 
            }
            system.debug('$$$$$$$$$$$$$$$$$$$$'+mapParentCaseCredCaseId);
            system.debug('$$$$$$$$$$$$$$$$$$$$'+mapProvNumParentCaseIds);
            if(mapParentCaseCredCaseId!=null && mapParentCaseCredCaseId.size()>0){
            
                List<Provider_Networks__c> listProvNet = [Select Id,Prov_ID__c,Contracting_Case__r.ParentId From Provider_Networks__c 
                                                          Where  Contracting_Case__r.ParentId!=null AND Contracting_Case__r.ParentId =:mapParentCaseCredCaseId.keySet() 
                                                          AND RecordType.Name='Contracting Onboarding' AND Prov_ID__c=:mapProvNumParentCaseIds.keySet()];
                                                          
                if(listProvNet!=null && listProvNet.size()>0){
                    for(Provider_Networks__c prov:listProvNet){
                        mapProvNetProvNum.put(prov.Id, prov.Prov_ID__c);
                    }
                }
                system.debug('$$$$$$$$$$$$$$$$$$$$'+mapProvNetProvNum);
                if(mapProvNetProvNum!=null && mapProvNetProvNum.size()>0){
                	
                    for(ContentDocumentLink contentDocument : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:mapProvNetProvNum.keySet()]){
                        system.debug('$$$$$$$$$$$$$$$$$$$$'+contentDocument);
                        ContentDocumentLink newConDoc = new ContentDocumentLink();
                        newConDoc.ContentDocumentId = contentDocument.ContentDocumentId;
                        Id parentId = contentDocument.LinkedEntityId;
						String strProvNum = mapProvNetProvNum.get(contentDocument.LinkedEntityId);
                        system.debug('$$$$$$$$$$$$$$$$$$$$'+strProvNum);
            			system.debug('$$$$$$$$$$$$$$$$$$$$'+parentId);
						if(mapProvNumParentCaseIds.containsKey(strProvNum)){
							newConDoc.LinkedEntityId = mapProvNumParentCaseIds.get(strProvNum);
                        }
						newConDoc.ShareType = 'I'; 
                        contDocLinkList.add(newConDoc);
                    }
                }
            } 
            
            try{
                    if(contDocLinkList!=null && contDocLinkList.size()>0){
                       insert contDocLinkList;
                    }
               } catch(Exception e){
                   system.debug('#### Exception occured ####');
            }
         
   
        }
    
   //PPN-20984 Changes
  public void createProviderFromContracting (List<case> newList)
    {
            Set<String> contractingProvIdSet                    =   new Set<String>();
            Map<String,Account> contractingAcctWithProvIdMap    =   new Map<String,Account>();
            List<Account> contractingacctsForUpdate             =   new List<Account>();
            Map<String,String> provIdWithCompletingFormMap      =   new Map<String,String>();
                
            string groupContractingRecTypeId;
            string groupDataEntryRecTypeId;
            string contractingProviderRecTypeId;
            String countersignRecTypeId;
            string providerMasterEntityId;
            string providerCounterSignId;
            String masterEntityRecTypeId ;
            string providerCredentialingId;
            string indvContractingRecTypeId;
            string indvCredentialingRecTypeId;
            string pfinProviderRectypeId;
            string indvCounterSignRectypeId;
            string indvNetworkRecTypeId;
            string providerNetworkId;
            Boolean contracting = false;
            Boolean counterSign = false;
            Boolean masterEntity = false;
            Boolean credentialing = false;
            Boolean network = false;
            Boolean pfin = false;
            
            Set<string> provDetProvIdSet = new Set<string>();
            Map<string,Id> provDetPFINContentDocMapIds = new Map<string, Id>();
            List<ContentDocumentLink> contDocLinkList = new List<ContentDocumentLink>();
            List<Provider_Networks__c> providerNetworkList = new List<Provider_Networks__c>();
          
            map<Id, Id> parentCaseMap       =   new map<Id, Id>();
        
            groupContractingRecTypeId       =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeId();
            groupDataEntryRecTypeId         =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Group_Provider_On_boarding').getRecordTypeId();
            countersignRecTypeId            =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Counter_Sign').getRecordTypeId();
            masterEntityRecTypeId           =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Master_Entity').getRecordTypeId();
            indvContractingRecTypeId        =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
            indvCredentialingRecTypeId      =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
            indvCounterSignRectypeId        =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Counter_Sign').getRecordTypeId();
            indvNetworkRecTypeId            =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Network_Load').getRecordTypeId();
            contractingProviderRecTypeId    =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Contracting_Onboarding').getRecordTypeId();
            pfinProviderRectypeId           =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('PFIN_Onboarding').getRecordTypeId();
            providerMasterEntityId          =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Master_Entity').getRecordTypeId();
            providerCounterSignId           =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('CounterSign').getRecordTypeId();
            providerCredentialingId         =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Credentialing').getRecordTypeId();
            providerNetworkId               =   Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Network').getRecordTypeId();
          
            System.debug('<======================= Debugging Starts in Create Provider  ==========================>>>>>');
            for(Case curCase : newList)
            {
                    
                    system.debug('#### curCase.recordtypeId ###' + curCase.recordtypeId );               
               //if((curCase.recordtypeId == groupContractingRecTypeId || curCase.recordtypeId == indvContractingRecTypeId) && curCase.parentId != NULL)
              if((curCase.recordtypeId == groupContractingRecTypeId || curCase.recordtypeId == indvContractingRecTypeId) && curCase.parentId != NULL)
                {
                    parentCaseMap.put(curCase.parentId, curCase.Id);
                    contracting = true;
                    system.debug('**** Inside Contracting Case logic *********');
                }
                else if((curCase.recordtypeId == countersignRecTypeId || curCase.recordtypeId == indvCounterSignRectypeId)&& curCase.parentId != NULL)
                {
                    parentCaseMap.put(curCase.parentId, curCase.Id);
                    counterSign = true;
                    system.debug('**** Inside Countersign Case logic *********');
                }
                else if(curCase.recordtypeId == masterEntityRecTypeId && curCase.parentId != NULL)
                {
                    parentCaseMap.put(curCase.parentId, curCase.Id);
                    masterEntity = true;
                    system.debug('**** Inside Master Entity Case logic *********');
                }
                else if(curCase.recordtypeId == groupDataEntryRecTypeId && curCase.parentId != NULL)
                {
                    pfin = true;
                     system.debug('**** Inside Group Date Entry Case logic *********');
                }
                else if(curCase.recordTypeId == indvCredentialingRecTypeId && curCase.parentId != NULL)
                {
                    System.debug(indvCredentialingRecTypeId+'curCase.recordTypeId===>>>'+curCase.recordTypeId);                    
                    parentCaseMap.put(curCase.parentId, curCase.Id);
                    credentialing = true;
                    system.debug('**** Inside indvCredentialingRecTypeId Case logic *********');
                }
                else if(curCase.recordTypeId == indvNetworkRecTypeId && curCase.parentId != NULL)
                {
                    parentCaseMap.put(curCase.parentId, curCase.Id);
                    network = true;
                     system.debug('**** Inside indvNetworkRecTypeId Case logic *********');
                }
            }        
            if(pfin || masterEntity || counterSign || contracting || credentialing || network)
            {    
                System.debug( pfin+'1111'+masterEntity+'2222'+counterSign+'3333'+contracting+'4444'+credentialing+'55555'+network);
                for(Provider_Networks__c provNetWork : [SELECT id,Network_Load_Plan_Id__c, Prior_Provider_Id__c, Network_Code_Name_Detail__c,Case_Number__c,Network_Code_Name__c,
                                                        Roles_Code__c,Panel_code__c,Networks_Effective_Date__c,Cred_Status__c,Designation_Code__c, Paper_Cred_Indicator__c,
                                                        PFIN_Case__c,Comp_Grid_Code__c ,Comp_Grid_Effective_Date__c ,recordTypeId ,Prov_Id__c,CounterSign__c,
                                                        Contracting_case__c,Master_Entity_Case__c,PFIN_Case__r.Plan_ID__c, contracting_case__r.Plan_ID__c, 
                                                        PFIN_onBoarding__c, Credentialing_case__c, PFIN_Case__r.parentId,credentialing_Case__r.parentId,
                                                        credentialing_Case__r.Plan_ID__c,credentialing_Case__r.Completing_the_form_for__c, contracting_case__r.parentId,PFIN_Case__r.recordtypeId, counterSign__r.plan_Id__c,
                                                        contracting_case__r.Status,contracting_case__r.Completing_the_form_for__c,counterSign__r.ParentId, contracting_case__r.origin, counterSign__r.origin, isFromIndividual__c
                                                        FROM Provider_Networks__c WHERE 
                                                        (PFIN_Case__r.parentId IN: parentCasemap.Keyset() OR contracting_case__r.parentId IN: parentCasemap.Keyset() OR 
                                                        Credentialing_Case__r.parentId IN: parentCasemap.keyset() OR counterSign__r.parentId IN: parentCasemap.KeySet())])
                {
 
                    if(contracting == false && provNetWork.recordTypeId == pfinProviderRectypeId){
                        system.debug('###### Execute Next Record ######');
                        continue;
                    }
                   
                    System.debug('credentialing_Case__r.Completing_the_form_for__c====>>>>'+provNetWork.credentialing_Case__r.Completing_the_form_for__c);
                    System.debug('contracting_case__r.Completing_the_form_for__c====>>>>'+provNetWork.contracting_case__r.Completing_the_form_for__c);
                    system.debug('### counterSign ## ' +counterSign);
                     system.debug('### MasterEntity ## ' +masterEntity);
                     System.debug('What is the boolean '+contracting+'-'+counterSign+'-'+masterEntity+'-'+credentialing+'-'+Network);
                     System.debug('Boolean 2'+parentCaseMap.containsKey(provNetwork.contracting_Case__r.parentId));
                    
                    Provider_Networks__c provDetail = new Provider_Networks__c();              
                    provDetail.Network_Load_Plan_Id__c = provNetWork.Network_Load_Plan_Id__c;  
                    provDetail.Roles_Code__c = provNetWork.Roles_Code__c;    
                    provDetail.Network_Code_Name__c = provNetWork.Network_Code_Name__c; 
                    provDetail.Networks_Effective_Date__c = provNetWork.Networks_Effective_Date__c; 
                    provDetail.Comp_Grid_Code__c = provNetWork.Comp_Grid_Code__c; 
                    provDetail.Cred_Status__c = provNetWork.Cred_Status__c; 
                    provDetail.Designation_Code__c = provNetWork.Designation_Code__c; 
                    provDetail.Panel_code__c= provNetWork.Panel_code__c;
                    provDetail.Network_Code_Name_Detail__c = provNetwork.Network_Code_Name_Detail__c;
                    provDetail.Prov_Id__c = provNetWork.Prov_Id__c;                               
                    provDetail.PFIN_onBoarding__c = provNetWork.PFIN_onBoarding__c;
                    provDetail.SkipValidation__c =True;
                    
                    System.debug('SK provDetail.Prov_Id__c=====>>>>'+ provDetail.Prov_Id__c);  
                    
                    if(contracting == true && parentCaseMap.containsKey(provNetWork.PFIN_Case__r.parentId)){
                        provDetail.recordTypeId = contractingProviderRecTypeId;
                        provDetail.Contracting_case__c = parentCaseMap.get(provNetWork.PFIN_Case__r.parentId);
                        provDetail.Network_Load_Plan_Id__c = provNetWork.PFIN_Case__r.Plan_ID__c;
                        provDetail.Paper_Cred_Indicator__c = provNetWork.Paper_Cred_Indicator__c;
                        
                        system.debug('************parentCaseMap****************');
                        if(provNetWork.Paper_Cred_Indicator__c == true){
                            for(ContentDocumentLink contentDocument : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:provNetWork.Id]){
                                provDetPFINContentDocMapIds.put(provNetWork.PFIN_onBoarding__c,contentDocument.ContentDocumentId); //storing the content Document Ids related to ProviderDetailsDataEntry
                                provDetProvIdSet.add(provNetWork.Prov_Id__c);
                                system.debug('****************************' + provDetPFINContentDocMapIds);
                            } 
                        }
                    }
                    //R4-Regression issues PPN-26811
                    else if(counterSign == true && (parentCaseMap.containsKey(provNetWork.credentialing_case__r.parentId) || (parentCaseMap.containsKey(provNetWork.contracting_case__r.parentId) && provNetWork.contracting_case__r.Status == 'No Credentialing needed')) && provNetWork.isFromIndividual__c){
                        provDetail.recordTypeId = providerCounterSignId;
                        if(parentCaseMap.containsKey(provNetWork.credentialing_Case__r.parentId)){
                            provDetail.CounterSign__c = parentCaseMap.get(provNetWork.credentialing_Case__r.parentId);
                            provDetail.Network_Load_Plan_Id__c = provNetWork.credentialing_Case__r.Plan_ID__c;
                        }
                        else{
                            provDetail.CounterSign__c = parentCaseMap.get(provNetWork.contracting_case__r.parentId);
                            provDetail.Network_Load_Plan_Id__c = provNetWork.contracting_case__r.Plan_ID__c;

                        }
                    }
                    else if(counterSign == true && parentCaseMap.containsKey(provNetWork.contracting_case__r.parentId) && !provNetWork.isFromIndividual__c){
                        provDetail.recordTypeId = providerCounterSignId;
                        provDetail.CounterSign__c = parentCaseMap.get(provNetWork.contracting_case__r.parentId);
                        provDetail.Network_Load_Plan_Id__c = provNetWork.contracting_case__r.Plan_ID__c;
                        provDetail.Prior_Provider_Id__c = string.valueOf(provNetwork.Id).substring(0,15);
                    }
                    else if(masterEntity == true && parentCaseMap.containsKey(provNetWork.contracting_case__r.parentId)){
                        provDetail.recordTypeId = providerMasterEntityId;
                        provDetail.Master_Entity_Case__c = parentCaseMap.get(provNetWork.contracting_case__r.parentId);
                        provDetail.Network_Load_Plan_Id__c = provNetWork.contracting_case__r.Plan_ID__c;
                        system.debug('*** Inside ME logic ****');
                    }
                    else if(credentialing == true && parentCaseMap.containsKey(provNetWork.contracting_case__r.parentId)){
                    System.debug('What is type id '+providerCredentialingId);
                        provDetail.recordTypeId = providerCredentialingId;
                        provDetail.Credentialing_Case__c = parentCaseMap.get(provNetWork.contracting_case__r.parentId);
                        provDetail.Network_Load_Plan_Id__c = provNetWork.contracting_case__r.Plan_ID__c;
                    }
                    else if(network == true && parentCaseMap.containsKey(provNetWork.contracting_case__r.parentId) && provNetwork.contracting_case__r.origin == 'Web On-boarding'){
                        provDetail.recordTypeId = providerNetworkId;
                        provDetail.Case_Number__c = parentCaseMap.get(provNetWork.contracting_case__r.parentId);
                        provDetail.Network_Load_Plan_Id__c = provNetWork.contracting_case__r.Plan_ID__c;
                    }
                    else if(network == true && parentCaseMap.containsKey(provNetWork.counterSign__r.parentId) && provNetwork.counterSign__r.origin == 'Manual On-boarding'){
                        provDetail.recordTypeId = providerNetworkId;
                        provDetail.Case_Number__c = parentCaseMap.get(provNetWork.counterSign__r.parentId);
                        provDetail.Network_Load_Plan_Id__c = provNetWork.counterSign__r.Plan_ID__c;
                    }
                     //providerNetworkList.add(provDetail);
                     
                   if(credentialing == true 
                      && parentCaseMap.containsKey(provNetWork.contracting_case__r.parentId)
                      && provNetWork.contracting_case__r.Completing_the_form_for__c != null
                     )
                   {
                      contractingProvIdSet.add( provNetWork.Prov_Id__c );   
                      provIdWithCompletingFormMap.put( provNetWork.Prov_Id__c , provNetWork.contracting_case__r.Completing_the_form_for__c  );                                       
                   }
                    providerNetworkList.add(provDetail); 
                }                
            }
            /***********************************************
            @Author: i364191
            @ver1.0 : 1.0
            @Date: 12/07
            @Param:  Individual contracting case associsted 
                      provider networks provId's
            ************************************************/
            System.debug('provIdWithCompletingFormMap===>>>>'+provIdWithCompletingFormMap);
            if( !contractingProvIdSet.isEmpty() && !provIdWithCompletingFormMap.isEmpty() )
            {
                contractingAcctWithProvIdMap   =   getAcctIdByProvId( contractingProvIdSet ); 
            }
        
            if( !contractingAcctWithProvIdMap.isEmpty())
            {
                for( String providStr : contractingProvIdSet)
                {
                    if( provIdWithCompletingFormMap.containsKey( providStr ) && contractingAcctWithProvIdMap.containsKey(providStr)
                        && contractingAcctWithProvIdMap.get(providStr).RecordType.developerName == 'Physician' 
                        && ( provIdWithCompletingFormMap.containsKey( providStr )  &&  provIdWithCompletingFormMap.get( providStr ) == 'Individual')
                      )
                    {
                        Account acctRecord = new Account(Id=contractingAcctWithProvIdMap.get(providStr).id);
                        acctRecord.Cred_Status__c = 'New';
                        contractingacctsForUpdate.add(acctRecord);
                    }
                }    
            }           

             system.debug('###### providerNetworkList #####' + providerNetworkList);
             system.debug('###### providerNetworkList #####' + providerNetworkList.size());
            if(!providerNetworkList.isEmpty())
            {
             insert providerNetworkList;               
                 
            }
            
            system.debug('*********************' + provDetProvIdSet);
            if(provDetProvIdSet!=null && provDetProvIdSet.size()>0){
                for(Provider_Networks__c provNetWork : [SELECT id,Network_Load_Plan_Id__c, Prior_Provider_Id__c, Network_Code_Name_Detail__c,Case_Number__c,Network_Code_Name__c,
                                                        Roles_Code__c,Panel_code__c,Networks_Effective_Date__c,Cred_Status__c,Designation_Code__c, Paper_Cred_Indicator__c,
                                                        PFIN_Case__c,Comp_Grid_Code__c ,Comp_Grid_Effective_Date__c ,recordTypeId ,Prov_Id__c,CounterSign__c,
                                                        Contracting_case__c,Master_Entity_Case__c,PFIN_Case__r.Plan_ID__c, contracting_case__r.Plan_ID__c, 
                                                        PFIN_onBoarding__c, Credentialing_case__c, PFIN_Case__r.parentId,credentialing_Case__r.parentId,
                                                        credentialing_Case__r.Plan_ID__c,credentialing_Case__r.Completing_the_form_for__c, contracting_case__r.parentId,PFIN_Case__r.recordtypeId, counterSign__r.plan_Id__c,
                                                        contracting_case__r.Status,contracting_case__r.Completing_the_form_for__c,counterSign__r.ParentId, contracting_case__r.origin, counterSign__r.origin, isFromIndividual__c
                                                        FROM Provider_Networks__c WHERE 
                                                        Paper_Cred_Indicator__c = true AND Prov_Id__c=:provDetProvIdSet AND Contracting_Case__c!=null])
                {
                    system.debug('*********************' + provDetPFINContentDocMapIds);
                    system.debug('*********************' + provNetWork);
                    system.debug('*********************' + provDetPFINContentDocMapIds.containsKey(provNetWork.PFIN_onBoarding__c));
                    if(provDetPFINContentDocMapIds!=null && provDetPFINContentDocMapIds.size()>0 && provDetPFINContentDocMapIds.containsKey(provNetWork.PFIN_onBoarding__c)){
                        ContentDocumentLink newConDoc = new ContentDocumentLink();
                        newConDoc.ContentDocumentId = provDetPFINContentDocMapIds.get(provNetWork.PFIN_onBoarding__c);
                        newConDoc.LinkedEntityId = provNetWork.Id;
                        newConDoc.ShareType = 'I'; 
                        contDocLinkList.add(newConDoc);
                    }
                    
                }
            }
            system.debug('*********************'+ contDocLinkList);     
            try{
                if(contDocLinkList!=null && contDocLinkList.size()>0){ 
                    insert contDocLinkList;
                }
            } catch(Exception e){
                system.debug('#### Exception occured ####');
            }
        
        if(!contractingacctsForUpdate.isEmpty())
        {
            try{
               update contractingacctsForUpdate; 
            }catch( Exception e ){
                System.debug('Exception e====>>>>>'+e.getMessage());

            }
        }
           
        System.debug('<=============Debugging Ends ==========================>>>>>');       
    }

    
    
     public static Map<Id,List<Case>> getChildCasesByParent(Set<Id> parentCaseIdSet) 
    {
        Map<Id,List<Case>> parentIdByChildrenMap = new Map<Id,List<Case>>();
        for (Case caseInfo : [Select Id,ParentId From Case c Where c.ParentId in :parentCaseIdSet]) 
        {
            if (!parentIdByChildrenMap.containsKey(caseInfo.ParentId)) 
            {
                parentIdByChildrenMap.put(caseInfo.ParentId, new List<Case>());
            }
            parentIdByChildrenMap.get(caseInfo.ParentId).add(caseInfo);
        }
        return parentIdByChildrenMap;
    }
        /* PPN-17747 Start */
    public static void OMNIQueueAssignmentForPEDI(List<Case> oldList, List<Case> newList)
    {
   // system.debug('OMNIQueueAssignmentForPEDI--- Coming inside method');
      for(Case c: newList) 
      {
        /*if( processedRecords.contains( c.Id) ) continue;
            processedRecords.add(c.Id);  */
          System.debug('processedRecords====>>>>'+processedRecords);
          System.debug('c.recordTypeId====>>>>'+c.recordTypeId); 
          System.debug('c.recordTypeId11====>>>>'+Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId());
          System.debug('c.recordTypeId22====>>>>'+Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Master_Entity').getRecordTypeId());
          System.debug('c.recordTypeId33====>>>>'+Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Group_Provider_On_boarding').getRecordTypeId());
          
        /*if(((c.Origin == 'Web On-boarding') || (c.Origin == 'Manual On-boarding')) 
           && ((c.recordTypeId  == recTypeMapbyDeveloperName.get('Data_Entry_Provider_On_boarding').Record_type_Id__c) 
          || (c.recordTypeId    == recTypeMapbyDeveloperName.get('Provider_Group_Onboarding_Master_Entity').Record_type_Id__c) 
          || (c.recordTypeId    == recTypeMapbyDeveloperName.get('Data_Entry_Group_Provider_On_boarding').Record_type_Id__c))
          ){ */
          
          if(((c.Origin == 'Web On-boarding') || (c.Origin == 'Manual On-boarding')) 
           && ((c.recordTypeId  == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId()) 
          || (c.recordTypeId    == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Master_Entity').getRecordTypeId()) 
          || (c.recordTypeId    == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Group_Provider_On_boarding').getRecordTypeId()))
          ){
                if(DataRep_planIdWithQueues.containsKey(c.Plan_ID__c))
                {
                    system.debug('OMNIQueueAssignmentForPEDI--- Coming inside methodloop if');
                    system.debug('c.Plan_ID__c'+DataRep_planIdWithQueues.get(c.Plan_ID__c));
                    c.OwnerId = DataRep_planIdWithQueues.get(c.Plan_ID__c);
                }
            }
        }
    } 
    
    /* PPN-17747 Ends */
    /*********************************************************************************************************
    * PPN-5272 After a case is created, based on the criteria set in the objects OMNI_User_Group__c 
    * and OMNI_Queue__c, change the owner on case to correpsonding queue. 
    * If no matching criteria is found,no action is needed
    *********************************************************************************************************/
    
    public static void OMNIChannelRouting( List<sObject> newList , Map<Id,Sobject> newMap )
    {
        
        Map<Id,Case> caseMap        =   (Map<Id,Case>)newMap;
        caseList                    =   (list<Case>)newList;
        OMNICriteriaTable temp      =   new OMNICriteriaTable();
        list<case> casestobeupdated =   new list<case>();
        Datetime GMTDate            =   system.now();
        String strConvertedDate     =   GMTDate.format('yyyy-MM-dd','America/Chicago');
        String strConvertedDate2    =   GMTDate.format('yyyy-MM-dd HH:mm:ss','America/Chicago');
        Datetime dttm               =   DateTIME.valueof(strConvertedDate2);
        Date dt                     =   Date.valueof(strConvertedDate);
        case tempcase               =   new case();
        
        if(q.isEmpty())
        {
             q       = [select id,Ownerid,Case_Type__c,Plan_Id__c,Queue_Priority__c,Request_Type_s__c from OMNI_Queue__c];
        }
        if(UGlist .isEmpty())
        {
            UGlist = [select id,Group__c,Selected_User_Ids__c,Selected_Users__c,User__c from OMNI_User_Group__c where Active__c = true and Start_Date__c <= :dt and End_Date__c >= :dt and Week_Days__c includes (:dttm.format('EEEE'))];
        }            
       
        Map<id,OMNI_User_Group__c> userMap = new Map<id,OMNI_User_Group__c>();
        for(OMNI_User_Group__c g: UGlist){       
            userMap.put(g.Group__c,g);
        }
        system.debug('userMap:' + userMap);
        for(OMNI_Queue__c t : q) {
            temp = new OMNICriteriaTable();
            temp.Queue = t;
            temp.UserGroup = userMap.get(t.id);
            criteria.add(temp);
        }
        
        
        UpdateCaseOwner(CaseList);
        
    }
    
    
    /*********************************************************************************************************
    * PPN-5272 Creating a common function to be called from Trigger as well as Batch
    *********************************************************************************************************/
    public static void UpdateCaseOwner( List<Case> CaseList)
    {
        System.debug('<<<============= Debugging Starts ===============>>>');  
        System.debug('CaseList===>>>'+CaseList.size()+caseList);   
        System.debug('criteria====>>>>'+criteria);
        CRMOwnerCheck = false;
        //User u = [select Id, username from User where Id = :UserInfo.getUserId()];
        list<case> CaseList2 = CaseList; 
        for(Case c : caseList2) {
            if((c.parentid != null  && c.id == null)|| c.CRM_Types__c=='Death File')
            {
            System.debug('************************'+c.OwnerId);  
            System.debug('************************'+UserInfo.getUserId());  
              
            if(recTypeMapbyId.containsKey(c.recordtypeid)){
            System.debug('************************'+recTypeMapbyId.get( c.recordtypeid ).Name__c); 
            if(c.OwnerId == UserInfo.getUserId() && recTypeMapbyId.get( c.recordtypeid ).Name__c =='CRM'){
                    CRMOwnerCheck = true;
                
             }
             }
            
                for(OMNICriteriaTable t:criteria){                

                        System.debug('Inside Else block ######'+t.Queue.Request_Type_s__c);
                        if((t.Queue.Request_Type_s__c != null 
                            && (t.Queue.Request_Type_s__c).contains( recTypeMapbyId.get( c.recordtypeid ).Name__c ) 
                            &&  t.Queue.Plan_Id__c == c.Plan_ID__c && (c.SkipOmniRouting__c==NULL || c.SkipOmniRouting__c=='')
                           ) || (
                               t.Queue.Request_Type_s__c != NULL && c.CRM_Types__c !=NULL && recTypeMapbyId.get( c.recordtypeid ).Name__c =='CRM' 
                               && t.Queue.Request_Type_s__c.contains(c.CRM_Types__c) && t.Queue.Plan_Id__c == c.Plan_ID__c 
                               && (c.SkipOmniRouting__c==NULL || c.SkipOmniRouting__c=='')
                             )
                           || (t.Queue.Request_Type_s__c != null && c.Request_Type__c != NULL && t.Queue.Request_Type_s__c.contains(c.Request_Type__c) 
                               && recTypeMapbyId.get( c.recordtypeid ).DeveloperName__c == 'Child_Mass_Case_IL_Roster' && t.Queue.Plan_Id__c == c.Plan_ID__c 
                               && (c.SkipOmniRouting__c==NULL || c.SkipOmniRouting__c==''))
                           || (t.Queue.Request_Type_s__c != NULL && c.CRM_Types__c !=NULL && recTypeMapbyId.get( c.recordtypeid ).Name__c =='CRM' 
                               && t.Queue.Request_Type_s__c.contains(c.CRM_Types__c) && t.Queue.Plan_Id__c == c.Plan_ID__c 
                               && CRMOwnerCheck == true)){//PPN-16124, PPN-15288 Code Added
                               System.debug('t.Queue.ownerid2222===>>>'+t.Queue.ownerid);                               
                               c.ownerid = t.Queue.ownerid;
                               break;                           
                           }
                    /*} */
                }
            }
        }
        System.debug('<<<============= Debugging Ends ===============>>>');    
    }
    
    public static Map<Id,List<Case>> getChildCasesByParentStatus(Set<Id> parentCaseIdSet) 
    {
        Map<Id,List<Case>> parentIdByChildrenMap = new Map<Id,List<Case>>();
        Set<String> CaseStatus =  new Set<String>{'Closed Rejected','Closed Processed','Cancelled'}; 
            for (Case caseInfo : [Select Id,ParentId From Case c Where c.ParentId in :parentCaseIdSet and c.status not in:CaseStatus]) 
        {
            if (!parentIdByChildrenMap.containsKey(caseInfo.ParentId)) 
            {
                parentIdByChildrenMap.put(caseInfo.ParentId, new List<Case>());
            }
            parentIdByChildrenMap.get(caseInfo.ParentId).add(caseInfo);
        }
        return parentIdByChildrenMap;
    }
    
    public static void casePriorityUpdate(Set<Id> parentCaseIdSet)
    {
        List<Case> parentCases = [Select c.Priority,
                                  (Select Priority From Cases) 
                                  From Case c
                                  Where c.Id in :parentCaseIdSet];
        List<Case> parentCasesToUpdate = new List<Case>();
        Set<string> casePriority = new Set<string>();
        for (Case parent:parentCases)
        {
            
            for (Case childCase:parent.Cases)
            {
                casePriority.add(childCase.Priority);
            }
            if(casePriority.contains('High'))
            {
                parent.Priority = 'High';
            }
            else if(casePriority.contains('Medium'))
            {
                parent.Priority = 'Medium';
            }
            else{
                parent.Priority = 'Low';
            }
            System.debug('Line # 518');
            parent.Plan_Id_Validation_By_Pass__c = False; 
            
            parentCasesToUpdate.add(parent);
        }
        if (parentCasesToUpdate.size()>0) 
        {
            update parentCasesToUpdate;
        }
    }
   
     
     /*
    * @author       :   Sreekanth K (i364191)
    * @date         :   07/19/2019
    * @description  :   Function is used to update the master case record based on the child state
    *                   for Web-demographic, Email, Manual ADC, Mass CRM Network load,Roster file case creation
    *                   type cases.
    * version       :   1.0 
    */
    public static void caseStatusUpdate(Set<Id> parentCaseIdSet)
    {
        List<Case>       parentCasesToUpdateList        =   new List<Case>();
        List<Case> parentCases                          =   [Select c.origin,c.IsClosed,RecordType.Name, c.status,c.CaseNUmber,(Select IsClosed,CaseNumber,RecordType.Name,parentId,parent.caseNumber,status From Cases) 
                                                             From Case c Where c.Id in :parentCaseIdSet];   
                
        /*
         * PPN-48325 ,PPN-48335
         * Below global seetings and code added to bi-pass the Credentialing cases status update if associated CRM cases status gets changed
         * and parent cases to be avaoided i.e on-boarding cases and Availity 
         */
        Set<Id> credentialingRecordTypeIdSet            =   new Set<Id>();
        Set<String> avaoidedParentCaseOriginsSet        =   new Set<String>();
        if(!String.isEmpty(GlobalSettings__c.getValues('PFFileRecieved').Credentialing_record_types__c))
        {
            List<Id> credentialingRecordTypeIdList      =   GlobalSettings__c.getValues('PFFileRecieved').Credentialing_record_types__c.split(',');
            credentialingRecordTypeIdSet.addAll( credentialingRecordTypeIdList );
            List<String> avaoidedParentCaseOriginsList  =   GlobalSettings__c.getValues('PFFileRecieved').Avoided_Case_Origins__c.split(',');
            avaoidedParentCaseOriginsSet.addAll( avaoidedParentCaseOriginsList );
        }
        
        List<Case> parentCasesToUpdate                              =   new List<Case>(); 
        Map<Id,Map<String,Integer>> parentIdAndStatusMap            =   new Map<Id,Map<String,Integer>>();
        Map<Id,Boolean>             parentIdWithAllChildClosedMap   =   new Map<Id,Boolean>();
        for (Case parent : parentCases) 
        {
           if( !credentialingRecordTypeIdSet.isEmpty() 
              && !credentialingRecordTypeIdSet.contains( parent.RecordTypeId ) 
              && !avaoidedParentCaseOriginsSet.contains(parent.Origin)) //PPN-48325 ,PPN-48335
           { 
                Boolean allChildrenClosed   =   true;
                Boolean allsamestatus       =   false; 
                
               /*
                * Consolidating data into map of parent case id with Status count and Parent 
                * case id with all child closed status
                */
                for( Case childCase : parent.Cases )
                {
                    Integer statusCount         =   0;
                    if( parentIdAndStatusMap.containsKey( childCase.ParentId ) )
                    {
                        
                        if( parentIdAndStatusMap.get( childCase.ParentId ).containsKey( childCase.Status ) )
                        {
                             statusCount = parentIdAndStatusMap.get( childCase.ParentId ).get( childCase.Status );
                             parentIdAndStatusMap.get( childCase.ParentId ).put( childCase.Status , ++statusCount );
                        }else{
                            parentIdAndStatusMap.get( childCase.ParentId ).put( childCase.Status , statusCount );
                        }
                    }else{
                        Map<String,Integer> statusCountMap  =   new map<String,Integer>();
                        statusCountMap.put( childCase.Status, 0 );
                        ParentIdAndStatusMap.put( childCase.ParentId, statusCountMap );
                    }
                    
                    If(!childCase.IsClosed)
                    {
                        parentIdWithAllChildClosedMap.put( childCase.ParentId , true );
                    }
                }              
            }
        }
        /* Iterate over the parent cases to find whether the child cases are closed or nor
         * If closed consider that parent case to be for closing
         */
        if( !ParentIdAndStatusMap.isEmpty() )
                {
                    for( Case parentCase : parentCases )
                    {
                        if( parentIdAndStatusMap.containsKey(  parentCase.id ) && parentIdAndStatusMap.get( parentCase.id ).size() > 1)
                        {
                            Case caseRec1           =   new Case( Id = parentCase.Id );
                            caseRec1.Status         =   (parentIdWithAllChildClosedMap.get(parentCase.id)!=null && parentIdWithAllChildClosedMap.get(parentCase.id)) ? 'In Progress' : 'Closed Processed';
                            parentCasesToUpdateList.add( caseRec1 );
                        }else{
                            Case caseRec            =   new Case( Id = parentCase.Id );
                            Set<String> tempSet     =   parentIdAndStatusMap.get(parentCase.id).keySet();
                            String      ststusStr   =   ( new List<String>(tempSet)[0]);
                            caseRec.Status          =   (parentIdWithAllChildClosedMap.get(parentCase.id)!=null && parentIdWithAllChildClosedMap.get(parentCase.id)) ? 'In Progress' : ststusStr;
                            parentCasesToUpdateList.add( caseRec );
                        }
                        System.debug( ParentIdAndStatusMap.get(parentCase.id).size()+'Indise 2nd Loop 22222 ====>>>>'+ parentCase.Cases.size() );
                    }
                } 
        // Final parent cases to update
        if (parentCasesToUpdateList.size()>0) 
        {
           update parentCasesToUpdateList;
        } 
    }
    
    /**********************************************************************
    * PPN-1758 Below code used to update the planId if there is change in Queue 
    * on either child case or on master case
    **********************************************************************/
    public static void planIdUpdateToQueueChange( List<sObject> newList , Map<Id,sObject> oldMap )
    {
        Map<Id,Case> oldMap1                =   (Map<Id,Case>)oldMap;
        Set<Id> childCaseIds                =   new Set<Id>();
        Set<Id> masterCaseIds               =   new Set<Id>();
        Map<Id,Id> parentCaseWithQueueId    =   new Map<Id,Id>();
     
        if( UserInfo.getProfileId() != GlobalSettings__c.getValues('PFFileRecieved').Integration_Profile_Id__c )
        {
            List<Case> recordsToUpdate          =   new List<Case>();
            System.debug(LoggingLevel.WARN,'Coming inside if');
            for( Case record:(List<Case>)newList )
            {
                
                String idPrefix     =   String.valueOf( record.OwnerId ).subString(0,3);
                System.debug(LoggingLevel.WARN,oldMap1.get(record.Id).OwnerId+'-'+record.OwnerId+'-'+idPrefix);
                if( ( oldMap1.get(record.Id).OwnerId != record.OwnerId ) && idPrefix=='00G')
                {  
                    System.debug('Test 111111===>>>');
                    if( queueIdWithPlan.get(record.OwnerId) != record.Plan_ID__c )
                    {  
                        
                        if( record.ParentId != null )
                        {
                            
                            masterCaseIds.add( record.parentId);
                            childCaseIds.add( record.Id );
                            parentCaseWithQueueId.put( record.ParentId, record.OwnerId );
                            parentCaseWithQueueId.put(record.Id, record.OwnerId);
                        }else{
                            masterCaseIds.add( record.Id );
                            parentCaseWithQueueId.put( record.Id, record.OwnerId );
                        }
                    } 
                }
            }
            
            String queryStr             =   'SELECT Id,ParentId FROM Case where Id IN :masterCaseIds OR Id IN :childCaseIds OR ParentId IN :masterCaseIds';
            List<Case> childCasesList   =   Database.query( queryStr );
            for( Case cs : childCasesList )
            {
 
                Id tempId   =   parentCaseWithQueueId.containsKey( cs.Id ) ? cs.Id : cs.ParentId ;
                cs.Plan_ID__c =   queueIdWithPlan.get( parentCaseWithQueueId.get( tempId ) );
                cs.OwnerId    =   parentCaseWithQueueId.get( tempId );
                System.debug('Line # 635');
                cs.Plan_Id_Validation_By_Pass__c = False;
                recordsToUpdate.add(cs);
            }
            if(!recordsToUpdate.isEmpty())
            {
                update recordsToUpdate;
            }
        }   
    }
    
    public static void getComments(sObject newObj,sObject oldObj )
    {
        CaseComment CaseComm = (CaseComment)oldObj;
        string parentObjId = CaseComm.ParentId;
    }
    public void validateSupAndPncUser( List<sObject> newList,Map<Id,sObject> oldMap )
    {
        Map<Id,Case> tempOldMap  =   (Map<Id,Case>)oldMap;
        Set<Id> modifiedCaseIds  =   new Set<Id>();
        
        if( UserInfo.getProfileId() != GlobalSettings__c.getValues('PFFileRecieved').Integration_Profile_Id__c )
        {
            for(Case record : (List<Case>)newList )
            {
                if(record.status!=null) {
                    if( record.status.startswith('Closed') )
                    {
                        //PPN-13009 : Supervisor or PNC must change case ownership from queue to themself, prior to closing
                        system.debug('***** profile ***' + currProfile);
                        system.debug('***** queueIdWithPlan ***' + queueIdWithPlan);
                        system.debug('***** ownerId ****' + record.ownerId);
                        
                        if( tempOldMap.get(record.Id).Status != record.Status && queueIdWithPlan.containsKey(record.OwnerId)
                           && (currProfile[0].name.contains('Supervisor') || currProfile[0].name == 'PNC Profile') )
                        {
                            record.addError(Label.SupAndPncUserCaseCloseValidationText);
                        }
                        else if( (UserInfo.getUserId() != record.ownerId) && (currProfile[0].name == 'PNC Profile') )
                        {
                            record.addError(Label.SupAndPncUserCaseCloseValidationText);
                        }
                        else if( !(tempOldMap.get(record.id).status.startswith('Closed')) )
                        {
                            //PPN-7132 : If the case is getting closed, change the owner to the person closing the case
                            record.ownerid = UserInfo.getUserId();  
                        }
                    }
               }
            }
        }
    }
    
    /*********************************************
    * Code to identify whether the new Owner belongs
    * to plan Id queue or Not
    **********************************************/
    public static void validateUserGroup( List<sObject> newList,Map<Id,sObject> oldMap )
    {
        if( UserInfo.getProfileId() != GlobalSettings__c.getValues('PFFileRecieved').Integration_Profile_Id__c && UserInfo.getProfileId() != EnterpriseProfileId )
        {
             /*******************************************************************
             * User story PPN-1645
             * Below code to conolidate the user , user role Id map to validate 
             * wheteher user belongs to specific plan or not
             ********************************************************************/
            roleMap                             =   RoleAndPlanId_Settings__c.getAll();
            Map<String,QueueIds__c> queueMap    =   QueueIds__c.getAll();
            Set<Id> roleIds                     =   new Set<Id>();
            for( RoleAndPlanId_Settings__c record : roleMap.values() )
            {
                roleIdWithPlanMap.put( record.Role_Id__c , record.PlanId__c );
                roleIds.add( record.Role_Id__c );
            }
            
            List<User> userRecords = [Select Id,UserRoleId from User where UserRoleId IN: roleIds ];
            for( User usr: userRecords )
            {
                ownerIdWithRoleIdMap.put( usr.Id,usr.UserRoleId ); 
            }
            
            for(QueueIds__c record : queueMap.values() )
            {
                queueIdWithPlan.put( record.QueueId__c, record.PlanId__c);
            }  
            
        //Edited for PPN-16284
        //Removed CRM from below recordtypeset per PPN-37055
        Set<String> rosterrecordTypeSet  =   new Set<String>{'Master_Mass_Case_IL_Roster','Child_Mass_Case_IL_Roster'};
        for(String rType : rosterrecordTypeSet )
        { 
            if(!recTypeMapbyDeveloperName.isEmpty() && recTypeMapbyDeveloperName.containsKey(rType))
              recordTypeSet.add(recTypeMapbyDeveloperName.get(rType).  Record_type_Id__c);
        }
        //PPN-16284 Ends
        Map<Id,Case> tempOldMap  =   (Map<Id,Case>)oldMap;
        Set<Id> modifiedCaseIds  =   new Set<Id>();
        
            for( Case record :(List<Case>)newList )
            {
                boolean isValidUser  =   true;
                String idPrefix        =   String.valueOf( record.OwnerId ).subString(0,3);
                Set<Id> tempSet        =   planIdWithQueues.get( record.Plan_ID__c );
                System.debug('<!-----------Debugging Starts ----------------->');
                if( ( tempOldMap.get(record.Id).OwnerId != record.OwnerId ) 
                   && idPrefix=='005'
                    &&(!recordTypeSet.contains(record.recordTypeId)) //PPN-16284
                  )
                {              

                if(  roleIdWithPlanMap.get( ownerIdWithRoleIdMap.get(  record.OwnerId ) ) != record.Plan_ID__c )
                        record.addError( Label.OwnerErrorText );
                }else if( ( tempOldMap.get(record.Id).OwnerId != record.OwnerId ) 
                         && idPrefix=='00G'
                         &&(!recordTypeSet.contains(record.recordTypeId)) //PPN-16284
                         && record.get('Status') != 'Escalated'
                         && currProfile[0].name  == 'PNC Profile'
                         &&(!tempSet.contains( record.OwnerId ))
                        )
                {
                    System.debug('In Side validate Queue for PNC');
                    record.addError(Label.CaseQueueText);
                }else if( ( tempOldMap.get(record.Id).Plan_Id__c != record.Plan_Id__c )
                         && supervisorProfiles.contains( currProfile[0].Name ) 
                         && !CASE_ORIGIN.contains(tempOldMap.get(record.Id).Origin)
                         && roleIdWithPlanMap.get( ownerIdWithRoleIdMap.get( record.ownerId ) ) != record.Plan_Id__c
                        )
                {
                    record.addError(Label.PlanIdValidationError);
                }
                
            }
        }       
    }

    //PPN-22088 Changes
    public static void updateNetworkName(List<sObject> newList , Map<Id,Sobject> oldMapList)
    {
        
        Map<Id,Case> oldMap =   (Map<Id,Case>)oldMapList;
        system.debug('oldMap=== '+oldMap);
        Id contractingEditRecTypeId;
        Id contractingRecTypeId;
        Id credentialingRecTypeId;
        Id credentialingEditrecTypeId;
        Id counterSignRecTypeId;
        Id counterSignEditRecTypeId;
        Id ProviderGroupOnBoarding;
               
        if(!recTypeMapbyDeveloperName.isEmpty())
        {
            for( String rtype : recTypeMapbyDeveloperName.keySet() )
            {
                if( rtype == 'Contracting_Provider_On_boarding'){
                    contractingRecTypeId = recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c;
                }
                else if(rtype == 'Provider_On_boarding_Contracting_Edit'){
                    contractingEditRecTypeId = recTypeMapbyDeveloperName.get('Provider_On_boarding_Contracting_Edit').Record_type_Id__c;
                }
                else if(rtype == 'Provider_On_boarding_Credentialing')
                {
                    credentialingRecTypeId = recTypeMapbyDeveloperName.get('Provider_On_boarding_Credentialing').Record_type_Id__c;
                    System.debug('Inside UpdatenetworkName<<<<<===========>>>>>>>>>>Provider On-boarding Credentialing');
                }
                else if(rtype == 'Provider_On_boarding_Credentialing_Edit')
                {
                     System.debug('Inside UpdatenetworkName<<<<<===========>>>>>>>>>>Provider On-boarding Credentialing Edit');
                    credentialingEditrecTypeId = recTypeMapbyDeveloperName.get('Provider_On_boarding_Credentialing_Edit').Record_type_Id__c;
                }
                else if(rtype == 'Provider_On_boarding_Counter_Sign'){
                    counterSignRecTypeId = recTypeMapbyDeveloperName.get('Provider_On_boarding_Counter_Sign').Record_type_Id__c;
                }
                else if(rtype == 'Provider_On_boarding_Counter_Sign_Edit'){
                    counterSignEditRecTypeId = recTypeMapbyDeveloperName.get('Provider_On_boarding_Counter_Sign_Edit').Record_type_Id__c;
                }  
                
                else if(rtype == 'Provider_Group_On_boarding_Network_Load'){
                    ProviderGroupOnBoarding = recTypeMapbyDeveloperName.get('Provider_Group_On_boarding_Network_Load').Record_type_Id__c;
                }  
            } 
        }

        
        for(Case curCase : (List<Case>)newList)
        {
            String str;            
            if(curCase.recordTypeId == contractingRecTypeId 
               || curCase.recordTypeId == credentialingRecTypeId 
               || curCase.recordTypeId == counterSignRecTypeId 
               || curCase.recordTypeId == contractingEditRecTypeId 
               || curCase.recordTypeId == credentialingEditrecTypeId 
               || curCase.recordTypeId == counterSignEditRecTypeId
               || curCase.recordTypeId == ProviderGroupOnBoarding
              ){
                if(curCase.Network_name__c != NULL){
                    system.debug('NetworkName============== '+curCase.Network_name__c+'====>>>>dETAILS '+curCase.Network_Name_Detail__c);
                    for(String s : curCase.Network_name__c.split(';')){
                        str = str != NULL ? str + '\r\n' + s : s;
                    }
                }
                 system.debug('Str======'+str);
                curCase.Network_name_Detail__c = str;
                if(curCase.recordTypeId == contractingEditRecTypeId)
                    curCase.recordTypeId = contractingRecTypeId;
                else if(curCase.recordTypeId == credentialingEditrecTypeId)
                    curCase.recordTypeId = credentialingRecTypeId;
                else if(curCase.recordTypeId == counterSignEditRecTypeId)
                    curCase.recordTypeId = counterSignRecTypeId;
                system.debug('######## Exit updateNetworkName method ######'); 
            }    
                   
        }
    }
    
     //PPN-16712 Changes
       //PPN-16712 Changes
       public static void validateContractingCase( List<sObject> newList,Map<Id,sObject> oldMap )
       {
            Set<Id> parentidset                     =   new set<Id>();
            Map<Id,Boolean>credentialingCloserMap   =   new Map<Id,Boolean>();
            Map<Id, Case> oldMapList                =   (Map<Id, Case>)oldMap;
            Id ContractrecordtypeId;
            Id CredrecordtypeId; 

         if(!recTypeMapbyDeveloperName.isEmpty())
        {
                contractrecordtypeId   =  recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c;
        credrecordtypeId    =  recTypeMapbyDeveloperName.get('Provider_On_boarding_Credentialing').Record_type_Id__c;
        }

            for(Case casenewList : (List<Case>)newList)
            {
                if(casenewList.status != oldMapList.get(casenewList.Id).status 
                   && casenewList.status != 'Closed Rejected' 
                   && casenewList.recordtypeId == ContractrecordtypeId
                  )
                    parentidset.add(casenewList.parentId);
            }
            system.debug('#### parentidset #####' + parentidset);
           if( parentidset.size()>0 && !String.isEmpty(CredrecordtypeId) )
           {
                List<Case> caseList1 = [Select id,status,parentId FROM case WHERE ParentId IN: parentidset AND RecordTypeId =: CredrecordtypeId];
                for(Case cList: caseList1 )
               {
                    if(cList.Status !='Cred Denied' && cList.status !='Cred Approved'){
                        credentialingCloserMap.put(cList.ParentId,true);
                    }
                    else{
                        credentialingCloserMap.put(cList.ParentId,false);
                    }
                }               
           }

            system.debug('#### credentialingCloserMap#####' + credentialingCloserMap);
            for(Case cListNew : (List<Case>)newList)
            {
                if(credentialingCloserMap.containsKey(cListNew.ParentId) && credentialingCloserMap.get(cListNew.ParentId)){
                    cListNew.addError('You cannot change the status.');
                    
                }
            }               

        
    }
    
    /*
    * Author :Gajjala Sujatha
    * Business Purpose: 
    * Date : 16/01/2019
    * StoryBoardNumber ://PPN-22389
    */
    public static Void UpdateProvIdInChildCase(List<sObject> newList, Map<Id, sObject> oldMap)
    {
        Id contractRecordTypeId;
        Set<Id> contractCaseIdSet = new Set<Id>();
        Set<Id> contractCaseAccountIdSet = new Set<Id>();
        Map<Id, String> mapOfAccountandProvId = new Map<Id, String>();
        Map<Id,Case> tempOldMap  =   (Map<Id,Case>)oldMap;      
        List<Provider_Networks__c> provIDUpdateInProviderDetailList = New List<Provider_Networks__c>();        

        for(Case contractCases : (List<Case>)newList){
        
        If(contractCases.accountId!=null)
        {
            if(tempOldMap.get(contractCases.Id).AccountId != contractCases.AccountId ) {
                contractCaseIdSet.add(contractCases.Id);
                contractCaseAccountIdSet.add(contractCases.AccountId);
                }
            }
        }
        if(!contractCaseAccountIdSet.isEmpty())
        {
            for(Account acc : [Select Id, Prov_ID__c from Account where Id IN : contractCaseAccountIdSet]){
                mapOfAccountandProvId.put(acc.Id, acc.Prov_ID__c);
            }
        }
        List<Provider_Networks__c> providerNetworkList  = [Select id,Contracting_Case__c, Credentialing_Case__c, CounterSign__c, Case_Number__c, Contracting_Case__r.AccountId, Credentialing_Case__r.AccountId, CounterSign__r.AccountId, Case_Number__r.AccountId  from Provider_Networks__c where (Contracting_Case__c IN : contractCaseIdSet OR Credentialing_Case__c IN : contractCaseIdSet OR CounterSign__c IN : contractCaseIdSet OR Case_Number__c IN : contractCaseIdSet)];
        system.debug('providerNetworkList'+providerNetworkList);
      //  system.debug(providerNetworkList[0].Contracting_Case__c);
       // system.debug('Set VAlue'+contractCaseIdSet.contains(providerNetworkList [0].Contracting_Case__c));
        for(Provider_Networks__c PD : providerNetworkList){
            if(contractCaseIdSet.contains(PD.Contracting_Case__c)){
                if(mapOfAccountandProvId.containsKey(PD.Contracting_Case__r.AccountId)){
                    Provider_Networks__c UpdatePD = New Provider_Networks__c(Id = PD.Id);
                    UpdatePD.Prov_ID__c = mapOfAccountandProvId.Get(PD.Contracting_Case__r.AccountId);
                    provIDUpdateInProviderDetailList.add(UpdatePd);
                }
            }
            if(contractCaseIdSet.contains(PD.Credentialing_Case__c)){
                if(mapOfAccountandProvId.containsKey(PD.Credentialing_Case__r.AccountId)){
                    Provider_Networks__c UpdatePD = New Provider_Networks__c(Id = PD.Id);
                    UpdatePD.Prov_ID__c = mapOfAccountandProvId.Get(PD.Credentialing_Case__r.AccountId);
                    provIDUpdateInProviderDetailList.add(UpdatePd);
                }
            }
            if(contractCaseIdSet.contains(PD.CounterSign__c)){
                if(mapOfAccountandProvId.containsKey(PD.CounterSign__r.AccountId)){
                    Provider_Networks__c UpdatePD = New Provider_Networks__c(Id = PD.Id);
                    UpdatePD.Prov_ID__c = mapOfAccountandProvId.Get(PD.CounterSign__r.AccountId);
                    provIDUpdateInProviderDetailList.add(UpdatePd);
                }
            }
             if(contractCaseIdSet.contains(PD.Case_Number__c)){
                if(mapOfAccountandProvId.containsKey(PD.Case_Number__r.AccountId)){
                    Provider_Networks__c UpdatePD = New Provider_Networks__c(Id = PD.Id);
                    UpdatePD.Prov_ID__c = mapOfAccountandProvId.Get(PD.Case_Number__r.AccountId);
                    provIDUpdateInProviderDetailList.add(UpdatePd);
                }
            }
        }
        if(!provIDUpdateInProviderDetailList.IsEmpty()){
            try{
                Update provIDUpdateInProviderDetailList;
            }catch(DmlException e)
            {
                system.debug('Exception=='+e.getmessage());
            }
            
            
        }
        
        
       
    }
    // PPN-31363 Ends
     //PPN-20507 & PPN-20508    
     public static Void createGroupContractingCase( List<sObject> newList, Map<Id,sObject> oldMap)
     {
      Id groupPfinRecordTypeId; 
      Id IndvPfinRecordTypeId; 
      Set<Id> pfinCaseIdset                 = new Set<Id>();
      Set<Id> pfinCasesIdswithProvPfin      = new Set<Id>();       
      List<Case> groupcontractingChildcase  = new list<Case>();
      List<Provider_Networks__c> providerNetworkList  = new   List<Provider_Networks__c>();//PPN-39498 
      if(!recTypeMapbyDeveloperName.isEmpty())
        {
            groupPfinRecordTypeId     =  recTypeMapbyDeveloperName.get('Data_Entry_Group_Provider_On_boarding').Record_type_Id__c;
            IndvPfinRecordTypeId    =  recTypeMapbyDeveloperName.get('Data_Entry_Provider_On_boarding').Record_type_Id__c;
        }
          
         
        system.debug('** groupPfinRecordTypeId'+groupPfinRecordTypeId);     
        for(Case pfinCases : (List<Case>)newList ){
            if(pfinCases.RecordTypeId  == groupPfinRecordTypeId && pfinCases.Status == 'Closed Processed' && pfinCases.Completing_the_form_for__c == 'Group'){
                 pfinCaseIdset.add(pfinCases.Id);        
            }  
            else if(pfinCases.RecordTypeId == IndvPfinRecordTypeId && pfinCases.status == 'Closed Processed' && pfinCases.Completing_the_form_for__c == 'Individual'){
                pfinCaseIdset.add(pfinCases.Id); 
            }              
        }
                system.debug('**** pfinCaseIdset***' + pfinCaseIdset);         
        
         if( !pfinCaseIdset.isEmpty() )
         {
            providerNetworkList  = [Select id,PFIN_Case__c,PFIN_onBoarding__c  from Provider_Networks__c where PFIN_Case__c IN : pfinCaseIdset];
            for( Provider_Networks__c pd : providerNetworkList )
            {          
               
                if(pd.PFIN_onBoarding__c == NULL || pd.PFIN_onBoarding__c == '')
                {
                    pfinCasesIdswithProvPfin.add( pd.PFIN_Case__c );               
                }            
            } 
         }
        
        system.debug('**** pfinCasesIdswithProvPfin ***' + pfinCasesIdswithProvPfin);
        for(Case cList : (List<Case>) newList){
            if(providerNetworkList.size() >0 )//PPN-39498 Starts
                {
                    if(pfinCaseIdset.contains(cList.Id) && pfinCasesIdswithProvPfin.contains(cList.Id) ){
                         cList.adderror('Please enter PFIN or/and Prov ID under Provider Detail section before closing the case');
                    }
                }
                else  
                {
                    if(pfinCaseIdset.contains(cList.Id))
                    {
                       cList.adderror('Please enter PFIN or/and Prov ID under Provider Detail section before closing the case'); 
                    }
                }//PPN-39498 Ends
        }
    }
    
     //PPN-22954 starts
     public static Void validateIndividualContractingCase( List<sObject> newList, Map<Id,sObject> oldMap)
     {
      Id contractRecordTypeId;  
      Set<Id> contractCaseIdset             = new Set<Id>();
      Set<Id> contractCasesIdswithProvPfin  = new Set<Id>();       
      List<Case> groupcontractingChildcase  = new list<Case>();
      List<Provider_Networks__c> providerNetworksList = new List<Provider_Networks__c> ();
        if(!recTypeMapbyDeveloperName.isEmpty())
        {
                contractRecordTypeId     =  recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c;
        }
          
        system.debug('** contractRecordTypeId'+contractRecordTypeId);     
        for(Case contractCases : (List<Case>)newList )
        {
            if(contractCases .RecordTypeId  == contractRecordTypeId 
               && contractCases .Status !='New' 
               && contractCases.Completing_the_form_for__c == 'Individual')
            {
                 contractCaseIdset.add(contractCases.Id);        
            }                
        }
        
        if(!contractCaseIdset .isEmpty())
        {
            providerNetworksList = [Select id,Contracting_Case__c  from Provider_Networks__c where 
                                                           Contracting_Case__c IN : contractCaseIdset ];
        }                                                 
         if(!providerNetworksList.isEmpty())
         {
            for(Provider_Networks__c pd : providerNetworksList )
            {          
               contractCasesIdswithProvPfin.add(pd.Contracting_Case__c );               
            } 
         }
            
        system.debug('**** contractCasesIdswithProvPfin ***' + contractCasesIdswithProvPfin);
        for(Case cList : (List<Case>) newList){
            if(contractCaseIdset .contains(cList.Id) && !contractCasesIdswithProvPfin.contains(cList.Id) ){
                 cList.adderror('Please enter PFIN and Prov ID');
            }
        }
    }
  
   
    
    public static boolean profileIsInExclusionList()
    {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        Map<string,CaseOwnerUpdate__c> CaseProfile =CaseOwnerUpdate__c.getAll();
        boolean sProfile = False;
        if(CaseProfile != null && CaseProfile.containsKey(PROFILE[0].Name))
        {
            sProfile = True;
        }
        return sProfile;
    }
    

    public static boolean getCaseStatus(String CaseStatus){                
        Map<string,CaseLockStatus__c> CaseStatusMap =CaseLockStatus__c.getAll();
        boolean sCaseStatus = False;
        if(CaseStatusMap != null && CaseStatusMap.containsKey(CaseStatus)){
            sCaseStatus = True;
        }
        return sCaseStatus;
    }
    /*** PPN-443 Code Starts**/
    public void linkRolodexAccount(List<Case> listOfNewCase)
    {
        List<String> listOfNpiNumbers   =   new List<String>();
        List<String> listOfTaxIds     =   new List<String>();
        List<String> listOfTelephoneNos =   new List<String>();
        List<String> listOfEmailIds   =   new List<String>();
        List<String> listOfSubmitterNames   =   new List<String>();
        List<Case> listOfCaseToLinkRolodex   =   new List<Case>();
        Id onBoardingRecordTypeId;
       
        if(!recTypeMapbyDeveloperName.isEmpty())
        {
                onBoardingRecordTypeId     =  recTypeMapbyDeveloperName.get('Provider_On_boarding').Record_type_Id__c;
        }
        
        for(Case newCase:listOfNewCase)
        {System.debug('Origin='+newCase.origin+'RecordType'+newCase.RecordTypeId+'-');
            if( ( newCase.origin   ==  'Web-Demographics' )
               || ( newCase.Origin  ==  'Web On-boarding' 
                   && newCase.RecordtypeId  ==  onBoardingRecordTypeId )
              )
            {
                listOfCaseToLinkRolodex.add(newCase);
                if(newCase.Tax_Id_Number__c !=NULL && newCase.Tax_Id_Number__c !='')
                {
                    listOfTaxIds.add(newCase.Tax_ID_Number__c);
                }
                if(newCase.Billing_NPI_Number__c !=NULL && newCase.Billing_NPI_Number__c!='')
                {
                    listOfNpiNumbers.add(newcase.Billing_NPI_Number__c);
                }
                if(newCase.Telephone_Number_Submitter__c !=NULL && newCase.Telephone_Number_Submitter__c !='')
                {
                    listOfTelephoneNos.add(newCase.Telephone_Number_Submitter__c);
                }
                if(newCase.Email_Address_Submitter__c !=NULL && newCase.Email_Address_Submitter__c !='')
                {
                    listOfEmailIds.add(newCase.Email_Address_Submitter__c);
                }
                if(newCase.Name_Submitter__c !=NULL && newCase.Name_Submitter__c !='')
                {
                    listOfSubmitterNames.add(newCase.Name_Submitter__c);
                }

            }
        }System.debug('Case'+listOfCaseToLinkRolodex);
        Map<String,Id> MapOfCombinedKeyAndItsAccount = new Map<String,Id>();
        if(!listOfEmailIds.isEmpty() 
           &&  !listOfTelephoneNos.isEmpty() 
           && !listOfSubmitterNames.isEmpty())
        {
            
            for(Account newAccount:[Select Id,NPI__c,Tax_Id__c,lastName,PersonEmail,Phone,Name,FirstName From Account Where RecordType.Name='Rolodex' and 
                NPI__c In:listOfNpiNumbers and Tax_Id__c In:listOfTaxIds and PersonEmail In:listOfEmailIds and Phone In:listOfTelephoneNos and
                lastName In: listOfSubmitterNames /* and firstName In: listOfSubmitterfirstNames */])
        {System.debug('Coming inside for loop');
            String combinedKey = '';
            if(newAccount.Tax_Id__c!=NULL && newAccount.Tax_Id__c!='')
            {
                combinedKey = combinedKey+newAccount.Tax_Id__c+'&';
            }
            if(newAccount.NPI__c !=NULL && newAccount.NPI__c!='')
            {
                combinedKey = combinedKey+newAccount.NPI__c+'&';
            }
            if(newAccount.Phone!=NULL && newAccount.Phone!='')
            {
                combinedKey = combinedKey+newAccount.Phone+'&';
            }
            if(newAccount.PersonEmail !=NULL && newAccount.PersonEmail!='')
            {
                combinedKey = combinedKey+newAccount.PersonEmail+'&';
            }
            if(newAccount.lastName!=NULL && newAccount.lastName!='')
            {
                combinedKey = combinedKey+newAccount.lastName+'&';
            }
            /*  if(newAccount.firstName!=NULL && newAccount.firstName!='')
            {
                combinedKey = combinedKey+newAccount.firstName+'&';
            } */
            if(combinedKey !='')
            {
                mapOfCombinedKeyAndItsAccount.put(combinedKey,newAccount.Id);
            }
        }
        }   
        
        List<Case> listOfCasetoCreateRolodex = new List<Case>();
        for(Case newCase:listOfCaseToLinkRolodex)
        {
            String matchKey = '';
            if(newCase.Tax_Id_Number__c !=NULL && newCase.Tax_Id_Number__c !='')
            {
                matchKey = matchKey+newCase.Tax_Id_Number__c+'&';
            }
            if(newCase.Billing_NPI_Number__c !=NULL && newCase.Billing_NPI_Number__c!='')
            {
                matchKey = matchKey+newCase.Billing_NPI_Number__c+'&';
            }
            if(newCase.Telephone_Number_Submitter__c !=NULL && newCase.Telephone_Number_Submitter__c !='')
            {
                matchKey = matchKey+newCase.Telephone_Number_Submitter__c+'&';
            }
            if(newCase.Email_Address_Submitter__c !=NULL && newCase.Email_Address_Submitter__c !='')
            {
                matchKey = matchKey+newCase.Email_Address_Submitter__c+'&';
            }
            if(newCase.Name_Submitter__c !=NULL && newCase.Name_Submitter__c !='')
            {
                matchKey = matchKey+newCase.Name_Submitter__c+'&';
            }
            /* if(newCase.First_Name_Web__c !=NULL && newCase.First_Name_Web__c !='')
            {
                matchKey = matchKey+newCase.First_Name_Web__c+'&';
            } */
            if(matchKey !='' && mapOfCombinedKeyAndItsAccount.containsKey(matchKey))
            {System.debug('Coming inside if');
            }
            else
            {System.debug('Coming inside else');
                listOfCasetoCreateRolodex.add(newCase);
            }
        }
        System.debug('list '+listOfCasetoCreateRolodex);
        List<Account> listOfAccountToCreate = new List<Account>();
        Map<String,Case> mapOfKeyAndItsCase = new Map<String,Case>();
        Map<String,Account> mapOfKeyAndItsAccount = new Map<String,Account>();
        
        if(!listOfCasetoCreateRolodex.isEmpty())
        {
            for(Case newCase:listOfCasetoCreateRolodex)
            {
                Account newAccount = new Account(  Tax_Id__c   =   newCase.Tax_Id_Number__c,
                                                   NPI__c     =   newCase.Billing_NPI_Number__c,
                                                   phone     =   newCase.Telephone_Number_Submitter__c, 
                                                   personEmail =   newCase.Email_Address_Submitter__c, 
                                                   lastName  =  newCase.Name_Submitter__c,
                                                   //firstName=newCase.First_Name_Web__c,
                                                   RecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rolodex').getRecordTypeId(),
                                                   PersonTitle  =  newCase.Title_Submitter__c,
                                                   CM_Corporate_Entity_Code__c   =   newCase.Plan_ID__c
                                                );
                listOfAccountToCreate.add(newAccount);
                String matchKey = '';
                if(newCase.Tax_Id_Number__c !=NULL && newCase.Tax_Id_Number__c !='')
                {
                    matchKey = matchKey+newCase.Tax_Id_Number__c+'&';
                }
                if(newCase.Billing_NPI_Number__c !=NULL && newCase.Billing_NPI_Number__c!='')
                {
                    matchKey = matchKey+newCase.Billing_NPI_Number__c+'&';
                }
                if(newCase.Telephone_Number_Submitter__c !=NULL && newCase.Telephone_Number_Submitter__c !='')
                {
                    matchKey = matchKey+newCase.Telephone_Number_Submitter__c+'&';
                }
                if(newCase.Email_Address_Submitter__c !=NULL && newCase.Email_Address_Submitter__c !='')
                {
                    matchKey = matchKey+newCase.Email_Address_Submitter__c+'&';
                }
                if(newCase.Name_Submitter__c !=NULL && newCase.Name_Submitter__c !='')
                {
                    matchKey = matchKey+newCase.Name_Submitter__c+'&';
                }
                /* if(newCase.First_Name_Web__c !=NULL && newCase.First_Name_Web__c !='')
                {
                    matchKey = matchKey+newCase.First_Name_Web__c+'&';
                } */
                if(matchKey !='')
                {
                    mapOfKeyAndItsCase.put(matchKey,newCase);
                }
            }System.debug('List of account'+listOfAccountToCreate);
            if(!listOfAccountToCreate.isEmpty())
            insert listOfAccountToCreate;
        }     
    }
    /*** PPN-443 Code Ends**/ 
    /*** PPN-22418 Code Starts **/
    
    public void linkExistingEntityAccount(List<Case> listOfNewCase)
    {
        List<String> listOfNpiNumbers = new List<String>();
        List<String> listOfTaxIds = new List<String>();
        Map<String,Case>mapOfKeyAndItsCase = new Map<String,Case>();
        for(Case newCase:listOfNewCase)
        {
            if(newCase.Billing_NPI_Number__c!=NULL && newCase.Billing_NPI_Number__c!='')
            {
                listOfNpiNumbers.add(newCase.Billing_NPI_Number__c);
            }
            if(newCase.Tax_ID_Number__c !=NULL && newCase.Tax_ID_Number__c!='')
            {
                listOfTaxIds.add(newCase.Tax_ID_Number__c);
            }
            mapOfKeyAndItsCase.put(newCase.Billing_NPI_Number__c+'&'+newCase.Tax_ID_Number__c,newCase);
        }
        Map<Id,List<String>>mapOfAccountIdAndItsTaxId = new Map<Id,List<String>>();
        Set<Id> setOfEntities = new Set<Id>();
        if( !listOfTaxIds.isEmpty() )
        {
            for(CM_Provider_Tax_Id__c newTaxId  :  [Select CM_PTI_Prov_Name_From__c,CM_PTI_Prov_Name_From__r.isPersonAccount,
                                                     CM_PTI_Tax_Id__c From CM_Provider_Tax_Id__c Where CM_PTI_Tax_Id__c In:listOfTaxIds ])
            {
                listOfTaxIds = new List<String>();
                if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL && mapOfAccountIdAndItsTaxId.containsKey(newTaxId.CM_PTI_Prov_Name_From__c))
                {
                    listOfTaxIds = mapOfAccountIdAndItsTaxId.get(newTaxId.CM_PTI_Prov_Name_From__c);
                }
                if(newTaxId.CM_PTI_Prov_Name_From__c !=NULL)
                {
                    listOfTaxIds.add(newTaxId.CM_PTI_Tax_Id__c);
                    mapOfAccountIdAndItsTaxId.put(newTaxId.CM_PTI_Prov_Name_From__c,listOfTaxIds);
                    if(!newTaxId.CM_PTI_Prov_Name_From__r.isPersonAccount)
                    {
                        setOfEntities.add(newTaxId.CM_PTI_Prov_Name_From__c);
                    }
                }
            }
        }
        Map<Id,List<String>>mapOfAccountIdAndItsNPI = new Map<Id,List<String>>();
        if(!listOfNpiNumbers.isEmpty())
        {
            for(CM_Provider_Identification__c newIdentification : [Select CM_Issu_Ident_Nmbr__c,CM_PI_Prov__r.isPersonAccount,CM_PI_Prov__c,
                                                               CM_Prvdr_Iden_Typ_Cd__c From CM_Provider_Identification__c Where 
                                                               CM_Issu_Ident_Nmbr__c In:listOfNpiNumbers and CM_Prvdr_Iden_Typ_Cd__c ='NPI' ])
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
                    if(!newIdentification.CM_PI_Prov__r.isPersonAccount)
                    {
                        setOfEntities.add(newIdentification.CM_PI_Prov__c);
                    }
                }    
            }
        }
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
                            mapOfKeyAndItsId.put(npiNo+'&'+taxNo,newId);
                        }
                    }
                }
            }
        }
        for(Case newCase:listOfNewCase)
        {
            if( newCase.Billing_NPI_Number__c!=NULL 
                && newCase.Billing_NPI_Number__c!='' 
                && newCase.Tax_ID_Number__c !=NULL 
                && newCase.Tax_ID_Number__c!=''
              )
            {
                if(!mapOfKeyAndItsId.isEmpty()){
                    if(setOfEntities.contains(mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'&'+newCase.Tax_ID_Number__c)))
                    {
                        newCase.Case_Entity__c=mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'&'+newCase.Tax_ID_Number__c);
                    }
                    else
                    {
                        newCase.AccountId=mapOfKeyAndItsId.get(newCase.Billing_NPI_Number__c+'&'+newCase.Tax_ID_Number__c);
                    }
                }
            }
        }
            
    }
    /** PPN-22418 Code Ends **/
    
    /** PPN-21154 Code Starts 
        PPN - 39167 -Group On boarding - 90 days wait for cred case in case of App Returned and Admin Denial status
    **/
    public void updateMasterCaseForGroup (List<Case> listOfNewCase,  Map<id, sObject> OldMapCaseValues)
    {
        System.debug('Coming inside updateMasterCaseForGroup ');
        Map<Id,List<Id>> mapOfParentAndItsProviderTotal     =   new Map<Id,List<Id>>();
        Map<Id,List<Id>> mapOfParentAndItsProviderApproved  =   new Map<Id,List<Id>>();
        Id NetworkTypeId,ContractTypeId,CredentialingTypeId, FacilityTypeId, AncillaryTypeId;
        Map<Id,Case> oldMap  =   (Map<Id,Case>)OldMapCaseValues;
       
        
        credentialingTypeId         =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
        networkTypeId               =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
        contractTypeId              =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeId();
        FacilityTypeId              =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing_Facility').getRecordTypeId();
        AncillaryTypeId             =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing_Ancillary').getRecordTypeId();
        
        List<Id> listOfParentCases  =   new List<Id>();
        List<Case> listOfCaseToUpdate   =   new List<Case>();
        for(Case newCase:listOfNewCase)
        {
            if((newCase.RecordTypeId == networkTypeId || newCase.RecordTypeId == credentialingTypeId || newCase.RecordTypeId == FacilityTypeId || newCase.RecordTypeId == AncillaryTypeId) 
               && (newCase.Completing_the_form_for__c == 'Group' || newCase.Completing_the_form_for__c == 'Facility' || newCase.Completing_the_form_for__c == 'Ancillary')
              )
            {
                listOfCaseToUpdate.add(newCase);
                listOfParentCases.add(newCase.ParentId);
            }
        }
        Map<Id,Boolean> mapOfParentIdAndProviderUpdated     =   new Map<Id,Boolean>();
        Map<Id,Boolean> mapOfParentIdAndCredentialingUpdated   =   new Map<Id,Boolean>();
        Map<Id,Boolean> mapOfParentIdAndNetworkUpdated       =   new Map<Id,Boolean>();
        Map<Id,Id> mapOfParentIdAndItsContractCase         =   new Map<Id,Id>();
        Set<Id> setOfParentIds                   =   new Set<Id>();
        if(!listOfParentCases.isEmpty() && networkTypeId!=null )
        {           
           for(Case newCase : [Select Id,ParentId,status,Completing_the_form_for__c From Case Where ParentId 
                               In:listOfParentCases and recordTypeId=:networkTypeId])
           {
               if(newCase.Status=='Closed Processed' && newCase.Completing_the_form_for__c=='Group')
               {
                   mapOfParentIdAndNetworkUpdated.put(newCase.parentId,true);
                   System.debug('### Inside If block - network '+newCase.ParentId);
               }
               else
               {
                   System.debug('### Inside Else block - network '+newCase.ParentId);
                   setOfParentIds.add(newCase.ParentId);
                   mapOfParentIdAndNetworkUpdated.put(newCase.ParentId,false);
               }
           } 
        }
        
        
        
        if(!listOfParentCases.IsEmpty() && (CredentialingTypeId!=null || FacilityTypeId != null || AncillaryTypeId != null))
        {
            for(Case newCase:[ Select Id,ParentId,status, Check_for_90_days__c From Case Where ParentId In:listOfParentCases and (recordTypeId=:CredentialingTypeId OR recordTypeId=:FacilityTypeId OR recordTypeId=:AncillaryTypeId )])
            {
                if(newCase.status=='Cred Approved' || newCase.status=='Provisionally Approved' || newCase.status == 'Delegated'  || newCase.status == 'Credentialing Not Required')
                {
                    mapOfParentIdAndCredentialingUpdated.put(newCase.ParentId,true);
                }
                else if((newCase.status=='Cred Denied' ||  (newCase.status == 'Admin Denial' && newCase.Check_for_90_days__c ) || 
                        ( newCase.status == 'Application Returned' && newCase.Check_for_90_days__c )) 
                             && !mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId) ) // PPN - 39167       
                {
                    mapOfParentIdAndCredentialingUpdated.put(newCase.ParentId,false);
                }
                else if((!mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId)) || (newCase.status!='Cred Approved' && newCase.status!='Provisionally Approved'  && newCase.status == 'Credentialing Not Required'
                && newCase.status!='Cred Denied' && newCase.status != 'Delegated' &&  !newCase.Check_for_90_days__c  ))
                {
                    system.debug('credentialing '+newCase.parentId+'-'+newCase.status);
                    system.debug('credentialing Id'+newCase.Id+'-'+newCase.status);
                    system.debug('credentialing 90days'+newCase.Check_for_90_days__c+'-'+newCase.status);
                    setOfParentIds.add(newCase.ParentId);
                }
            }
        }
        if( !listOfParentCases.isEmpty() && contractTypeId!=null )
        {
            for(Provider_Networks__c newNetwork:[Select Cred_Status__c,Contracting_Case__r.parentId,Contracting_Case__r.status,
                                             contracting_Case__c From Provider_Networks__c where Contracting_Case__r.ParentId In:listOfParentCases 
                                             and Contracting_Case__r.recordTypeId=:contractTypeId ])
        {
            if(newNetwork.Cred_Status__c !='' && newNetwork.Cred_Status__c!=NULL)
            {
                mapOfParentIdAndItscontractCase.put(newNetwork.Contracting_Case__r.parentId,newNetwork.Contracting_Case__c);
                mapOfParentIdAndProviderUpdated.put(newNetwork.Contracting_case__r.parentId,true);
            }
            else
            {
                System.debug('contracting '+newNetwork.Contracting_case__r.parentId);
                setOfParentIds.add(newNetwork.Contracting_case__r.parentId);
                mapOfParentIdAndProviderUpdated.put(newNetwork.Contracting_case__r.parentId,false);
            }
        }
        }
        
        List<Case> listOfCasetoApproveUpdates = new List<Case>();
        List<Case> listOfCasetoDeniedUpdates = new List<Case>();
        Set<Id> setOfUniqueIds = new Set<Id>();
        system.debug('*** mapOfParentIdAndNetworkUpdated ***' + mapOfParentIdAndNetworkUpdated);
        system.debug('*** mapOfParentIdAndProviderUpdated ***' + mapOfParentIdAndProviderUpdated);
        system.debug('*** mapOfParentIdAndCredentialingUpdated ***' + mapOfParentIdAndCredentialingUpdated);
        system.debug('#### setOfParentIds ####' + setOfParentIds);   
        for(Case newCase:listOfCaseToUpdate)
        {
            system.debug('#### Inside For loop ###');
            if(!setOfParentIds.contains(newCase.ParentId))
            {
                System.debug('### 1'+newCase.ParentId+'-'+mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId));
                System.debug('### 2'+mapOfParentIdAndNetworkUpdated.containsKey(newCase.ParentId));
                System.debug('### 3'+mapOfParentIdAndProviderUpdated.containsKey(newCase.parentId));
                Case newCaseUpdate = new Case(id=newCase.ParentId);
                if((mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId) && mapOfParentIdAndCredentialingUpdated.get(newCase.ParentId)) 
                && (mapOfParentIdAndNetworkUpdated.containsKey(newCase.parentId) && mapOfParentIdAndNetworkUpdated.get(newCase.ParentId))
                && (mapOfParentIdAndProviderUpdated.containsKey(newCase.ParentId) && mapOfParentIdAndProviderUpdated.get(newCase.parentId)))               
                {
                System.debug('First if');
                    Case newContractCase = new Case(id=mapOfParentIdAndItscontractCase.get(newCase.parentId));
                    listOfCasetoApproveUpdates.add(newContractCase);
                    listOfCasetoApproveUpdates.add(newCaseUpdate);
                }
                else if(mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId) && mapOfParentIdAndCredentialingUpdated.get(newCase.ParentId)
                && mapOfParentIdAndProviderUpdated.containsKey(newCase.parentId) && mapOfParentIdAndProviderUpdated.get(newCase.parentId)
                && !mapOfParentIdAndProviderUpdated.containsKey(newCase.parentId))
                {
                System.debug('Second if');
                    if(mapOfParentIdAndItscontractCase.containsKey(newCase.ParentId))
                    {                
                        Case newContractCase = new Case(id=mapOfParentIdAndItscontractCase.get(newCase.parentId));
                        listOfCasetoApproveUpdates.add(newContractCase);
                    }
                    listOfCasetoApproveUpdates.add(newCaseUpdate);
                }
                else if((mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId) && !mapOfParentIdAndCredentialingUpdated.get(newCase.ParentId))
                && ((mapOfParentIdAndProviderUpdated.containsKey(newCase.parentId) && mapOfParentIdAndProviderUpdated.get(newCase.parentId))
                || (!mapOfParentIdAndProviderUpdated.containsKey(newCase.parentId))))
                {
                System.debug('Third if');
                    if(mapOfParentIdAndItscontractCase.containsKey(newCase.ParentId))
                    {
                        Case newContractCase = new Case(id=mapOfParentIdAndItscontractCase.get(newCase.parentId));
                        listOfCasetoDeniedUpdates.add(newContractCase);
                    }
                    listOfCasetoDeniedUpdates.add(newCaseUpdate);                    
                }
                else if(mapOfParentIdAndCredentialingUpdated.isEmpty() 
                && (mapOfParentIdAndNetworkUpdated.containsKey(newCase.parentId) && mapOfParentIdAndNetworkUpdated.get(newCase.ParentId))
                && (mapOfParentIdAndProviderUpdated.containsKey(newCase.ParentId) && mapOfParentIdAndProviderUpdated.get(newCase.parentId)))               
                {
                    System.debug('Fourth if');
                    Case newContractCase = new Case(id=mapOfParentIdAndItscontractCase.get(newCase.parentId));
                    listOfCasetoApproveUpdates.add(newContractCase);
                    listOfCasetoApproveUpdates.add(newCaseUpdate);
                }
                else if(mapOfParentIdAndProviderUpdated.isEmpty()
                && (mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId) && mapOfParentIdAndCredentialingUpdated.get(newCase.ParentId)))
                {
                    System.debug('Fifth if');
                    listOfCasetoApproveUpdates.add(newCaseUpdate);
                }
                else if(mapOfParentIdAndProviderUpdated.isEmpty()
                && (mapOfParentIdAndCredentialingUpdated.containsKey(newCase.ParentId) && !mapOfParentIdAndCredentialingUpdated.get(newCase.ParentId)))
                {
                    System.debug('Fifth if');
                   
                    listOfCasetoDeniedUpdates.add(newCaseUpdate);
                     System.debug('listOfCasetoDeniedUpdates'+listOfCasetoDeniedUpdates);
                }
                
                
            }
        }
        System.debug('Approved'+listOfCasetoApproveUpdates);
        System.debug('Denied'+listOfCasetoDeniedUpdates);
       // List<Case> listOfFinalCase = new List<Case>();//Commented by u393129
        Map<Id,Case> listOfFinalCase = new Map<Id,Case>();
        for(Case caseToUpdate:listOfCasetoApproveUpdates)
        {
            casetoUpdate.status='Closed Processed';
            //listOfFinalCase.put(casetoUpdate.Id,caseToUpdate);//Commented by u393129
            listOfFinalCase.put(casetoUpdate.Id,caseToUpdate);
        }
        for(Case caseToUpdate:listOfCasetoDeniedUpdates)
        {
            casetoUpdate.status='Closed Rejected';
            casetoUpdate.skipILRoster__c = true;            
            //listOfFinalCase.add(casetoUpdate);  //Commented by u393129     
            listOfFinalCase.put(casetoUpdate.Id,caseToUpdate);     
        }
        for(Case newCase:[Select Id,status from Case Where ParentId in:listOfCasetoDeniedUpdates and RecordType.DeveloperName='Provider_Group_On_boarding_Counter_Sign' and isClosed = false])
        {
            newCase.status='Closed Rejected';
            newCase.skipILRoster__c = true;
           // listOfFinalCase.add(newCase);    //Commented by u393129  
           listOfFinalCase.put(newCase.Id,newCase);   
        }
        //Added try catch block 
        if(listOfFinalCase.size()>0)
            try{
                 update listOfFinalCase.values();
            }catch(DmlException e)
            {
                system.debug('Exception=='+e.getMessage());
            }
        
       
        
    }
    /** PPN-21154 Code Ends **/

/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Subhashini             03/19/2019             PPN-30306 ValidateDuplicateCredentialingCase
   Subhashini            05/02/2019              PPN - 35968 Validate DOB for Provider Account                
*/ 
  Public static Void ValidateDuplicateCredentialingCase(List<sObject> newList, Map<Id, sObject> OldMapCaseValues)
     {
        Set<String> setOfContractCase = new Set<String>();
        Set<String> setOfAccount = new Set<String>();
        Set<String> setOfAccountWithoutNPI = new Set<String>();
         Map<Id,Case> oldMap  =   (Map<Id,Case>)OldMapCaseValues;
        Map <Id, Id> mapofContractCaseAndAccount =new Map<Id, Id>();
        Id physicianId,entityId; 
        Id IndvContractRecordTypeId;
        Id IndvCredRecordTypeId;
        Id groupCredRecordTypeId;
        Id ManualgroupCredRecordTypeId;
        Map<Id, String> mapofAccountAndDOB = new Map<Id, String>();
        List<CM_Provider_Identification__c> lstAccoutNPI = new List<CM_Provider_Identification__c>();
          physicianId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();        
        if(!recTypeMapbyDeveloperName.isEmpty())
        {
            IndvContractRecordTypeId = recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c;
            IndvCredRecordTypeId = recTypeMapbyDeveloperName.get('Provider_On_boarding_Credentialing').Record_type_Id__c;
            groupCredRecordTypeId = recTypeMapbyDeveloperName.get('Provider_Group_On_boarding_Credentialling').Record_type_Id__c;
            ManualgroupCredRecordTypeId = recTypeMapbyDeveloperName.get('Provider_Manual_Group_On_boarding_Credentialling').Record_type_Id__c;
        }
        for(Case contractCase : (List<Case>)newList)
            {
                                
                if(contractCase.Status == 'Needs Credentialing' && contractCase.AccountId != NULL && contractCase.RecordTypeId == IndvContractRecordTypeId){
                    
                    setOfAccount.add(contractCase.AccountId);
                    system.debug('setOfAccount'+ setOfAccount);
                }
            }
            if(!setOfAccount.isEmpty())
            {
                for(Case credCase : [SELECT ID, ACCOUNTID,  Account.Prov_ID__c , Account.Date_of_Birth__c, STATUS, ISCLOSED  FROM CASE WHERE ACCOUNTID IN : setOfAccount AND (ISCLOSED = FALSE OR (STATUS IN('Admin Denial' , 'Application Returned') AND   Check_for_90_days__c = FALSE) )  AND (RecordTypeId = : IndvCredRecordTypeId OR RecordTypeId = : groupCredRecordTypeId OR RecordTypeId = : ManualgroupCredRecordTypeId)])
                {
                    if(credCase.AccountId != NULL)
                    {
                        
                        if(!mapofContractCaseAndAccount.containsKey(credCase.Id))
                        {
                            mapofContractCaseAndAccount.put(credCase.AccountId, credCase.Id);
                            
                        }              
                    }
                }
             }
            if(!setOfAccount.iSEmpty())
            {
                
                for(Account accountToVerify : [Select Id, Name, Prov_Id__c, Date_of_Birth__c From Account where  RecordTypeId =: physicianId and Id  IN : setOfAccount ])
                {
                    if(accountToVerify.Id != NULL)    {
                           mapofAccountAndDOB.put(accountToVerify.Id, String.valueOf(accountToVerify.Date_of_Birth__c));
                     }
                }
            }
            if(!setOfAccount.iSEmpty())
            {
               // lstAccoutNPI =[select Id,  CM_Prvdr_Iden_Typ_Cd__c, CM_Issu_Ident_Nmbr__c, CM_PI_Prov__c, CM_PI_Prov__r.Prov_ID__c From CM_Provider_Identification__c where CM_PI_Prov__c IN : setOfAccount AND (CM_Prvdr_Iden_Typ_Cd__c =: 'License' OR  CM_Prvdr_Iden_Typ_Cd__c =: 'NPI') AND (CM_Issu_Ident_Nmbr__c != '' OR CM_Issu_Ident_Nmbr__c != NULL)];
                for(CM_Provider_Identification__c actNPI : [select Id,  CM_Prvdr_Iden_Typ_Cd__c, CM_Issu_Ident_Nmbr__c, CM_PI_Prov__c, CM_PI_Prov__r.Prov_ID__c From CM_Provider_Identification__c where CM_PI_Prov__c IN : setOfAccount AND (CM_Prvdr_Iden_Typ_Cd__c =: 'License' OR  CM_Prvdr_Iden_Typ_Cd__c =: 'NPI') AND (CM_Issu_Ident_Nmbr__c != '' OR CM_Issu_Ident_Nmbr__c != NULL)])
                {
                    setOfAccountWithoutNPI.add(actNPI.CM_PI_Prov__c ); 
                }
            }
            system.debug('mapofContractCaseAndAccount'+mapofContractCaseAndAccount);
            for(Case contractCaseToValidate : (List<Case>)newList)
            {
            system.debug('mapofContractCaseAndAccount'+mapofContractCaseAndAccount);
                system.debug('contractCaseToValidate.AccountId'+contractCaseToValidate.AccountId);
                system.debug('Cred case creatioon'+ mapofAccountAndDOB);
                if(contractCaseToValidate.Status == 'Needs Credentialing' &&  ((oldMap == NULL || oldMap.isEmpty()) || (oldMap != NULL && oldMap.get(contractCaseToValidate.Id).Status != contractCaseToValidate.Status)) && contractCaseToValidate.AccountId != NULL && mapofContractCaseAndAccount.ContainsKey(contractCaseToValidate.AccountId) && contractCaseToValidate.RecordTypeId == recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c )
                {
                     system.debug('contractCaseToValidate'+contractCaseToValidate.Id);
                     contractCaseToValidate.adderror('Duplicate credentialing case in existence for the entered Prov ID');
                     
                }
                
                if(contractCaseToValidate.Status == 'Needs Credentialing' && contractCaseToValidate.AccountId != NULL && mapofAccountAndDOB.ContainsKey(contractCaseToValidate.AccountId) )
                {
                    if((mapofAccountAndDOB.get(contractCaseToValidate.AccountId)) == null || (mapofAccountAndDOB.get(contractCaseToValidate.AccountId) == '') )
                    {
                        contractCaseToValidate.adderror('DOB missing for Account. Please update the DOB for provider to create the credentialing case '  );
                    }
                }
                if(!setOfAccountWithoutNPI.isEmpty())
                {
                    if(contractCaseToValidate.Status == 'Needs Credentialing'  && contractCaseToValidate.AccountId != NULL  && (setOfAccountWithoutNPI.size() != setOfAccount.size()))
                    {
                        contractCaseToValidate.adderror('NPI/License # missing for account. Please update at least one of the following NPI/License # for provider to create the credentialing case');
                    }
                }
                if(setOfAccountWithoutNPI.isEmpty() )
                {
                    if(contractCaseToValidate.Status == 'Needs Credentialing'  && contractCaseToValidate.AccountId != NULL  )
                    {
                        contractCaseToValidate.adderror('NPI/License # missing for account. Please update at least one of the following NPI/License # for provider to create the credentialing case');
                    }
                }
                
                
            }
            
    }

    /*
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    -----------------------------------------------------------------------------                 
    * Subhashini             03/11/2019             PPN-31082 ValidateProvIdInGroupNetwork
    */  

 public static Void ValidateProvIdInGroupNetwork(List<sObject> newList, Map<Id, sObject> oldMap)
    {
            Id physicianId,entityId;
            Boolean isAvailable = false ;
            map<string,boolean> mapNetworkProvid  = new Map<string, boolean>();
            Set<String> setOfProvId = new Set<String>();
            system.debug('Coming inside before update');
            physicianId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Physician').getRecordTypeId();//PPN-37116
            entityId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Entity_Account').getRecordTypeId();//PPN-37116

            
            for(Case networkCase : (List<Case>)newList)
            {
                if(networkCase.Prov_ID__c!= NULL &&  networkCase.RecordTypeId == recTypeMapbyDeveloperName.get('Provider_Group_On_boarding_Network_Load').Record_type_Id__c){
                    setOfProvId.add(networkCase.Prov_ID__c);
                }
            }
            if(!setOfProvId.isEmpty())
            {
                for(Account accountToVerify : [Select Id, Name, Prov_Id__c From Account where (RecordTypeId =: entityId OR RecordTypeId =: physicianId) and 
                                               Prov_Id__c  IN : setOfProvId])
                {
                      mapNetworkProvid.put(accountToVerify.Prov_Id__c , true);
                }
             }
            for(Case networkCase : (List<Case>)newList)
            {
                if(networkCase.Prov_ID__c!= NULL &&  networkCase.RecordTypeId == recTypeMapbyDeveloperName.get('Provider_Group_On_boarding_Network_Load').Record_type_Id__c && !mapNetworkProvid.containsKey(networkCase.Prov_ID__c)){
                     networkCase .adderror('Please enter the valid 9 digit Prov ID');
                }
            }
            
      }
            




    /*
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    -----------------------------------------------------------------------------                 
    * Laxman Vattam             01/29/2019             PPN-30575 UPdate Account on Network Load Cases
    */     
    public void updateAccountOnNetworkLoadCases( List<sObject> newList,Map<Id,SObject> oldMap )
    {
        System.debug('updateAccountOnNetworkLoadCases:Start');
        Map<Id,Case> oldMap1    =   new Map<Id,Case>();        
        if( oldMap.size()>0 )
        {            
            oldMap1     =   (Map<Id,Case>)oldMap;
        }
        
        List<Case>   newList1               =  (List<Case>)newList;
        Set<String> provIdSet               =  new Set<String>();
        Set<Id>     acctIdSet               =  new Set<Id>();
        Map<String,Account> provIdAcctMap   =  new Map<String,Account>();
        List<Account> accountsToUpdate      =  new List<Account>();
        Set<Id> individualCredCaseIds       =  new Set<Id>();
        map<Id,String> caseIdwithProvIdMap  =  new Map<Id,String>();
        Set<Id> recordTypeIdSet             =  new Set<Id>();
        //PPN-37201-Sujatha Starts
        for( Case csRecord : newList1 )
        {
            //system.debug('csRecord.RecordTypeId:' + csRecord.RecordTypeId);
            
           // system.debug('csRecord.Completing_the_form_for__c:' + csRecord.Completing_the_form_for__c);
            if(recTypeMapbyDeveloperName.containskey('Provider_Group_On_boarding_Network_Load')  &&  
              recTypeMapbyDeveloperName.containskey('Network_Load') &&             
                (csRecord.RecordTypeId == recTypeMapbyDeveloperName.get('Provider_Group_On_boarding_Network_Load').Record_type_Id__c ||
                csRecord.RecordTypeId == recTypeMapbyDeveloperName.get('Network_Load').Record_type_Id__c)
               && !String.isEmpty( csRecord.Prov_ID__c ) 
               && csRecord.Completing_the_form_for__c == 'Group'
              )
            {
                provIdSet.add( csRecord.Prov_ID__c);
            }
           // system.debug('provIdSet:' + provIdSet);
        }
        //PPN-37201-Sujatha ends
        
            if( !provIdSet.isEmpty() )
            {
                provIdAcctMap   =   getAcctIdByProvId(provIdSet);
                system.debug('provIdAcctMap:' + provIdAcctMap);
                if(!provIdAcctMap.isEmpty())
                {
                    System.debug('newList1 +++++'+newList1.size());
                    System.debug('provIdAcctMap+++++'+provIdAcctMap);
                    for( Case cRecord : newList1 )
                    {
                        system.debug('cRecord.Id:' + cRecord.Id + 'cRecord.Prov_ID__c+++'+cRecord.Prov_ID__c);
                        if( String.isNotEmpty( cRecord.Prov_ID__c) 
                           && provIdAcctMap.containsKey( cRecord.Prov_ID__c) 
                           && cRecord.Completing_the_form_for__c  ==  'Group'
                           && provIdAcctMap.get(cRecord.Prov_ID__c) != null
                          )
                        {
                            //system.debug('cRecord.Prov_ID__c11+++'+cRecord.Prov_ID__c);
                            //system.debug('xxxx:' + provIdAcctMap.get(cRecord.Prov_ID__c).Id);
                            cRecord.AccountId  =   provIdAcctMap.get(cRecord.Prov_ID__c).Id;
                        }
                    }
                }   
            }
        
        System.debug('updateAccountOnNetworkLoadCases:End');
    }
    /*
     * PPN-25402
     * Group flow: Cred status update on a physician account will be updated based on Prov id on credentialing case
     * Individual flow : Cred status on physician will be updated based on the prov Id available on Provider details object 
     * associated to a credentialing case
     */
    public void updatePhysicianAcctOnGroupCredCase( List<sObject> newList,Map<Id,SObject> oldMap )
    {
        System.debug('inside update Physician Account====>>>>'+newList);
        Map<Id,Case> oldMap1    =   new Map<Id,Case>();
        
        if( oldMap.size()>0 )
        {
            oldMap1     =   (Map<Id,Case>)oldMap;
        }
        List<Case>   newList1               =   (List<Case>)newList;
        Set<String> provIdSet               =   new Set<String>();
        Set<Id>     acctIdSet               =   new Set<Id>();
        Map<String,Account> provIdAcctMap   =   new Map<String,Account>();
        List<Account> accountsToUpdate      =   new List<Account>();
        Set<Id> individualCredCaseIds    =  new Set<Id>();
        //Map<Id,RecordType> recordTypeMap   =   new Map<Id,RecordType>([Select Id,Name,DeveloperName from RecordType where DeveloperName IN:recTypeSet]);
        map<Id,String> caseIdwithProvIdMap    =  new Map<Id,String>();
        Set<Id> recordTypeIdSet        =  new Set<Id>();
        
        If(!recTypeMapbyDeveloperName.isEmpty())
        {
            recordTypeIdSet.add(recTypeMapbyDeveloperName.get('Provider_On_boarding_Credentialing').Record_type_Id__c);
            recordTypeIdSet.add(recTypeMapbyDeveloperName.get('Provider_Group_On_boarding_Credentialling').Record_type_Id__c);
        }
        
        if(oldMap1.IsEmpty())
        {
          for( Case csRecord : newList1 )
            {
                if( recordTypeIdSet.contains( csRecord.RecordTypeId )
                    && !String.isEmpty( csRecord.Contract_ProvID__c ) 
                    && csRecord.Completing_the_form_for__c == 'Group'
                  )
                {
                    provIdSet.add( csRecord.Contract_ProvID__c );
                }
            }  
        }else {
            for( Case csRecord : newList1 )
            {
               System.debug('inside update Physician Account11111====>>>>'+newList1);
                System.debug(csRecord.RecordTypeId+'inside update Physician Account22222====>>>>'+recordTypeIdSet);
                System.debug(csRecord.Completing_the_form_for__c+'inside update Physician Account3333====>>>>'+oldMap1.get(csRecord.Id).Status+'======>>>'+ csRecord.Status);
                if( recordTypeIdSet.contains( csRecord.RecordTypeId )
                   && !String.isEmpty( csRecord.Contract_ProvID__c ) 
                   && csRecord.Completing_the_form_for__c == 'Group'
                   && oldMap1.get(csRecord.Id).Status != csRecord.Status
                  )
                {
                    provIdSet.add( csRecord.Contract_ProvID__c );
                }else if( recordTypeIdSet.contains( csRecord.RecordTypeId )
                   && csRecord.Completing_the_form_for__c == 'Individual'
                   && oldMap1.get(csRecord.Id).Status != csRecord.Status )
                {
                     System.debug('inside update Physician Account33333====>>>>'+csRecord.Status);
                    individualCredCaseIds.add( csRecord.Id );
                }
                
                if( recordTypeIdSet.contains( csRecord.RecordTypeId )
                   && !String.isEmpty( csRecord.Contract_ProvID__c ) 
                   && csRecord.Completing_the_form_for__c == 'Group'
                   && oldMap1.get(csRecord.Id).AccountId != csRecord.AccountId
                  )
                {
                      acctIdSet.add( csRecord.AccountId );
                }
            } 
        }
        
        System.debug('individualCredCaseIds====>>>'+individualCredCaseIds);
        if(!individualCredCaseIds.isEmpty())
        {
            List<Provider_Networks__c> providerNetworkList  = [Select Id,Credentialing_Case__c,Prov_ID__c from Provider_Networks__c where Credentialing_Case__c IN:individualCredCaseIds];
            if(!providerNetworkList.isEmpty())
            {
                for( Provider_Networks__c provNetwork :  providerNetworkList )
                {
                    provIdSet.add(provNetwork.Prov_ID__c);
                    caseIdwithProvIdMap.put( provNetwork.Credentialing_Case__c,provNetwork.Prov_ID__c);
                }
            }
        }
        
        // Below code when ProvId on credentiling case and Associated AccountName ProvId both are same
        if( !provIdSet.isEmpty() )
         {
                provIdAcctMap   =   getAcctIdByProvId(provIdSet);
                if(!provIdAcctMap.isEmpty())
                {
                    for( Case csRecord : newList1 )
                    {
                        //System.debug('provIdAcctMap.get(csRecord.Contract_ProvID__c).RecordType.developerName======>>>>>>'+provIdAcctMap.get(csRecord.Contract_ProvID__c).RecordType.developerName);
                        if( String.isNotEmpty( csRecord.Contract_ProvID__c ) 
                           && provIdAcctMap.containsKey( csRecord.Contract_ProvID__c) 
                           && provIdAcctMap.get(csRecord.Contract_ProvID__c).RecordType.developerName == 'Physician'
                           && csRecord.Completing_the_form_for__c  ==  'Group'
                          )
                        {
                            csRecord.AccountId  =   provIdAcctMap.get( csRecord.Contract_ProvID__c ).Id;
                            Account acct        =   new Account( Id = provIdAcctMap.get( csRecord.Contract_ProvID__c ).Id); 
                            acct.Cred_Status__c =   csRecord.Status;
                            accountsToUpdate.add( acct );
                        }else if( !caseIdwithProvIdMap.isempty()
                                  && caseIdwithProvIdMap.containsKey( csRecord.Id )
                                  && provIdAcctMap.containsKey( caseIdwithProvIdMap.get( csRecord.id ) ) 
                                  && provIdAcctMap.get( caseIdwithProvIdMap.get( csRecord.id ) ).RecordType.developerName == 'Physician'
                                  && csRecord.Completing_the_form_for__c  ==  'Individual' )
                        {
                                  Account acct        =   new Account( Id = provIdAcctMap.get( caseIdwithProvIdMap.get( csRecord.id ) ).Id); 
                                  acct.Cred_Status__c =   csRecord.Status;   
                                 accountsToUpdate.add( acct );
                         }
                    }
                }   
          }
          
          if( !acctIdSet.isEmpty() )
          {
              for( case csrecord : newList1 )
              {
                  if( String.isNotEmpty( csRecord.AccountId ) && acctIdSet.contains( csRecord.AccountId ) )
                     { 
                            Account acct        =   new Account( Id = csRecord.AccountId ); 
                            acct.Cred_Status__c =   csRecord.Status;
                            accountsToUpdate.add( acct );
                     }
              }
             
          }
        
        if( !accountsToUpdate.isEmpty() )
        {
            update accountsToUpdate;
        }  
    }
    /*
     * PPN-25402
     */
    public map<String,Account> getAcctIdByProvId( Set<String> provIdSet )
    {
        System.debug('provIdSet====>>>>>'+provIdSet);
        List<Account> acctList                  =   [Select Name,RecordType.DeveloperName,Prov_ID__c,recordTypeId,Id from Account Where  Prov_ID__c IN: provIdSet ];
        system.debug('acctList=== '+acctList);
        Map<String,Account> tempProvIdAcctMap   =   new Map<String,Account>();
        if(!acctList.isEmpty()){
            for( Account acct: acctList ) 
            {
                tempProvIdAcctMap.put(acct.Prov_ID__c,acct);
            } 
        } 
       System.debug('tempProvIdAcctMap====>>>>>'+tempProvIdAcctMap);
        return tempProvIdAcctMap;
    }
    
    //PPN-27889 Method to validate Network name field should be mandatory in contracting child case (both individual and group)- closure status - PPN-27889
    public void validateProviderDetailsection(map<id,sObject> mapNewCase,map<id,sObject> mapOldCase)        
    {
        system.debug('Entered validateProviderDetailsection ');
        system.debug(recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c );
        map<id,Case> mapofNewCase = (map<id,case>)mapNewCase;
        map<id,Case> mapofOldCase = (map<id,case>)mapOldCase; 
        Set<Id> resultIds = mapOfNewCase.keySet();

        AggregateResult[] groupedResults = [SELECT Contracting_Case__c, Count(Name) FROM Provider_Networks__c 
                                            where Contracting_Case__c in :resultIds and  
                                            Contracting_Case__r.Out_of_Network__c = false and
                                             (Network_Code_Name__c = '' OR Network_Code_Name__c = null) and
                                            (Contracting_Case__r.recordtypeid = :recTypeMapbyDeveloperName.get('Provider_Group_Onboarding_Contracting').Record_type_Id__c or
                                             Contracting_Case__r.recordtypeid = :recTypeMapbyDeveloperName.get('Contracting_Provider_On_boarding').Record_type_Id__c      or
                                             Contracting_Case__r.recordtypeid = :recTypeMapbyDeveloperName.get('Provider_On_boarding_Contracting_Edit').Record_type_Id__c)
                                            GROUP BY Contracting_Case__c];
        for (AggregateResult ar : groupedResults)  {
            System.debug('Contracting_Case__c:' + ar.get('Contracting_Case__c'));
            System.debug('Count:' + ar.get('expr0'));
            if((integer)ar.get('expr0') > 0 && ((mapofNewCase.get((id)ar.get('Contracting_Case__c')).status == 'Needs Credentialing' && mapofOldCase.get((id)ar.get('Contracting_Case__c')).status != 'Needs Credentialing') 
                                            || (mapofNewCase.get((id)ar.get('Contracting_Case__c')).status == 'No Credentialing needed' && mapofOldCase.get((id)ar.get('Contracting_Case__c')).status != 'No Credentialing needed' )) ){
                mapofNewCase.get((id)ar.get('Contracting_Case__c')).adderror('Network Name is required under Provider Details');
            }             
        } 
    }
    
    

     /*
     * Author : Sujatha G
     * Date  :  04/30/2019
     * Business purpose : PPN-38678
    */
     public void assignOwnerForCRMchildCases(List<Case> newListCases){
    
        system.debug('coming crmowner assignment');
        Map<String,ID> mapOfEntePCredentialQueue = new Map<String,ID>();
        Map<String,ID> mapOfCredInquiryQueue = new Map<String,ID>();        
        Id crmRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM').getRecordTypeId();
        Id ancillaryRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider On-boarding Credentialing - Ancillary').getRecordTypeId();
        Id facillityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider On-boarding Credentialing - Facility').getRecordTypeId();
        system.debug('facillityRecordTypeId '+facillityRecordTypeId );
        if(g.isEmpty())
            g = [select Id, Name from Group where Type = 'Queue' AND (NAME = 'Enterprise Credentialing OK' OR NAME = 'Enterprise Credentialing TX' OR NAME = 'Enterprise Credentialing IL' OR NAME = 'Enterprise Credentialing NM' 
                 OR NAME = 'Enterprise Credentialing MT' OR NAME = 'IL Cred Inquiry to Cred' OR NAME = 'TX Cred Inquiry to Cred' OR NAME = 'NM Cred Inquiry to Cred' OR NAME = 'OK Cred Inquiry to Cred' OR NAME = 'MT Cred Inquiry to Cred')];
        if(g.Size()>0){
            for(Group ques :g){        
               
         if(ques.Name == 'Enterprise Credentialing OK'){
                   mapOfEntePCredentialQueue .put('OK1', ques.id);
               }
        else if(ques.Name == 'Enterprise Credentialing TX'){
                   mapOfEntePCredentialQueue.put('TX1', ques.id);
               }
        else if(ques.Name == 'Enterprise Credentialing IL'){
                   mapOfEntePCredentialQueue.put('IL1', ques.id);
               }
        else if(ques.Name == 'Enterprise Credentialing NM'){
                   mapOfEntePCredentialQueue.put('NM1', ques.id);
               }
        else if(ques.Name == 'Enterprise Credentialing MT'){
                   mapOfEntePCredentialQueue.put('MT1', ques.id);
               }
        else if(ques.Name == 'IL Cred Inquiry to Cred'){
                   mapOfCredInquiryQueue.put('IL1', ques.id);
               } 
        else if(ques.Name == 'TX Cred Inquiry to Cred'){
                   mapOfCredInquiryQueue.put('TX1', ques.id);
               } 
        else if(ques.Name == 'NM Cred Inquiry to Cred'){
                   mapOfCredInquiryQueue.put('NM1', ques.id);
               } 
        else if(ques.Name == 'OK Cred Inquiry to Cred'){
                   mapOfCredInquiryQueue.put('OK1', ques.id);
               } 
        else if(ques.Name == 'MT Cred Inquiry to Cred'){
                   mapOfCredInquiryQueue.put('MT1', ques.id);
               } 
        
            }
        }
        system.debug('mapOfEntePCredentialQueue+++++++'+mapOfEntePCredentialQueue);
        system.debug('mapOfCredInquiryQueue+++++++'+mapOfCredInquiryQueue);      
        
        for(Case newCases : newListCases){            
        if(newCases.recordTypeId == crmRecordTypeId && (newCases.CRM_Types__c == 'Specialty Change' || newCases.CRM_Types__c == 'Cred Rush Request' || newCases.CRM_Types__c == 'Transition of Participation' ||
            newCases.CRM_Types__c == 'Reciprocal' || newCases.CRM_Types__c == 'Status Change' || newCases.CRM_Types__c == 'Reinstatement' || newCases.CRM_Types__c == 'Credentialing Application'|| newCases.CRM_Types__c == 'Credentialing Docs' || newCases.CRM_Types__c == 'Stop Credentialing')){
       
            if(newCases.OwnerId == UserInfo.getUserId() && mapOfEntePCredentialQueue.containskey(newCases.Plan_ID__c)){
                newCases.OwnerId = mapOfEntePCredentialQueue.get(newCases.Plan_ID__c);
            }
    
        }
        if(newCases.recordTypeId == crmRecordTypeId && (newCases.CRM_Types__c == 'Term-Preclusion' || newCases.CRM_Types__c == 'Term-Debarment' || newCases.CRM_Types__c == 'Term-Committee Denial' ||
            newCases.CRM_Types__c == 'Term-Inactive License' || newCases.CRM_Types__c == 'Term-Recred Final Term Request' || newCases.CRM_Types__c == 'Term-Admin Denial' || newCases.CRM_Types__c == 'Term-Non Compliant'|| newCases.CRM_Types__c == 'Provider Update')){
        
            if(newCases.OwnerId == UserInfo.getUserId() && mapOfEntePCredentialQueue.containskey(newCases.Plan_ID__c)){
                newCases.OwnerId = mapOfCredInquiryQueue.get(newCases.Plan_ID__c);

            }
        }
    
    
        if(newCases.recordTypeId == ancillaryRecordTypeId || newCases.recordTypeId == facillityRecordTypeId){
            //system.debug('facillityRecordTypeId@@@'+facillityRecordTypeId);
            if(mapOfEntePCredentialQueue.containskey(newCases.Plan_ID__c)){
                newCases.OwnerId = mapOfEntePCredentialQueue.get(newCases.Plan_ID__c); 
                
            }

        }
           }
        
    }
    //PPN-38678 End -Sujatha G
       /*
     * Author : Sethuraman E
     * Date  :  04/26/2019
     * Business purpose : SF-Credentialing Integration - Individual On boarding - 90 days wait for cred case in case of App Returned and Admin Denial status 
    */
     public static void checkFor90days( List<sObject> CaseList, Map<Id,sObject> oldMapsObject){

        Set<Id> parentCaseSet = new Set<Id>();
        Map<Id, Case> updateCaseMap = new Map<Id, Case>();
        Map<Id, Case> oldMap = (Map<Id,Case>)oldMapsObject;
        Set<Id> totalContractCaseSet = new Set<Id>();
        Set<Id> totContractCase90daysCheckedSet = new Set<Id>();
    
        for(Case curCase : (List<Case>)caseList){
           if(curCase.Check_for_90_days__c != oldMap.get(curCase.Id).Check_for_90_days__c && curCase.Check_for_90_days__c){
             if(curCase.parentId != NULL){
                 parentCaseSet.add(curCase.parentId);
             }
           }
        }
    
        for(Case contractCase : [SELECT id, status, parentId,Completing_the_form_for__c, Check_for_90_days__c,  recordtype.developername FROM Case WHERE parentId IN: parentCaseSet]){
            If(contractCase.Completing_the_form_for__c == 'Individual' || contractCase.Completing_the_form_for__c == 'Facility' || contractCase.Completing_the_form_for__c == 'Ancillary'){
                If( contractCase.recordType.developername == 'Contracting_Provider_On_boarding'){
                        Case conCase = new Case(Id = contractCase.Id);
                        conCase.status ='Closed Rejected';
                        conCase.External_Comments__c = 'Case is being rejected as Credentialing child case is in  Application Returned or Admin Denial status for more than 90 days';
                        updateCaseMap.put(conCase.Id, conCase);
                }
                if(!updateCaseMap.containsKey(contractCase.parentId)){
                        Case masterCase = new Case(Id = contractCase.parentId);
                        masterCase.status ='Closed Rejected';
                        masterCase.External_Comments__c= 'Case is being rejected as Credentialing child case is in  Application Returned or Admin Denial status for more than 90 days';
                        updateCaseMap.put(masterCase.Id, masterCase);
                }
            }
            else{ 
                if(contractCase.recordtype.developername == 'Provider_Group_On_boarding_Credentialling' && contractCase.Check_for_90_days__c){
                        totContractCase90daysCheckedSet.add(contractCase.Id);                       
                }
                if(contractCase.recordtype.developername == 'Provider_Group_On_boarding_Credentialling' ){
                         totalContractCaseSet.add(contractCase.Id);                       
                }
                system.debug('totalContractCaseSet.size()'+totalContractCaseSet.size());
                system.debug('totContractCase90daysCheckedSet.size()'+totContractCase90daysCheckedSet.size());
                IF(!totalContractCaseSet.isEmpty() && !totContractCase90daysCheckedSet.isEmpty() ){
                    if(contractCase.recordType.developername == 'Provider_Group_Onboarding_Contracting' && (totalContractCaseSet.size() == totContractCase90daysCheckedSet.size())){
                            totalContractCaseSet.add(contractCase.Id);
                            Case conCase = new Case(Id = contractCase.Id);
                            conCase.status = 'Closed Rejected';
                            conCase.External_Comments__c = 'Case is being rejected as Credentialing child case is in  Application Returned or Admin Denial status for more than 90 days';
                            updateCaseMap.put(conCase.Id, conCase);
                    }
                    if(!updateCaseMap.containsKey(contractCase.parentId)  ){
                        if(totalContractCaseSet.size() == totContractCase90daysCheckedSet.size()){
                            Case masterCase = new Case(Id = contractCase.parentId);
                            masterCase.status ='Closed Rejected';
                            masterCase.External_Comments__c= 'Case is being rejected as Credentialing child case is in  Application Returned or Admin Denial status for more than 90 days';
                            updateCaseMap.put(masterCase.Id, masterCase);
                         }
                    }
                }
                
            }
        }
            
        if(!updateCaseMap.isEmpty())
            update updateCaseMap.values();
    
     }
      
     /*
     * Author : Sethuraman E
     * Date   :  05/27/2019
     * Business purpose : User can enable the Paper cred checkbox only if there is an attachment to the case. 
                          If not, they will be getting error.
       Us     :  PPN-36046 and PPN-41941
     */
     public static void validatePaperCredCheckbox (List<sObject> CaseList, Map<Id,sObject> oldMapsObject){
         
         Map<Id, Case> mapOldCase = (Map<Id,Case>)oldMapsObject;
         Set<Id> setCurCase = new Set<Id>();
         Set<Id> setAttachmentCase = new Set<Id>();
         
         for(Case curCase : (List<Case>)caseList){
             if(curCase.Paper_Cred_Indicator__c != mapOldCase.get(curCase.Id).Paper_Cred_Indicator__c && curCase.Paper_Cred_Indicator__c){
                 setCurCase.add(curCase.Id);
             }
         }   
         
         system.debug('##### caseSet ###' + setCurCase );
         if(!setCurCase.isEmpty()){             
             for(ContentDocumentLink contentDocument : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId IN: setCurCase]){
                 setAttachmentCase.add(contentDocument.LinkedEntityId);
             }
         
             system.debug('##### attachmentCaseSet ###' + setAttachmentCase);
             for(Case curCase : (List<Case>)caseList){
                 if(!setAttachmentCase.contains(curCase.Id) && setCurCase.contains(curCase.Id)){
                     curcase.adderror('Please attach the paper credentialing application to the case.');
                 }
             }
         }
     }
     
     
     public void UpdateCRMCaseNumber(List<Case> newListCases,Map<Id,Case> oldMap ){

        // PPN-39172 Code begin
        String strCRMRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CRM').getRecordTypeId();
        String strCrmCaseNumber;
        Map<Id,String>  MapCRMNumber =  new Map<Id,String>();          
        Set<String> setOfCRMnumber = new Set<String>();
        List<Case> InsertCaselst = new List<Case>(); 
        List<Case> NumberCaselst = new List<Case>();  
        List<Case> updateCaselst = new List<Case>();
        
                
        
        for(Case newCase:newListCases){       
            if(newCase.recordTypeId  == strCRMRecTypeId && newCase.Credentialing_Case_Number__c != Null){                
                setOfCRMnumber.add(newCase.Credentialing_Case_Number__c); 
            }
        }
        
         if(!setOfCRMnumber.isEmpty()){
             NumberCaselst = [SELECT Id,ParentId ,Casenumber, CRM_Case_Number__c FROM Case WHERE ParentId IN: setOfCRMnumber ORDER BY LastmodifiedDate DESC]; 
         
          for(Case c:NumberCaselst){
            if(!MapCRMNumber.containsKey(c.ParentId)){
                MapCRMNumber.put(c.ParentId,c.Casenumber);
            }
         }
         
        InsertCaselst =  [SELECT Id,Casenumber,ParentId,CRM_Case_Number__c FROM Case WHERE Id IN: setOfCRMnumber and Isclosed = False];
         
        for(Case c:InsertCaselst ){
           
        
           if(MapCRMNumber.containsKey(c.Id)){
                    Case CurCase = new Case(Id=c.Id);
                    Curcase.CRM_Case_Number__c = MapCRMNumber.get(c.Id);
                    Curcase.CRMCaseFromCredCase__c = true;
                    updateCaselst.add(Curcase);
                }
            }
             if(!updateCaselst.isEmpty()){
                 Update updateCaselst ;
             }
            
        }
        
        
        // PPN-39172 Code End
                
    }
    
   public void UpdateCredentialingCaseNumber(List<Case> newListCases ,Map<Id,Case> oldMap){

        // PPN-39171 Code begin
        String strCredRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        String strCredRecTypeIdgrp =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
        
        Set<String> setOfCrmNumber = new Set<String>();  
        Map<String,Id>  MapCRMNumber =  new Map<String,Id>(); 
        Map<String,Id>  MapCredNumber =  new Map<String,Id>();  
        List<Case> updatelstCase = new List<Case>();  
        List<Case> ListCRMcase = new List<Case>();     
         
        
        for(Case newCase:newListCases){
            if(newCase.recordTypeId  == strCredRecTypeId || newCase.recordTypeId  == strCredRecTypeIdgrp){
                if(newCase.CRM_Case_Number__c != null && (newCase.CRM_Case_Number__c!= oldMap.get(newCase.Id).CRM_Case_Number__c) ){
                    System.Debug('***newCase.CRM_Case_Number__c'+newCase.CRM_Case_Number__c);
                    MapCRMNumber.Put(newCase.CRM_Case_Number__c,newCase.Id);
                }
            }
        }
         System.Debug('***MapCRMNumber'+MapCRMNumber);
         if(!MapCRMNumber.isEmpty()){ 
             ListCRMcase = [SELECT Id,Casenumber,CRM_Case_Number__c, Credentialing_Case_Number__c,Credentialing_Case_Number__r.Id FROM Case WHERE CaseNumber IN: MapCRMNumber.Keyset()]; 
             System.Debug('***ListCRMcase'+ListCRMcase);              
             
             for(Case c:ListCRMcase){         
                           
                 if(MapCRMNumber.containsKey(c.Casenumber)){
                     
                    Case CurCase = new Case(Id=c.Id);
                    CurCase.Credentialing_Case_Number__c = MapCRMNumber.get(c.Casenumber);
                    updatelstCase.add(CurCase);
                 }
                 
                 
             }
             if(!updatelstCase.isEmpty()){
                 Update updatelstCase;
             }
             
         }        
         
                
    }    
    
    public void OwnerChangeforOKPlan( List<Case> CaseList){
         
         Map<Id,Id>  MapContractingCase =  new Map<Id,Id>(); 
         List<Case> ListOfcontarctcases = new List<Case>();
         List<Case> updatelstCase = new List<Case>(); 
         Set<String> setOfParentId = new Set<String>();          
        
        Group g = [select Id, Name from Group where Type = 'Queue' AND (NAME = 'OK Contracting Queue')];
        
        String strgrpContractRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeId();
        String strContractRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
        String strgrpcredRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
        String strcredRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        String strcounterRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Counter_Sign').getRecordTypeId();
        String strcountergrpRecTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Counter_Sign').getRecordTypeId();
                
    
        for(Case curCase : (List<Case>)caseList){
           if(curCase.Plan_Id__c == 'OK1' && ((curCase.recordTypeId == strgrpcredRecTypeId) ||(curCase.recordTypeId == strcredRecTypeId) 
                                                ||(curCase.recordTypeId == strcounterRecTypeId)  ||(curCase.recordTypeId == strcountergrpRecTypeId))){
             if(curCase.parentId != NULL){
                 setOfParentId.add(curCase.parentId);
             }
           }
        }
         
         if(!setOfParentId.isEmpty()){ 
          ListOfcontarctcases = [SELECT id, status, parentId,OwnerId,recordtype.developername FROM Case WHERE parentId IN: setOfParentId AND (RecordTypeId = : strContractRecTypeId OR RecordTypeId = : strgrpContractRecTypeId)];
           
           for(Case c:ListOfcontarctcases){         
                           
                MapContractingCase.put(c.parentId,c.OwnerId); 
            }
               
            for(Case newCase : (List<Case>)caseList){
            if((newCase.recordTypeId == strgrpcredRecTypeId) ||(newCase.recordTypeId == strcredRecTypeId) 
                                                ||(newCase.recordTypeId == strcounterRecTypeId) || (newCase.recordTypeId == strcountergrpRecTypeId)){
                    
                    
                    if(MapContractingCase.containskey(newCase.parentId)){
                        
                        newCase.OwnerId = MapContractingCase.get(newCase.parentId);                         
                    }
                     else{                        
                        newCase.OwnerId = g.id;                        
                    }            
            }
            
        }           
          
      }  
          
   }
   
   public void NetworkEffDateCheck(List<Case> newListCases ,Map<Id,Case> oldMap){ //PPN-46322
       
    Set<Id> networkCaseIdset                 = new Set<Id>();
    Set<Id> networkCasesIdswithEffDt      = new Set<Id>();
    List<Provider_Networks__c> providerNetworkList  = new   List<Provider_Networks__c>();
    String strnetworkgrpRecTypeId  =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
    String strnetworkIndvRecTypeId  =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Network_Load').getRecordTypeId();

    
        for(Case newCase:newListCases){
            if(newCase.recordTypeId  == strnetworkgrpRecTypeId){
                if(newCase.Status =='Closed Processed' && (newCase.status!= oldMap.get(newCase.Id).status)
                    && newCase.Completing_the_form_for__c == 'Group'){
                     System.Debug('***newCase'+newCase);   
                    if(newCase.Network_Effective_Date__c == Null){                    
    
                        newCase.addError('Network Effective Date is required.');
    
                    }
                }
            }
            if(newCase.recordTypeId  == strnetworkIndvRecTypeId){
                if(newCase.Status =='Closed Processed' && (newCase.status!= oldMap.get(newCase.Id).status) 
                && newCase.Completing_the_form_for__c == 'Individual'){
                     networkCaseIdset.add(newCase.Id);     
                }
            }
        }
        
        if( !networkCaseIdset.isEmpty())
        {
            providerNetworkList  = [Select id,Case_Number__c,Networks_Effective_Date__c  from Provider_Networks__c where Case_Number__c IN : networkCaseIdset];
            for( Provider_Networks__c pd : providerNetworkList )
            {          
               
                if(pd.Networks_Effective_Date__c == NULL )
                {
                    networkCasesIdswithEffDt.add(pd.Case_Number__c);
                }            
            } 
        }
         
        for(Case cList : (List<Case>) newListCases){
            if(providerNetworkList.size() >0 )
            {
                if(networkCaseIdset.contains(cList.Id) &&  networkCasesIdswithEffDt.contains(cList.Id)){
                    cList.adderror('Network Effective Date is required.');
                }
            }
        }   
            
    }
    
    public void beforeInsert(SObject so) {}
    public void beforeUpdate(SObject oldSo, SObject so) {}
    public void beforeDelete(SObject so) {}
    public void afterInsert(SObject so) {}
    public void afterUpdate(SObject oldSo, SObject so) {
    }
    public void afterDelete(SObject so) {}
    public void andFinally() {}
}