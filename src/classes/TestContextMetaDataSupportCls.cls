public class TestContextMetaDataSupportCls {
  
    public static List<Request_Types__mdt> requestTypes(String planId)
    {
        List<Request_Types__mdt>  requestTypeList = new List<Request_Types__mdt>();
        String requestTypeQueryStr      =   'SELECT ' + Utils.getObjectFieldList('Request_Types__mdt') +' FROM Request_Types__mdt';
        requestTypeQueryStr             =   requestTypeQueryStr + ' where Plan_Ids__c like \'%' + planId + '%\'';
        requestTypeList =   (List<Request_Types__mdt>)Database.query( requestTypeQueryStr );
        return requestTypeList;
    }
    
    public static List<Case_Type_with_Roles__mdt> caseTypeWithRoles()
    {
        List<Case_Type_with_Roles__mdt>  caseTypeWithRolesList = new List<Case_Type_with_Roles__mdt>();
        String requestTypeQueryStr      =   'SELECT ' + Utils.getObjectFieldList('Case_Type_with_Roles__mdt') +' FROM Case_Type_with_Roles__mdt';
        caseTypeWithRolesList           =   (List<Case_Type_with_Roles__mdt>)Database.query( requestTypeQueryStr );
        return caseTypeWithRolesList;
    }

}