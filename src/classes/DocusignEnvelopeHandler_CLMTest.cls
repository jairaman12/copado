/**
 * This is the test class for the 'DocusignEnvelopeTrigger_CLM' Trigger and Handler
 * @author Chaitanya Motupalli
 */

@isTest
public class DocusignEnvelopeHandler_CLMTest 
{ 
    static testMethod void testData()
   {
       
       GlobalSettings__c glbs=TestDataFactory_CLM.InsertGlobalsetting();
       
       account acc= TestDataFactory_CLM.CreateAccount('NM1');
       user u=[select Id from user where userrole.Name='Texas Supervisor' AND user.IsActive = true limit 1];
        Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
       //Apttus__APTS_Agreement__c agg= TestDataFactory_CLM.CreateAgreement('Facility','New Mexico','CLM New Mexico');
       Apttus__APTS_Agreement__c agg=new Apttus__APTS_Agreement__c();
      agg.Apttus__Account__c=acc.Id;
      agg.OwnerId=u.Id;
      //agrmt.Plan__c='Illinois';
      agg.Provider_Networks__c=  null;
      agg.recordtypeId=professionalRecordTypeId ;
      //agrmt.Percent_of_Covered_Charges__c= 10;
     insert agg;
     // agrmtList.add(agg);
       
       list<Apttus_DocuApi__DocuSignDefaultRecipient2__c>reclist= TestDataFactory_CLM.CreateDocusignRecipients();
      
      
       agg.Apttus__Status__c='Other Party Signatures';
       agg.Apttus__Status_Category__c='In Signatures';
       update agg;
       
       List< Apttus_DocuApi__DocuSignEnvelope__c> lstDocsignEnv= new List< Apttus_DocuApi__DocuSignEnvelope__c>();
       Apttus_DocuApi__DocuSignEnvelope__c docuSE= new Apttus_DocuApi__DocuSignEnvelope__c();
       docuSE.CLM_E_Signature_Status__c='with provider';
       docuSE.Apttus_DocuApi__EnvelopeId__c='sssss';
       docuSE.Apttus_CMDSign__Agreement__c=agg.id;  
       lstDocsignEnv.add(docuSE);
       insert lstDocsignEnv;
      
       Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c docuSERS= new Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c();
       docuSERS.Apttus_DocuApi__RoleName__c='Signer 1';
       docuSERS.Apttus_DocuApi__Status__c='sent';
       docuSERS.Apttus_DocuApi__DocuSignEnvelopeId__c=docuSE.id;
       docuSERS.Apttus_DocuApi__Email__c='chaitu863@gmail.com';
       insert docuSERS;
       agg.CLM_Agr_E_Signature_Status__c='with provider';
       system.assertEquals('with provider',agg.CLM_Agr_E_Signature_Status__c);
       
       Test.startTest();
       DocusignEnvelopeHandler_CLM.UpdateAgreementEsignatureStatus(lstDocsignEnv);
       Test.stopTest();
       
      
   }
    
    
     static testMethod void testData2()
   {
        GlobalSettings__c glbs=TestDataFactory_CLM.InsertGlobalsetting();
        

        account acc= TestDataFactory_CLM.CreateAccount('NM1');
        
       user u=[select Id from user where userrole.Name='Texas Supervisor' AND user.IsActive = true limit 1];
        Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
       //Apttus__APTS_Agreement__c agg= TestDataFactory_CLM.CreateAgreement('Facility','New Mexico','CLM New Mexico');
       Apttus__APTS_Agreement__c agg=new Apttus__APTS_Agreement__c();
      agg.Apttus__Account__c=acc.Id;
      agg.OwnerId=u.Id;
      //agrmt.Plan__c='Illinois';
      agg.Provider_Networks__c=  null;
      agg.recordtypeId=professionalRecordTypeId ;
      //agrmt.Percent_of_Covered_Charges__c= 10;
     insert agg;
       
        list<Apttus_DocuApi__DocuSignDefaultRecipient2__c>reclist= TestDataFactory_CLM.CreateDocusignRecipients();
        

        agg.Apttus__Status__c='Other Party Signatures';
        agg.Apttus__Status_Category__c='In Signatures';
        update agg;
       
        List< Apttus_DocuApi__DocuSignEnvelope__c> lstDocusigneve= new List< Apttus_DocuApi__DocuSignEnvelope__c>();
        Apttus_DocuApi__DocuSignEnvelope__c docuSE= new Apttus_DocuApi__DocuSignEnvelope__c();
        docuSE.Apttus_DocuApi__Status__c='voided';
        docuSE.Apttus_DocuApi__EnvelopeId__c='sssss';
        docuSE.Apttus_CMDSign__Agreement__c=agg.id;  
        lstDocusigneve.add(docuSE);
        insert lstDocusigneve;
      
        Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c docuSERS= new Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c();
        docuSERS.Apttus_DocuApi__RoleName__c='Signer 1';
        docuSERS.Apttus_DocuApi__Status__c='sent';
        docuSERS.Apttus_DocuApi__DocuSignEnvelopeId__c=docuSE.id;
        docuSERS.Apttus_DocuApi__Email__c='chaitu863@gmail.com';
        insert docuSERS;
        agg.CLM_Agr_E_Signature_Status__c=null;
        system.assertEquals(null,agg.CLM_Agr_E_Signature_Status__c);
       
        Test.startTest();
        DocusignEnvelopeHandler_CLM.ClearAgreementEsignatureStatus(lstDocusigneve);
        Test.stopTest();
        
   }
       
}