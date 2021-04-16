public class CaseCommentTriggerHandler  implements ITrigger{
    public CaseCommentTriggerHandler() {
    }
    public void bulkBefore() {
    }
    public void bulkAfter() {
    }
    public void beforeInsert(SObject so) {
        CaseComment CaseComm = (CaseComment)so;
        string parentObjId = CaseComm.ParentId;
        List<Case> CaseStatus = [Select Status from Case where Id =:parentObjId];
        if(getCaseStatus(CaseStatus[0].Status)){
            System.debug('************getCaseStatus(CaseStatus[0].Status'+getCaseStatus(CaseStatus[0].Status));               
            if(getsProfile()){
                if(CaseStatus[0].Status == 'Prod Verification'){
                   so.addError(Label.ProdComAdd); 
                }
                /* PPN-4971
                 * 
                 * If
                 * 1.) Check to see if the Case status is one of the Closed Status values.                
                 * 2.) If the user is a Supervisor, allow Case Comment edit on closed case
                 * Then
                 * 3.)Bypass validation to allow Supervisors to add comments to closed cases. 
                 * 
                 */ 
                 else if(Utils.canBypassValidationsForClosedCase(CaseStatus[0].Status)){                               
                            System.debug('************Insert bypass matched');
                }                 
                else{
                    System.debug('************2222Insert bypass matched');
                    so.addError(Label.CommentAdd);}
            }
        }
    }
    public void beforeUpdate(SObject oldSo, SObject so) {
        CaseComment CaseComm = (CaseComment)so;
        string parentObjId = CaseComm.ParentId;
        List<Case> CaseStatus = [Select Status from Case where Id =:parentObjId];
        if(getCaseStatus(CaseStatus[0].Status)){
            if(getsProfile()){
                if(CaseStatus[0].Status == 'Prod Verification'){
                    so.addError(Label.ProdComUpd	);
                }
                /* PPN-4971
                 * 
                 * If
                 * 1.) Check to see if the Case status is one of the Closed Status values.                
                 * 2.) If the user is a Supervisor, allow Case Comment edit on closed case
                 * Then
                 * 3.)Bypass validation to allow Supervisors to add comments to closed cases. 
                 * 
                 
                 else if(Utils.canBypassValidationsForClosedCase(CaseStatus[0].Status)){                               
                            System.debug('***********Update bypass matched');
                }*/                  
                else{so.addError(Label.CommentUpdate	);}
            }
        }
    }
    public void beforeDelete(SObject so) {
        CaseComment CaseComm = (CaseComment)so;
        string parentObjId = CaseComm.ParentId;
        List<Case> CaseStatus = [Select Status from Case where Id =:parentObjId];
        boolean sProfile = getsProfile();
        if(getCaseStatus(CaseStatus[0].Status)){
            if(sProfile){
                if(CaseStatus[0].Status == 'Prod Verification'){
                    so.addError(Label.ProdComDel);
                }
                else{so.addError(Label.CommentDel);}
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
}