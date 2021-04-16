public class TestClassData{
    
    /*
* Method name  : CreateAccount
* Description  : Create an account
* Return Type  : Account
* Parameter    : nil
*/
    public static Account CreateAccount()
    {
        Account acc1 = new Account();
        acc1.Name = 'Test Account1'; 
        acc1.BillingStreet ='xyz';
        acc1.BillingCity = 'ABC';
        acc1.BillingCountry = 'USA';
        acc1.NPI__c='1234567890';
        acc1.CM_Corporate_Entity_Code__c = 'IL1';  
        insert acc1;
        
        return acc1;
    }
    
/* 	*/
    public static Account CreatePersonAccount()
    {
       // String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;       
        String RecTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account Accnt = new Account();
        Accnt.RecordTypeID=RecTypeId;
        Accnt.FirstName='Test FName';
        Accnt.LastName='Test LName';
        Accnt.PersonMailingStreet='test@yahoo.com';
        Accnt.PersonMailingPostalCode='12345';
        Accnt.PersonMailingCity='SFO';
        Accnt.PersonEmail='test@yahoo.com';
        Accnt.PersonHomePhone='1234567';
        Accnt.PersonMobilePhone='12345678';
        Accnt.CM_Corporate_Entity_Code__c = 'IL1';
         insert Accnt;
        
        return Accnt;
        }
    
       
    
    /*
* Method name  : CreateCustomSettingData
* Description  : Create Custom Setting Data
* Return Type  : None
* Parameter    : sobject name
*/
    public static void CreateCustomSettingData(string sobjname)
    {
        list<recordtype> recTypes = new list<recordtype>();
        boolean t = true;
        integer counter = 0;
        list<RecordType_settings__c> rts = new list<RecordType_settings__c>();
        string query = 'select id,name,DeveloperName,IsActive,SobjectType from recordtype where SobjectType = :sobjname and isactive= :t';
        recTypes = database.query(query);
        for(recordtype r:recTypes){
            RecordType_settings__c temp = new RecordType_settings__c();
            temp.DeveloperName__c   = r.DeveloperName;
            temp.name	            = r.id;
            temp.Name__c            = r.id;
            temp.Record_type_Id__c  = r.Id;
            temp.sObject_Type__c    = r.SobjectType;
			rts.add(temp);         
            counter = counter + 1;
        }
        insert rts;        
    }
    
    
    /*
* Method name  : CreateProviderIdentification
* Description  : Create an Provider Identification record
* Return Type  : CM_Provider_Identification__c
* Parameter    : Account Id
*/
    public static CM_Provider_Identification__c CreateProviderIdentification(Id acctId)
    {
        CM_Provider_Identification__c provIden = new CM_Provider_Identification__c();        
        provIden.CM_PI_Prov__c = acctId;
        provIden.CM_PI_Current_Status__c = 'New';
        provIden.CM_Corporate_Entity_Code__c = 'IL1';
        provIden.CM_Issu_Ident_Nmbr__c ='1234567890';      
        insert provIden;        
        return provIden;
    }
     public static CM_Provider_Identification__c CreateProviderIdentificationDelete(Id acctId)
    {
        CM_Provider_Identification__c provIden = new CM_Provider_Identification__c();        
        provIden.CM_PI_Prov__c = acctId;
        provIden.CM_PI_Current_Status__c = 'New';
        provIden.CM_Corporate_Entity_Code__c = 'IL1';
        insert provIden;
        provIden.CM_Corporate_Entity_Code__c = 'OK1';
        update provIden;
        //delete provIden;
        return provIden;
    }
    
    
    /*
* Method name  : CreateProviderTaxIdentification
* Description  : Create an Provider Tax Identification record
* Return Type  : CM_Provider_Identification__c
* Parameter    : Account Id
*/
    public static CM_Provider_Tax_Id__c CreateProviderTaxIdentification(Id acctId)
    {
        CM_Provider_Tax_Id__c provTaxIden = new CM_Provider_Tax_Id__c();        
        provTaxIden.CM_PTI_Prov_Name_To__c = acctId;
        provTaxIden.CM_PTI_Prov_Name_From__c = acctId;
        provTaxIden.CM_PTI_Tax_Id__c = 'Tax';
        provTaxIden.CM_Corporate_Entity_Code__c = 'IL1';
        insert provTaxIden;
        provTaxIden.CM_Corporate_Entity_Code__c = 'IL1';
        update provTaxIden;
        //delete provtaxIden;
        return provTaxIden;
    }
    public static CM_Provider_Tax_Id__c CreateProviderTaxIdentificationForDelete(Id acctId)
    {
        CM_Provider_Tax_Id__c provTaxIden = new CM_Provider_Tax_Id__c();        
        provTaxIden.CM_PTI_Prov_Name_To__c = acctId;
        provTaxIden.CM_PTI_Prov_Name_From__c = acctId;
        provTaxIden.CM_PTI_Tax_Id__c = 'Tax';
        provTaxIden.CM_Corporate_Entity_Code__c = 'IL1';
        insert provTaxIden;
        provTaxIden.CM_Corporate_Entity_Code__c = 'IL1';
        update provTaxIden;
        //delete provtaxIden;
        return provTaxIden;
    }
   
    
    
    /*
* Method name  : CreateAffiliation
* Description  : Create an Affiliation record
* Return Type  : CM_Provider_Identification__c
* Parameter    : Account Id
*/
    public static Affiliations__c CreateAffiliation(Id acctId)
    {
        Affiliations__c affi = new Affiliations__c();        
        affi.CM_Affiliated_Provider_Name__c = acctId;        
        affi.CM_Corporate_Entity_Code__c = 'IL1';
        insert affi;
        
        return affi;
    }
    
    /*
* Method name  : CreateSpecialty
* Description  : Create an Specialty record
* Return Type  : CM_Provider_Identification__c
* Parameter    : Account Id
*/
    public static CM_Specialty__c CreateSpecialty(Id acctId, Id sploc, Id NetSpl)
    {
        CM_Specialty__c spl = new CM_Specialty__c();        
        spl.CM_SP_Provider__c = acctId;
        spl.CM_SP_Acc_Tax_Addr__c = sploc;
        spl.CM_SP_Network__c = NetSpl;        
        spl.Corporate_Entity_Code__c = 'IL1';
        insert spl;        
        return spl;
    }
    
    /*
* Method name  : CreateChildCase
* Description  : Create an Child Case record
* Return Type  : Case
* Parameter    : Account Id
*/    
    public static case CreateChildCase(Id acctId)
    {
        Case c      =   new Case();        
        c.AccountId =   acctId; 
        c.Case_Entity__c = acctId;
        c.Plan_ID__c    =   'IL1';   
        c.First_Name_Current__c     =   'Jason';
        c.Middle_Initial_Current__c =   'M';
        c.Last_Name_Current__c      =   'Sam';   
        c.Title_Current__c          =   'Mr.';
        c.Suffix_Current__c         =   '';
        C.Current_Practice_Name__c  =   'Ortho';
        
        c.First_Name_New__c         =   'Jason Thompson';
        c.Middle_Initial_New__c     =   'M';
        c.Last_Name_New__c          =   'Samuel';   
        c.Title_New__c              =   'Mr.';
        c.Suffix_New__c             =   '';
        C.New_Practice_Name__c      =   'Neuro';
        c.Effective_Date_of_Change_Name__c  =   Date.parse('10/19/2011');
        c.Comments_NPI_Tax__c       =   'Name Change';          
        return c; 
    }
    
    /*
* Method name  : CreateServicePayeeLocationAddress
* Description  : Create an Service & Payee Location Address record
* Return Type  : CM_SPL_Addr__c
* Parameter    : Provider Tax Identification Id
*/
    public static CM_SPL_Addr__c CreateServicePayeeLocationAddress(Id ProvId)
    {
        system.debug('provid****'+ provId);
        CM_SPL_Addr__c spl = new CM_SPL_Addr__c();          
        spl.CM_SPL_Prov_Tax_ID__c = provId;                
        spl.CM_Corporate_Entity_Code__c = 'IL1';
        insert spl;
        return spl;
    }
    
    /*
* Method name  : CreateNetwork
* Description  : Create an Network record
* Return Type  : CM_Network__c
* Parameter    : Service and Payee Location Id
*/
    public static CM_Network__c CreateNetwork(Id splId)
    {
        CM_Network__c net = new CM_Network__c();        
        net.CM_Service_Payee_Location_Address__c = splId;        
        net.CM_Corporate_Entity_Code__c = 'IL1';
        insert net;
        
        return net;
    }
    
    /*
* Method name  : CreateHoursofOperation
* Description  : Create an Hours of Operation record
* Return Type  : CM_Hours_of_Operation__c
* Parameter    : Service and Payee Location Id
*/
    public static CM_Hours_of_Operation__c CreateHoursofOperation(Id splId)
    {
        CM_Hours_of_Operation__c hno = new CM_Hours_of_Operation__c();        
        hno.CM_HoO_Service_Payee_Location_Address__c     = splId;        
        hno.CM_Corporate_Entity_Code__c = 'IL1';
        //hno.Name = 'Name';
        insert hno;
        
        return hno;
    }
    
    /*
* Method name  : CreateUser
* Description  : Create an User record
* Return Type  : User
* Parameter    : None

    public static User createUser()
    {
        String profile = 'Supervisor';
        String role    = 'Illinois Supervisor';
        String roleName         =   String.isEmpty( role )? ' ': role ;
        String profileName      =   String.isEmpty( profile )?'System Administrator': profile;
        
        Id roleId       =   [select id from UserRole where Name=:roleName Limit 1].Id;
        Id profileId    =   [SELECT Id FROM Profile WHERE Name =:profileName Limit 1].Id;   
        User usr = new User();
        usr.ProfileId = profileId;
        usr.UserRoleId= roleId;
        usr.LastName = 'last';
        usr.Email = 'puser'+System.currentTimeMillis()+'@bcbsil.com';
        usr.Username = 'testuser'+System.currentTimeMillis()+'@bcbsil.com';
        usr.CompanyName = 'TEST';
        usr.Title = 'title';
        usr.Alias = 'alias';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        insert usr;
        return Usr;
    }
*/
}