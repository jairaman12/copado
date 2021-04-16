/**************************************************************************************************
Apex Class Name  : SharedEmailInboxes
Version          : 1.0  
Functionality    : Used to get the shared email boxes from custom setting while user reply from salesforce.com
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Stroty Number 
* ----------------------------------------------------------------------------                 
*  Ashok N                    03/08/2019          PPN-29897
*/


global class SharedEmailInboxes implements QuickAction.QuickActionDefaultsHandler 
{
    
   /*
    * Author :Ashok N
    * Date :03/08/2019 
    * User story : PPN-29897
    * Ver 1.0
    * Business process : to override the from address when user send the email from salesforce.com 
    *  based on the custom setting Name and case orgin we override the fromemailId
    */ 
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) 
    {
        String sAddress;
        List<Error_Message__c> List_ErrorMessage= new List<Error_Message__c>();
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(0);
        EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject(); 
        Case Case_Query = [SELECT origin,CaseNumber, Priority FROM Case WHERE Id=:sendEmailDefaults.getContextId()];
        system.debug('Case_Query====>> '+Case_Query);
        
        try{
            for(EmailToCaseRoutingAddresses__c EmailToCaseRoutingAddresses: [Select name, routingname__c from emailtocaseroutingaddresses__c where name = :Case_Query.Origin limit 1 ]){
                if(EmailToCaseRoutingAddresses.Name!=null ||EmailToCaseRoutingAddresses.Name!='')
                {
                    system.debug('EmailToCaseRoutingAddresses.routingname__c====>> '+EmailToCaseRoutingAddresses.routingname__c);
                    emailMessage.ValidatedFromAddress=EmailToCaseRoutingAddresses.routingname__c;
                    //emailMessage.FromAddress = EmailToCaseRoutingAddresses.routingname__c;
                    emailMessage.FromAddress = '';
                    emailMessage.FromName = EmailToCaseRoutingAddresses.routingname__c;
                }
            }
        }catch(QueryException e )
        {
          system.debug('Exception message===='+e.getMessage());
        }
       
    }
    
    
}