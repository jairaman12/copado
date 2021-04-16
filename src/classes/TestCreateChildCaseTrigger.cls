@isTest
private class TestCreateChildCaseTrigger {
   
    static testMethod void testCases() {
     List<case> crCase = new List<case>();
     Case  c = new case();
       
    for (integer i = 0;i<4;i++){          
        // Test data for Case Information  
        if(i == 0) {c.Plan_ID__c='IL1';}
        if(i == 1) {c.Plan_ID__c='TX1';}
        if(i == 2) {c.Plan_ID__c='NM1';}
        if(i == 3) {c.Plan_ID__c='OK1';}
        if(i == 4) {c.Plan_ID__c='MT1';}
      			c.New_Billing_NPI_Number__c='41000'; 
                c.New_Tax_ID_Number__c='789100';
                c.SSN__c='Yes';   
                c.Effective_Date_of_Change_NPI_Tax__c=Date.parse('10/14/2016');
                c.Comments_NPI_Tax__c='New Tax ID Change';
        		
        		c.First_Name_Current__c='Jason';
                c.Middle_Initial_Current__c='M';
                c.Last_Name_Current__c='Sam';   
                c.Title_Current__c='Mr.';
                c.Suffix_Current__c='';
                C.Current_Practice_Name__c='Ortho';
                          
                c.First_Name_New__c='Jason Thompson';
                c.Middle_Initial_New__c='M';
                c.Last_Name_New__c='Samuel';   
                c.Title_New__c='Mr.';
                c.Suffix_New__c='';
                C.New_Practice_Name__c='Neuro';
                c.Effective_Date_of_Change_Name__c=Date.parse('10/19/2011');
                c.Comments_NPI_Tax__c='Name Change';
        
        		 c.Street_Address_Administrative_Current__c='300 E Randalop Street';   
                c.City_Administrative_Current__c='Chicago';
                c.State_Administrative_Current__c='IL';    
                c.Zip_Administrative_Current__c='18931'; //String
                c.Telephone_Administrative_Current__c='3031239856';
                c.Email_Administrative_Current__c='testphy@hcsc.net' ;   
                c.Fax_Administrative_Current__c='fax';        
                //c.ContactId='123';//Contact Name
                //c.Provider__c='Provider NM';
                //
                c.Street_Address_Administrative_New__c='300 E Randalop Street';   
                c.City_Administrative_New__c='Chicago';
                c.State_Administrative_New__c='IL';    
                c.Zip_Administrative_New__c='18931'; //String
                c.Telephone_Administrative_New__c='3031239856';
                c.Email_Administrative_New__c='testphy@hcsc.net' ;   
                c.Fax_Administrative_New__c='2432434';
                c.Comments_Administrative__c='New Administrative Address Change';
                //c.ContactPhone=9874664322; // Not Writeable
                //c.ContactEmail='testphy@hcsc.net' ; // Not Writeable
                //
                //c.Street_Address_Suite_No_Billing_Current__c='300 E Randalop Street'; 
                c.City_Billing_Current__c='Chicago';
                c.State_Billing_Current__c='IL';    
                c.Zip_Billing_Current__c='18931'; //String
                c.Telephone_Billing_Current__c='3031239856';
                c.Email_Billing_Current__c='testphy@hcsc.net' ;   
                c.Fax_Billing_Current__c='2432434';
                    
                c.Street_Address_Suite_No_Billing_New__c='300 E Randalop Street';   
                c.City_Billing_New__c='Chicago';
                c.State_Billing_New__c='IL';    
                c.Zip_Billing_New__c='18931'; //String
                c.Telephone_Billing_New__c='3031239856';
                c.Email_Billing_New__c='testphy@hcsc.net' ;   
                c.Fax_Billing_New__c='2432434';
                c.Effective_Date_of_Change_Billing__c=Date.parse('10/14/2011');   
                c.Comments_Billing__c='New Billing Address Change';   
                 	 //Test Case data for Current & New Credentialing Address/Telephone/Fax/Email Change   
                c.Street_Address_Suite_Credential_Current__c='300 E Randalop Street';   
                c.City_Credential_Current__c='Chicago';
                c.State_Credential_Current__c='IL';    
                c.Zip_Credential_Current__c='18931'; //String
                c.Telephone_Credential_Current__c='3031239856';
                c.Email_Credential_Current__c='testphy@hcsc.net' ;   
                c.Fax_Credential_Current__c='2432434';     
                    
                c.Street_Address_Suite_Credential_New__c='300 E Randalop Street';   
                c.City_Credential_New__c='Chicago';
                c.State_Credential_New__c='IL';    
                c.Zip_Credential_New__c='18931'; //String
                c.Telephone_Credential_New__c='3031239856';
                c.Email_Credential_New__c='testphy@hcsc.net' ; 
                c.Fax_Credential_New__c='2432434';
                c.Effective_Date_of_Change_Credential__c=Date.parse('10/14/2011');   
                c.Comments_Credential__c='New Credential Address Change';  
        
        
            //Test Case data for Current & New Office Physical Address/Telephone/Fax/Email and Hours of Operation Change
            c.Street_Address_Suite_No_Physical_Current__c='300 E Randalop Street';   
            c.City_Physical_Current__c='Chicago';
            c.State_Physical_Current__c='IL';    
            //c.Zip_Physical_Current__c=18931;
            c.Telephone_Physical_Current__c='3031239856';
            c.Email_Physical_Current__c='testphy@hcsc.net' ;   
            c.Fax_Physical_Current__c='2432434';
                
            c.Street_Address_Suite_No_Physical_New__c='300 E Randalop Street';   
            c.City_Physical_New__c='Chicago';
            c.State_Physical_New__c='IL';    
            //c.Zip_Physical_New__c=18931;
            c.Telephone_Physical_New__c='3031239856';
            c.Email_Physical_New__c='testphy@hcsc.net' ;   
            c.Fax_Physical_New__c='2432434';
            c.Accepting_New_Patients__c='Yes';
            c.Primary_Location_Physical__c='Yes';
            c.Supervising_Physician__c='Yes'; 
                   
            c.Mon_Open__c='09:00 AM';
            c.Mon_Close__c='10:00 PM';
            c.Tue_Open__c='09:00 AM';
            c.Tue_Close__c='10:00 PM';
            c.Wed_Open__c='09:00 AM';
            c.Wed_Close__c='10:00 PM';
            c.Thu_Open__c='09:00 AM';
            c.Thu_Close__c='10:00 PM';
            c.Fri_Open__c='09:00 AM';
            c.Fri_Close__c='10:00 PM';
            c.Sat_Open__c='09:00 AM';
            c.Sat_Close__c='10:00 PM';
            c.Sun_Open__c='09:00 AM';
            c.Sun_Close__c='10:00 PM'; 
        
    }
    
     // Start the test, this changes governor limit context to
     // that of trigger rather than test.
   
     Test.startTest();
     crCase.add(c);
     try {
                insert crCase;
            } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
            }
     Test.stopTest(); 
    }
}