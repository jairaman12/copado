public class DataUtility {
public static void insertTestData()
    {
        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        Id entityId,physicianId,personID,rolodexId;
        for(RecordType newRecordType:[Select Id,Name From RecordType Where Name='Entity Account' OR Name='Physician' OR Name='Rolodex' OR Name='Rolodex Affiliation'])
        {
            if(newRecordType.Name=='Entity Account')
            {
                entityId=newRecordType.Id;
            }
            if(newRecordType.Name=='Rolodex')
            {
                personID=newRecordType.Id;
            }
            if(newRecordType.Name=='Rolodex Affiliation')
            {
                rolodexId=newRecordType.Id;
            }
            else
            {
                physicianId=newRecordtype.Id;
            }
        } 
        Account newAccount = new Account();       
        newAccount.Name='Test Account';
        newAccount.CM_Corporate_Entity_Code__c='IL1';
        newAccount.RecordTypeId=entityId;
        insert newAccount;
        
        
        Account physicianDr = new Account();
        physicianDr.firstName='Saravana';
        physicianDr.lastName='Bharathi';
        physicianDr.CM_Corporate_Entity_Code__c='IL1';
        physicianDr.RecordTypeId=physicianId;
        physicianDr.Phone = '9185512503';
        physicianDr.personemail = 'test@abc.com';
        physicianDr.NPI__c = '1234567890';
        physicianDr.Tax_Id__c = '123456789';
        insert physicianDr;
        
        Account personAcc = new Account();
        personAcc.firstName='Test Account Per';
        personAcc.lastName='personAcc';
        personAcc.CM_Corporate_Entity_Code__c='IL1';
        personAcc.RecordTypeId=personID;
        personAcc.personemail = 'test@abc.com';
        personAcc.Phone = '9185512503';
        personAcc.NPI__c = '1234567890';
        personAcc.Tax_Id__c = '123456789';
        insert personAcc;
        
        Account affiliatedAccount = new Account();
        affiliatedAccount.Name='Test Affiliated Account';
        affiliatedAccount.CM_Corporate_Entity_Code__c='IL1';
        affiliatedAccount.RecordTypeId=entityId;
        insert affiliatedAccount;

        
        List<Affiliations__c> listOfAffiliations = new List<Affiliations__c>();
        Affiliations__c newAffiliation = new Affiliations__c ();
        newAffiliation.RecordTypeId = rolodexId;
        newAffiliation.CM_Affiliated_Provider_Name__c=affiliatedAccount.Id;
        newAffiliation.Account__c=newAccount.Id;
        listOfAffiliations.add(newAffiliation);
        
        newAffiliation = new Affiliations__c();
        newAffiliation.RecordTypeId = rolodexId;
        newAffiliation.CM_Affiliated_Provider_Name__c=personAcc.Id;
        newAffiliation.Account__c=newAccount.Id;
        listOfAffiliations.add(newAffiliation);
        
        newAffiliation = new Affiliations__c();
        newAffiliation.RecordTypeId = rolodexId;
        newAffiliation.CM_Affiliated_Provider_Name__c=physicianDr.Id;
        newAffiliation.Account__c=newAccount.Id;
        listOfAffiliations.add(newAffiliation);
        insert listOfAffiliations;
        
        List<CM_SPL_Addr__c> listOfAddress = new List<CM_SPL_Addr__c>();
        CM_SPL_Addr__c billPfin = new CM_SPL_Addr__c ();
        billPfin.CM_SPL_PFIN_No__c='BillPfin';
        billPfin.Bill_PFIN__c='BillPfin';
        billPfin.CM_SPL_Prov__c=newAccount.Id;
        billPfin.CM_SPL_Addr_Type__c='Billing';
        listOfAddress.add(billPfin);
        
        CM_SPL_Addr__c nonbillPfin = new CM_SPL_Addr__c();
        nonbillPfin.CM_SPL_PFIN_No__c='NonBillPfin';
        nonbillPfin.Bill_PFIN__c='BillPfin';
        nonbillPfin.CM_SPL_Prov__c=newAccount.Id;
        nonbillPfin.CM_SPL_Addr_Type__c='Service';
        listOfAddress.add(nonbillPfin);
        
        CM_SPL_Addr__c affiliatedNonBillPfin = new CM_SPL_Addr__c();
        affiliatedNonBillPfin.CM_SPL_PFIN_No__c='AffiliatedPfin';
        affiliatedNonBillPfin.Bill_PFIN__c='BillPfin';
        affiliatedNonBillPfin.CM_SPL_Prov__c=affiliatedAccount.Id;
        affiliatedNonBillPfin.CM_SPL_Addr_Type__c='Billing';
        listOfAddress.add(affiliatedNonBillPfin);
        
         CM_SPL_Addr__c billingAddress = new CM_SPL_Addr__c();
        billingAddress.CM_SPL_Addr_Line_1__c='Test add1';
        billingAddress.CM_SPL_Add_Line_2__c='Test add2';
        billingAddress.CM_SPL_City__c ='test city';
        billingAddress.CM_SPL_State__c='test state';
        billingAddress.CM_SPL_Zip_CD__c='234234';
        billingAddress.CM_SPL_Mobile_No__c='1234565435';
        billingAddress.CM_SPL_Email__c='abc@dc.com';
        billingAddress.CM_SPL_Fax_No__c='fax12345';
        billingAddress.CM_SPL_Addr_Type__c='Billing';
        billingAddress.CM_SPL_PFIN_No__c='BillPfin';
        billingAddress.Bill_PFIN__c='BillPfin';
        billingAddress.CM_SPL_Prov__c=personAcc.Id;        
        listOfAddress.add(billingAddress);
        
        CM_SPL_Addr__c serviceLocationAddress = new CM_SPL_Addr__c();
        serviceLocationAddress.CM_SPL_Addr_Line_1__c='Test add1';
        serviceLocationAddress.CM_SPL_Add_Line_2__c='Test add2';
        serviceLocationAddress.CM_SPL_City__c ='test city';
        serviceLocationAddress.CM_SPL_State__c='test state';
        serviceLocationAddress.CM_SPL_Zip_CD__c='234234';
        serviceLocationAddress.CM_SPL_Mobile_No__c='1234565435';
        serviceLocationAddress.CM_SPL_Email__c='abc@dc.com';
        serviceLocationAddress.CM_SPL_Fax_No__c='fax12345';
        serviceLocationAddress.CM_SPL_Addr_Type__c='Service';
        serviceLocationAddress.CM_SPL_PFIN_No__c='BillPfin';
        serviceLocationAddress.Bill_PFIN__c='BillPfin';
        affiliatedNonBillPfin.CM_SPL_Prov__c=physicianDr.Id;        
        listOfAddress.add(serviceLocationAddress);
        
        
        
          CM_SPL_Addr__c credentialingAddress = new CM_SPL_Addr__c();
        credentialingAddress.CM_SPL_Addr_Line_1__c='Test add1';
        credentialingAddress.CM_SPL_Add_Line_2__c='Test add2';
        credentialingAddress.CM_SPL_City__c ='test city';
        credentialingAddress.CM_SPL_State__c='test state';
        credentialingAddress.CM_SPL_Zip_CD__c='234234';
        credentialingAddress.CM_SPL_Mobile_No__c='1234565435';
        credentialingAddress.CM_SPL_Email__c='abc@dc.com';
        credentialingAddress.CM_SPL_Fax_No__c='fax12345';
        credentialingAddress.CM_SPL_Addr_Type__c='Credentialing';
        credentialingAddress.CM_SPL_PFIN_No__c='BillPfin';
        credentialingAddress.Bill_PFIN__c='BillPfin';
        affiliatedNonBillPfin.CM_SPL_Prov__c=affiliatedAccount.Id;        
        listOfAddress.add(credentialingAddress);
        
         CM_SPL_Addr__c adminAddress = new CM_SPL_Addr__c();
        adminAddress.CM_SPL_Addr_Line_1__c='Test add1';
        adminAddress.CM_SPL_Add_Line_2__c='Test add2';
        adminAddress.CM_SPL_City__c ='test city';
        adminAddress.CM_SPL_State__c='test state';
        adminAddress.CM_SPL_Zip_CD__c='234234';
        adminAddress.CM_SPL_Mobile_No__c='1234565435';
        adminAddress.CM_SPL_Email__c='abc@dc.com';
        adminAddress.CM_SPL_Fax_No__c='fax12345';
        adminAddress.CM_SPL_Addr_Type__c='Administration';
        adminAddress.CM_SPL_PFIN_No__c='BillPfin';
        adminAddress.Bill_PFIN__c='BillPfin';
        affiliatedNonBillPfin.CM_SPL_Prov__c=physicianDr.Id;        
        listOfAddress.add(adminAddress);
       
        
        
        insert listOfAddress;
    }
}