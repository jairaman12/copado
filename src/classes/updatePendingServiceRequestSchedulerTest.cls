@isTest
public class updatePendingServiceRequestSchedulerTest {

     @isTest
    static void updatePendingServiceRequestSchedulerTest1()
    {
      List<User>  userList    =   TestCaseUtil.createUser('System Administrator','Illinois Supervisor',1);
        insert userList;
        
        List<User>  dataRepUserlist =   TestCaseUtil.createUser('Provider Data Rep','Provider Data Rep- IL',1);
        insert dataRepUserlist;

        System.runAs(userList[0]){
            
          GlobalSettings__c gs    =   new GlobalSettings__c();
            gs.name                 =   'PFFileRecieved';
            gs.PFFileRecieved__c    =   false;
            gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
            gs.CRM_Case_record_Type_Id__c = Utils.GetRecordTypeId('Case','CRM');
            insert gs;
        CaseOwnerUpdate__c caseOwner1 = new CaseOwnerUpdate__c(Name='PNC Profile',Profile__c='PNC Profile');
        insert caseOwner1;
        
        CaseOwnerUpdate__c caseOwner2 = new CaseOwnerUpdate__c(Name='Provider Data Rep',Profile__c='Provider Data Rep');
        insert caseOwner2;
       
        List<RecordType> recType =  [SELECT DeveloperName,Id,Name FROM RecordType WHERE Name In ('Master Provider Case data','Name Change Request')];
        Case parentCase          =  TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c   =   'test@test.com';
        parentCase.RecordTypeId =   recType[0].id;
        parentCase.Plan_ID__c   =   'IL1';
        parentCase.Status       =   'New';
         parentCase.Subject     =   'Test Email';
         parentCase.Origin      =   'PNC NetOps Inquiries';
        insert parentCase;
        
        Case childCase          =   TestCaseUtil.CreateCase();   
        childCase.ParentId      =   parentCase.id; 
        childCase.Email_Address_Submitter__c    =   'test3@test.com';
        childCase.RecordTypeId  =   recType[1].id;
        childCase.Govt_Programs__c              =   true;
        childCase.Plan_ID__c                    =   'IL1';
        childCase.Status                        =   'New';
            try
            {
                insert childCase;
            }catch(Exception e){
                
            }
            Set<id> caseIds = new Set<Id>();
            caseIds.add(childCase.Id);
            
           Test.startTest();
            updatePendingServiceRequestScheduler testJob = new updatePendingServiceRequestScheduler (caseIds);
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('TestJob', sch, testJob);
           Test.stopTest();
        }
    }
}