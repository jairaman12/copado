/**
* This class is used to send formatted email based on Request Category selection whenever case is close/reject processed 
*
**/
public class OwnerNotification{
    @InvocableMethod(label='ownerNotification' description='Sends the Email to Owner email.')    
    public static void ownerNotify(list<EmailMessage> emailList)
    {
        List<String> toEmailAddresses = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        String orgWideEmail = ' ';  
        String submitterbody = '';
        boolean saveMail = true;
        try{  
            if (emailList != Null)
            {
                if (emailList.size() > 0)
                {
                    List<EmailMessage> emailMsgList = new List<EmailMessage>();
                    List<Id> listOfRelatedIds = new List<Id>();
                    Map<Id,Case> mapOfIdAndItsCase = new Map<Id,Case>();       
                    for(EmailMessage emailRec : emailList)
                    {System.debug('Related to Id'+emailRec.RelatedToId);
                        if(emailRec.RelatedToId != NULL)
                            listOfRelatedIds.add(emailRec.RelatedToId);                        
                    }
                    for(Case newCase:[Select id,owner.Type,owner.Email,ownerId,caseNumber,Name_Submitter__c,Plan_ID__c,EmailThread__c from Case where Id in :listOfRelatedIds])
                    {
                        mapOfIdAndItsCase.put(newCase.Id,newCase);System.debug('What is type '+newCase.Owner.Type);
                    }System.debug('map'+mapOfIdAndItsCase);
                    for(EmailMessage emailMsg:emailList)
                    { 
                        Messaging.SingleEmailMessage submitterMail = new Messaging.SingleEmailMessage();
                        Case newCase = new Case(); 
                        System.debug('What is in related to '+emailMsg.RelatedToId);
                        if(mapOfIdAndItsCase.containsKey(emailMsg.RelatedToId))
                        {
                            newCase = mapOfIdAndItsCase.get(emailMsg.RelatedToId);
                        }  
                        System.debug('Case'+newCase);
                        orgWideEmail   =    EMReply.GetStateEmail(EMReply.getLocation(newCase.Plan_ID__c));
                        system.debug('## mapOfIdAndItsCase ###' + mapOfIdAndItsCase);
                        system.debug('## new case ###' + newCase);
                        system.debug('## owner type ###' + newCase.owner.Type);
                        if(newCase.owner.Type =='User' || string.valueOf(newCase.ownerId).startswith('005'))
                        {
                            toEmailAddresses.add(newCase.owner.Email);   
                            if (emailMsg.FromAddress.equalsignoreCase(orgWideEmail))
                            {
                                saveMail = false;
                                break;                            
                            }
                            List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail];
                            if(!owea.isEmpty())
                            {
                                submitterMail.setOrgWideEmailAddressId( owea[0].Id ); 
                            } 
                            submitterMail.setSubject(emailMsg.Subject.replaceAll('Sandbox:',''));
                            submitterMail.setToAddresses(toEmailAddresses);                 
                            submitterMail.setSaveAsActivity(false);    
                            submitterbody += 'Hi,<br/><br/> This is to notify that, there is an email communication added to the Case ' +newCase.caseNumber +' which you owned.<br/><br/> Thanks,<br/>Salesforce Support.';        
                            submitterMail.setHtmlBody(submitterbody); 
                            allmsg.add(submitterMail);
                            
                            if(!test.isrunningtest())
                            { 
                                Messaging.sendEmail(allmsg);
                            }
                        }
                    }
                }
            }     
            
        } 
        catch(Exception ex)
        {
            System.debug('Exception occurred'+ex);
        }         
    }
   
}