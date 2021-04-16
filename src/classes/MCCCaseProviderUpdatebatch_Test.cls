/**************************************************************************************************
Apex Class Name  : MCCCaseProviderUpdatebatch_Test
Version          : 1.0  
Functionality    : Test class for MCCCaseProviderUpdatebatch
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                  
*   Nagendra Babu               08/14/2018                
***************************************************************************************************/
@isTest
public class MCCCaseProviderUpdatebatch_Test
{
    
    static testmethod void finishMethod_MCCCaseProviderUpdatebatch()
    {
       test.starttest();
       MCCCaseProviderUpdatebatch bc=new MCCCaseProviderUpdatebatch(new List<case>(),new List<MCC_Data_Object__c>());
       //database.executebatch(bc);
       Database.BatchableContext  bc1;
        bc.start(bc1);
       bc.execute(bc1,new List<MCC_Data_Object__c>());
       bc.finish(bc1);
       test.stoptest();
    }
}