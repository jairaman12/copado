/****************************************************************
@Author      : Provider Intake Salesforce team 
@Date        : 10/12/2018
@Description : Test class for Account Trigger
*******************************************************
SI.No       Author                Modification Comments
1          Sethu Raman                Created

******************************************************************/


@isTest
public class Test_ProviderDetailsTrigger{    

public static Id dataEntryRecordTypeId;
public static Id credRecordTypeId;
public static Id contractRecordTypeId;
public static Id counterSignRecordTypeId;
public static Id provCounterSignRecTypeId;
 
    public static testmethod void createCustomSettingRecords(){
          dataEntryRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Entry_Provider_On_boarding').getRecordTypeId();
          credRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_On_boarding_Credentialing').getRecordTypeId();
          contractRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contracting_Provider_On_boarding').getRecordTypeId();
          counterSignRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Provider_Group_On_boarding_Counter_Sign').getRecordTypeId();
          provCounterSignRecTypeId = Schema.SObjectType.Provider_Networks__c.getRecordTypeInfosByDeveloperName().get('CounterSign').getRecordTypeId();
          
          List<RecordType_settings__c> recTypeList = new List<RecordType_settings__c>();
          
          RecordType_settings__c rType1 = new RecordType_settings__c();
          rType1.name = 'Provider On-boarding Data Entry';
          rType1.Name__c = 'Provider On-boarding Data Entry';
          rType1.developerName__c = 'Data_Entry_Provider_On_boarding';
          rType1.sObject_Type__c = 'Case';
          rType1.Record_type_Id__c = dataEntryRecordTypeId;
          recTypeList.add(rType1);
          
          RecordType_settings__c rType2 = new RecordType_settings__c();
          rType2.name = 'Provider On-boarding';
          rType2.Name__c = 'Provider On-boarding';
          rType2.developerName__c = 'Provider_On_boarding';
          rType2.sObject_Type__c = 'Case';
          rType2.Record_type_Id__c = dataEntryRecordTypeId;
          recTypeList.add(rType2);
          
          RecordType_settings__c rType3 = new RecordType_settings__c();
          rType3.name = 'Provider On_boarding Credentialing';
          rType3.Name__c = 'Provider On_boarding Credentialing';
          rType3.developerName__c = 'Provider_On_boarding_Credentialing';
          rType3.sObject_Type__c = 'Case';
          rType3.Record_type_Id__c = credRecordTypeId;
          recTypeList.add(rType3); 
          
          RecordType_settings__c rType4 = new RecordType_settings__c();
          rType4.name = 'Provider Group On_boarding Cred';
          rType4.Name__c = 'Provider Group On_boarding Credentialling';
          rType4.developerName__c = 'Provider_Group_On_boarding_Credentialling';
          rType4.sObject_Type__c = 'Case';
          rType4.Record_type_Id__c = credRecordTypeId;
          recTypeList.add(rType4);  
          
          RecordType_settings__c rType5 = new RecordType_settings__c();
          rType5.name = 'Provider Group Onboarding Master';
          rType5.Name__c = 'Provider Group Onboarding Master Entity';
          rType5.developerName__c = 'Provider_Group_Onboarding_Master_Entity';
          rType5.sObject_Type__c = 'Case';
          rType5.Record_type_Id__c = credRecordTypeId;
          recTypeList.add(rType5); 
          
          RecordType_settings__c rType6 = new RecordType_settings__c();
          rType6.name = 'Provider On-boarding Contracting';
          rType6.Name__c = 'Provider On-boarding Contracting';
          rType6.developerName__c = 'Contracting_Provider_On_boarding';
          rType6.sObject_Type__c = 'Case';
          rType6.Record_type_Id__c = contractRecordTypeId;
          recTypeList.add(rType6); 
          
          RecordType_settings__c rType7 = new RecordType_settings__c();
          rType7.name = 'Provider Group On-boarding Data';
          rType7.Name__c = 'Provider Group On-boarding DataEntry';
          rType7.developerName__c = 'Data_Entry_Group_Provider_On_boarding';
          rType7.sObject_Type__c = 'Case';
          rType7.Record_type_Id__c = contractRecordTypeId;
          recTypeList.add(rType7);
          
          RecordType_settings__c rType8 = new RecordType_settings__c();
          rType8.name = 'Provider Group On-boarding Contr';
          rType8.Name__c = 'Provider Group On-boarding Contracting';
          rType8.developerName__c = 'Provider_Group_Onboarding_Contracting';
          rType8.sObject_Type__c = 'Case';
          rType8.Record_type_Id__c = contractRecordTypeId;
          recTypeList.add(rType8); 
          
          insert recTypeList;          
          
          GlobalSettings__c gs = new GlobalSettings__c();
          gs.name = 'PFFileRecieved';
          gs.Record_Type_Names__c = 'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
          gs.PFFileRecieved__c = true;
          insert gs;
    }
    
    
    public static testmethod void createPFINProviderRecords(){         
          createCustomSettingRecords();
          Case newCase = TestCaseUtil.CreateCase();
          newCase.recordTypeId = dataEntryRecordTypeId;
          insert newCase;  
          Provider_Networks__c prov = new Provider_Networks__c(PFIN_Case__c = newCase.Id, PFIN_onBoarding__c ='1234', Prov_ID__c ='1234');
          insert prov;
    }
    
    public static testMethod void createContractProviderRecords(){
          createCustomSettingRecords();
          
          Case newCase = TestCaseUtil.CreateCase();
          newCase.recordTypeId = contractRecordTypeId;
          insert newCase;            
          Provider_Networks__c prov = new Provider_Networks__c(contracting_case__c = newCase.Id, PFIN_onBoarding__c ='1234', Prov_ID__c ='1234', Panel_code__c='aa', Cred_Status__c ='No Credentialing Needed');
          insert prov; 
          
          Case newCase2 = TestCaseUtil.CreateCase();
          newCase.recordTypeId = counterSignRecordTypeId;
          insert newCase2;       
          Provider_Networks__c prov2 = new Provider_Networks__c(counterSign__c= newCase2.Id, PFIN_onBoarding__c ='1234', Prov_ID__c ='1234', Panel_code__c='aa', prior_provider_Id__c = string.valueOf(prov.Id).substring(0,15));
          insert prov2;
                    
          prov.panel_code__c = 'ab';
          update prov;
    }
    
    public static testMethod void deleteProvNetworks(){
          createCustomSettingRecords();
          
          Case newCase = TestCaseUtil.CreateCase();
          newCase.recordTypeId = counterSignRecordTypeId;
          insert newCase;            
          Provider_Networks__c prov = new Provider_Networks__c(contracting_case__c = newCase.Id, PFIN_onBoarding__c ='1234', Prov_ID__c ='1234', Panel_code__c='aa', recordTypeId = provCounterSignRecTypeId);
          insert prov; 
          
          try{
              delete prov;
          }
          catch(Exception e){
          
          }
    }
}