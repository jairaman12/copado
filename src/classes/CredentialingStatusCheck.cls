/*
-------------------------------------------------------------------------------
 Developer                   Date                   Description
----------------------------------------------------------------------------- 
 Ashok N                    5/29/2019                PPN-40802
 Sreekanth K                06/13/2019               PPN-41295
*/

public  class CredentialingStatusCheck {
   
    /*
    * @author       :   Ashok Nettem
    * @date         :   06/05/2019
    * @description  :
    * ver           :   1.0 
    * Param         :   Input will take the License_Number and return the wrapperclass
    * @JIRA Stories :   PPN-40802
    * ver           :   1.1 
    * Description   :   Part of the PPN-41295, introduced logic to swapping of Cred status and
                        Plan id is with business provided text
    * @JIRA Stories :   PPN-41295
    */
    @AuraEnabled 
    public static CredentialingStatusWrapper getProviderDetailsByLicenseNumber(String License_Number)
    {
        system.debug('License_NumberInnerclass=== '+License_Number);
        CredentialingStatusWrapper CredentialingStatus                      =   new CredentialingStatusWrapper();
        List<String> ListProviderId                                         =   new List<String>();
        Map<Id,CM_Provider_Identification__c> MapCM_Provider_Identification =   new Map<Id,CM_Provider_Identification__c>(
                                                                                    [select Id ,CM_PI_Prov__c from CM_Provider_Identification__c 
                                                                                     where CM_Prvdr_Iden_Typ_Cd__c='License' AND  CM_Issu_Ident_Nmbr__c=: License_Number
                                                                                    ]);
        
        system.debug('MapCM_Provider_Identification===>> '+MapCM_Provider_Identification.size());
        List<Account> ListAccountProviderId                                 =   new List<Account>();
        
        if(MapCM_Provider_Identification.size()>1)
        {
            CredentialingStatus.NoProviderId                           =   ' More than one results found '+License_Number+ ' Please search with NPI Number ';
        }else if(MapCM_Provider_Identification.size()==0 || MapCM_Provider_Identification.isempty())
        {
            //Apex Add the message No provider id records is found.
            CredentialingStatus.NoProviderId                                =   ' License  '+License_Number+'  was not found. Please try searching by NPI or contact your appropriate state below for further information.';
        }else if(MapCM_Provider_Identification.size()==1)
        {
            for(CM_Provider_Identification__c CM_Provider_Identification :MapCM_Provider_Identification.values())
            {
                ListProviderId.add(CM_Provider_Identification.CM_PI_Prov__c);
            }
        }
        System.debug('ListProviderId====>>>>'+ListProviderId);
        
        if(ListProviderId.size()>0)
        {
             Map<String,String> caseSettingsMap         =   getCredStatusMappingValue(); 
             Integer statusValidateCount                =   0;
             List<Public_search_history_tracking__c> trackingHistoryList    =   new List<Public_search_history_tracking__c>();
            
            for( Account provRecord : [Select Id,Cred_Status__c,Name,CM_Corporate_Entity_Code__c,Cred_Status_Date__c from 
                                                     Account where Id IN:ListProviderId Order BY Cred_Status_Date__c DESC ] )
            {
                if(!String.isEmpty(provRecord.Cred_Status__c))
                {
                 /*
                  * Converting status to lowercase as the cred status updated through ftp
                  * is in uppercase and through onbroding flow updated status in lower case
                  */
                 String tempProviderStatusStr   = provRecord.Cred_Status__c.toLowerCase();
                 String tempCorpEntityStr       = provRecord.CM_Corporate_Entity_Code__c;   
                
                if(caseSettingsMap.containsKey( tempProviderStatusStr ))
                {
                    provRecord.CM_Corporate_Entity_Code__c          =   caseSettingsMap.containsKey( provRecord.CM_Corporate_Entity_Code__c )?caseSettingsMap.get( provRecord.CM_Corporate_Entity_Code__c ) : provRecord.CM_Corporate_Entity_Code__c;
                    System.debug('CaseSettings 222====>>>'+caseSettingsMap.get( tempProviderStatusStr.toLowerCase() ));
                    provRecord.Cred_Status__c                       =   caseSettingsMap.get( tempProviderStatusStr.toLowerCase() );
                    provRecord.CM_Corporate_Entity_Code__c          =   caseSettingsMap.get( tempCorpEntityStr.toLowerCase() );
                    ListAccountProviderId.add( provRecord );
                    
                    /*
                     * Insert tracking history
                     */
                    Public_search_history_tracking__c trackingRecord    =   new Public_search_history_tracking__c();
                    trackingRecord.Provider_Displayed__c                =   provRecord.Id;
                    trackingRecord.Search_Date_and_Time__c              =   System.now();
                    trackingRecord.Cred_Status__c                       =   provRecord.Cred_Status__c ;
                    System.debug(provRecord.Cred_Status__c+'License Search status ====>>>>'+caseSettingsMap.get( provRecord.Cred_Status__c ));
                    System.debug('License Search status ====>>>>'+trackingRecord.Cred_Status__c);
                    trackingRecord.Cred_Status_Date_Displayed__c        =   provRecord.Cred_Status_Date__c;
                    trackingRecord.License_Number__c                    =   License_Number;
                    trackingHistoryList.add( trackingRecord );
                }else{
                    statusValidateCount++;
                }
              }
            }
            if(!ListAccountProviderId.isEmpty() && statusValidateCount == 0 )
            {
                CredentialingStatus.ListAccounts    =   ListAccountProviderId;
                CredentialingStatus.LicenseNumber   =   'Entered License Number '+License_Number;
                try{
                    insert trackingHistoryList;
                }catch(Exception e){
                    System.debug('trackingHistoryList===>>>'+e.getMessage());
                }
            }else{
                CredentialingStatus.NoProviderId                                =   'No Results found for entered License Number  '+License_Number+'  Please enter NPI Number or contact your appropriate state below for further information ';
            }
        }
        system.debug('CredentialingStatus=== >>> '+CredentialingStatus);
        return CredentialingStatus;
    }
    
    /*
    * @author       :   Ashok Nettem
    * @date         :   06/05/2019
    * @description  :
    * ver           :   1.0 
    * Param         :   Input will take the NPI_Number and return the wrapperclass
    * @JIRA Stories :   PPN-40802
    * ver           :   1.1 
    * Description   :   Part of the PPN-41295, introduced logic to swapping of Cred status and
                        Plan id is with business provided text
    * @JIRA Stories :   PPN-41295
    */
    @AuraEnabled 
    public static CredentialingStatusWrapper getProviderDetailsByNPINumber(String NPI_Number)
    {
        CredentialingStatusWrapper CredentialingStatus                      =   new CredentialingStatusWrapper();
        List<String> ListProviderId                                         =   new List<String>();
        List<Account> ListAccountProviderId                                =   new List<Account>();
        
        Map<Id,CM_Provider_Identification__c> MapCM_Provider_Identification =   new Map<Id,CM_Provider_Identification__c>([select Id ,CM_PI_Prov__c from 
                                                                                    CM_Provider_Identification__c where CM_Prvdr_Iden_Typ_Cd__c='NPI' AND  
                                                                                    CM_Issu_Ident_Nmbr__c=: NPI_Number]);
       
        if( MapCM_Provider_Identification.size()==0 )
        {
            //Apex Add the message No provider id records is found.
            CredentialingStatus.NoProviderId='NPI  '+  NPI_Number  +' was not found Please try searching by License number or contact your appropriate state below for further information';
        }else
        {
            for(CM_Provider_Identification__c CM_Provider_Identification :MapCM_Provider_Identification.values())
            {
                ListProviderId.add(CM_Provider_Identification.CM_PI_Prov__c);
            }
        }
        
        if(ListProviderId.size()>0)
        {
            Map<String,String> caseSettingsMap          =   getCredStatusMappingValue();
            Integer statusValidateCount                 =   0;
            List<Public_search_history_tracking__c> trackingHistoryList =   new List<Public_search_history_tracking__c>();
            
            for( Account provRecord : [Select Id,Cred_Status__c,Name,CM_Corporate_Entity_Code__c,Cred_Status_Date__c from 
                                       Account where Id IN:ListProviderId Order BY Cred_Status_Date__c DESC] )
            {
                if(!String.isEmpty(provRecord.Cred_Status__c))
                {
                    /*
                      * Converting status to lowercase as the cred status updated through ftp
                      * is in uppercase and through onbroding flow updated status in lower case
                      */
                    String tempProviderStatusStr1    =   provRecord.Cred_Status__c.toLowerCase();
                    String tempCorpEntityStr        =    provRecord.CM_Corporate_Entity_Code__c;
                    for(String str : caseSettingsMap.keySet()){
                        System.debug(tempProviderStatusStr1+'str===>>>>'+str);
                        if(Str.trim()==tempProviderStatusStr1.trim()){
                            System.debug('Inside str===>>>>'+str);
                        }
                    }
                    if(caseSettingsMap.containsKey( tempProviderStatusStr1 ))
                    {
                        
                        provRecord.CM_Corporate_Entity_Code__c          =   caseSettingsMap.containsKey( provRecord.CM_Corporate_Entity_Code__c )?caseSettingsMap.get( provRecord.CM_Corporate_Entity_Code__c ) : provRecord.CM_Corporate_Entity_Code__c;
                        System.debug('CaseSettings 111====>>>'+caseSettingsMap.get( tempProviderStatusStr1));
                        provRecord.Cred_Status__c                       =   caseSettingsMap.get( tempProviderStatusStr1 );
                        provRecord.CM_Corporate_Entity_Code__c          =   caseSettingsMap.get( tempCorpEntityStr.toLowerCase() );
                        ListAccountProviderId.add( provRecord );
                        
                        /*
                         * Insert tracking history
                         */
                        Public_search_history_tracking__c trackingRecord    =   new Public_search_history_tracking__c();
                        trackingRecord.Provider_Displayed__c                =   provRecord.Id;
                        trackingRecord.Search_Date_and_Time__c              =   System.now();
                        trackingRecord.Cred_Status__c                       =   provRecord.Cred_Status__c ; 
                        System.debug('NPI Search status ====>>>>'+trackingRecord.Cred_Status__c);
                        trackingRecord.Cred_Status_Date_Displayed__c        =   provRecord.Cred_Status_Date__c;
                        trackingrecord.NPI_Number__c                        =   NPI_Number;
                        trackingHistoryList.add( trackingRecord );
                    }else{
                        statusValidateCount++;
                    }
              }
            }
            if( !ListAccountProviderId.isEmpty() && statusValidateCount == 0 )
            {
                CredentialingStatus.ListAccounts    =   ListAccountProviderId;
                CredentialingStatus.LicenseNumber   =   'Entered NPI Number '+NPI_Number;
                
             try{
                    insert trackingHistoryList;
                }catch(Exception e){
                    System.debug('trackingHistoryList===>>>'+e.getMessage());
                }
            }else{
                CredentialingStatus.NoProviderId='No Results found for entered NPI Number '+  NPI_Number  +'  Please enter License Number or contact your appropriate state below for further information';
            }
        }
        return CredentialingStatus;
    }
    
  /*
    * @author       :   Sreekanth K
    * @date         :   06/05/2019
    * @description  :   This function to provide the making value for the cred status on the Account
    * ver           :   1.0 
    * Param         :
    * @JIRA Stories :   PPN-41295
    */
    @AuraEnabled 
    public static Map<String,String> getCredStatusMappingValue( )
    {
       Map<String,String> caseSettingsMap                       =   new Map<String,String>();
        List<Case_Mapping_Settings__mdt> CredStatusMetadataList =   [Select Actual_Value__c,Mapping_value__c,Id 
                                                                    from Case_Mapping_Settings__mdt];
       String   tempString  =   '';
        
        if( !CredStatusMetadataList.isEmpty() )
        {
            for( Case_Mapping_Settings__mdt record : CredStatusMetadataList )
            {
                tempString = record.Actual_Value__c;
                System.debug('Actaul Value===>>>>>'+tempString.toLowerCase());
                caseSettingsMap.put( tempString.toLowerCase() , record.Mapping_value__c );
            }
        } 
        
        return caseSettingsMap;
    }     
    /*
    * @author       : Ashok Nettem
    * @date         : 06/05/2019
    * @description  :Wrapping the account and other values and sending as the respone
    * ver           :1.0 
    * Param         :
    * @JIRA Stories : PPN-40802
    */
    public class CredentialingStatusWrapper{
       
        @AuraEnabled
        public List<Account> ListAccounts{get;set;}
        @AuraEnabled
        public String MutipleProviderId{get;set;}
        @AuraEnabled
        public String NoProviderId{get;set;}
        @AuraEnabled
        public String LicenseNumber{get;set;}
        @AuraEnabled
        public String NPINumber{get;set;}
        
    }
    
    
}