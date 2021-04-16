public with sharing class APTSCU_MassAmendmentAngularController {
    public List<Apttus__APTS_Agreement__c> listDisplayAgreement{get;set;}
    public List<Apttus__APTS_Agreement__c> listFilteredAgreement{get;set;}
    public Apttus__APTS_Agreement__c myAgreement {get;set;}  //for search purpose
    
    //pagination
    public List<APTSMD_AgreementWrapper> lstWrapper {get;set;}
    public List<APTSMD_AgreementWrapper> lstSetController{get;set;}
    APTSMD_CustomIterableAgreement obj;
    
    //agreement fields in form
    public Apttus__APTS_Agreement__c agreementToChange {get;set;}    
       
    public List<id> agreementIdsToGenerate; //store newly created agreements ids so we know which agreement to generate doc on.
    
    public boolean readyToGenerate {get;set;} //controls button display
    
    public Set<String> contactSet {get;set;} //store primarycontacts
    
    public String agreementString {get;set;}
    
    public string amendedAgreementString {get;set;}
    
    public List<Apttus__APTS_Agreement__c> newAgreementList {get;set;} //store agreements to display after amend, both old and new
    
    public String newAgreementListJSON {get;set;}
    
    public List<Apttus__APTS_Agreement__c> deserializedAgreements;
    
    public List<String> agreementNames = new List<String>();
    
    public static String finalAgreements = 'a';
    
    public string selectedtype{get;set;}    //Store amendment type "Send/Review"
    
    public Set<Id> finalDisplayIds{get;set;}
    public Set<Id> idsToHighlight;
    public String idString{get;set;}
    Boolean noRecordsSelected = false;
    
    // @Chintan - Added for dynamic filter
    public String expressioncrtJSON {get; set;}
    public String expressionpliJSON {get; set;}
    //public string operatorTypes{get;set;}
    public string agreementIds{get;set;}
    public static Map<String, Integer> objectAPIToCount = new Map<String, Integer>();
        
    public APTSCU_MassAmendmentAngularController(ApexPages.StandardSetController  controller) {
        deserializedAgreements = new List<Apttus__APTS_Agreement__c>();
        deserializedAgreements = (List<Apttus__APTS_Agreement__c>)controller.getSelected();
        for(Apttus__APTS_Agreement__c lstObj : deserializedAgreements){
            lstObj.Selected__c = true;
        }
        if(deserializedAgreements.size() == 0){
            noRecordsSelected = true;
        }
        
        /*List<String> operatorList = new List<String>();
        operatorList.add('=');
        operatorList.add('!=');
        operatorList.add('<');
        operatorList.add('>');
        operatorList.add('<=');
        operatorList.add('>=');
        operatorList.add('Contains');
        operatorTypes=JSON.serialize(operatorList);
        */
        
        List<expressionWrapper> expforquote = new List<expressionWrapper>();
        expressionWrapper expfor = new expressionWrapper();
        expforquote.add(expfor);
        expressioncrtJSON=JSON.serialize(expforquote);
        expressionpliJSON=JSON.serialize(expforquote);
    }
    
    public APTSCU_MassAmendmentAngularController(ApexPages.StandardController controller) {
        
        //initialize value
        myAgreement = new Apttus__APTS_Agreement__c();
        lstWrapper =  new List<APTSMD_AgreementWrapper>();
        lstSetController = new List<APTSMD_AgreementWrapper>();
        agreementToChange = new Apttus__APTS_Agreement__c();
        readyToGenerate = false;
        agreementIdsToGenerate = new List<id>();
        contactSet = new Set<String>();
        newAgreementList = new List<Apttus__APTS_Agreement__c>();
        finalAgreements = 'a';
        finalDisplayIds = new Set<id>();
        idsToHighlight = new Set<Id>();
        deserializedAgreements = new List<Apttus__APTS_Agreement__c>();
 
       /* List<String> operatorList = new List<String>();
        operatorList.add('=');
        operatorList.add('!=');
        operatorList.add('<');
        operatorList.add('>');
        operatorList.add('<=');
        operatorList.add('>=');
        operatorList.add('Contains');
        operatorTypes=JSON.serialize(operatorList);
*/
            
        List<expressionWrapper> expforquote = new List<expressionWrapper>();
        expressionWrapper expfor = new expressionWrapper();
        expforquote.add(expfor);
        expressioncrtJSON=JSON.serialize(expforquote);
        expressionpliJSON=JSON.serialize(expforquote);
            
            
        //set default values of agreementtochange
        agreementToChange.Apttus__Contract_Start_Date__c = system.today();
        agreementToChange.Apttus__Contract_End_Date__c = system.today().addYears(1);
        agreementToChange.Apttus__Amendment_Effective_Date__c = system.today().addDays(5);
        //display all agreement
        
        /*Map<Id, Apttus__APTS_Agreement__c> mapOfAgreements = new Map<Id, Apttus__APTS_Agreement__c>();
        mapOfAgreements = new Map<Id, Apttus__APTS_Agreement__c>([Select Id,RecordType.Name,Apttus__FF_Agreement_Number__c,Name,Apttus__Contract_Start_Date__c,SLA__c,
                           Apttus__Contract_End_Date__c,Apttus__Total_Contract_Value__c,
                           Apttus__Auto_Renewal__c,Payment_Terms__c, Apttus__Internal_Renewal_Notification_Days__c,
                           Optional_Monthly_Notification_Limit__c, Apttus__Related_Opportunity__r.Name,
                           Apttus__Related_Opportunity__c, Apttus__Status_Category__c, Apttus__Primary_Contact__c, Apttus__Primary_Contact__r.Name,
                           Apttus__Account__c,  Apttus__Version_Number__c,
                           Apttus__Status__c, Apttus_Approval__Approval_Status__c, Apttus_Approval__Term_Exception_Approval_Status__c,
                           APTPS_Region__c, Support_Exhibits__c, Selected__c,
                           Annual_Uplift__c, Apttus__Special_Terms__c, Amended_Terms__c, Apttus__Amendment_Effective_Date__c
                           From Apttus__APTS_Agreement__c WHERE ((Apttus__Status_Category__c = 'In Effect' AND Apttus__Status__c = 'Activated') OR (Apttus__Status_Category__c = 'Expired' AND Apttus__Status__c = 'Expired') OR (Apttus__Status_Category__c = 'Terminated' AND Apttus__Status__c = 'Terminated')) ORDER BY Apttus__FF_Agreement_Number__c]);*/
        
        agreementIds = '';
        /*for(Id agmtId : mapOfAgreements.keySet()){
            agreementIds += +agmtId+',';
        }
        if(agreementIds.length() > 0)
        agreementIds = agreementIds.substring(0, agreementIds.length()-1);
        */
        /*listDisplayAgreement = new List<Apttus__APTS_Agreement__c>();
        listDisplayAgreement.addAll(mapOfAgreements.values());*/
        //agreementString = JSON.serialize(listDisplayAgreement);
        agreementString = '[]';
    }

    public pageReference onClickAmend(){
        return null;
    }
    
    public pageReference deleteAgreement(){
    String newAgreementString = ApexPages.currentPage().getParameters().get('myParam');
        List<Apttus__APTS_Agreement__c> deserializedAgreements = (List<Apttus__APTS_Agreement__c>)JSON.deserialize(newAgreementString, List<Apttus__APTS_Agreement__c>.class);
      for(Apttus__APTS_Agreement__c agrW : deserializedAgreements){
            if(agrW.Selected__c){
                delete agrW;
            }
        }
        String previousURL=ApexPages.currentPage().getHeaders().get('Referer');
        return new pagereference(previousURL); 
    }
    
    public pagereference doMassAmend(){
        
        if(noRecordsSelected){
            String previousURL = ApexPages.currentPage().getHeaders().get('Referer');
            return new pageReference(previousURL);
        }
            
        
        Apttus__APTS_Agreement__c thisAgreement;
        Apttus__APTS_Agreement__c oldAgr;
        /*
         *  @Chintan - Agreement object for Mass Amend Agreement
         */
        Apttus__APTS_Agreement__c objParentMassAmendAgmt = new Apttus__APTS_Agreement__c();
        Mass_Amendment_Agreements__c objMassAmendAgmt;
        List<Mass_Amendment_Agreements__c> lstMassAmendAgmt = new List<Mass_Amendment_Agreements__c>();
        
        String newAgreementString = ApexPages.currentPage().getParameters().get('myParam');
        String myEffectiveDate = ApexPages.currentPage().getParameters().get('myEffectiveDate');
        String myAgmtName = ApexPages.currentPage().getParameters().get('myAgmtName');
        String myDesc = ApexPages.currentPage().getParameters().get('myDesc');
        String agmtAmendmentNumber = ApexPages.currentPage().getParameters().get('agmtAmendmentNumber');
        String agmtAmendmentWhereasText = ApexPages.currentPage().getParameters().get('agmtAmendmentWhereasText');
        String agmtAmendmentLanguage = ApexPages.currentPage().getParameters().get('agmtAmendmentLanguage');
        
        
        
        if(deserializedAgreements == null || deserializedAgreements.size() == 0){
            deserializedAgreements = (List<Apttus__APTS_Agreement__c>)JSON.deserialize(newAgreementString, List<Apttus__APTS_Agreement__c>.class);
        }
        idsToHighlight = new Set<Id>();
        
        
        objParentMassAmendAgmt.Apttus__Account__c = [select id from account where name = :Label.APTS_Mass_Amend_Agreement].Id; // Account ID of 'Mass Amend Agreement'
        objParentMassAmendAgmt.name = myAgmtName; //'Mass Amendment Agreement : '+Datetime.now();
        objParentMassAmendAgmt.RecordTypeID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Mass Amendment').getRecordTypeId(); //'01236000000Ojhc'; // Id for Agreement Record Type : Mass Amendement
        objParentMassAmendAgmt.Apttus__Description__c = myDesc;
        
        objParentMassAmendAgmt.Amendment_Number__c = agmtAmendmentNumber;
        objParentMassAmendAgmt.Amendment_Whereas_Text__c = agmtAmendmentWhereasText;
        objParentMassAmendAgmt.Amendment_Language__c = agmtAmendmentLanguage;
        
        String[] effectiveDate = myEffectiveDate.split('-');
        objParentMassAmendAgmt.Apttus__Amendment_Effective_Date__c = date.parse(effectiveDate[1].replaceAll('"', '')+'/'+effectiveDate[2].replaceAll('"', '')+'/'+effectiveDate[0].replaceAll('"', ''));
        
        List<Apttus__APTS_Agreement__c> selectedAgmtList = new List<Apttus__APTS_Agreement__c>();
        List<Apttus__APTS_Agreement__c> lstOfAgreementsForMassAmend = new List<Apttus__APTS_Agreement__c>();
        Set<ID> setOfSelectedAgmts = New Set<ID>();
        for(Apttus__APTS_Agreement__c agrW : deserializedAgreements){
            if(agrW.Selected__c){
                setOfSelectedAgmts.add(agrW.Id);
                selectedAgmtList.add(agrW);
            }
        }
        
        List<Apttus__APTS_Agreement__c> updateOldAgmtList = new List<Apttus__APTS_Agreement__c>();
        Map<ID, Apttus__APTS_Agreement__c> mapOfSelectedAgmts;
        if(setOfSelectedAgmts.size() > 0){
            mapOfSelectedAgmts = new Map<ID, Apttus__APTS_Agreement__c>([Select id, Apttus__Status__c, Apttus__Version_Number__c, Apttus__Status_Category__c,Apttus__Primary_Contact__c,Apttus__Agreement_Number__c, name from Apttus__APTS_Agreement__c where id in: setOfSelectedAgmts]);
        }
        //go through all agreements and find the selected ones
        for(Apttus__APTS_Agreement__c agrW : selectedAgmtList){

                //--Change old agreements to superseded--
                oldAgr = new Apttus__APTS_Agreement__c();
                oldAgr = mapOfSelectedAgmts.get(agrW.Id);
                oldAgr.Apttus__Status__c = 'Superseded';
                oldAgr.Apttus__Status_Category__c = 'Amended';
                updateOldAgmtList.add(oldAgr);
                
                /*
                 *  @Chintan - 
                 */
                objMassAmendAgmt = new Mass_Amendment_Agreements__c();
                objMassAmendAgmt.Amended_Agreement__c = oldAgr.id;
                objMassAmendAgmt.Signature_Type__c = 'Wet';
                lstMassAmendAgmt.add(objMassAmendAgmt);
        }
        if(updateOldAgmtList.size() > 0){
            update updateOldAgmtList;
        }
        
        if(lstMassAmendAgmt.size() > 0){
            insert objParentMassAmendAgmt;
            
            for(Mass_Amendment_Agreements__c objMassAmend : lstMassAmendAgmt){
                objMassAmend.Original_Agreement__c = objParentMassAmendAgmt.Id;
            }
            insert lstMassAmendAgmt;
        }
        return new pageReference('/'+objParentMassAmendAgmt.Id);
    }
    
    public void populateNewAgreementList(){
    
    
        newAgreementList.clear();
        newAgreementList = [Select Id,RecordType.Name,Apttus__Agreement_Number__c,Name,Apttus__Contract_Start_Date__c,SLA__c,
                           Apttus__Contract_End_Date__c,Apttus__Total_Contract_Value__c,
                           Apttus__Auto_Renewal__c,Payment_Terms__c, Apttus__Internal_Renewal_Notification_Days__c,
                           Optional_Monthly_Notification_Limit__c, Apttus__Related_Opportunity__r.Name,
                           Apttus__Related_Opportunity__c, Apttus__Status_Category__c, Apttus__Primary_Contact__c, Apttus__Primary_Contact__r.Name,
                           Apttus__Account__c,  Apttus__Version_Number__c,
                           Apttus__Status__c, Apttus_Approval__Approval_Status__c, Apttus_Approval__Term_Exception_Approval_Status__c,
                           APTPS_Region__c,  Support_Exhibits__c, Selected__c,
                           Annual_Uplift__c, Apttus__Special_Terms__c, Amended_Terms__c, Apttus__Amendment_Effective_Date__c
                           From Apttus__APTS_Agreement__c WHERE Id In :finalDisplayIds ORDER BY Apttus__Agreement_Number__c]; 
                           
       amendedAgreementString = JSON.serialize(newAgreementList);
       newAgreementListJSON = JSON.serialize(newAgreementList);
       idString = String.join(new List<Id>(idsToHighlight),',');
    }
    public void doGenerate()
    {
        String sessionId = userInfo.getSessionId();
        for(String tempId : agreementIdsToGenerate){
            generateDocument(tempId, sessionId);
        }
        //send email if primary contact is not empty
        for(String temp : contactSet){
            SendEmail(temp); 
        }        
    }



    @future(callout=true)
    public static void generateDocument(Id recordId, String sessionId)
    {
        Apttus__APTS_Template__c templateAmendment;
        Id generatedDocId; //return value
         
        //Finds correct template to use based on checkbox 'Use for MassAmend'
        
        try{
            templateAmendment = [SELECT Id, Name FROM Apttus__APTS_Template__c WHERE (Use_for_MassAmend__c = TRUE AND Apttus__IsActive__c = TRUE) LIMIT 1];
        }catch(exception ex){
            throw ex;
        }
        
        Id templateId = templateAmendment.Id;
        String accessLevel = 'Insert comments and tracked changes only';    
        String docFormat = 'DOCX';   
        String apiServerURL = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
        try{
        
            if(!Test.isRunningTest())
            {
                generatedDocId = Apttus.MergeWebService.generateDoc(templateId, recordId, accessLevel, docFormat, sessionId, apiServerURL);
            }
        }catch(exception ex){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error while generating the document. Please make sure that your template exists and is correct.'));
        }
        
    }
    
    
    public void sendEmail(String contactId)
    {
        
        try{
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(contactId);
        mail.setSubject('Agreements Successfully Amended');
        String body = 'Dear ' + userinfo.getName() + ', <br/><br/>These following agreements are sucessfully amended: ';
        for(String s:agreementNames){
            body = body + '<br/>' + s;
        }
        
        body = body + '<br/></br>Changed terms:<br/>';
        if(agreementToChange.Apttus__Contract_Start_Date__c != null){
            body = body + 'Agreement Start Date: ' + agreementToChange.Apttus__Contract_Start_Date__c + '<br/>';
        }
        if(agreementToChange.Apttus__Contract_End_Date__c != null){
            body = body + 'Agreement End Date: ' + agreementToChange.Apttus__Contract_End_Date__c + '<br/>';
        }
        if(agreementToChange.Apttus__Amendment_Effective_Date__c != null){
            body = body + 'Amendment Effective Date: ' + agreementToChange.Apttus__Amendment_Effective_Date__c + '<br/>';
        }
        if(agreementToChange.Amended_Terms__c != null){
            body = body + 'Amended Terms: ' + agreementToChange.Amended_Terms__c + '<br/>';
        }
        mail.setHTMLBody(body);
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if (!results.get(0).isSuccess()) {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            String errorMessage = results.get(0).getErrors()[0].getMessage();
        }
        }catch(EmailException e){
          
        }
     }
     
     /*
      * @Chintan
      * Get all the fields of Object (API Name passed in parameter)
      */
    @RemoteAction
    public static List<Map<String,String>> getObjectFields(String objectAPIName){
        List<Map<String,String>> fieldMap;
        try{
            fieldMap= getAllFields(objectAPIName);
        }catch(Exception e){}
        return fieldMap;
    }
    
    public static List<Map<String,String>> getAllFields(String objectName){
        String selects = '';
     
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        Map<String,String>  selectFields = new Map<String,String> ();
        List<Map<String,String>> mapList = new List<Map<String,String>>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                String APIName = String.valueOf(fd.getReferenceTo());
                APIName = APIName.substring(1,APIName.length()-1);
                if(fd.getType()+'' == 'REFERENCE' && APIName != '' && APIName != 'Group, User' && getRecordCount(APIName) > 50000 && String.valueOf((fd.getName()+'')).toLowerCase().right(2) == 'id')
                    selectFields.put(fd.getLabel(),(fd.getName()+'').toLowerCase().removeEnd('id')+'.Name');
                else if(fd.getType()+'' == 'REFERENCE' && APIName != '' && APIName != 'Group, User' && getRecordCount(APIName) > 50000 && String.valueOf((fd.getName()+'')).toLowerCase().right(2) == '_c')
                    selectFields.put(fd.getLabel(),(fd.getName()+'').toLowerCase().removeEnd('_c')+'_r.Name');
                else
                    selectFields.put(fd.getLabel(),fd.getName());
            }
        }
        Map<String,String> fieldTypeMap = getAllFieldType(objectName);
        Map<String,String> referenceMap = getReferenceAPIMap(objectName);
        mapList.add(selectFields);
        mapList.add(fieldTypeMap);
        mapList.add(referenceMap);
        return mapList;
    }
    
    public static Map<String,string> getAllFieldType(String stype){
        Schema.SObjectType objectName = Schema.getGlobalDescribe().get(stype);
        Schema.DescribeSObjectResult objectDescribe =objectName.getDescribe();
        string  objectLabel=objectDescribe.getLabel(); 
        
        // code to get reference fields,all fields of object - start 
        Map<String,String> referenceMap = new Map<String,String>();
        Map<String,String> referenceLabel = new Map<String,String>();
        
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(stype.toLowerCase()).getDescribe().Fields.getMap();
        
        list<string> allFields = new list<string>();
        
        Map<String,String> attributeFieldMap = new Map<String,String>();
        Map<String,Schema.DisplayType> attributeFieldTypeMap = new Map<String,Schema.DisplayType>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                String APIName = String.valueOf(fd.getReferenceTo());
                APIName = APIName.substring(1,APIName.length()-1);
                if(fd.getType()+'' == 'REFERENCE' && APIName != '' && APIName != 'Group, User' && getRecordCount(APIName) > 50000 && String.valueOf((fd.getName()+'')).toLowerCase().right(2) == 'id')
                    referenceMap.put(String.valueOf((fd.getName()+'').toLowerCase().removeEnd('id')+'.Name'),'STRING');                
                else if(fd.getType()+'' == 'REFERENCE' && APIName != '' && APIName != 'Group, User' && getRecordCount(APIName) > 50000 && String.valueOf((fd.getName()+'')).toLowerCase().right(2) == '_c')
                    referenceMap.put(String.valueOf((fd.getName()+'').toLowerCase().removeEnd('_c')+'_r.Name'),'STRING');
                else
                    referenceMap.put(String.valueOf(fd.getName()),String.valueOf(fd.getType()));
            }
        }
        // code to get reference fields,all fields of object - end
        return referenceMap;
    }
    
    public static  Map<String,String> getReferenceAPIMap(String stype){
        
        Map<String,String> referenceMap= new Map<String,String>();
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(stype.toLowerCase()).getDescribe().Fields.getMap();
        
        list<string> allFields = new list<string>();
        
        Map<String,String> attributeFieldMap = new Map<String,String>();
        Map<String,Schema.DisplayType> attributeFieldTypeMap = new Map<String,Schema.DisplayType>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if(String.valueOf(fd.getType()) =='REFERENCE'){
                    String APIName = String.valueOf(fd.getReferenceTo());
                    referenceMap.put(String.valueOf(fd.getName()),APIName.substring(1,APIName.length()-1));
                }
            }
        }
         return referenceMap;
    }
    
     public class expressionWrapper{
        public string fieldname{get;set;}
        public string operator{get;set;}
        public string value{get;set;}
        public String andor{get;set;}
        public String colorand{get;set;}
        public String fontcolorand{get;set;}
        public String coloror{get;set;}
        public String fontcoloror{get;set;}
        public Integer sequence {get;set;}
        
        public List<String> pickListValues{get;set;}
        public map<id,String> referncevalue{get;set;}
        public expressionWrapper(){
            this.fieldname = '';
            this.operator = ''; 
            this.value = '';
            this.colorand = 'White';
            this.fontcolorand = 'Black';
            this.coloror = 'White';
            this.fontcoloror = 'Black';
            this.sequence = 1;
        }
    }
    
    @RemoteAction
    public static List<String>  getPicklistValues(String obj,String fieldAPI){
        List<String> fieldMetaData;
        try{
           fieldMetaData=getPicklistValuesForField(obj,fieldAPI);
            
        }catch(Exception e){
            
        }
        return fieldMetaData;
    }
    
    public static List<String> getPicklistValuesForField(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }

        return lstPickvals;
    }
    
    @RemoteAction
    public static map<id,String>  getReferenceRecords(String objAPI){
        map<id,String> recordList= new map<id,String>();
        try{
            String query = 'select id,name from '+objAPI;
            List<sObject> objectRecords = database.query(query);
            if(!objectRecords.isEmpty()){
                for(sObject obj : objectRecords){
                    //   recordList.add(String.valueOf(obj.get('Name')));
                    recordList.put(String.valueOf(obj.get('id')),String.valueOf(obj.get('Name')));
                }
            }
        }catch(Exception e){}
        return recordList;
    }
    
    public static Integer getRecordCount(String objAPI){
        if(objectAPIToCount.containsKey(objAPI))
        {
            return objectAPIToCount.get(objAPI);
        }
        else
        {
            String query = 'SELECT COUNT() from '+objAPI;
            Integer count = Database.countQuery(query);
            objectAPIToCount.put(objAPI, count);
            return count;
        }
    }
    
    @RemoteAction
    public static List<Apttus__APTS_Agreement__c> getAgmtsAsPerCondition(String param, String agmtIdsStr){
        agmtIdsStr = agmtIdsStr.replaceAll(',', '\',\'');
        String query = 'Select Id,RecordType.Name,Apttus__FF_Agreement_Number__c,Name,Apttus__Contract_Start_Date__c, Apttus__Contract_End_Date__c,Apttus__Total_Contract_Value__c,Payment_Terms__c, Apttus__Related_Opportunity__r.Name, Apttus__Related_Opportunity__c, Apttus__Primary_Contact__c, Apttus__Primary_Contact__r.Name, Apttus__Account__c, Apttus__Version_Number__c , Apttus__Status__c, Selected__c, Amended_Terms__c, Apttus__Amendment_Effective_Date__c From Apttus__APTS_Agreement__c WHERE ((Apttus__Status_Category__c = \'In Effect\' AND Apttus__Status__c = \'Activated\') OR (Apttus__Status_Category__c = \'Expired\' AND Apttus__Status__c = \'Expired\') OR (Apttus__Status_Category__c = \'Terminated\' AND Apttus__Status__c = \'Terminated\')) and '+param+' ORDER BY Apttus__FF_Agreement_Number__c';//Id in (\''+agmtIdsStr+'\') AND 
        return database.query(query);
        //List<Apttus__APTS_Agreement__c> listOfAgreements = database.query(query);
        //return JSON.serialize(listOfAgreements);
    }
}