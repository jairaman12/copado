public class ProviderNetworkCls 
{

    public List<SelectOption> 			networks     			{ set; get; }
    public List<SelectOption> 			networkNames 			{ set; get; }
    public Provider_Networks__c 		providerNetwork         { get; set; } 
    public String						network					{ get; set; }
    public String						networkName				{ get; set; }
    
    private String		returnUrl	=	'';
	private String 		planId;
    Private Id 			caseId;
    private Id 			providerNetworkId;
    private String		pageMode;
    private Map<String,String> networkMap 		=	 new Map<String,String>();
    private Map<String,String> networkNameMap 	=	 new Map<String,String>();
    
    public ProviderNetworkCls(ApexPages.StandardController std)
    {
        networkNames		=	new List<SelectOption>();
        networks			=	new List<SelectOption>();
        providerNetwork		=	new Provider_Networks__c();
        network				=	'';
        networkName			=	'';
        
        
        planId 				=	ApexPages.currentPage().getParameters().get('planId');
        caseId 				=	ApexPages.currentPage().getParameters().get('caseId');
        pageMode			=	ApexPages.currentPage().getParameters().get('mode');
        if(pageMode == 'edit')
        {
            providerNetworkId	=	ApexPages.currentPage().getParameters().get('networkId');
        }

        if( String.isNotEmpty( planId ) && pageMode == 'create')
        {
            System.debug('planId===>>>'+planId);
            for ( Networks_With_Codes__mdt network : [ Select Network_Code__c,Network_Name__c,Plan_Id__c from Networks_With_Codes__mdt where Plan_Id__c =: planId] )
            {
                networkNames.add( new SelectOption( network.Network_Name__c , network.Network_Name__c));
                networks.add( new SelectOption( network.Network_Code__c , network.Network_Code__c));
                networkMap.put( network.Network_Code__c, network.Network_Name__c );
                NetworkNameMap.put( network.Network_Name__c, network.Network_Code__c );
            }
          providerNetwork.Plan_Id__c		=	planId;
          providerNetwork.Case_Number__c	=	caseId;
        }else If(String.isNotEmpty( planId ) 
                 && pageMode == 'edit'
                ){
            
            providerNetwork = [ Select Id,Plan_Id__c,Case_Number__c,Comp_Grid_Code__c,Designation_Code__c,Network__c,
                                Networks_Effective_Date__c,Name__c,Panel_code__c,Roles_Code__c from Provider_Networks__c 
                                where Id =:providerNetworkId ];
            networkNames.add( new SelectOption( providerNetwork.Name__c , providerNetwork.Name__c));
            networks.add( new SelectOption( providerNetwork.Network__c , providerNetwork.Network__c));
        }
    }
    
    public PageReference  saveAction()
    {            
         returnUrl =  saveNetwork(true);
        return ( new PageReference ( returnUrl ).setRedirect(true) );
    }
    
    public PageReference saveAndNewAction()
    {            
         returnUrl =  saveNetwork(false);
        System.debug('returnUrl=====>>>>'+returnUrl);
        return ( new PageReference ( returnUrl ).setRedirect(true) ); 
    }
    
    public String saveNetwork( Boolean isSave )
    {
        String retPageURl                				=   '';
        List<Provider_Networks__c> networksForInsert	=   new List<Provider_Networks__c>();
        Provider_Networks__c	networkRec;
        
        if( providerNetwork != null ) 
        {
            If(pageMode=='edit')
            {
               networkRec	=	new Provider_Networks__c(id=providerNetworkId); 
            }else{ networkRec	=	new Provider_Networks__c(); }
                
           
            networkRec.Case_Number__c		  	=	caseId;
            networkRec.Plan_Id__c				=	planId;
            networkRec.Name__c					=	networkName;
            networkRec.Network__c				=	network;
            networkRec.Comp_Grid_Code__c		=	providerNetwork.Comp_Grid_Code__c;
            networkRec.RecordTypeId				=   utils.GetRecordTypeId('Provider_Networks__c','Network');
            networkRec.Panel_code__c			=	providerNetwork.Panel_code__c;
            networkRec.Roles_Code__c		 	=	providerNetwork.Roles_Code__c;
            networkRec.Designation_Code__c		=	providerNetWork.Designation_Code__c;
            networkRec.Networks_Effective_Date__c	=	providerNetwork.Networks_Effective_Date__c;
            networksForInsert.add( networkRec );
        }
        
        if(!networksForInsert.isEmpty()){
            upsert networksForInsert;
        }
        
        if( isSave == true )
        {
           retPageURl   =   '/' + networksForInsert[0].Id;    
        }else{retPageURl = ApexPages.currentPage().getUrl();}
        
        return retPageURl;
    }
    
    public PageReference displayNetworkNames()
    {
        if( String.isNotEmpty( network ) && networkMap.containsKey(network))
        {
            networkNames.clear();
            networkNames.add( new SelectOption(networkMap.get(network),networkMap.get(network)));
        }
        System.debug('networkNames===>>>>'+networkNames);
        return null;
    }
    
    public PageReference displayNetworks()
    {
        System.debug('networkName===>>>>'+networkName);
        if( String.isNotEmpty( networkName ) && networkNameMap.containsKey( networkName ))
        {
            networks.clear();
            networks.add( new SelectOption( networkNameMap.get(networkName),networkNameMap.get(networkName) ));
        }
        System.debug('networks===>>>>'+networks);
        return null;
    }
    
    public PageReference backToCase()
    {
         return ( new PageReference ( '/'+caseId ).setRedirect(true) );
    }
    
}