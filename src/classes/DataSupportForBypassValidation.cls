public class DataSupportForBypassValidation {
            
    public void insertDataForCustomSettings(){

        insertClosedCaseStatuses();
        insertClosedCaseBypass();
        
        
    }    
            
    public void insertClosedCaseStatuses(){
        
                    insert
                  ( 
                        new CaseLockStatus__c
                        (                                
                            Name='ClosedCaseStatuses' , Status__c = 'Closed,Closed Processed,Closed Rejected'
                        )
                  ); 
        
    }
    
    public void insertClosedCaseBypass(){
        
                    insert
                  ( 
                        new CaseProfile__c
                        (                                
                            Name= 'ClosedCaseBypass' , ProfileName__c = 'Supervisor,Montana Supervisor,PNC Profile'
                        )
                  ); 
        
    }    
    
    
}