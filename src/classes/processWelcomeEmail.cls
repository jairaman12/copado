/**
* This class is used to send welcome email whenever Provider On-boarding Master case is closed processed 
*
**/
public class processWelcomeEmail{
    @InvocableMethod(label='welcome Email Creation' description='Sends Email based on the Status')    
    public static void welcomeEmailCreation(list<Case> caseList){
        system.debug('caseList=== '+caseList);
        
        String htmlEmailBody = '';
        system.debug('1:pre');
        //Getting Email Templates
        List<EmailTemplate> templateId = new List<EmailTemplate>([Select id, DeveloperName, Body, HTMLValue from EmailTemplate where DeveloperName like '%WelcomeEmailTemplate%']); 
        map<string,EmailTemplate> emailTemplateMap = new map<string,EmailTemplate>();
        map<string,Id> oweMap = new map<string,Id>();
        List<EmailMessage> emailMsgList = new List<EmailMessage>();
        for(EmailTemplate e:templateId){
            emailTemplateMap.put(e.DeveloperName,e);
        }
        system.debug('2:pre');
        //Getting OrgWideEmailAddress
        set<string> orgWideEmail = new set<string>();
        orgWideEmail.add(Email_Settings__c.getValues('OrgWideEmailIL').state__c);
        orgWideEmail.add(Email_Settings__c.getValues('OrgWideEmailTX').state__c);
        orgWideEmail.add(Email_Settings__c.getValues('OrgWideEmailMT').state__c);
        orgWideEmail.add(Email_Settings__c.getValues('OrgWideEmailOK').state__c);
        orgWideEmail.add(Email_Settings__c.getValues('OrgWideEmailNM').state__c);             
        List<OrgWideEmailAddress> owea = [select Id,Address from OrgWideEmailAddress where Address in :orgWideEmail];
        System.debug('owea===>>>'+owea);
        /*******************
         * Modified By: I364191
         * JIRA # : PPN-30175
         * *****************/
        if( !owea.isEmpty() )
        {
            for(OrgWideEmailAddress o:owea)
            {
                if(string.valueof(o.Address) == Email_Settings__c.getValues('OrgWideEmailIL').state__c)
                {
                    oweMap.put('IL1',o.Id);
                }else if(string.valueof(o.Address) == Email_Settings__c.getValues('OrgWideEmailTX').state__c )
                {
                    oweMap.put('TX1',o.Id);
                }else if(string.valueof(o.Address)== Email_Settings__c.getValues('OrgWideEmailNM').state__c)
                {
                    oweMap.put('NM1',o.Id);
                }else if(string.valueof(o.Address) == Email_Settings__c.getValues('OrgWideEmailOK').state__c )
                {
                    oweMap.put('OK1',o.Id);
                }else if(string.valueof(o.Address)== Email_Settings__c.getValues('OrgWideEmailMT').state__c)
                {
                    oweMap.put('MT1',o.Id);
                }
        	}
        }
        
        system.debug('3:pre');
        //Getting Account Names
        set<id> accIds = new set<id>();
        set<id> caseIds = new set<id>();
        Map<Id,Id> CaseRecordType = new Map<Id,Id>();//Added by U393129 to get the recordtype from process builder
        for(case c: caseList){
              CaseRecordType.put(c.RecordTypeId,c.RecordTypeId);
            if(c.accountId != null)
                accIds.add(c.accountid);
            if(	c.Case_Entity__c != null)
                accIds.add(c.Case_Entity__c);
            CaseIds.add(c.Id);
        }
        list<account> accName = [select id,name from account where id = :accIds];
        map<id,string> accNameMap = new map<id,string>();
        for(account a: accName)
        {
            accNameMap.put(a.Id,a.name);
        }
        system.debug('AccountName====');
        // record types from custom settings
        Map<id,string> recTypeMapbyId                    =   new Map<Id,string>();
        Map<String,RecordType_settings__c> recordTypemap =   RecordType_settings__c.getAll();
        if(!recordTypemap.isEmpty())
        {
            for( RecordType_settings__c recType : recordTypemap.values()  )
            {
                recTypeMapbyId.put( recType.Record_type_Id__c , recType.DeveloperName__c );
            }
        }
        system.debug('5:pre==== '+recTypeMapbyId);
        //Getting Network Load Case Information for Individual
        set<Id> masterCaseIds = new set<Id>();
        list<case> masterCases=[select id from case where id in :caseIds and recordtypeId IN :CaseRecordType.keyset()];
  
        system.debug('masterCases=== '+masterCases);
        list<Provider_Networks__c> provDetList = new list<Provider_Networks__c>();
        for(case m:masterCases)
        {
            masterCaseIds.add(m.Id);
        }
        
        system.debug('6:pre');
        list<Provider_Networks__c> providerDetails = [select id,Case_Number__r.CaseNumber,ProviderName__c,Case_Number__r.parentId,Network_Code_Name_Detail__c,
                                                      Networks_Effective_Date__c from Provider_Networks__c where 
                                                      Case_Number__c in :masterCaseIds and Case_Number__r.status = 'Closed Processed' 
                                                      ];
        system.debug('providerDetails==== '+providerDetails);
        map<id,list<Provider_Networks__c>> masterWithNetworkMap = new map<id,list<Provider_Networks__c>>();
        for(Provider_Networks__c p:providerDetails)
        {
            if(masterWithNetworkMap.containsKey(p.Case_Number__c)) 
            {
                // Master Case already in map
                masterWithNetworkMap.get(p.Case_Number__c).add(p);
            } else {
                // Master Case is not yet in Map
                masterWithNetworkMap.put(p.Case_Number__c,new list<Provider_Networks__c> { p });                    
            }
        }
        system.debug('7:pre==== '+masterWithNetworkMap);
        
        //Getting Network Load Case Information for Group
        list<case> groupCases = [select id,CaseNumber,parentId,Network_Name__c,Network_Name_Detail__c,Network_Effective_Date__c from Case where Id in :CaseIds and recordtype.developername = 'Provider_Group_On_boarding_Network_Load'];
        
        system.debug('10:pre');
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();	
        
        if (caseList!=null){
            system.debug('caseList=== '+caseList);
            for(case caseRec : caseList)
            { 
                system.debug('1===caseRec.Plan_ID__c=== '+caseRec.Plan_ID__c+'caseRec.Email_Address_Submitter__c===  '+caseRec.Email_Address_Submitter__c);
                System.debug('oweMap.get===>>>'+oweMap.get('IL1'));
                if (caseRec.Plan_ID__c!=null && caseRec.Email_Address_Submitter__c != null)
                {
                    system.debug('caseRec.Plan_ID__c=== '+caseRec.Plan_ID__c+'caseRec.Email_Address_Submitter__c===  '+caseRec.Email_Address_Submitter__c);
                    mail = new Messaging.SingleEmailMessage();	
                    if(caseRec.Plan_ID__c == 'IL1'){
                        system.debug('1:p');
                        mail.setTemplateID(emailTemplateMap.get('WelcomeEmailTemplateIL').Id); 
                        system.debug('2:p');
                        mail.setOrgWideEmailAddressId(oweMap.get('IL1'));
                        system.debug('3:p');
                        htmlEmailBody = emailTemplateMap.get('WelcomeEmailTemplateIL').HTMLValue;  
                        //system.debug('4:p:htmlemailbody:' + htmlEmailBody);
                    }
                    else if(caseRec.Plan_ID__c == 'MT1'){
                        system.debug('1:p');
                        mail.setTemplateID(emailTemplateMap.get('WelcomeEmailTemplateMT').Id); 
                        system.debug('2:p');
                        mail.setOrgWideEmailAddressId(oweMap.get('MT1'));
                        system.debug('3:p');
                        htmlEmailBody = emailTemplateMap.get('WelcomeEmailTemplateMT').HTMLValue;  
                        system.debug('4:p');
                    }
                    else if(caseRec.Plan_ID__c == 'TX1'){
                        system.debug('1:p');
                        mail.setTemplateID(emailTemplateMap.get('WelcomeEmailTemplateTX').Id); 
                        system.debug('2:p');
                        mail.setOrgWideEmailAddressId(oweMap.get('TX1'));
                        system.debug('3:p');
                        htmlEmailBody = emailTemplateMap.get('WelcomeEmailTemplateTX').HTMLValue;  
                        system.debug('4:p');
                    }
                    else if(caseRec.Plan_ID__c == 'NM1'){
                        system.debug('1:p');
                        mail.setTemplateID(emailTemplateMap.get('WelcomeEmailTemplateNM').Id); 
                        system.debug('2:p');
                        mail.setOrgWideEmailAddressId(oweMap.get('NM1'));
                        system.debug('3:p');
                        htmlEmailBody = emailTemplateMap.get('WelcomeEmailTemplateNM').HTMLValue;  
                        system.debug('4:p');
                    }
                    else if(caseRec.Plan_ID__c == 'OK1'){
                        system.debug('1:p');
                        mail.setTemplateID(emailTemplateMap.get('WelcomeEmailTemplateOK').Id); 
                        system.debug('2:p');
                        mail.setOrgWideEmailAddressId(oweMap.get('OK1'));
                        system.debug('3:p');
                        htmlEmailBody = emailTemplateMap.get('WelcomeEmailTemplateOK').HTMLValue;  
                        system.debug('4:p');
                    }
                    String[] toaddressArr = new String[]{};
                        system.debug('5:p');
                    string provName = '';
                    system.debug('caseRec.recordtypeId:' + caseRec.recordtypeId);
                    string tablebody ='<table class="tabelle separate" border="1"><tr><th>Network Name</th><th>Network Effective Date</th></tr>';
                    string str = '';
                    /*Network Load*/
                    system.debug('masterWithNetworkMap123.get(caserec.Id):' + masterWithNetworkMap.get(caserec.Id));
                    if(recTypeMapbyId.get(caseRec.recordtypeId) == 'Network_Load')
                    {
                        if(caserec.accountId != null)
                        {
                         provName = accNameMap.get(caserec.accountId);   
                        }else{
                            if( !masterWithNetworkMap.isEmpty() && masterWithNetworkMap.containsKey(caseRec.id) )
                            {
                                List<Provider_Networks__c> provNetworks =  masterWithNetworkMap.get(caserec.id);
								provName	=	String.isEmpty(provNetworks[0].ProviderName__c)? '' : provNetworks[0].ProviderName__c;                           
                            }
                        }

                        system.debug('masterWithNetworkMap.get(caserec.Id):' + masterWithNetworkMap.get(caserec.Id));
                        if(masterWithNetworkMap.get(caserec.Id) != null)
                        {
                            map<string,string> findDupes = new map<string,string>();
                            for(Provider_Networks__c n:masterWithNetworkMap.get(caserec.Id))
                            {
                                String[] networkNameArray = new String[]{''};
                                    system.debug('n.Network_Code_Name_Detail__c:' + n.Network_Code_Name_Detail__c);
                                if (string.isblank(n.Network_Code_Name_Detail__c))
                                {    
                                    system.debug('n.Network_Code_Name_Detail__c:' + n.Network_Code_Name_Detail__c + ':' + n.Case_Number__r.casenumber );
                                    continue;
                                }else{                    
                                    networkNameArray = n.Network_Code_Name_Detail__c.split('\n');
                                    system.debug('6:p:' + networkNameArray);
                                }
                                
                                for(String nName : networkNameArray){                                    
                                    string temp = nName.replaceAll('(\\r|\\n)+', '').trim();
                                    system.debug('7:p:' + n.Case_Number__r.casenumber + temp + n.Networks_Effective_Date__c);
                                    if(findDupes.get(n.Case_Number__r.casenumber + temp + n.Networks_Effective_Date__c) != null){
                                        system.debug('skipped case number:3:' + n.Case_Number__r.casenumber + temp + n.Networks_Effective_Date__c );
                                        continue;
                                    }else{
                                        system.debug('8:p:');
                                        findDupes.put(n.Case_Number__r.casenumber + temp + n.Networks_Effective_Date__c,n.Case_Number__r.casenumber + temp + n.Networks_Effective_Date__c);
                                    } 
                                    string st = '';
                                    if(n.Networks_Effective_Date__c != null)
                                        st = string.valueof(n.Networks_Effective_Date__c).substring(0,10);
                                    str += '</tr><td class="zelle">' + nName +  '</td><td class="zelle">' + st +  '</td></tr>';                                                     
                                }
                            }
                        }
                    }else if( recTypeMapbyId.get(caseRec.recordtypeId) == 'Provider_Group_On_boarding_Network_Load'){
                        /*
                        * Author: u393129
                        * Commnted : reason the Account Name is not displayed in the welcome Template, as Case_Entity__c is always blank
                        * @Date : 12/12/2018
                        if(caserec.Case_Entity__c != null)
                        provName = accNameMap.get(caserec.Case_Entity__c);
                        */
                        /*
                        * Author: u393129
                        * Purpouse :Mapped the new field AccountId to get the Account Name, as the Case_Entity__c is always blank .
                        * @Date : 12/12/2018
                        */
                        if(caserec.AccountId != null)
                        {
                            provName = accNameMap.get(caserec.AccountId); 
                        }else if( !String.isEmpty(caserec.ProviderName__c) ){
                            provName = caserec.ProviderName__c; 
                        }
                           
                        system.debug('accNameNetwork:' + accNameMap.get(caserec.AccountId));
                        for(Case obj:groupCases)
                        {
                            String[] networkNameArray = new String[]{''};
                                if (string.isblank(obj.Network_Name_Detail__c))
                            {    
                                system.debug('obj.Network_Name__c:' + obj.Network_Name__c + ':' + obj.casenumber );
                                continue;
                            }
                            else{
                                networkNameArray = obj.Network_Name_Detail__c.split('\n');
                            }
                            map<string,string> findDupes = new map<string,string>();
                            for(String nName : networkNameArray){
                                system.debug('fixing nName:' + nName);
                                nName = nName.replaceAll('(\\r|\\n)+', '').trim();
                                if(findDupes.get(obj.casenumber + nName + obj.Network_Effective_Date__c) != null){
                                    system.debug('skipped case number:5:' + obj.createddate + ':' + obj.casenumber );
                                    continue;
                                }else{
                                    findDupes.put(obj.casenumber + nName + obj.Network_Effective_Date__c,obj.casenumber + nName + obj.Network_Effective_Date__c);
                                }
                                string s = '';
                                if(obj.Network_Effective_Date__c != null)
                                    s = string.valueof(obj.Network_Effective_Date__c).substring(0,10);
                                str += '</tr><td class="zelle">' + nName +  '</td><td class="zelle">' + s +  '</td></tr>';           
                            }                           
                        }
                    }
                    system.debug('str:' + str);
                    tablebody += str;
                    tablebody += '</table>'; 
                    system.debug('tablebody:' + tablebody);
                    toaddressArr.add(caseRec.Email_Address_Submitter__c);
                    system.debug('6:p');
                    mail.setToAddresses(toaddressArr);
                    system.debug('7:p');
                    String subject='BCBS'+ caseRec.Plan_ID__c.substring(0,2) + ' Welcome Email';
                    system.debug('8:p');
                    mail.setSubject(subject);             
                    if(caseRec.EmailThread__c != null && caseRec.EmailThread__c != '')
                        htmlEmailBody = htmlEmailBody.replace('refid',caseRec.EmailThread__c);
                    //htmlEmailBody = htmlEmailBody.replace('refid',caseRec.EmailThread__c);
                    system.debug('9:p:' + provName);
                    if(provName != null && provName != '')
                        htmlEmailBody = htmlEmailBody.replace('ProviderName',provName);
                    system.debug('10:p');
                    htmlEmailBody = htmlEmailBody.replace('NetworkNameNetworkEffectiveDate',tableBody);
                    system.debug('11:p');
                    mail.setHTMLBody(htmlEmailBody);
                    mail.setSaveAsActivity(false);
                    emailList.add(mail);
                    EmailMessage emailMsg = new EmailMessage(); // Created a EmailMessage and copy all details from above.
                    emailMsg.ToAddress=(mail.getToAddresses())[0];
                    emailMsg.Subject=mail.getSubject();
                    emailMsg.HtmlBody=mail.getHtmlBody();
                    if(caserec.parentId == null)
                        emailMsg.ParentId = caseRec.Id; 
                    else
                        emailMsg.ParentId = caseRec.ParentId; 
                    emailMsg.MessageDate = system.now();
                    emailMsg.Status = '0';
                    emailMsgList.add(emailMsg);
                }
            }
            //sending emails
            if(emailList != null && !emailList.isEmpty()){
                system.debug('emailList:' + emailList);
                system.debug('htmlEmailBody:' + htmlEmailBody);
                if(!test.isrunningtest()) 
                    Messaging.sendEmail(emailList);
                if(emailMsgList.size() > 0)
                    upsert emailMsgList; 
            }
        }
        
    }   
}