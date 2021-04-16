public class CreateNetworkChildCls {
     @InvocableMethod(label='createChildNetworks' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void updateEmailCaseOwner(list<Case> caseList)
    {
        Map<Id,List<String>> caseIdProviderMap  =   new Map<Id,List<String>>();
        List<Case> caseListForInsert            =   new List<Case>();
        List<Provider_Networks__c> networksForInsert = new List<Provider_Networks__c>();
        
        System.debug('caseList====>>>>'+caseList);
        if( !caseList.isEmpty() )
        {
            for(case cs: caseList)
            {
                Case csRecord       = new Case();
                csRecord.AccountId  = cs.AccountId;
                csRecord.Application_Id__c              =   cs.Application_Id__c;
                csRecord.Application_Review_URL__c      =   cs.Application_Review_URL__c;
                csRecord.Attachment_Indicator__c        =   cs.Attachment_Indicator__c;
                csRecord.Attachment_Review_URL__c       =   cs.Attachment_Review_URL__c;
                csRecord.Bill_PFIN__c                   =   cs.Bill_PFIN__c;
                csRecord.Billing_NPI_Number__c          =   cs.Billing_NPI_Number__c;
                csRecord.Bill_NPI_Type__c               =   cs.Bill_NPI_Type__c;//Sujatha UAT Defect PPN-34628
                csRecord.Plan_ID__c                     =   cs.Plan_ID__c;
                csRecord.Case_Entity__c                 =   cs.Case_Entity__c;
                csRecord.Completing_the_form_for__c     =   cs.Completing_the_form_for__c;
                csRecord.Prov_ID__c                     =   cs.Prov_ID__c;
                csRecord.Description                    =   cs.Description;
                csRecord.Do_Not_Add_List__c             =   cs.Do_Not_Add_List__c;
                csRecord.Email_Address_Submitter__c     =   cs.Email_Address_Submitter__c;
                csRecord.Govt_Programs__c               =   cs.Govt_Programs__c;
                csRecord.Contract_PFIN__c               =   cs.Contract_PFIN__c;
                csRecord.Name_Change__c                 =   cs.Name_Change__c;
                csRecord.Name_of_Provider_Group__c      =   cs.Name_of_Provider_Group__c;
                csRecord.Network_Name_Detail__c         =   cs.Network_Name_Detail__c;
                csRecord.Network_Name__c                =   cs.Network_Name__c;
                csRecord.Origin                         =   cs.Origin;
                csRecord.Original_Creation_Date__c      =   cs.Original_Creation_Date__c;
                csRecord.ParentId                       =   cs.ParentId;
                csRecord.Priority                       =   cs.Priority;
                csRecord.Title_Submitter__c             =   cs.Title_Submitter__c;
                csRecord.Name_Submitter__c              =   cs.Name_Submitter__c;                
                csRecord.RecordTypeId                   =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Network_Load').getRecordTypeId();
                  //  '012c0000000DZMSAA4';
                csRecord.Rendering_NPI__c               =   cs.Rendering_NPI__c;
                csRecord.Status                         =   'New';
                csRecord.Subject                        =   cs.Subject;
                csRecord.Tax_ID_Number__c               =   cs.Tax_ID_Number__c;
                csRecord.Telephone_Number_Submitter__c  =   cs.Telephone_Number_Submitter__c;
                csRecord.Network_Name__c                =   cs.Network_Name__c;
                csRecord.Out_of_Network__c              =   cs.Out_of_Network__c;
                caseListForInsert.add(csRecord);
            }
        }
        if(!caseListForInsert.isEmpty()){
            Database.insert(caseListForInsert);
        }
        
        for( Case cs : caseListForInsert )
        {
            if( String.isNotBlank( cs.Network_Name__c ) )
            {
                String tempString  = cs.Network_Name__c;
                
                for (String network : tempString.split(';') )
                {
                    Provider_Networks__c networkRec     =   new Provider_Networks__c();
                    networkRec.Name__c                  =   network.substringAfter('- ');
                    networkRec.Network__c               =   network.substringBefore(' -');
                    networkRec.Case_Number__c           =   cs.Id;
                    networkRec.Plan_Id__c               =   cs.Plan_ID__c;
                    networksForInsert.add(networkRec);
                }
            }
        }
        if(!networksForInsert.isEmpty()){
            insert networksForInsert;
        }
        
    } 
}