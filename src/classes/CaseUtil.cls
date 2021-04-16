/**This Utility class is created for adding fixed value **/
public class CaseUtil {
     public static String  OBJ_TYPE='Case';     
     public static String  REC_TYP_NM_CHG='Name_Change_Request';
     public static String  REC_TYP_NPI_ID='NPI_Tax_Id_Change';
     public static String  REC_TYP_PHY_ADD_CHG='Physical_Address_Change';
     public static String  REC_TYP_BILL_ADD_CHG='Billing_Address_Change';
     public static String  REC_TYP_CRED_CHG='Credentialing_Change';
     public static String  REC_TYP_ADMIN_CHG='Administrative_Change';   
     public static String  REC_TYP_OTHER_CHG='Other_Provider_Change'; 
     public static String  REC_TYP_PROV_GRP='Remove_Provider_from_Group_Location'; 
     public static String  REC_TYP_STAT_CHECK='Inquiry_Types'; 
     public static String  REC_TYP_NWK_CHG='Network_Change';
     public static String  REC_TYP_ADD_PROV_GRP='Add_Provider_To_Group_Location';
     public static String  REC_TYPE_MASTER_PROVIDER_CASE ='Master_Provider_Case_data';
     public static String  REC_TYP_CRM ='CRM'; /* PPN-14563  */
    
    public RecordType getRecordId(String recordName){
        
         RecordType recType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:recordName];
        
        return recType;
    }
  
}