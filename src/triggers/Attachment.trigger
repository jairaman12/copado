trigger Attachment on Attachment (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(Attachment.sObjectType);
}