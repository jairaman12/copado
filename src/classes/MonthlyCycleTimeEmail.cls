/**************************************************************************************************
Apex Class Name : MonthlyCycleTimeEmail.apxc
Version : 1.0 
Functionality : Sends monthly Cycle Time report notification email to configured Profiles
Modification Log :
-----------------------------------------------------------------------------
Developer 		Date 			Description
----------------------------------------------------------------------------
Andrew Maddox  	Aug 10, 2017 	Code Logic For PPN-3463
**********************************************************************/



global class MonthlyCycleTimeEmail Implements Schedulable {
    
        public String ctEnvironment;   
    	public String ctProfile;  
    	public String ctReportName;   
    	public String ctReportId;   
    	public String ctEmailTemplateName;   
    
    	Map<String, CycleTimeDataObject> ctMap = new Map<String, CycleTimeDataObject>();
    
    

        global void execute(SchedulableContext sc)
        {
            createAndSendCycleTimeNotificationEmail();
        }
 

        public void createAndSendCycleTimeNotificationEmail()
        {
            
            
            /*
		     * Retreives Cycle Time Custom Object Values 
			*/              
            CycleTimeSettings__c ctEnvironmentObj = CycleTimeSettings__c.getValues('Environment');            
            if(ctEnvironmentObj != null){
                    ctEnvironment = ctEnvironmentObj.CycleTimeConfigurationObject__c; 
                    System.debug('Cycle Time Environment = ' + ctEnvironment);
            }         
            
            CycleTimeSettings__c ctTargetProfileObj = CycleTimeSettings__c.getValues('TargetProfile');            
            if(ctTargetProfileObj != null){
                    ctProfile = ctTargetProfileObj.CycleTimeConfigurationObject__c; 
                    System.debug('Cycle Time Target Profile = ' + ctProfile);
            }            
              
            
            CycleTimeSettings__c ctEmailTemplateObj = CycleTimeSettings__c.getValues('CycleTimeEmailTemplate');            
            if(ctEmailTemplateObj != null){
                    ctEmailTemplateName = ctEmailTemplateObj.CycleTimeConfigurationObject__c; 
                    System.debug('Cycle Time Email Template = ' + ctEmailTemplateName);
            }         
                                                           
            // Processes and actions involved in the Apex transaction occur next,
            // which conclude with sending a single email.
            
            // Now create a new single email message object
            // that will send out a single email to the addresses in the To, CC & BCC list.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
            // An IN-bind with a String list
            String[] profileArray = ctProfile.split(',');
            System.debug('ss size = ' + profileArray.size());
                                   
            //Set up the CycleTimeMap with Profile-level information
            for(String profile : profileArray){
                System.debug('profile =' + profile);
                CycleTimeDataObject ctdo = new CycleTimeDataObject();                                
                ctdo.profileName = profile;
                ctMap.put([select id from profile where name =:profile limit 1][0].id,ctdo );
            }

            //Get the list of users associated with the target profile
            User[] uList = [select email, profileid, userrole.name from user where profileid in (select id from profile where name in :profileArray) ];
            System.debug('uList size = ' + uList.size());
             
			/*
			 * Get the Profile-level CycleTimeDataObject 
			 * if it does not have an existing map for the (role/planid) and email list, add the list
			 * if it has an existing map for the (role/planid) and email list, add the existing list
			 */                            
           for (User user : uList) {                                           
             	CycleTimeDataObject ctdo = ctMap.get(user.profileId);
               /*
               System.debug('user = '  + user);
               System.debug('ctdo.emailMap = '  + ctdo.emailMap);
               System.debug('ctdo role name = '  + user.userrole.name);
               System.debug('ctdo.emailMap.get = '  + ctdo.emailMap.get(user.userrole.name));
               */
               
                if(ctdo.emailMap.get(user.userrole.name) == null){
                    List<String> newtemp = new List<String>();
                    newtemp.add(user.email);                    
                    ctdo.emailMap.put(user.userrole.name,newtemp );
                    
                }
                else{
                    List<String> etemp = ctdo.emailMap.get(user.userrole.name);
                    etemp.add(user.email);
                    ctdo.emailMap.put(user.userrole.name, etemp);
                    
                }							
            }  
           // System.debug('ctMap = ' + ctMap);
            
            for(String key: ctMap.keySet()){
                CycleTimeDataObject ctdo = ctMap.get(key);
                //System.debug('ctdo = ' + ctdo);
                
                Map<String, List<String>> emailMap = ctdo.emailMap; 
                
                System.debug('email map for ' + key + ' = ' + emailMap);
                for(String roleName: emailMap.keySet()){
                    
                    
                    	//all the email addresses for a given rolename
                    	List<String> emailAddresses = emailMap.get(roleName);
                    
                    	//System.debug('email addresses by role in email map for ' + key + ' --- ' + roleName + ' = ' + emailAddresses);
                    
                    	//list of lists to store email address lists of 100 or less emails
                    	List<List<String>> listOfEmailAddresses = new List<List<String>>();
                    
                    	//list to store 100 email addresses
                    	List<String> tempEmailAddresses = new List<String>();
                    
                    for(String email: emailAddresses){    
                        tempEmailAddresses.add(email);
                        if(math.mod(tempEmailAddresses.size(),100) == 0){
                         System.debug('************Loading addresses to List of Lists' + tempEmailAddresses);   
                         listOfEmailAddresses.add(tempEmailAddresses);   
                         tempEmailAddresses = new String[]{};
                        }                    
                    }
                    listOfEmailAddresses.add(tempEmailAddresses);
                    
                    //System.debug('list of email addresses = ' + listOfEmailAddresses);
                    
                    EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = :ctEmailTemplateName limit 1];
                    
                    for(List<String> setOfEmails: listOfEmailAddresses){
                        
                        sendMail(emailTemplate.Id, returnHtmlBodyForRoleName(emailTemplate, roleName, ctEnvironment), setOfEmails, roleName);                                              
                    }                                        
                    
                }
                                                                               
            }            
                                                                      
        }
    
        public String returnHtmlBodyForRoleName(EmailTemplate emailTemplate, String ctRoleName, String ctEnvironment ){
        			
        String reportName;     
        
        //Lookup report id from role name
            CycleTimeSettings__c ctTempObj = CycleTimeSettings__c.getValues(ctRoleName);            
            if(ctTempObj != null){
                     reportName = ctTempObj.CycleTimeConfigurationObject__c; 
                    System.debug('Report name = ' + reportName);
            }     
        
            //Get the Id of the Target Email Report
            String ctReportId = [select id from report where name = :reportName limit 1][0].id;
            

			String htmlbody = emailTemplate.HtmlValue;
            //System.debug('email template HTML value before = ' + htmlbody);
                        
            htmlbody = htmlbody.replace('{!ReportId}',ctReportId);
            htmlbody = htmlbody.replace('{!Environment}',ctEnvironment);
            
            System.debug('email template HTML value after = ' + htmlbody);        
        
        
        return htmlbody;
    }
    
	public void sendMail(String emailTemplateId, String htmlbody, List<String> toAddresses, String roleName){	
                                    
         	System.debug('Sending... ' + toAddresses.size() + ' emails.');
        
  			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
    
            mail.setTemplateId(emailTemplateId);
            
            mail.setHtmlBody(htmlbody);
            
            mail.setPlainTextBody('Plain body');
            
            mail.setTreatBodiesAsTemplate(true);
            
            // Assign the addresses for the To and CC lists to the mail object.
            //Limit 100 addresses
            mail.setToAddresses(toAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('andrew_maddox@hcsc.net');
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName('Salesforce Support');
																					            
            // Specify the subject line for your email address.
            mail.setSubject('Monthly Cycle Time Reports');
            
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);
            
            // Optionally append the salesforce.com email signature to the email.
            // The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);           
            
   
            // Send the email you have created.
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] { mail });
                   
            if (!results.get(0).isSuccess()) {
                System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                String errorMessage = results.get(0).getErrors()[0].getMessage();
                System.debug('Error sending emails =' + errorMessage);
                System.debug('Error sending emails for' + toAddresses);
            }
        	else{
             	System.debug('Sent email for the following addresses: ' + toAddresses);
        	}

        
    	}    
    
    

}