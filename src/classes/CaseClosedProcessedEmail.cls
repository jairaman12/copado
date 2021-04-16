/**
* This class is used to send formatted email based on Request Category selection whenever case is close/reject processed 
*
**/
public class CaseClosedProcessedEmail{
    @InvocableMethod(label='caseEmailCreation' description='Sends the Email to Submitter Email based on the Status')    
    public static void caseEmailCreation(list<Case> caseList){
        List<String> toEmailAddresses = new List<String>();
        //List<Confirm_Email_Settings__c> contMailAddrLst = Confirm_Email_Settings__c.getall().values();
        Map<String, Confirm_Email_Settings__c> contactMailAddrMap = new Map<String, Confirm_Email_Settings__c>();
        //System.debug('Confirm_Email_Settings__c====>>>>'+Confirm_Email_Settings__c.getall().values());
        System.debug('caseList===>>>'+caseList); 
        boolean error = false;
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailMsgList = new List<EmailMessage>(); // Created a EmailMessage and copy all details from above.
        for(Confirm_Email_Settings__c cnfrmEmail : Confirm_Email_Settings__c.getall().values()){
            contactMailAddrMap.put(cnfrmEmail.case_origin__c, cnfrmEmail);
        }
        
        //system.debug( 'Custom data'+contactMailAddrMap);
        
        String submitterbody = null;
        String caseType=null;
        String orgWideEmail = ' ';  
        String caseOrigin = '';
        try{ 
            if (caseList!=null){
                for(case caseRec : caseList){ 
                    if (caseRec.Plan_ID__c!=null)
                    {             
                        
                        Messaging.SingleEmailMessage submitterMail = new Messaging.SingleEmailMessage(); 
                        if( caserec.Email_Address_Submitter__c  == null || caseRec.Email_Address_Submitter__c == ' ')
                        {
                            error = true; 
                        }else{
                            toEmailAddresses.add(caseRec.Email_Address_Submitter__c);
                        }
                        system.debug('***** CaseRec Id ********'+ caseRec.Id);
                        List<Case> childCases = [select id,Status,RecordType.DeveloperName,External_Comments__c from Case where parentId in (:caseRec.Id)];
                        if (!error && childCases.size()>0){
                            system.debug('****  It is not coming here *****');
                            orgWideEmail   =    GetStateEmail(CaseClosedProcessedEmail.getLocation(caseRec.Plan_ID__c));                        
                            
                            List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail];
                            
                            if(!owea.isEmpty())
                            {
                                submitterMail.setOrgWideEmailAddressId( owea[0].Id ); 
                            } 
                            //toEmailAddresses.add(caseRec.Email_Address_Submitter__c); 
                            
                            submitterMail.setToAddresses(toEmailAddresses);
                            submitterMail.setSaveAsActivity(false);
                            RecordType RecType =[select RecordType.DeveloperName from RecordType where Id = :caseRec.RecordTypeId ];  
                            if(RecType.DeveloperName=='Provider_On_boarding'){
                                caseType ='Provider On-boarding';
                            }    
                            else { 
                                caseType ='Demographic Change';
                            } 
                           if(caseRec.Origin !='TX PDSC Consumer Complaints' && caseRec.Origin !='IL Consumer Provider Data' && caseRec.Origin !='NM Network Provider Finder Inquiries'){
                            submitterMail.setSubject('BCBS'+CaseClosedProcessedEmail.getLocation(caseRec.Plan_ID__c)+' '+caseType+' Request Form Completed');
                            }
                            else{
                            submitterMail.setSubject('BCBS'+CaseClosedProcessedEmail.getLocation(caseRec.Plan_ID__c)+' Provider Data Change Request Completed');
                            }
                            submitterbody='<style type="text/css">';
                            submitterbody +='.tabelle {width: 578px; border-collapse: collapse;}';
                            submitterbody +='.zelle{padding: 3px;background-color: #B7CEEC;font-family: "Times New Roman", Times, serif; font-size: 15px;text-align: left;color: Black;}';
                            submitterbody +='th {background-color: SteelBlue;padding: 3px;color: White;font-size: 15px;font-family: "Times New Roman", Times, serif;}';
                            submitterbody +='</style>';        
                            submitterbody += '<div style="border: thin solid #2C82BA; width:100%"><img src="'+getWebUrl()+CaseClosedProcessedEmail.GetResourceURL('bcbs'+CaseClosedProcessedEmail.getLocation(caseRec.Plan_ID__c)+'logo')+'"/>'; 
                            if (RecType.DeveloperName=='Email')
                                submitterbody += '<hr width="100%" size="20" color="#2C82BA"><br/><br/><br/>';
                            else
                                submitterbody += '<hr width="100%" size="20" color="#2C82BA"><br/>'+caseRec.Name_Submitter__c+', <br/><br/>';
                            if (RecType.DeveloperName=='Master_Provider_Case_data' || RecType.DeveloperName=='Email'){             
                             if(caseRec.Origin !='TX PDSC Consumer Complaints' && caseRec.Origin !='IL Consumer Provider Data' && caseRec.Origin !='NM Network Provider Finder Inquiries'){
                                submitterbody +='This email is to notify you that we have completed your request.<br/><br/>';               
                                submitterbody += 'Your case number is '+caseRec.CaseNumber;
                                }
                               else{                           
                               submitterbody +='Hi ,<br/><br/>';
                               submitterbody +='This email is to notify you that  the request for provider data change (Case number :'+ caseRec.CaseNumber +') has been completed.';               
                               }
                                
                                if (RecType.DeveloperName=='Email')
                                    submitterbody +='<br/><br/>';
                                else
                                submitterbody +=', for '+caseRec.Name_of_Provider_Group__c+'.<br/><br/>';                                 
                             if(caseRec.Origin !='TX PDSC Consumer Complaints' && caseRec.Origin !='IL Consumer Provider Data' && caseRec.Origin !='NM Network Provider Finder Inquiries'){
                                submitterbody +='<table class="tabelle separate" border="1"><tr><th>Type of Change</th><th>Status</th><th>Comment</th></tr>';
                                                         
                               for(Case childCaseRec : childCases){  
                                    if (childCaseRec.External_Comments__c==null)
                                        childCaseRec.External_Comments__c = '';               
                                    
                                    if(childCaseRec.RecordType.DeveloperName=='Name_Change_Request')              
                                        submitterbody +='<tr><td class="zelle"> Name</td><td class="zelle">' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    if(childCaseRec.RecordType.DeveloperName=='NPI_Tax_Id_Change'){               
                                        submitterbody +='<tr><td class="zelle"> NPI Tax ID</td><td class="zelle">' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }
                                    if(childCaseRec.RecordType.DeveloperName=='Physical_Address_Change'){
                                        submitterbody +='<tr><td class="zelle"> Office Physical Address </td><td class="zelle">' +childCaseRec.Status+  '</td><td class="zelle">'+childCaseRec.External_Comments__c+  '</td></tr>';
                                    }                 
                                    if(childCaseRec.RecordType.DeveloperName=='Billing_Address_Change'){
                                        submitterbody +='<tr><td class="zelle"> Billing Address </td><td class="zelle">' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }                 
                                    if(childCaseRec.RecordType.DeveloperName=='Credentialing_Change'){
                                        submitterbody += '<tr><td class="zelle"> Credentialing Address </td><td class="zelle"> ' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }                  
                                    if(childCaseRec.RecordType.DeveloperName=='Administrative_Change'){
                                        submitterbody +='<tr><td class="zelle"> Administrative Address </td><td class="zelle"> ' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }                  
                                    if(childCaseRec.RecordType.DeveloperName=='Other_Provider_Change'){                 
                                        submitterbody +='<tr><td class="zelle"> Other Provider Updates </td><td class="zelle"> ' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }
                                    if(childCaseRec.RecordType.DeveloperName=='Remove_Provider_from_Group_Location'){                 
                                        submitterbody +='<tr><td class="zelle"> Remove Provider from Group/Location </td><td class="zelle"> ' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }
                                    if(childCaseRec.RecordType.DeveloperName=='Add_Provider_To_Group_Location'){                 
                                        submitterbody +='<tr><td class="zelle"> Add Provider from Group/Location </td><td class="zelle"> ' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }
                                    if(childCaseRec.RecordType.DeveloperName=='Network_Change'){                 
                                        submitterbody +='<tr><td class="zelle"> Network Change </td><td class="zelle"> ' +childCaseRec.Status+  '</td><td class="zelle">' +childCaseRec.External_Comments__c+  '</td></tr>';
                                    }                
                                }
                                submitterbody += '</table>';
                                }                             
                            }
                            
                            else if (RecType.DeveloperName=='Provider_On_boarding') {
                                submitterbody +='This email is to notify you that we have completed your request.<br/><br/>';
                                submitterbody +='Your case number is '+caseRec.CaseNumber+', for '+caseRec.Name_of_Provider_Group__c+'.<br/><br/>';
                                submitterbody +='Please note completing this application does NOT mean that you are a participating provider. Your claims will be processed as out-of-network until you are contracted, credentialed, and have an effective date.';
                            }
                            
                             
                                       
                            submitterbody +='<br/><br/>'; 
                            //system.debug('**** %%%%%%% '+ contactMailAddrMap.get(caseRec.Origin).case_origin__c);  
                            if(caseRec.origin != NULL && contactMailAddrMap != NULL && contactMailAddrMap.containsKey(caseRec.origin)){
                                system.debug('**** inside if'+ contactMailAddrMap.get(caseRec.Origin).case_origin__c);  
                                submitterbody += 'If you have any questions or concerns regarding this inquiry, '+contactMailAddrMap.get(caseRec.Origin).contact_Info__c+'.<br/><br/>';   
                            }
                            else{
                                submitterbody += 'If you have any questions or concerns regarding this inquiry, '+CaseClosedProcessedEmail.getContactDetails(CaseClosedProcessedEmail.getLocation(caseRec.Plan_ID__c),caseRec.Origin)+'.<br/><br/>';
                            }
                            
                            submitterbody += 'Sincerely, <br/>'; 
                            submitterbody += 'Blue Cross and Blue Shield of '+CaseClosedProcessedEmail.getState(caseRec.Plan_ID__c)+ '<hr width="100%" size="20" color="#2C82BA">'; 
                            submitterbody += '<center><b>Powered by: Salesforce<sup>TM</sup></b></center><hr width="25%"></br>';
                            submitterbody += '<center>Blue Cross and Blue Shield of '+CaseClosedProcessedEmail.getState(caseRec.Plan_ID__c)+ ', a Division of Health Care Service Corporation,</center>';
                            submitterbody += '<center>a Mutual Legal Reserve Company, an Independent Licensee of the Blue Cross and Blue Shield Association.</center><br/>'; 
                            submitterbody += '<center>&copy; 2017 Health Care Service Corporation. All rights reserved.</center><hr width="50%"></br>';
                            /**submitterbody += 'HCSC Company Disclaimer:</br>';
submitterbody += 'The information contained in this communication is confidential, private, proprietary, or otherwise privileged and is intended only for the use of the addressee.';
submitterbody += ' Unauthorized use, disclosure, distribution or copying is strictly prohibited and may be unlawful.  If you have received this communication in error, please notify the sender immediately at'; 
submitterbody += ' (312) 653-6000 in Illinois; (800) 447-7828 in Montana; (800) 835-8699 in New Mexico; (918) 560-3500 in Oklahoma; or (972) 766-6900 in Texas.<br/><br/>';**/
                            submitterbody += '<hr width="100%" size="20" color="#2C82BA">';
                            submitterbody += ' (NOTE: Please do not remove the Ref id)'+' Ref id '+caseRec.EmailThread__c;
                            submitterbody += '</div>';        
                            
                            submitterMail.setHtmlBody(submitterbody);        
                            system.debug('submitterbody:' + submitterbody);
                            allmsg.add(submitterMail);
                            if(!test.isrunningtest()) Messaging.sendEmail(allmsg);
                            for(Messaging.SingleEmailMessage email : allmsg ){
                                EmailMessage emailMsg = new EmailMessage(); // Created a EmailMessage and copy all details from above.
                                emailMsg.ToAddress=(email.getToAddresses())[0];
                                emailMsg.Subject=email.getSubject();
                                emailMsg.HtmlBody=email.getHtmlBody();
                                emailMsg.ParentId = caseRec.Id; //Attach with the case
                                emailMsg.MessageDate = system.now();
                                emailMsg.Status = '0';
                                emailMsgList.add(emailMsg);
                            }
                            if(emailMsgList.size() > 0)
                                upsert emailMsgList;        
                        }
                    }               
                }
            }
        }catch(Exception ex){
            System.debug('Exception occurred'+ex.getCause());
        }         
    }
    public static String getLocation(String planId){
        system.debug('getLocation: Start');
        String loc = '';
        if (loc!=null)
            loc =  planId.remove('1');
        system.debug('getLocation: End:'+loc );
        return loc;
    }
    
    public static String getWebUrl(){
        String url ='';
        Email_Settings__c webUrl = Email_Settings__c.getValues('URL');
        if (url!=null){
            url =  webUrl.State__c;                     
        }
        return url;
    }
    public static String getContactDetails(String planId,String caseOrigin){
        system.debug('getContactDetails: Start' + planId + ':' + caseOrigin );
        String con = '';    
        Email_Settings__c stateCon;
        if (planId!=null) { 
            if (caseOrigin!=null){
                stateCon = Email_Settings__c.getValues(caseOrigin);
                System.debug('stateCon1::'+stateCon);
            }if (stateCon==null){
                stateCon = Email_Settings__c.getValues(CaseClosedProcessedEmail.getLocation(planId));
                System.debug('stateCon2::'+stateCon);
            }
            
            if (con!=null)  
                con = stateCon.State__c;  
        }   
        system.debug('getContactDetails: End:' + con);
        return con;
    }
    
    public static String getState(String planId){
        String state = '';
        if (planId.endsWithIgnoreCase('IL1')) {
            state = 'Illinois';
        }else if (planId.endsWithIgnoreCase('TX1')){
            state = 'Texas';
        }else if (planId.endsWithIgnoreCase('MT1')){
            state = 'Montana';
        }else if (planId.endsWithIgnoreCase('NM1')){
            state = 'New Mexico';
        }else if (planId.endsWithIgnoreCase('OK1')){
            state = 'Oklahoma';
        }      
        
        return state;
    }
    
    public Static String GetStateEmail(String planId){
        String orgStateEmail='';  
        if (planId!=null) { 
            Email_Settings__c stateEmail = Email_Settings__c.getValues('OrgWideEmail'+CaseClosedProcessedEmail.getLocation(planId));
            if (stateEmail!=null)                
                orgStateEmail = stateEmail.State__c;
            
        }
        return  OrgStateEmail; 
    }
    
    /**
* Method to Retrieve Static Resource URL dynamically
* */
    public static String GetResourceURL(String resourceName)
    {
        system.debug('CCPE : resourceName:' + resourceName);
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
        if(resourceList.size() == 1)
        {           
            system.debug('CCPE: Finally In');
            String namespace = resourceList[0].NamespacePrefix;    
            
            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
        }
        else return '';
    }
    
}