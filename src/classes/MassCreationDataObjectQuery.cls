global class MassCreationDataObjectQuery {
    
    
    /*
     * Author :Ashok N
     * Date : 12/23/2018
     * Business Purpouse : To query the case records to get the Plan ID
     */
  public Map<Id,Case> getCaseQueryRecord(set<Id> SetCaseId) 
  {
      Map<Id,Case> Map_CaseQuery=new Map<Id,Case>([Select Id,CaseNumber,status,Plan_ID__c ,ParentId,MCC_Record_Name__c,Project_Number__c,Grouping_ID__c,Comments from case where 
                                                   ID IN :SetCaseId]);
      return Map_CaseQuery;
  }
    
  /*
     * Author :Ashok N
     * Date : 12/23/2018
     * Business Purpouse : To query the case records to get the Plan ID
     */
  public List<Case> getlistOfCaseQueryRecord(List<string> listCaseNum) 
  {
      List<Case> listCaseQuery=new list<Case>([Select Id,CaseNumber,status,Plan_ID__c ,ParentId,MCC_Record_Name__c,Project_Number__c,Grouping_ID__c,Comments from case where 
                                                   CaseNumber IN :listCaseNum]);
      return listCaseQuery;
  }
    
    /*
     * Author :Ashok N
     * Date : 12/23/2018
     * Business Purpouse : To query the case records to get the Plan ID
     */
  public List<Case> getlistOfCaseQueryRecords(List<Id> listCaseId) 
  {
      List<Case> listCaseQuery=new list<Case>([Select Id,CaseNumber,status,Plan_ID__c ,ParentId,MCC_Record_Name__c,Project_Number__c,Grouping_ID__c,Comments from case where 
                                                   Id IN :listCaseId]);
      return listCaseQuery;
  }
    
    
    
    /*
     * Author :Ashok N
     * Date : 1/14/2019
     * Business Purpouse : To query the caseID from the caseNumber 
     */
  public Map<Id,Case> getCaseQueryRecordID(set<String> SetCaseNumber) 
  {
      Map<Id,Case> Map_CaseQuery=new Map<Id,Case>([Select Id,CaseNumber,status,Plan_ID__c ,ParentId,MCC_Record_Name__c,Project_Number__c,Grouping_ID__c,Comments from case where 
                                                   caseNumber IN :SetCaseNumber]);
      return Map_CaseQuery;
  }
    
    
    /*
     * Author :Ashok N
     * Date : 1/29/2019
     * Business Purpouse : To query the caseID from the caseNumber 
     */
  public Map<Id,Case> getCaseQueryCredCycle(set<Id> SetCaseID) 
  {
      Map<Id,Case> Map_CaseQuery=new Map<Id,Case>([Select Id,CaseNumber,status,Plan_ID__c ,ParentId,MCC_Record_Name__c,Project_Number__c,Grouping_ID__c,Comments from case where 
                                                   ID IN :SetCaseId AND Cred_Cycle__c='I']);
      return Map_CaseQuery;
  }
    
    
  /*
   * 
   */
    
    public Map<Id,MCC_Data_Object__c> getMCCDataObject(Set<ID> Set_MCCRecordId)
    {
        Map<Id,MCC_Data_Object__c> Map_MCCDataObjectQuery=new Map<Id,MCC_Data_Object__c>([select Id,MCC_File_Type__c,MCC_File_Id__c,
                                                                                          MCC_Load_Status__c,MCC_Prov_ID__c,File_Count__c,
                                                                                          Name,MCC_Plan_ID__c
                                                                                          from MCC_Data_Object__c 
                                                                                          where Id IN :Set_MCCRecordId]);
       return Map_MCCDataObjectQuery;
    }
    
    /*
     * 
     */
    
    public Map<Id,Group> getGroupQuery(String Queue ,String DeveloperName, Set<String> AssingeId)
    {
        Map<Id,Group> Map_GroupQuery= new Map<Id,Group>([SELECT Id, Name,developerName FROM Group WHERE type =:Queue 
                                                         and (developerName =:DeveloperName OR NAME IN :AssingeId )]);
        return Map_GroupQuery;
    }
    
    /*
     * 
     * 
     */
    public Map<Id,Case> getCaseProjectNumber(Set<String> ProjectNumber)
    {
        Map<Id,case> getCaseProjectNumber= new Map<Id,Case>([SELECT Id, Project_Number__c,ParentId FROM CASE 
                                                             where Project_Number__c IN :ProjectNumber AND IsClosed !=true ]);
        return getCaseProjectNumber;
    }
    /*
     * 
     * Author :U393129
     * Date : 12/26/2018
     * Business Purpouse : To get the recordType When we insert the process the records to MCC_Data_object
     * Ver : 1.0  
*/
     
    
    public Map<Id,RecordType> getRecordType(String SobjectType)
    {
      Map<Id,RecordType> RecordTypeQuery = new Map<Id,RecordType>([Select Id,developerName,Name,sobjectType from RecordType where
                                                                   SobjectType=:SobjectType ]);
      return RecordTypeQuery;
    }
    
 
    
/*
     * 
     * Author :U393129
     * Date : 12/26/2018
     * Business Purpouse : To Query the records from CM_Provider_Tax_Id
     * Ver : 1.0  
*/
    
    public Map<id,CM_Provider_Tax_Id__c> getCM_ProviderTaxId(Set<String> TaxIdSet)
    {
        Map<Id, CM_Provider_Tax_Id__c> Map_CM_ProviderTaxIDQuery=new Map<Id,CM_Provider_Tax_Id__c>([select id, CM_PTI_Prov_Name_From__c,  CM_PTI_Tax_Id__c from CM_Provider_Tax_Id__c where CM_PTI_Tax_Id__c IN :TaxIdSet ]);
        return Map_CM_ProviderTaxIDQuery;
    }
    
    
    /*
     * 
     * Author :U393129
     * Date : 12/26/2018
     * Business Purpouse : To Query the records from CM_Provider_Tax_Id
     * Ver : 1.0  
*/
    
    public Map<id,CM_Provider_Identification__c> getCMProviderIdentification(Set<String> NPIIdSet)
    {
        Map<Id, CM_Provider_Identification__c> Map_ProviderIdentification=new Map<Id,CM_Provider_Identification__c>([select id, CM_PI_Prov__c, CM_Issu_Ident_Nmbr__c from CM_Provider_Identification__c where  CM_Issu_Ident_Nmbr__c In: NPIIdSet ]);
        return Map_ProviderIdentification;
    }
    
    
    /*
    * 
    * Author :U393129
    * Date : 12/28/2018
    * Business Purpouse : To Query the Account records by using the Prov_ID__c
    * Ver : 1.0  
    */
    
    public Map<id,Account> getAccount(Set<String> SetProviderID)
    {
        Map<Id, Account> Map_Account=new Map<Id,Account>([select id, Prov_ID__c,CM_Corporate_Entity_Code__c,RecordtypeId,RecordType.developerName,Name  from  
                                                          Account where  Prov_ID__c In: SetProviderID ]);
        return Map_Account;
    }
    
    
    
    
     /*
    * 
    * Author :U393129
    * Date : 1/15/2019
    * Business Purpouse : To Query the Prov_ID__c from the ID 
    * Ver : 1.0  
    */
    
    public Map<id,Account> getAccountID(Set<ID> Set_AccountId)
    {
        Map<Id, Account> Map_Account=new Map<Id,Account>([select id, Prov_ID__c,CM_Corporate_Entity_Code__c,RecordtypeId,RecordType.developerName,Name  
                                                          from  Account where  ID IN: Set_AccountId ]);
        return Map_Account;
    }
    
    
    /*
    * 
    * Author :U393129
    * Date : 1/15/2019
    * Business Purpouse : To Query the Prov_ID__c from the ID 
    * Ver : 1.0  
    */
    
    public List<Account> getCredAccount(List<string> listProvId)
    {
        List<Account> listAccount=new List<Account>([select id, Prov_ID__c,CM_Corporate_Entity_Code__c,RecordtypeId,RecordType.developerName,Name  
                                                          from  Account where  Prov_ID__c IN: listProvId ]);
        return listAccount;
    }
    
    
      /*
    * 
    * Author :U393129
    * Date : 1/15/2019
    * Business Purpouse : To Query the Prov_ID__c from the ID 
    * Ver : 1.0  
    */
    
    public List<Account> getCredAccounts(List<Id> listAcctId)
    {
        List<Account> listAccount=new List<Account>([select id, Prov_ID__c,CM_Corporate_Entity_Code__c,RecordtypeId,RecordType.developerName,Name  
                                                          from  Account where  Id IN: listAcctId ]);
        return listAccount;
    }
    
    
    
    
    /*
* 
* Author :U393129
* Date : 12/28/2018
* Business Purpouse : To Query the User Record from User
* Ver : 1.0  
*/
    public Map<Id,User> getUser(Set<String> SetOfEmployeeIds)
    {
        Map<Id,User> Map_User= new Map<Id,User>
            ([Select Id,employeeNumber From User where employeeNumber In: SetOfEmployeeIds]);
        return Map_User;
        
    }
    
    
      /*
* 
* Author :U393129
* Date : 12/28/2018
* Business Purpouse : To Query the records from Case by using Grouping_ID__c
* Ver : 1.0  
*/
    public Map<Id,Case> getCaseGroupValues(Set<String> SetGroupingID)
    {
        Map<Id,Case> Map_CaseGroupValues= new Map<Id,Case>
            ([SeLECT Id, Grouping_ID__c, Project_Number__c,ParentId FROM Case WHERE Grouping_ID__c IN: SetGroupingID AND
              IsClosed !=true]);
         return Map_CaseGroupValues;
        
    }
    
    
         /*
* 
* Author :Ashok N
* Date : 12/28/2018
* Business Purpouse : To Query the records from Case by using Grouping_ID__c
* Ver : 1.0  
*/
    public Map<Id,GlobalSettings__c> getGlobalCustomSetting()
    {
        Map<Id,GlobalSettings__c> Map_GlobalSettings= new Map<Id,GlobalSettings__c>
            ([SeLECT Id, MCC_Case_Origin__c,Name, PFFileRecieved__c FROM GlobalSettings__c]);
         return Map_GlobalSettings;
        
    }

             /*
* 
* Author :Ashok N
* Date : 2/28/2019
* Business Purpouse : To Query the records user records
* Ver : 1.0  
*/
    
  public map<Id,User> getUserDetails(Set<Id> Set_UserId)
  {
     Map<Id,User> Map_User= new Map<Id,User>
            ([Select Id,employeeNumber,Alias From User where Id In: Set_UserId]);
        return Map_User; 
  }

    
                 /*
* 
* Author :Ashok N
* Date : 3/04/2019
* Business Purpouse : To Query the reports 
* Ver : 1.0  
*/
    
  public map<Id,Report> getReportName()
  {
     Map<Id,Report> Map_Report= new Map<Id,Report>([Select Id,DeveloperName From Report]);
     return Map_Report; 
  }
    
                     /*
* 
* Author :Ashok N
* Date : 3/06/2019
* Business Purpouse : To Query the reports 
* Ver : 1.0  
*/
    
  public map<Id,ETL_Report_Config_Data__mdt> getETLReprotConfigData(Set<String> Set_MCCFileType)
  {
      Map<Id,ETL_Report_Config_Data__mdt> ETL_Report_Config_Data= new Map<Id,ETL_Report_Config_Data__mdt>
          ([select Id,Email_Address__c,Destination_Org__c,Active_Email__c,File_Type__c,Plan_Id__c,Total_Accounts__c from ETL_Report_Config_Data__mdt where 
            File_Type__c IN : Set_MCCFileType]);
      return ETL_Report_Config_Data; 
  }
    
}