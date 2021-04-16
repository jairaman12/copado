/**************************************************************************************************
Apex Class Name  : RolodexAffiliationController
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/11/2018             PPN-14680,PPN-17862 ,PPN-18686
* Andrew Maddox              06/11/2018             PPN-18686       
***************************************************************************************************/
public class RolodexAffiliationController {
    
    public Affiliations__c      aff             { set; get ; }
    public String               provId          { Set;  get; }
    public Boolean              displayRollDown { set; get;  }
    public Boolean              isEditPage { set; get;   }
    public String               acctOrPfin { set; get;   }
    private String              acctId          = '';
    Private String              returnUrl       = '';
    private String              planId          = '';
    
    private Id                  affId;
       
    
    public RolodexAffiliationController( )
    {
        isEditPage      =   false;
        aff             =   new Affiliations__c();
        provId          =   '';
        displayRollDown =   false;
        acctOrPfin = '';
        if( ApexPages.currentPage().getParameters().get('isEditPage') == 'true' )
        {
            isEditPage  =   true;
            affId           =   ApexPages.currentPage().getParameters().get('id');
            String queryString  = 'SELECT ' + Utils.getObjectFieldList('Affiliations__c')+' FROM Affiliations__c where id=\''+ApexPages.currentPage().getParameters().get('id')+'\' limit 1';
            aff = (Affiliations__c)Database.query( queryString );
            acctId = aff.CM_Affiliated_Provider_Name__c;
            provId = aff.Entity_Prov_Id__c;
        }else{
            system.debug('inside create page===>>>>'+ ApexPages.currentPage().getParameters().get('isEditPage'));
            aff.CM_Corporate_Entity_Code__c     =   ApexPages.currentPage().getParameters().get('planId');
            planId                              =   ApexPages.currentPage().getParameters().get('planId');
            aff.CM_Affiliated_Provider_Name__c  =   ApexPages.currentPage().getParameters().get('id');    
            acctId                              =   ApexPages.currentPage().getParameters().get('id') ;    
        }
           
    }
    
    public void displayRolldownAction()
    {
      
        Account acct            =   new Account();
        CM_SPL_Addr__c splAddr  =   new CM_SPL_Addr__c();
        System.debug(acctOrPfin+'isProviderChanged=====>>>>');
        if(!String.isEmpty( aff.Account__c) && acctOrPfin == 'account' )
        {
             System.debug(acctOrPfin+'aff provider entity=====>>>>'+aff.Account__c);
            acct            =   [Select Id,Class__c,Prov_ID__c from Account where Id=:aff.Account__c];  
            provId          =   acct.Prov_ID__c;
            aff.Affiliated_to_Service_PFIN__c  = null ;
            acctOrPfin  = '';
            
        }else if( !String.isEmpty( aff.Affiliated_to_Service_PFIN__c ) && acctOrPfin == 'pfin')
        {
            System.debug(acctOrPfin+'aff.Affiliated_to_Service_PFIN__c=====>>>>'+aff.Affiliated_to_Service_PFIN__c);
            splAddr =   [SELECT CM_SPL_Prov__c,Id,CM_SPL_Prov__r.Class__c,CM_SPL_Prov__r.Prov_ID__c,Name FROM CM_SPL_Addr__c where id=:aff.Affiliated_to_Service_PFIN__c];
            aff.Account__c  =   splAddr.CM_SPL_Prov__c;
            provId          =   splAddr.CM_SPL_Prov__r.Prov_ID__c;
            acctOrPfin      =   '';
        }
        
        if( ( !String.isEmpty( acct.Class__c) && acct.Class__c == 'C' ) || 
           ( !String.isEmpty(splAddr.CM_SPL_Prov__r.Class__c ) && splAddr.CM_SPL_Prov__r.Class__c == 'C')  )
        {
           displayRollDown = true;
            if(aff.Roll_Down__c == true){
                aff.Roll_Down__c = false;
            }   
                
         }else{
            System.debug('displayRollDown false===>>>>'+displayRollDown);
            displayRollDown = false; 
             if(aff.Roll_Down__c == true){
                aff.Roll_Down__c = false;
            }  
        }
    }
    
    
      /***************************************************************
     * @inputs: none
     * @output: 
     **************************************************************/
    public PageReference  saveAffiliationAction()
    {            
        returnUrl =  affiliationSaveUtility(true);
        if(returnUrl != NULL)
            return ( new PageReference ( returnUrl ).setRedirect(true) );
        return null;
    }
    
    public PageReference refreshPage(){
        
        returnUrl='/apex/RolodexAffiliationPage?isdtp=vw&id='+affId+'&planId='+planId+'&from=Affiliation&isEditPage=true'; 
        return ( new PageReference ( returnUrl ).setRedirect(true) );
    }
      /***************************************************************
     * @inputs: none
     * @output: This method is invoked by Save & New commandbutton
     **************************************************************/
    public PageReference  saveAndNewAffiliationAction()
    {
        returnUrl = affiliationSaveUtility(false);
        if(returnUrl != NULL){
            return ( new PageReference ( returnUrl ).setRedirect(true) );
            }
            return null;
    }

    public String affiliationSaveUtility( Boolean isSave )
    {
        String retPageURl                           =   '';
        List<Affiliations__c> affToInsert           =   new List<Affiliations__c>();
        Affiliations__c affToSave;
        
        if(isEditPage==true){
          affToSave                 =   new Affiliations__c(Id=affId);
        }else{
         affToSave                  =   new Affiliations__c();   
        }
        
        string phone = aff.Phone__c != NULL ? aff.Phone__c.replaceAll( '[^0-9]' , '' ) : NULL;
        string mobilePhone = aff.Mobile_Phone__c != NULL ? aff.Mobile_Phone__c.replaceAll( '[^0-9]' , '' ): NULL ;
        string fax = aff.Fax__c != NULL ? aff.Fax__c.replaceAll( '[^0-9]' , '' ) : NULL;
        
        system.debug('###### phone ####' + phone);
        system.debug('###### mobilePhone ####' + mobilePhone);
        system.debug('###### fax ####' + fax);
        
        if(phone != NULL && (!Phone.isNumeric() || phone.length() != 10)){
            aff.Phone__c.addError('Invalid Phone Number or Format');
            return NULL;
        }
        if(mobilePhone != NULL && (!mobilePhone.isNumeric() || mobilePhone.length() != 10)){
            aff.Mobile_Phone__c.addError('Invalid Mobile Phone Number or Format');
            return NULL;
        }
        if(fax != NULL && (!fax.isNumeric() || fax.length() != 10)){
            aff.Fax__c.addError('Invalid Fax Number or Format');
            return NULL;
        }
        
        affToSave.RecordTypeId                      =   Utils.GetRecordTypeId( 'Affiliations__c', 'Rolodex_Affiliation');
        affToSave.Account__c                        =   aff.Account__c;
        affToSave.Affiliated_to_Service_PFIN__c     =   aff.Affiliated_to_Service_PFIN__c;
        affToSave.CM_Corporate_Entity_Code__c       =   aff.CM_Corporate_Entity_Code__c;
        affToSave.Roll_Down__c                      =   aff.Roll_Down__c;
        affToSave.CM_Affiliated_Provider_Name__c    =   aff.CM_Affiliated_Provider_Name__c;
        affToSave.Start_Date__c                     =   aff.Start_Date__c;
        affToSave.End_Date__c                       =   aff.End_Date__c;
        affToSave.Status__c                         =   aff.Status__c;
        affToSave.Role__c                           =   aff.Role__c;
        affToSave.Phone__c                          =   aff.Phone__c;
        affToSave.Mobile_Phone__c                   =   aff.Mobile_Phone__c;
        affToSave.Fax__c                            =   aff.Fax__c;
        affToSave.Email__c                          =   aff.Email__c;
        affToInsert.add(affToSave);
        Database.UpsertResult[] srList              =   Database.upsert( affToInsert , false );
        
        for( DataBase.UpsertResult sr : srList )
        {
            if( sr.isSuccess() && isSave == true )
            {
                System.debug('sr.getId===>>>'+sr.getId());
                retPageURl  = '/'+sr.getId();   
            }else if( sr.isSuccess() && isSave == false  )
            {
                // PPN-19759 fix
                retPageURl  = '/apex/RolodexAffiliationPage?id='+acctId+'&planId='+planId+'&isEditPage=false'+'&planId='+planId; 
            }
        }
        
        return retPageURl;
    }
    
    /*
    * This method is invoked by cancel commandbutton
    */
    public Pagereference cancelAction(){ 

        return (new PageReference('/'+acctId).setRedirect(true));
    }

}