public class ContentDocumentTriggerHandler{
    
    /* Author : SethuRaman E
     * Date   : 06/20/2019
     * Ver    : 1.0
     * Business purpouse : Once uploaded no one should able to delete the file
    */ 
     
    public static void beforedelete(List<ContentDocument> oldContentDocumentList){
        for(ContentDocument conDoc : oldContentDocumentList){
            conDoc.addError('You cannot delete the file.'); 
        }   
    }
    
    /* Author : Laxman
     * Date   : 06/28/2019
     * Business purpouse : Block enterprise profile users from adding files
    */
    public void blockFileCreation(list<ContentDocument> newList){
     //PPN-47954 - Sujatha G Starts
        Boolean Enterprice_Credentialing_Rep_permission = false;
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId()];
        system.debug('##lstcurrentUserPerSet' + lstcurrentUserPerSet);
        for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                System.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
                if ( psa.PermissionSet.Name.equals('Enterprise_Credentialing_Rep') ) {
                    Enterprice_Credentialing_Rep_permission = true;
                }
        }
        //PPN-47954 - Sujatha G Ends
        String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId()].name;
        if(Label.FileBlockedProfiles.contains(profileName) &&  Enterprice_Credentialing_Rep_permission != true){
            for(ContentDocument cd:newList){
                cd.adderror('You do not have permission to add Files');
            }
        }
    }
    
}