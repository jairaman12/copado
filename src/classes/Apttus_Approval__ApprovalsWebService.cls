/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ApprovalsWebService {
    global ApprovalsWebService() {

    }
    webService static Boolean addApprovalEmailAttachment(Id sObjectId, Id attId) {
        return null;
    }
    webService static Boolean addCommentsToRequest(Id requestId, String comments) {
        return null;
    }
    global static void addSObjectToCache(SObject modifiedSO) {

    }
    webService static Boolean approveRequest(Id requestId, String comments) {
        return null;
    }
    webService static Boolean areActionsSupported(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static Boolean canApproveRejectRequest(Id requestId) {
        return null;
    }
    webService static Boolean cancelApprovals(String sObjectType, Id sObjectId) {
        return null;
    }
    webService static List<String> checkIfApprovalRequired2(String headerIdStatus, List<String> childIdStatusList, List<Id> modifiedChildObjectIds) {
        return null;
    }
    webService static List<Boolean> checkIfApprovalRequired(List<Id> sObjectIds) {
        return null;
    }
    webService static Apttus_Approval.SubmissionComments checkIfCommentsRequired(Id ctxObjectId, String ctxObjectType) {
        return null;
    }
    webService static Apttus_Approval.SubmissionComments checkIfCommentsRequired2(Id ctxObjectId, String ctxObjectType) {
        return null;
    }
    webService static Id cloneEmailTemplate(Id originalId) {
        return null;
    }
    webService static Boolean copyAttachment(Id destParentId, Id attId) {
        return null;
    }
    webService static Boolean createAdhocApproval(Id contextRequestId, String stepLabel, String assigneeType, Id assigneeId, String submissionComment, String relativeLocationToContext, List<String> dependsOnContextRequestIdList, List<String> dependsOnMeContextRequestIdList, Boolean sendEmail, Boolean notifyOnly) {
        return null;
    }
    webService static Boolean escalateRequest(Id requestId) {
        return null;
    }
    webService static String getAddCommentPageUrl(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static List<Attachment> getApprovalEmailAttachmentsWithName(Id sObjectId, String attName) {
        return null;
    }
    webService static List<Apttus_Approval__Approval_Request__c> getApprovalHistory(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static String getApproveRejectPageUrl(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static List<Apttus_Approval.AP.CriteriaFieldDO> getEntryCriteriaFields(String ctxObjectType) {
        return null;
    }
    webService static String getMyApprovalsPageUrl(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static String getReassignPageUrl(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static Boolean isApprovalRequired(String sObjectType, Id sObjectId) {
        return null;
    }
    webService static Boolean isEmailApprovalResponseEnabled() {
        return null;
    }
    webService static Boolean isStatusCancelled(Apttus_Approval__Approval_Request__c requestSO) {
        return null;
    }
    webService static Boolean previewApprovals(String sObjectType, Id sObjectId) {
        return null;
    }
    webService static Boolean reassignRequest(Id requestId, Id toAssigneeId, String comments) {
        return null;
    }
    webService static Boolean rejectRequest(Id requestId, String comments) {
        return null;
    }
    webService static Boolean replaceApprovalEmailAttachment(Id sObjectId, Id attId) {
        return null;
    }
    global static Id selectApprovalProcess(String bizObjectType, Id bizObjectId) {
        return null;
    }
    webService static Boolean submitForApprovals(String sObjectType, Id sObjectId) {
        return null;
    }
    global static Boolean submitForApprovalsWithAttachments(String sObjectType, Id sObjectId, Id processId, Map<String,Id> templateFldNameIdMap) {
        return null;
    }
    global static Boolean submitForApprovalsWithAttachments(String sObjectType, Id sObjectId, Id processId, Map<String,String> templateFldName2NameMap) {
        return null;
    }
    webService static Boolean submitForApprovalsWithComments(String sObjectType, Id sObjectId, Apttus_Approval.SubmissionComments comments) {
        return null;
    }
    webService static Boolean updateApprovalData(Id instanceId, String sObjectType, Id contextObjId, List<Id> oldContextObjIds, List<Id> newContextObjIds) {
        return null;
    }
    webService static Boolean updateAutoReapprovalData(String sObjectType, Id contextObjId, List<Id> oldContextObjIds, List<Id> newContextObjIds) {
        return null;
    }
}
