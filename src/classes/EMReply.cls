/**
* This class is used to send formatted email based on Request Category selection whenever case is close/reject processed 
*
**/
public class EMReply{
    @InvocableMethod(label='caseEmailReply' description='Sends the Email to Submitter Email based on the Status')    
    public static void caseEmailReply(list<EmailMessage> emailList){
        List<String> toEmailAddresses = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Map<String, Confirm_Email_Settings__c> contactMailAddrMap = new Map<String, Confirm_Email_Settings__c>();
        String orgWideEmail = ' ';  
        String submitterbody = '';
        boolean saveeMail = true;
        
        for(Confirm_Email_Settings__c cnfrmEmail : Confirm_Email_Settings__c.getall().values()){
            contactMailAddrMap.put(cnfrmEmail.Case_Origin__c, cnfrmEmail);
        }

        system.debug( 'Custom data'+contactMailAddrMap);
        try{  
            if (emailList.size() >0){
                if (emailList!=null){
                    List<EmailMessage> emailMsgList = new List<EmailMessage>();       
                    for(EmailMessage emailRec : emailList){ 
                        Messaging.SingleEmailMessage submitterMail = new Messaging.SingleEmailMessage(); 
                        toEmailAddresses.add(emailRec.FromAddress);
                        Case c = [select id, origin,caseNumber,Name_Submitter__c,Plan_ID__c,EmailThread__c from Case where Id in (:emailRec.RelatedToId)];  
                        orgWideEmail   =    GetStateEmail(EMReply.getLocation(c.Plan_ID__c));   
                        if (emailRec.FromAddress.equals('orgWideEmail')){
                            saveeMail = false;
                            break;                            
                        }
                        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail];
                        if(!owea.isEmpty())
                        {
                            submitterMail.setOrgWideEmailAddressId( owea[0].Id ); 
                        } 
                        submitterMail.setSubject(emailRec.Subject.replaceAll('Sandbox:',''));
                        submitterMail.setToAddresses(toEmailAddresses);                 
                        submitterMail.setSaveAsActivity(false);
                        submitterbody += '<div style="border: thin solid #2C82BA; width:100%"><img src="'+getWebUrl()+EMReply.GetResourceURL('bcbs'+EMReply.getLocation(c.Plan_ID__c)+'logo')+'"/>';       
                        submitterbody += '<hr width="100%" size="20" color="#2C82BA"><br/><br/>';      
                        submitterbody += 'Thank you for contacting Blue Cross and Blue Shield of '+EMReply.getState(c.Plan_ID__c)+'.<br/><br/>';
                        submitterbody += 'We have received your email for case number '+c.CaseNumber+'.<br/><br/>';  
                        submitterbody += 'Since case '+c.CaseNumber+' is closed, your request can not be processed at this time.<br/><br/>'; 
                        /*
                        if(c.Plan_id__c == 'IL1'){
                            EmailMessage contactEmail = [select id,FromAddress,ToAddress,createddate from EmailMessage where parentid = :c.Id and incoming = true order by createddate asc limit 1];
                            submitterbody += 'To open a new case for your request or for any questions, '+ contactEmail.ToAddress +'.<br/><br/>';     
                        }
						*/	
                        system.debug('c.origin:' + c.origin);
                        if(c.origin != NULL && contactMailAddrMap != NULL && contactMailAddrMap.containsKey(c.origin)){
                            system.debug('*** inside If **:' + c.origin);
                            submitterbody += 'To open a new case for your request or for any questions, '+contactMailAddrMap.get(c.Origin).contact_Info__c+'.<br/><br/>';                          
                        }
                        else{
                            system.debug('*** inside Else**');
                            submitterbody += 'To open a new case for your request or for any questions, '+ EMReply.getContactDetails(EMReply.getLocation(c.Plan_ID__c),null) +'.<br/><br/>';
                        }                       
                        
                        submitterbody += 'Sincerely, <br/>';       
                        submitterbody += 'Blue Cross and Blue Shield of '+EMReply.getState(c.Plan_ID__c)+ '<hr width="100%" size="20" color="#2C82BA">'; 
                        submitterbody += '<center><b>Powered by: Salesforce<sup>TM</sup></b></center><hr width="25%"></br>';
                        submitterbody += '<center>Blue Cross and Blue Shield of '+EMReply.getState(c.Plan_ID__c)+', a Division of Health Care Service Corporation,</center>';
                        submitterbody += '<center>a Mutual Legal Reserve Company, an Independent Licensee of the Blue Cross and Blue Shield Association.</center><br/>'; 
                        submitterbody += '<center>&copy; 2017 Health Care Service Corporation. All rights reserved.</center><hr width="50%"></br>';
                        submitterbody += '<hr width="100%" size="20" color="#2C82BA">';
                        submitterbody += ' (NOTE: Please do not remove the Ref id)'+' Ref id '+c.EmailThread__c;    
                        submitterbody += '</div>';        
                        submitterMail.setHtmlBody(submitterbody); 
                        allmsg.add(submitterMail);
                        
                        if(!test.isrunningtest()){ 
                            Messaging.sendEmail(allmsg);
                        }
                        for(Messaging.SingleEmailMessage email : allmsg ){
                            EmailMessage emailMsg = new EmailMessage(); 
                            emailMsg.ToAddress=(email.getToAddresses())[0];
                            emailMsg.Subject=email.getSubject();
                            emailMsg.HtmlBody=email.getHtmlBody();                
                            emailMsg.ParentId = c.id; 
                            emailMsg.MessageDate = system.now();
                            emailMsg.Status = '0';
                            emailMsgList.add(emailMsg);
                        }
                    }
                    /* Modified for PPN-14084 Begin */
                    if(!emailMsgList.isEmpty() && saveeMail){
                        system.debug('**** inside database method*******');
                        Database.SaveResult[] srList = Database.insert(emailMsgList, false);
                        for(Database.SaveResult sr : srList){
                            if (!sr.isSuccess()) {
                                system.debug('**** Exception Occured ***' + sr.getErrors());
                            }   
                        }
                    }
                    /* Modified for PPN-14084 End */
                }
            }     
            
        } catch(Exception ex){
            System.debug('Exception occurred'+ex);
        }         
    }
    
    public static String getLocation(String planId){
        String loc = '';
        if (loc!=null)
            loc =  planId.remove('1');
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
        String con = '';    
        Email_Settings__c stateCon;
        system.debug('getContactDetails : planId:' + planId);
        if (planId!=null) { 
            if (caseOrigin!=null){
                stateCon = Email_Settings__c.getValues(caseOrigin);
            }if (stateCon==null){
                stateCon = Email_Settings__c.getValues(CaseClosedProcessedEmail.getLocation(planId)+'RC');
            }
            
            if (con!=null)  
                con = stateCon.State__c;  
        }   
        
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
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
        if(resourceList.size() == 1)
        {           
            String namespace = resourceList[0].NamespacePrefix;
            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
        }
        else return '';
    }
    
}