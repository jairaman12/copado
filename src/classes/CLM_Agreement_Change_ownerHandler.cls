/******************************
Apex Class Name     : CLM_Agreement_Change_ownerHandler
Version             : 1.0
Function            : This is a handler class for CLM_Reimbursement trigger which checkS the change owner functionality,
                      checking if the new user being assigned belongs to the same plan, or if the user is a clm 
                      admin or system admin and if that's not the case throwing an error


Developer                  Date                                
------------------------------------------------------------------------------------- 
Chaitanya Motupali         8/7/2019  

*****************************/
// Code written for checking the change owner functionality, checking if the new user being assigned belongs to the 
// same plan, or if the user is a clm admin or system admin
public class CLM_Agreement_Change_ownerHandler 
{
    //Method takes in 3 arguments, a list of agreements either getting created or edited, an old map of all the agreements
    //and a new map of all the agreements
	public static void beforeUpdate(List<Apttus__APTS_Agreement__c>agreementList ,Map<Id,Apttus__APTS_Agreement__c> agreementOldMap,Map<Id,Apttus__APTS_Agreement__c> agreementNewMap)
    { 
        set<Id> ownerIds=new set<Id>();
        map<string,user> ownerMap=new map<string,user>();
        //Iterating through the list of all the agreements given as an input to the before update method
        for(Apttus__APTS_Agreement__c agrmt: agreementList)
        {
            ownerIds.add(agrmt.ownerId);
        }
        
        //Query to get the roles and profiles of the users, which are added to the ownerMap
        for(user u: [select name,userrole.Name,profile.Name from user where Id IN:ownerIds])
        { 
            ownerMap.put(u.Id,u);
        }
        
        for(Apttus__APTS_Agreement__c agrmt:agreementList)
        { 
            user owner;
            //Getting all the owner id's and adding them to the ownerMap
            if(ownerMap.get(agrmt.ownerId)!=null)
            {
                owner=ownerMap.get(agrmt.ownerId);
            }
            //Condition to check that plan and owner of the agreement are same or the owner is either CLM Admin or System
            //Administrator
            if(((agrmt.Plan__c=='Illinois' && (owner.userrole.Name!='CLM Illinois' && owner.userrole.Name!='CLM Admin' && owner.userrole.Name!='Illinois Supervisor' && owner.userrole.Name!='Illinois PNC'))|| (agrmt.Plan__c=='Montana' && (owner.userrole.Name!='CLM Montana' && owner.userrole.Name!='CLM Admin' && owner.userrole.Name!='Montana Supervisor' ) )|| (agrmt.Plan__c=='New Mexico' && (owner.userrole.Name!='CLM New Mexico' && owner.userrole.Name!='CLM Admin' && owner.userrole.Name!='New Mexico Supervisor') )|| (agrmt.Plan__c=='Oklahoma' && (owner.userrole.Name!='CLM Oklahoma' && owner.userrole.Name!='CLM Admin' && owner.userrole.Name!='Oklahoma Supervisor')) || (agrmt.Plan__c=='Texas' && (owner.userrole.Name!='CLM Texas' && owner.userrole.Name!='CLM Admin' && owner.userrole.Name!='Texas PNC' && owner.userrole.Name!='Provider Data Rep- TX' && owner.userrole.Name!='Texas Supervisor')))&& owner.profile.Name!='System Administrator')
            { 
                //Throwing an error stored in the custom label CLM Owner Error
                agrmt.adderror(system.label.CLM_Owner_Error);
            }            
        }
    }
}