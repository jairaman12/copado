public class Extension4EmbeddedEmail{

    private final Case tCase;
    public String shortCaseId{get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public Extension4EmbeddedEmail(ApexPages.StandardController stdController) {
        this.tCase = [select origin from case where id = :ApexPages.currentPage().getParameters().get('id')];
        shortCaseId= String.valueOf(this.tCase.Id).substring(0,15);
    }

    public String getFromAddress_hold() {
        
        String sAddress;
        
        EmailToCaseRoutingAddresses__c sharedAddress = EmailToCaseRoutingAddresses__c.getValues(tCase.Origin);
        if(sharedAddress != null){
            sAddress = sharedAddress.RoutingName__c; 
            System.debug('Shared Address = ' + sAddress);
        }                                                       
        return sAddress ;
    }
    
    
        public String getFromAddress(){
        
        EmailToCaseRoutingAddresses__c te2c;
        String returnString = '';
        
        
            for(EmailToCaseRoutingAddresses__c tObj: [Select name, routingname__c from emailtocaseroutingaddresses__c where name = :tCase.Origin limit 1 ]){
                returnString = tObj.routingname__c;
            }

        return  returnString;
    }
}