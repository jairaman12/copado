/******************************
Test class name     : CLM_LocatinSearchTest
Version             : 1.0
Function            : This is a test class for CLM_LocationSearchController apex class

Developer                  Date                                
------------------------------------------------------------------------------------- 
Chaitanya Motupalli        5/1/2019 
                     
******************************/


@isTest 
private class CLM_LocatinSearchTest{


/*The following "testData" method helpful to load test data for all objects such as Account,Agreement,Provider Identification
Service &payee location address, Agreement provider location. Here PFIN Search functionality has been checked. */

    static testMethod void testData()
    {
        
      
    	GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;

         RecordType rolodexType = [Select Id From RecordType Where sObjectType='Account' and DeveloperName='Rolodex'];

        Account acc= new Account();

        acc.lastName='rolodex Account';

        acc.Tax_Id__c='123456789';

        acc.NPI__c='1234567890';

        acc.RecordTypeId=rolodexType.Id;

        acc.CM_Corporate_Entity_Code__c = 'IL1';

        acc.Phone = '9185512503';
        acc.Prov_ID__c='708472251';

        acc.PersonEmail = 'testemail@email.com';

        insert acc;
       
      		user u=[select Id from user where userrole.Name in ('CLM Illinois', 'Illinois Supervisor') AND user.IsActive = true limit 1];
      		Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      		agrmt.Apttus__Account__c=acc.Id;
      		agrmt.Plan__c='illinois';
        	agrmt.OwnerId=u.Id;
      
      		insert agrmt;
      
      	  CLM_Prov_Id_Search__c IdSearch=new CLM_Prov_Id_Search__c();
          IdSearch.CLM_Prov_Id__c='708472251';
          IdSearch.Account__c=acc.Id;
          IdSearch.Agreement__c=agrmt.Id;
      
      	  insert IdSearch;
        
      	CM_Provider_Identification__c loc=new CM_Provider_Identification__c();
      	loc.CM_Prvdr_Iden_Typ_Cd__c='NPI';
      	loc.CM_Issu_Ident_Nmbr__c='1111';
      	loc.CM_PI_Prov__c=acc.Id;
      
      	insert loc;
      
          CM_Provider_Identification__c loc2=new CM_Provider_Identification__c();
          loc2.CM_Prvdr_Iden_Typ_Cd__c='Govt. Id';
          loc2.CM_Issu_Ident_Nmbr__c='1111';
          loc2.CM_PI_Prov__c=acc.Id;
          
      insert loc2;
      
      CM_Provider_Identification__c loc3=new CM_Provider_Identification__c();
      loc3.CM_Prvdr_Iden_Typ_Cd__c='Medicare';
      loc3.CM_Issu_Ident_Nmbr__c='1111';
      loc3.CM_PI_Prov__c=acc.Id;
      
      insert loc3;
      
      CM_SPL_Addr__c servLoc=new CM_SPL_Addr__c();
      servLoc.CLM_NPI__c='11111';
      
      servLoc.CM_SPL_City__c='CA';
      servLoc.CM_SPL_Zip_CD__c='11111';
      servLoc.CM_SPL_Prov__c=acc.Id;
      
      insert servLoc;
    
      Agreement_Provider_Locations__c  provLoc=new Agreement_Provider_Locations__c ();
      provLoc.CLM_SPL_City__c='CA';
      provLoc.CLM_SPL_Zip_CD__c='11111';
      provLoc.CLM_Address__c='CA';
      provLoc.CLM_SPL_NPI_Number__c='11111';
      
      insert provLoc;
      
      CLM_LocationSearchController.locationWrapper cmp = new CLM_LocationSearchController.locationWrapper();
      cmp.isSelected=true;
      
      Agreement_Provider_Locations__c agrtmLoc=new Agreement_Provider_Locations__c();
      agrtmLoc.Agreement__c=agrmt.Id;
      agrtmLoc.CLM_SPL_Addr_Type__c=servLoc.CM_SPL_Addr_Type__c;
      
      agrtmLoc.CLM_SPL_Zip_CD__c=servLoc.CM_SPL_Zip_CD__c;
      agrtmLoc.CLM_SPL_PFIN_No__c=servLoc.CM_SPL_PFIN_No__c;
      agrtmLoc.CLM_SPL_NPI_Number__c=servLoc.CLM_NPI__c;
      insert agrtmLoc;
      
      
      
      ApexPages.StandardController sc = new ApexPages.StandardController(agrmt);
      CLM_LocationSearchController ctrl= new CLM_LocationSearchController (sc);
    
    
      PageReference pageRef = Page.CLM_LocationSearch;
      pageRef.getParameters().put('id', String.valueOf(agrmt.Id));
      Test.setCurrentPage(pageRef);
        
      ctrl.PFIN=true;
      ctrl.searchText='708472251';
      ctrl.provIdSearchTxt='708472251';
      //ctrl.master=true;
      
        
      ctrl.smartsearch();
      ctrl.getsearchSites();
      ctrl.createLocations();
      ctrl.quickSave();
      ctrl.Cancel();
      ctrl.updteNPIDetails();
      ctrl.searchProvId();
      ctrl.removeProvId();
      ctrl.masterCheckBox();
      ctrl.removeLocation();
      ctrl.GetIsClassic();
      ctrl.Firstbtn();
      ctrl.prvbtn();
      ctrl.nxtbtn();
      ctrl.lstbtn();
      ctrl.getnxt();
      ctrl.getprv();
   
    }
   
   
   
   
   
   static testMethod void testData2() {
       
       
        GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
     RecordType rolodexType = [Select Id From RecordType Where sObjectType='Account' and DeveloperName='Rolodex'];

        Account acc= new Account();

        acc.lastName='rolodex Account';

        acc.Tax_Id__c='123456789';

        acc.NPI__c='1234567890';

        acc.RecordTypeId=rolodexType.Id;

        acc.CM_Corporate_Entity_Code__c = 'OK1';

        acc.Phone = '9185512503';

        acc.PersonEmail = 'testemail@email.com';

        insert acc;
      
     	 user u=[select Id from user where userrole.Name in ('CLM Oklahoma' ,'Oklahoma Supervisor') AND user.IsActive = true limit 1];
       
      	Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      	agrmt.Apttus__Account__c=acc.Id;
      	agrmt.Plan__c='Oklahoma';
       	agrmt.OwnerId=u.Id;
      	insert agrmt;
      
         CM_SPL_Addr__c servLoc=new CM_SPL_Addr__c();
          servLoc.CLM_NPI__c='11111';
          
          servLoc.CM_SPL_City__c='CA';
          servLoc.CM_SPL_Zip_CD__c='11111';
          servLoc.CM_SPL_Prov__c=acc.Id;
          
          insert servLoc;
    
      Agreement_Provider_Locations__c  provLoc=new Agreement_Provider_Locations__c ();
      provLoc.CLM_SPL_City__c='CA';
      provLoc.CLM_SPL_Zip_CD__c='11111';
      provLoc.CLM_Address__c='CA';
      provLoc.CLM_SPL_NPI_Number__c='11111';
      
      insert provLoc;
      
      CLM_LocationSearchController.locationWrapper cmp = new CLM_LocationSearchController.locationWrapper();
      cmp.isSelected=true;
      
      ApexPages.StandardController sc = new ApexPages.StandardController(agrmt);
      CLM_LocationSearchController ctrl= new CLM_LocationSearchController (sc);
    
      PageReference pageRef = Page.CLM_LocationSearch;
      pageRef.getParameters().put('id', String.valueOf(agrmt.Id));
      Test.setCurrentPage(pageRef);
      
      ctrl.PFIN=true;
      ctrl.provIdSearchTxt='33333';
      ctrl.master=true;
      
      ctrl.smartsearch();
      ctrl.getsearchSites();
      ctrl.createLocations();
      ctrl.quickSave();
      ctrl.Cancel();
      ctrl.updteNPIDetails();
      ctrl.searchProvId();
      ctrl.removeProvId();
      ctrl.masterCheckBox();
      ctrl.removeLocation();
      ctrl.GetIsClassic();
      ctrl.Firstbtn();
      ctrl.prvbtn();
      ctrl.nxtbtn();
      ctrl.lstbtn();
      ctrl.getnxt();
      ctrl.getprv();
       
       
    }
    
    
    //TaxID Search 
    
     static testMethod void testData3() {
     
      GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
     RecordType rolodexType = [Select Id From RecordType Where sObjectType='Account' and DeveloperName='Rolodex'];

        Account acc= new Account();

        acc.lastName='rolodex Account';

        acc.Tax_Id__c='123456789';

        acc.NPI__c='1234567890';

        acc.RecordTypeId=rolodexType.Id;

        acc.CM_Corporate_Entity_Code__c = 'TX1';

        acc.Phone = '9185512503';

        acc.PersonEmail = 'testemail@email.com';

        insert acc;
      
      user u=[select Id from user where userrole.Name in('CLM Texas', 'Texas Supervisor') AND user.IsActive = true limit 1];
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
      agrmt.Plan__c='Texas';
         agrmt.OwnerId=u.Id;
      insert agrmt;
      
      CM_SPL_Addr__c servLoc=new CM_SPL_Addr__c();
      servLoc.CLM_NPI__c='11111';
      
      servLoc.CM_SPL_City__c='CA';
      servLoc.CM_SPL_Zip_CD__c='11111';
      servLoc.CM_SPL_Prov__c=acc.Id;
      
      insert servLoc;
    
      Agreement_Provider_Locations__c  provLoc=new Agreement_Provider_Locations__c ();
      provLoc.CLM_SPL_City__c='CA';
      provLoc.CLM_SPL_Zip_CD__c='11111';
      provLoc.CLM_Address__c='CA';
      provLoc.CLM_SPL_NPI_Number__c='11111';
      
      insert provLoc;
      
      CLM_LocationSearchController.locationWrapper cmp = new CLM_LocationSearchController.locationWrapper();
      cmp.isSelected=true;
      
      ApexPages.StandardController sc = new ApexPages.StandardController(agrmt);
      CLM_LocationSearchController ctrl= new CLM_LocationSearchController (sc);
    
      PageReference pageRef = Page.CLM_LocationSearch;
      pageRef.getParameters().put('id', String.valueOf(agrmt.Id));
      Test.setCurrentPage(pageRef);
      
      ctrl.taxId=true;
      ctrl.searchText='11111';
        
      
      ctrl.smartsearch();
      ctrl.getsearchSites();
      ctrl.createLocations();
      ctrl.searchProvId();
      ctrl.Cancel();
      ctrl.updteNPIDetails();
      ctrl.Firstbtn();
      ctrl.prvbtn();
      ctrl.nxtbtn();
      ctrl.lstbtn();
      ctrl.getnxt();
      ctrl.getprv();
      
      
    }
    
    
    //NPI search
    
     static testMethod void testData4() {
    
     
           GlobalSettings__c gs    =   new GlobalSettings__c();
        gs.name                 =   'PFFileRecieved';
        gs.PFFileRecieved__c    =   false;
        gs.List_size__c         =   10;
        gs.Account_trigger_switch__c    =   false;
        gs.Record_Type_Names__c =   'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;      
       RecordType rolodexType = [Select Id From RecordType Where sObjectType='Account' and DeveloperName='Rolodex'];

        Account acc= new Account();

        acc.lastName='rolodex Account';

        acc.Tax_Id__c='123456789';

        acc.NPI__c='1234567890';

        acc.RecordTypeId=rolodexType.Id;

        acc.CM_Corporate_Entity_Code__c = 'MT1';

        acc.Phone = '9185512503';

        acc.PersonEmail = 'testemail@email.com';

        insert acc;
         
      user u=[select Id from user where userrole.Name in('CLM Montana','Montana Supervisor') AND user.IsActive = true limit 1];
      Apttus__APTS_Agreement__c agrmt=new Apttus__APTS_Agreement__c();
      agrmt.Apttus__Account__c=acc.Id;
         agrmt.OwnerId=u.Id;
      agrmt.Plan__c='Montana';
      
      insert agrmt;
      
      CM_SPL_Addr__c servLoc=new CM_SPL_Addr__c();
      servLoc.CLM_NPI__c='11111';
      
      servLoc.CM_SPL_City__c='CA';
      servLoc.CM_SPL_Zip_CD__c='11111';
      servLoc.CM_SPL_Prov__c=acc.Id;
      
      insert servLoc;
    
      Agreement_Provider_Locations__c  provLoc=new Agreement_Provider_Locations__c ();
      provLoc.CLM_SPL_City__c='CA';
      provLoc.CLM_SPL_Zip_CD__c='11111';
      provLoc.CLM_Address__c='CA';
      provLoc.CLM_SPL_NPI_Number__c='11111';
      
      insert provLoc;
      
      CLM_LocationSearchController.locationWrapper cmp = new CLM_LocationSearchController.locationWrapper();
      cmp.isSelected=true;
      
      ApexPages.StandardController sc = new ApexPages.StandardController(agrmt);
      CLM_LocationSearchController ctrl= new CLM_LocationSearchController (sc);
    
      PageReference pageRef = Page.CLM_LocationSearch;
      pageRef.getParameters().put('id', String.valueOf(agrmt.Id));
      Test.setCurrentPage(pageRef);
      
      ctrl.npi=true;
      ctrl.searchText='11111';
        
     
      ctrl.smartsearch();
      ctrl.getsearchSites();
      ctrl.createLocations();
      ctrl.searchProvId();
      ctrl.Cancel();
      ctrl.updteNPIDetails();
      ctrl.Firstbtn();
      ctrl.prvbtn();
      ctrl.nxtbtn();
      ctrl.lstbtn();
      ctrl.getnxt();
      ctrl.getprv();
     
       
    }
 
    
}