@isTest
public class OMNIProcessorsDisplayClsTest {
    
    @isTest
    static void test_OMNIProcessorsDisplayCls()
    {
         List<User>  userList  =  TestCaseUtil.createUser('Supervisor','Illinois Supervisor',3);
         insert userList;
        System.runAs(userList[0]){
        Set<Id> userIds     =  new Set<Id>();
        userIds.add(userList[0].id);
        userIds.add(userList[1].id);
        userIds.add(userList[2].id); 
            
        List<user> userLst1    =  [Select id,Name from user where Id IN:userIds ]; 
        List<User> userListtemp  =  new List<user>();
        Test.startTest();
            List<Case_Type_with_Roles__mdt>  caseTypeWithRolesListtemp  =  new List<Case_Type_with_Roles__mdt>();
            OMNIProcessorsDisplayCls opd  =  new OMNIProcessorsDisplayCls();
            caseTypeWithRolesListtemp     =  TestContextMetaDataSupportCls.caseTypeWithRoles();
            OMNIProcessorsDisplayCls.caseTypeWithRolesList       =   caseTypeWithRolesListtemp;
            userListtemp = OMNIProcessorsDisplayCls.getUsersList('IL1','Email');
        Test.stopTest();    
        }
    }

}