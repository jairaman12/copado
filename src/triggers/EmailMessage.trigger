trigger EmailMessage on EmailMessage (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(EmailMessage.sObjectType);
}