public class AgentWorkTriggerHandler 
{
    public AgentWorkTriggerHandler(){
        
    }
    public void onBeforeInsert(list<AgentWork> newList) 
    {
          System.debug('Before Insert111===>>>'+newList.size());
    }
     public void onAfterInsert(list<AgentWork> newList) 
     {      
        System.debug('After Insert222===>>>'+newList.size());
     }
    public void onBeforeUpdate(list<AgentWork> newList, map<id,AgentWork> oldMap) 
    {  
        System.debug('After Insert3333===>>>'+newList.size());
    }
    public void onAfterUpdate(list<AgentWork> newList, map<id,AgentWork> oldMap) 
    {  
        System.debug('After Inser44444===>>>'+newList.size());
        List<Case> finalcasesForUpdate = new List<Case>();
        
                Set<Id> caseIds = new Set<Id>();
        
        for( AgentWork agWork :  newList )
        {
            if(agWork.Status=='Opened')
              caseIds.add(agWork.WorkItemId);
        }
        Map<Id,case> caseMap    = new Map<Id,Case>([Select Id,ParentId,Status,OwnerId,RecordType.DeveloperName from Case where Id IN: caseIds]);
        if(!caseMap.isEmpty())
        {
            for(Case cs : caseMap.values())
            {
                Case recToUpdate = new Case(Id=cs.Id);
                recToUpdate.Status= 'In progress';
                recToUpdate.Plan_Id_Validation_By_Pass__c = true;
                finalcasesForUpdate.add(recToUpdate);
                System.debug('finalcasesForUpdate1111===>>>'+finalcasesForUpdate);
            }
        }
        
        if(!finalcasesForUpdate.isEmpty()) 
        upsert finalcasesForUpdate;
        
    }
 
}