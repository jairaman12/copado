/**
 * This apex class provides methods to create test data for Apttus CLM flow.
 * Created By - Kushal Bhalodiya
 * Created Date - 16th Oct, 2018
 * Modified By - 
 * Modified Date - 
 */
 public class APTS_CLMTestUtility {

    /*Create Comply System Properties*/
    public static Apttus__ComplySystemProperties__c createComplySystemProp()
    {
        Apttus__ComplySystemProperties__c sysProp = new Apttus__ComplySystemProperties__c(
        Name = 'System Properties',
        Apttus__AllowPDFSelectionOverride__c = true,
        Apttus__AllowPrivateSelectionOverride__c = true,
        Apttus__AllowReconcileSelectionOverride__c = true,
        Apttus__AutoEnablePDFForFinalDocs__c = true,
        Apttus__AutoEnablePrivateIndicator__c = false,
        Apttus__AutoEnableReconciliation__c = true,
        Apttus__AutoInsertHeaderFooterData__c = false,
        Apttus__BypassSharing__c = false,
        Apttus__DefaultOpportunityAgreementOwner__c = 'Opportunity Owner',
        Apttus__DocumentStructureFX2ForImportedDocs__c = true,
        Apttus__EnableClauseApprovals__c = false,
        Apttus__EnableDocumentVersioning__c = false,
        Apttus__EnableMergeCallDebug__c = false,
        Apttus__EnableMultipleCheckout__c = false,
        Apttus__EnablePDFSecurity__c = false,
        Apttus__EnableSubmitMergeCall__c = true,
        Apttus__EnableTemplateVersioning__c = true,
        Apttus__EnableVersionControl__c = true,
        Apttus__HideContentControlBorder__c = false,
        Apttus__InstanceUrl__c = System.Url.getSalesforceBaseUrl().toExternalForm(),
        Apttus__MergeCallTimeoutMillis__c = 60000.0,
        Apttus__MergeWebserviceEndpoint__c = 'https://mergews.apttus.net/cgi-bin/MergeServer/Bin/MMCGI.exe',
        Apttus__PublishAuthorEvents__c = false,
        Apttus__PublishMergeEvents__c = true,
        Apttus__UseAgreementLocksForVersioning__c = false,
        Apttus__UseLongQuestionsInWizard__c = false,
        Apttus_CMDSign__AutoSelectAttachment__c = false,
        Apttus_CMDSign__AutoSelectMultipleRecipients__c = true,
        Apttus_CMDSign__ESignatureStrictMode__c = false,
        Apttus_CMDSign__EnableDocumentPreviewInDocuSign__c = true,
        Apttus_CMDSign__FilterRSPCByPrimaryAgreementStatus__c = false,
        Apttus_CMDSign__OneClickSend__c = true,
        Apttus_CMDSign__SelectAllAttachments__c = false,
        Apttus_CMDSign__SelectAttachmentsFromRSPCAgreements__c = false,
        Apttus_CMDSign__UpdateRSPCAgreementStatus__c = false,
        Apttus__EnableFile__c = true,
        Apttus__UnlockSmartElements__c = false);
        
        return sysProp;

    }
    
    /*Create Account*/
    public static Account createAccount()
    {
        Account accSO = new Account(
        Name = 'Agreement',
        Type = 'ANCMEDGP',
        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity Account').getRecordTypeId(),
        CM_Corporate_Entity_Code__c = 'NM1',
        Designation__c = 'NPI Ready',
        Directory_Exclusion__c = false,
        Prov_ID__c = '142534695',
        Status__c = 'Active',
        Class__c = 'C',
        Organization_Type__c = 'ANCMEDGP');
        return accSO;
    }
    
    /*Create Contact*/
    public static Contact createContact()
    {
        Contact conSO = new Contact(
        LastName = 'Test Contact',
        FirstName = 'First Con',
        MailingStreet = '10912 Broad Green Ter',
        MailingCity = 'Potomac',
        MailingState = 'MD',
        MailingPostalCode = '20854',
        MailingCountry = 'USA',
        Email = 'example@testemail.com');
        return conSO;  
    }
    
    
    /*Create Agreement*/
    public static List<Apttus__APTS_Agreement__c> createAgreement(Id conId, Id accountId, Integer count) {

        List<Apttus__APTS_Agreement__c> newAgreementsList = new List<Apttus__APTS_Agreement__c>();
        Apttus__APTS_Agreement__c aptContract;
        do
        {
                aptContract = new Apttus__APTS_Agreement__c(recordtypeid = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('ASC').getRecordTypeId(),
                Name = 'Agreement',
                Apttus__Primary_Contact__c = conId,
                Apttus__Agreement_Category__c = 'Standard',
                Apttus__Account__c = accountId);
                newAgreementsList.add(aptContract);
                count --;
        }
        while(count > 0);
        
        return newAgreementsList;

    }
    
    
    /* create attachment with body*/
    public static List<Attachment> createAttachmentWithBody(List<Apttus__APTS_Agreement__c> agreementList,String name) {

        List<Attachment> attachList = new List<Attachment>();
        Attachment attachSO;
        for(Apttus__APTS_Agreement__c agreeSO : agreementList)
        {
            attachSO = new Attachment();
            attachSO.ParentID = agreeSO.ID;
            attachSO.Name = name;
            Blob bodyBlob = Blob.valueOf('Test Body');
            attachSO.Body = bodyBlob;
            attachList.add(attachSO);
        }
        return attachList;
    }
    
    /*Create Template*/
    public static Apttus__APTS_Template__c createTemplate()
    {
        
        Apttus__APTS_Template__c templateSO = new Apttus__APTS_Template__c(
        Name = Label.APTS_Amendment_Template,
        Apttus__Agreement_Types__c = 'Default;ASC;Facility;Medical Group;Non-ASC Ancillary;Professional',
        Apttus__BusinessObject__c = 'Apttus__APTS_Agreement__c',
        Apttus__Category__c = 'Default',
        Apttus__EnableAgreementClauseTracking__c = false,
        Apttus__FrameworkFormat__c = 'FX2',
        Apttus__IsActive__c = true,
        Apttus__IsTransient__c = false,
        Apttus__Language__c = 'English',
        Apttus__Locale__c = 'English (United States)',
        Apttus__Mergefields2__c = 'Apttus__APTS_Agreement__c (Name, Apttus__Account__c, Apttus__FF_Agreement_Number__c); Account (Name, AccountNumber);',
        Apttus__Mergefields__c = 'Apttus__APTS_Agreement__c (Name, Apttus__Account__c, Apttus__FF_Agreement_Number__c); Account (Name, AccountNumber);',
        Apttus__NeedsPublishing__c = false,
        Apttus__Subcategory__c = 'Default',
        Apttus__Type__c = 'Agreement',
        Use_for_MassAmend__c = false);
        return templateSO;
    }
    
    /* create attachment with body*/
    public static Attachment createTemplateAttachmentWithBody(ID templateID ,String name) {
        Attachment attachSO;
        attachSO = new Attachment();
        attachSO.ParentID = templateID;
        attachSO.Name = name;
        Blob bodyBlob = Blob.valueOf('Test Body');
        attachSO.Body = bodyBlob;
        return attachSO;
    }
    
    /* create Mass Amendment Agreements*/
    public static Mass_Amendment_Agreements__c createMassAmendmentAgreements(ID testAgreement, ID originalAgreement) {
        Mass_Amendment_Agreements__c massagreements = new Mass_Amendment_Agreements__c(
        Amended_Agreement__c = testAgreement,
        Original_Agreement__c = originalAgreement,
        Signature_Type__c = 'Wet');
        return massagreements;
    }
    
    /*Create Mass Agreement*/
    public static Apttus__APTS_Agreement__c createMassAgreement(Id conId, Id accountId, Integer count) {
        Apttus__APTS_Agreement__c agreementSO = new Apttus__APTS_Agreement__c(
        Name = 'test',
        RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Mass Amendment').getRecordTypeId(),
        Apttus__Account_Search_Field__c = 'Mass Amend Agreement.0',
        Apttus__Account__c = accountId,
        Apttus__Agreement_Number__c = '00000550',
        Apttus__Amendment_Effective_Date__c = Date.newInstance(2018,10,22),
        Apttus__Auto_Renew_Consent__c = false,
        Apttus__Auto_Renewal__c = false,
        Apttus__Description__c = 'ts',
        Apttus__Initiation_Type__c = 'Negotiate Contract',
        Apttus__IsInternalReview__c = false,
        Apttus__IsLocked__c = false,
        Apttus__Is_System_Update__c = false,
        Apttus__Non_Standard_Legal_Language__c = false,
        Apttus__Owner_Expiration_Notice__c = '90 Days',
        Apttus__Perpetual__c = false,
        Apttus__Requestor__c = UserInfo.getUserId(),
        Apttus__Source__c = 'Internal Paper',
        Apttus__Status_Category__c = 'Request',
        Apttus__VersionAware__c = false,
        Apttus__Version_Number__c = 0.0,
        Apttus__Version__c = 0.0,
        Apttus__Workflow_Trigger_Created_From_Clone__c = false,
        Apttus__Workflow_Trigger_Viewed_Final__c = false,
        Apttus_Approval__Approval_Status__c = 'Not Submitted',
        Apttus_Approval__Term_Exception_Approval_Status__c = 'Not Submitted',
        BA_IP_Max_Reimb_Allowance_Per_Diem__c = 1250.0,
        BA_BP_IP_Hospital_Services_per_diem__c = 554.0,
        MA_HMO_lesser_of_of_Covered__c = 100.0,
        Blue_Salud__c = 3313.59,
        ICR__c = 1872.13,
        Stoploss_Threshold__c = 100000.0,
        Stoploss_Reimbursement_Rate__c = 4100.0,
        Excluded_Services_Per_Treatment_Amount__c = 375.0,
        Legal_Hold__c = false,
        BA_BP_Residential_Treat_Srvcs_per_diem__c = 362.0,
        BAdv_Max_Reimb_Allowed_Resid_Treat_Srvcs__c = 309.0,
        BChoice_Max_Reimb_Allow_Resid_Treat_Srvc__c = 364.0,
        Initial_HMO_Attachment_Term_years__c = 'one (1) year',
        BPref_Max_Reimb_Allowed_Resid_Treat_Srvc__c = 309.0,
        Charge_Master_Max_Increase_percent__c = 'zero percent (0%)',
        Blue_Advantage_PPO_Lab_Conversion_Factor__c = 'nineteen dollars and forty-eight cents ($19.48)',
        Blue_Advantage_PPO_SNF_Max_Per_Diem__c = 'three hundred forty dollars ($340.00)',
        Blue_Traditional_Lab_Conversion_Factor__c = 'twenty-five dollars and twenty-nine cents ($25.29)',
        BlueChoice_PPO_Lab_Conversion_Factor__c = 'twenty-four dollars and seventy-six cents ($24.76)',
        BlueLincs_HMO_Lab_Conversion_Factor__c = 'nineteen dollars and forty-eight cents ($19.48)',
        BlueLincs_HMO_SNF_Max_Per_Diem__c = 'three hundred sixty-five dollars ($365.00)',
        BluePreferred_PPO_Lab_Conversion_Factor__c = 'twenty-three dollars and seventeen cents ($23.17)',
        BlueTrad_Choice_Pref_SNF_Max_Per_Diem__c = 'four hundred twenty-five dollars ($425.00)',
        DME_Purchase_pre_auth_cap_amount__c = 'four thousand dollars ($4,000.00)',
        DME_Rental_Fee_pre_auth_cap_amount__c = 'four thousand dollars ($4,000.00)',
        RBRVS_Publication_Location__c = 'Federal Register Volume 80 No. 220 (dated November 16, 2015)',
        Initial_MedicareSelect_Attach_Term_yrs__c = 'one (1) year',
        Initial_PPO_Attachment_Term_years__c = 'one (1) year',
        Initial_Term_years__c = '3',
        IP_Max_Reimbursement_Allowance_Per_Diem__c = 1350.0,
        MA_HMO_lesser_of_of_Medicare_allowed__c = 100.0,
        MA_PPO_lesser_of_of_Covered__c = 100.0,
        MA_PPO_lesser_of_of_Medicare_allowed__c = 100.0,
        Initial_Medicare_Select_Attachment_Term__c = 'one (1) year',
        Provider_Credentialed__c = false,
        Medicd_Untimed_PerUnit_OP_rehab_exceptn__c = 75.0,
        BAdv_Untimed_PerUnit_OP_rehab_exceptn__c = 75.0,
        BComm_Untimed_PerUnit_OP_rehab_exceptnv__c = 75.0,
        BPref_Untimed_PerUnit_OP_rehab_exceptn__c = 75.0,
        APTSMD_MassAmended__c = false,
        Payment_Terms__c = '30',
        SLA__c = false,
        Plan_1st_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        Plan_2nd_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        Plan_3rd_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        PPO_1st_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        PPO_2nd_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        PPO_3rd_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        HMO_2nd_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        HMO_3rd_Charge_Schedule_Increase_Cap__c = 'zero percent (0%)',
        HMO_of_Billed_Chges_for_Cvd_Svcs__c = '0.0');
        return agreementSO;
    }
}