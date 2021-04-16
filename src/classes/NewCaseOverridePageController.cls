/* Created to override the built-in 'New' button that is displayed on the 'Cases' List View.
 * Only System Administrators should have access to this visualforce page.
 * This is how we are hiding the 'New' button on the 'Cases' tab in the Salesforce mobile application as part of PPN-22360
 * Configuration: Setup > Cases > Buttons, Links, and Actions > NewCase
 * Developer: Travis Self
*/
global class NewCaseOverridePageController {
    
    public Case newCase                     {get; set;}
    public List<RecordType> caseRecTypes    {get; set;}
    
    public NewCaseOverridePageController(ApexPages.StandardController controller) {
        
        newCase = new Case();
        
        caseRecTypes = new List<RecordType>();
        
        caseRecTypes = [SELECT Id, Name, Description FROM RecordType WHERE SObjectType='Case' ORDER BY Name];

    } 
    
    public PageReference createCase() {
        
        return new PageReference ( '/500/e?retURL=/apex/NewCaseOverridePage&RecordType=' + String.valueOf(newCase.recordTypeId).substring(0,15) + '&ent=Case&nooverride=1' ).setRedirect(true);
        
    }
    
    public PageReference cancel() {
        
        return new PageReference('/500/o').setRedirect(true);
        
    }
    

}