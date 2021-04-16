@isTest
public class TestMonthlyCycleTimeEmail{
          
    @isTest
    public static void test_MonthlyCycleTimeEmail(){     
                                
        DataSupportForMonthlyCycleTimeEmail ds = new DataSupportForMonthlyCycleTimeEmail();
        ds.insertDataForCustomSettings();
        String emailTemplateId = ds.returnEmailTemplateId();
        
        String htmlbody = '<html>presentation goes in here</html>';
        List<String> ta = new List<String>();
        ta.add('andrew_maddox@hcsc.net');
        String roleName = 'Business Admin';
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE id = :emailTemplateId limit 1];
                
                                                     
        Test.startTest();
        
        MonthlyCycleTimeEmail mcte = new MonthlyCycleTimeEmail();      
        
        try{
             mcte.sendMail(emailTemplateId, htmlbody, ta , roleName);
            
        	mcte.execute(null);                     
        			            
           
            
            mcte.returnHtmlBodyForRoleName(emailTemplate, roleName, 'UAT' );
            
             
        }
        catch(ListException le){
            
            System.assert(le.getMessage().contains('index'), 'This is the list exception error message');
            
        }        
        catch(Exception e){
            
            System.assert(e.getMessage().contains('error'), 'This is the general case error message');
                            
        }
                                      
        // stop the test
        Test.stopTest();

    }
    
    @isTest    
    public static void test_MonthlyCycleTimeEmailWithSeeAllDataTrue(){                               
         /*
         * 
         * Need to run with SeeAllData=true since the code is dependent on a report listing
         * and I am not able to simulate/set-up reports as data support for the test class
         * 
         * 
         */
        MonthlyCycleTimeEmail mcte = new MonthlyCycleTimeEmail(); 
       // mcte.createAndSendCycleTimeNotificationEmail();     
        
    }        
    
    
  
}