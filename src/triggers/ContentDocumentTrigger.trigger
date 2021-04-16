/********************************************************************************
Apex Class Name - ContentDocumentTrigger
Version - 1.0
Created Date - June 28, 2019
Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Laxman Vattam           June 28, 2019        PPN-44640 Block File changes by Enterprise Profile
********************************************************************************/
trigger ContentDocumentTrigger on ContentDocument (before insert,before update,before delete) {
    
     /* Author : SethuRaman E
     * Date   : 06/20/2019
     * Ver    : 1.0
     * Business purpouse : Once uploaded no one should able to delete the file
     */ 
        
    if(Trigger.isBefore && Trigger.isDelete){
        ContentDocumentTriggerHandler.beforedelete(Trigger.Old);
    } 
    
    /* Author : Laxman
     * Date   : 06/28/2019
     * Business purpouse : Block enterprise profile users from adding files
    */
    ContentDocumentTriggerHandler cDTriggerHandler = new ContentDocumentTriggerHandler();
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        cDTriggerHandler.blockFileCreation(trigger.new);
    }
}