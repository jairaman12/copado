@isTest
private class OMNIUserRecalculationtest {

    static testMethod void test_userrecaluclation() {
    List<User>  userList    =   TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
        insert userList;
       System.runAs(new User(Id = UserInfo.getUserId())){
        OMNI_Queue__c queueRec              =   new OMNI_Queue__c();
         queueRec.Case_Type__c              =   'Demographics';
         queueRec.Request_Type_s__c         =   'Credentialing Change; Name Change Request';
         queueRec.Plan_Id__c                =   'IL1';
         queueRec.Queue_Priority__c         =   '5';
         insert queueRec;
         
         OMNI_User_Group__c usrGrouprec     =   new OMNI_User_Group__c();
         usrGrouprec.Group__c               =   queueRec.Id;
         usrGrouprec.Start_Date__c          =   date.today();
         usrGrouprec.End_Date__c            =   date.today();
         usrGrouprec.Plan_Id__c             =   'IL1';
         usrGrouprec.Active__c              =   true;
         usrGrouprec.Week_Days__c           =   'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday';
         usrGrouprec.Selected_User_Ids__c   =   userList[0].Id;
         usrGrouprec.Selected_Users__c      =   userList[0].Name;
         insert usrGrouprec;
             
         OMNI_User_Group__c usrGrouprec1        =   new OMNI_User_Group__c();
         usrGrouprec1.Group__c              =   queueRec.Id;
         usrGrouprec1.Start_Date__c         =   date.today();
         usrGrouprec1.End_Date__c           =   Date.Today().addDays(15);
         usrGrouprec1.Plan_Id__c            =   'IL1';
         usrGrouprec1.Active__c             =   true;
         usrGrouprec1.Week_Days__c          =   'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday';
         usrGrouprec1.Selected_User_Ids__c  =   userList[0].Id;
         usrGrouprec1.Selected_Users__c     =   userList[0].Name;
         insert usrGrouprec1;
           GlobalSettings__c gs    =   new GlobalSettings__c();
           gs.name                 =   'PFFileRecieved';
           gs.PFFileRecieved__c    =   false;
           gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
           insert gs;        
           Test.startTest();
            OMNIUserRecalculation bt = new OMNIUserRecalculation();
            Database.executeBatch( bt );
            System.Schedule('OMNIUserreCalc', '0 00 3 * * ?', new OMNIUserRecalculationScheduler());
            Test.stopTest(); 
       }
    }
}