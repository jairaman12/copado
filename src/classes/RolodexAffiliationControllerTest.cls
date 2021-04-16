@isTest
public class RolodexAffiliationControllerTest 
{
   @isTest static void createRolodexAffiliation()
   {
       GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        gs.name                 =   'PFFileRecieved';
        insert gs;
       
       List<RecordType> recTypeList = [Select Id,DeveloperName,Name from RecordType where sObjectType='Account'];
       Map<String,RecordType> recTypeMap  = new Map<String,RecordType>();
       
       for(RecordType recType : recTypeList )
       {
           recTypeMap.put(recType.DeveloperName,recType);
       }     
      Account rolodexAcct = new Account( lastname			=	'test rolodex',
                                  recordTypeId 	= 	recTypeMap.get('Rolodex').Id,
                                  CM_Corporate_Entity_Code__c	=	'IL1',
                                  PersonEmail = 'testemail@email.com',
                                  Tax_Id__c='123456789',
                                  NPI__c='1234567890',
                                  Phone = '9185512503'
                                );
     insert rolodexAcct;
     Account entityAcct = new Account( Name			=	'test Entity',
                                  recordTypeId 	= 	recTypeMap.get('Entity_Account').Id,
                                  CM_Corporate_Entity_Code__c	=	'IL1',
                                  Class__c			=	'C'
                                  );
      
     insert entityAcct;
     Account masterEntityAcct = new Account( Name			=	'test Master Entity',
                                  recordTypeId 	= 	recTypeMap.get('Master_Entity_Account').Id,
                                  CM_Corporate_Entity_Code__c	=	'IL1',
                                  	Organization_Type__c		=	'HCSYS'
                                );
    insert masterEntityAcct;
    Account physicianAcct1 = new Account( LastName			=	'test Physician1',
                                  recordTypeId 	= 	recTypeMap.get('Physician').Id,
                                  CM_Corporate_Entity_Code__c	=	'IL1'
                                );
   insert physicianAcct1;
   Account physicianAcct2 = new Account( LastName			=	'test Physician2',
                                  recordTypeId 	= 	recTypeMap.get('Physician').Id,
                                  CM_Corporate_Entity_Code__c	=	'IL1'
                                  
                                );
    insert physicianAcct2;
       
    Affiliations__c afft1 = new Affiliations__c( Account__c = masterEntityAcct.id,
                                                 Affiliated_Provider_Tax_Id__c = '264562522',
                                                Affiliation_Type__c	=	'HCSYSP',
                                                CM_Affiliated_Provider_Name__c = physicianAcct1.Id
    											);
     insert afft1;
    
    Test.startTest();
    PageReference pageRef = Page.RolodexAffiliationPage;
	Test.setCurrentPage(pageRef);
    RolodexAffiliationController controller = new RolodexAffiliationController();
 	ApexPages.currentPage().getParameters().put('planId',rolodexAcct.CM_Corporate_Entity_Code__c);
    ApexPages.currentPage().getParameters().put('from','Account');   
    ApexPages.currentPage().getParameters().put('isEditPage','false'); 
    ApexPages.currentPage().getParameters().put('id',rolodexAcct.Id);   
    Test.stopTest();
    controller.displayRolldownAction();
    controller.saveAffiliationAction();
    controller.saveAndNewAffiliationAction();
    controller.cancelAction();
    controller.refreshPage();
       
   }
}