/**
* 
* @Author Provider Intake Team
* @Description - Test Class for ContractingDetailsEditPageLigh.
* @Date 04/12/2019
* */
@isTest
public class TestContractingDetailsEditPageLigh{
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

public static Id pfinRecTypeId;
public static Id contractRecTypeId;
public static Id counterRecTypeId;
public static Id entityRecTypeId;
public static Id credRecTypeId;
public static Id networkRecTypeId;

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
    contractRecTypeId= Schema.SobjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Contracting_Onboarding').getRecordTypeId();
    credRecTypeId= Schema.SobjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Credentialing').getRecordTypeId();
    counterRecTypeId= Schema.SobjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('CounterSign').getRecordTypeId();
    entityRecTypeId= Schema.SobjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Master_Entity').getRecordTypeId();
    networkRecTypeId = Schema.SobjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('Network').getRecordTypeId();

    
        List<RecordType_settings__c> customRecordTypeList = new List<RecordType_settings__c>();
        
          RecordType_settings__c recTypeproviderPFIN = new RecordType_settings__c();        
          recTypeproviderPFIN.name = 'PFIN Onboarding';     
          recTypeproviderPFIN.Name__c = 'PFIN Onboarding';      
          recTypeproviderPFIN.developerName__c = 'PFIN_Onboarding';     
          recTypeproviderPFIN.sObject_Type__c = 'Provider_Networks__c';     
          recTypeproviderPFIN.Record_type_Id__c = pfinRecTypeId;       
          customRecordTypeList.add(recTypeproviderPFIN );       
            
          RecordType_settings__c recTypeprovidercontract = new RecordType_settings__c();     
          recTypeprovidercontract.name = 'Contracting Onboarding';       
          recTypeprovidercontract.Name__c = 'Contracting Onboarding';        
          recTypeprovidercontract.developerName__c = 'Contracting_Onboarding';       
          recTypeprovidercontract.sObject_Type__c = 'Provider_Networks__c';     
          recTypeprovidercontract.Record_type_Id__c = contractRecTypeId;       
          customRecordTypeList.add(recTypeprovidercontract);
          
          
           RecordType_settings__c recTypeprovidercred = new RecordType_settings__c();     
          recTypeprovidercred.name = 'Credentialing';       
          recTypeprovidercred.Name__c = 'Credentialing';        
          recTypeprovidercred.developerName__c = 'Credentialing';       
          recTypeprovidercred.sObject_Type__c = 'Provider_Networks__c';     
          recTypeprovidercred.Record_type_Id__c = credRecTypeId;       
          customRecordTypeList.add(recTypeprovidercred);
          
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
                                 
           insert customRecordTypeList;         
                              
          GlobalSettings__c gs = new GlobalSettings__c();
          gs.name = 'PFFileRecieved';
          gs.Record_Type_Names__c = 'Provider_On_boarding;Data_Entry_Provider_On_boarding;Provider_Group_Onboarding_Master_Entity;Data_Entry_Group_Provider_On_boarding;Provider_Group_On_boarding_Network_Load';
          gs.PFFileRecieved__c = true;
          insert gs;          
    
}
public static testMethod void insertPFINCase(){
    createCustomSettingData();
     list<Provider_Networks__c > lstproviderNetwork  = new list<Provider_Networks__c >();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
        
    Case pfinCase =TestCaseUtil.CreateCase();
    pfinCase.Completing_the_form_for__c='Individual';
    pfinCase.ParentId =masterCase.Id;
    pfinCase.recordtypeid=RecordTypeIdPFINCase;
    Insert pfinCase; 
     
    Provider_Networks__c providerNetwork = new Provider_Networks__c();
    providerNetwork .PFIN_Case__c = pfinCase.Id;
    providerNetwork .PFIN_onBoarding__c ='1234';
    providerNetwork .Prov_Id__c ='1234';
    providerNetwork.RecordTypeId = pfinRecTypeId;
    //lstproviderNetwork.add(providerNetwork  );
    insert providerNetwork  ;  
       
       
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
     Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('pfincase', String.valueOf(pfinCase.Id));
    pageRef.getParameters().put('id', String.valueOf(pfinCase.Id));
    pageRef.getParameters().put('fromPFIN', 'true');
    idValue = ApexPages.currentPage().getParameters().get('Id');    
    pageRef.getParameters().put('planId', String.valueOf(pfinCase.Plan_ID__c));       
    ApexPages.currentPage().getParameters().put('id', providerNetwork .Id);*/
  
   pageRef.getParameters().put('id',String.valueOf(providerNetwork.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
      
    
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
    
} 

public static testMethod void insertGrpPFINCase(){

    createCustomSettingData();
     Test.startTest();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
        
    Case pfinCase =TestCaseUtil.CreateCase();
    pfinCase.Completing_the_form_for__c='Group';
    pfinCase.ParentId =masterCase.Id;
    pfinCase.recordtypeid=RecordTypeIdGrpPFINCase ;
    Insert pfinCase;
    
    Provider_Networks__c providerNetwork = new Provider_Networks__c();
    providerNetwork .PFIN_Case__c = pfinCase.Id;
    providerNetwork .PFIN_onBoarding__c ='1234';
    providerNetwork .Prov_Id__c ='1234';
    providerNetwork.RecordTypeId = pfinRecTypeId;
    insert providerNetwork ;
    
    
    PageReference pageRef = Page.ContractingProviderDetail;      
    Test.setCurrentPageReference(pageRef);
    
  /*  pageRef.getParameters().put('fromPFIN', 'true');
    pageRef.getParameters().put('id', String.valueOf(pfinCase.Id));
    pageRef.getParameters().put('planId', String.valueOf(pfinCase.Plan_ID__c));      
    ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Provider_networks__c>{providerNetwork}); 
            pageRef.getParameters().put('provId', String.valueOf(providerNetwork.Id));*/
    //    pageRef.getParameters().put('Id', String.valueOf(providerNetwork.Id));
   // pageRef.getParameters().put('idValue', String.valueOf(providerNetwork.Id));
    pageRef.getParameters().put('id',String.valueOf(providerNetwork.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);              
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
    Test.stopTest();
    
}

public static testMethod void insertPFINCase_provId(){
    createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
        
    Case pfinCase =TestCaseUtil.CreateCase();
    pfinCase.Completing_the_form_for__c='Individual';
    pfinCase.ParentId =masterCase.Id;
    pfinCase.recordtypeid=RecordTypeIdPFINCase;
    Insert pfinCase; 
     
    Provider_Networks__c providerNetwork = new Provider_Networks__c();
    providerNetwork .PFIN_Case__c = pfinCase.Id;
    providerNetwork .PFIN_onBoarding__c ='1234';
    providerNetwork .Prov_Id__c ='1234';
    insert providerNetwork ;  
      
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
    /*pageRef.getParameters().put('id', String.valueOf(pfinCase.Id));
    pageRef.getParameters().put('fromPFIN', 'true');
    pageRef.getParameters().put('planId', String.valueOf(pfinCase.Plan_ID__c));       
     pageRef.getParameters().put('Id', String.valueOf(providerNetwork.Id));*/
      pageRef.getParameters().put('id',String.valueOf(providerNetwork.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);  
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
    
} 

    public static testMethod void insertPFINCase_Validate(){
    createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
        
    Case pfinCase =TestCaseUtil.CreateCase();
    pfinCase.Completing_the_form_for__c='Individual';
    pfinCase.ParentId =masterCase.Id;
    pfinCase.recordtypeid=RecordTypeIdPFINCase;
    Insert pfinCase; 
     
    Provider_Networks__c providerNetwork = new Provider_Networks__c();
    providerNetwork .PFIN_Case__c = pfinCase.Id;
    providerNetwork .PFIN_onBoarding__c ='1234ASDFGH@#';
    providerNetwork .Prov_Id__c ='1234QWERTY#';
    providerNetwork.Network_Code_Name__c = '786UNDTI;ENWUFEFYE;E8769876N';
    insert providerNetwork ;  
      
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
    /*pageRef.getParameters().put('id', String.valueOf(pfinCase.Id));
    pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(pfinCase.Plan_ID__c));       
     pageRef.getParameters().put('Id', String.valueOf(providerNetwork.Id));*/
      pageRef.getParameters().put('id',String.valueOf(providerNetwork.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc); 
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
    
} 
public static testMethod void insertGrpPFINCase_provId(){

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
    
    Provider_Networks__c providerNetwork = new Provider_Networks__c();
    providerNetwork .PFIN_Case__c = pfinCase.Id;
    providerNetwork .PFIN_onBoarding__c ='1234';
    providerNetwork .Prov_Id__c ='1234';
    insert providerNetwork ;    
      ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork); 
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
  /*   pageRef.getParameters().put('fromPFIN', 'true');
    pageRef.getParameters().put('pfincase', String.valueOf(pfinCase.Id));
   
    pageRef.getParameters().put('planId', String.valueOf(pfinCase.Plan_ID__c)); */   
    pageRef.getParameters().put('Id', String.valueOf(providerNetwork.Id));
    ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);  
    objProviderDetailExt.providerId =  providerNetwork.Id;  
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
    
}

/*public static testMethod void insertEntityCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;       
    
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Individual';
    contractCase .ParentId =masterCase.Id;
    contractCase .recordtypeid=RecordTypeIdContract;
    Insert contractCase ;   
    
     Case entityCase =TestCaseUtil.CreateCase();
    entityCase .Completing_the_form_for__c='Group';
    entityCase .ParentId =masterCase.Id;
    entityCase .recordtypeid=RecordTypeIdEntity ;
    Insert entityCase ;   
       
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase .Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
    insert providerNetwork2 ;
    
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   // PageRef.getParameters().put('fromPFIN', 'false');
   
   // pageRef.getParameters().put('planId', String.valueOf(entityCase.Plan_ID__c));
   // pageRef.getParameters().put('masterEntityCase', String.valueOf(entityCase.Id));       
   //  pageRef.getParameters().put('id',String.valueOf(providerNetwork.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc); 
      objProviderDetailExt.masterEntity  = true;
           
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}*/
public static testMethod void insertEntityCase_provId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;  
    
    
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Individual';
    contractCase .ParentId =masterCase.Id;
    contractCase .recordtypeid=RecordTypeIdContract;
    Insert contractCase ;      
    
     Case entityCase =TestCaseUtil.CreateCase();
    entityCase .Completing_the_form_for__c='Group';
    entityCase .ParentId =masterCase.Id;
    entityCase .recordtypeid=RecordTypeIdEntity ;
    Insert entityCase ;   
       
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase .Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Master Entity').getRecordTypeId();
    insert providerNetwork2 ;
    
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
    /*PageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(entityCase.Plan_ID__c));
    pageRef.getParameters().put('masterEntityCase', String.valueOf(entityCase.Id));    
    pageRef.getParameters().put('id', String.valueOf(entityCase.Id));*/   
    ApexPAges.StandardController  sc = new ApexPages.StandardController(providerNetwork2);
    // pageRef.getParameters().put('provId', String.valueOf(providerNetwork2.Id)); 
    ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc); 
   
    
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}
public static testMethod void insertIndCredCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;       
             
     Case credCase =TestCaseUtil.CreateCase();
    credCase .Completing_the_form_for__c='Individual';
    credCase .ParentId =masterCase.Id;
    credCase .recordtypeid=RecordTypeIdCred ;
    Insert credCase ;      
       
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Credentialing_Case__c = credCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    //providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    ProviderNetwork2.Network_Code_Name__c = 'SDF43R;4F4TR44FWEF;FR4T4T';
     providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Credentialing').getRecordTypeId();
    insert providerNetwork2 ;   
       
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);   
    /*PageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(credCase.Plan_ID__c));
    pageRef.getParameters().put('credentialingCase', String.valueOf(credCase.Id));*/
      pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);    
    objProviderDetailExt.providerId =  providerNetwork2.Id; 
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}
public static testMethod void insertGrpCredCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
        
     Case credCase =TestCaseUtil.CreateCase();
    credCase .Completing_the_form_for__c='Group';
    credCase .ParentId =masterCase.Id;
    credCase .recordtypeid=RecordTypeIdGrpCred ;
    Insert credCase ;
    
    Provider_Networks__c providerNetwork3 = new Provider_Networks__c();
    providerNetwork3 .Credentialing_Case__c = credCase.Id;
    providerNetwork3 .PFIN_onBoarding__c ='1234';
    providerNetwork3 .Prov_Id__c ='1234';
    providerNetwork3 .Panel_code__c='Accepting';
   // providerNetwork3 .Cred_Status__c ='No Credentialing Needed';
     providerNetwork3.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Credentialing').getRecordTypeId();
    insert providerNetwork3;    
     
     PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(credCase.Plan_ID__c));
    pageRef.getParameters().put('credentialingCase', String.valueOf(credCase.Id)); */
     pageRef.getParameters().put('id',String.valueOf(providerNetwork3.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork3); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);    
    objProviderDetailExt.providerId =  providerNetwork3.Id; 
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}
public static testMethod void insertIndCredCase_provId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;       
             
     Case credCase =TestCaseUtil.CreateCase();
    credCase .Completing_the_form_for__c='Individual';
    credCase .ParentId =masterCase.Id;
    credCase.Source__c = 'Provider On-boarding Credentialing';
    credCase .recordtypeid=RecordTypeIdCred ;
    Insert credCase ;      
       
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Credentialing_Case__c = credCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
   // providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Credentialing').getRecordTypeId();
    insert providerNetwork2 ;    
       
   //  ApexPAges.StandardSetController  sc = new ApexPages.StandardSetController(new LIST<Case>{credCase});
     PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);   
      /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(credCase.Plan_ID__c));
    pageRef.getParameters().put('credentialingCase', String.valueOf(credCase.Id)); 
    pageRef.getParameters().put('id', String.valueOf(credCase.Id));
    pageRef.getParameters().put('provId', String.valueOf(providerNetwork2.Id));*/
      pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
    
    objProviderDetailExt.providerId =  providerNetwork2.Id; 
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}
public static testMethod void insertGrpCredCase_provId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;       
       
    Case credCase =TestCaseUtil.CreateCase();
    credCase .Completing_the_form_for__c='Group';
    credCase .ParentId =masterCase.Id;
    credCase.Source__c = 'Provider Group On-boarding Credentialing';
    credCase .recordtypeid=RecordTypeIdGrpCred ;
    Insert credCase ;    
      
            
    Provider_Networks__c providerNetwork3 = new Provider_Networks__c();
    providerNetwork3 .Credentialing_Case__c = credCase.Id;
    providerNetwork3 .PFIN_onBoarding__c ='1234';
    providerNetwork3 .Prov_Id__c ='1234';
    providerNetwork3 .Panel_code__c='Accepting';
   // providerNetwork3 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork3.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Credentialing').getRecordTypeId();
    insert providerNetwork3;
    
    // ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Case>{credCase});
     PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(credCase.Plan_ID__c));
    pageRef.getParameters().put('credentialingCase', String.valueOf(credCase.Id)); 
    pageRef.getParameters().put('id', String.valueOf(credCase.Id));
    pageRef.getParameters().put('provId', String.valueOf(providerNetwork3.Id));*/
     pageRef.getParameters().put('id',String.valueOf(providerNetwork3.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork3); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
    objProviderDetailExt.providerId =  providerNetwork3.Id; 
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}

public static testMethod void insertIndCounterCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.Out_of_Network__c =false;
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 

    Insert masterCase;
    
    Case counterCase =TestCaseUtil.CreateCase();
    counterCase .Completing_the_form_for__c='Individual';
    counterCase .ParentId =masterCase.Id;
    counterCase .recordtypeid=RecordTypeIdcounter ;
    Insert counterCase ;
     Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .counterSign__c= counterCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    ProviderNetwork2.Network_Code_Name__c = 'SDF43R;4F4TR44FWEF;FR4T4T';
    insert providerNetwork2 ;
    
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(counterCase.Plan_ID__c));
    pageRef.getParameters().put('counterSignCase', String.valueOf(counterCase.Id)); 
    pageRef.getParameters().put('id', String.valueOf(counterCase.Id));
    pageRef.getParameters().put('id',String.valueOf(providerNetwork.Id));*/
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);       
     objProviderDetailExt.providerId =  providerNetwork2.Id; 
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
}
public static testMethod void insertGrpCounterCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
    
    Case counterCase =TestCaseUtil.CreateCase();
    counterCase .Completing_the_form_for__c='Group';
    counterCase .ParentId =masterCase.Id;
    counterCase .recordtypeid=RecordTypeIdGrpCounter ;
    Insert counterCase ;
    
     Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .counterSign__c= counterCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    insert providerNetwork2 ;
    
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(counterCase.Plan_ID__c));
    pageRef.getParameters().put('counterSignCase', String.valueOf(counterCase.Id));*/ 
   pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);   
    objProviderDetailExt.providerId =  providerNetwork2.Id;     
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
}
public static testMethod void insertIndCounterCase_ProvId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ;
    Insert masterCase;
    
    Case counterCase =TestCaseUtil.CreateCase();
    counterCase .Completing_the_form_for__c='Individual';
    counterCase .ParentId =masterCase.Id;
    counterCase .recordtypeid=RecordTypeIdcounter ;
    counterCase.Source__c = 'Provider On-boarding Counter Sign';
    Insert counterCase ;
     Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .counterSign__c= counterCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    ProviderNetwork2.Network_Code_Name__c = 'SDF43R;4F4TR44FWEF;FR4T4T';
    providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('CounterSign').getRecordTypeId();
    insert providerNetwork2 ;
    
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(counterCase.Plan_ID__c));
    pageRef.getParameters().put('counterSignCase', String.valueOf(counterCase.Id)); 
    ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Provider_networks__c>{providerNetwork2});
     pageRef.getParameters().put('provId', String.valueOf(providerNetwork2.Id)); */ 
     pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
}
public static testMethod void insertGrpCounterCase_provId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;
    
    Case counterCase =New case();
    counterCase .Completing_the_form_for__c='Group';
    counterCase .ParentId =masterCase.Id;
    counterCase .recordtypeid=RecordTypeIdGrpCounter ;
    counterCase.Source__c = 'Provider Group On-boarding Counter Sign';
    Insert counterCase ;
     Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .counterSign__c= counterCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('CounterSign').getRecordTypeId();
    insert providerNetwork2 ;
    
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(counterCase.Plan_ID__c));
    pageRef.getParameters().put('counterSignCase', String.valueOf(counterCase.Id)); 
    pageRef.getParameters().put('id', String.valueOf(counterCase.Id));
    ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Provider_networks__c>{providerNetwork2});
     pageRef.getParameters().put('provId', String.valueOf(providerNetwork2.Id));*/  
 pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
}


public static testMethod void insertIndcontractCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;        
       
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Individual';
    contractCase .ParentId =masterCase.Id;
   // contractCase.Status ='Master Entity Needed';
    contractCase .recordtypeid=RecordTypeIdContract;
    Insert contractCase ;   
        
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.RecordTypeId = contractRecTypeId;
    insert providerNetwork2 ;
  //  ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Case>{contractCase});   
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
    /*pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(contractCase.Plan_ID__c));
    pageRef.getParameters().put('contractingCase', String.valueOf(contractCase.Id));   
    pageRef.getParameters().put('id', String.valueOf(contractCase.Id));   */            
   pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
}
public static testMethod void insertGrpcontractCase(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;        
       
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Group';
    contractCase .ParentId =masterCase.Id;
      //  contractCase.Status ='Master Entity Needed';
    contractCase .recordtypeid=RecordTypeIdGrpContract;
    Insert contractCase ;   
        
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='12347898';
    providerNetwork2 .Panel_code__c='Accepting';
   // providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.RecordTypeId = contractRecTypeId;
    insert providerNetwork2 ;  
//ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Case>{ContractCase});   
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
   /* pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(contractCase.Plan_ID__c));
    pageRef.getParameters().put('contractingCase', String.valueOf(contractCase.Id));
    pageRef.getParameters().put('id', String.valueOf(contractCase.Id));  */              
    pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}
public static testMethod void insertIndcontractCase_provId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Individual';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;        
       
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Individual';
    contractCase .ParentId =masterCase.Id;
    contractCase .recordtypeid=RecordTypeIdContract;
        //contractCase.Status ='Master Entity Needed';
    contractCase.Source__c = 'Provider On-boarding Contracting';
    Insert contractCase ;   
        
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
    providerNetwork2.isFirstProvider__c =True;
    providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
    providerNetwork2.RecordTypeId = contractRecTypeId;
    
   // providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Contracting Onboarding').getRecordTypeId();
    insert providerNetwork2 ;       
//ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Case>{ContractCase});   
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
    /*pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(contractCase.Plan_ID__c));
    pageRef.getParameters().put('contractingCase', String.valueOf(contractCase.Id)); 
    pageRef.getParameters().put('id', String.valueOf(contractCase.Id));
      pageRef.getParameters().put('provId', String.valueOf(providerNetwork2.Id)); */          
    pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
      
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();
}
public static testMethod void insertGrpcontractCase_ProvId(){
      createCustomSettingData();
    Case masterCase = TestCaseUtil.CreateCase();
    masterCase.Completing_the_form_for__c= 'Group';
    masterCase.recordtypeid=RecordTypeIdMasterCase ; 
    Insert masterCase;        
       
    Case contractCase =TestCaseUtil.CreateCase();
    contractCase .Completing_the_form_for__c='Group';
    contractCase .ParentId =masterCase.Id;
      //  contractCase.Status ='Master Entity Needed';
    contractCase .recordtypeid=RecordTypeIdGrpContract;
    Insert contractCase ;   
        
    Provider_Networks__c providerNetwork2 = new Provider_Networks__c();
    providerNetwork2 .Contracting_Case__c= contractCase.Id;
    providerNetwork2 .PFIN_onBoarding__c ='1234';
    providerNetwork2 .Prov_Id__c ='1234';
    providerNetwork2 .Panel_code__c='Accepting';
   // providerNetwork2 .Cred_Status__c ='No Credentialing Needed';
   
   providerNetwork2.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Contracting Onboarding').getRecordTypeId();
    insert providerNetwork2 ; 
//ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST<Case>{ContractCase});   
    PageReference pageRef = Page.ContractingDetailsEditPageLigh;      
    Test.setCurrentPageReference(pageRef);
  /*  pageRef.getParameters().put('fromPFIN', 'false');
    pageRef.getParameters().put('planId', String.valueOf(contractCase.Plan_ID__c));
    pageRef.getParameters().put('contractingCase', String.valueOf(contractCase.Id)); 
    pageRef.getParameters().put('id', String.valueOf(contractCase.Id));
    pageRef.getParameters().put('provId', String.valueOf(providerNetwork2.Id));*/  
     pageRef.getParameters().put('id',String.valueOf(providerNetwork2.Id));
  
   ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork2 ); 
   ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh(sc);
  // objProviderDetailExt.providerId =  providerNetwork2.Id;    
   objProviderDetailExt.idValue= contractCase.Id;
      objProviderDetailExt.caseId = contractCase.Id;
    objProviderDetailExt.SaveAction();
    objProviderDetailExt.SaveAndNewAction();
    objProviderDetailExt.backToCase();

}
public static testMethod void insertGrpnetworkCase(){       
    createCustomSettingData();      
     Test.startTest();      
    Case masterCase = TestCaseUtil.CreateCase();        
    masterCase.Completing_the_form_for__c= 'Group';     
    masterCase.recordtypeid=RecordTypeIdMasterCase ;        
    Insert masterCase;      
                
    Case pfinCase =TestCaseUtil.CreateCase();       
    pfinCase.Completing_the_form_for__c='Group';        
    pfinCase.ParentId =masterCase.Id;       
    pfinCase.recordtypeid=RecordTypeIdNetwork ;     
    Insert pfinCase;        
            
    Provider_Networks__c providerNetwork = new Provider_Networks__c();      
    providerNetwork .Case_Number__c = pfinCase.Id;        
    providerNetwork .PFIN_onBoarding__c ='1234';        
    providerNetwork .Prov_Id__c ='1234';        
    providerNetwork.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Network').getRecordTypeId();     
    insert providerNetwork ;        
            
            
    PageReference pageRef = Page.ContractingDetailsEditPageLigh ;             
    Test.setCurrentPageReference(pageRef);      
            
  /*  pageRef.getParameters().put('fromPFIN', 'true');        
    pageRef.getParameters().put('id', String.valueOf(pfinCase.Id));     
    pageRef.getParameters().put('planId', String.valueOf(pfinCase.Plan_ID__c));             
    ApexPAges.StandardSetController sc = new ApexPages.StandardSetController(new LIST{providerNetwork});   */     
    //pageRef.getParameters().put('caseId', String.valueOf(providerNetwork.Id));      
      pageRef.getParameters().put('Id', String.valueOf(providerNetwork.Id));
     ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork);        
    ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh (sc); 
    ProviderDetailsTriggerHandler ProvDetHandler = new ProviderDetailsTriggerHandler(); 
    ProvDetHandler.updateAccountonNetworkLoadCases(new List<Provider_Networks__c >{providerNetwork});
    objProviderDetailExt.SaveAction();      
    objProviderDetailExt.SaveAndNewAction();        
    objProviderDetailExt.backToCase();      
    pageRef = objProviderDetailExt.pageRedirect();      
    Test.stopTest();        
            
}

public static testMethod void insertnetworkCase(){       
    createCustomSettingData();      
     Test.startTest();      
    Case masterCase = TestCaseUtil.CreateCase();        
    masterCase.Completing_the_form_for__c= 'Group';     
    masterCase.recordtypeid=RecordTypeIdMasterCase ;        
    Insert masterCase;      
                
    Case pfinCase =TestCaseUtil.CreateCase();       
    pfinCase.Completing_the_form_for__c='Group';        
    pfinCase.ParentId =masterCase.Id;       
    pfinCase.recordtypeid=RecordTypeIdNetwork ;     
    Insert pfinCase;        
            
    Provider_Networks__c providerNetwork = new Provider_Networks__c();      
    providerNetwork .Case_Number__c = pfinCase.Id;        
    providerNetwork .PFIN_onBoarding__c ='1234';        
    providerNetwork .Prov_Id__c ='1234';        
    providerNetwork.recordtypeid = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByName().get('Network').getRecordTypeId();     
    insert providerNetwork ;        
            
            
    PageReference pageRef = Page.ContractingDetailsEditPageLigh ;             
    Test.setCurrentPageReference(pageRef);      
            
    
    //pageRef.getParameters().put('caseId', String.valueOf(providerNetwork.Id));      
      pageRef.getParameters().put('Id', String.valueOf(providerNetwork.Id));
     ApexPages.StandardController sc = new ApexPages.StandardController(providerNetwork);        
    ContractingDetailsEditPageLigh objProviderDetailExt=new ContractingDetailsEditPageLigh (sc); 
    
    objProviderDetailExt.SaveAction();      
    objProviderDetailExt.SaveAndNewAction();        
    objProviderDetailExt.backToCase();      
    pageRef = objProviderDetailExt.pageRedirect();      
    Test.stopTest();        
            
}
}