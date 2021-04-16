@isTest
public class TestCycleTimeDataObject {
          
    public static testMethod void test_CycleTimeDataObject(){

         // start the test execution context
        Test.startTest();
			
        CycleTimeDataObject ctdo = new CycleTimeDataObject();

		Map<String, List<String>> emailMap = ctdo.emailMap; 
        
        String pn = ctdo.profileName;

        // stop the test
        Test.stopTest();

    }
  
}