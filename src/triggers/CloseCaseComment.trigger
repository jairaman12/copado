trigger CloseCaseComment on CaseComment (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(CaseComment.sObjectType);
}