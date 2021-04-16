@isTest
public class ManualCCreationControllerSupoort_test {    
   
    static void prepareData() {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
    }
    
    Static testMethod void TestingMCC(){    
        prepareData();
        RecordType netwrkChgRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_NWK_CHG];
        String CaseMode ='Add';
        List<Case> ntwlist = new List<Case>();
        Case networkChg = new Case();
        networkChg.Status ='New';
        networkChg.Priority ='Medium';
        networkChg.Plan_ID__c ='IL1';
        networkChg.Govt_Programs__c = true;
        networkChg.Completing_the_form_for__c ='Group';   
        networkChg.Name_Submitter__c ='testing';
        networkChg.Title_Submitter__c ='te';
        networkChg.Telephone_Number_Submitter__c ='2136547899';
        networkChg.Email_Address_Submitter__c ='test@hy.com';   
        networkChg.Tax_ID_Number__c='1236547893';   
        networkChg.Billing_NPI_Number__c ='1236547896';
        networkChg.Bill_NPI_Type__c ='Type 2 (Group)';
        networkChg.Original_Creation_Date__c=System.now(); 
        networkChg.Email_Address_Submitter__c ='ASGDH@ASGDJ.COM';
        networkChg.RecordTypeId = netwrkChgRecType.Id;
        
        ntwlist.add(networkChg);
        insert ntwlist;
        NetworkJsonSupportCls nw = new NetworkJsonSupportCls();
        List<NetworkJsonSupportCls.NetworkGroups> ngList = new List<NetworkJsonSupportCls.NetworkGroups>();
        List<NetworkJsonSupportCls.SelectedNetworks> snList = new List<NetworkJsonSupportCls.SelectedNetworks>();
        List<NetworkJsonSupportCls.Designationcode> dcList = new List<NetworkJsonSupportCls.Designationcode>();
        nw.networkGroups= new List<NetworkJsonSupportCls.NetworkGroups>();
        NetworkJsonSupportCls.Designationcode newde  = new NetworkJsonSupportCls.Designationcode();
        newde.code = '123';
        newde.effectivedate = '10/12/2018';
        newde.enddate = '10/12/2019'; 
        dcList.add(newde);
        NetworkJsonSupportCls.Designationcode comCode  = new NetworkJsonSupportCls.Designationcode();
        comCode.code = '123';
        comCode.effectivedate = '10/12/2018';
        comCode.enddate = '10/12/2019'; 
        dcList.add(comCode);
        NetworkJsonSupportCls.SelectedNetworks newsn = new NetworkJsonSupportCls.SelectedNetworks();
        newsn.networkName = 'NetworkName';
        newsn.panel = 'paneltest';
        newsn.role = 'role test';
        newsn.designationcode = dcList;
        newsn.compgridcode = dcList;
        snList.add(newsn);        
        NetworkJsonSupportCls.NetworkGroups newnw= new NetworkJsonSupportCls.NetworkGroups();
        newnw.comments = 'Testing';
        newnw.effectiveDate = '10/12/2018';    
        newnw.selectedNetworks = snList ;
		nw.networkGroups.add(newnw);       
        String hiddenJson = Json.serialize(nw);
        ManualCaseCreationControllerSupoortCls.createNetworkRecords(ntwlist,hiddenJson,CaseMode);

    }
    Static testMethod void TestingMCCWithNegative(){    
        prepareData();
        RecordType netwrkChgRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_NWK_CHG];
        String CaseMode ='Add';
        List<Case> ntwlist = new List<Case>();
        Case networkChg = new Case();
        networkChg.Status ='New';
        networkChg.Priority ='Medium';
        networkChg.Plan_ID__c ='IL1';
        networkChg.Govt_Programs__c = true;
        networkChg.Completing_the_form_for__c ='Group';   
        networkChg.Name_Submitter__c ='testing';
        networkChg.Title_Submitter__c ='te';
        networkChg.Telephone_Number_Submitter__c ='2136547899';
        networkChg.Email_Address_Submitter__c ='test@hy.com';   
        networkChg.Tax_ID_Number__c='1236547893';   
        networkChg.Billing_NPI_Number__c ='1236547896';
        networkChg.Bill_NPI_Type__c ='Type 2 (Group)';
        networkChg.Original_Creation_Date__c=System.now(); 
        networkChg.Email_Address_Submitter__c ='ASGDH@ASGDJ.COM';
        networkChg.RecordTypeId = netwrkChgRecType.Id;
        
        ntwlist.add(networkChg);
        insert ntwlist;
        String CaseModevalue ='Delete';
        List<Case> ntwlist2 = new List<Case>();
        ntwlist2.add(networkChg);
        NetworkJsonSupportCls nw = new NetworkJsonSupportCls();
        List<NetworkJsonSupportCls.NetworkGroups> ngList = new List<NetworkJsonSupportCls.NetworkGroups>();
        List<NetworkJsonSupportCls.SelectedNetworks> snList = new List<NetworkJsonSupportCls.SelectedNetworks>();
        List<NetworkJsonSupportCls.Designationcode> dcList = new List<NetworkJsonSupportCls.Designationcode>();
        nw.networkGroups= new List<NetworkJsonSupportCls.NetworkGroups>();
        NetworkJsonSupportCls.Designationcode newde  = new NetworkJsonSupportCls.Designationcode();
        newde.code = '123';
        newde.effectivedate = '10/12/2018';
        newde.enddate = '10/12/2019';
        dcList.add(newde);
        NetworkJsonSupportCls.Designationcode comCode  = new NetworkJsonSupportCls.Designationcode();
        comCode.code = '123';
        comCode.effectivedate = '10/12/2018';
        comCode.enddate = '10/25/2019'; 
        dcList.add(comCode);
        NetworkJsonSupportCls.Designationcode comCode1  = new NetworkJsonSupportCls.Designationcode();
        comCode.code = '';
        comCode.effectivedate = '10/12/2018';
        comCode.enddate = ''; 
        dcList.add(comCode1);
        NetworkJsonSupportCls.Designationcode comCode2  = new NetworkJsonSupportCls.Designationcode();
        comCode.code = '';
        comCode.effectivedate = '';
        comCode.enddate = '10/25/2019'; 
        dcList.add(comCode2);
        NetworkJsonSupportCls.SelectedNetworks newsn = new NetworkJsonSupportCls.SelectedNetworks();
        newsn.networkName = 'NetworkName';
        newsn.panel = 'paneltest';
        newsn.role = 'role test';
        newsn.designationcode = dcList;
        newsn.compgridcode = dcList;
        snList.add(newsn);        
        NetworkJsonSupportCls.NetworkGroups newnw= new NetworkJsonSupportCls.NetworkGroups();
        newnw.comments = 'Testing';
        newnw.effectiveDate = '10/12/2018';    
        newnw.selectedNetworks = snList ;
		nw.networkGroups.add(newnw);  
        ngList.add(newnw);
        String hiddenJson = Json.serialize(nw);
        Integer networkCodeCount  = 0;
        ManualCaseCreationControllerSupoortCls.createNetworkRecords(ntwlist,hiddenJson,CaseMode);
		//ManualCaseCreationControllerSupoortCls.createNetworkRecords(ntwlist,hiddenJson,CaseModevalue);
        DeleteModeNetworkJsonSupportCls deleteNetwrks = new DeleteModeNetworkJsonSupportCls();
        List<DeleteModeNetworkJsonSupportCls.NetworkGroups> dnetwrks = new List<DeleteModeNetworkJsonSupportCls.NetworkGroups>();
        List<String> selectntw = new List<String>();
        String snetworks = 'selectnetwrks1';
        selectntw.add(snetworks);
        String snetwrks2 = 'selectnetwrks2';
        selectntw.add(snetwrks2);
        DeleteModeNetworkJsonSupportCls.NetworkGroups dnRecord = new DeleteModeNetworkJsonSupportCls.NetworkGroups();
        dnRecord.comments = 'testing';
        dnRecord.effectiveDate = '10/20/2018';
        dnRecord.nwReason = 'Reason';
        dnRecord.selectedNetworks = selectntw;
        dnetwrks.add(dnRecord);
        String hiddenJsondelete = Json.serialize(dnetwrks);
        //deleteNetwrks.add(dnetwrks);        
        //DeleteModeNetworkJsonSupportCls deleteNtwrks = DeleteModeNetworkJsonSupportCls.parse(hiddenJsondelete);
    } 
    
     Static testMethod void TestingMCCDeleteMode(){    
        prepareData();
        RecordType netwrkChgRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_NWK_CHG];
        String CaseMode ='Delete';
        List<Case> ntwlist = new List<Case>();
        Case networkChg = new Case();
        networkChg.Status ='New';
        networkChg.Priority ='Medium';
        networkChg.Plan_ID__c ='IL1';
        networkChg.Govt_Programs__c = true;
        networkChg.Completing_the_form_for__c ='Group';   
        networkChg.Name_Submitter__c ='testing';
        networkChg.Title_Submitter__c ='te';
        networkChg.Telephone_Number_Submitter__c ='2136547899';
        networkChg.Email_Address_Submitter__c ='test@hy.com';   
        networkChg.Tax_ID_Number__c='1236547893';   
        networkChg.Billing_NPI_Number__c ='1236547896';
        networkChg.Bill_NPI_Type__c ='Type 2 (Group)';
        networkChg.Original_Creation_Date__c=System.now(); 
        networkChg.Email_Address_Submitter__c ='ASGDH@ASGDJ.COM';
        networkChg.RecordTypeId = netwrkChgRecType.Id;
        
        ntwlist.add(networkChg);
        insert ntwlist;
         
        DeleteModeNetworkJsonSupportCls dnw = new DeleteModeNetworkJsonSupportCls();
        List<DeleteModeNetworkJsonSupportCls.NetworkGroups> ngList = new List<DeleteModeNetworkJsonSupportCls.NetworkGroups>();
        dnw.networkGroups= new List<DeleteModeNetworkJsonSupportCls.NetworkGroups>();
         List<String> strList = new List<String>{'Test 1','Test 2'}; 
        DeleteModeNetworkJsonSupportCls.NetworkGroups newnw= new DeleteModeNetworkJsonSupportCls.NetworkGroups();
        newnw.comments = 'Testing';
        newnw.nwReason	=	'reason 11';
        newnw.effectiveDate = '10/20/2018';            
        newnw.selectedNetworks = strList ;
        System.debug('newnw######===>>>'+newnw);
		dnw.networkGroups.add(newnw);       
        String hiddenJson = Json.serialize(dnw);
        ManualCaseCreationControllerSupoortCls.createNetworkRecords(ntwlist,hiddenJson,CaseMode);

    }    
}