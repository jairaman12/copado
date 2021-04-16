public class AttachmentTriggerHandler  implements ITrigger{
    private Set<String> objectKeyPrefixSet = getObjectPrefix();
    public AttachmentTriggerHandler() {
    }
    public void bulkBefore() {
    }
    public void bulkAfter() {
    }
    public void beforeInsert(SObject so) {
        Attachment CaseAtt = (Attachment)so;
        string parentObjId = CaseAtt.ParentId;
        if(objectKeyPrefixSet.contains(parentObjId.subString(0,3))){
            List<Case> CaseStatus = [Select Status from Case where Id =:parentObjId];
            if(getCaseStatus(CaseStatus[0].Status)){
                if(getsProfile()){
                    if(CaseStatus[0].Status == 'Prod Verification'){
                        so.addError(Label.ProdAttAdd);
                    }
                    else{so.addError(Label.AttAdd);}
                }
            }
        }
    }
    public void beforeUpdate(SObject oldSo, SObject so) {
        Attachment CaseAtt = (Attachment)so;
        string parentObjId = CaseAtt.ParentId;
        if(objectKeyPrefixSet.contains(parentObjId.subString(0,3))){
            List<Case> CaseStatus = [Select Status from Case where Id =:parentObjId];
            if(getCaseStatus(CaseStatus[0].Status)){
                if(getsProfile()){
                    if(CaseStatus[0].Status == 'Prod Verification'){
                        so.addError(Label.ProdAttUpd);
                    }
                    else{so.addError(Label.AttUpdate);}
                }
            }
        }
    }
    public void beforeDelete(SObject so) {
        Attachment CaseAtt = (Attachment)so;
        string parentObjId = CaseAtt.ParentId;
        if (objectKeyPrefixSet.contains(parentObjId.subString(0,3))){
            if(getsProfile()){
                List<Case> CaseStatus = [Select Status from Case where Id =:parentObjId];
                if(CaseStatus[0].Status == 'Prod Verification'){
                    so.addError(Label.ProdAttDel);
                }
                else{so.addError(Label.AttDelete);}
            }
        }
    }
    public void afterInsert(SObject so) {   
    }
    public void afterUpdate(SObject oldSo, SObject so) {
    }
    public void afterDelete(SObject so) {
    }
    public void andFinally() {  
    }
    public static boolean getsProfile(){
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        Map<string,CaseProfile__c> CaseProfile =CaseProfile__c.getAll();
        boolean sProfile = True;
        if(CaseProfile != null && CaseProfile.containsKey(PROFILE[0].Name)){
            sProfile = False;
        }
        return sProfile;
    } 
    public static boolean getCaseStatus(String CaseStatus){
        Map<string,CaseLockStatus__c> CaseStatusMap =CaseLockStatus__c.getAll();
        boolean sCaseStatus = False;
        if(CaseStatusMap != null && CaseStatusMap.containsKey(CaseStatus)){
            sCaseStatus = True;
        }
        return sCaseStatus;
    }
    private Set<String> getObjectPrefix() {
    	String[] types = new String[]{'Case','Case'};
	    Set<String> objectKeyPrefixSet = new Set<String>();
		for (Schema.DescribeSobjectResult result : Schema.describeSObjects(types)) {
			objectKeyPrefixSet.add(result.getKeyPrefix());
		}
		
		return objectKeyPrefixSet;
    }
}