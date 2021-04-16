public class OMNIProcessorsDisplayCls 
{
    public Static List<Case_Type_with_Roles__mdt> 		caseTypeWithRolesList 			=	new List<Case_Type_with_Roles__mdt>();
    public static Map<String,Map<String,List<String>>> roleWithCaseTypesWithRolesMap 	=	new Map<String,Map<String,List<String>>>();
    public static Map<String,Map<String,List<User>>>   planIdRequestTypeWithUsersMap 	=	new Map<String,Map<String,List<User>>>();
    
    public OMNIProcessorsDisplayCls()
    {
        //initdataLoad();
    }
    public void initdataLoad()
    {
        
           //System.debug('roleWithCaseTypesWithRolesMap===>>>'+roleWithCaseTypesWithRolesMap); 
     }
    
    public static List<User> getUsersList(String planId,String caseType)
    {
        String requestTypeQueryStr      =   'SELECT ' + Utils.getObjectFieldList('Case_Type_with_Roles__mdt') +' FROM Case_Type_with_Roles__mdt';
        caseTypeWithRolesList           =   (List<Case_Type_with_Roles__mdt>)Database.query( requestTypeQueryStr );
        
        if(!caseTypeWithRolesList.isEmpty())
        {
           for( Case_Type_with_Roles__mdt record : caseTypeWithRolesList )
           {
               List<String> roleNames	=	new List<String>();
               roleNames.addAll(record.Role_Developer_Name__c.split(';'));
               if(roleWithCaseTypesWithRolesMap.containsKey(record.Plan_Id__c))
               {
                  if(roleWithCaseTypesWithRolesMap.get(record.Plan_Id__c).containsKey(record.CaseType__c))
                  {
                       roleWithCaseTypesWithRolesMap.get(record.Plan_Id__c).get(record.CaseType__c).addAll(roleNames);
                  }else{
                      List<String> tempStrList = new List<String>();
                      tempStrList.addAll( roleNames );
                      roleWithCaseTypesWithRolesMap.get(record.Plan_Id__c).put( record.CaseType__c , tempStrList );
                  }
               }else{
                    List<String> tempStrList1		=	new List<String>();
					tempStrList1.addall( roleNames );
       				Map<String , List<String>> tempMap	=	new Map<String , List<String>>();
					tempMap.put(record.CaseType__c  , tempStrList1);
					roleWithCaseTypesWithRolesMap.put(record.Plan_Id__c , tempMap);
               }
               }
           }
        System.debug(planId+'%%%%%===>>>>'+caseType);
     	List<User> userList		=	new List<User>();
    	Set<String> roleNameSet	=	new Set<String>();
        roleNameSet.addAll(roleWithCaseTypesWithRolesMap.get(planId).get(caseType));
        System.debug('roleNameSet===>>>'+roleNameSet);
        if(!roleNameSet.isEmpty())
        {
              //String requestTypeQueryStr1   =   'SELECT ' + Utils.getObjectFieldList('User') +' FROM User where isActive = true';
        	  userList              		=   [Select id,Name from User where UserRole.DeveloperName IN :roleNameSet AND isActive=true];
              System.debug('userList===>>>'+userList);
        }
        return userList;
    }
}