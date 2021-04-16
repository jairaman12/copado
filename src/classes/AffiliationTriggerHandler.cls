/**************************************************************************************************
Apex Class Name  : AffiliationTriggerHandler
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/11/2018             PPN-17862         
***************************************************************************************************/
public class AffiliationTriggerHandler 
{
    private string affCode                  =   'Medical Group Participant (MGP)';
    private List<Affiliations__c> affRollupsForInsert = new List<Affiliations__c>();
    private String ME_RecordType_Name       =   'Master_Entity_Account';
    private String Group_RecordType_Name    =   'Entity_Account';
    
    
     public void onBeforeInsert( List<Affiliations__c> newList )
    { 
        createAffiliations( newList );
    }
    
    public void onBeforeUpdate( List<Affiliations__c> newList , Map<id,Affiliations__c> oldMap )
    {
        ValidatePhoneFormat(newList);
        createAffiliations(newList);
    }
    
    public void ValidatePhoneFormat( List<Affiliations__c> newList ){
        
        for(Affiliations__c aff : newList){
            string phone = aff.Phone__c != NULL ? aff.Phone__c.replaceAll( '[^0-9]' , '' ) : NULL;
            string mobilePhone = aff.Mobile_Phone__c != NULL ? aff.Mobile_Phone__c.replaceAll( '[^0-9]' , '' ): NULL ;
            string fax = aff.Fax__c != NULL ? aff.Fax__c.replaceAll( '[^0-9]' , '' ) : NULL;
            
            if(phone != NULL && (!Phone.isNumeric() || phone.length() != 10)){
                aff.Phone__c.addError('Invalid Phone Number or Format');
            }
            if(mobilePhone != NULL && (!mobilePhone.isNumeric() || mobilePhone.length() != 10)){
                aff.Mobile_Phone__c.addError('Invalid Mobile Phone Number or Format');
            }
            if(fax != NULL && (!fax.isNumeric() || fax.length() != 10)){
                aff.Fax__c.addError('Invalid Fax Number or Format');
            }
        }
    }
    
    public void createAffiliations( List<Affiliations__c> newList )
    {
        Map<id,Affiliations__c> roldexAndProviderAcctIdMap  =   new Map<id,Affiliations__c>();
        List<Affiliations__c> refinedAffiliations           =   new List<Affiliations__c>();
        List<Affiliations__c> refinedMEAffiliations         =   new List<Affiliations__c>();
        Set<Id>     rolodexAcctIdSet            =   new Set<id>();
        Set<id>     providerAcctIdSet           =   new Set<Id>();
        Set<Id>     groupAccoutIdSet            =   new Set<Id>();
        Set<Id>     meAccountIdSet              =   new Set<Id>();
        
        for( Affiliations__c aff :  newList )
        {
           
            if(aff.Roll_Down__c == true)
            {
                roldexAndProviderAcctIdMap.put(aff.Account__c,aff);
                rolodexAcctIdSet.add( aff.CM_Affiliated_Provider_Name__c );
                providerAcctIdSet.add( aff.Account__c );
            }
        }
        System.debug('roldexAndProviderAcctIdMap===>>>'+roldexAndProviderAcctIdMap.keySet());
        if(!providerAcctIdSet.isEmpty())
        { 
            for(Account acct : [Select Id,RecordTypeId,RecordType.DeveloperName from Account Where Id IN:providerAcctIdSet])
            {
                if(acct.RecordType.DeveloperName == ME_RecordType_Name )
                {
                    System.debug('In side ME account'+acct.Id);
                    meAccountIdSet.add(acct.Id);
                }else if( acct.RecordType.DeveloperName == Group_RecordType_Name ){
                    System.debug('In side Group account'+acct.Id);
                   groupAccoutIdSet.add(acct.Id);
                }
            }
            
            
            if(!meAccountIdSet.isEmpty())
            {
                System.debug('meAccountIdSet===>>>'+meAccountIdSet);
                refinedAffiliations = [Select CM_Affiliated_Provider_Name__c,Account__c from Affiliations__c 
                                        where Account__c IN:meAccountIdSet ];
              
            }else If(!groupAccoutIdSet.isEmpty())
            {
               refinedAffiliations = [Select CM_Affiliated_Provider_Name__c,Account__c from Affiliations__c 
                                        where CM_Affiliated_Provider_Name__c IN:groupAccoutIdSet and CM_Affiliation_Code_Description__c=:affCode];
                
            }
              System.debug('refinedAffiliations===>>>>'+refinedAffiliations.size());
            if(!refinedAffiliations.isEmpty())
            {
                for( Affiliations__c affrec :  refinedAffiliations  )
                {
                      
                    if(    roldexAndProviderAcctIdMap.containsKey(affrec.CM_Affiliated_Provider_Name__c) )
                    {
                        // Code to create affiliations if selected account is either Entity / physician account
                        // creating affiliations for all asscoatied affiliations with affiliation description type MGP
                       Affiliations__c aff                  =   new Affiliations__c();
                        aff.Account__c                      =   affrec.Account__c;
                        aff.CM_Affiliated_Provider_Name__c  =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).CM_Affiliated_Provider_Name__c;
                        aff.CM_Corporate_Entity_Code__c     =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).CM_Corporate_Entity_Code__c;
                        aff.Start_Date__c                   =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Start_Date__c;
                        aff.End_Date__c                     =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).End_Date__c;
                        aff.Status__c                       =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Status__c;
                        aff.Role__c                         =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Role__c;
                        aff.Phone__c                        =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Phone__c;
                        aff.Mobile_Phone__c                 =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Mobile_Phone__c;
                        aff.Fax__c                          =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Fax__c;
                        aff.Email__c                        =   roldexAndProviderAcctIdMap.get(affrec.CM_Affiliated_Provider_Name__c).Email__c;
                        affRollupsForInsert.add( aff ); 
                    }else if( roldexAndProviderAcctIdMap.containsKey(affrec.Account__c) ) 
                    {
                        //PPN-19745
                        // Code to create affiliations if selected account is Master entity account
                        // If ME account gets seleted by the user , we are creating affiliations for all asscoatied affiliations with ME
                        Affiliations__c aff                 =   new Affiliations__c();
                        aff.Account__c                      =   affrec.CM_Affiliated_Provider_Name__c;
                        aff.CM_Affiliated_Provider_Name__c  =   roldexAndProviderAcctIdMap.get(affrec.Account__c).CM_Affiliated_Provider_Name__c;
                        aff.CM_Corporate_Entity_Code__c     =   roldexAndProviderAcctIdMap.get(affrec.Account__c).CM_Corporate_Entity_Code__c;
                        aff.Start_Date__c                   =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Start_Date__c;
                        aff.End_Date__c                     =   roldexAndProviderAcctIdMap.get(affrec.Account__c).End_Date__c;
                        aff.Status__c                       =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Status__c;
                        aff.Role__c                         =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Role__c;
                        aff.Phone__c                        =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Phone__c;
                        aff.Mobile_Phone__c                 =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Mobile_Phone__c;
                        aff.Fax__c                          =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Fax__c;
                        aff.Email__c                        =   roldexAndProviderAcctIdMap.get(affrec.Account__c).Email__c;
                        affRollupsForInsert.add( aff ); 
                    }                         
                } 
            }
           
        }
        System.debug('affRollupsForInsert===>>>>'+affRollupsForInsert);
        if(!affRollupsForInsert.isEmpty())
        {
            try{
                insert affRollupsForInsert;
            }catch(Exception e){
                System.debug('Message===>>>>'+e.getMessage());
            }
            
        }
    }
}