/*
Apex Class Name  : TestDataFactory
Version          : 1.0  
Functionality    : All the test Data is created in the stroy  
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ashok N                    11/15/2018             Global TestData Creation      
******************************************************************************
*/



@isTest


public class TestDataFactory
{

/*
 * 
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Laxman Vattam             11/29/2018             to create the Credentialing Case  
*/    
    public static account  CreateAccount(String planID)
    {    
        account acc = new account();
        acc.name = 'test Account';
        acc.prov_id__c=String.Valueof ( Math.round(Math.random()*1000));
        acc.CM_Corporate_Entity_Code__c = planId;
        insert acc;
        return acc;
        
    }

 /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Laxman Vattam             11/29/2018             to create the Network Case
*/    
    public static List<Case>  NetworkCaseCreation(List<Provider_Networks__c> pnList,String planID,String IndorGrp)
    {
        account acc = new account();
        acc = createaccount('IL1');
        
        Id Master_Provider_Case_data=Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Master_Provider_Case_data').getRecordTypeId();
        List<Case> netCase = new List<Case>();
        //Create a parent case.
        Case p = new Case();
        p.Status='New';
        p.accountId = acc.Id;
        p.subject='Parent'; 
        p.Billing_NPI_Number__c = '1234567890';        
        p.Tax_ID_Number__c = '123456789';
        p.Plan_Id__c = planID;
        p.RecordTypeId = Master_Provider_Case_data;
        insert p;           
                
        //Create a child case
        Case c = new Case();
        c.accountId = acc.Id;
        c.Status='New';
        c.subject='Child'; 
        c.Billing_NPI_Number__c = '1234567890';
        c.Rendering_NPI__c = '1234567895';
        c.Provider_Finder_Close_Date__c = null;
        c.ParentId = p.Id;
        c.Plan_Id__c = planID;
        c.Prov_ID__c = '1234567890';
        c.Status='New'; 
        c.Email_Address_Submitter__c = 'test@test.com';
        
        /*
         * Author : U393129
         * Purpouse : Changed to get the recordtypname using the Network_Load and Provider_Group_On_boarding_Network_Load
*/
         Id Network_LoadRecordTypeId=Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Network_Load').getRecordTypeId();
        Id Provider_Group_On_boarding_Network_LoadId=Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
        
        
        if(IndorGrp == 'Ind')
            c.recordtypeId=Network_LoadRecordTypeId;
        else{
            c.recordtypeId=Provider_Group_On_boarding_Network_LoadId;
            c.Network_Name_Detail__c = 'PTW - Triwest';
        }
        insert c;   
        netCase.add(c);
        
        list<Provider_Networks__c> pn = new list<Provider_Networks__c>();        
        pn = TestDataFactory.ProviderNetworkCreation(1,planId,'01241000001h1Bu');
        for(Provider_Networks__c pt:pn){
            pt.Credentialing_Case__c = c.id;
        }    
        update pn;
        return netCase;
    }   
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description                      Ver
-----------------------------------------------------------------------------                 
* Laxman Vattam             11/29/2018             to create the Credentialing Case   1.0
  U393129                   12/12/22018            Passing the record ID Master Provider Case data of case   2.0
*/    
    public static List<Case>  CredCaseCreation(List<Provider_Networks__c> pnList,String planID,String IndorGrp, Id RecordId)
    {
        account acc = new account();
        acc = createaccount('IL1');
        List<Case> cred = new List<Case>();
        //Create a parent case.
        Case p = new Case();
        p.Status='New';
        p.accountId = acc.Id;
        p.subject='Parent'; 
        p.Billing_NPI_Number__c = '1234567890';        
        p.Tax_ID_Number__c = '123456789';
        p.Plan_Id__c = 'IL1';
        p.RecordTypeId = RecordId;
        insert p;   
        
        //Create a child case
        Case c = new Case();
        c.accountId = acc.Id;
        c.Status='New';
        c.subject='Child'; 
        c.Billing_NPI_Number__c = '1234567890';
        c.Rendering_NPI__c = '1234567895';
        c.Provider_Finder_Close_Date__c = null;
        c.ParentId = p.Id;
        c.Plan_Id__c = 'IL1';
        c.Contract_ProvID__c = '123456789';
        c.Email_Address_Submitter__c = 'test@test.com';
        c.Network_Name__c = 'BAV - Blue Precision HMO';       
        if(IndorGrp == 'Ind'){
            c.recordtypeId = RecordId;
        }
        /*
         * Author : U393129
         * Purpouse : We have not constructed the test data fot the group

        else{
            c.recordtypeId = '01241000001h1Bh';
        }
*/
        
        insert c;   
        cred.add(c);
        
        list<Provider_Networks__c> pn = new list<Provider_Networks__c>();
        pn = pnlist;
        for(Provider_Networks__c pt:pn){
            pt.Credentialing_Case__c = c.id;
        }    
        update pn;
        pn = [select id,Credentialing_Case__c,Credentialing_Case__r.parentid,Credentialing_Case__r.recordtype.developername,Credentialing_Case__r.status,prov_id__c,Credentialing_Case__r.Cred_Case_Reported__c  from Provider_Networks__c];
        system.debug('pn:finaltest:' + pn[0].Credentialing_Case__r.parentid + ':' + pn[0].Credentialing_Case__r.recordtype.developername + ':' + pn[0].Credentialing_Case__r.status + ':' + pn[0].Credentialing_Case__r.Cred_Case_Reported__c);
        return cred;
    }
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Laxman Vattam             11/29/2018             to create the Provider Details  
*/    
    public static List<Provider_Networks__c>  ProviderNetworkCreation(Integer NumberOfrecords,String planID,Id recTypeId)
    {
        List<Provider_Networks__c> pn = new List<Provider_Networks__c>();
        for(integer i=0;i<NumberOfRecords;i++){
            Provider_Networks__c p = new Provider_Networks__c();
            p.ProviderName__c      = 'MAYUMI NEHA AABERG';
            p.Network_Code_Name__c = 'BAV - Blue Precision HMO';
            p.Network_Code_Name_Detail__c = 'BAV - Blue Precision HMO';
            p.prov_id__c           = '123456789';
            p.recordtypeid         = recTypeId;
            p.Networks_Effective_Date__c = date.valueof('2018-10-10');
            pn.add(p);
        }
        insert pn;
        return pn;
    }    
    
    
    Map<Integer,String> MCC_Record_Name= new Map<Integer,String>();
    Map<Integer,String> mccNameWithCaseMap = new Map<Integer,String>();
    List<MCC_Data_Object__c> List_MCC_Data_ObjectQuery= new List<MCC_Data_Object__c>();
    
    public void networkLoadMassStatus(Integer NumberOfrecords)
    {
        InsertGlobalsetting();
        LstCreateAccount(NumberOfrecords,'TX1');
      // DataCaseCommentsTriggerHandler ('TX1');
        
        //Create Case Records
        List<case> CreateCaseRecords=OnCreateCaseData(NumberOfrecords,'TX1');
        if(CreateCaseRecords.size()>0)
        {
            try{
                insert CreateCaseRecords;
            }catch(DmlException e)
            {
                system.debug('DmlException=='+e.getCause());
            }
        }
        //Create MMC Object Records
        List<Case> List_CaseValues=getCaseRecords(CreateCaseRecords);
        List<MCC_Data_Object__c> CreateMCCDataRecords= OnCreateMCCDataObject(NumberOfrecords);
        if(CreateMCCDataRecords.size()>0)
        {
            try{
                Insert CreateMCCDataRecords;
            }
            catch(DmlException e)
            {
                system.debug('CreateException==' +e.getMessage());
            }
        }
        
        List<MCC_Data_Object__c> getMCCDataRecords=  QueryMCCDataObject(CreateMCCDataRecords);
        List<MCC_Data_Object__c> List_MCC_Data_Object=  QueryMCCDataObject(getMCCDataRecords);
        Map<Id,Case> Map_UpdateCaseValues= UpdateCaseRecords(List_CaseValues);
        if(Map_UpdateCaseValues.size()>0)
        {
            try{
                update Map_UpdateCaseValues.values();
            }catch(DmlException e)
            {
                system.debug('Exception==e'+e.getCause());
                
            }
        }
        MCCLoadStatusUpdateBatch_Test(Map_UpdateCaseValues,getMCCDataRecords);
        InsertCaseComments(Map_UpdateCaseValues);
        SharedEmailInBoxes_Test();
        
       
    }
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/15/2018             to create the Case records   
*/
    
    public List<Case>  OnCreateCaseData(Integer NumberOfrecords,String planID)
    {
       
        List<Case> List_CaseInsert= new List<Case>();
        for(integer i=0;i<NumberOfrecords;i++)
        {
            Case InsertCase=new Case();
            InsertCase.status='Opened';
            InsertCase.Plan_ID__c=planID;
            InsertCase.Grouping_ID__c='123456';
            InsertCase.prov_id__c='123456789';
            InsertCase.Cred_Cycle__c='I';
           // InsertCase.MCC_Record_Name__c=mccNameWithCaseMap.get(i);
            List_CaseInsert.add(InsertCase);
        }
       
        return List_CaseInsert;
        
    }
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/15/2018             to Query Case records   
*/ 
    Map<integer,Id> MCC_Case_Id= new Map<integer,Id>();
    
    public List<Case> getCaseRecords(List<Case> ListCaseValues)
    {
        set<Id> CaseId= new set<Id>();
        List<Case> ListCaseRecord= new List<Case>();
        Integer TempCaseValue=0;
        
        for(Case Casevalues : ListCaseValues)
        {
            CaseId.add(Casevalues.Id); 
        }
        system.debug('CaseId=== '+CaseId);
        List<Case> List_CaseQuery=[select Id,MCC_Record_Name__c,plan_id__C from case where ID IN : CaseId];
        do{
            
            for(Case CaseValues : List_CaseQuery)
            {
                MCC_Case_Id.put(TempCaseValue,CaseValues.Id); 
                ListCaseRecord.add(CaseValues);
            }
            TempCaseValue=TempCaseValue+1;
        }while(TempCaseValue<List_CaseQuery.size());
       system.debug('List_CaseQuery=== '+List_CaseQuery);
       system.debug('MCC_Case_Id==='+MCC_Case_Id);
       
        return ListCaseRecord;
    }

 /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/24/2018             to Update Case records   
*/ 
    
public Map<Id,Case> UpdateCaseRecords(List<Case> ListCaseValues)
{
    system.debug('ListCaseValues=== '+ListCaseValues.size() +'===MCCDataObjectRecordName'+MCCDataObjectRecordName);
    system.debug('===MCCDataObjectRecordNamesize'+MCCDataObjectRecordName.size());
    Map<Id,Case> Map_UpdateCase= new Map<Id,case>();
    Integer TempCaseUpdate=0;
    do{
        for(case CaseValues1 :ListCaseValues)
        {
            if(MCCDataObjectRecordName.get(TempCaseUpdate)!=null)
            {
                Case Caseupdate= new Case(); 
                Caseupdate.Id=CaseValues1.Id; 
                system.debug('MCCDataObjectRecordName ==' +MCCDataObjectRecordName.get(TempCaseUpdate));
                caseupdate.MCC_Record_Name__c=MCCDataObjectRecordName.get(TempCaseUpdate);
                Map_UpdateCase.put(caseupdate.Id,Caseupdate);
            }
            TempCaseUpdate=TempCaseUpdate+1;
        }
        
    }while(TempCaseUpdate<ListCaseValues.size());
    system.debug('List_UpdateCase=== '+Map_UpdateCase);
    return Map_UpdateCase;
}
    

   
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/26/2018             to Query the MCC Records  
*/
    Map<String,Id> MCCDataObjectId= new Map<String,Id>();
    Map<Integer,String> MCCDataObjectRecordName= new Map<Integer,String>();
    
    public List<MCC_Data_Object__c> QueryMCCDataObject(List<MCC_Data_Object__c> MCCDataObject)
    {
        set<Id> MCC_DataObjectId= new Set<Id>();
        ETLReportingNotification ReportingNotification = new ETLReportingNotification();
        MassCreationDataObjectQuery MassCreationQuery= new MassCreationDataObjectQuery();
        Set<String> Set_MMCName= new Set<String>();
        Integer TempMMCObject=0;
        MCCTriggerHandler HandlerClass = new MCCTriggerHandler();
        Map<Id,MCC_Data_Object__c>  networkLoadMassData= new Map<Id,MCC_Data_Object__c>();
        Map<String,MCC_Data_Object__c> insertNetworkFileRecords = new Map<String,MCC_Data_Object__c>();
        Map<Id,MCC_Data_Object__c> Map_MCC_Data_Object= new Map<Id,MCC_Data_Object__c>();
        List<MCC_Data_Object__c> List_MCC_Data_object= new List<MCC_Data_Object__c>();
        Set<String> Set_MCC_Prov_ID = new Set<String>();
        set<Id> Set_MCC_RecordId= new Set<Id>();
        for(MCC_Data_Object__c MCCDataObjectValues : MCCDataObject)
        {
            MCC_DataObjectId.add(MCCDataObjectValues.Id);
        }
        List_MCC_Data_ObjectQuery=[select Id,Name,MCC_Case_Status__c,MCC_Case_Id__c, Processed_for_reporting__c,MCC_File_Type__c,MCC_Comments__c,Cred_Status_Date__c,Re_Cred_Date__c,
                                   MCC_Override_Queue__c,MCC_File_Id__c,MCC_Grouping_ID__c,File_Count__c,MCC_Load_Status__c,Onboarding_Case_ID__c,Cred_Cycle__c,Cred_Status__c, MCC_Prov_ID__c,MCC_Assignee_ID__c,MCC_Project_Number__c,
                                   MCC_Plan_ID__c,MCC_Request_Type__c,MCC_Priority__c
                                   from MCC_Data_Object__c where ID IN :MCC_DataObjectId];
        system.debug('List_MCC_Data_ObjectQuery== '+List_MCC_Data_ObjectQuery.size());
        do{
            for(MCC_Data_Object__c MCCDataObjectValues : List_MCC_Data_ObjectQuery)
            {
                    networkLoadMassData.put(MCCDataObjectValues.MCC_Case_Id__c,MCCDataObjectValues);
                    MCCDataObjectId.put(MCCDataObjectValues.Name,MCCDataObjectValues.Id);
                    MCCDataObjectRecordName.put(TempMMCObject,MCCDataObjectValues.Name);
                    Set_MMCName.add(MCCDataObjectValues.Name);
                    insertNetworkFileRecords.put(MCCDataObjectValues.Name,MCCDataObjectValues);
                    List_MCC_Data_object.add(MCCDataObjectValues);
                    Map_MCC_Data_Object.put(MCCDataObjectValues.id,MCCDataObjectValues);
                    Set_MCC_Prov_ID.add(MCCDataObjectValues.MCC_Prov_ID__c);
                    Set_MCC_RecordId.add(MCCDataObjectValues.Id);
                    TempMMCObject=TempMMCObject+1;
            }
            
        }while(TempMMCObject<List_MCC_Data_ObjectQuery.size());
         
        
        System.debug('mccNameWithCaseMap=== '+mccNameWithCaseMap.size()+'===== '+mccNameWithCaseMap);
        //MCCTriggerHandler.networkLoadMassStatus(networkLoadMassData,List_MCC_Data_object);
        //MCCTriggerHandler.insertNetworkFileRecords(insertNetworkFileRecords,List_MCC_Data_object);
        //HandlerClass.AccountCaseCredStatus(Set_MCC_Prov_ID, List_MCC_Data_Object);
        MassCreationQuery.getMCCDataObject(Set_MCC_RecordId);
        MCCTriggerHandler.networkLoadMassStatus(insertNetworkFileRecords, List_MCC_Data_Object);
        ReportingNotification.CredentialingReport(Map_MCC_Data_Object);
        HandlerClass.massCasesClose(insertNetworkFileRecords);
        return List_MCC_Data_ObjectQuery;
    }
     
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/15/2018             to create the MCC_Data_Object records   
*/
    
    public List<MCC_Data_Object__c> OnCreateMCCDataObject(Integer NumberOfrecords)
    {
       
        system.debug('Excecution==='+NumberOfrecords);
        List<MCC_Data_Object__c> ListInsert_MCC_Data_Object = new List<MCC_Data_Object__c>();
        set<id> SetID_MCCD_Data_object= new Set<Id>();
        set<Id> SetID_Case= new Set<Id>();
        Map<Integer,Id> Map_CaseId= new Map<Integer,Id>();
        Set<String> planIdSet   =  new Set<String>(); 
        Map<Id,MCC_Data_Object__c> Map_InsertedMCC_Data_Object= new Map<Id,MCC_Data_Object__c>();
        Map<String,MCC_Data_Object__c> networkLoadMassData= new Map<String,MCC_Data_Object__c>();
        List<MCC_Data_Object__c> List_MCC_Data_Object = new List<MCC_Data_Object__c>();
        Integer j=1;
      
       for ( Integer i = 1; i < NumberOfrecords; i++ )
        {
            MCC_Data_Object__c Insert_MCCDataObject = new MCC_Data_Object__c();
            if(i<5)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='Closed Processed';
                Insert_MCCDataObject.MCC_File_Type__c='Network Load Mass Status';
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'A';
                Insert_MCCDataObject.Processed_for_reporting__c=false;
                Insert_MCCDataObject.Onboarding_Case_ID__c='00';
                Insert_MCCDataObject.Cred_Cycle__c='R';
                Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                Insert_MCCDataObject.MCC_Grouping_ID__c='1234567';
                Insert_MCCDataObject.MCC_Plan_ID__c = 'IL1';
               
            } 
            else if(i<10)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='New';
                Insert_MCCDataObject.MCC_File_Type__c='Network Recruitment';
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'B';
                Insert_MCCDataObject.Processed_for_reporting__c=false;
                Insert_MCCDataObject.MCC_Plan_ID__c = 'TX1';
                Insert_MCCDataObject.Onboarding_Case_ID__c='';
                Insert_MCCDataObject.Cred_Cycle__c='I';
                Insert_MCCDataObject.MCC_Grouping_ID__c='1234567';
                Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                //Insert_MCCDataObject.MCC_Assignee_ID__c='12345678';
              
            }
            else if(i<15)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='In-Progress';
                Insert_MCCDataObject.MCC_File_Type__c='ADC Mass Status';
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'C';
                Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.Processed_for_reporting__c=False;
                Insert_MCCDataObject.MCC_Plan_ID__c = 'MN1';
                Insert_MCCDataObject.Onboarding_Case_ID__c='';
                Insert_MCCDataObject.MCC_Grouping_ID__c='1234567';
                Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                Insert_MCCDataObject.Cred_Cycle__c='R';
                //Insert_MCCDataObject.MCC_Assignee_ID__c='12345678';
              }
            else if(i<20)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='New';
                Insert_MCCDataObject.MCC_File_Type__c='Onboarding Cred Mass Status Update';
                //Insert_MCCDataObject.RecordTypeId=Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Onboarding_Cred_Mass_Status_Update').getRecordTypeId();
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'D';
                Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.Processed_for_reporting__c=False;
                Insert_MCCDataObject.MCC_Plan_ID__c = 'MN1';
                Insert_MCCDataObject.Onboarding_Case_ID__c='0012345';
                Insert_MCCDataObject.Cred_Cycle__c='I';
                Insert_MCCDataObject.MCC_Grouping_ID__c='1234567';
                Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                //Insert_MCCDataObject.MCC_Assignee_ID__c='12345678';
            }
             else if(i<25)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='New';
                Insert_MCCDataObject.MCC_File_Type__c='Mass CRM Creation';
                //Insert_MCCDataObject.RecordTypeId=Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Onboarding_Cred_Mass_Status_Update').getRecordTypeId();
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'E';
                Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.Processed_for_reporting__c=False;
                Insert_MCCDataObject.MCC_Plan_ID__c = 'MN1';
                Insert_MCCDataObject.Onboarding_Case_ID__c='00123567';
                Insert_MCCDataObject.Cred_Cycle__c='I';
                Insert_MCCDataObject.MCC_Grouping_ID__c='1234567';
                Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                //Insert_MCCDataObject.MCC_Assignee_ID__c='12345678';
            }
            
             else if(i<30)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='New';
                Insert_MCCDataObject.MCC_File_Type__c='CRM Mass Status';
                //Insert_MCCDataObject.RecordTypeId=Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Onboarding_Cred_Mass_Status_Update').getRecordTypeId();
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'CRMSt';
                //Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.Processed_for_reporting__c=False;
                Insert_MCCDataObject.MCC_Plan_ID__c = 'MN1';
                Insert_MCCDataObject.Onboarding_Case_ID__c=null;
                Insert_MCCDataObject.Cred_Cycle__c='I';
               Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                //Insert_MCCDataObject.MCC_Assignee_ID__c='12345678';
            }
             else if(i<35)
            {
                Insert_MCCDataObject.MCC_Billing_NPI__c= 'Test' +i;
                Insert_MCCDataObject.MCC_Case_Status__c='New';
                Insert_MCCDataObject.MCC_File_Type__c='ILR';
                //Insert_MCCDataObject.RecordTypeId=Schema.SObjectType.MCC_Data_Object__c.getRecordTypeInfosByDeveloperName().get('Onboarding_Cred_Mass_Status_Update').getRecordTypeId();
                Insert_MCCDataObject.MCC_Comments__c='Text' +i;
                Insert_MCCDataObject.MCC_File_Id__c=system.today()+'Ros';
                //Insert_MCCDataObject.MCC_Case_Id__c=MCC_Case_Id.get(i);
                Insert_MCCDataObject.Processed_for_reporting__c=False;
                Insert_MCCDataObject.MCC_Plan_ID__c = 'MN1';
                //Insert_MCCDataObject.Onboarding_Case_ID__c='00';
                Insert_MCCDataObject.Cred_Cycle__c='R';
                Insert_MCCDataObject.MCC_Prov_ID__c='123456789';
                //Insert_MCCDataObject.MCC_Assignee_ID__c='12345678';
            }
            
          List_MCC_Data_Object.add(Insert_MCCDataObject);
         }
         
        return List_MCC_Data_Object;
        
        
    }
    
     
  /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/24/2018             to Cover the batch job
*/
    
    public void MCCLoadStatusUpdateBatch_Test(Map<Id,Case> Map_CaseValue, List<MCC_Data_Object__c> List_MMC_Data_Object)
    {
       
        Test.startTest();
        getReportTypes();
        prepareData();
        CreateRecordType_settings(40);
        Test.stopTest();        
    }
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/21/2018             to insert the custom setting data   
*/
    
    public static void prepareData()
    {
        
        GlobalSettings__c gs = new GlobalSettings__c();
        gs.Name = 'PFFileRecieved';
        gs.Record_Type_Names__c = 'CRM;';  
        gs.Acceptable_Plan_Ids__c   =   'IL1,MT1,NM1,OK1,TX1'; 
        gs.MCC_trigger_switch__c    =   false;
        insert gs;
        
        List<MCC_Report_Users__c> mccUsersList =  new List<MCC_Report_Users__c>();
        
        MCC_Report_Users__c objreportUser=new MCC_Report_Users__c();           
        objreportUser.Email__c='test@bcbsil.com';
        objreportUser.name='test user';
        objreportUser.Plan_Id__c='TX1';
        
        mccUsersList.add(objreportUser);
        
        MCC_Report_Users__c objreportUser1=new MCC_Report_Users__c();           
        objreportUser1.Email__c='test1@bcbsil.com';
        objreportUser1.name='test user1';
        objreportUser1.Plan_Id__c='IL1';
        
        mccUsersList.add(objreportUser1);
        
        MCC_Report_Users__c objreportUser2=new MCC_Report_Users__c();           
        objreportUser2.Email__c='test2@bcbsil.com';
        objreportUser2.name='test user2';
        objreportUser2.Plan_Id__c='MT1';
        mccUsersList.add(objreportUser2);
        
        MCC_Report_Users__c objreportUser3=new MCC_Report_Users__c();           
        objreportUser3.Email__c='test3@bcbsil.com';
        objreportUser3.name='test user3';
        objreportUser3.Plan_Id__c='OK1';
        
        mccUsersList.add(objreportUser3);
        
        MCC_Report_Users__c objreportUser4 = new MCC_Report_Users__c();           
        objreportUser4.Email__c='test4@bcbsil.com';
        objreportUser4.name='test user4';
        objreportUser4.Plan_Id__c='NM1';
        mccUsersList.add(objreportUser4);
        
        if(mccUsersList.size()>0)
        {
            try{
                insert mccUsersList;
            }catch(DmlException e)
            {
                system.debug('Excpetion==='+e.getMessage());
            }
        }
        
        
        
    }
    
    
 /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/21/2018             Insert the global setting   
* Sreekanth K                07/16/2019             Added all required global seeting fields
*/
 public List<GlobalSettings__c>  InsertGlobalsetting()
    {
        string strIndvCredRecTypeId                      =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        List<GlobalSettings__c> List_InsertGobalSetting            =   new List<GlobalSettings__c>();
        GlobalSettings__c GlobalSettingsValues                =   new GlobalSettings__c();
        GlobalSettingsValues.Name                       =   'PFFileRecieved';
        GlobalSettingsValues.Record_Type_Names__c               =   'CRM;'; 
        GlobalSettingsValues.MCC_trigger_switch__c                =   false;
        GlobalSettingsValues.Acceptable_Plan_Ids__c               =   'IL1,MT1,NM1,OK1,TX1';   
        GlobalSettingsValues.Authorized_Profiles_To_Route_Contracting__c    =  'Supervisor;Provider Data Rep;PNC Profile;System Administrator;Montana Supervisor';
        GlobalSettingsValues.Authorised_Profiles_To_Escalate_Case__c      =   'Provider Data Rep;System Administrator';
        GlobalSettingsValues.Record_Type_Names__c              =    'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        GlobalSettingsValues.Credentialing_record_types__c           =   strIndvCredRecTypeId;
        GlobalSettingsValues.PFFileRecieved__c                  =   false;
        GlobalSettingsValues.Avoided_Case_Origins__c            =  'Web On-boarding,Manual On-boarding,Availity';
        GlobalSettingsValues.Credentialing_record_types__c          =  '01241000001h1BpAAI,01241000001h1BqAAI,01241000001h1BhAAI,01241000001h1BlAAI';
        List_InsertGobalSetting.add(GlobalSettingsValues);
        if(List_InsertGobalSetting.size()>0)
        {
            try{
                insert List_InsertGobalSetting;
            }catch(DmlException e)
            {
                system.debug('Exception=='+e.getMessage());
            }
        }
        return List_InsertGobalSetting;
    }
    
  /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/26/2018             ReportTypes Query   
*/
    
  public List<Report> getReportTypes()
  {
      Set<String>  reportNames  =  new Set<String>
      {'Recruitment_File_Result','Death_File_Result','Roster_File_Result','Credentialing_cases_mass_update_report','CRM_Mass_Case_Closure_Report',
          'Mass_Case_Closure_Report','NetworkLoad_Mass_Status_Template','Credentialing_cases_mass_update_reportV2'};
      List<report> List_Report=[Select Id,Name from Report where DeveloperName IN :reportNames];     
      return List_Report;
      
  }
    
    /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/27/2018             To create the custom setting for RecordType_settings__c
*/
    
    public static void CreateRecordTypeSettings()
    {
        list<RecordType> rt             = new list<RecordType>();
        RecordType_settings__c rtype    =   new RecordType_settings__c();
        list<RecordType_settings__c> rTypeList = new list<RecordType_settings__c>();
        rt = [select id,DeveloperName,Name,SobjectType from RecordType where SobjectType = 'Case'];
        integer i = 0;
        for(RecordType r:rt){
            i = i + 1;
            rtype                       =   new RecordType_settings__c();
            rtype.DeveloperName__c      =   r.developername;
            rtype.Name__c               =   r.name.substring(0,1) + string.valueof(i);
            rtype.Name                  =   r.name.substring(0,1) + string.valueof(i);
            rtype.Record_type_Id__c     =   r.Id;
            rtype.sObject_Type__c       =   'Case';
            rTypeList.add(rType);
        }
        insert rTypeList;
    }
    
    /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/27/2018             To create the custom setting for RecordType_settings__c
*/
    
    public static void CreateEmailSettings()
    {
        list<Email_Settings__c> esList            = new list<Email_Settings__c>();
        Email_Settings__c es    =   new Email_Settings__c();
        es.Name      = 'OrgWideEmailIL';
        es.State__c  = 'ILintaketeampiermailboxsit@bcbsmt.com';
        esList.add(es);
        es    =   new Email_Settings__c();
        es.Name      = 'OrgWideEmailMT';
        es.State__c  = 'MTintaketeampiermailboxsit@bcbsmt.com';
        esList.add(es);
        es    =   new Email_Settings__c();
        es.Name      = 'OrgWideEmailTX';
        es.State__c  = 'TXintaketeampiermailboxsit@bcbsmt.com';
        esList.add(es);
        es    =   new Email_Settings__c();
        es.Name      = 'OrgWideEmailNM';
        es.State__c  = 'NMintaketeampiermailboxsit@bcbsmt.com';
        esList.add(es);
        es    =   new Email_Settings__c();
        es.Name      = 'OrgWideEmailOK';
        es.State__c  = 'OKLintaketeampiermailboxsit@bcbsmt.com';
        esList.add(es);
        insert esList;
    }
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/27/2018             To create the custom setting for RecordType_settings__c
*/
    
    public List<RecordType_settings__c> CreateRecordType_settings(Integer NumberOfRecords)
    {
        system.debug('Test== >> ');
       List<RecordType_settings__c> Insert_RecordType_settings= new List<RecordType_settings__c>();
       for(Integer i=0;i<NumberOfRecords;i++)
       {
          RecordType_settings__c RecordType_settings= new RecordType_settings__c();
           if(i<=1)
           {
               RecordType_settings.DeveloperName__c='Contracting_Provider_On_boarding';
               RecordType_settings.Name__c='Contracting_Provider_On_boarding';
               RecordType_settings.Name='Contracting_Provider_On_boarding';
               RecordType_settings.Record_type_Id__c='01241000000vQzIAAU';
               RecordType_settings.sObject_Type__c='Contracting_Provider_On_boarding';
               Insert_RecordType_settings.add(RecordType_settings);
           }else if(i<=2)
           {
               RecordType_settings.DeveloperName__c='Provider_Group_Onboarding_Contracting';
               RecordType_settings.Name='Provider Group Onboarding Contracting';
               RecordType_settings.Name__c='Provider Group Onboarding Contracting';
               RecordType_settings.Record_type_Id__c='01241000001h1BjAAI';
               RecordType_settings.sObject_Type__c='Provider_Group_Onboarding_Contracting';  
                Insert_RecordType_settings.add(RecordType_settings);
           }else if(i<=3)
           {
               RecordType_settings.DeveloperName__c='Provider_On_boarding_Contracting_Edit';
               RecordType_settings.Name='Provider_On_boarding_Contracting_Edit';
               RecordType_settings.Name__c='Provider_On_boarding_Contracting_Edit';
               RecordType_settings.Record_type_Id__c='01241000001h1BmAAI';
               RecordType_settings.sObject_Type__c='Provider_On_boarding_Contracting_Edit';  
               Insert_RecordType_settings.add(RecordType_settings);
           }
       }
       if(Insert_RecordType_settings.size()>0)
       {
           try{
               insert Insert_RecordType_settings;
               system.debug('Insert_RecordType_settings== '+Insert_RecordType_settings);
           }catch(DmlException e)
           {
               system.debug('Excpetion==== '+e.getMessage());
           }
       }
        return Insert_RecordType_settings;
    }
    
    
/*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                    11/28/2018             To create the case comments (DataSupportForCaseCommentTriggerHandler)
*/
  
  public List<CaseComment> InsertCaseComments(Map<Id,Case> MapCaseId)
  {
     Set<Id> Set_CaseId= new Set<Id>();
     List<CaseComment> List_InsertCaseComments = new List<CaseComment>();
     for(Id CaseId :Set_CaseId)
     {
        CaseComment Insert_CaseComments = new CaseComment(); 
        Insert_CaseComments.ParentId=CaseId;
        Insert_CaseComments.CommentBody='TestBody';
        Insert_CaseComments.IsPublished=true;
        List_InsertCaseComments.add(Insert_CaseComments);
     }
      if(List_InsertCaseComments.size()>0)
      {
          try{
              Insert List_InsertCaseComments;
          }catch(DmlException e)
          {
              
          }
      }
     return List_InsertCaseComments;
  }
  
  
  
  /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                   02/03/2019                Create Account Values
*/


public List<Account> LstCreateAccount(Integer NumberOfrecords, String PlanID)
{
    
    AccountTriggerHandler Handler= new AccountTriggerHandler();
    List<Account> List_AccountInsert = new List<Account>();
    for(Integer i=0;i<=NumberOfrecords;i++)
    {
        Account Account_Insert = new Account();
        Account_Insert.name = 'test Account';
        Account_Insert.prov_id__c='123456'+i;
        Account_Insert.CM_Corporate_Entity_Code__c = PlanID;
        List_AccountInsert.add(Account_Insert);
    }
    if(List_AccountInsert.size()>0)
     {
         try{
             insert List_AccountInsert;
         }catch(DmlException e)
         {
             system.debug('Exception=='+e.getmessage());
         }
     } 
    getAccountValues(List_AccountInsert);
    return List_AccountInsert;
}

 /*
-----------------------------------------------------------------------------
* Developer                   Date                   Description
-----------------------------------------------------------------------------                 
* Ashok N                   02/03/2019                Query Account Values
*/

public Map<Id,Account> getAccountValues(List<Account> List_AccountValues)
{
   Map<Id,Account> NewAccountValues = new Map<Id,Account>();
   AccountTriggerHandler AccountHandler= new AccountTriggerHandler();
   Set<Id> Set_AccountId= new set<Id>();
   for(Account AccountValues : List_AccountValues)
   {
     NewAccountValues.put(AccountValues.Id,AccountValues);
     Set_AccountId.add(AccountValues.Id);
   }
   List<Account> List_AccountQuery= new List<Account>();
   Map<Id,Account> Map_AccountUpdate = new Map<Id,Account>();
   try{
     List_AccountQuery=[select Id,Description from account where Id IN:Set_AccountId];  
   }catch(QueryException e)
    {
    
        system.debug('Excpetion==='+e.getmessage());
    }
    
   
   for(Account AccountValues : List_AccountQuery)
   {
       Account AccountUpdate = new Account();
       AccountUpdate.id=AccountValues.Id;
       AccountUpdate.Description='Test123';
       Map_AccountUpdate.put(AccountUpdate.Id,AccountUpdate);
    }
    try{
        update Map_AccountUpdate.values();
    }catch(DmlException e )
    {
        system.debug('Exception=='+e.getmessage());
    }
    AccountHandler.CommentHistoryTracking(Map_AccountUpdate, NewAccountValues);
 
 return null;   
}

  
      /*
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    -----------------------------------------------------------------------------                 
    * Sreekanth K                02/03/2019             create date for DefaultQueueSettings custom settings
    */
    public static List<DefaultQueueSettings__c> insertDefaultQueueSettings()
    {
        Map<String,Id>    queueNameWithIdMap                      =      new Map<String,Id>();
        for(Group grp : [Select DeveloperName,Name,Id from Group where Type='Queue' and DeveloperName IN ('Illinois_Queue','OMNI_IL_Contracting_Queue','OMNI_IL_Data_Entry_Queue')])
        {
            queueNameWithIdMap.put( grp.developerName , grp.Id );
        }
        
        List<DefaultQueueSettings__c> recordsToInsert      =      new List<DefaultQueueSettings__c>();
        
        DefaultQueueSettings__c dSeeting1                          =      New DefaultQueueSettings__c();
        dSeeting1.Name                                                           =       'Illinois_Queue';
        dSeeting1.IsContractingQueue__c                            =      false;
        dSeeting1.IsDataEntryQueue__c                              =      false;
        dSeeting1.IsEscalateQueue__c                               =      true;
        dSeeting1.PlanId__c                                                      =      'IL1';
        dSeeting1.QueueId__c                                              =       queueNameWithIdMap.get('Illinois_Queue');
        dSeeting1.QueueName__c                                            =      'Illinois Queue';
        recordsToInsert.add( dSeeting1 );
        
        DefaultQueueSettings__c dSeeting2                          =      New DefaultQueueSettings__c();
        dSeeting2.Name                                                           =       'OMNI_IL_Data_Entry_Queue';
        dSeeting2.IsContractingQueue__c                            =      false;
        dSeeting2.IsDataEntryQueue__c                              =      true;
        dSeeting2.IsEscalateQueue__c                               =      false;
        dSeeting2.PlanId__c                                                      =      'IL1';
        dSeeting2.QueueId__c                                              =       queueNameWithIdMap.get('OMNI_IL_Data_Entry_Queue');
        dSeeting2.QueueName__c                                            =      'IL Data Entry Queue';
        recordsToInsert.add( dSeeting2 );
        
        DefaultQueueSettings__c dSeeting3                          =      New DefaultQueueSettings__c();
        dSeeting3.Name                                                           =       'OMNI_IL_Contracting_Queue';
        dSeeting3.IsContractingQueue__c                            =      true;
        dSeeting3.IsDataEntryQueue__c                              =      false;
        dSeeting3.IsEscalateQueue__c                               =      false;
        dSeeting3.PlanId__c                                                      =      'IL1';
        dSeeting3.QueueId__c                                              =       queueNameWithIdMap.get('OMNI_IL_Contracting_Queue');
        dSeeting3.QueueName__c                                            =      'IL Contracting Queue';
        recordsToInsert.add( dSeeting3 );
        
        if( !recordsToInsert.isEmpty() )
          {
              try{
                  Insert recordsToInsert;
              }catch(DmlException e)
              {
                  System.debug('Exception in default queue settings insert===>>>'+e.getMessage());
              }
          }
      return recordsToInsert;
    }
    
     /*
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    -----------------------------------------------------------------------------                 
    * Ashok N              04/01/2019            To cover the test class for SharedEmailInboxes
    */
    
    public void SharedEmailInBoxes_Test()
    {
        List<Error_Message__c> List_ErrorMessage= new List<Error_Message__c>();
        Case InsertCase=new Case();
        InsertCase.status='New';
        InsertCase.Origin='Ancillary Gov Expansion';
        InsertCase.Grouping_ID__c='123456';
        InsertCase.prov_id__c='123456789';
        InsertCase.Cred_Cycle__c='I';
        Insert InsertCase;
        EmailToCaseRoutingAddresses__c Insert_EmailToCaseRoutingAddresses = new EmailToCaseRoutingAddresses__c();
        Insert_EmailToCaseRoutingAddresses.Name='Ancillary Gov Expansion';
        Insert_EmailToCaseRoutingAddresses.routingname__c='Test123@gmail.com';
        insert Insert_EmailToCaseRoutingAddresses;
        Error_Message__c Insert_Error_Message = new Error_Message__c();
        Insert_Error_Message.Class_Name__c='Test123';
        List_ErrorMessage.add(Insert_Error_Message);
        insert List_ErrorMessage;
        
        List<Map<String, Object>> defaultSettingAsObject = new List<Map<String, Object>>
        {
            new Map<String, Object>
            {
                   'targetSObject' => new EmailMessage(),
                    'contextId' => InsertCase.Id,
                    'actionType' => 'Email',
                    'actionName' => 'Case.Email',
                    'fromAddressList' => new List<String> { 'salesforce@test.com' }
            }
        };  
            List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(JSON.serialize(defaultSettingAsObject), List<QuickAction.SendEmailQuickActionDefaults>.class);
        try {
            (new SharedEmailInboxes()).onInitDefaults(defaultsSettings);
        }
        catch(Exception e) {
           // failureDuringExecution = e; 
        }

    }
    
        /*
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    -----------------------------------------------------------------------------                 
    * Ashok N              04/12/2019            To cover the test class for DataSupportForCaseCommentTriggerHandler
    */
    
    public void DataCaseCommentsTriggerHandler(String PlanId,Integer TotalRecords)
    {
        QueueIds__c QueueIds = new QueueIds__c();
        QueueIds.PlanId__c='IL1';
        QueueIds.QueueId__c='0014100001uAa4i';
        QueueIds.Name='0014100001uAa4i';
        insert QueueIds;
        
        GlobalSettings__c GlobalSettings = new GlobalSettings__c();
        GlobalSettings.Acceptable_Plan_Ids__c='IL1';
        GlobalSettings.Name='Test123';
        GlobalSettings.PFFileRecieved__c=true;
        insert GlobalSettings;
        
        DataSupportForCaseCommentTriggerHandler DataSupport = new DataSupportForCaseCommentTriggerHandler();
        Id Provider_Group_On_boarding_Network_LoadId=Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
        CreateRecordTypeSettings();
        Case InsertCase=new Case();
        InsertCase.status='New';
        InsertCase.Plan_ID__c='TX1';
        InsertCase.Origin='Web On-boarding';
        InsertCase.Grouping_ID__c='123456';
       // InsertCase.prov_id__c='123456789';
        InsertCase.Prov_ID__c='111111111';
        insertCase.RecordTypeId=Provider_Group_On_boarding_Network_LoadId;
        InsertCase.Cred_Cycle__c='I';
        Insert InsertCase;
        DataSupport.returnNewCaseComment(InsertCase);
        Datasupport.insertDataForParentCases();
        Datasupport.insertDataForChildCases(InsertCase);
        DataSupport.insertDataForCustomSettings();
        CaseComment Case_Comments = new CaseComment();
        Case_Comments.ParentId=InsertCase.Id;
        Case_Comments.CommentBody='Test Body';
        Insert Case_Comments;
        
    }
    
}