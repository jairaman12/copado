global class CRMCaseCreationController1 
{
    public String selectedCrmTypes              { get; set; }
    public String caseStatusSelected            { get; set; }
    Public List<caseWrapper> caseWrapList       { set; get; }
    public Case caseRec                         { get; set; }
    public String acctId                        { set; get; }
    public String addPFINS                      { set; get; }
    public RecordType CRMRecType                { get; set; }
    private Set<String>  CRM_RECORDS            =   new Set<String>{'CRM','Master_CRM_Case_Data'};
    private String returnUrl                    = '';
    private String urlForSaveAndNew             = '';
    
    /* PPN-24048 Changes Begin */
    private List<String> caseOwnerProfileOptions    = new List<String>{'Supervisor', 'Provider Data Rep', 'Montana Supervisor', 'PNC Profile'};
    private List<String> illinoisUserRoles          = new List<String>{'Illinois_Supervisor','Illinois_PNC','Provider_Data_Rep_IL'};
    private List<String> oklahomaUserRoles          = new List<String>{'Oklahoma_Supervisor','Oklahoma_PNC','Provider_Data_Rep_OK'};
    private List<String> texasUserRoles             = new List<String>{'Texas_Supervisor','Texas_PNC','Provider_Data_Rep_TX'};
    private List<String> montanaUserRoles           = new List<String>{'Montana_Supervisor','Provider_Data_Rep_MT'};
    private List<String> newMexicoUserRoles         = new List<String>{'New_Mexico_Supervisor','New_Mexico_PNC','Provider_Data_Rep_NM'};
    private List<User> possibleCaseOwnersByUser     = new List<User>();
    private List<Group> possibleCaseOwnersByQueue   = new List<Group>();
    private List<Id> queuesFromCustomSettings       = new List<Id>();
    /* PPN-24048 Changes End */
    
    /* values to persist data in dynamic area */
    public String lookupValue                   { set; get;}
    public String fieldName                     { set; get;}
    public String fieldValue                    { set; get;}
    
    /*** PPN-14567 Changes Begin ***/
    public Set<String> selectedRequestTypes     { get; set; }
    /*** PPN-14567 Changes End***/ 
    
    public String entityId              {get;set;}
    public String parentId              {get;set;}
    public String parentCaseNumber      {get;set;}
    
    public String sobjName  {get; set;}
    String backwardUrl          =   '';
    String caseOrigin           =   '';
    private String planId       =   '';
    
    /*** BEGIN PPN-19310 ***/
    public List<pfinWrapper> allPfins       {get; set;}
    public Integer numberOfPfinOptions      {get; set;}
    public String pfinSearchValue           {get; set;}
    public String parentObjectRecordType    {get; set;}
    public Boolean saveAndCloneClicked      {get; set;}
    public Boolean selectAllPfinsCheckbox   {get; set;}
    public Boolean isFromCredentialing      {get; set;}  // PPN-43949
    public Boolean oktosave      {get;set;}
    private List<Id> tempIDList;
    private String soql;    // dynamic soql to control the pfin search table
    /*** END PPN-19310 ***/
    
    public Boolean inConsole                {get; set;}
    public Boolean fromCase                 {get; set;}
    
    public CRMCaseCreationController1(ApexPages.StandardController controller)
    {
        caseRec             = new Case();
        entityId            = '';
        acctId              = '';
        parentId            = '';
        parentCaseNumber    = '';
        urlForSaveAndNew    = ApexPages.currentPage().getUrl();
        isFromCredentialing = false;
        fromCase            = false;
        
        /* URL Parameters being passed from custom button */
        sObjName            = ApexPages.currentPage().getParameters().get('from');
        acctId              = ApexPages.currentPage().getParameters().get('accountId');
        entityId            = ApexPages.currentPage().getParameters().get('caseEntityId');
        planId              = ApexPages.currentPage().getParameters().get('planId');
        pfinSearchValue     = ApexPages.currentPage().getParameters().get('pfinNumber');
        parentId            = ApexPages.currentPage().getParameters().get('parentId');
        caseOrigin          = ApexPages.currentPage().getParameters().get('Origin');
        inConsole           = Boolean.valueOf(ApexPages.currentPage().getParameters().get('inConsole'));
        
        if( sObjName == 'Account' || sObjName == 'ServiceAndPayee' ) {
            
            Account parentAccount = [SELECT RecordType.Name FROM Account WHERE Id =: acctId and CM_Corporate_Entity_Code__c=:planId];
            
            parentObjectRecordType = parentAccount.RecordType.Name;
            
            if( parentObjectRecordType.contains('Entity') ){
                entityId = acctId;
                acctId = '';
            }
        } else {
            fromCase = true;
            parentObjectRecordType = 'Case';
            //caseRec.Corporate_Received_Date_Time__c = [SELECT Corporate_Received_Date_Time__c FROM Case WHERE Id=: parentId LIMIT 1].Corporate_Received_Date_Time__c;   //PPN-39400
            Case parentCase = [SELECT Id, CaseNumber, recordType.Name, Corporate_Received_Date_Time__c FROM Case WHERE Id=: parentId LIMIT 1];
            if(parentCase != NULL){
                caseRec.Corporate_Received_Date_Time__c = parentCase.Corporate_Received_Date_Time__c;
                if(parentCase.recordType.Name == 'Provider On-boarding Credentialing' || parentCase.recordType.Name == 'Provider Group On-boarding Credentialling')
                    isFromCredentialing = true;
            }
        }
        
        caseStatusSelected      =   ''; 
        caseWrapList            =   new List<caseWrapper>();
        selectedRequestTypes    =   new Set<String>(); 
        CRMRecType              =   [Select Id,Name From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName =:CaseUtil.REC_TYP_CRM];
        
        caseRec.RecordTypeId   =   CRMRecType.Id;
        caseRec.Plan_ID__c     =   planId;
        
        if(caseOrigin != '') 
        {
            caseRec.Origin  =  caseOrigin;
        }
        if(parentId != '')
        {
            caseRec.ParentId = parentId;
            caseRec.CRM_Parent_Case_Lookup__c = parentId;
        }
        if(entityId != '') {
            
            caseRec.Case_Entity__c = entityId;
        }
        if(acctId != '') {
            
            caseRec.AccountId = acctId;
        }
        
        populatePfins();
        
        queryCaseOwnerOptions();
        
    }
    
    /* 
    * PPN-24048: This method is used to get all the possible case owners based on the planid. These values populate the case owner picklists.
    */
    public void queryCaseOwnerOptions() {
        
        String userQuery = 'SELECT Id, Name, UserRole.Name, userRole.DeveloperName FROM User WHERE UserRole.Name != null AND Profile.Name IN :caseOwnerProfileOptions AND isActive = true ';
        
        /* Build the query based on the roles in each plan */
        if(planId == 'IL1') {
            userQuery += 'AND userRole.DeveloperName IN:illinoisUserRoles '; 
        } else if(planId == 'OK1') {
            userQuery += 'AND userRole.DeveloperName IN:oklahomaUserRoles ';
        } else if(planId == 'TX1') {
            userQuery += 'AND userRole.DeveloperName IN:texasUserRoles ';
        } else if(planId == 'MT1') {
            userQuery += 'AND userRole.DeveloperName IN:montanaUserRoles ';
        } else if(planId == 'NM1') {
            userQuery += 'AND userRole.DeveloperName IN:newMexicoUserRoles ';
        }
        
        userQuery += 'ORDER BY name';
        
        possibleCaseOwnersByUser = database.query(userQuery);
        
        for( QueueIds__c queue : [SELECT Id, QueueId__c FROM QueueIds__c WHERE PlanId__c = :planId]) {
            queuesFromCustomSettings.add(queue.QueueId__c);
         }
        
        possibleCaseOwnersByQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND (NOT Name like 'CLM%') AND (NOT Name like 'Default%') AND Id IN :queuesFromCustomSettings ORDER BY Name];
    }
    
    /*
     * PPN-24048: This method populates the user 'Case Owner' dropdowns
     */ 
    public List<SelectOption> getPossibleCaseOwnersByUser() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption(String.valueOf(UserInfo.getUserId()), String.valueOf(UserInfo.getName())));
        for(User u : possibleCaseOwnersByUser) {
            options.add(new SelectOption(String.valueOf(u.Id),String.valueOf(u.Name)));
        }
        
        return options;
     }
    
    /*
     * PPN-24048: This method populates the queue 'Case Owner' dropdowns
     */ 
    public List<SelectOption> getPossibleCaseOwnersByQueue() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--') );
        for(Group queue : possibleCaseOwnersByQueue) {
            options.add(new SelectOption(String.valueOf(queue.Id),String.valueOf(queue.Name)));
        }
        
        return options;
     }
       
    // populate CRM case types on VF Page
    public List<SelectOption> crmRequestTypes
    {
        get{
            if(crmRequestTypes == null)
            {
                crmRequestTypes                                     =   new List<SelectOption>();
                Schema.DescribeFieldResult crmCaseTypeField         =   Case.CRM_Types__c.getDescribe();
                List<Schema.PicklistEntry> crmTypes                 =   crmCaseTypeField.getPickListValues();
                for( Schema.PicklistEntry crmType : crmTypes )
                {
                    //crmRequestTypes.add( crmType.getValue() );
                    crmRequestTypes.add(new SelectOption(crmType.getValue(),crmType.getValue()));
                    
                }
            }
            crmRequestTypes.sort();
            return crmRequestTypes;
        }
        private set;
    }
    
    // populate CRM case Status on VF Page
    public List<SelectOption> crmCaseStatus
    {
        get{
            if(crmCaseStatus == null)
            {
                crmCaseStatus       =   New List<SelectOption>();
                String csStatus = GlobalSettings__c.getValues('PFFileRecieved').CRM_Case_Status_fields__c;
                for(String csStat : csStatus.split(',') ){
                    crmCaseStatus.add( new SelectOption( csStat , csStat ));
                }
            }
            return crmCaseStatus;
        }
        private set;
    }
    
    /***************************************************************
* @inputs: 
*  1.) lookupValue - used to find object in global caseWrapList
*  2.) fieldName   - name of field in object to update
*  3.) fieldValue  - value applied to field
* @output: 
*  caseWrapList is updated with value
**************************************************************/    
    public void updateSelectedCrmTypes()
    {
        for( caseWrapper wrapper : caseWrapList )
        {
            if(wrapper.reqTypeName == lookupValue)
            {
                if(fieldName.equals('picklistSelector')) {
                    wrapper.caseOwnerType = fieldValue;
                } else if(fieldName.equals('userSelector')) {
                    wrapper.selectedUser = fieldValue;
                } else if(fieldName.equals('queueSelector')) {
                    wrapper.selectedQueue = fieldValue;
                } else {
                    Object f = wrapper.caserec.get(fieldName);
                    f = fieldValue;
                }
            }
            
        }        
        
    }
    
    /***************************************************************
* @inputs: none
* @output: CaseWrapper will be populated with selected request type
* and a emty case and this method will be invoke bu Actionfunction
**************************************************************/
    public void selectedCrmTypesToController()
    {
        List<caseWrapper> tempWrapperList       =   new List<caseWrapper>();
        Map<String,caseWrapper> caseWrapperMap  =   new Map<String,CaseWrapper>();
        
        if( !caseWrapList.isEmpty() )
        {
            tempWrapperList.addAll(caseWrapList);
            for( caseWrapper wrapper : caseWrapList )
            {
                System.debug( 'wrapper.case===>>>'+wrapper.caserec );  
                caseWrapperMap.put( wrapper.reqTypeName , wrapper);  
            }
            caseWrapList.clear();
        }
        
        selectedRequestTypes.clear();
        selectedRequestTypes = (Set<String>)System.JSON.deserialize(selectedCrmTypes, Set<String>.class);
        
        if( selectedRequestTypes != null && tempWrapperList.isEmpty() ){
            for( String  str : selectedRequestTypes )
            {
                caseWrapper caseWrapRec             =   new caseWrapper();
                caseWrapRec.caserec                 =   new Case();
                caseWrapRec.reqTypeName             =   str;
                caseWrapRec.caserec.CRM_Types__c    =   caseWrapRec.reqTypeName;
                caseWrapRec.caseStatus              =   crmCaseStatus;
                if(isFromCredentialing)
                    caseWrapRec.caserec.Credentialing_Case_Number__c = parentId;
                caseWrapList.add( caseWrapRec );
            }
        }else if( selectedRequestTypes != null && !tempWrapperList.isEmpty() ){
            System.debug('tempWrapperList1111===>>>'+tempWrapperList.size());
            Integer tempCounter         =   0;
            for( String reqTypeString :  selectedRequestTypes )
            {
                if ( !caseWrapperMap.isEmpty() && caseWrapperMap.containsKey( reqTypeString ) ){
                    caseWrapList.add( caseWrapperMap.get( reqTypeString ) );
                }else{
                    caseWrapper caseWrapRec             =   new caseWrapper();
                    caseWrapRec.caserec                 =   new Case();
                    caseWrapRec.reqTypeName             =   reqTypeString;
                    caseWrapRec.caserec.CRM_Types__c    =   caseWrapRec.reqTypeName;
                    caseWrapRec.caseStatus              =   crmCaseStatus;
                    if(isFromCredentialing)
                        caseWrapRec.caserec.Credentialing_Case_Number__c = parentId;
                    caseWrapList.add( caseWrapRec );
                }
            }
            System.debug('caseWrapList 2222==>>>'+caseWrapList.Size());
        } 
        System.debug('caseWrapList 2222===>>>'+caseWrapList.size());
    }
    
    /***************************************************************
    * @inputs: none
    * @output: This method is invoked by the Cancel commandbutton.
    **************************************************************/
    public PageReference cancelAction()
    {    
        if(sObjName=='Case') {
            returnURL = '/' + parentId;
        } else if(sObjName=='ServiceAndPayee') {
            returnURL = '/' + ApexPages.currentPage().getParameters().get('recordId');
        } else {
            returnURL = '/' + acctId;
        } 
        
        return (new PageReference ( returnUrl ).setRedirect(true) );
    }
    
    /***************************************************************
    * @inputs: none
    * @output: This method is invoked by Save commandbutton
    **************************************************************/
    public PageReference  saveAction()
    {            
        oktosave = true;
        returnUrl =  saveCRMData(true);
        System.debug('returnUrl=====>>>>'+returnUrl);
        if(returnUrl != null){
            return ( new PageReference ( returnUrl ).setRedirect(true) );
        }else{
            return null;
        }
    }
    /***************************************************************
    * @inputs: none
    * @output: This method is invoked by Save & New commandbutton
    **************************************************************/
    public PageReference  saveAndNewAction()
    {
        
        returnUrl = saveCRMData(false);
        System.debug('Save n New returnUrl===>>>>'+urlForSaveAndNew);    
        return new Pagereference( urlForSaveAndNew ).setredirect(true);
    }
    
    /*
    * PPN:19348, Sprint 13, Team 1: This method is invoked by Save & Clone commandbutton
    */
    public PageReference saveAndCloneAction()
    {
        
        try {
            
            returnUrl = saveCRMData(false);
            
        } catch(Exception e) {
            
            System.debug('EXCEPTION WHEN SAVE AND CLONE: ' + e);
            
        }
        
        // Values to clear upon reloading after "Save & Clone" clicked per the acceptance criteria
        caseRec = caseRec.clone();
        caseRec.AccountId                   = null;
        caseRec.ContactId                   = null;
        caseRec.Case_Entity__c              = null;
        caseRec.CRM_Parent_Case_Lookup__c   = null;
        //caseRec.Origin                        = null;
        //caseRec.Corporate_Received_Date_Time__c   = null;
        fromCase                            = true;
        addPFINS                            = '';
        caseOrigin                          = '';
        acctId                              = '';
        entityId                            = '';
        caseStatusSelected                  = ''; 
        pfinSearchValue                     = '';
        
        selectAllPfinsCheckbox = false;
        allPfins = new List<pfinWrapper>();
        
        saveAndCloneClicked = true;
        
        return null;
    }
    
    /***************************************************************
* @inputs: none
* @output: This method is called by either Save or Save & New 
* action methods
**************************************************************/
    public String saveCRMData(Boolean isSave)
    {
        parentId                                = caseRec.CRM_Parent_Case_Lookup__c;
        String retPageURl                       =   '';
        List<Case> masterCRMRecordsForInsert    =   new List<case>();
        List<Case> childCRMRecordsForInsert     =   new List<case>();
        Map<String,Id> recTypeNamesMap          =   new Map<String,Id>();
        List<recordType> recTypeList            =   [Select Id,DeveloperName,Name from RecordType where developerName IN: CRM_RECORDS];
        
       
        System.debug('caseRec===>>>>'+caseRec);
        /************ Case recordtype Map ******/ 
        for(RecordType recType : recTypeList)
        {
            recTypeNamesMap.put(recType.DeveloperName,recType.Id);
        }
        
        /************ Insert master case ******/
        Boolean goodToInsert            =   true;
        if( caseRec!= null ) 
        {
          // try{
            if(( parentId==null || parentId == '')) {
                Case masterCRMCase                          =   new Case();
                masterCRMCase.AccountId                     =   caseRec.AccountId;
                masterCRMCase.Case_Entity__c                =   caseRec.Case_Entity__c;
                masterCRMCase.ContactId                     =   caseRec.ContactId;
                masterCRMCase.RecordTypeId                  =   recTypeNamesMap.get('Master_CRM_Case_Data');
                masterCRMCase.Plan_ID__c                    =   caseRec.Plan_ID__c;
                masterCRMCase.Priority                      =   'Medium'; 
                masterCRMCase.type                          =   caseRec.Type;
                masterCRMCase.Reason                        =   caseRec.Reason;
                masterCRMCase.Origin                        =   caseRec.Origin;
                masterCRMCase.Email_Address_Submitter__c    =   caserec.Email_Address_Submitter__c;
                masterCRMCase.Corporate_Received_Date_Time__c   =   caseRec.Corporate_Received_Date_Time__c;
                masterCRMCase.OwnerId                       =   UserInfo.getUserId();
                masterCRMCase.PFIN_Numbers_Long__c          = '';
                
                for(Integer i=0; i<allPfins.size(); i++) {                    
                    if(allPfins[i].selected) {                        
                        masterCRMCase.PFIN_Numbers_Long__c += allPfins[i].pfinNum.CM_SPL_PFIN_No__c + ', ';                        
                    } 
                }
                
                if(masterCRMCase.PFIN_Numbers_Long__c != '')
                    masterCRMCase.PFIN_Numbers_Long__c = masterCRMCase.PFIN_Numbers_Long__c.substring(0, masterCRMCase.PFIN_Numbers_Long__c.length()-2);
                /* PPN-19022 Start */                
                if(addPFINS != null && addPFINS != '')
                    masterCRMCase.PFIN_Numbers_Long__c = masterCRMCase.PFIN_Numbers_Long__c == '' ? addPFINS : masterCRMCase.PFIN_Numbers_Long__c + ', ' + addPFINS;
                /* PPN-19022 end */
                masterCRMRecordsForInsert.add(masterCRMCase);
                
                Database.SaveResult[] reults     =   Database.Insert( masterCRMRecordsForInsert , false ) ;
                for(Database.SaveResult sr : reults ){
                    if (sr.isSuccess())
                    {
                        parentId    =   sr.getId();
                        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    }
                }
                parentCaseNumber = masterCRMCase.CaseNumber;
            }  
            
            System.debug('parentId1111===>>>'+parentId);
            if(parentId != null || parentId != '')
            {
                for( caseWrapper wrapper : caseWrapList ) {
                    System.debug(entityId+'acctId===>>>'+acctId+'parentId===>>>'+parentId);
                    Case childCrmCase = new Case();
                    childCrmCase.AccountId                  =   caseRec.AccountId;
                    childCrmCase.Case_Entity__c             =   caseRec.Case_Entity__c;
                    childCrmCase.ContactId                  =   caseRec.ContactId;
                    childCrmCase.Plan_ID__c                 =   caseRec.Plan_ID__c;
                    childCrmCase.Type                       =   caseRec.Type;
                    childCrmCase.Email_Address_Submitter__c =   caserec.Email_Address_Submitter__c;
                    childCrmCase.Corporate_Received_Date_Time__c    =   caseRec.Corporate_Received_Date_Time__c;
                    childCrmCase.Origin                     =   caseRec.Origin;
                    childCrmCase.Priority                   =   wrapper.caserec.Priority;
                    childCrmCase.CRM_Comments__c            =   wrapper.caserec.CRM_Comments__c;
                    childCrmCase.Credentialing_Case_Number__c =  wrapper.caserec.Credentialing_Case_Number__c;
                    childCrmCase.Status                     =   wrapper.caserec.status;
                    childCrmCase.parentId                   =   parentId;
                    childCrmCase.RecordTypeId               =   recTypeNamesMap.get('CRM');
                    childCrmCase.CRM_Types__c               =   wrapper.reqTypeName;
                    childCrmCase.Outcome__c                 =   wrapper.caseRec.Outcome__c;
                    childCrmCase.SkipOmniRouting__c         =   'true';    // PPN-24672
                    childCrmCase.PFIN_Numbers_Long__c       =   '';
                    childCrmCase.Grievance_Description__c   =   wrapper.caseRec.Grievance_Description__c; //PPN-34485
                    
                    
                   if(wrapper.caserec.Credentialing_Case_Number__c != Null){
                    
                        childCrmCase.parentId                   = wrapper.caserec.Credentialing_Case_Number__c;
                        parentId = wrapper.caserec.Credentialing_Case_Number__c;
                        childCrmCase.CRMCaseFromCredCase__c = true;
                    }
                    
                    for(Integer i=0; i<allPfins.size(); i++) {
                        
                        if(allPfins[i].selected) {
                            
                            childCrmCase.PFIN_Numbers_Long__c += allPfins[i].pfinNum.CM_SPL_PFIN_No__c + ', ';
                            
                        } 
                    }
                    
                    /* PPN-24048: Set the child case owners based on selections made on the crm case creation page */
                    if(wrapper.caseOwnerType.equals('User')) {
                        childCrmCase.OwnerId = wrapper.selectedUser;
                    } else if(wrapper.caseOwnerType.equals('Queue')) {
                        childCrmCase.OwnerId = wrapper.selectedQueue;
                    }
                    
                    if(childCrmCase.PFIN_Numbers_Long__c != '')
                        childCrmCase.PFIN_Numbers_Long__c = childCrmCase.PFIN_Numbers_Long__c.substring(0, childCrmCase.PFIN_Numbers_Long__c.length()-2);
                    /* PPN-19022 Start */
                    if(addPFINS != null && addPFINS != '')
                        childCrmCase.PFIN_Numbers_Long__c = childCrmCase.PFIN_Numbers_Long__c == '' ? addPFINS : childCrmCase.PFIN_Numbers_Long__c + ', ' + addPFINS;
                    /* PPN-19022 End */
                    childCrmCase.Other_Reason_Description__c     = wrapper.caserec.Other_Reason_Description__c; 
                    childCRMRecordsForInsert.add( childCrmCase );
                    
                    
                }
                
               /* if(parentId!= null && planId!=null) {
                    parentCaseNumber = [SELECT Id, CaseNumber from Case WHERE Id=:parentId AND Plan_ID__c=:planId].CaseNumber;
                }*/
                
                caseRec.ParentId = parentId;
                
                    
                
            }    
           
            
            if( !childCRMRecordsForInsert.isEmpty() ){
                insert childCRMRecordsForInsert;
                
                setMasterCaseStatus(parentId, childCRMRecordsForInsert);
            }
            
             /*}catch(Exception e){
                System.debug('Exception ====>>>>'+e.getMessage()); 
                }*/ 
        }
        
        if( isSave == true )
        {
            retPageURl   =   '/' + parentId; 
            //retPageURl = '/lightning/r/Case/' + parentId + '/view';
            System.debug('retPageURl 11111===>>>'+retPageURl);
        }else
            retPageURl = ApexPages.currentPage().getUrl();
        
        return retPageURl;
    }
    
    /*** Method to set the status of the Master Case based on the child CRM case statuses ***/
    public void setMasterCaseStatus(String masterCaseId, List<Case> childCRMCases) {
        
        Boolean allChildStatusesAreNew      = false;
        Boolean allChildStatusesAreClosed   = false;
        Integer newStatuses                 = 0;
        Integer closedStatuses              = 0;
        Case mCase                          = [SELECT Id, Status, CRM_Case_Number__c, recordType.name FROM Case WHERE Id= :masterCaseId LIMIT 1];    /** Retrieving the master case from the database. Can be a Master CRM Case or Email-to-Case **/
        system.debug('****** mCase ****' + mCase);
        for(Case childCRMCase : childCRMCases) {
            
            if( childCRMCase.Status == 'New' ) {
                newStatuses++;
            } else if( childCRMCase.Status.contains('Closed') ) {
                closedStatuses++;
            }
        }
            system.debug('****** childCRMCases ***' + childCRMCases);
            if(!childCRMCases.isEmpty() && (mCase.recordType.name == 'Provider On-boarding Credentialing' || mCase.recordType.name == 'Provider Group On-boarding Credentialling')){
                
                String strLastCaseNumber = [SELECT Id, caseNumber FROM Case WHERE Id IN: childCRMCases ORDER BY caseNumber DESC LIMIT 1].CaseNumber;
                system.debug('***** strLastCaseNumber ****' + strLastCaseNumber);
                mCase.CRM_Case_Number__c = strLastCaseNumber;
                mCase.CRMCaseFromCredCase__c = true;
            }
            
            if(mCase.recordType.name != 'Provider On-boarding Credentialing' && mCase.recordType.name != 'Provider Group On-boarding Credentialling'){
            
                if( newStatuses == childCRMCases.size() ) {
                    mCase.Status = 'New';
                } else if( closedStatuses == childCRMCases.size() ) {
                    mCase.Status = 'Closed';
                } else {
                    mCase.Status = 'In Progress';
                }
            }
        
        
        try{
            update mCase;
        } catch(Exception e) {
            System.debug('Error when updating master case for newly created CRM case(s): ' + e);
        }
        
    }
    
    /*** inner class to store left selected options ***/
    public class caseWrapper
    {
        public Case caserec                     {set; get;}
        public String reqTypeName               {set; get;}
        public List<SelectOption> caseStatus    {set; get;}
        public String caseOwnerType             {get; set;}
        public String selectedUser              {get; set;}
        public String selectedQueue             {get; set;}
        
        public caseWrapper() {
            caseOwnerType = 'User';
        }
    }
    
    public PageReference populatePfins() {
        
        try {
            selectAllPfinsCheckbox = false;
            allPfins = new List<pfinWrapper>();
            numberOfPfinOptions = 0;
            
            String entityType = '';
            
            acctId = '';
            entityId = '';
            
            if(caseRec.AccountId != null)
                acctId = caseRec.AccountId;
            
            if(caseRec.Case_Entity__c != null) {
                entityType = [SELECT Id, RecordType.Name, IsPersonAccount FROM Account WHERE Id =: caseRec.Case_Entity__c].RecordType.Name;
                if(entityType.contains('Entity')) {
                    entityId = caseRec.Case_Entity__c;
                }
                
                System.debug('--------------------> CASE ENTITY TYPE: ' + [SELECT Id, RecordType.Name, IsPersonAccount FROM Account WHERE Id =: caseRec.Case_Entity__c].RecordType.Name );
            }
            List<CM_SPL_Addr__c> tempList = new List<CM_SPL_Addr__c>();
            Set<String> pfinNumberSet = new Set<String>();
            tempIDList = new List<Id>();
            
            System.debug('Account ID: ' + acctId);
            System.debug('Case Account ID: ' + caseRec.AccountId);
            System.debug('ENTITY ID: ' + entityId);
            System.debug('Case ENTITY ID: ' + caseRec.Case_Entity__c);
            
            
            if(entityId != '' && caseRec.Case_Entity__c != null) {
                
                if(!entityType.contains('Master')) {
                    
                    soql    = 'SELECT Id, CM_SPL_PFIN_No__c, CM_SPA_Tax_ID__c, CM_County__c,Bill_PFIN__c, CM_SPL_Prov__r.Prov_ID__c, CM_SPL_Prov__c FROM CM_SPL_Addr__c WHERE';
                    
                    if(acctId != '' && caseRec.AccountId != null) {
                        soql    +=   ' (CM_SPL_Prov__c=:acctId OR CM_SPL_Prov__c=:entityId) AND';
                    } else if(acctId == '' || caseRec.AccountId == null) {
                        soql    +=   ' CM_SPL_Prov__c=:entityId AND';
                    }
                    
                    soql += ' CM_Corporate_Entity_Code__c=:planId ORDER BY CM_SPL_PFIN_No__c LIMIT 999';
                    
                } else if(entityType.contains('Master')) {
                    
                    for(Affiliations__c a : [SELECT Id, Affiliated_to_Service_PFIN__c, CM_Corporate_Entity_Code__c FROM Affiliations__c WHERE Account__c=:entityId AND CM_Corporate_Entity_Code__c=:planId ORDER BY Affiliated_to_Service_PFIN__c] ) {
                        tempIDList.add(a.Affiliated_to_Service_PFIN__c);
                    }
                    System.debug('--------------------> # of Affiliations: ' + tempIDList.size() );
                    soql  = 'SELECT Id, CM_SPL_PFIN_No__c, CM_SPA_Tax_ID__c, CM_County__c,Bill_PFIN__c, CM_SPL_Prov__r.Prov_ID__c, CM_SPL_Prov__c FROM CM_SPL_Addr__c WHERE';
                    
                    if(acctId != '' && tempIDList.size() > 0 && caseRec.AccountId != null) {
                        soql += ' (CM_SPL_Prov__c=:acctId OR Id IN:tempIDList)'; 
                    } else if(acctId != '' && tempIDList.size() == 0 && caseRec.AccountId != null) {
                        soql += ' CM_SPL_Prov__c=:acctId';
                    } else if(acctId == '' && tempIDList.size() > 0 && caseRec.AccountId == null) {
                        soql += ' Id IN:tempIDList';
                    }
                    
                    soql += ' AND CM_Corporate_Entity_Code__c=:planId ORDER BY CM_SPL_PFIN_No__c LIMIT 999';
                    
                }
                
                
            } else if(acctId != '' && caseRec.AccountId != null) {
                
                soql    = 'SELECT Id, CM_SPL_PFIN_No__c, CM_SPA_Tax_ID__c, CM_County__c, Bill_PFIN__c,CM_SPL_Prov__r.Prov_ID__c,CM_SPL_Prov__c FROM CM_SPL_Addr__c WHERE CM_SPL_Prov__c=:acctId AND';
                soql    += ' CM_Corporate_Entity_Code__c=:planId ORDER BY CM_SPL_PFIN_No__c LIMIT 999';
            }
            
            if( (acctId != '' && caseRec.AccountId != null) || (entityId != '' && caseRec.Case_Entity__c != null) ) {
                tempList = Database.query(soql);
            }
            
            allPfins = new List<pfinWrapper>();
            
            System.debug('SOQL STATEMENT: ' + soql );
            System.debug('LIST SIZE WITH DUPLICATES: ' + tempList.size() );
            
            for(Integer i=0; i<tempList.size(); i++) {
                
                if(i == 0) {
                    
                    pfinWrapper p = new pfinWrapper(tempList[i]);
                    numberOfPfinOptions++;
                    allPfins.add(p);
                    
                } else if( i>=1 ) {
                    
                    String prevPfin = tempList[i-1].CM_SPL_PFIN_No__c;
                    String currPfin = tempList[i].CM_SPL_PFIN_No__c;
                    
                    if( !currPfin.equalsIgnoreCase(prevPfin) ) {
                        numberOfPfinOptions++;
                        pfinWrapper p = new pfinWrapper(tempList[i]);
                        
                        allPfins.add(p);
                        
                    }  
                    
                }
                
            }
            
            System.debug('List SIZE WITHOUT DUPLICATES: ' + numberOfPfinOptions );
            
            
        } catch(Exception e) {
            System.debug('EXCEPTION: ' + e);
        } 
        
        return null;
    }
    
    // Wrapper to hold service and payee locations in search table
    public class pfinWrapper {
        public CM_SPL_Addr__c pfinNum           {get; set;}
        public Boolean selected                 {get; set;}
        
        // Instantiation of pfin wrapper for table
        public pfinWrapper(CM_SPL_Addr__c pi) {
            pfinNum = pi;
            selected = false;
        }
    }
    
    
    /*******PFIN PAGE TABLE**********/
}