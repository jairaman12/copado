@isTest
public class TestBypassValidationForClosedCase {
          
    @isTest
    public static void test_BypassValidationForClosedCase(){     
                                
        DataSupportForBypassValidation ds = new DataSupportForBypassValidation();
        ds.insertDataForCustomSettings();
                                                     
        Test.startTest();        
        
        Utils.canBypassValidationsForClosedCase('Closed Processed');
        
                                      
        // stop the test
        Test.stopTest();

    }
    
    
  
}