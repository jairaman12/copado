public class DataSupportForMonthlyCycleTimeEmail {

    
 
    
    
    public void insertDataForCustomSettings(){
                        
        insertCycleTimeSettings();                
    }    
    
    public String returnEmailTemplateId(){
        
        return [select id from EmailTemplate where name ='CycleTimeEmailTemplate' limit 1][0].id;
                       
    }
    
    
    public void insertCycleTimeSettings(){
        insertStatementForCycleTimeSettings('Business Admin', 'CycleTimeReport_Enterprise');                        
		insertStatementForCycleTimeSettings('CycleTimeEmailTemplate',  'CycleTimeEmailTemplate');        
		insertStatementForCycleTimeSettings('Environment',  'https://hcscprovider--dryrun1.cs13.my.salesforce.com/');        
		insertStatementForCycleTimeSettings('Illinois Supervisor',  'CycleTimeReport_Supervisor_IL1');                       
		insertStatementForCycleTimeSettings('Montana Supervisor',  'CycleTimeReport_Supervisor_MT1');                       
		insertStatementForCycleTimeSettings('New Mexico Supervisor',  'CycleTimeReport_Supervisor_NM1');                      
		insertStatementForCycleTimeSettings('Oklahoma Supervisor',  'CycleTimeReport_Supervisor_OK1');                 
		insertStatementForCycleTimeSettings('TargetProfile',  'Enterprise Profile');                      
		insertStatementForCycleTimeSettings('Texas Supervisor',  'CycleTimeReport_Supervisor_TX1');                    
		insertStatementForCycleTimeSettings('VP',  'CycleTimeReport_Enterprise');         
                                         
    }
    
    public void insertStatementForCycleTimeSettings(String name, String cObj){
        
                    insert
                  ( 
                        new CycleTimeSettings__c
                        (                                
                            name= name , CycleTimeConfigurationObject__c = cObj
                        )
                  ); 
        
    }
    
    
}