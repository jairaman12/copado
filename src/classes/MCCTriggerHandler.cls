/**************************************************************************************************
Apex Class Name  : MCCTriggerHandler
Version          : 1.0  
Functionality    : Refinifing the data when a new data ( Death file / Network request file ) loaded onto
salesforce MCC Data Object. Based on file data we will be creating the master and child cases
Modification Log :

-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru           05/17/2018             PPN-16123,PPN-16127, PPN-16130
* Travis Self                 05/17/2018             PPN-17068
* Saravana Bharathi           05/28/2018             PPN-16131
* SethuRaman                  06/11/2018             PPN-15304, PPN-15288
* Sujatha                     06/11/2018             PPN-16157, PPN-15296, PPN-18002
* Subhashini                  06/14/2018             PPN-15292
* Sreekanth Kalluru           09/17/2018             PPN-25417
* Travis Self                 10/25/2018             PPN-27401
* Ashok N                     11/08/2018             PPN-27739
* Ashok N                     11/15/2018             PPN-26925
* Saravana Bharathi           11/26/2018             PPN-22389
* Josh McGhee                 01/31/2019             PPN-31194
* Ashok N                     01/31/2019             PPN-27738
* Ashok N                     02/25/2019             PPN-30357
* Ashok N                     02/28/2019             PPN-34061
* Ashok N                     03/6/2019              PPN-30878,PPN-30876
* Ashok N                     06/11/2019             PPN-40428
* Laxman, Suman               06/24/2019             PPN-41284
***************************************************************************************************/
public class MCCTriggerHandler 
{
    public Set<Id> processedRecprds                                             =   new Set<Id>();
    public Set<Id> processedMCCRecords                                          =   new Set<Id>();
    private String deathFileType                                                =   'DF';
    //private String networkRequestType                                           =   'Network Recruitment';
    private String MassCRMCreation                                           =   'Mass CRM Creation';// Added the new field PPN-26925
    private String rosterFile                                                   =   'ILR'; 
    private String onBoardingCredRequestType                                    =   'Onboarding Cred Mass Status Update'; //PPN-25417
    private String crmMassStatusType                      =   'CRM Mass Status';  //PPN-27401
    
    private Map<String,MCC_Data_Object__c> onBoardingCredRecordsMap             =   new Map<String,MCC_Data_Object__c>();
    private Map<String, List<MCC_Data_Object__c> >  deathFileRecordsMap         =   new Map<String,List<MCC_Data_Object__c>>();
    Map<String,MCC_Data_Object__c>  networkRequestRecordsMap  =   new Map<String,MCC_Data_Object__c>();
    
    private Map<String, List<MCC_Data_Object__c>> rosterFileMap                 = new Map<String, List<MCC_Data_Object__c>>();
    //PPN-22986,PPN-25549
    private Map<String,MCC_Data_Object__c> masscloseRecordsMap                  =   new Map<String,MCC_Data_Object__c>();
    private Map<String,MCC_Data_Object__c> crmMasscloseRecordsMap               =   new Map<String,MCC_Data_Object__c>();  //PPN-27401
    private Map<String,Account> provIdWithAccountMap                            =   new Map<String,Account>();
    Set<String> TaxIdSet                                                        =   new Set<String>(); //PPN-15292
    Set<String> NPIIdSet                                                        =   new Set<String>(); //PPN-15292
    Public Map<Id, List<CM_Provider_Identification__c>> accwithNPIMap           =   new Map<Id, List<CM_Provider_Identification__c>>(); //PPN-15292 
    Public Map<Id,  List<CM_Provider_Tax_Id__c>> accwithTaxIdMap                =   new Map<Id,  List<CM_Provider_Tax_Id__c>>(); //PPN-15292 
    Public Map<String, Id> accwithNPITaxIdMap                                   =   new Map<String, Id>(); //PPN-15292 
    Public static Map<String,Account> provIdWithAccountIdMap                    =   new Map<String,Account>();
    Public Set<String> provIdSet                                                =   new Set<String>();
    String defaultCaseStatus                                                    =   'New';
    String defaultCasePriority                                                  =   'Medium';
    String crmTypeForDeathFile                                                  =   'Death File';
    Set<String> planIdSet   =  new Set<String>();
    Id networkRecordTypeId,deathFileRecordTypeId;
    Id rosterRecordTypeId;
    Map<String,MCC_Data_Object__c> networkLoadMassData                          =   new Map<string,MCC_Data_Object__c>();
    List<MCC_Data_Object__c> ListMCCDataObject                               =   new List<MCC_Data_Object__c>();
    
    public MCCTriggerHandler()
    {
        String[] planIds = GlobalSettings__c.getValues('PFFileRecieved').Acceptable_Plan_Ids__c.split(',');
        planIdSet.addAll(planIds);
        
    }
    
    
    /****
    * @input: List of Mcc data objects
    * @output: Map of Death file and Network type recordtype
    ****/
    public void onbeforeInsert ( List<MCC_Data_Object__c> newList )
    {
        Set<String> setOfProvIds = new Set<String>();
        Set<String> setOfCaseIds = new Set<STring>();
        for(MCC_Data_Object__c newData:newList)
        {
            if(newData.MCC_File_Type__c == deathFileType)
            {
                newData.RecordTypeId=Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Death_File').getRecordTypeId();
            }
            else if(newData.MCC_Request_Type__c == MassCRMCreation) //PPN-18002 Change
            {
                newData.RecordTypeId=Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Network_Recruitment').getRecordTypeId();
            }
            else if (newData.MCC_File_Type__c == rosterFile) //PPN-18002 Change
            {
                newData.RecordTypeId    =   Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Roster').getRecordTypeId();
                newData.MCC_Plan_ID__c  =   'IL1';
            }

            
            if(newData.MCC_Prov_ID__c != null && setOfProvIds.contains(newData.MCC_Prov_Id__c))
            {
                newData.MCC_Load_Status__c = false;
            }
            if(newData.MCC_Prov_Id__c !=NULL)
            {
                setOfProvIds.add(newData.MCC_Prov_ID__c);
            }
            if(newData.Onboarding_Case_Id__c!= null && setOfCaseIds.contains(newData.Onboarding_Case_Id__c))
            {
                newData.MCC_Load_Status__c = false;
            }
            if(newData.Onboarding_Case_Id__c!=NULL)
            {
                setOfCaseIds.add(newData.Onboarding_Case_Id__c);
            }
            if(newData.Cred_Cycle__c !=NULL && newData.Cred_Cycle__c !='I' && newData.Cred_Cycle__c !='R' )
            {
                newData.MCC_Load_Status__c = false;
            } 
        }
        
        Map<String,String> mapOfProvIdAndPlanId = new Map<String,String>();
        List<Account> List_AccountQuery= new List<Account>();
        List_AccountQuery=[Select Prov_Id__c, CM_Corporate_Entity_Code__c From Account where Prov_Id__c In:setOfProvIds];
        system.debug('List_AccountQuery'+List_AccountQuery);
        for(Account newAccount:List_AccountQuery)
        {
            mapOfProvIdAndPlanId.put(newAccount.Prov_Id__c,newAccount.CM_Corporate_Entity_Code__c);
        }
        system.debug('mapOfProvIdAndPlanId'+mapOfProvIdAndPlanId);
        for(MCC_Data_Object__c newData:newList)
        {
            if(newData.MCC_Prov_Id__c !=NULL && mapOfProvIdAndPlanId.containsKey(newData.MCC_Prov_Id__c))
            {
                if(newData.MCC_File_Type__c!='Onboarding Cred Mass Status Update')//Added A condtion because to consildate the logic
                    newData.MCC_plan_Id__c = mapOfProvIdandPlanId.get(newData.MCC_Prov_Id__c);
                system.debug('newData.MCC_plan_Id__c'+newData.MCC_plan_Id__c);
            }
        }        
        
        
    }    
    
    /****
    * @input: List of Mcc data objects
    * @output: Map of Death file and Network type records List
    ****/
    public void onAfterInsert ( List<MCC_Data_Object__c> newList )
    { 
        System.debug('newList===>>>'+newList.size());
        List<MCC_Data_Object__c> onboardingList = new List<MCC_Data_Object__c>();
        for( MCC_Data_Object__c mccRecord : newList )
        {
            
            /*
            * PPN-27739
            */
            if(mccRecord.MCC_File_Type__c == 'Network Load Mass Status')
            {
                networkLoadMassData.put( mccRecord.MCC_Case_Id__c,mccRecord);
                ListMCCDataObject.add(mccRecord);
                
            }
            
            System.debug('mccRecord.MCC_File_Type__c===>>>>'+mccRecord.MCC_File_Type__c);
            if( processedMCCRecords.contains( mccRecord.Id ) ) continue;
            processedMCCRecords.add( mccRecord.Id ); 
            If( !planIdSet.isEmpty() && planIdSet.contains(mccRecord.MCC_Plan_ID__c))
            {    
                system.debug('Test====');
                if( mccRecord.MCC_File_Type__c == deathFileType ) //mccRecord.MCC_Request_Type__c coming up null
                {
                    List<MCC_Data_Object__c> tempMccList    =   new List<MCC_Data_Object__c>(); 
                    if( deathFileRecordsMap.isEmpty() )
                    {
                        tempMccList.add( mccRecord );
                        deathFileRecordsMap.put( mccRecord.MCC_File_Type__c , tempMccList );
                    }else
                    {
                        deathFileRecordsMap.get( deathFileType ).add( mccRecord );
                    }
                }
                else if(mccRecord.MCC_File_Type__c == MassCRMCreation)
                {
                    ListMCCDataObject.add( mccRecord );
                    networkRequestRecordsMap.put(mccRecord.Name,mccRecord);
                }                
            }  
            if(mccRecord.MCC_File_Type__c == rosterFile && mccRecord.MCC_Project_Number__c != NULL)
            {
                if(rosterFileMap.containsKey(mccRecord.MCC_Project_Number__c)){
                    rosterFileMap.get(mccRecord.MCC_Project_Number__c).add(mccRecord);
                }
                else{
                    rosterFileMap.put(mccRecord.MCC_Project_Number__c, new List<MCC_Data_Object__c>{mccRecord});
                }
            }  
            /*************************************************************
            * PPN-25417
            * Below code is to conslodiate the onBoradingCredential cases
            * received through FTP
            ************************************************************/
            if(!String.isEmpty( mccRecord.MCC_File_Type__c)  && mccRecord.MCC_File_Type__c == onBoardingCredRequestType && mccRecord.Bad_Data__c ==False) 
            {
                System.debug('Coming inside onboarding');
                onboardingList.add(mccRecord);
                
            }
            /*************************************************************
            * PPN-22549
            * Below code is to mass close cases
            * received through FTP
            ************************************************************/
            //System.debug('mccRecord.MCC_File_Type__c===>>>>'+mccRecord.MCC_File_Type__c);
            if(!String.isEmpty(mccRecord.MCC_File_Type__c)  && mccRecord.MCC_File_Type__c == 'ADC Mass Status' ) 
            {
                //System.debug('mccRecord.MCC_File_Type__c===>>>>'+mccRecord.MCC_File_Type__c);
                if(!masscloseRecordsMap.containsKey( mccRecord.MCC_Case_Id__c )){
                    masscloseRecordsMap.put( mccRecord.MCC_Case_Id__c,mccRecord);
                }
            }
            /*************************************************************
            * PPN-27401
            * Below code is to mass close CRM cases received through FTP
            ************************************************************/
            if(!String.isEmpty(mccRecord.MCC_File_Type__c)  && mccRecord.MCC_File_Type__c == crmMassStatusType ) 
            {
                if(!crmMasscloseRecordsMap.containsKey( mccRecord.MCC_Case_Id__c )){
                    crmMasscloseRecordsMap.put( mccRecord.MCC_Case_Id__c,mccRecord);
                }
            } 
            
            
        }
        System.debug('massRecordsMap===>>>>'+masscloseRecordsMap);
        
        System.debug('onBoardingCredRecordsMap===>>>>'+onboardingList);
        System.debug('deathFileRecordsMap===>>>'+deathFileRecordsMap);
        System.debug('networkRequestRecordsMap===>>>'+networkRequestRecordsMap);
        system.debug('##### rosterFileMap ####' + rosterFileMap);
        
        if(!masscloseRecordsMap.isEmpty()){
            massCasesClose(masscloseRecordsMap);
        }
        //PPN-27401
        if( !crmMasscloseRecordsMap.isEmpty() ) {
            massCasesClose(crmMasscloseRecordsMap);
        }
        if( !networkRequestRecordsMap.isEmpty() )
        {
            insertNetworkFileRecords(networkRequestRecordsMap,ListMCCDataObject);
        }
        if( !rosterFileMap.isEmpty() ){
            insertRosterFileRecords ( rosterFileMap );
        }
        //PPN-25417 changes
        if(!onboardingList.isEmpty())
        {
            onBoardingCredStatusUpdate( onboardingList);
        }
        /*PPN-27739
        * Date:
        * Author :
        * 
        */
        if(networkLoadMassData.size()>0)
        {
            networkLoadMassStatus(networkLoadMassData,ListMCCDataObject);
        }
        
    }
    
    
    
    /****
    * @input : Map of map request type name with Group Id records as list
    * @output: Master case and child case creation for Network request file
    *          Child case records to be passed on to schduler class
    ****/
        /****
    * @input : Map of map request type name with Group Id records as list
    * @output: Master case and child case creation for Network request file
    *          Child case records to be passed on to schduler class
    
    Author : Unknown
    * Date : Unknown
    * ver  : 1.0 
    ==================================================================================
    * Author : Ashok N
    * Business Purpose: Please refer the StoryBoardNumber :PPN-15304 ,PPN-15288
    * Date : 01/10/2019
    * ver :2.0 
    * StoryBoardNumber :PPN-22986,PPN-25549,PPN-27401
    */
    public static void insertNetworkFileRecords( Map<String,MCC_Data_Object__c> networkRequestMapToMapOfList, List<MCC_Data_Object__c> ListMCCDataObject)
    {
        MassCreationDataObjectQuery   MassCreationDataObject = new MassCreationDataObjectQuery();
        system.debug('networkRequestMapToMapOfList=== '+networkRequestMapToMapOfList.keyset());
        List<Case> networkMasterCaseList    =   new List<Case>();
        List<Case> networkChildCaseList     =   new List<Case>();
        Set<String> SetOfQueueNames = new Set<String>();
        Set<String> SetOfEmployeeIds = new Set<String>();
        Map<String,Id> mapOfQueueAndItsId = new Map<String,Id>();
        MassCreationDataObjectQuery MassCreationData= new MassCreationDataObjectQuery();
        Map<String,Id> mapOfEmployeeIdAndItsId = new Map<String,Id>();
        Map<String,String> MCC_GroupingId = new Map<String,String>();
        Set<String> Set_GroupingID = new Set<String>();
        Map<Id,GlobalSettings__c> GetGlobalSettingValues= MassCreationData.getGlobalCustomSetting();
        Map<Integer,String> CustomSetting_MCC_Case_Origin= new Map<Integer,String>();
        
        for(GlobalSettings__c GlobalSetting : GetGlobalSettingValues.values())
        {
            if(GlobalSetting.Name=='PFFileRecieved')
            {
                CustomSetting_MCC_Case_Origin.put(0,GlobalSetting.MCC_Case_Origin__c);
            }
        }
        
        Set<string> Set_ProviderID = new Set<String>();
        Map<String,String> Map_MCC_Grouping_ID= new Map<String,String>();
        Map<String,String> Map_MCC_Case_Status= new Map<String,String>();
        Map<String,String> Map_MCC_Project_Number= new Map<String,String>();
        Map<String,String> Map_MCC_Plan_ID= new Map<String,String>();
        for(MCC_Data_Object__c newData:networkRequestMapToMapOfList.values())
        {
            SetOfQueueNames.add(newData.MCC_Override_Queue__c);
            SetOfEmployeeIds.add(newData.MCC_Assignee_ID__c);
            MCC_GroupingId.put(newData.Name,newData.MCC_Grouping_ID__c);
            Set_GroupingID.add(newData.MCC_Grouping_ID__c);
            if(newData.MCC_Prov_ID__c!=null)
            {
                Set_ProviderID.add(newData.MCC_Prov_ID__c); 
            }
            Map_MCC_Grouping_ID.put(newData.MCC_Grouping_ID__c,newData.MCC_Grouping_ID__c);
            Map_MCC_Case_Status.put(newData.MCC_Grouping_ID__c,newData.MCC_Case_Status__c);
            Map_MCC_Project_Number.put(newData.MCC_Grouping_ID__c,newData.MCC_Project_Number__c);
            Map_MCC_Plan_ID.put(newdata.MCC_Grouping_ID__c,newData.MCC_Plan_ID__c);
        } 
        Map<Id,Account> getAccountQueryValues= MassCreationData.getAccount(Set_ProviderID);
        Map<String,Id> Map_AccountId= new Map<String,Id>();
        Map<String,String> Map_AccountRecordTypeName= new Map<String,String>();
        for(Account AccountValues : getAccountQueryValues.values())
        {
            Map_AccountId.put(AccountValues.Prov_ID__c,AccountValues.Id);
            Map_AccountRecordTypeName.put(AccountValues.Prov_ID__c,AccountValues.recordtype.developerName);
        }
        String Queue='Queue';
        String DeveloperName='';
        Map<Id,Group> Map_GroupValues= new Map<Id,Group>();
        //Query the group values 
        Map_GroupValues=MassCreationData.getGroupQuery(Queue, DeveloperName, SetOfQueueNames);
        for(Group GroupValues : Map_GroupValues.values())
        {
            mapOfQueueAndItsId.put(GroupValues.name,GroupValues.Id);
        }
        Map<Id,User> Map_UserQueryValues= new Map<Id,User>();
        Map_UserQueryValues=MassCreationData.getUser(SetOfEmployeeIds);
        for(User UserValues : Map_UserQueryValues.values())
        {
            mapOfEmployeeIdAndItsId.put(UserValues.employeeNumber,UserValues.Id);
        }
        
        //TO Query the case Values by using Group_ID__C(())
        system.debug('Set_GroupingID=== '+Set_GroupingID);
        Map<Id,Case> Map_CaseQueryValues= MassCreationData.getCaseGroupValues(Set_GroupingID);
        system.debug('Map_CaseQueryValues=== '+Map_CaseQueryValues);
        Map<String,String> Map_ParentCaseId = new Map<String,String>();
        Map<String,Id> Map_ExistingParentCaseId = new Map<String,Id>();
        Map<String,String> CheckGroupNumber_Case = new Map<String,String>();
        for(case CaseValues : Map_CaseQueryValues.values())
        {
            
            Map_ParentCaseId.put(CaseValues.Grouping_ID__c,CaseValues.parentId);
            CheckGroupNumber_Case.put(CaseValues.Grouping_ID__c,CaseValues.Grouping_ID__c);
        }
        //Master CRM Case Data  
        system.debug('Map_ParentCaseId=== '+Map_ParentCaseId.size()+'==== >>> '+Map_ParentCaseId);
        String SobjectType='Case'; 
        Map<Id,RecordType> getCaseRecordTypeValues= MassCreationData.getRecordType(SobjectType);
        system.debug('getCaseRecordTypeValues=== '+getCaseRecordTypeValues);
        Map<Integer,Id> Map_Master_CRM_Case_Data = new Map<Integer,Id>();
        Map<Integer,Id> Map_CRMRecordType = new Map<Integer,Id>();
        for(RecordType RecordTypeValues : getCaseRecordTypeValues.values())
        {
            if(RecordTypeValues.DeveloperName.containsIgnoreCase('Master_CRM_Case_Data'))
            {
                Map_Master_CRM_Case_Data.put(0,RecordTypeValues.Id); 
            }else if(RecordTypeValues.DeveloperName.containsIgnoreCase('CRM')){
                Map_CRMRecordType.put(1,RecordTypeValues.Id);
            }
        }
        system.debug('Set_GroupingID=== '+Set_GroupingID);
        for(String MastercaseId :Set_GroupingID)
        {
            if(CheckGroupNumber_Case.get(MastercaseId)!=MastercaseId)
            {
                Case MasterNetworkMasterCase           =   new Case();
                MasterNetworkMasterCase.Grouping_ID__c =   Map_MCC_Grouping_ID.get(MastercaseId);
                //networkMasterCase.OwnerId        =   userInfo.getUserId();//This will Assign to 
                //Integration User Always (U393129 Need Clarification) need to check the userName
                MasterNetworkMasterCase.RecordTypeId   =   Map_Master_CRM_Case_Data.get(0);
                MasterNetworkMasterCase.status         =   Map_MCC_Case_Status.get(MastercaseId);
                MasterNetworkMasterCase.Project_Number__c  =   Map_MCC_Project_Number.get(MastercaseId);
                MasterNetworkMasterCase.Plan_ID__c     =  Map_MCC_Plan_ID.get(MastercaseId);
                MasterNetworkMasterCase.Priority       = 'Medium';//  defaultCasePriority;(U393129 Need Clarification)
                MasterNetworkMasterCase.Origin         =   CustomSetting_MCC_Case_Origin.get(0);
                networkMasterCaseList.add( MasterNetworkMasterCase );
            }
            
        }
        
        
        system.debug('networkMasterCaseList==>> '+networkMasterCaseList.size());
        Database.SaveResult[] Network_ParentCaseCreation;
        Set<Id> NetWorkMasterCaseId = new Set<Id>();
        List<String> List_Error= new List<String>();
        if(networkMasterCaseList.size()>0)
        {
            try{
                Network_ParentCaseCreation=database.insert(networkMasterCaseList, false); 
            }catch(DmlException e)
            {
                system.debug('Exception=='+e.getMessage());
            }
        }
        
        // system.debug('Network_ParentCaseCreation=='+Network_ParentCaseCreation.size());
        Map<Id,Case> GetCaseValues= new Map<Id,Case>();
        if(networkMasterCaseList.size()>0)
        {
            for (Database.SaveResult sr : Network_ParentCaseCreation) 
            {
                if(Sr.isSuccess())
                {
                    NetWorkMasterCaseId.add(sr.getId());
                }else{
                    for(Database.Error err : sr.getErrors()) {
                        List_Error.add(err.getMessage());
                    }
                }
            }
        }
        if(NetWorkMasterCaseId.size()>0)
        {
            GetCaseValues = MassCreationData.getCaseQueryRecord(NetWorkMasterCaseId);
        }
        system.debug('GetCaseValues=== '+GetCaseValues);
        Map<String, Id> insertedMasterCaseMap = new Map<String, Id>();
        for(Case existingCase : GetCaseValues.values())
        {
            Map_ParentCaseId.put(existingCase.Grouping_ID__c , existingCase.Id);
        }
        Map<Id,Case> insertILRChildCases = new Map<Id,Case>();
        system.debug('Map_ParentCaseId=== '+Map_ParentCaseId);
        List<MCC_Data_Object__c> listOfAllRecords = new List<MCC_Data_Object__c>();
        List<case> Insert_NetworkChildCase = new List<case>();
        system.debug('networkRequestMapToMapOfList=== '+networkRequestMapToMapOfList.size());
        for(MCC_Data_Object__c MCC_Data_Object:networkRequestMapToMapOfList.values())
        {
            if(Map_ParentCaseId.get(MCC_Data_Object.MCC_Grouping_ID__c)!=null)
            {
                Case networkChildCase = new Case();
                networkChildCase.RecordTypeId = Map_CRMRecordType.get(1);
                if(MCC_Data_Object.MCC_Case_Status__c !=NULL)
                {
                    networkChildCase.Status = MCC_Data_Object.MCC_Case_Status__c;
                }
                else
                {
                    networkChildCase.Status = 'New';
                }
                networkChildCase.Plan_ID__c            =   MCC_Data_Object.MCC_Plan_ID__c;
                networkChildCase.Project_Number__c     =   MCC_Data_Object.MCC_Project_Number__c;
                networkChildCase.Grouping_ID__c=MCC_Data_Object.MCC_Grouping_ID__c;
                networkChildCase.MCC_Record_Name__c    =   MCC_Data_Object.Name;
                networkChildCase.CRM_Types__c          =   MCC_Data_Object.MCC_Request_Type__c;
                if(MCC_Data_Object.MCC_Priority__c!=null)
                {
                    networkChildCase.Priority= MCC_Data_Object.MCC_Priority__c; 
                }
                else{
                    networkChildCase.Priority='Medium';
                }
                networkChildCase.Origin = CustomSetting_MCC_Case_Origin.get(0);
                networkChildCase.ParentId  =  Map_ParentCaseId.get(MCC_Data_Object.MCC_Grouping_ID__c) ;  
                if(MCC_Data_Object.MCC_Assignee_ID__c !=NULL && 
                   mapOfEmployeeIdAndItsId.containsKey(MCC_Data_Object.MCC_Assignee_ID__c)) 
                {
                    networkChildCase.OwnerId               =   mapOfEmployeeIdAndItsId.get(MCC_Data_Object.MCC_Assignee_ID__c);
                    networkChildCase.Status                = 'New';
                    networkChildCase.SkipOmniRouting__c    = 'true';//PPN-16124 Code Added
                    networkChildCase.Plan_ID__c=MCC_Data_Object.MCC_Plan_ID__c;
                }
                else if((MCC_Data_Object.MCC_Assignee_ID__c==NULL &&  MCC_Data_Object.MCC_Override_Queue__c !=NULL && 
                         mapOfQueueAndItsId.containsKey(MCC_Data_Object.MCC_Override_Queue__c))
                        ||(MCC_Data_Object.MCC_Assignee_ID__c !=NULL && mapOfEmployeeIdAndItsId !=NULL 
                           && !mapOfEmployeeIdAndItsId.containsKey(MCC_Data_Object.MCC_Assignee_ID__c))
                       )
                {
                    networkChildCase.OwnerId               =   mapOfQueueAndItsId.get(MCC_Data_Object.MCC_Override_Queue__c);
                    networkChildCase.Status                ='New';                         
                    networkChildCase.SkipOmniRouting__c    = 'true';//PPN-16124 code added
                    
                }
                if(Map_AccountRecordTypeName.get(MCC_Data_Object.MCC_Prov_ID__c)=='Entity_Account')
                {
                    networkChildCase.Case_Entity__c = Map_AccountId.get(MCC_Data_Object.MCC_Prov_ID__c);   
                }else if (Map_AccountRecordTypeName.get(MCC_Data_Object.MCC_Prov_ID__c)=='Physician')
                {
                    networkChildCase.AccountId = Map_AccountId.get(MCC_Data_Object.MCC_Prov_ID__c); 
                }
                Insert_NetworkChildCase.add(networkChildCase);
            }
        }
        Database.SaveResult[] Insert_ChildNetworkCase; 
        List<String> List_Error_Message= new List<String>();
        Set<Id> InsertCaseId= new Set<Id>();
        Set<Id> NetWorkChildCaseId = new Set<Id>();
        system.debug('Insert_NetworkChildCase===>>> '+Insert_NetworkChildCase+'=====  '+Insert_NetworkChildCase.size());
        if(Insert_NetworkChildCase.size()>0)
        {
            try{
                Insert_ChildNetworkCase=database.insert(Insert_NetworkChildCase,false);
            }catch(DmlException e)
            {
                system.debug('Exception===e');
            }
        }
        for (Database.SaveResult sr : Insert_ChildNetworkCase)
        {
            if (sr.isSuccess()) 
            {
                NetWorkChildCaseId.add(sr.getId());
            }
            else 
            {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) 
                {
                    List_Error_Message.add(err.getMessage());
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
            
        }
        system.debug('NetWorkCaseId==== '+NetWorkChildCaseId);
        GetCaseValues = MassCreationData.getCaseQueryRecord(NetWorkChildCaseId);
        Set<Id> CaseNumberSucess= new set<Id>();
        system.debug('GetCaseValues=== >> '+GetCaseValues.size());
        Map<Id,Id> Map_CaseNumber= new Map<Id,Id>();
        Map<String,String> NewtworkLoad_MCC_Plan_ID= new Map<String,String>();
        Map<Id,MCC_Data_Object__c>  MapUpdate_MCC_Data_Object = new Map<Id,MCC_Data_Object__c>();
        Map<String,Id> Map_MCC_CaseId= new Map<String,Id>();
        for(Case Case_UpdatedSuccessfully : GetCaseValues.values())
        {
            CaseNumberSucess.add(Case_UpdatedSuccessfully.ID);
            Map_CaseNumber.put(Case_UpdatedSuccessfully.Id,Case_UpdatedSuccessfully.Id);
            NewtworkLoad_MCC_Plan_ID.put(Case_UpdatedSuccessfully.MCC_Record_Name__c,Case_UpdatedSuccessfully.Plan_ID__c);
            Map_MCC_CaseId.put(Case_UpdatedSuccessfully.MCC_Record_Name__c,Case_UpdatedSuccessfully.Id);
        }
        for(MCC_Data_Object__c MCC_Data_Object : ListMCCDataObject)
        {
            MCC_Data_Object__c Update_MCC_Data_Object = new MCC_Data_Object__c();
            Update_MCC_Data_Object.id=MCC_Data_Object.Id;
            if(Map_MCC_CaseId.containskey(MCC_Data_Object.Name))
            {
                Update_MCC_Data_Object.MCC_Load_Status__c=true;
                Update_MCC_Data_Object.MCC_Case_Id__c=Map_MCC_CaseId.get(MCC_Data_Object.Name);
                if(NewtworkLoad_MCC_Plan_ID.get(MCC_Data_Object.Name)!=null)
                {
                    Update_MCC_Data_Object.MCC_Plan_ID__c=NewtworkLoad_MCC_Plan_ID.get(MCC_Data_Object.Name);
                }else{
                    Update_MCC_Data_Object.MCC_Plan_ID__c='ID';
                }
            }
            else
            {
                for(String ErrorMessage : List_Error_Message)
                {
                    Update_MCC_Data_Object.MCC_Load_Status__c=false; 
                    Update_MCC_Data_Object.MCC_Plan_ID__c=MCC_Data_Object.MCC_Plan_ID__c;
                    Update_MCC_Data_Object.Error_Message__c=ErrorMessage;
                }
                
            }
            
            MapUpdate_MCC_Data_Object.put(Update_MCC_Data_Object.id,Update_MCC_Data_Object);
        } 
        system.debug('MapUpdate_MCC_Data_Object=== '+MapUpdate_MCC_Data_Object);
        if(MapUpdate_MCC_Data_Object.size()>0)
        {
            try{
                update MapUpdate_MCC_Data_Object.values();
            }catch(DmlException e)
            {
                system.debug('Exception==e'+e.getMessage());
            }
        }
        
        
        
        
    }
    
    /*
    * PPN-15304: Roster File Master Case Creation
    PPN-15288: Roster File Child Case Creation
    */
    public void insertRosterFileRecords ( Map<String, List<MCC_Data_Object__c>> rosterFileMap)
    {
        Id masterILRrecordTypeId;
        Id childILRrecordTypeId;
        Id illinoisQueueId;
        
        for(Group illinoisgroup : [SELECT Id, developerName FROM Group WHERE type = 'Queue' AND developerName = 'Illinois_Queue' LIMIT 1]){
            illinoisQueueId = illinoisgroup.Id ;
        }
        
        List<Case> insertILRMasterCases = new List<Case>();
        
        for(RecordType rt : [SELECT Id, Name, DeveloperName FROM RecordType WHERE sobjectType = 'Case' AND (DeveloperName = 'Master_Mass_Case_IL_Roster' OR DeveloperName = 'Child_Mass_Case_IL_Roster')]){
            if(rt.DeveloperName == 'Master_Mass_Case_IL_Roster'){
                masterILRrecordTypeId = rt.Id;
            }
            else if(rt.DeveloperName == 'Child_Mass_Case_IL_Roster'){
                childILRrecordTypeId = rt.Id; 
            }
        }
        
        Map<string, Case> existingCaseMap = new Map<string, Case>(); 
        List<Case> caseList = [SELECT Id, Project_Number__c FROM Case WHERE Project_Number__c != NULL AND ParentId =: NULL AND Project_Number__c IN: rosterFileMap.keySet()];
        if(caseList != NULL){
            for(Case curCase : caseList){
                existingCaseMap.put(curCase.Project_Number__c , curCase);
            }        
        }
        
        for(String projectNumber : rosterFileMap.keySet()){
            if(existingCaseMap.containsKey(projectNumber)){
                continue;
            }
            Case masterCase = new Case();
            masterCase.recordTypeId = masterILRrecordTypeId;
            masterCase.Origin = 'Mass Case Creation';
            masterCase.Plan_ID__c = 'IL1';
            masterCase.Priority = 'Medium';
            masterCase.Status = 'New';
            masterCase.Project_Number__c = projectNumber;
            masterCase.ownerId = illinoisQueueId ;
            insertILRMasterCases.add(masterCase);            
        }
        
        if( !insertILRMasterCases.isEmpty() ){
            try{
                Database.insert(insertILRMasterCases);
            }
            catch(Exception e){
                System.debug('#### Exception Occured while creation of ILR Master Cases ### ' + e.getMessage());
            }
        }
        
        Map<String, String> insertedMasterCaseMap = new Map<String, String>();
        for(Case insertedCase : [SELECT Id, Project_Number__c FROM Case WHERE Id IN: insertILRMasterCases]){
            insertedMasterCaseMap.put(insertedCase.Project_Number__c , insertedCase.Id);
        }
        for(Case existingCase : existingCaseMap.values()){
            insertedMasterCaseMap.put(existingCase.Project_Number__c , existingCase.Id);
        }
        system.debug('###### insertedMasterCaseMap #####' + insertedMasterCaseMap);
        
        List<Case> insertILRChildCases = new List<Case>();
        List<MCC_Data_Object__c> listOfAllRecords = new List<MCC_Data_Object__c>();
        for(List<MCC_Data_Object__c> mcc : rosterFileMap.values())
        {
            listOfAllRecords.addAll(mcc);
        }
        system.debug('###### listOfAllRecords #####' + listOfAllRecords);
        for(MCC_Data_Object__c mcc:listOfAllRecords)
        {
            /*
            * PPN-36640
            * Below code added to verify if Coroprate received date available on a roster file.
            * If available will convert that into a datetime value
            */
            Datetime corpDateTime;
            If( mcc.MCC_Corp_Recd_Date__c != null )
            {
                Date mccCorpDate               = Date.parse(mcc.MCC_Corp_Recd_Date__c);    
                corpDateTime                   = Datetime.newInstance( mccCorpDate.year(), mccCorpDate.month(),mccCorpDate.day() );
            }
            Case childCase = new Case();
            childCase.recordTypeId          =   childILRrecordTypeId;
            childCase.Origin                =   'Mass Case Creation';
            childCase.Plan_ID__c            =   'IL1';
            childCase.Priority              =   'Medium';
            childCase.status                =   'New';
            childCase.ownerId               =   illinoisQueueId;
            childCase.Corporate_Received_Date_Time__c   =   corpDateTime !=null ? corpDateTime : Datetime.now();
            childCase.MCC_Record_Name__c    =   mcc.Name;
            childCase.Request_type__c       =   mcc.MCC_Request_Type__c; 
            childCase.Billing_NPI_Number__c =   mcc.MCC_Billing_NPI__c; //PPN-15292
            childCase.Tax_ID_Number__c      =   mcc.MCC_Tax_ID__c;   //PPN-15292   
            childCase.Project_Number__c     =   mcc.MCC_Project_Number__c;//PPN-15293
            //PPN-16157 & PPN-15296 start
            childCase.MC_PFIN__c            =   mcc.MCC_PFIN__c;
            childCase.Bill_PFIN__c          =   mcc.Bill_PFIN__c;
            
            if(mcc.Government__c!= null && mcc.Government__c.equalsIgnoreCase('Y'))
            {
                childCase.Govt_Programs__c=true;
            }
            if(mcc.Action__c!= null && mcc.Action__c=='Add')
            {
                childCase.MC_Add__c=true;                                      
            }
            else if(mcc.Action__c!= null && mcc.Action__c=='Change')
            {
                childCase.MC_Change__c=true;  
            }
            else if(mcc.Action__c!= null && mcc.Action__c=='Delete')
            {
                childCase.MC_Delete__c=true;                                     
            }
            //PPN-16157 & PPN-15296 end
            //PPN-15292 Starts
            system.debug('MCC_Tax_ID__c'+mcc.MCC_Tax_ID__c);
            system.debug('MCC_Billing_NPI__c'+mcc.MCC_Billing_NPI__c);
            if(mcc.MCC_Tax_ID__c!= null)
                TaxIdSet.add(mcc.MCC_Tax_ID__c);
            if(mcc.MCC_Billing_NPI__c!= null)
                NPIIdSet.add(mcc.MCC_Billing_NPI__c);
            //PPN-15292 Ends
            
            if(insertedMasterCaseMap.containsKey(mcc.MCC_Project_Number__c))
            {
                childCase.parentId = insertedMasterCaseMap.get(mcc.MCC_Project_Number__c);
            }
            insertILRChildCases.add(childCase);
        }
        //PPN-22331 Starts
        for(CM_Provider_Tax_Id__c accWithTaxID :  [select id, CM_PTI_Prov_Name_From__c,  CM_PTI_Tax_Id__c from CM_Provider_Tax_Id__c where CM_PTI_Tax_Id__c In: TaxIdSet]){
            system.debug('accWithTaxID'+accWithTaxID);
            if(accwithTaxIdMap.containsKey(accWithTaxID.CM_PTI_Prov_Name_From__c)){
                accwithTaxIdMap.get(accWithTaxID.CM_PTI_Prov_Name_From__c).add(accWithTaxID);
            }
            else{
                accwithTaxIdMap.put(accWithTaxID.CM_PTI_Prov_Name_From__c, New list<CM_Provider_Tax_Id__c>{accWithTaxID});
            }
        }
        
        for(CM_Provider_Identification__c accWithNPI :  [select id, CM_PI_Prov__c, CM_Issu_Ident_Nmbr__c from CM_Provider_Identification__c where  CM_Issu_Ident_Nmbr__c In: NPIIdSet]){
            system.debug('accWithNPI'+accWithNPI);
            if(accwithNPIMap.containsKey(accWithNPI.CM_PI_Prov__c)){
                accwithNPIMap.get(accwithNPI.CM_PI_Prov__c).add(accwithNPI);
            }
            else{
                accwithNPIMap.put(accwithNPI.CM_PI_Prov__c, new list<CM_Provider_Identification__c >{accwithNPI});
            }
        }
        
        
        for(Id accId : accwithTaxIdMap.keySet()){
            List<CM_Provider_Tax_Id__c> taxIdList = accwithTaxIdMap.get(accId);
            for(CM_Provider_Tax_Id__c cmproviderIdentificationtax : taxIdList){
                if(accWithNPIMap !=NULL && accWithNPIMap.containsKey(accId))
                {
                    List<CM_Provider_Identification__c> cmProviderList = accwithNPIMap.get(accId);
                    for(CM_Provider_Identification__c cmproviderIdentification : cmProviderList){
                        string key = cmproviderIdentification.CM_Issu_Ident_Nmbr__c  +'-'+ cmproviderIdentificationtax.CM_PTI_Tax_Id__c  ;
                        if(!accwithNPITaxIdMap.containsKey(key)){
                            accwithNPITaxIdMap.put(key, accId);
                        }                   
                        else{
                            accwithNPITaxIdMap.remove(key);
                        }                       
                    }
                }
            }
        }
        
        Map<Id, Account> accTypeMap = new Map<Id, Account>();
        for(Account acc : [select Id, RecordType.Name from Account where Id IN :accwithNPITaxIdMap.Values()]){
            accTypeMap.put(acc.Id, acc);                    
        }
        
        
        for(Case childcase : insertILRChildCases){
            string key = (childcase.Billing_NPI_Number__c +'-'+ childcase.Tax_ID_Number__c);          
            if((accwithNPITaxIdMap.containskey(key)) && ((accTypeMap.get(accwithNPITaxIdMap.get(key)).RecordType.Name) ==('Entity Account'))) {
                childCase.Case_Entity__c = accwithNPITaxIdMap.get(key);                         
            }
            else if((accwithNPITaxIdMap.containskey(key)) && ((accTypeMap.get(accwithNPITaxIdMap.get(key)).RecordType.Name) ==('Physician'))){
                childCase.AccountId = accwithNPITaxIdMap.get(key);                         
            }
            
        }      
        //PPN - 22331 Ends
        system.debug('###### insertILRChildCases #####' + insertILRChildCases);
        if(!insertILRChildCases.isEmpty()){
            try{
                Database.insert(insertILRChildCases);
            }
            catch(Exception e){
                system.debug('#### An Exception occured while creating ILR Child Cases ###' +  e.getMessage());
            }
        }
        Database.executeBatch( new MCCLoadStatusUpdateBatch(insertILRChildCases));
    }
    
    
    /****
    * @input: List of MCC data objects records specific to group id
    * @output: Project number with , separarated values
    ****/
    public String projectNumbers( List<MCC_Data_Object__c> mccObjectList )
    {
        String projectNumberStr = '';
        Set<String> projectNumberSet    = new Set<String>();
        
        if( !mccObjectList.isEmpty() )
        {
            for( MCC_Data_Object__c mccDataRecord :  mccObjectList )
            {
                projectNumberSet.add( mccDataRecord.MCC_Project_Number__c );
            }
        }
        if(!projectNumberSet.isEmpty())
        {
            for( String tempProjectNumber : projectNumberSet )
            {
                projectNumberStr = projectNumberStr+','+tempProjectNumber;
            }
        }
        projectNumberStr = projectNumberStr.substring(1);
        return projectNumberStr;
    }
    
    
    public Map<String,Account> getProviderMap( Set<String> provIdSet )
    {
        System.debug('provIdSet===>>>'+provIdSet);
        List<Account> acctList                  =    [Select Id,Prov_ID__c,RecordTypeId From Account where Prov_ID__c IN:provIdSet ];
        Map<String,Account> provIdWithAcctMap   =   new Map<String,Account>();
        System.Debug('acctList=====>>>>'+acctList);
        if(!acctList.isEmpty() )
        {
            for( Account acct : acctList )
            {
                provIdWithAcctMap.put( acct.Prov_ID__c , acct );         
            }
        }
        System.debug('provIdWithAcctMap===>>>'+provIdWithAcctMap);
        return provIdWithAcctMap;
    }
    
    
    /*
    Author : Unknown
    * Date : Unknown
    * ver  : 1.0 
    ==================================================================================
    * Author : Saravana Bharathi <Saravana_Bharathi@bcbsil.com>
    * Business Purpose: Please refer the StoryBoardNumber :PPN-22986,PPN-25549,PPN-27401
    * Date : 12/24/2018
    * ver :2.0 
    * StoryBoardNumber :PPN-22986,PPN-25549,PPN-27401
    ==================================================================================
    * Author :Josh McGhee
    * date : 1/31/2019
    * Defect Number : PPN-31194
    * ver :3.0
    */
        
    public void massCasesClose(Map<string,MCC_Data_Object__c> recordsMap)
    {
        List<Case> CasesForUpdate =   new List<Case>();
        Set<String> caseIdSet=new Set<String>();
        Database.SaveResult[] sr  =   new List<Database.SaveResult>();
        Database.SaveResult[] Update_MCC_Data_Object  ;
        caseIdSet.addAll( recordsMap.keySet() ); 
        System.debug('caseIdSet===>>>>'+caseIdSet);
        Map<Id,String> mapOfIdAndItsPlan = new Map<Id,String>();
        if(caseIdSet.size()>0){
            for( Case csRecord : [Select CaseNumber,Id,Status,Plan_ID__c from Case Where Id IN: caseIdSet ] )
            {
                Case Case_MassCloseUpdate=   new Case( Id = csRecord.Id );
                if(recordsMap.get(csRecord.Id).MCC_Case_Status__c != null) {
                    Case_MassCloseUpdate.Status           =   recordsMap.get(csRecord.Id).MCC_Case_Status__c.trim();
                }
                Case_MassCloseUpdate.MCC_Record_Name__c     =   recordsMap.get(csRecord.Id).Name;
                /*
                *Author :Josh McGhee
                date : 1/31/2019
                Defect Number : PPN-31194
                */
                Case_MassCloseUpdate.OwnerId=userinfo.getuserId();// 
                
                // Update case comments based on file type
                if( recordsMap.get(csRecord.Id).MCC_File_Type__c == crmMassStatusType ) {
                    Case_MassCloseUpdate.CRM_Comments__c     =   recordsMap.get(csRecord.Id).MCC_Comments__c;
                } else {
                    Case_MassCloseUpdate.External_Comments__c  =   recordsMap.get(csRecord.Id).MCC_Comments__c;
                }
                mapOfIdAndItsPlan.put(csRecord.Id,csRecord.Plan_Id__c);
                CasesForUpdate.add(Case_MassCloseUpdate);
            }
        }
        System.debug('CasesForUpdate====>>>>'+CasesForUpdate);
        List<MCC_Data_Object__c> listOfDatas = new List<MCC_Data_Object__c>();
        if( !CasesForUpdate.isEmpty() )
        {
            Database.SaveResult[] srList;
            srList = Database.update( CasesForUpdate,false);  
            for(Database.SaveResult newResult:srList)
            {
                if(recordsMap.containsKey(newResult.getId()))
                {    
                    MCC_Data_Object__c MccRecord = new MCC_Data_Object__c(id=recordsMap.get(newResult.getId()).Id);          
                    if(newResult.isSuccess())
                    {
                        MccRecord.MCC_Load_Status__c=true;
                        
                    }
                    else
                    {
                        MccRecord.MCC_Load_Status__c=false;
                        for(Database.Error newError:newResult.getErrors())
                        {
                            MccRecord.Error_Message__c = MccRecord.Error_Message__c+newError.getMessage();
                        }
                    }
                    if(mapOfIdAndItsPlan.containsKey(newResult.getId()))
                    {
                        MccRecord.MCC_Plan_ID__c  = mapOfIdAndItsPlan.get(newResult.getId());
                    }else{
                        MccRecord.MCC_Plan_ID__c='ID';
                        MccRecord.Error_Message__c='CaseNumberNotFound';
                    }
                    listOfDatas.add(MccRecord);
                }
            }           
        }
        if(listOfDatas.size()>0)
        {
            try{
                Update_MCC_Data_Object=database.update(listOfDatas, false); 
            }catch(DmlException e)
            {
                system.debug('Excpetion==e'+e.getMessage()); 
            }
            
        }
        //update listOfDatas;
        //U393129
        //You need to update the MCC_Data_Object__c and you need to capture the error message and not all errors
        //Database.executeBatch( new MCCLoadStatusUpdateBatch(CasesForUpdate ) ); 
    }
    
    
    /*
    * Author :Gajjala Sujatha
    * Business Purpose: 
    * Date : 16/01/2019
    * StoryBoardNumber ://PPN-22389
    * Author :Ashok N
    * Business Purpose: 
    * Date : 16/01/2019
    * ver 1.0
    * StoryBoardNumber ://PPN-22389
    * Author :Ashok N
    * Business Purpose: created the new fields that are to capture the histrocal data.
    * Date : 2/28/2019
    * ver 2.0
    * StoryBoardNumber :PPN-34061
    */
    
    
    	public void onBoardingCredStatusUpdate( List<MCC_Data_Object__c> listMCCDataObject) {
			
		List<String> listMCCCaseNum = new List<String>();
		List<String> listMCCProvID = new List<String>();
		List<Id> listMCCObjId = new List<Id>();
		List<Account> listAccountObj= new List<Account>();
		List<Case> listCaseObj= new List<Case>();
		Map<String,Id> mapProvIdAcctId = new Map<String,Id>();
		Map<String, Id> mapCaseNumCaseId =  new Map<String, Id>();
		Map<Id,Case> mapCaseIdCaseObj= new Map<Id,Case>();
		Map<Id,Account> mapAcctIdAcctObj= new Map<Id,Account>();
		Map<String,Id> mapCaseIdMCCDataObjectId= new Map<String,Id>();
		Map<id,MCC_Data_Object__c> mapUpdateMCCIdMCCDataObject = new Map<id,MCC_Data_Object__c>();
		Map<String, List<MCC_Data_Object__c>> mapMCCProvIdDateTime = new Map<String, List<MCC_Data_Object__c>>();
		Map<String,Credentialing_Comments_History__c> mapCredComProvIdLatestDateTime = new Map<String,Credentialing_Comments_History__c>();
		Map<String,MCC_Data_Object__c> mapProvIdLatestDateTime = new Map<String,MCC_Data_Object__c>();
		List<Database.saveResult> listAcctUpdate;
		List<Database.saveResult>  listCaseUpdate;
		Savepoint SavePointTrigger;
		MassCreationDataObjectQuery MassCreationData= new MassCreationDataObjectQuery();
	    Map<String,String> mapCaseNotupdated=new Map<String,String>();
					 
		for(MCC_Data_Object__c objMCCData : listMCCDataObject) {
			
			if(objMCCData.Onboarding_Case_ID__c!=null){
				listMCCCaseNum.add(objMCCData.Onboarding_Case_ID__c);
                mapCaseNotupdated.put(objMCCData.Onboarding_Case_ID__c,objMCCData.Onboarding_Case_ID__c);
			}
			
			List<MCC_Data_Object__c> listMCCDataObj = mapMCCProvIdDateTime.get(objMCCData.MCC_Prov_ID__c);
			
			if(listMCCDataObj == null) {
				mapMCCProvIdDateTime.put(objMCCData.MCC_Prov_ID__c, new List<MCC_Data_Object__c>{objMCCData});
			} else {
				listMCCDataObj.add(objMCCData);
				listMCCDataObj.sort();
			}
			
			listMCCProvID.add(objMCCData.MCC_Prov_ID__c);  
			listMCCObjId.add(objMCCData.Id);         
		}
		
		Map<String,MCC_Data_Object__c> mapLatestMCCRec = new Map<String,MCC_Data_Object__c>();
		
		for(string strMCCProvId:mapMCCProvIdDateTime.keySet()){
			for(MCC_Data_Object__c mccRec:mapMCCProvIdDateTime.get(strMCCProvId)){
			   mapLatestMCCRec.put(strMCCProvId,mccRec);   
			}            
		}
		system.debug('*************************'+mapLatestMCCRec);
		system.debug('*************************'+mapMCCProvIdDateTime);
		
		try{
			listAccountObj = MassCreationData.getCredAccount(listMCCProvID); 
			if(listMCCCaseNum!=null && listMCCCaseNum.size()>0){
				listCaseObj = MassCreationData.getlistOfCaseQueryRecord(listMCCCaseNum);   
			}  
		}catch(QueryException e) {
			system.debug('Exception====>>>'+e.getMessage());
		}
		
		for(Account objAcct : listAccountObj){
			mapProvIdAcctId.put(objAcct.Prov_ID__c,objAcct.Id); 
		}
		
		for(Case objCase : listCaseObj) {
			mapCaseNumCaseId.put(objCase.CaseNumber,objCase.Id);
		}
		
		if(listMCCProvID!=null && listMCCProvID.size()>0){
		   
			List<Credentialing_Comments_History__c> listCredComHist =[SELECT Id,Account__c,Account__r.Prov_ID__c,Cred_Status_Time_Stamp__c FROM Credentialing_Comments_History__c 
																	  where Account__r.Prov_ID__c=:listMCCProvID ORDER by Cred_Status_Time_Stamp__c ASC];
			system.debug('*************************'+listCredComHist);
			if(listCredComHist!=null && listCredComHist.size()>0){
				for(Credentialing_Comments_History__c objCred:listCredComHist){
					mapCredComProvIdLatestDateTime.put(objCred.Account__r.Prov_ID__c,objCred); 
				}
			}
				
			system.debug('*************************'+mapCredComProvIdLatestDateTime);
			
			for(string strProvId: mapLatestMCCRec.keySet()){
				if(mapCredComProvIdLatestDateTime.containsKey(strProvId)){
					string strCredTime = mapCredComProvIdLatestDateTime.get(strProvId).Cred_Status_Time_Stamp__c;
					string strMCCCredTime = mapLatestMCCRec.get(strProvId).Cred_Status_Time_Stamp__c;
					system.debug('*************************'+strCredTime);
					system.debug('*************************'+strMCCCredTime);
					if(strMCCCredTime > strCredTime){
						system.debug('*************entered if************');
						mapProvIdLatestDateTime.put(strProvId,mapLatestMCCRec.get(strProvId));
					}
					
				} else {
					system.debug('**********entere else***************');
					if(mapLatestMCCRec.get(strProvId).Onboarding_Case_ID__c!=null) {
						Case objCaseUpdate  = new Case();
						objCaseUpdate.Status = mapLatestMCCRec.get(strProvId).Cred_Status__c;
						objCaseUpdate.External_Comments__c = mapLatestMCCRec.get(strProvId).MCC_Comments__c;
						objCaseUpdate.Cred_Cycle__c=mapLatestMCCRec.get(strProvId).Cred_Cycle__c;
						objCaseUpdate.Cred_Status_Date__c=mapLatestMCCRec.get(strProvId).Cred_Status_Date__c;
						objCaseUpdate.Re_Cred_Date__c=mapLatestMCCRec.get(strProvId).Re_Cred_Date__c;
						objCaseUpdate.CAQH_Number__c= mapLatestMCCRec.get(strProvId).CAQH_Number__c;
						objCaseUpdate.Cred_Status_Time_Stamp__c = mapLatestMCCRec.get(strProvId).Cred_Status_Time_Stamp__c;
						objCaseUpdate.id=mapCaseNumCaseId.get(mapLatestMCCRec.get(strProvId).Onboarding_Case_ID__c);
						
						mapCaseIdCaseObj.put(objCaseUpdate.Id,objCaseUpdate);
						mapCaseIdMCCDataObjectId.put(mapLatestMCCRec.get(strProvId).Onboarding_Case_ID__c,mapLatestMCCRec.get(strProvId).Id);
					}
					Account objAccountUpdate = new Account();
					objAccountUpdate.Cred_Status__c = mapLatestMCCRec.get(strProvId).Cred_Status__c;
					objAccountUpdate.Cred_Status_Date__c = mapLatestMCCRec.get(strProvId).Cred_Status_Date__c;
					objAccountUpdate.Re_Credentialing_date__c = mapLatestMCCRec.get(strProvId).Re_Cred_Date__c;
					objAccountUpdate.Comments__c = mapLatestMCCRec.get(strProvId).MCC_Comments__c;
					objAccountUpdate.Cred_Cycle__c = mapLatestMCCRec.get(strProvId).Cred_Cycle__c;
					objAccountUpdate.Cred_Status_Time_Stamp__c = mapLatestMCCRec.get(strProvId).Cred_Status_Time_Stamp__c;
					objAccountUpdate.Id =mapProvIdAcctId.get(mapLatestMCCRec.get(strProvId).MCC_Prov_ID__c);
					
					mapAcctIdAcctObj.put(objAccountUpdate.id,objAccountUpdate);
					
				}
			}  
		}
		
		system.debug('*************************'+mapCaseIdCaseObj);
		system.debug('*************************'+mapAcctIdAcctObj);
		system.debug('*************************'+mapCaseIdMCCDataObjectId);
		
		system.debug('*************************'+mapProvIdLatestDateTime);
		system.debug('*************************'+mapCredComProvIdLatestDateTime);
		 
		for(MCC_Data_Object__c objMCCData : listMCCDataObject) {
			system.debug('*************************'+objMCCData);
			if(mapProvIdLatestDateTime.containsKey(objMCCData.MCC_Prov_ID__c) && mapProvIdLatestDateTime!=null){
				if(objMCCData.Onboarding_Case_ID__c!=null) {
					Case objCaseUpdate  = new Case();
					objCaseUpdate.Status = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Status__c;
					objCaseUpdate.External_Comments__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).MCC_Comments__c;
					objCaseUpdate.Cred_Cycle__c=mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Cycle__c;
					objCaseUpdate.Cred_Status_Date__c=mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Status_Date__c;
					objCaseUpdate.Re_Cred_Date__c=mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Re_Cred_Date__c;
					objCaseUpdate.CAQH_Number__c= mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).CAQH_Number__c;
					objCaseUpdate.Cred_Status_Time_Stamp__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Status_Time_Stamp__c;
					objCaseUpdate.id=mapCaseNumCaseId.get(objMCCData.Onboarding_Case_ID__c);
					
					mapCaseIdCaseObj.put(objCaseUpdate.Id,objCaseUpdate);
					mapCaseIdMCCDataObjectId.put(objMCCData.Onboarding_Case_ID__c,objMCCData.Id);
			   }
					Account objAccountUpdate = new Account();
					objAccountUpdate.Cred_Status__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Status__c;
					objAccountUpdate.Cred_Status_Date__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Status_Date__c;
					objAccountUpdate.Re_Credentialing_date__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Re_Cred_Date__c;
					objAccountUpdate.Comments__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).MCC_Comments__c;
					objAccountUpdate.Cred_Cycle__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Cycle__c;
					objAccountUpdate.Cred_Status_Time_Stamp__c = mapProvIdLatestDateTime.get(objMCCData.MCC_Prov_ID__c).Cred_Status_Time_Stamp__c;
					objAccountUpdate.Id =mapProvIdAcctId.get(objMCCData.MCC_Prov_ID__c);
					
					mapAcctIdAcctObj.put(objAccountUpdate.id,objAccountUpdate);
			}
		}
		
		system.debug('*************************'+mapCaseIdCaseObj);
		system.debug('*************************'+mapAcctIdAcctObj);
		system.debug('*************************'+mapCaseIdMCCDataObjectId);
		
		try{
			if(mapCaseIdCaseObj!=null && mapCaseIdCaseObj.size()>0) {
				listCaseUpdate = Database.update(mapCaseIdCaseObj.values(),false);
			}
			
			if(mapAcctIdAcctObj!=null && mapAcctIdAcctObj.size()>0) {
			  listAcctUpdate = Database.update(mapAcctIdAcctObj.values(),false);
			}
			SavePointTrigger = Database.setSavepoint();
		}catch(DmlException e) {
			Database.rollback(SavePointTrigger);
			system.debug('Excpetion==e '+e.getMessage());   
		}
		
		system.debug('*************************'+listCaseUpdate);
		system.debug('*************************'+listAcctUpdate);
		
		//Fetching the case IDS that are updated sucesffully.
		List<id> listCaseId= new list<Id>();
		List<String> listCaseErrors= new List<String>();
		List<String> listAccountErrors= new List<String>();
		List<Id> listAcctIds = new List<Id>();
		
		if(listCaseUpdate!=null && listCaseUpdate.size()>0){
			for(database.SaveResult CaseValues :listCaseUpdate){
				if (CaseValues.isSuccess()) {
					listCaseId.add(CaseValues.getId());
				} else {
					for(Database.Error err : CaseValues.getErrors()) {
						listCaseErrors.add(err.getMessage());
					} 
				}
			}
		}
		
		if(listAcctUpdate!=null && listAcctUpdate.size()>0){
			for(database.SaveResult acctValues :listAcctUpdate){
				if (acctValues.isSuccess()) {
					listAcctIds.add(acctValues.getId());
				} else {
					for(Database.Error err : acctValues.getErrors()) {
						listAccountErrors.add(err.getMessage());
					} 
				}
			}
		}
		
		system.debug('*************************'+listCaseId);
		system.debug('*************************'+listAcctIds);
		
		if(listCaseId!=null && listCaseId.size()>0){
			listCaseObj=MassCreationData.getlistOfCaseQueryRecords(listCaseId);    
		}
		
		if(listAcctIds!=null && listAcctIds.size()>0){
		  listAccountObj = MassCreationData.getCredAccounts(listAcctIds);
		}
		
		List<String> listCaseNum= new List<String>();
		List<MCC_Data_Object__c> listOfMCCDataObjectRec = new List<MCC_Data_Object__c>();
		List<Credentialing_Comments_History__c> listCredCommHistInsert = new List<Credentialing_Comments_History__c>();
		List<database.SaveResult> listUpdateMCCDataObject;
		Map<String,String> mapCasNumCasPlanId= new Map<String,String>();
		Map<String,Id> mapCasNumCasId= new Map<String,Id>();
		Map<String,Id> mapProvIdAcctIds = new Map<String,Id>();
		Map<String,String> mapProvIdAcctPlanId = new Map<String,String>();
		
		system.debug('*************************'+listCaseObj);
		system.debug('*************************'+listAccountObj);
		
		if(listCaseObj!=null && listCaseObj.size()>0){
			for(Case objCase : listCaseObj) {
				mapCasNumCasPlanId.put(objCase.CaseNumber,objCase.Plan_ID__c);
				mapCasNumCasId.put(objCase.CaseNumber,objCase.Id);
				listCaseNum.add(objCase.CaseNumber);
			}
		}
		
		if(listAccountObj!=null && listAccountObj.size()>0){
			for(Account objAccount : listAccountObj) {
				mapProvIdAcctIds.put(objAccount.Prov_ID__c,objAccount.Id);
				mapProvIdAcctPlanId.put(objAccount.Prov_ID__c,objAccount.CM_Corporate_Entity_Code__c);
			}
		}
		
		system.debug('*************************'+mapCasNumCasPlanId);
		system.debug('*************************'+mapCasNumCasId);
		system.debug('*************************'+listCaseNum);
		
		system.debug('*************************'+mapProvIdAcctIds);
		system.debug('*************************'+mapProvIdAcctPlanId);
		
		 listOfMCCDataObjectRec = [Select Id, Cred_Status__c,MCC_Comments__c,Cred_Cycle__c,Cred_Status_Date__c,Re_Cred_Date__c,
								   Cred_Status_Time_Stamp__c,Onboarding_Case_ID__c,MCC_Prov_ID__c,Account__c,Admin_Error_Message__c,
								   MCC_Plan_ID__c,MCC_Load_Status__c,Error_Message__c From MCC_Data_Object__c Where Id=:listMCCObjId];
		
		for(MCC_Data_Object__c  objMCCData: listOfMCCDataObjectRec){

			 Credentialing_Comments_History__c objCredCommHistInsert = new Credentialing_Comments_History__c(); 
			 objCredCommHistInsert.Cred_Status__c =  objMCCData.Cred_Status__c;
			 objCredCommHistInsert.Comments_History__c =  objMCCData.MCC_Comments__c;
			 objCredCommHistInsert.Cred_Cycle__c =  objMCCData.Cred_Cycle__c;
			 objCredCommHistInsert.Cred_Status_Date__c =  objMCCData.Cred_Status_Date__c;
			 objCredCommHistInsert.Re_Cred_Date__c =  objMCCData.Re_Cred_Date__c;
			 objCredCommHistInsert.Cred_Status_Time_Stamp__c =  objMCCData.Cred_Status_Time_Stamp__c;
			 
			 system.debug('*************************'+listCaseNum.contains( objMCCData.Onboarding_Case_ID__c));
			 system.debug('*************************'+mapCasNumCasPlanId);
			if(listCaseNum.contains( objMCCData.Onboarding_Case_ID__c)) {
				objMCCData.MCC_Plan_ID__c = mapCasNumCasPlanId.get( objMCCData.Onboarding_Case_ID__c);
				objMCCData.MCC_Load_Status__c = true;
				objMCCData.MCC_Case_Id__c = mapCasNumCasId.get( objMCCData.Onboarding_Case_ID__c);
				objCredCommHistInsert.Account__c = mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c);
				objCredCommHistInsert.Case__c=mapCasNumCasId.get( objMCCData.Onboarding_Case_ID__c);                  
				listCredCommHistInsert.add(objCredCommHistInsert);
			}else {
				 objMCCData.MCC_Plan_ID__c = mapProvIdAcctPlanId.get( objMCCData.MCC_Prov_ID__c);
				 objMCCData.MCC_Load_Status__c = true;
				 objMCCData.Account__c = mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c);  
				 objCredCommHistInsert.Account__c = mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c);
				 listCredCommHistInsert.add(objCredCommHistInsert);
			}
			 
			if(!listCaseNum.contains( objMCCData.Onboarding_Case_ID__c)) {
				
				 for(String strCaseError : listCaseErrors) {
					 objMCCData.Admin_Error_Message__c=strCaseError +''+ mapCaseNotupdated.get( objMCCData.Onboarding_Case_ID__c);
					 objMCCData.MCC_Load_Status__c=false; 
					 objMCCData.MCC_Plan_ID__c= 'ID';
					 //objMCCData.MCC_Case_Id__c = mapCasNumCasId.get( objMCCData.Onboarding_Case_ID__c);
					 objMCCData.Error_Message__c= 'CaseNumber was not updated  ' + mapCaseNotupdated.get( objMCCData.Onboarding_Case_ID__c);
				}
				system.debug('Not a CredCase==== >>> '+mapCasNumCasId.get( objMCCData.Onboarding_Case_ID__c));
			}else {
				for(String strAcctError : listAccountErrors) {
					 objMCCData.Admin_Error_Message__c=strAcctError  + mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c);
					 objMCCData.MCC_Load_Status__c=false; 
					 objMCCData.MCC_Plan_ID__c= 'ID';
					 objMCCData.Account__c = mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c);
					 objMCCData.Error_Message__c= 'AccountId not found  ' + mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c);
				}
				system.debug('Not a CredCase==== >>> '+mapProvIdAcctIds.get( objMCCData.MCC_Prov_ID__c));
			}

			 
			mapUpdateMCCIdMCCDataObject.put( objMCCData.Id, objMCCData);
		}
		
		
		system.debug('*************************'+mapUpdateMCCIdMCCDataObject);
		if(mapUpdateMCCIdMCCDataObject!=null && mapUpdateMCCIdMCCDataObject.size()>0) {
			try{
				listUpdateMCCDataObject=database.update(mapUpdateMCCIdMCCDataObject.values(),false);
			}catch(DmlException e) {
				system.debug('Exception==e'+e.getMessage());
			}
		}
		
		system.debug('*************************'+listCredCommHistInsert);
		if(listCredCommHistInsert!=null && listCredCommHistInsert.size()>0){
			try{
				insert listCredCommHistInsert;
			}catch(DmlException e){
				system.debug('Excpetion===e'+e.getMessage());
			}
		}
			 
			
			
	}
			 
         
    
    /*
    * Author : Ashok N
    * Business Purpose: 
    * Date : 11/09/2018
    * StoryBoardNumber :PPN-27739
    */
    
    public  static void networkLoadMassStatus(Map<String,MCC_Data_Object__c> networkLoadMassData , List<MCC_Data_Object__c> ListMCCDataObject)
    {
        system.debug('NetworkLoadMassUpdate==='+networkLoadMassData);
        Set<String> Set_MCC_Case_Id= new Set<String>();
        Set_MCC_Case_Id=networkLoadMassData.keyset();
        system.debug('Set_MCC_Case_Id==='+Set_MCC_Case_Id);
        Database.SaveResult[] srList;
        Database.SaveResult[] srListMCCDataObject;
        List<Case> Lst_CaseQueryRecord= new List<Case>();
        List<Case> Lst_CaseNumberQuery= new List<Case>();
        Map<String,Id> NewtworkLoad_CaseId =   new Map<String,Id>();
        Map<String,String> NewtworkLoad_MCC_Plan_ID =   new Map<String,String>();
        Map<String,String> Map_CaseNumber =   new Map<String,String>();
        Map<Id,Case> MapNetwork_Load_Mass_Status = new Map<Id,Case>();
        //To Query the CaseID when the ETL load the data into the MCC_Data_Object__c object.
        Lst_CaseQueryRecord=[Select Id,CaseNumber,status,Plan_ID__c ,Comments from case where ID IN :Set_MCC_Case_Id];
        Map<String,String> MCC_Data_CaseStatus= new Map<String,String>();
        set<Id> NetworkLoadUpdated_CaseId = new Set<Id>();
        set<String> CaseNumberSucess = new Set<String>();
        Map<String,Id> ID_MCC_Data_Object = new Map<String,Id>();
        List<MCC_Data_Object__c> Query_MCCDataObject= new List<MCC_Data_Object__c>();
        Map<Id,MCC_Data_Object__c> MapUpdate_MCC_Data_Object= new Map<Id,MCC_Data_Object__c>();
        system.debug('Lst_CaseQueryRecord=== '+Lst_CaseQueryRecord);
        //Keeping the Case id for the future use.
        for(Case NetworkLoad_Case: Lst_CaseQueryRecord)
        {
            NewtworkLoad_CaseId.put(NetworkLoad_Case.Id,NetworkLoad_Case.Id);
            
        }
        //Updates the case value with the MCC_Data_Object__c values 
        for(MCC_Data_Object__c MCC_Data_Object : ListMCCDataObject)
        {
            Case NetworkLoad_CaseUpdate= new Case();
            NetworkLoad_CaseUpdate.status=MCC_Data_Object.MCC_Case_Status__c;
            NetworkLoad_CaseUpdate.Id=NewtworkLoad_CaseId.get(MCC_Data_Object.MCC_Case_Id__c);
            MapNetwork_Load_Mass_Status.put(NetworkLoad_CaseUpdate.Id,NetworkLoad_CaseUpdate);
        }
        system.debug('MapNetwork_Load_Mass_Status=== '+MapNetwork_Load_Mass_Status.size());
        
        if(MapNetwork_Load_Mass_Status.size()>0)
        {
            try{
                srList=Database.Update(MapNetwork_Load_Mass_Status.values(), false);
            }
            catch(DmlException e)
            {
                system.debug('Execption===>>'+e.getMessage());
            }
        }
        for (Database.SaveResult sr : srList)
        {
            if (sr.isSuccess()) 
            {
                NetworkLoadUpdated_CaseId.add(sr.getId());
            }
            else 
            {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) 
                {
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
            
        }
        // To Query the CaseNumber which ever processed  updated successfully and to update the partiuclar MCC_Load_Status__c to true else it will false
        Lst_CaseNumberQuery=[Select Id, Plan_ID__c ,CaseNumber from Case Where Id IN : NetworkLoadUpdated_CaseId];
        system.debug('Lst_CaseNumberQuery=== '+Lst_CaseNumberQuery+'==== '+NetworkLoadUpdated_CaseId);
        for(Case Case_UpdatedSuccessfully : Lst_CaseNumberQuery)
        {
            CaseNumberSucess.add(Case_UpdatedSuccessfully.ID);
            Map_CaseNumber.put(Case_UpdatedSuccessfully.Id,Case_UpdatedSuccessfully.Id);
            NewtworkLoad_MCC_Plan_ID.put(Case_UpdatedSuccessfully.Id,Case_UpdatedSuccessfully.Plan_ID__c);
        }
        
        
        for(MCC_Data_Object__c MCC_Data_Object : ListMCCDataObject)
        {
            MCC_Data_Object__c Update_MCC_Data_Object = new MCC_Data_Object__c();
            Update_MCC_Data_Object.id=MCC_Data_Object.Id;
            if( (MCC_Data_Object.MCC_Case_Id__c!=null) || (Map_CaseNumber.containskey(MCC_Data_Object.MCC_Case_Id__c)) )
            {
                Update_MCC_Data_Object.MCC_Load_Status__c=true;
            }
            else
            {
                
                Update_MCC_Data_Object.MCC_Load_Status__c=false; 
            }
            Update_MCC_Data_Object.MCC_Plan_ID__c=NewtworkLoad_MCC_Plan_ID.get(MCC_Data_Object.MCC_Case_Id__c);
            MapUpdate_MCC_Data_Object.put(Update_MCC_Data_Object.id,Update_MCC_Data_Object);
        }
        if(MapUpdate_MCC_Data_Object.size()>0)
        {
            try{
                srListMCCDataObject=Database.Update(MapUpdate_MCC_Data_Object.values(), false);
            }catch(DmlException e)
            {
                system.debug('Exception=='+e.getMessage());
            }
        }
        
    }   
}