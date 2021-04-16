/*
 * Used to test the mobile version of CRM Case Creation 
*/
@isTest
public class LtngCtrlCRMCase_test {   
    
     @testSetup static void prepareData() {
         GlobalSettings__c gs    =   new GlobalSettings__c();
            gs.name                 =   'PFFileRecieved';
            gs.PFFileRecieved__c    =   false;
            gs.Affiliation_Trigger_Switch__c =   false;
         	gs.CRM_Case_Origin_Values__c = 'Email,Fax,In Person,Internal,Mass Case Creation,Others,Phone,Webex,Written';
         	gs.CRM_Case_Status_fields__c = 'New,In Progress,Waiting for Internal Response,Waiting for External Response,Closed';
            gs.Record_Type_Names__c = 'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
         insert gs;
         	
         Account acc = TestClassData.CreateAccount();
         CM_SPL_Addr__c spl = new CM_SPL_Addr__c();
         spl.CM_SPL_PFIN_No__c = '1234567890';         
         spl.CM_County__c      = 'Orange';
         spl.Bill_PFIN__c      = '1234567890';
         spl.CM_SPL_Prov__c    = acc.id;
         spl.CM_Corporate_Entity_Code__c = 'IL1';
         insert spl;
         spl = new CM_SPL_Addr__c();
         spl.CM_SPL_PFIN_No__c = '1234567890';         
         spl.CM_County__c      = 'Orange';
         spl.Bill_PFIN__c      = '1234567890';
         spl.CM_SPL_Prov__c    = acc.id;
         spl.CM_Corporate_Entity_Code__c = 'IL1';
         insert spl;
     }
    @isTest
    static void test_LtngCtrlCRMCase(){  
        Account acc = [select id from account limit 1];
        list<CM_SPL_Addr__c> spl = [select id,CM_SPL_PFIN_No__c from CM_SPL_Addr__c];
        case c = new case();
        c.Status = 'New';
        c.AccountId = acc.Id;
        c.Priority = 'Low';
            c.Origin = 'Email';
            c.Email_Address_Submitter__c = 'l@l.com';
            c.Corporate_received_date__c = date.valueof('2018-10-11');
        sobject parId;
        sobject contId;
        
        LtngCtrlCRMCase.getInitial(acc.Id,'Case');
        LtngCtrlCRMCase.getPFINS(acc.Id);
        LtngCtrlCRMCase.savedata(c,spl,acc.Id,null,null);
        case c2 = new case();
        LtngCtrlCRMCase.getselectOptions(c2,'Origin');
        LtngCtrlCRMCase.getselectOptions(c2,'Outcome__c');
        LtngCtrlCRMCase.getselectOptions(c2,'Status');
        LtngCtrlCRMCase.getselectOptions(c2,'CRM_Types__c');
        LtngCtrlCRMCase.getselectOptions(c2,'Type');
        LtngCtrlCRMCase.getDependentMap(c2,'CRM_Types__c','Outcome__c');
        
    }
}