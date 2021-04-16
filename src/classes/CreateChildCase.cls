/*For each Master Case created, Create respective  
    child cases  records for the Master case which have the specific work item checkboxes.  
    */ 

public class CreateChildCase {
    public static void  createChildCaseMethod(List <case> newCase){   
        
List<Case> childCases = new List<case>();
    for(case c:newCase) {
         if (c.ParentId==null){
        	System.debug('Case Details::: '+c);
         System.debug('Inside Child Case Creation::::::: ');
        //----Create Work Item for Name Change
        if(c.Name_Change__c) {
             System.debug('Inside Name Change::::::: ');
            RecordType nameChangeRecType = [Select Id From RecordType  Where SobjectType = :ChildCaseUtil.OBJ_TYPE and DeveloperName = :ChildCaseUtil.REC_TYP_NM_CHG];
            childCases.add(new case(ParentId=c.id,RecordTypeId =nameChangeRecType.id,Origin=c.Origin,Plan_ID__c=c.Plan_ID__c,Name_Change__c=c.Name_Change__c,First_Name_Current__c= c.First_Name_Current__c,Middle_Initial_Current__c=c.Middle_Initial_Current__c,Last_Name_Current__c=c.Last_Name_Current__c,Title_Current__c=c.Title_Current__c,Suffix_Current__c=c.Suffix_Current__c,Current_Practice_Name__c=c.Current_Practice_Name__c,
                            First_Name_New__c=c.First_Name_New__c,Middle_Initial_New__c=c.Middle_Initial_New__c,Last_Name_New__c=c.Last_Name_New__c,Title_New__c=c.Title_New__c,New_Practice_Name__c=c.New_Practice_Name__c,Effective_Date_of_Change_Name__c=c.Effective_Date_of_Change_Name__c,Comments_Name_Change__c=c.Comments_Name_Change__c));
        }
        //----Create Work Item for NPI/Tax Id Change
        if(c.NPI_Tax_Id_Change__c) {
        System.debug('Inside NPI Tax ID::::::: ');    
            RecordType taxIdChangeRecType = [Select Id From RecordType  Where SobjectType = :ChildCaseUtil.OBJ_TYPE and DeveloperName = :ChildCaseUtil.REC_TYP_NPI_ID];
           childCases.add(new case(ParentId=c.id,RecordTypeId =taxIdChangeRecType.id,Origin=c.Origin,Plan_ID__c=c.Plan_ID__c,New_Tax_ID_Number__c= c.New_Tax_ID_Number__c,NPI_Tax_Id_Change__c=c.NPI_Tax_Id_Change__c,New_Billing_NPI_Number__c=c.New_Billing_NPI_Number__c,SSN__c=c.SSN__c,Comments_NPI_Tax__c=c.Comments_NPI_Tax__c,Effective_Date_of_Change_NPI_Tax__c=c.Effective_Date_of_Change_NPI_Tax__c));
        }
        //----Create Work Item for Office Physical Address/Telephone/Fax/Email and Hours of Operation Change
        if(c.Office_Physical_Address_Telephone_Fax_Em__c) {
            System.debug('Inside Physical::::::: ');    
            RecordType pAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :ChildCaseUtil.OBJ_TYPE and DeveloperName = :ChildCaseUtil.REC_TYP_PHY_ADD_CHG];
            childCases.add(new case(ParentId=c.id,RecordTypeId =pAddrChangeRecType.id,Origin=c.Origin,Plan_ID__c=c.Plan_ID__c,Office_Physical_Address_Telephone_Fax_Em__c=c.Office_Physical_Address_Telephone_Fax_Em__c,Street_Address_Suite_No_Physical_current__c= c.Street_Address_Suite_No_Physical_current__c,City_Physical_Current__c=c.City_Physical_Current__c,State_Physical_Current__c=c.State_Physical_Current__c,Zip_Physical_Current__c=c.Zip_Physical_Current__c,Telephone_Physical_Current__c=c.Telephone_Physical_Current__c,
                                   Email_Physical_Current__c=c.Email_Physical_Current__c,Fax_Physical_Current__c=c.Fax_Physical_Current__c,Accepting_New_Patients__c=c.Accepting_New_Patients__c,
                                   Street_Address_Suite_No_Physical_New__c=c.Street_Address_Suite_No_Physical_New__c,City_Physical_New__c=c.City_Physical_New__c,State_Physical_New__c=c.State_Physical_New__c,Zip_Physical_New__c=c.Zip_Physical_New__c,Telephone_Physical_New__c=c.Telephone_Physical_New__c,
                                   Email_Physical_New__c=c.Email_Physical_New__c,Fax_Physical_New__c=c.Fax_Physical_New__c,Primary_Location_Physical__c=c.Primary_Location_Physical__c,Supervising_Physician__c=c.Supervising_Physician__c,
                                   Mon_Open__c=c.Mon_Open__c,Tue_Open__c=c.Tue_Open__c,Wed_Open__c=c.Wed_Open__c,Thu_Open__c=c.Thu_Open__c,Fri_Open__c=c.Fri_Open__c,Sat_Open__c=c.Sat_Open__c,Sun_Open__c=c.Sun_Open__c,
                                   Mon_Close__c=c.Mon_Close__c,Tue_Close__c=c.Tue_Close__c,Wed_Close__c=c.Wed_Close__c,Thu_Close__c=c.Thu_Close__c,Fri_Close__c=c.Fri_Close__c,Sat_Close__c=c.Sat_Close__c,Sun_Close__c=c.Sun_Close__c));
        }
        //----Create Work Item for Billing Address/Telephone/Fax/Email Change
        if(c.Billing_Address_Telephone_Fax_Email_Chan__c) {
             System.debug('Inside Billing::::::: ');
            RecordType bAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :ChildCaseUtil.OBJ_TYPE and DeveloperName = :ChildCaseUtil.REC_TYP_BILL_ADD_CHG];
            childCases.add(new case(ParentId=c.id,RecordTypeId =bAddrChangeRecType.id,Origin=c.Origin,Plan_ID__c=c.Plan_ID__c,Billing_Address_Telephone_Fax_Email_Chan__c=c.Billing_Address_Telephone_Fax_Email_Chan__c,Street_Address_Suite_No_Billing_Current__c= c.Street_Address_Suite_No_Billing_Current__c,City_Billing_Current__c=c.City_Billing_Current__c,State_Billing_Current__c=c.State_Billing_Current__c,Zip_Billing_Current__c=c.Zip_Billing_Current__c,Telephone_Billing_Current__c=c.Telephone_Billing_Current__c,
                                   Email_Billing_Current__c=c.Email_Billing_Current__c,Fax_Billing_Current__c=c.Fax_Billing_Current__c,Accepting_New_Patients__c=c.Accepting_New_Patients__c,
                                   Street_Address_Suite_No_Billing_New__c=c.Street_Address_Suite_No_Billing_New__c,City_Billing_New__c=c.City_Billing_New__c,State_Billing_New__c=c.State_Billing_New__c,Zip_Billing_New__c=c.Zip_Billing_New__c,Telephone_Billing_New__c=c.Telephone_Billing_New__c,
                                   Fax_Billing_New__c=c.Fax_Billing_New__c,Effective_Date_of_Change_Billing__c=c.Effective_Date_of_Change_Billing__c,Comments_Billing__c=c.Comments_Billing__c));
            
        }
        //----Create Work Item for Credentialing Address/Telephone/Fax/Email Change
        if(c.Credentialing_Address_Telephone_Fax_Emai__c) {
             System.debug('Inside Credentialing::::::: ');
            RecordType cAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :ChildCaseUtil.OBJ_TYPE and DeveloperName = :ChildCaseUtil.REC_TYP_CRED_CHG];
            childCases.add(new case(ParentId=c.id,RecordTypeId =cAddrChangeRecType.id,Origin=c.Origin,Plan_ID__c=c.Plan_ID__c,Credentialing_Address_Telephone_Fax_Emai__c=c.Credentialing_Address_Telephone_Fax_Emai__c,Street_Address_Suite_Credential_Current__c= c.Street_Address_Suite_Credential_Current__c,City_Credential_Current__c=c.City_Credential_Current__c,State_Credential_Current__c=c.State_Credential_Current__c,Zip_Credential_Current__c=c.Zip_Credential_Current__c,Telephone_Credential_Current__c=c.Telephone_Credential_Current__c,
                                   Email_Credential_Current__c=c.Email_Credential_Current__c,Fax_Credential_Current__c=c.Fax_Credential_Current__c,Accepting_New_Patients__c=c.Accepting_New_Patients__c,
                                   Street_Address_Suite_Credential_New__c=c.Street_Address_Suite_Credential_New__c,City_Credential_New__c=c.City_Credential_New__c,State_Credential_New__c=c.State_Credential_New__c,Zip_Credential_New__c=c.Zip_Credential_New__c,Telephone_Credential_New__c=c.Telephone_Credential_New__c,
                                   Email_Credential_New__c=c.Email_Credential_New__c,Fax_Credential_New__c=c.Fax_Credential_New__c,Effective_Date_of_Change_Credential__c=c.Effective_Date_of_Change_Credential__c,Comments_Credential__c=c.Comments_Credential__c));
        }
        //----Administrative Address/Telephone/Fax/Email Change
        if(c.Administrative_Address_Telephone_Fax_Ema__c) {
             System.debug('Inside Administrative::::::: ');
            RecordType aAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :ChildCaseUtil.OBJ_TYPE  and DeveloperName = :ChildCaseUtil.REC_TYP_ADMIN_CHG];
            childCases.add(new case(ParentId=c.id,RecordTypeId =aAddrChangeRecType.id,Origin=c.Origin,Plan_ID__c=c.Plan_ID__c,Administrative_Address_Telephone_Fax_Ema__c=c.Administrative_Address_Telephone_Fax_Ema__c,Street_Address_Administrative_Current__c= c.Street_Address_Administrative_Current__c,City_Administrative_Current__c=c.City_Administrative_Current__c,State_Administrative_Current__c=c.State_Administrative_Current__c,Zip_Administrative_Current__c=c.Zip_Administrative_Current__c,Telephone_Administrative_Current__c=c.Telephone_Administrative_Current__c,
                                   Email_Administrative_Current__c=c.Email_Administrative_Current__c,Fax_Administrative_Current__c=c.Fax_Administrative_Current__c,Accepting_New_Patients__c=c.Accepting_New_Patients__c,
                                   Street_Address_Administrative_New__c=c.Street_Address_Administrative_New__c,City_Administrative_New__c=c.City_Administrative_New__c,State_Administrative_New__c=c.State_Administrative_New__c,Zip_Administrative_New__c=c.Zip_Administrative_New__c,Telephone_Administrative_New__c=c.Telephone_Administrative_New__c,
                                   Email_Administrative_New__c=c.Email_Administrative_New__c,Fax_Administrative_New__c=c.Fax_Administrative_New__c,Effective_Date_of_Change_Administrative__c=c.Effective_Date_of_Change_Administrative__c,Comments_Administrative__c=c.Comments_Administrative__c));
        }
    }
    }
        try {
             System.debug('Before Inserting the Child');
                insert childCases;
             System.debug('After Inserting the Child');
            } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
            }
   } 
}