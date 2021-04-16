/**************************************************************************************************
Apex Class Name  : OMNIQueueManagementCls
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru             09/09/2017           Sprint 24,25,26
* Sreekanth K                   09/07/2017           PPN-22916           
***************************************************************************************************/
public class OMNIQueueManagementCls 
{
    public List<SelectOption>           allProcessors               {set; get;}
    public List<SelectOption>           allProcessorsOrig           {set; get;}
    public list<SelectOption>           selectedProcessors          {set; get;}
     public SelectOption[]              allRequestTypes             {set; get;}
    public SelectOption[]               selectedRequests            {set; get;}
    
    public String                       planId                      {get; set;}
    public Integer                      rowNumberHidden             {get; set;}
    public OMNI_Queue__c                omniQueueObj                {set; get;}
    public List<OMNI_User_Group__c>     omniUserGrpList             {set; get;}
    public List<SelectOption>           caseTypeOptions             {set; get;}
    public String                       selectedCaseType            {set; get;}
    public Integer                      rowToDelete                 {set; get;}    
    public Boolean                      displayUserBlock            {set; get;}
    public List<OMNI_Queue__c>          omniQueueList               {set; get;}
    public List<OMNI_Queue__c>          omnireservedQueueList       {set; get;}
    public  Boolean                     isEditPage                  {get; set;}
    public  Boolean                     isDeleteMode                {get; set;}
    private Boolean                     isCreatePage                {get; set;}
    public  Id                          RecordToPass                {get; set;}
    public  Id                          OwnerIdToPass               {get; set;}
    public List<SelectOption>           leftOeverProcessors;
    public Group g;
    
    private static final Integer NUM_OF_EMPTY_TASKS             =   3;
    public List<User> userList                                  =   new List<User>();
    public Map<String,List<String>>     caseTypeWithrequestMap  =   new Map<String,List<String>>();
    public Set<String>                  caseTypeSet             =   new set<String>();
    public List<Request_Types__mdt>     requestTypeList         =   new List<Request_Types__mdt>();
    public Map<String,Id>               userNameWithId          =   new Map<String,Id>();
    public Map<String,Id>               globalUserNameWithId    =   new Map<String,Id>();
    Map<Id,OMNI_Queue__c> omniqueIdWithOptionsMap               =   new Map<Id,OMNI_Queue__c>();
    public Map<String,String> caseTypeAndOrigMap                =   new Map<String,String>();
    
    private id tempid;
    private id tempOwnerId;
    private Boolean firstTime= true;
    private Integer counter;
    public OMNI_Queue__c omniQueue;
    public OMNI_Queue__c omniQueuePrev;
    public List<SelectOption>           varyingOptionsList      =    new List<SelectOption>();
    public list<case> tlist = new list<case>();
    public list<case> flist = new list<case>();
    public list<case> olist = new list<case>();
    
    
    public list<recordtype> CaseRtype= [select name,developername from recordtype where sobjecttype = 'Case'];
    public map<string, string> CaseRMap = new map<string, string>();
    public list<Group> CaseQName= [select id,name,developername from Group];
    public map<string, id> CaseQMap = new map<string, id>();
    
     /**Added for PPN: 12062 **/
    Public list<OMNI_User_Group__c> PrevOmniUserGroup= new list<OMNI_User_Group__c>();
    Public list<OMNI_User_Group__c> OmniUserGrpToBeSaved= new list<OMNI_User_Group__c>();
    
    public OMNIQueueManagementCls()
    {
        system.debug('Inside Constructor') ;
        selectedRequests        =   new List<SelectOption>();
        allRequestTypes         =   new List<SelectOption>();
        allProcessors           =   new List<SelectOption>();
        allProcessorsorig       =   new List<SelectOption>();
        selectedProcessors      =   new List<SelectOption>();
        leftOeverProcessors     =   new List<SelectOption>();
        omnireservedQueueList   =   new List<OMNI_Queue__c>();
        omniQueueList           =   new List<OMNI_Queue__c>();
        omniQueueObj            =   new OMNI_Queue__c();
        processorsWrap          =   new  List<processorsWrapper>();
        displayUserBlock        =   false;
        omniqueIdWithOptionsMap =   new Map<Id,OMNI_Queue__c>();
        requestTypeList.clear();
        allRequestTypes.clear();
        isEditPage              =  false;
        isCreatePage            =  false;
        isDeleteMode            =   false;
        /*******************************************************
        * @initialdataload to load while new queue tab clicked
        * @editDataLoad to load the data when a record gets
        *  edited from edit screen
        *******************************************************/        
        if(ApexPages.currentPage().getParameters().get('oId')!=null){
            system.debug('inside oid:' );
            isEditPage = true;
            tempid = ApexPages.currentPage().getParameters().get('oId');
            tempOwnerId = ApexPages.currentPage().getParameters().get('sid');
            editDataLoad();
        } else if(ApexPages.currentPage().getParameters().get('oid')==null) { 
            isCreatePage = true;
            intialDataLoad();
        }     
        
        // display usergroup records on page load
        omniUserGrpList    =  new List<OMNI_User_Group__c>();
        if(isEditPage){
            omniUserGrpList = [select id,Active__c,End_Date__c,Group__c,Plan_Id__c, Selected_User_Ids__c,
                               Selected_Users__c,Start_Date__c,User__c,Week_Days__c from OMNI_User_Group__c 
                               where Group__c = :tempid];
           updateProcessWrap(omniUserGrpList); 
        }else{
            for ( Integer i = 0; i < NUM_OF_EMPTY_TASKS; i ++ )
            {
                addNewProcessorSelection();
            }
        }
    }
    
    //intial data load 
    public void intialDataLoad()
    { 
        Map<String,RoleAndPlanId_Settings__c> roleMap     = RoleAndPlanId_Settings__c.getAll();
        Map<Id,String> roleIdWithPlanMap                  = new Map<Id,String>();
        Id uRoleId = UserInfo.getUserRoleId();
        List<User> processorList = [Select Id,name,UserRoleId from User where isActive=true];
        for( User usr : processorList)
        {
             globalUserNameWithId.put(usr.name, usr.Id);
        }
        // PlanId bsed on logged in User user 
        for( RoleAndPlanId_Settings__c record : roleMap.values() )
        {
            roleIdWithPlanMap.put( record.Role_Id__c , record.PlanId__c );
        }
        if(!roleIdWithPlanMap.isEmpty())
        {
            planId =       roleIdWithPlanMap.get(uRoleId);  
        }
        
        // display Case types on intial page load
        caseTypeOptions = new List<SelectOption>();
        String requestTypeQueryStr      =   'SELECT ' + Utils.getObjectFieldList('Request_Types__mdt') +' FROM Request_Types__mdt';
        requestTypeQueryStr             =   requestTypeQueryStr + ' where Plan_Ids__c like \'%' + planId + '%\'';
        requestTypeList                 =   (List<Request_Types__mdt>)Database.query( requestTypeQueryStr );
        Set<String> caseTypeSet         =   new Set<String>();
        Map<String,String>  caseTypeMap =   new Map<String,String>();
        
        for( Request_Types__mdt requestType : requestTypeList)
        {
            caseTypeAndOrigMap.put(requestType.Request_Name__c, requestType.CaseType_Name_Origin__c);
            String planIds   =   requestType.Plan_Ids__c;
            if(caseTypeWithrequestMap.containsKey( requestType.CaseType__c))
            {
                caseTypeWithrequestMap.get(requestType.CaseType__c).add(requestType.Request_Name__c);
            }else{
                List<String> reqList = new List<String>();
                reqList.add(requestType.Request_Name__c);
                caseTypeWithrequestMap.put(requestType.CaseType__c, reqList);
            }       
        } 
        
        if(!requestTypeList.isEmpty())
        {
            for( Request_Types__mdt requestType : requestTypeList)
            {
                String planIds   =   requestType.Plan_Ids__c;
                if( planIds.contains( planId ))
                {
                    caseTypeSet.add(requestType.CaseType__c);
                    caseTypeMap.put(requestType.CaseType__c, requestType.CaseType_Name_Origin__c);
                }
            }

            if(!caseTypeSet.isEmpty())
            {  caseTypeOptions.clear();
             for( String caseType :  caseTypeSet)
             {
                 caseTypeOptions.add(new SelectOption(caseType,caseType));
                 caseTypeOptions.sort();
             }
            } 
        }
        
        List<Omni_Queue__c> omniQueueList = [Select Name,Id,Request_Type_s__c,Case_Type__c,CreatedById,LastModifiedById 
                                             from Omni_Queue__c where Plan_Id__c=:planId];
        for(OMNI_Queue__c rec: omniQueueList)
        {
            omniqueIdWithOptionsMap.put(rec.Id, rec);
        }
    } 
    
    //edit data load 
    public void editDataLoad()
    { 
        intialDataLoad();
        SelectOption[]  tempoptionlist = new list<selectoption>();  
        omniQueueObj = [select id,Name,Case_Type__c,Owner__c,Plan_Id__c,ownerId,Queue_Priority__c,Request_Type_s__c from omni_queue__c where id = :tempid];
        omniQueueprev = omniQueueObj;
        if(String.isNotEmpty(omniQueueObj.Case_Type__c))
        {
            selectedCaseType = omniQueueObj.Case_Type__c  ;
            displayUserBlock = true;
            displayCaseReqtypes();
            displayProcessors();
            System.debug('Edit page allRequestTypes ===>>>'+allRequestTypes);
            for(SelectOption s:allRequestTypes)
            {
                if(string.valueof(omniQueueObj.Request_Type_s__c).contains(string.valueof(s.getValue()))){
                    selectedRequests.add(s);
                }else{
                    tempoptionlist.add(s);
                }
            }
        }
        if(!tempoptionlist.isEmpty()){
            allRequestTypes = tempoptionlist;
        }else{
           allRequestTypes.clear(); 
        }
        
    } 
    /******Adding the Omni Queue Id to page when user clicks on Edit on Existing Queue's Page ***/
    public pageReference openPage() 
    {
        pageReference pg = new pageReference('/apex/OMNIQueueManagementPage?oid=' + recordtopass+'&ownerId='+ownerIdToPass);
        pg.setRedirect(true);
        return pg;
    }     
    
    /**** Adding new processor rows When user cliscks on Add new Processor buttton *******/
    public void addNewProcessorSelection()
    {
        omniUserGrpList.add( new OMNI_User_Group__c());  
    }
    
    /*********** Bases on Case Type selection relared case types will be displayed *******/
    public Pagereference displayCaseReqtypes()
    {
        allRequestTypes.clear();
        selectedRequests.clear();
        if(!string.isEmpty(selectedCaseType) && isEditPage==true &&  selectedCaseType!='None')
        {
            omniUserGrpList  = [select id,Active__c,End_Date__c,Group__c,Plan_Id__c, Selected_User_Ids__c,
                               Selected_Users__c,Start_Date__c,User__c,Week_Days__c,Group__r.Request_Type_s__c from  OMNI_User_Group__c 
                               where Group__c = :tempid and Group__r.Case_Type__c=:selectedCaseType];
            
            if(!omniUserGrpList.isEmpty())
            {
                Set<String> reqTyesSelected = new Set<String>();
                reqTyesSelected.addAll(omniUserGrpList[0].Group__r.Request_Type_s__c.split(';'));
                System.debug('selectedCaseType$$$###$$$$===>>>'+selectedCaseType);
                System.debug('caseTypeWithrequestMap$$$###$$$$===>>>'+caseTypeWithrequestMap);
                if(caseTypeWithrequestMap !=NULL && caseTypeWithRequestMap.containsKey(selectedCaseType))
                {
                for(String requestName : caseTypeWithrequestMap.get(selectedCaseType))
                { 
                    if(reqTyesSelected.contains(requestName))
                    {
                        selectedRequests.add(new SelectOption(requestName,requestName));
                    }else{
                         allRequestTypes.add(new SelectOption(requestName,requestName)) ;
                    }
                }
                updateProcessWrap(omniUserGrpList);
                }
            }else{
                 if(caseTypeWithrequestMap !=NULL && caseTypeWithrequestMap.containsKey(selectedCaseType))
                 {
                 for(String requestName : caseTypeWithrequestMap.get(selectedCaseType))
                { 
                    allRequestTypes.add(new SelectOption(requestName,requestName)) ;
                    allRequestTypes.sort();
                    displayUserBlock = true;
                }
                 }
                for ( Integer i = 0; i < NUM_OF_EMPTY_TASKS; i ++ )
                {
                    addNewProcessorSelection();
                }
                   processorsWrap.clear();
                
            }
        }
        System.debug(isEditPage+'omniUserGrpList inside display Case type'+omniUserGrpList.size());
        If( (omniUserGrpList.isEmpty() || isEditPage == false) &&  selectedCaseType!='None'){
            if(!caseTypeWithrequestMap.isEmpty()){
            for(String requestName : caseTypeWithrequestMap.get(selectedCaseType))
            { 
                allRequestTypes.add(new SelectOption(requestName,requestName)) ;
                allRequestTypes.sort();
                displayUserBlock = true;
            }
            processorsWrap.clear();
            } 
        }
        return null;
    }  
    
    /****************************************
    * Upon the Case types selection display the processors 
    * Ex: Web demographic CSR's and for Email supervisors
    * @input :  Case type
    * @output: SelectOptions 
    * *************************************/
    public PageReference displayProcessors()
    {
        // Types of users to be dispaed
        if(!Test.isRunningTest()){
        userList   = OMNIProcessorsDisplayCls.getUsersList(planId,selectedCaseType);
        }
        Set<String> usersSet    = new Set<String>();
        Set<String> pNames1 = new Set<String>();
        selectedProcessors.clear();
         
         
        if(isEditPage == true && processorsWrap.isEmpty() && isDeleteMode==false)
        {
            List<OMNI_User_Group__c> omniUsersList;
           if(!String.isEmpty(selectedCaseType))
            {
                System.debug('1111##==>>>');
                omniUsersList  = [select id,Active__c,End_Date__c,Group__c,Plan_Id__c, Selected_User_Ids__c,
                               Selected_Users__c,Start_Date__c,User__c,Week_Days__c from OMNI_User_Group__c 
                               where Group__c = :tempid and Group__r.Case_Type__c=:selectedCaseType ]; 
            }else{
                 System.debug('22222##==>>>>');
                omniUsersList  = [select id,Active__c,End_Date__c,Group__c,Plan_Id__c, Selected_User_Ids__c,
                               Selected_Users__c,Start_Date__c,User__c,Week_Days__c from OMNI_User_Group__c 
                               where Group__c = :tempid ];
            }
             
            if(omniUsersList.size()>0)
            {
                updateProcessWrap(omniUsersList);
                for( OMNI_User_Group__c omniuser : omniUsersList )
                {
                    String[] usrs = omniuser.Selected_Users__c.split(',');
                    usersSet.addAll(usrs); 
                }
                updateLeftOptions(usersSet);
            }  
        }
         System.debug(rowNumberHidden+'processorsWrap size ####====>>>>>'+processorsWrap.size());
         if( processorsWrap.size()>0)
        {
            
            for( processorsWrapper pw : processorsWrap )
            {
                System.debug('pw.rowNumber'+pw.rowNumber);
                if( pw.rowNumber == String.valueOf(rowNumberHidden) 
                   && pw.rightSideSelections.size() > 0 )
                {
                    System.debug(pw.rightSideSelections.size()+'pw.rightSideSelections inside for loop '+pw.rightSideSelections);
                    System.debug('selectedProcessors inside for loop'+selectedProcessors);
                    
                    for(SelectOption option: pw.rightSideSelections)
                    {
                        selectedProcessors.add(new SelectOption(option.getLabel(),option.getLabel())); 
                    }
                    
                   // pNames1.addAll( getNames(pw.rightSideSelections) );
                } 
              pNames1.addAll( getNames(pw.rightSideSelections) );   
            }
            System.debug('pNames1'+pNames1);
            if(!pNames1.isEmpty()){
                updateLeftOptions(pNames1);}else{allProcessorsToDisplay();}
        }else if(firstTime || processorsWrap.isEmpty())
        {
            allProcessorsToDisplay();
        }
        return null;
    }
    
    public void allProcessorsToDisplay()
    {
        List<String> userNames  =   new List<String>();
        allProcessors.clear();
            for( User usr : userList)
            {
                userNames.add(usr.name);
                userNameWithId.put(usr.name, usr.Id); 
            }
            userNames.sort();
            if(!userNames.isEmpty())
            {
                for(String names: userNames)
                {
                    allProcessors.add(new SelectOption(userNameWithId.get(names),names));
                    allProcessorsOrig.add(new SelectOption(userNameWithId.get(names),names));
                    firstTime =  false;
                }
            }
    }
     
    /****************************************
    * update the processors selected in modal input
    * @input :  SelectOption values
    * @output:  Omni_Users_c records as a list 
    * *************************************/
    public Pagereference updateProcessors()
    {
        system.debug('<!-----------Start of updateProcessors----------------->');
        List<OMNI_User_Group__c> tempomniUserGrpList = new List<OMNI_User_Group__c>();
        String selectedUserName =   '';
        String selectedUserIds  =   '';
        Set<String> selectedUserNameSet = new Set<String>();
       
        if(!selectedProcessors.isEmpty()){
            for(SelectOption selOption : selectedProcessors)
            {
                selectedUserName    = selectedUserName+','+selOption.getLabel();
                selectedUserNameSet.add(selOption.getLabel());
                selectedUserIds     = selectedUserIds+','+selOption.getValue();
            }
            
            counter     =   -1; 
           
            for(OMNI_User_Group__c rec : omniUserGrpList )
            {
                counter =counter+1;
                string[] splitUsers;
                string[] splitUserIds;
                List<SelectOption>  roption = new List<SelectOption>();
                OMNI_User_Group__c newGroup     =   new OMNI_User_Group__c();
                
                
                if( String.isNotEmpty(selectedUserName)){
                    newGroup.Selected_Users__c      =   (counter == rowNumberHidden) ? selectedUserName.substring(1) : rec.Selected_Users__c ;
                    newGroup.Selected_User_Ids__c   =   (counter == rowNumberHidden) ? selectedUserIds.substring(1) : rec.Selected_User_Ids__c;
                }else{
                    newGroup.Selected_Users__c     =   '';
                    newGroup.Selected_User_Ids__c  =   '';
                }
                newGroup.Start_Date__c          =   rec.Start_Date__c;
                newGroup.End_Date__c            =   rec.End_Date__c;
                newGroup.Active__c              =   rec.Active__c;
                newGroup.Week_Days__c           =   rec.Week_Days__c;
                newGroup.RowNumber__c           =   rowNumberHidden;
                List<SelectOption> leftOptions  =   new List<SelectOption>();
                List<SelectOption> rightOptions =   new List<SelectOption>();
                tempomniUserGrpList.add(newGroup);
            }
            
            omniUserGrpList.clear();
             updateProcessWrap(tempomniUserGrpList);
            omniUserGrpList.addAll(tempomniUserGrpList);
        }
        
        return null;
    }
    /************************** 
    * Delete the current row
    * @input: row number
    * ***********************/
    public void deleteCurrentRow()
    {   
        System.debug(rowToDelete+'omniUserGrpList inside delete row ===>>>>'+processorsWrap.size());
        System.debug('=====>>>>'+omniUserGrpList);

        if(omniUserGrpList.size()>0)
        {
            isDeleteMode = true;
            Set<String> usersSet    = new Set<String>();
            System.debug('omniUserGrpList.get(rowToDelete).Selected_Users__c===>>>>'+omniUserGrpList.get(rowToDelete).Selected_Users__c);
            OMNI_User_Group__c toBeDeleted = omniUserGrpList.remove( rowToDelete);
            updateProcessWrap(omniUserGrpList);
            System.debug(omniUserGrpList.size()+'inside processor delete Wrap function====>>>>'+rowToDelete);
            
        }
       
        System.debug('After delete processorsWrap size===>>>>'+omniUserGrpList.size());
    }  
    
    /**************************************************** 
    * Save both OMNI Queue and QMNI Users 
    ***************************************************/
    public pageReference doSave()
    {
        // Create a savepoint while AccountNumber is null
        Savepoint sp = Database.setSavepoint();
        
        String reqTypes='';
        String reqTypeVal='';
        Boolean Start = true;
        List<OMNI_Queue__c> omniQueuList            =   new List<OMNI_Queue__c>();
        Map<Integer,Id> priorityMap                 =   new Map<Integer,Id>();
        Boolean redirectURL                         =   false;
        String priorityStr                          =    omniQueueObj.Queue_Priority__c;
        
        if( omniQueueObj.Name == null || 
           String.isEmpty(priorityStr)==true ||
           String.isEmpty(selectedCaseType) == true ||
           selectedRequests.isEmpty())
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make sure you have entered Queue Name, Priority, Case Type and request types .'));
            return null;
        }
        if(omniUserGrpList.size()>0)
        {
            for(OMNI_User_Group__c omniusergrp : omniUserGrpList)
            {
                if((omniusergrp.Selected_Users__c == null || 
                    omniusergrp.Start_Date__c == null ||
                    omniusergrp.End_Date__c == null ||
                    omniusergrp.Week_Days__c == null ||                         
                    omniusergrp.Start_Date__c  > omniusergrp.End_Date__c) && 
                   !(omniusergrp.Selected_Users__c == null && 
                     omniusergrp.Start_Date__c == null &&
                     omniusergrp.End_Date__c == null &&
                     omniusergrp.Week_Days__c == null)                       
                  )
                {                            
                    if(omniusergrp.Start_Date__c  > omniusergrp.End_Date__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Start date cannot be greater than End date'));
                    }else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Make sure you have selected Processors, Start date, End date and Days to be selected and then retry'));
                    }
                    return null;
                    break;                         
                }
            }
        }
        
        String existingCaseTypesQueuename       =   validateQueue(planId,selectedRequests,omniQueueObj.Name,omniQueueObj.Id);
        String existingQueueName                =   validateQueueName(planId,omniQueueObj.Name,omniQueueObj.Id);    
         System.debug(existingCaseTypesQueuename+'<<<===existingCaseTypesQueuename===>>>'+existingQueueName);
        if(String.isNotEmpty( existingQueueName ))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Queue already exists, Please select a different name.'));
            return null;
        }else if(String.isNotEmpty( existingCaseTypesQueuename )){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Queue Name and selected request type(s) should be a unique name and with different case type(s). Refer Existing Queue(s)  \''+existingCaseTypesQueuename+'\''+'to edit.'));
            return null;
        }
         
        
        for( QueueRoutingConfig routingConfig  :[SELECT DeveloperName,Id,RoutingPriority FROM QueueRoutingConfig])
        {
            priorityMap.put(routingConfig.RoutingPriority , routingConfig.Id);
        }
        
        
        if(isEditPage==true){
            omniQueue =   new OMNI_Queue__c(id=tempid);
            omniQueue.OwnerId = omniQueueObj.OwnerId;
            /***********************************************************************
                * A custom queue has been edit them removing all processors associated
                * with this queue and addining it agin
                ***********************************************************************/
            List<OMNI_User_Group__c> deleteOmniUsers = [Select Id,Start_Date__c,End_Date__c,Week_Days__c,Active__c from OMNI_User_Group__c where Group__c=:tempid] ;
            /**Added For PPN: 12062 - starts**/
            if(deleteOmniUsers !=null)
            PrevOmniUserGroup.addall(deleteOmniUsers);
            /** Added For PPN: 12062 -ends **/
            delete deleteOmniUsers;
        }else{
            omniQueue = new OMNI_Queue__c(); 
        }
        omniQueue.Name              =   omniQueueObj.Name;
        omniQueue.Plan_Id__c        =   planId;
        omniQueue.Queue_Priority__c =   omniQueueObj.Queue_Priority__c;
        omniQueue.Case_Type__c      =   selectedCaseType;
        
        if(!selectedRequests.isEmpty()){
            for( SelectOption so : selectedRequests ){
                if(Start) {
                    reqTypes    =   so.getValue();
                    reqTypeVal  =   caseTypeAndOrigMap.get(so.getValue());
                    Start       =   false;
                }else{
                    reqTypes    =   reqTypes+';'+so.getValue();
                    reqTypeVal   =   reqTypeVal+';'+caseTypeAndOrigMap.get(so.getValue());
                }
            }
        }
        omniQueue.Request_Type_s__c =   reqTypes; 
        omniQueue.Case_Type_Name_Origin__c = reqTypeVal;
        upsert omniQueue;
        
        // Group g;
        if(isEditPage==false)
        {
            g           =   new Group();
            g.name      =   'OMNI_'+planId.substringBefore('1')+'_'+omniQueue.Name;
            g.Type      ='Queue';
            g.Email =   GlobalSettings__c.getValues('PFFileRecieved').Fake_Email__c;
            g.QueueRoutingConfigId      =   priorityMap.get(integer.valueOf(omniQueue.Queue_Priority__c)) ;
            try{
               insert g; 
            }catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Field to create a Queue.Please reach out your system Admin.');
            }
            
            Group newQueueId    =   [Select Id from Group where id=:g.Id];
            if(newQueueId!=null )
            {
                QueueIds__c queueIdrec  =   new QueueIds__c();
                queueIdrec.PlanId__c    =   planId;
                queueIdrec.Name         =   g.Name;
                queueIdrec.QueueId__c   =   g.Id;
                insert queueIdrec;
            }
            redirectURL      =   true;
        }else if(isEditPage==true)
        {
            g = new Group( Id=omniQueue.OwnerId );
            g.QueueRoutingConfigId      =   priorityMap.get(integer.valueOf(omniQueue.Queue_Priority__c)) ;
            try{
               update g; 
            }catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Field to update the Queue.Please reach out your system Admin.'+e.getMessage());
            }
            redirectURL      =   true;
        }
        
        List<OMNI_User_Group__c>  omniUserGroupList = new List<OMNI_User_Group__c>();
        List<Id> prosIds = new List<Id>();
        String userIds  ='';
        if(omniUserGrpList.size()>0)
        {
            for(OMNI_User_Group__c omniusergrp : omniUserGrpList)
            {  
                if(!(omniusergrp.Selected_Users__c == null && 
                     omniusergrp.Start_Date__c == null &&
                     omniusergrp.End_Date__c == null &&
                     omniusergrp.Week_Days__c == null)   ){ 
                         
                         Set<String> selectedProcessorNames = new Set<String>();
                         selectedProcessorNames.addAll(omniusergrp.Selected_Users__c.split(','));
                         
                         for(String prosName: selectedProcessorNames){
                             userIds = userIds+','+globalUserNameWithId.get(prosName);
                         }
                         userIds = userIds.substring(1);
                         
                         System.debug('userIds===>'+userIds);
                         
                         OMNI_User_Group__c oug      =   new OMNI_User_Group__c();
                         oug.Active__c               =   omniusergrp.Active__c;
                         oug.Plan_Id__c              =   planId;
                         oug.Selected_User_Ids__c    =   getProcessorIdsStr(selectedProcessorNames);
                         oug.Selected_Users__c       =   omniusergrp.Selected_Users__c;
                         oug.Group__c                =   omniQueue.id;
                         oug.Start_Date__c           =   omniusergrp.Start_Date__c;
                         oug.End_Date__c             =   omniusergrp.End_Date__c;
                         oug.Week_Days__c            =   omniusergrp.Week_Days__c;
                         //userIds                     =   userIds+','+omniusergrp.Selected_User_Ids__c;
                         omniUserGroupList.add( oug );
                     }
            }
             /** Added For PPN:12062 - Starts**/
            if(omniUserGroupList!=null)
            OmniUserGrpToBeSaved.addall(omniUserGroupList);
            /** Added For PPN:12062 - Ends**/
            for( String str : userIds.split(','))
            {
                if(str.startsWith('005'))
                {
                    prosIds.add(Id.valueOf(str));
                }
            }
            if(!omniUserGroupList.isEmpty()){
                redirectURL     =   true;
                try{
                    insert omniUserGroupList;
                }catch(Exception e)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Failed to update/insert the Queues to a Queue.Please reach out your system Admin.'+e.getMessage());
                }
                
            }
            system.debug('before: queuable apex');
            System.debug('prosIds===>>>'+prosIds);
            
        }
        
          reParentExistingCases();  
       
        ID jobID;
        if(isEditPage){ 
            System.debug('flist111===>>>'+flist);
            jobID= System.enqueueJob(new updateExistingCases(prosIds,g.Id,omniQueue.Id,flist)); 
        }else{
            jobID= System.enqueueJob(
                new addSobjectTypetoQueue(prosIds,g.Id,omniQueue.Id,flist)); 
        }
        
        if(redirectURL == true){
            return (new pagereference('/apex/OMNIQueueManagementPage').setredirect(true));
        }else{
            return null;
        }
    }
    
/*********************************************************
* Core function that handles reparenting of existing cases
* based on rule creation/edit
**********************************************************/
    public void reParentExistingCases()
    {
        for(Recordtype r:CaseRtype){
            CaseRMap.put(r.name,r.developername);
        }
        for(Group g:CaseQName){
            CaseQMap.put(g.developername,g.id);
        }
        
        system.debug('CaseRMap:' + CaseRMap);
        
        if(isEditPage){            
            handleEditRule();
        }else{
            handleNewRule();
        }
        
        for(case c:flist){
            c.ownerid = omniQueue.ownerid;
        }        
    }
    
/********************************************************
* This function handles reparenting of existing cases
* when new rule is created
*********************************************************/    
    public void handleNewRule()
    {
        system.debug('--------handleNewRule------------' + omniQueue.Case_Type__c);
        system.debug('omniQueue.Case_Types__c:' + omniQueue);
        if(omniQueue.Case_Type__c == 'Govt Cases'){
            //flist = [select id, ownerid from case where Govt_Programs__c = true and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and owner.type = 'Queue' and RecordType.DeveloperName !='Master_Provider_Case_data'];
             flist = [select id, ownerid from case where Govt_Programs__c = true and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and owner.type = 'Queue' and (RecordType.DeveloperName ='Email' OR ParentId != null)];
            System.debug('flist===>>>>'+flist);
        }else if(omniQueue.Case_Type__c == 'Email'){
            string[] emails = omniQueue.Request_Type_s__c.split(';');
            system.debug('omniQueue.Request_Type_s__c:' + omniQueue.Request_Type_s__c);
            system.debug('emails:' + emails);
            system.debug('caseTypeAndOrigMap:' + caseTypeAndOrigMap);
            string[] origin = new list<string>();
            for(string s:emails){
                origin.add(caseTypeAndOrigMap.get(s));
            }
            system.debug('origin:' + origin);
            flist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c 
                     and owner.type = 'Queue' and recordtype.developername = 'Email' and  Origin in :Origin];
        }else if(omniQueue.Case_Type__c == 'Network Change'){
            flist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c 
                     and owner.type = 'Queue' and recordtype.developername = 'Network_Change'];
        }/*else if(omniQueue.Case_Type__c == 'Provider On-boarding - Contracting'){
            flist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c 
                     and owner.type = 'Queue' and recordtype.developername in :recordtypes ]; 
        }else if(omniQueue.Case_Type__c == 'Provider On-boarding - Data Entry'){
            flist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c 
                     and owner.type = 'Queue' and recordtype.developername in :recordtypes ]; 
        }*/
        else if(omniQueue.Case_Type__c == 'Demographics' ||
               omniQueue.Case_Type__c == 'Provider On-boarding - Contracting' ||
               omniQueue.Case_Type__c == 'Provider On-boarding - Data Entry'){
            SYSTEM.debug('<<<===In side demographic omniQueue.Case_Type__c ===>>>'+omniQueue.Case_Type__c);
            string[] recordtypes = new list<string>();
            string[] rtypes = omniQueue.Request_Type_s__c.split(';');        
            for(string s:rtypes){
                recordtypes.add(CaseRMap.get(s));
            }
            SYSTEM.debug('<<<===In side demographic recordtypes ===>>>'+recordtypes);
            flist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' 
                     and Plan_ID__c = :omniQueue.Plan_Id__c and owner.type = 'Queue' 
                     and recordtype.developername in :recordtypes];
        }else if(omniQueue.Case_Type__c == 'CRM'){
           //PPN-22916 
            List<String> crmRequestTypes    =   new list<string>();
              
            crmRequestTypes                 =   omniQueue.Request_Type_s__c.split(';'); 
            System.debug(crmRequestTypes+'In side CRM case block =====>>>>'+omniQueue.Case_Type__c);
            System.debug('In side CRM case block1111 =====>>>>'+omniQueue.Request_Type_s__c);
            flist                           =   [select id, ownerid from case where Govt_Programs__c = false 
                                                 and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c 
                                                 and recordtype.developername = 'CRM' 
                                                 and CRM_Types__c  IN :crmRequestTypes and SkipOmniRouting__c=''];
            System.debug('In side CRM case block2222 =====>>>>'+flist);
        }else{
            system.debug('We have a problem: Unmatched Case Type');
        }
    }

/*********************************************************
* This function handles reparenting of existing cases
* when existing rule is edited
**********************************************************/     
    public void handleEditRule()
    {   
        Boolean ProcessorIsActive = false;  //Added For PPN:12062   
        // Scenario 1: During rule edit, if Case Type and Request Types are not changed, no action is required 
       /** Added for PPN:12062 - when the processor is edited with valid values,reparent old existing cases**/
        List<String> listOfNewRequestType = new List<String>();
        List<String> listOfOldRequestType = new List<String>();
        if(omniQueuePrev.Request_Type_s__c !=NULL && omniQueuePrev.Request_Type_s__c.contains(';'))
        {
            listOfNewRequestType = omniQueuePrev.Request_Type_s__c.split(';');
        }
        if(omniQueue.Request_type_s__c !=NULL && omniQueue.Request_Type_s__c.contains(';'))
        {
            listOfoldRequestType = omniQueue.Request_Type_s__c.split(';');
        }
        Set<String> setOfOldRequestTypes = new Set<String>();
        setOfOldRequestTypes.addAll(listOfOldRequestType);
        Boolean isSameRequestType=true;
        if(listOfNewRequestType.size() ==listOfOldRequestType.size())
        {
            for(String newRequestType:listOfNewRequestType)
            {
                if(!setOfOldRequestTypes.contains(newRequestType))
                {
                    isSameRequestType=false;
                }
                
            }
        }
        else
        {
            isSameRequestType = false;
        }
        if( omniQueue.Case_Type__c == omniQueuePrev.Case_Type__c 
           && isSameRequestType )
        {System.debug('Inside corresponding if ');
           
           if( PrevOmniUserGroup.size() == OmniUserGrpToBeSaved.size() 
             && omniQueue.Request_Type_s__c == omniQueuePrev.Request_Type_s__c )
           {
               for( integer i=0; i< PrevOmniUserGroup.size(); i++ )
               {
                     if( PrevOmniUserGroup[i].Active__c == false && 
                        OmniUserGrpToBeSaved[i].Active__c != PrevOmniUserGroup[i].Active__c )
                     {
                        ProcessorIsActive = true;
                     }
                     if( PrevOmniUserGroup[i].Start_Date__c!=OmniUserGrpToBeSaved[i].Start_Date__c || 
                        PrevOmniUserGroup[i].End_Date__c!=OmniUserGrpToBeSaved[i].End_Date__c || 
                        PrevOmniUserGroup[i].Week_Days__c!=OmniUserGrpToBeSaved[i].Week_Days__c || 
                        ProcessorIsActive == true )
                     { System.debug('Expected output');
                                handleNewRule();
                     } 
                }
           }else
           {
                handleNewRule();
           }
           /** Added for PPN: 12062-ends **/
        // Scenario 2: During rule edit, if Case Type is not changed but Request Types are changed, handle email/Web Demographic cases     
        }else if( omniQueue.Case_Type__c == omniQueuePrev.Case_Type__c 
                 && omniQueue.Request_Type_s__c != omniQueuePrev.Request_Type_s__c)
        {
            if(omniQueue.Case_Type__c == 'Email')
            {
                system.debug('handleEmailChanges ===>>>');
                handleEmailChanges();                
            }else if( omniQueue.Case_Type__c == 'Demographics' 
                     || omniQueue.Case_Type__c == 'CRM'
                     || omniQueue.Case_Type__c == 'Provider On-boarding - Contracting'
                     || omniQueue.Case_Type__c == 'Provider On-boarding - Data Entry'
                    )
            {
                system.debug(omniQueue.Request_Type_s__c+'<<<=== new 11111 old ===>>>'+omniQueuePrev.Request_Type_s__c);
                handleDemographicChanges();  
            }
        // Scenario 3: During rule edit, if Case Type and Request Types are both changed, change the owner on existing cases to 
        //             standard queue for old Case Type/Request Types and change the owner on existing cases to custom queue  for new Case Type/Request Types 
        }
       
        else if( omniQueue.Case_Type__c != omniQueuePrev.Case_Type__c && 
                  omniQueue.Request_Type_s__c != omniQueuePrev.Request_Type_s__c )
        {
             system.debug(omniQueue.Request_Type_s__c+'<<<=== new 22222 old ===>>>'+omniQueuePrev.Request_Type_s__c);
            handleNewRule();
            pushToStandardQ();
        }
    }    
    
/************************************************************************
* This function handles reparenting of existing cases
* when changes in request types occur for 'Web Demographic' Case Type
*************************************************************************/    
    public void handleDemographicChanges()
    {
        string[] newRtypes = omniQueue.Request_Type_s__c.split(';'); 
        string[] oldRtypes = omniQueuePrev.Request_Type_s__c.split(';'); 
        string[] addedRtypes = new list<string>();
        string[] deletedRtypes = new list<string>();
        Map<string, string> newMap = new Map<string, string>();
        System.debug(oldRtypes+'oldRtypes====>>>>'+newRtypes);
        System.debug('omniQueue.Case_Type__c===>>>'+omniQueue.Case_Type__c);
        for(string n : newRtypes)
        {
            newMap.put(n,n);
        }
        Map<string, string> OldMap = new Map<string, string>();
        for(string o : oldRtypes)
        {
            OldMap.put(o,o);
            if(newMap.get(o) == null){
                deletedRtypes.add(caseRMap.get(o));
            }
        }
        for(string n : newRtypes)
        {
            if(oldMap.get(n) == null){
                addedRtypes.add(caseRMap.get(n));
            }
        }
        If(omniQueue.Case_Type__c == 'Demographics' 
           || omniQueue.Case_Type__c == 'Provider On-boarding - Contracting'
           || omniQueue.Case_Type__c == 'Provider On-boarding - Data Entry' 
          )
        {
             //PPN-37114 (status = 'New'OR status = 'In Progress')
             flist = [select id, ownerid from case where Govt_Programs__c = false and (status = 'New' OR status = 'In Progress') and Plan_ID__c = :omniQueue.Plan_Id__c and owner.type = 'Queue' and recordtype.developername in :addedRtypes];
             olist = [select id, ownerid from case where Govt_Programs__c = false and (status = 'New' OR status = 'In Progress') and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid and recordtype.developername in :deletedRtypes];
             System.debug('deletedRtypes++'+deletedRtypes);
             System.debug('omniQueue.Plan_Id__c++'+omniQueue.Plan_Id__c);
             System.debug('omniQueuePrev.ownerid++'+omniQueuePrev.ownerid);
             System.debug('omniQueuePrev.ownerid++'+omniQueuePrev.ownerid);
             System.debug(olist.size()+'In Side handle demographic changes===>>>>'+flist.size());
           
                 updateStdQueue( olist , omniQueue.Case_Type__c );
            
        }else if( omniQueue.Case_Type__c == 'CRM')
        {
            //PPN-22916 
            System.debug('Inside handleDemographicChanges====>>>>>'+omniQueue.Case_Type__c);
            olist                           =   [select id, ownerid from case where Govt_Programs__c = false 
                                                 and status = 'New' 
                                                 and Plan_ID__c = :omniQueuePrev.Plan_Id__c 
                                                 and recordtype.developername = 'CRM'
                                                 and OwnerId = :omniQueuePrev.ownerId 
                                                 and CRM_Types__c  IN :oldRtypes and SkipOmniRouting__c='']; 
            flist                           =   [select id, ownerid from case where Govt_Programs__c = false 
                                                 and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c 
                                                 and recordtype.developername = 'CRM' 
                                                 and CRM_Types__c  IN :newRtypes and SkipOmniRouting__c=''];
            System.debug('Inside handleDemographicChanges flist====>>>>>'+flist);
             System.debug('Inside handleDemographicChanges olist====>>>>>'+olist);
            updateStdQueue( olist , omniQueue.Case_Type__c );
        }
        
    }

/****************************************************
* Generic function that accepts list of cases and
* changes the owner to state specific default queue
*****************************************************/      
    public void updateStdQueue( list<case> clist , String requestType )
    {
        System.debug('clist +++'+clist );
        System.debug('requestType +++'+requestType );
        list<case> olist = new list<case>();
        olist = clist;
        if( !String.isEmpty( requestType ) && requestType == 'Provider On-boarding - Contracting' )
        {    
            System.debug('updateStdQueue++++');
            for(case c:olist){
                          
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQmap.get('OMNI_IL_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQmap.get('OMNI_MT_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQmap.get('OMNI_NM_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQmap.get('OMNI_OK_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQmap.get('OMNI_TX_Contracting_Queue');
                }
                 System.debug('c.ownerid+++'+c.ownerid);
            } 
            
           
        }else if ( !String.isEmpty( requestType ) && requestType == 'Provider On-boarding - Data Entry' )
        {
            for(case c:olist){                
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQmap.get('OMNI_IL_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQmap.get('OMNI_MT_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQmap.get('OMNI_NM_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQmap.get('OMNI_OK_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQmap.get('OMNI_TX_Data_Entry_Queue');
                }
            }
            
        }else{
             for(case c:olist)
            {
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQMap.get('OMNI_IL_DataRep_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQMap.get('OMNI_MT_Supervisor_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQMap.get('OMNI_NM_DataRep_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQMap.get('OMNI_OK_DataRep_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQMap.get('OMNI_TX_DataRep_Standard_Queue');
                }
            }
        }

        if(olist.size() > 0)    
            update olist;
    }
    
/*************************************************************
* This function handles reparenting of existing cases
* when changes in request types occur for 'Email' Case Type
**************************************************************/      
    public void handleEmailChanges()
    {
        System.debug('Inside handle Email changes ===>>>>');
        string[] newEmails = omniQueue.Request_Type_s__c.split(';');
        string[] oldEmails = omniQueuePrev.Request_Type_s__c.split(';');
        string[] addedEmails = new list<string>();
        string[] deletedEmails = new list<string>();
        Map<string, string> newMap = new Map<string, string>();
        for(string n : newEmails)
        {
            newMap.put(n,n);
        }
        Map<string, string> OldMap = new Map<string, string>();
        for(string o : oldEmails)
        {
            OldMap.put(o,o);
            if(newMap.get(o) == null){
                deletedEmails.add(o);
            }
        }
        for(string n : newEmails)
        {
            if(oldMap.get(n) == null){
                addedEmails.add(n);
            }
        }
        
        string[] origin = new list<string>();
        for(string s:addedemails){
            origin.add(caseTypeAndOrigMap.get(s));
        }
        flist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and owner.type = 'Queue' and recordtype.developername = 'Email' and  Origin in :Origin];
        origin = new list<string>();    
        for(string s:deletedemails){
            origin.add(caseTypeAndOrigMap.get(s));
        }
        olist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid and Origin in :Origin];
        System.debug('flist ===>>>>'+flist);
        System.debug('olist ===>>>>'+olist);
        for(case c:olist)
        {
            
            if(omniQueue.Plan_Id__c == 'IL1'){
                c.ownerid = caseQmap.get('OMNI_IL_Supervisor_PNC_Standard_Queue');
            }else if(omniQueue.Plan_Id__c == 'MT1'){
                c.ownerid = caseQmap.get('OMNI_MT_Supervisor_Standard_Queue');
            }else if(omniQueue.Plan_Id__c == 'NM1'){
                c.ownerid = caseQmap.get('OMNI_NM_Supervisor_PNC_Standard_Queue');
            }else if(omniQueue.Plan_Id__c == 'OK1'){
                c.ownerid = caseQmap.get('OMNI_OK_Supervisor_PNC_Standard_Queue');
            }else if(omniQueue.Plan_Id__c == 'TX1'){
                c.ownerid = caseQmap.get('OMNI_TX_Supervisor_PNC_Standard_Queue');
            }
        }
        if(olist.size() > 0) 
            update olist;
        
    }
    
/*************************************************************************
* This function handles reparenting of existing cases
* to push the existing cases to standard queues when case type changes
**************************************************************************/      
    public void pushToStandardQ()
    {
        System.debug('pushToStandardQ+++');
        if(omniQueuePrev.Case_Type__c == 'Govt Cases'){
            olist = [select id, ownerid from case where Govt_Programs__c = true and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid];
            for(case c:olist){
                c.ownerid = caseQMap.get('OMNI_IL_Govt_Queue');
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQmap.get('OMNI_IL_Govt_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQmap.get('OMNI_MT_Govt_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQmap.get('OMNI_NM_Govt_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQmap.get('OMNI_OK_Govt_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQmap.get('OMNI_TX_Govt_Queue');
                }
            }
            if(olist.size() > 0) 
                update olist;
        }else if(omniQueuePrev.Case_Type__c == 'Email'){
            string[] emails = omniQueuePrev.Request_Type_s__c.split(';');
            string[] origin = new list<string>();
            for(string s:emails){
                origin.add(caseTypeAndOrigMap.get(s));
            }
            olist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid and recordtype.developername = 'Email'];
            for(case c:olist){
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQmap.get('OMNI_IL_Supervisor_PNC_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQmap.get('OMNI_MT_Supervisor_PNC_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQmap.get('OMNI_NM_Supervisor_PNC_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQmap.get('OMNI_OK_Supervisor_PNC_Standard_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQmap.get('OMNI_TX_Supervisor_PNC_Standard_Queue');
                }
            }
            if(olist.size() > 0)    
                update olist;
        }else if(omniQueuePrev.Case_Type__c == 'Network Change'){
            olist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid and recordtype.developername = 'Network_Change'];
            updateStdQueue( olist , omniQueuePrev.Case_Type__c );
        }else if(omniQueuePrev.Case_Type__c == 'Provider On-boarding - Contracting'){
            
            string[] recordtypes = new list<string>();
            string[] rtypes = omniQueuePrev.Request_Type_s__c.split(';');        
            for(string s:rtypes){
                recordtypes.add(caseRMap.get(s));
            }
            
            olist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid and recordtype.developername IN:recordtypes ]; 
            for(case c:olist){                
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQmap.get('OMNI_IL_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQmap.get('OMNI_MT_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQmap.get('OMNI_NM_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQmap.get('OMNI_OK_Contracting_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQmap.get('OMNI_TX_Contracting_Queue');
                }
            }
            if(olist.size() > 0) 
                update olist;
        }else if(omniQueuePrev.Case_Type__c == 'Provider On-boarding - Data Entry'){
            
            string[] recordtypes = new list<string>();
            string[] rtypes = omniQueuePrev.Request_Type_s__c.split(';');        
            for(string s:rtypes){
                recordtypes.add(caseRMap.get(s));
            }
            
            olist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid and recordtype.developername IN:recordtypes ]; 
            for(case c:olist){                
                if(omniQueue.Plan_Id__c == 'IL1'){
                    c.ownerid = caseQmap.get('OMNI_IL_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'MT1'){
                    c.ownerid = caseQmap.get('OMNI_MT_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'NM1'){
                    c.ownerid = caseQmap.get('OMNI_NM_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'OK1'){
                    c.ownerid = caseQmap.get('OMNI_OK_Data_Entry_Queue');
                }else if(omniQueue.Plan_Id__c == 'TX1'){
                    c.ownerid = caseQmap.get('OMNI_TX_Data_Entry_Queue');
                }
            }
            
            if(olist.size() > 0) 
            updateStdQueue( olist , omniQueuePrev.Case_Type__c );
        }else if(omniQueuePrev.Case_Type__c == 'Demographics'){
            string[] recordtypes = new list<string>();
            string[] rtypes = omniQueuePrev.Request_Type_s__c.split(';');        
            for(string s:rtypes){
                recordtypes.add(caseRMap.get(s));
            }
            olist = [select id, ownerid from case where Govt_Programs__c = false and status = 'New' 
                     and Plan_ID__c = :omniQueue.Plan_Id__c and ownerid = :omniQueuePrev.ownerid 
                     and recordtype.developername in :recordtypes];
            updateStdQueue( olist , omniQueuePrev.Case_Type__c);
        }else if(omniQueuePrev.Case_Type__c == 'CRM'){  
            //PPN-22916 
            List<String> crmRequestTypes    =   new List<string>();
            crmRequestTypes                 =   omniQueuePrev.Request_Type_s__c.split(';'); 
            System.debug(crmRequestTypes+'In side update Exiting omni queue for CRM =====>>>>'+omniQueuePrev.Case_Type__c);
            
            System.debug('In side CRM case block1111 =====>>>>'+omniQueuePrev.Request_Type_s__c);
            olist                           =   [select id, ownerid from case where Govt_Programs__c = false 
                                                 and status = 'New' 
                                                 and Plan_ID__c = :omniQueuePrev.Plan_Id__c 
                                                 and recordtype.developername = 'CRM'
                                                 and OwnerId = :omniQueuePrev.ownerId 
                                                 and CRM_Types__c  IN :crmRequestTypes and SkipOmniRouting__c='']; 
            updateStdQueue( olist , omniQueuePrev.Case_Type__c );
        }else{
            system.debug('We have a problem: Unmatched Case Type');
        }
    }    
    /*************************************************
    * Validates selected Case request type is part 
    * of any other existing queue or not
    *************************************************/
    public String validateQueue(String planId, SelectOption[] selectedRequests,String omniQueueName,Id objId )
    {
        List<String> options = new List<String>();
        String queueName ='';
        for(SelectOption option: selectedRequests )
        {
            options.add(option.getValue());
        }
        String query    =   'SELECT ' + Utils.getObjectFieldList('OMNI_Queue__c') +' FROM OMNI_Queue__c';
        query          =   query + ' where Plan_Id__c like \'%' + planId + '%\'';
        boolean hasCondition = false;
        if(!options.isempty()) 
        {
            hasCondition = true;
            query += '  AND ( Request_Type_s__c includes (\''+options[0]+'\'';
            options.remove(0);
        }
        while(!options.isempty()) 
        {
            query += ',\''+options[0]+'\'';
            options.remove(0);
        }
        if(hasCondition)
        {
            query += '))';
        }
        
        System.debug('query===>>>'+query);
        List<OMNI_Queue__c> omniQueueList   =   (List<OMNI_Queue__c>)Database.query( query );
        
        if(!omniQueueList.isEmpty())
        {
            for( OMNI_Queue__c omniRec : omniQueueList )
            {
                if( (objId!= null || objId!='')
                   && omniRec.Id!=objId)
                {
                    queueName=queueName+','+omniRec.Name;
                }
            }
            
        }else{
            queueName='';
        }
        queueName = String.isNotEmpty(queueName) ? queueName.substring(1):'';
        return queueName;
    }
    
    /***************************************************************************
     * validate Queue name entered while creating new queue
     * @inputs : Plan Id, Queue Name
     * @output : Exixting Queue names
     * *************************************************************************/
    public String validateQueueName(String planId,String omniQueueName,Id objId)
    {
        List<String> options = new List<String>();
        String queueName ='';
        for(SelectOption option: selectedRequests )
        {
            options.add(option.getValue());
        }
        String query    =   'SELECT ' + Utils.getObjectFieldList('OMNI_Queue__c') +' FROM OMNI_Queue__c';
        query           =   query + ' where Plan_Id__c like \'%' + planId + '%\'';
        query           =   query+'  AND Name=\''+omniQueueName+'\'';
             
        System.debug('query111'+query);       
        List<OMNI_Queue__c> omniQueueList   =   (List<OMNI_Queue__c>)Database.query( query );
        System.debug('omniQueueList1111'+omniQueueList);
        if(!omniQueueList.isEmpty())
        {
            for( OMNI_Queue__c omniRec : omniQueueList )
            {
                if( (objId!= null || objId!='')
                   && omniRec.Id!=objId)
                {
                    if(omniRec.Name==omniQueueName)
                      queueName=queueName+','+omniRec.Name;
                }
            }
        }else{
            queueName='';
        }
        queueName = String.isNotEmpty(queueName) ? queueName.substring(1):'';
        return queueName;
    }
    
    
    
    /**** To display the queues created by each state supervisor *****/
    public Pagereference doDisplayQueuerecords()
    {
        String omniQueueQueryStr    = 'SELECT ' + Utils.getObjectFieldList('OMNI_Queue__c') +' FROM OMNI_Queue__c';
        omniQueueQueryStr           =  omniQueueQueryStr + ' where Plan_Id__c like \'%' + planId + '%\'';
        omnireservedQueueList.clear();
        omniQueueList.clear();
        List<OMNI_Queue__c> tempOmniList = (List<OMNI_Queue__c>)Database.query( omniQueueQueryStr );
        Set<Id> omniQueueIds        =   new Set<Id>();
        
        for(Omni_Queue__c omniQue : tempOmniList)
        {
            omniQueueIds.add(omniQue.Id);
            if(String.isEmpty(omniQue.Case_Type__c))
            {
                omnireservedQueueList.add(omniQue);
            }else{
                omniQueueList.add(omniQue);
            }
            
        }
        Map<Id,OMNI_User_Group__c> omniUserGrpMap = new Map<Id,OMNI_User_Group__c>([Select id,Selected_Users__c from OMNI_User_Group__c where Id IN:omniQueueIds]);
        return null;
    }
    
    /*** Canel button functionalityto refresh the page ***/
    public pagereference refreshPage()
    {
        return (new pagereference('/apex/OMNIQueueManagementPage').setredirect(true));
    }
    
    /*** inner class to store left selected options ***/
    Public List<processorsWrapper> processorsWrap {set; get;}
    public class processorsWrapper
    {
        public String rowNumber;
        public List<SelectOption>   rightSideSelections {get; set;}    
    }
    
    /************************************************** 
     * Update Processorwrap 
     **************************************************/
    public void updateProcessWrap(List<OMNI_User_Group__c> userGroupList)
    {
        processorsWrap.clear();
        System.debug('userGroupList in update processWrap111====>>>'+userGroupList);
            counter     =   -1; 
            for( OMNI_User_Group__c rec : userGroupList )
            {
                counter =counter+1;
                string[] splitUsers;
                string[] splitUserIds;
                List<SelectOption>  roption = new List<SelectOption>();
                processorsWrapper pw            =   new processorsWrapper();
                pw.rowNumber                    =   String.valueOf(counter);
                if( String.isNotEmpty(rec.Selected_Users__c)  && String.isNotEmpty(rec.Selected_User_Ids__c)){
                    splitUsers = rec.Selected_Users__c.split(','); 
                    splitUserIds = rec.Selected_User_Ids__c.split(','); 
                    for (Integer i = 0; i < splitUsers.size(); i++) {
                        roption.add(new SelectOption(splitUserIds[i],splitUsers[i]));
                        system.debug('roption:' + roption);
                    }
                }
                pw.rightSideSelections  = roption;
                processorsWrap.add(pw);
            }
    }
    
    /***************** Update left options **************************/
    Public void updateLeftOptions( Set<String> processorSet )
    {
       System.debug('processorSet===>>>>>>'+processorSet);
        allProcessors.clear();
        List<String> userNames  =   new List<String>();
        Set<String> usersSet = new Set<String>();
        List<SelectOption> tempOptionList = new List<SelectOption>();
       
        if(!allProcessors.isEmpty()){
        for(SelectOption option : allProcessors)
        {
            System.debug(option.getValue()+'inside update===>>>option===>>>'+option.getLabel());
            if(!processorSet.contains(option.getLabel()))
            {
                usersSet.add(option.getLabel());
            } 
        }
        }else{
      System.debug('processorSet else loop===>>>'+processorSet);
         for( User usr : userList)
        {
            if(!processorSet.contains(usr.Name)){
              usersSet.add(usr.Name);
            }
         }
        }
        
        for( User usr : userList)
        {
            if(usersSet.contains(usr.Name))
            {
                userNameWithId.put(usr.name, usr.Id);
                userNames.add(usr.name); 
            }
            userNames.sort();
        }
        
        if(userNames.size()>0)
        {
            allProcessors.clear();
            for(String names : userNames)
            {
                allProcessors.add(new SelectOption(userNameWithId.get(names),names));
            }
        }
    }
    
    public Set<String> getNames(List<SelectOption> optionList )
    {
        Set<String> pNames = new Set<String>();
        
        for(SelectOption option : optionList)
        {
            pNames.add(option.getLabel());
        }
        return pNames;
    }
    
    public String getProcessorIdsStr(Set<String> processorNames){
        
        String processorIds='';
        for(String prosName: processorNames){
            processorIds = processorIds+','+globalUserNameWithId.get(prosName);
        }
        processorIds = processorIds.substring(1);
        return processorIds;
    }
   
}