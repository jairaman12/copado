@istest
public class ManualOnboardingCreation_Test {

public static Id RecordTypeIdMasterCase;
public static Id RecordTypeIdPFINCase;
public static Id RecordTypeIdEntity ;
public static Id RecordTypeIdGrpPFINCase;
public static Id RecordTypeIdCred ;
public static Id RecordTypeIdGrpCred ;
public static Id RecordTypeIdContract ;
public static Id RecordTypeIdGrpContract;
public static Id RecordTypeIdManualGrpCred ;
public static Id RecordTypeIdGrpCounter ;
public static Id RecordTypeIdCounter ;
public static Id RecordTypeIdGrpNetwork ;
public static Id RecordTypeIdNetwork ;
public static Id RecordTypeIdFacility;
public static Id RecordTypeIdAncillary;
public static Id pfinRecTypeId;

    
     static void prepareData() 
     {
         TestDataFactory tdf = new TestDataFactory();
         tdf.InsertGlobalsetting();
    }
    
     static void prepareData1() {
        string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        string strGroupCredentailingRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();

        
        GlobalSettings__c gspf    =   new GlobalSettings__c();
        gspf.name                 =   'PFFileRecieved';
        gspf.PFFileRecieved__c    =   false;
        gspf.Record_Type_Names__c =   'Provider_On_boarding_Credentialing_Facility,Provider_On_boarding_Credentialing_Ancillary';
        gspf.Credentialing_record_types__c = strIndvCredRecTypeId;
       	gspf.Avoided_Case_Origins__c            =  'Web On-boarding,Manual On-boarding,Availity';
        gspf.Credentialing_record_types__c          =  '01241000001h1BpAAI,01241000001h1BqAAI,01241000001h1BhAAI,01241000001h1BlAAI';
        insert gspf;
        
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'Ancillary FacilityPage Navigation';
        gs.Enable_Ancillary_Facility__c  = False;
       	gs.Avoided_Case_Origins__c            =  'Web On-boarding,Manual On-boarding,Availity';
        gs.Credentialing_record_types__c          =  '01241000001h1BpAAI,01241000001h1BqAAI,01241000001h1BhAAI,01241000001h1BlAAI';
        insert gs;  
        
    }
    
    static void prepareData2() {
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'Ancillary FacilityPage Navigation';
        gs.Enable_Ancillary_Facility__c  = True;
        insert gs;
        
    }
    
    public static testMethod void createCustomSettingData(){
        RecordTypeIdMasterCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider On-boarding').getRecordTypeId();
        RecordTypeIdPFINCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider On-boarding Data Entry').getRecordTypeId();
        RecordTypeIdGrpPFINCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider Group Onboarding Data Entry').getRecordTypeId();
        RecordTypeIdEntity = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Provider Group Onboarding Master Entity').getRecordTypeId();
        RecordTypeIdCred = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
        RecordTypeIdGrpCred = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
        RecordTypeIdContract = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
        RecordTypeIdManualGrpCred = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Manual_Group_On_boarding_Credentialling').getRecordTypeId();
        RecordTypeIdGrpCounter = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Counter_Sign').getRecordTypeId();
        RecordTypeIdCounter = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Counter_Sign').getRecordTypeId();    
        RecordTypeIdGrpContract =   Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_Onboarding_Contracting').getRecordTypeId(); 
        RecordTypeIdGrpNetwork = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Network_Load').getRecordTypeId();
        RecordTypeIdNetwork =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Network_Load').getRecordTypeId();
        pfinRecTypeId = Schema.SobjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('PFIN_Onboarding').getRecordTypeId();
        RecordTypeIdFacility =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing_Facility').getRecordTypeId();       
        RecordTypeIdAncillary =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing_Ancillary').getRecordTypeId();       
           
        List<RecordType_settings__c> customRecordTypeList = new List<RecordType_settings__c>();
          
          RecordType_settings__c recTypeMaster = new RecordType_settings__c();
          recTypeMaster.name = 'Provider On-boarding';
          recTypeMaster.Name__c = 'Provider On-boarding';
          recTypeMaster.developerName__c = 'Provider_On_boarding';
          recTypeMaster.sObject_Type__c = 'Case';
          recTypeMaster.Record_type_Id__c = RecordTypeIdMasterCase ;
          customRecordTypeList.add(recTypeMaster );
          
          RecordType_settings__c recTypePFIN = new RecordType_settings__c();
          recTypePFIN.name = 'Provider On-boarding Data Entry';
          recTypePFIN.Name__c = 'Provider On-boarding Data Entry';
          recTypePFIN.developerName__c = 'Data_Entry_Provider_On_boarding';
          recTypePFIN.sObject_Type__c = 'Case';
          recTypePFIN.Record_type_Id__c = RecordTypeIdPFINCase ;
          customRecordTypeList.add(recTypePFIN );
          
           RecordType_settings__c recTypeGrpPFIN = new RecordType_settings__c();
          recTypeGrpPFIN.name = 'Provider Group On-boarding Data';
          recTypeGrpPFIN.Name__c = 'Provider Group On-boarding DataEntry';
          recTypeGrpPFIN.developerName__c = 'Data_Entry_Group_Provider_On_boarding';
          recTypeGrpPFIN.sObject_Type__c = 'Case';
          recTypeGrpPFIN.Record_type_Id__c = RecordTypeIdGrpPFINCase ;
          customRecordTypeList.add(recTypeGrpPFIN);
          
            RecordType_settings__c recTypeContract= new RecordType_settings__c();
          recTypeContract.name = 'Provider On-boarding Contracting';
          recTypeContract.Name__c = 'Provider On-boarding Contracting';
          recTypeContract.developerName__c = 'Contracting_Provider_On_boarding';
          recTypeContract.sObject_Type__c = 'Case';
          recTypeContract.Record_type_Id__c = RecordTypeIdContract;
          customRecordTypeList.add(recTypeContract); 
          
           RecordType_settings__c recTypeEntity = new RecordType_settings__c();
          recTypeEntity.name = 'Provider Group Onboarding Master';
          recTypeEntity.Name__c = 'Provider Group Onboarding Master Entity';
          recTypeEntity.developerName__c = 'Provider_Group_Onboarding_Master_Entity';
          recTypeEntity.sObject_Type__c = 'Case';
          recTypeEntity.Record_type_Id__c = RecordTypeIdEntity ;
          customRecordTypeList.add(recTypeEntity ); 
          
           RecordType_settings__c recTypeCred = new RecordType_settings__c();
          recTypeCred .name = 'Provider On_boarding Credentialling';
          recTypeCred .Name__c = 'Provider On_boarding Credentialing';
          recTypeCred .developerName__c = 'Provider_On_boarding_Credentialing';
          recTypeCred .sObject_Type__c = 'Case';
          recTypeCred .Record_type_Id__c = RecordTypeIdCred ;
          customRecordTypeList.add(recTypeCred );           
          
          RecordType_settings__c recTypeMGrpCred = new RecordType_settings__c();
          recTypeMGrpCred .name = 'Manual_grp_On_boarding_Credentialling';
          recTypeMGrpCred .Name__c = 'Provider Manual Group On-boarding Credentialling';
          recTypeMGrpCred .developerName__c = 'Provider_Manual_Group_On_boarding_Credentialling';
          recTypeMGrpCred .sObject_Type__c = 'Case';
          recTypeMGrpCred .Record_type_Id__c = RecordTypeIdManualGrpCred ;
          customRecordTypeList.add(recTypeMGrpCred ); 
           
          RecordType_settings__c recTypeGrpCred = new RecordType_settings__c();
          recTypeGrpCred .name = 'Provider Group On_boarding Cred';
          recTypeGrpCred .Name__c = 'Provider Group On_boarding Credentialling';
          recTypeGrpCred .developerName__c = '   Provider_Group_On_boarding_Counter_Sign';
          recTypeGrpCred .sObject_Type__c = 'Case';
          recTypeGrpCred .Record_type_Id__c = RecordTypeIdGrpCounter ;
          customRecordTypeList.add(recTypeGrpCred );
           
          RecordType_settings__c recTypeGrpCounter = new RecordType_settings__c();
          recTypeGrpCounter .name = 'Provider Group On-boarding Counter';
          recTypeGrpCounter .Name__c = 'Provider Group On-boarding Counter Sign';
          recTypeGrpCounter .developerName__c = 'Provider_Group_On_boarding_Credentialling';
          recTypeGrpCounter .sObject_Type__c = 'Case';
          recTypeGrpCounter .Record_type_Id__c = RecordTypeIdGrpCred ;
          customRecordTypeList.add(recTypeGrpCounter );  
            
           RecordType_settings__c recTypeGrpNetwork = new RecordType_settings__c();
          recTypeGrpNetwork .name = 'Provider Group On boarding Network';
          recTypeGrpNetwork .Name__c = 'Provider Group On boarding Network Load';
          recTypeGrpNetwork .developerName__c = 'Provider_Group_On_boarding_Network_Load';
          recTypeGrpNetwork .sObject_Type__c = 'Case';
          recTypeGrpNetwork .Record_type_Id__c = RecordTypeIdGrpNetwork ;
          customRecordTypeList.add(recTypeGrpNetwork ); 
          
           RecordType_settings__c recTypeNetwork = new RecordType_settings__c();
          recTypeNetwork .name = 'Network Load';
          recTypeNetwork .Name__c = 'Network Load';
          recTypeNetwork .developerName__c = 'Network_Load';
          recTypeNetwork .sObject_Type__c = 'Case';
          recTypeNetwork .Record_type_Id__c = RecordTypeIdNetwork ;
          customRecordTypeList.add(recTypeNetwork );
          
          RecordType_settings__c recTypeFacility = new RecordType_settings__c();
          recTypeFacility .name = 'Provider On-boarding Cred - Facility';
          recTypeFacility .Name__c = 'Provider On-boarding Credentialing - Facility';
          recTypeFacility .developerName__c = 'Provider_On_boarding_Credentialing_Facility';
          recTypeFacility .sObject_Type__c = 'Case';
          recTypeFacility .Record_type_Id__c = RecordTypeIdFacility ;
          customRecordTypeList.add(recTypeFacility); 
          
          RecordType_settings__c recTypeAncillary = new RecordType_settings__c();
          recTypeAncillary.name = 'Provider On-boarding Cred - Ancillary';
          recTypeAncillary.Name__c = 'Provider On-boarding Credentialing - Ancillary';
          recTypeAncillary.developerName__c = 'Provider_On_boarding_Credentialing_Ancillary';
          recTypeAncillary.sObject_Type__c = 'Case';
          recTypeAncillary.Record_type_Id__c = RecordTypeIdAncillary;
          customRecordTypeList.add(recTypeAncillary);
                
                                 
          insert customRecordTypeList;         
            
            
          string strIndvCredRecTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
          string strGroupCredentailingRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Credentialling').getRecordTypeId();
  
                              
          GlobalSettings__c gs = new GlobalSettings__c();
          gs.name = 'PFFileRecieved';
          gs.Record_Type_Names__c = 'Provider_On_boarding;Data_Entry_Provider_On_boarding;Provider_Group_Onboarding_Master_Entity;Data_Entry_Group_Provider_On_boarding;Provider_Group_On_boarding_Network_Load';
          gs.PFFileRecieved__c = true;
          gs.Credentialing_record_types__c = strIndvCredRecTypeId;
          insert gs;          
    
}
    
    
    static testmethod void providerOnboardingIndividualDataentry(){
        prepareData(); 
        prepareData1();   
        Account ac = new Account();        
        ac = TestClassData.CreatePersonAccount();      
        List<case> clist = new List<case>();           
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        newc.OnboardingGovtProgram__c =True;
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);         
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
       // ssc.setSelected(clist);     
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC1 = new ManualOnboardingCreation(sc);
        testMOC1.countOfProviderDetails = 0;
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        //ManualOnboardingCreation testMOC1 = new ManualOnboardingCreation(ssc); 
        testMOC1.countOfProviderDetails=0;
        testMOC1.selectedType = 'Provider On-boarding Data Entry';  
        testMOC1.isPersonAccount =  ac.IsPersonAccount;
        testMOC1.proceed();
        testMOC1.addrow();
       // testMOC1.removingRow();
        testMOC1.UpdateProvId();
        //testMOC1.assignPlanId();
        testMOC1.populateProvider();
        testMOC1.cancel();
        testMOC1.saveAndNew();
        testMOC1.saveRecord();
       // testMOC1.removingRow();
        testMOC1.insertMasterAndChild();
              
    }
    static testmethod void providerOnboardingIndividualContracting(){
        prepareData();  
        prepareData1();   
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount();         
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        newc.Case_Entity__c = ac.Id;
        newc.Tax_ID_Number__c ='abc123';  
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);       
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ManualOnboardingCreation testMOC2 = new ManualOnboardingCreation(ssc); 
        testMOC2.selectedType = 'Provider On-boarding Contracting';
        testMOC2.isPersonAccount =  ac.IsPersonAccount;
        testMOC2.proceed();
        testMOC2.addrow();
       //  testMOC2.addrow();
       // testMOC2.removingRow();
        testMOC2.UpdateProvId();
        //testMOC2.assignPlanId();
        testMOC2.populateProvider();
        testMOC2.cancel();
        testMOC2.saveAndNew();
        testMOC2.saveRecord();
        testMOC2.insertMasterAndChild();
              
    }
    static testmethod void providerOnboardingIndividualCredentialing(){
        prepareData();   
        prepareData1();  
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing';
        testMOC3.isPersonAccount =  ac.IsPersonAccount;
        testMOC3.proceed();
              
    }
    static testmethod void providerOnboardingIndividualCounterSign(){
        prepareData(); 
        prepareData1();    
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);
       // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc); //Modified       
        testMOC4.selectedType = 'Provider On-boarding Counter sign';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
              
    }
      static testmethod void providerOnboardingGroupDataentry(){
        prepareData();  
        prepareData1();   
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);       
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);
      //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Data Entry';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
              
    }
    static testmethod void providerOnboardingGroupContracting(){
        prepareData(); 
        prepareData1();    
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
       // ssc.setSelected(clist);
       // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Contracting';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
              
    }
    static testmethod void providerOnboardingGroupCredenting(){
        prepareData(); 
        prepareData1();    
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);
       // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Credentialing';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
              
    }
    static testmethod void providerOnboardingGroupCounterSign(){
        prepareData();  
        prepareData1();   
        Account ac = new account();
        //ac = TestClassData.CreatePersonAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        //newc = TestClassData.CreateChildCase(ac.Id);
        //newc.Case_Entity__c = '';
        //newc.accountId= '';
        newc.Billing_NPI_Number__c ='';
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
       // ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
       // ssc.setSelected(clist);
      //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Counter sign';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
        testMOC4.ValidateDuplicateCredentialingCase();
       
        
        
              
    }    
    
    static testmethod void providerOnboardingGroupCounterSign1(){
        prepareData();    
        prepareData1(); 
        Account ac = new account();
        ac = TestClassData.CreateAccount();
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
       // ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
       // ssc.setSelected(clist);
      //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Counter sign';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
        testMOC4.ValidateDuplicateCredentialingCase();        
              
    }
    
    
     static testmethod void providerOnboardingGroupCounterSign2(){
        prepareData(); 
        prepareData1(); 
        Account ac = new account();
        List<case> clist = new List<case>();        
        Case c      =   new Case();  
        c.Plan_ID__c    =   'IL1';   
        c.First_Name_Current__c     =   'Jason';
        c.Middle_Initial_Current__c =   'M';
        c.Last_Name_Current__c      =   'Sam';   
        c.Title_Current__c          =   'Mr.';
        c.Suffix_Current__c         =   '';
        c.Current_Practice_Name__c  =   'Ortho';
        insert c;
        clist.add(c);
        PageReference pageRef = Page.ManualOnboardingCreation;
        Test.setCurrentPage(pageRef);
        
       // ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
       // ssc.setSelected(clist);
      //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Counter sign';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
        testMOC4.ValidateDuplicateCredentialingCase();        
              
    }
    
    
     static testmethod void providerOnboardingGroupCounterSign3(){
        
        Account ac = new account();
        
        PageReference pageRef = Page.ManualOnboardingCreation;
        Test.setCurrentPage(pageRef);
        
       // ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
       // ssc.setSelected(clist);
      //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ManualOnboardingCreation testMOC4 = new ManualOnboardingCreation(ssc);        
        testMOC4.selectedType = 'Provider Group On-boarding Counter sign';
        testMOC4.isPersonAccount =  ac.IsPersonAccount;
        testMOC4.proceed();
        testMOC4.ValidateDuplicateCredentialingCase();        
              
    }
    
     static testmethod void providerOnboardingGroupContracting1(){
        prepareData(); 
        prepareData1();    
        Account ac = new account();
        ac = TestClassData.CreatePersonAccount(); 
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        newc.Case_Entity__c = ac.Id;
        newc.Tax_ID_Number__c ='abc123';  
        newc.Plan_ID__c ='TX1';
        newc.Billing_NPI_Number__c = '';
        newc.Tax_ID_Number__c='';        
        clist.add(newc);        
     
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);       
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ManualOnboardingCreation testMOC2 = new ManualOnboardingCreation(ssc); 
        testMOC2.selectedType = 'Provider Group On-boarding Contracting';
        testMOC2.proceed();
        testMOC2.addrow();
       //  testMOC2.addrow();
       // testMOC2.removingRow();
        testMOC2.UpdateProvId();
        //testMOC2.assignPlanId();
        testMOC2.populateProvider();
        testMOC2.cancel();
        testMOC2.saveAndNew();
        testMOC2.saveRecord();
        testMOC2.insertMasterAndChild();
              
    }
    
    static testmethod void providerOnboardingFacilityNPI(){
        prepareData(); 
        prepareData1();           
        
        Account ac = new Account();
        ac.Name = 'Test Account1'; 
        ac.Class__c ='C';
        ac.Organization_Type__c ='ANCMEDGP';
        ac.BillingStreet ='xyz';
        ac.BillingCity = 'ABC';
        ac.Prov_Id__c ='345678922';
        ac.BillingCountry = 'USA';
        ac.NPI__c='';
        ac.CM_Corporate_Entity_Code__c = 'IL1';  
        insert ac;         
        
          
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(ac.Id);
        newc.Case_Entity__c = ac.Id;
        newc.Plan_ID__c ='TX1';
        newc.Billing_NPI_Number__c = '';
        newc.Tax_ID_Number__c='';        
        clist.add(newc);        
     
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);       
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ManualOnboardingCreation testMOC2 = new ManualOnboardingCreation(ssc); 
        testMOC2.selectedType = 'Provider On-boarding Credentialing - Facility';
        testMOC2.proceed();
        testMOC2.addrow();      
        testMOC2.UpdateProvId();       
        testMOC2.populateProvider();
        testMOC2.cancel();
        testMOC2.saveAndNew();
        testMOC2.saveRecord();
        testMOC2.insertMasterAndChild();
              
    }
    
    
     static testmethod void providerOnboardingFacility(){
        prepareData();   
        prepareData1();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='F';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(acc1.Id);
        newc.Case_Entity__c = acc1.Id;
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Facility';        
        testMOC3.proceed();
              
    }
    
    static testmethod void providerOnboardingFacility1(){
        prepareData();   
        prepareData1();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='F';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.BillingCountry = 'USA';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;       
              
        
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(acc1.Id);
        newc.Case_Entity__c = acc1.Id;
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Facility';        
        testMOC3.proceed();
              
    }
    
    static testmethod void providerOnboardingFacility2(){
        prepareData();   
        prepareData2();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='F';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;
        
        CM_Provider_Tax_Id__c newTax = new CM_Provider_Tax_Id__c();
        newTax.CM_PTI_Tax_Id__c = '123456789';
        newTax.CM_Corporate_Entity_Code__c = 'IL1';
        newTax.CM_PTI_Prov_Name_From__c = acc1.Id;
        newTax.CM_PTI_Prov_Id_End_Date__c = Date.newInstance(2020, 12, 9);
        insert newTax;
        
        CM_Provider_Identification__c newNPI = new CM_Provider_Identification__c();
        newNPI.CM_Prvdr_Iden_Typ_Cd__c = 'NPI';
        newNPI.CM_Issu_Ident_Nmbr__c ='1234567890';
        newNPI.CM_Corporate_Entity_Code__c = 'IL1';
        newNPI.CM_PI_License_Status__c = 'Active';
        newNPI.CM_PI_Prov__c = acc1.Id;
        insert newNPI;
        
        
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(acc1.Id);
        newc.Case_Entity__c = acc1.Id;
        newc.Tax_ID_Number_long__c = '123456789';
        newc.Billing_NPI_Number_long__c = '1234567890';
        clist.add(newc);
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Facility';        
        testMOC3.proceed();
              
    }
    
    static testmethod void providerOnboardingAncillary1(){
        prepareData();   
        prepareData2();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='C';
        acc1.Organization_Type__c ='ANCMEDGP';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.Prov_Id__c ='345678922';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(acc1.Id);
        newc.Case_Entity__c = acc1.Id;
        clist.add(newc);
        
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2 .PFIN_onBoarding__c ='1234';
        providerNetwork2 .Prov_Id__c ='345678';
        providerNetwork2 .Panel_code__c='Accepting';
        providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        insert providerNetwork2 ;
        
        
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Ancillary';        
        testMOC3.proceed();
              
    }
    
    static testmethod void providerOnboardingAncillary2(){
        prepareData();   
        prepareData1();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='C';
        acc1.Organization_Type__c ='ANCMEDGP';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.Prov_Id__c ='345678922';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;
        
        CM_Provider_Tax_Id__c newTax = new CM_Provider_Tax_Id__c();
        newTax.CM_PTI_Tax_Id__c = '123456789';
        newTax.CM_Corporate_Entity_Code__c = 'IL1';
        newTax.CM_PTI_Prov_Name_From__c = acc1.Id;
        newTax.CM_PTI_Prov_Id_End_Date__c = Date.newInstance(2020, 12, 9);
        insert newTax;
        
        CM_Provider_Identification__c newNPI = new CM_Provider_Identification__c();
        newNPI.CM_Prvdr_Iden_Typ_Cd__c = 'NPI';
        newNPI.CM_Issu_Ident_Nmbr__c ='1234567890';
        newNPI.CM_Corporate_Entity_Code__c = 'IL1';
        newNPI.CM_PI_License_Status__c = 'Active';
        newNPI.CM_PI_Prov__c = acc1.Id;
        insert newNPI;
        
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(acc1.Id);
        newc.Case_Entity__c = acc1.Id;
        newc.Tax_ID_Number_long__c = '123456789';
        newc.Billing_NPI_Number_long__c = '1234567890';
        newc.Status = 'In progress'; 
        newc.Case_Entity__c = acc1.Id;       
        clist.add(newc);         
        
        Provider_Networks__C newNetwork1 = new Provider_Networks__c();
        newNetwork1.Credentialing_Case__c=newc.Id;
        newNetwork1.Prov_ID__c='345678922';
        newNetwork1.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        insert newNetwork1;         
        
       
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Ancillary';        
        testMOC3.proceed();
              
    }
    
    static testmethod void providerOnboardingAncillary3(){
        prepareData();   
        prepareData1();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='C';
        acc1.Organization_Type__c ='ANCMEDGP';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.Prov_Id__c ='345678922';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;
        List<case> clist = new List<case>();
        Case newc = new Case();
        newc = TestClassData.CreateChildCase(acc1.Id);
        newc.Case_Entity__c = acc1.Id;
        clist.add(newc);
        
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2.Credentialing_Case__c=newc.Id;
        providerNetwork2.Prov_Id__c ='345678';
        providerNetwork2.Panel_code__c='Accepting';
        providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        insert providerNetwork2 ;
        
        
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Ancillary';        
        testMOC3.proceed();
              
    }
    
        
    static testmethod void providerOnboardingAncillary4(){
        createCustomSettingData();
        prepareData(); 
        prepareData1();  
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.Class__c ='C';
        acc1.Organization_Type__c ='ANCMEDGP';
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.Prov_Id__c ='345678922';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;       
       
        
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Ancillary';
        masterCase.recordtypeid=RecordTypeIdMasterCase ; 
        Insert masterCase;
            
        Case pfinCase =TestCaseUtil.CreateCase();
        pfinCase.Completing_the_form_for__c='Ancillary';
        pfinCase.ParentId =masterCase.Id;
        pfinCase.Case_Entity__c = acc1.Id;
        pfinCase.recordtypeid=RecordTypeIdAncillary ;
        pfinCase.Status = 'In progress';
        Insert pfinCase;                     
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2 .Credentialing_Case__c= pfinCase.Id;
        providerNetwork2 .PFIN_onBoarding__c ='1234';
        providerNetwork2 .Prov_Id__c ='345678922';
        providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
        insert providerNetwork2 ;
       
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);               
        ApexPages.StandardController ssc = new ApexPages.StandardController(acc1);
       //  ManualOnboardingCreation mocase = new ManualOnboardingCreation(sc);
         ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC3 = new ManualOnboardingCreation(ssc);        
        testMOC3.selectedType = 'Provider On-boarding Credentialing - Ancillary';        
        testMOC3.proceed();
        
        Case masterCase1 = TestCaseUtil.CreateCase();
        masterCase1.Completing_the_form_for__c= 'Ancillary';
        masterCase1.recordtypeid=RecordTypeIdMasterCase ; 
        Insert masterCase1;
        
        Case newc1 = new Case();
        newc1 = TestClassData.CreateChildCase(acc1.Id);
        newc1.Completing_the_form_for__c='Ancillary';
        newc1.ParentId =masterCase1.Id;
        newc1.Case_Entity__c = acc1.Id;
        newc1.recordtypeid=RecordTypeIdAncillary ;
        newc1.Status = 'In progress';
        insert newc1; 
        
        Provider_Networks__C newNetwork2 = new Provider_Networks__c();
        newNetwork2.Credentialing_Case__c=newc1.Id;
        newNetwork2.Prov_ID__c='345678922';
        newNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        insert newNetwork2; 
        
        PageReference pageRef1 = Page.ManualOnboardingCreation;
        pageRef1.getParameters().put('Id', String.valueOf(acc1.Id));
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(acc1.Id));                      
        ApexPages.StandardController ssc1 = new ApexPages.StandardController(acc1);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(acc1.Id));
        ManualOnboardingCreation testMOC31 = new ManualOnboardingCreation(ssc1);        
        testMOC31.selectedType = 'Provider On-boarding Credentialing - Ancillary';        
        testMOC31.proceed(); 
              
    }
    
     static testmethod void providerOnboardingGroupContracting2(){
         
         Account ac= TestCaseUtil.createAccount();        
         
         createCustomSettingData();
         prepareData1(); 
     
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Group';
        masterCase.recordtypeid=RecordTypeIdMasterCase ; 
        Insert masterCase;
            
        Case pfinCase =TestCaseUtil.CreateCase();
        pfinCase.Completing_the_form_for__c='Group';
        pfinCase.ParentId =masterCase.Id;
        pfinCase.recordtypeid=RecordTypeIdGrpPFINCase ;
        Insert pfinCase;
               
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2 .Contracting_Case__c= pfinCase.Id;
        providerNetwork2 .PFIN_onBoarding__c ='1234';
        providerNetwork2 .Prov_Id__c ='345678922';
        providerNetwork2 .Panel_code__c='Accepting';
        providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
        providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
        insert providerNetwork2 ;
    
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));        
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        ManualOnboardingCreation testMOC2 = new ManualOnboardingCreation(ssc); 
        testMOC2.selectedType = 'Provider Group On-boarding Contracting';
        testMOC2.proceed();
        testMOC2.addrow();
        testMOC2.UpdateProvId();
        testMOC2.populateProvider();
        testMOC2.cancel();        
        testMOC2.saveAndNew();
        testMOC2.saveRecord();
        testMOC2.insertMasterAndChild();
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv; 
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        try{
            delete documents;
        }
        Catch(Exception e){}
    }static testmethod void coverContentDocumentTriggerHandler(){
         
         Account ac= TestCaseUtil.createAccount();        
         
         createCustomSettingData();
     
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Group';
        masterCase.recordtypeid=RecordTypeIdMasterCase ; 
        Insert masterCase;
            
        Case pfinCase =TestCaseUtil.CreateCase();
        pfinCase.Completing_the_form_for__c='Group';
        pfinCase.ParentId =masterCase.Id;
        pfinCase.recordtypeid=RecordTypeIdGrpPFINCase ;
        Insert pfinCase;
               
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2 .Contracting_Case__c= pfinCase.Id;
        providerNetwork2 .PFIN_onBoarding__c ='1234';
        providerNetwork2 .Prov_Id__c ='345678922';
        providerNetwork2 .Panel_code__c='Accepting';
        providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
        providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
        insert providerNetwork2 ;
    
        PageReference pageRef = Page.ManualOnboardingCreation;
        pageRef.getParameters().put('Id', String.valueOf(ac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(ac.Id));
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(clist);
        //ssc.setSelected(clist);       
        ApexPages.StandardController ssc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(ac.Id));
        // ManualOnboardingCreation mocase = new ManualOnboardingCreation(ssc);
        ManualOnboardingCreation testMOC2 = new ManualOnboardingCreation(ssc); 
        testMOC2.selectedType = 'Provider Group On-boarding Contracting';
        testMOC2.proceed();
        testMOC2.addrow();
       //  testMOC2.addrow();
       // testMOC2.removingRow();
        testMOC2.UpdateProvId();
        //testMOC2.assignPlanId();
        testMOC2.populateProvider();
        //testMOC2.cancel();
        testMOC2.saveAndNew();
        testMOC2.saveRecord();
        testMOC2.insertMasterAndChild();
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv; 
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        try{
            delete documents;
        }
        Catch(Exception e){}
    }
    
    /*public static testmethod void coverPaperCredLogicIndividualOnboarding(){
        TestDataFactory tdf = new TestDataFactory();
         tdf.InsertGlobalsetting();
        createCustomSettingData(); 
        Account ac= TestCaseUtil.createAccount();        
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Individual';
        masterCase.recordtypeid= RecordTypeIdMasterCase ; 
        Insert masterCase;
            
        Case pfinCase =TestCaseUtil.CreateCase();
        pfinCase.Completing_the_form_for__c='Individual';
        pfinCase.ParentId =masterCase.Id;
        pfinCase.recordtypeid=RecordTypeIdPFINCase;
        Insert pfinCase;               
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2 .Contracting_Case__c= pfinCase.Id;
        providerNetwork2 .PFIN_onBoarding__c ='1234';
        providerNetwork2 .Prov_Id__c ='345678922';
        //providerNetwork2 .Panel_code__c='Accepting';
        //providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        //providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
        //providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
        insert providerNetwork2 ;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv; 
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink newConDoc = new ContentDocumentLink();
        newConDoc.ContentDocumentId = documents[0].Id;
        newConDoc.LinkedEntityId = pfinCase.Id;
        newConDoc.ShareType = 'I'; 
        insert newConDoc;
        
        pfinCase.Paper_Cred_indicator__c = true;
        pfinCase.status ='Closed Processed';
        update pfinCase;
        
        Case contractingCase = [SELECT Id, status FROM Case WHERE parentId =: masterCase.Id AND recordtypeId =: RecordTypeIdContract];
        contractingCase.status = 'Needs Credentialing';
        update contractingCase;
    }*/
    
    
    public static testmethod void coverPaperCredLogicGroupOnboarding(){         
        
        createCustomSettingData();

        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1',Prov_Id__c ='1234555',
                                   recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity Account').getRecordTypeId());       
     
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Group';
        masterCase.recordtypeid= RecordTypeIdMasterCase ; 
        masterCase.case_entity__c = acct.Id;
        Insert masterCase;
            
        Case pfinCase =TestCaseUtil.CreateCase();
        pfinCase.Completing_the_form_for__c='Group';
        pfinCase.ParentId =masterCase.Id;
        pfinCase.recordtypeid=RecordTypeIdGrpContract;
        pfinCase.case_entity__c = acct.Id;
        Insert pfinCase;               
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2 .PFIN_Case__c = pfinCase.Id;
        providerNetwork2 .PFIN_onBoarding__c ='1234';
        providerNetwork2 .Prov_Id__c ='1234555';
        providerNetwork2 .Panel_code__c='Accepting';
        providerNetwork2.Network_Name__c ='BAV - Blue Advantage HMO,DEB - DNOA';
        //providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
        providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Contracting Onboarding').getRecordTypeId();
        insert providerNetwork2 ;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv; 
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink newConDoc = new ContentDocumentLink();
        newConDoc.ContentDocumentId = documents[0].Id;
        newConDoc.LinkedEntityId = providerNetwork2.Id;
        newConDoc.ShareType = 'I'; 
        insert newConDoc;
        
    }
    
    public static testmethod void coverCRMCredentialingCase(){
         
        Account ac= TestCaseUtil.createAccount();        
         
        createCustomSettingData();
     
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Individual';
        masterCase.recordtypeid= RecordTypeIdMasterCase ; 
        Insert masterCase;
            
        Case credCase = TestCaseUtil.CreateCase();
        credCase.Completing_the_form_for__c= 'Individual';
        credCase.ParentId = masterCase.Id;
        credCase.recordtypeid = RecordTypeIdCred;
        Insert credCase; 
        
        
        Case credCase2 = TestCaseUtil.CreateCase();
        credCase2.Completing_the_form_for__c= 'Individual';
        credCase2.ParentId = masterCase.Id;
        credCase2.recordtypeid = RecordTypeIdCred;
        Insert credCase2;              
        
        Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
        providerNetwork2.Credentialing_Case__c = credCase.Id;
        providerNetwork2.PFIN_onBoarding__c ='1234';
        providerNetwork2.Prov_Id__c = '345678922';
        insert providerNetwork2 ;
        
        Case newCRMcase = new Case();
        newCRMCase.credentialing_Case_Number__c = credCase.Id;
        newCRMcase.parentId = credCase.Id;
        newCRMCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM').getRecordTypeId();
        newCRMCase.origin ='Fax';
        newCRMCase.Plan_Id__c ='IL1';
        newCRMCase.corporate_received_date__c = system.today();
        insert newCRMcase;
        
        newCRMCase.credentialing_Case_Number__c = credCase2.Id;
        update newCRMCase;
    }
    
    public static testmethod void validatePaperCred(){
         
        Account ac= TestCaseUtil.createAccount();        
         
        createCustomSettingData();
     
        Case masterCase = TestCaseUtil.CreateCase();
        masterCase.Completing_the_form_for__c= 'Individual';
        masterCase.recordtypeid= RecordTypeIdMasterCase ; 
        Insert masterCase;
            
        Case pfinCase =TestCaseUtil.CreateCase();
        pfinCase.Completing_the_form_for__c='Individual';
        pfinCase.ParentId =masterCase.Id;
        pfinCase.recordtypeid=RecordTypeIdPFINCase;
        Insert pfinCase;    
        
        Test.startTest();
        pfinCase.paper_cred_indicator__c = true;
        update pfinCase;
        Test.stopTest();
     }
 }