public class DataSupportForCaseCommentTriggerHandler {
    
    
    
    public CaseComment returnNewCaseComment(Case parentCase){
            //Create data
        CaseComment cc = new CaseComment
        (
        	CommentBody = 'This is my test comment',
        	ParentId = parentCase.id,
            IsPublished = true               
        );
        insert cc;
    
    	return cc;
    
	}
    

    public Case insertDataForParentCases(){
        
        //Create a Case to initialize the Extension constructor
        Case parentCase = TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c = 't1est@test.com';
        parentCase.Govt_Programs__c = true;
        insert parentCase;
        AvoidRecursion.runAfter = false;
        return parentCase;
        
    }
    
    public Case insertDataForChildCases(Case parentCase){
        
        Case childCase = TestCaseUtil.CreateCase();   
        childCase.ParentId = parentCase.id;        
        childCase.Email_Address_Submitter__c = 't2est@test.com';
        childCase.Govt_Programs__c = true;
        insert childCase;       
        AvoidRecursion.runAfter = false;
        return childCase;
    }       
    
   public void updateCase(Case uCase, String fieldname, String value){
        
        uCase.put(fieldname, value);        
        update uCase;
        AvoidRecursion.runAfter = false;
        
    } 
         
    
    public void insertDataForCustomSettings(){
        
        
       insert
      ( 
          	new CaseLockStatus__c
        	(
            	name='Closed Processed', status__c = 'Closed Processed'
            )
        );
                
        
        
        insert
        (
            new CaseProfile__c
        	(
            	name='System Administator', ProfileName__c = 'System Administrator'
            )                      
        );
        
        insert
        (    
           new CaseProfile__c
        	(
            	
                name='ClosedCaseBypass', ProfileName__c = 'Supervisor,Montana Supervisor'
            )  
        );
        
        insert
        (
            new CaseLockStatus__c
            (
                 name='ClosedCaseStatuses', status__c = 'Closed,Closed Processed,Closed Rejected'                
                //name='ClosedCaseStatuses', status__c = 'Closed,Closed Processed,Closed Rejected'                
            )
         );   
        
        
        insert
        (
            new Email_Settings__c
            (
                 name='URL', state__c = 'http://prodevmer-hcscproviderintake.cs71.force.com'                              
            )
         );           
        
        insert
        (
            new Email_Settings__c
            (
                 name='IL', state__c = 'Netops_Provider_Update@bcbsil.com'                              
            )
         );           
        
    }    
    
    
    
    
}