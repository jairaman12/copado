@isTest
public class TestCaseUtil 
{  
    
    /**
    * Create user 
    ***/
    public static List<User> createUser(String profile,String role,Integer count)
    {
        
        String roleName         =   String.isEmpty( role )? ' ': role ;
        String profileName      =   String.isEmpty( profile )?'System Administrator': profile;
        List<User> userList     =   new List<User>();
        
        Id roleId               =   [select id from UserRole where Name=:roleName Limit 1].Id;
        Id profileId            =   [SELECT Id FROM Profile WHERE Name =:profileName Limit 1].Id;   
        for(Integer i=0;i<count;i++){
        User usr = new User();
         usr.ProfileId = profileId;
         usr.UserRoleId= roleId;
         usr.LastName = 'last'+i;
         usr.Email = 'puser'+System.currentTimeMillis()+i+'@bcbsil.com';
         usr.Username = 'testuser'+System.currentTimeMillis()+i+'@bcbsil.com';
         usr.CompanyName = 'TEST';
         usr.Title = 'title';
         usr.Alias = 'alias';
         usr.TimeZoneSidKey = 'America/Los_Angeles';
         usr.EmailEncodingKey = 'UTF-8';
         usr.LanguageLocaleKey = 'en_US';
         usr.LocaleSidKey = 'en_US';
         userList.add(usr);
        }
         return userList;
    }
    
    /**
     * Create Account and insert
     * */   
    public static Account createAccount()
    {   
        Account acct = new Account( name = 'Test Company Name', CM_Corporate_Entity_Code__c = 'IL1',
                                   recordtypeid = '012410000011qbxAAA' ); //recordtypeid is for entity account 
        try 
        {      
            insert acct;                
        } catch( DmlException e ) 
        {
            System.debug('Error occurred on master case creation1: ' + e.getMessage());
        }           
        return acct;
      }
    
      /**
     * Create Contact and insert
     * */     
     private static Contact createContact()
     {  
         Account act    =   createAccount();
         Contact con    =   new Contact(FirstName='John',LastName='Doe',Email='john.doe@test.com',AccountId=act.id);   
         
         try 
         {     
             insert con;
             //System.debug('Contact ID: ' + con.Id);
         } catch(DmlException e) 
         {
             System.debug('Error occurred on master case creation2: ' + e.getMessage());
         }  
        return con;     
      }
    
     /**
     * Test data for Case Information
     * */ 
    private static void caseInfo( Case c )
    {        
        c.Origin    =   'Web On-boarding';
        c.Priority  =   'Low';
        c.Status    =   'New';       
        c.Completing_the_form_for__c    =   'Individual Provider';
        c.Original_Creation_Date__c     =   Date.parse('10/31/2017');
    }
        
    /**
     * Test data for submitter Information
     * */
    private static void subInfo( Case c )
    {
        c.Name_Submitter__c     =   'Ravi Raj Pandey';
        c.Title_Submitter__c    =   'Mr';
        c.Telephone_Number_Submitter__c =   '8967514321';
        c.Email_Address_Submitter__c    =   'rrpandey@gmail.com';
    }
     
    /**
     * Test Data for Provider Information
     * */
    private static void provInfo( Case c )
    {
         c.Name_of_Provider_Group__c    =   'ABC';  
         c.Rendering_NPI__c             =   '7961235487';
        // c.Billing_NPI_Number__c      =   '240723';
          c.Billing_NPI_Number__c       =   '2407230000';
         c.Tax_ID_Number__c             =   '204973420';
     }
    
     /**
     * Test Data for NPI/Tax Id Change
     * */
    private static void npiChg( Case c )
    {  
        c.New_Billing_NPI_Number__c =   '4100000000'; 
        c.New_Tax_ID_Number__c      =   '789100000';
        c.SSN__c                    =   'Yes';   
        c.Effective_Date_of_Change_NPI_Tax__c   =   Date.parse('10/14/2016');
        c.Comments_NPI_Tax__c       =   'New Tax ID Change';  
     }
    
   /**
     * Test Case data for Name Change
     * */
    public static void nameChg( Case c )
    { 
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
    }
   
     /**
     * Test Case data for Current & New Administrative Address/Telephone/Fax/Email Change   
     * */
    private static void adminAddrChg( Case c )
    {          
        c.Street_Address_Administrative_Current__c  =   '300 E Randalop Street';   
        c.City_Administrative_Current__c            =   'Chicago';
        c.State_Administrative_Current__c           =   'IL';    
        c.Zip_Administrative_Current__c             =   '18931';
        c.Telephone_Administrative_Current__c       =   '3031239856';
        c.Email_Administrative_Current__c           =   'testphy@hcsc.net' ;   
        //c.Fax_Administrative_Current__c             =   '123456789';        
        
        c.Street_Address_Administrative_New__c      =   '300 E Randalop Street';   
        c.City_Administrative_New__c                =   'Chicago';
        c.State_Administrative_New__c               =   'IL';    
        c.Zip_Administrative_New__c                 =   '18931'; 
        c.Telephone_Administrative_New__c           =   '3031239856';
        c.Email_Administrative_New__c               =   'testphy@hcsc.net' ;   
        //c.Fax_Administrative_New__c                 =   '243243423';
        c.Comments_Administrative__c                =   'New Administrative Address Change';
                     
    }
    
     /**
     * Test Case data for Current & New Administrative Address/Telephone/Fax/Email Change   
     * */         
    private static void billingAddrChg( Case c )
    {  
        c.Street_Address_Suite_No_Billing_Current__c    =   '300 E Randalop Street'; 
        c.City_Billing_Current__c                       =   'Chicago';
        c.State_Billing_Current__c                      =   'IL';    
        c.Zip_Billing_Current__c                        =   '18931';
        c.Telephone_Billing_Current__c                  =   '3031239856';
        c.Email_Billing_Current__c                      =   'testphy@hcsc.net' ;   
       // c.Fax_Billing_Current__c                        =   '243243423';
            
        c.Street_Address_Suite_No_Billing_New__c        =   '300 E Randalop Street';   
        c.City_Billing_New__c                           =   'Chicago';
        c.State_Billing_New__c                          =   'IL';    
        c.Zip_Billing_New__c                            =   '18931';
        c.Telephone_Billing_New__c                      =   '3031239856';
        c.Email_Billing_New__c                          =   'testphy@hcsc.net' ;   
        //c.Fax_Billing_New__c                            =   '243243423';
        c.Effective_Date_of_Change_Billing__c           =   Date.parse('10/14/2011');   
        c.Comments_Billing__c                           =   'New Billing Address Change';   
      }
    
    
    /**
     * Test Case data for Current & New Administrative Address/Telephone/Fax/Email Change   
     * */
    private static void credentialAddrChg( Case c )
    { 
        c.Street_Address_Suite_Credential_Current__c    =   '300 E Randalop Street';   
        c.City_Credential_Current__c                    =   'Chicago';
        c.State_Credential_Current__c                   =   'IL';    
        c.Zip_Credential_Current__c                     =   '18931'; //String
        c.Telephone_Credential_Current__c               =   '3031239856';
        c.Email_Credential_Current__c                   =   'testphy@hcsc.net' ;   
        //c.Fax_Credential_Current__c                     =   '243243423';     
        
        c.Street_Address_Suite_Credential_New__c        =   '300 E Randalop Street';   
        c.City_Credential_New__c                        =   'Chicago';
        c.State_Credential_New__c                       =   'IL';    
        c.Zip_Credential_New__c                         =   '18931'; //String
        c.Telephone_Credential_New__c                   =   '3031239856';
        c.Email_Credential_New__c                       =   'testphy@hcsc.net' ; 
        //c.Fax_Credential_New__c                         =   '243243423';
        c.Effective_Date_of_Change_Credential__c        =   Date.parse('10/14/2011');   
        c.Comments_Credential__c                        =   'New Credential Address Change';
    }
      
     /**
     * Test Case data for Current & New Office Physical Address/Telephone/Fax/Email and Hours of Operation Change   
     * */
    private static void physicalAddrChg( Case c )
    {
        c.Street_Address_Suite_No_Physical_Current__c   =   '300 E Randalop Street';   
        c.City_Physical_Current__c                      =   'Chicago';
        c.State_Physical_Current__c                     =   'IL';    
        c.Telephone_Physical_Current__c                 =   '3031239856';
        c.Email_Physical_Current__c                     =   'testphy@hcsc.net' ;   
        //c.Fax_Physical_Current__c                       =   '243242334';
            
        c.Street_Address_Suite_No_Physical_New__c       =   '300 E Randalop Street';   
        c.City_Physical_New__c                          =   'Chicago';
        c.State_Physical_New__c                         =   'IL';    
        c.Telephone_Physical_New__c                     =   '3031239856';
        c.Email_Physical_New__c                         =   'testphy@hcsc.net' ;   
        //c.Fax_Physical_New__c                           =   '243243234';
        c.Accepting_New_Patients__c                     =   'Yes';
        c.Primary_Location_Physical__c                  =   'Yes';
        c.Supervising_Physician__c                      =   'Yes'; 
               
        c.Mon_Open__c   =   '09:00 AM';
        c.Mon_Close__c  =   '10:00 PM';
        c.Tue_Open__c   =   '09:00 AM';
        c.Tue_Close__c  =   '10:00 PM';
        c.Wed_Open__c   =   '09:00 AM';
        c.Wed_Close__c  =   '10:00 PM';
        c.Thu_Open__c   =   '09:00 AM';
        c.Thu_Close__c  =   '10:00 PM';
        c.Fri_Open__c   =   '09:00 AM';
        c.Fri_Close__c  =   '10:00 PM';
        c.Sat_Open__c   =   '09:00 AM';
        c.Sat_Close__c  =   '10:00 PM';
        c.Sun_Open__c   =   '09:00 AM';
        c.Sun_Close__c  =   '10:00 PM';            
    }
    
    public static case CreateCase()
    {
        Case c      =   new Case();
        Contact con =   createContact(); 
        // c.ContactId =   con.id;
        c.AccountId =   con.AccountId; 
        c.NPI_Tax_Id_Change__c  =   true;  
        c.Name_Change__c        =   true;
        c.Bill_NPI_Type__c      ='Type 2 (Group)';
        c.status    ='Closed Rejected';
        c.PFIN_Numbers_Long__c  ='1236547896';
        c.External_Comments__c = 'test';
        c.Bill_PFIN__c  = '2145639874';
        c.Administrative_Address_Telephone_Fax_Ema__c   =   true;
        c.Billing_Address_Telephone_Fax_Email_Chan__c   =   true;
        c.Credentialing_Address_Telephone_Fax_Emai__c   =   true; 
        c.Office_Physical_Address_Telephone_Fax_Em__c   =   true;
        
        caseInfo(c);
        subInfo(c);
        provInfo(c);
        integer n       =   2;         
        c.Plan_ID__c    =   'IL1';   
        
        // Number of times case needs to be created
        for (integer i = 0;i<n;i++)
        {          
            if (c.NPI_Tax_Id_Change__c) 
            {
                //System.debug('NPI Change:::'+c.NPI_Tax_Id_Change__c);
                npiChg(c);
            }
            
            if(c.Name_Change__c)
            {
                //System.debug('Name Change:::'+c.Name_Change__c);
                nameChg(c); 
            }
            
            if(c.Administrative_Address_Telephone_Fax_Ema__c)
            {
                //System.debug('Admin Address Change:::'+c.Administrative_Address_Telephone_Fax_Ema__c);
                adminAddrChg(c);
            }
            
            if(c.Billing_Address_Telephone_Fax_Email_Chan__c)
            {
                //System.debug('Billing Address Change:::'+c.Billing_Address_Telephone_Fax_Email_Chan__c);
                billingAddrChg(c);       
            }  
            
            if (c.Credentialing_Address_Telephone_Fax_Emai__c)
            {
                //System.debug('Credentialing Address Change:::'+c.Credentialing_Address_Telephone_Fax_Emai__c);
                credentialAddrChg(c);
            } 
            
            if (c.Office_Physical_Address_Telephone_Fax_Em__c)
            {
                //System.debug('Office Physical Address Change:::'+c.Office_Physical_Address_Telephone_Fax_Em__c);
                physicalAddrChg(c);
            }
                    
        } 
        
     return c; 
    }  
}