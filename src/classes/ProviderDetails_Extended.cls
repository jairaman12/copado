/****************************************************************
@Author      : Provider Intake team 
@Date        : 06/22/2017
@Description : This calss used to display broader view of Account 
details along with related objects records
******************************************************************/
public class ProviderDetails_Extended
{
    public Id accountId;
    public String numberOfRecordsToShow 									{ get; set; }    
    public set<Id>	provTaxIdentSet	=	new Set<Id>();
    public set<Id>  networkIds		=	new Set<Id>();
    
    
    public Map<Id,CM_Provider_Tax_Id__c> provIndentificationMap;
    public List<Affiliations__c>		affiliationsList					{ get; set; }
    public List<CM_Specialty__c>		specialityList						{ get; set; }
    public List<Account>				rolodexAccountsList					{ get; set; }
    public List<Case>					caseList							{ get; set; }
    public List<CM_Provider_Identification__c> provIdentificationList		{ get; set; }
    public List<CM_Provider_Tax_Id__c>	provTaxIdentificationList			{ get; set;	}
    public List<providerTaxIdenWrapper> listProvTaxIdentWrapper				{ get; set; }
    Public List<Account> accountList    									{ get; set; }
    Public Map<Id,List<CM_Specialty__c>> spltyWithNetworkIdsMap				{ get; set; }
    public Map<Id,List<CM_SPL_Addr__c>> spltyAddrMap 						{ get; set; }
    public Map<Id,List<CM_Specialty__c>> splAddressIdWithNtwrkSpltyMap_1    { get; set; }
    public static Boolean isSpeciality	{ get; set; }
    
    public ProviderDetails_Extended()
    {
        listProvTaxIdentWrapper 			= 	new List<providerTaxIdenWrapper>();
        splAddressIdWithNtwrkSpltyMap_1  	=	new Map<Id,List<CM_Specialty__c>>();
        spltyAddrMap						=	new Map<Id,List<CM_SPL_Addr__c>>();
        accountId   						=   ApexPages.currentPage().getParameters().get('Id');
        isSpeciality						=	false;
        intializeData();
    }
    
    public void intializeData()
    {
        /*
`* Account information results *
`	 */
        String acctQueryString      =   'SELECT Parent.Name,RecordType.name,' + Utils.getObjectFieldList('Account') +' FROM Account WHERE Id =:accountId';
        accountList                 =   (List<Account>)Database.query( acctQueryString );
        
        /*
* Provider information results 
*/
        String provIndentificationStr	=	'SELECT ' + Utils.getObjectFieldList('CM_Provider_Identification__c') +' FROM CM_Provider_Identification__c WHERE CM_PI_Prov__c=:accountId';
        provIdentificationList			=	(List<CM_Provider_Identification__c>)Database.query( provIndentificationStr );
        
        /*
* Provider Tax Identification results 
*/
        provIndentificationMap	=	new Map<Id,CM_Provider_Tax_Id__c>([Select Id,Name,CM_PTI_Tax_Id__c,CM_PTI_Tax_Shared_Ind__c,
                                                                       CM_PTI_Prov_Name_From__c,CM_PTI_Prov_Id_Start_Date__c,CM_PTI_Prov_Id_End_Date__c,
                                                                       CM_PTI_Tax_Type__c FROM CM_Provider_Tax_Id__c WHERE CM_PTI_Prov_Name_To__c=:accountId or  CM_PTI_Prov_Name_From__c=:accountId ]);
        System.debug('provIndentificationMap===>>>'+provIndentificationMap.size());
        for(Id provTaxId : provIndentificationMap.keySet() )
        {
            provTaxIdentSet.add( provTaxId );
        }
        if(!provIndentificationMap.isEmpty())
            populateProvTaxIdenData( provIndentificationMap );
        
        /*
* Affiliation results
*/	
        String affiliationStr	=	'SELECT '+ Utils.getObjectFieldList('Affiliations__c') +' FROM Affiliations__c WHERE Account__c =:accountId or CM_Affiliated_Provider_Name__c=:accountId';
        affiliationsList		=	(List<Affiliations__c>)Database.query( affiliationStr );
        
        /*
* Speciality results
*/	
        String specialityStr	=	'SELECT '+ Utils.getObjectFieldList('CM_Specialty__c') +' FROM CM_Specialty__c WHERE CM_SP_Provider__c =:accountId';
        specialityList			=	(List<CM_Specialty__c>)Database.query( specialityStr );
        
        /*
* Rolodex Account results
*/
        String rolodexAcctQueryStr	=	'SELECT '+ Utils.getObjectFieldList('Account') +' FROM Account WHERE CM_Rolodex_Account__c =:accountId';
        rolodexAccountsList			=	(List<Account>)Database.query( rolodexAcctQueryStr );
        /*
* Cases associated with either Entity or with Physician accounts
*/
        String caseQueryString		=	'SELECT '+ Utils.getObjectFieldList('Case') +' FROM Case WHERE 	Case_Entity__c =:accountId OR AccountId=:accountId';
        caseList					=	(List<Case>)Database.query( caseQueryString );
        /*
* Get custom settings for pagination
*/
        Web2Case__c cs_numberOfRecordsToShow = (Web2Case__c.getValues('NumberOfRecordsToShow'));
        
        if (cs_numberOfRecordsToShow !=null){
            this.numberOfRecordsToShow = cs_numberOfRecordsToShow.CaseObjectValues__c;	               
        } 
        else{
            this.numberOfRecordsToShow = '5';
        }        
        
    }
    
    public void populateProvTaxIdenData( Map<Id,CM_Provider_Tax_Id__c> provTaxIdenMap )
    {
        
        String queryString 	= 'SELECT ' + Utils.getObjectFieldList('CM_SPL_Addr__c')
            +',(SELECT '+ Utils.getObjectFieldList('CM_Specialty__c')+' FROM Specialties__r)'
            +',(SELECT '+ Utils.getObjectFieldList('CM_Network__c')+' FROM Networks1__r)'
            +',(SELECT '+ Utils.getObjectFieldList('CM_Hours_of_Operation__c')+' FROM Hours_of_Operation__r)'
            +' FROM CM_SPL_Addr__c where CM_SPL_Prov_Tax_ID__c IN : provTaxIdentSet'; 
        
        
        List<CM_SPL_Addr__c> spltyAddrList		=	(List<CM_SPL_Addr__c>)Database.query( queryString );
        Set<Id> serviceAndPayeeLocationSet		=	new Set<Id>();   
        if(!spltyAddrList.isEmpty())
        {
            for( CM_SPL_Addr__c spltyRecord : spltyAddrList )
            {  
                serviceAndPayeeLocationSet.add( spltyRecord.Id );
                if(!spltyAddrMap.containsKey( spltyRecord.CM_SPL_Prov_Tax_ID__c ) )
                {
                    System.debug('spltyRecord.CM_SPL_Prov_Tax_ID__c===>>>'+spltyRecord.CM_SPL_Prov_Tax_ID__c);
                    spltyAddrMap.put( spltyRecord.CM_SPL_Prov_Tax_ID__c, new List<CM_SPL_Addr__c>() );
                }
                spltyAddrMap.get( spltyRecord.CM_SPL_Prov_Tax_ID__c ).add( spltyRecord ); 
            }
        }
        
        /**** Specality records associated with Newworks ****/
        String networksQueryString 					=	'SELECT '+Utils.getObjectFieldList('CM_Network__c')+' FROM CM_Network__c WHERE CM_Service_Payee_Location_Address__c IN : serviceAndPayeeLocationSet';
        List<CM_Network__c>	netwrokList				=	(List<CM_Network__c>)Database.query( networksQueryString );
        
        for( CM_Network__c network : netwrokList )
        {
            networkIds.add( network.Id );
        }
        
        List<CM_Specialty__c> networkSpecialityList = new  List<CM_Specialty__c>();
        If(!networkIds.isEmpty())
        {
            networkSpecialityList = [Select Id,Name,CM_SP_Board_CD__c,Corporate_Entity_Code__c,CM_SP_Provi_Type_CD__c,CM_SP_Specialty__c,CM_SP_Specialty_CD__c,
                                     CM_SP_Effective_Date__c,	CM_SP_End_Date__c,CM_SP_Network__c,CM_SP_Acc_Tax_Addr__c,CM_SP_Prov_Type__c,CM_SP_SubSpec_CD__c,
                                     CM_SP_Provider__c FROM CM_Specialty__c WHERE CM_SP_Network__c IN : networkIds];   
        }        
                
        if(!networkSpecialityList.isEmpty()){
            for(CM_Specialty__c speciality : networkSpecialityList)
            {
                if(!splAddressIdWithNtwrkSpltyMap_1.containsKey( speciality.CM_SP_Network__c ) )
                {
                    splAddressIdWithNtwrkSpltyMap_1.put(speciality.CM_SP_Network__c, new List<CM_Specialty__c>());
                }
                splAddressIdWithNtwrkSpltyMap_1.get(speciality.CM_SP_Network__c ).add(speciality);
            }
            
        }						
        
        if(networkIds.size()>0)
        {
            for(Id tempId : networkIds)
            {
                if( !splAddressIdWithNtwrkSpltyMap_1.containsKey(tempId))
                {
                    splAddressIdWithNtwrkSpltyMap_1.put(tempId, new List<CM_Specialty__c>() );
                }
            }
        }
        
        if(!splAddressIdWithNtwrkSpltyMap_1.isEmpty())
        {
            isSpeciality = true;
        }
        
        
        
        if(!provTaxIdenMap.isEmpty())
        {
            for( Id provTaxId : provTaxIdenMap.keySet()) 
            {
                if( spltyAddrMap.containsKey( provTaxId ) )
                {
                    System.debug(spltyAddrMap.get( provTaxId ));
                    listProvTaxIdentWrapper.add( new providerTaxIdenWrapper( provTaxIdenMap.get( provTaxId ), spltyAddrMap.get( provTaxId )));
                }else{
                    listProvTaxIdentWrapper.add( new providerTaxIdenWrapper( provTaxIdenMap.get( provTaxId ),new List<CM_SPL_Addr__c>() ) );
                }
            } 
        }
    }
    
    public pageReference prevPage()
    {
        String backwardUrl = '/'+accountId;
        return (new PageReference( backwardUrl ).setRedirect(true));
    }
    
    
    /************* Inner Calss ********************/
    public class providerTaxIdenWrapper
    {
        public CM_Provider_Tax_Id__c 			provTaxIden	{ get; set; }
        public List<CM_SPL_Addr__c> 			spAddrList	{ get; set; }
        
        public providerTaxIdenWrapper( CM_Provider_Tax_Id__c  provTaxIden, List<CM_SPL_Addr__c>  spAddrList )
        {
            this.provTaxIden	=	provTaxIden;
            this.spAddrList		=	spAddrList;
        }
    }
}