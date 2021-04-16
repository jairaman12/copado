trigger AgentWorkTrigger on AgentWork (after delete, after insert, 
                                       after undelete, after update, 
                                       before delete, before insert, 
                                       before update)
{
    
	AgentWorkTriggerHandler handler = new AgentWorkTriggerHandler();
    if(Trigger.isBefore) {		
   		if(Trigger.isInsert) {
            System.debug('Trigger Fiered on AgentWork ====>>>');
			handler.onBeforeInsert(Trigger.new);
		} 			
		else if (Trigger.isUpdate) {			
			handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
		}
		/*else if (Trigger.isDelete) {
			handler.onBeforeDelete(Trigger.old);
		} */
	}
	else if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			handler.onAfterInsert(Trigger.new);
		}			
		else if (Trigger.isUpdate) {
			handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
		}
		/*else if (Trigger.isDelete) {
			handler.onAfterDelete(Trigger.old);
		}
		else if (Trigger.isUndelete) {
			handler.onAfterUndelete(Trigger.new);
		} */
	}
}