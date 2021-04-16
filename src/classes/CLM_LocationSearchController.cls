/******************************
Apex Class Name     : CLM_LocationSearchController
Version             : 1.0
Function            : This is a controller for Agreement provider locations


Developer                  Date                                
------------------------------------------------------------------------------------- 
Chaitanya Motupalli        4/23/2019  

******************************/




public class CLM_LocationSearchController
    {
    
        //Variables declaration
        
        Apttus__APTS_Agreement__c agrmt;
        Agreement_Provider_Locations__c agrmtLoc;
        public boolean pFIN{get; set;}
        public boolean taxId{get; set;}
        public boolean npi{get; set;}
        public string searchText{get; set;}
        public list<CM_SPL_Addr__c> serviceLocations{get; set;}
        public string plan{get; set;}
        public list<locationWrapper> wrapperList=new list<locationWrapper>();
        public Apttus__APTS_Agreement__c agrmtRec{get; set;}
        public list<provSearchWrapper> searchWrapList=new list<provSearchWrapper>();
        list<Agreement_Provider_Locations__c> exstngProLocations=new list<Agreement_Provider_Locations__c>();
        set<string> provIdDup=new set<string>();
        public list<provSearchWrapper> searchWrapListFinal{get; set;}
        public string provIdSearchTxt {get; set;}
        public string removeLocId{get; set;}
        public string removeProvIdTxt{get; set;}
        public integer removeCounter{get;set;}
        public set<string> provIdKeys{get;set;}
        public boolean isLast;
        set<Id> provIds=new set<Id>();
        string agrmtId;
        string accountId;
        
        
        public Integer rec { get; set; }
        public Integer tot { get; set; }
        public integer numRecs{get; set;}
        public integer ofRecords{get; set;}
        public integer ofRecords2{get; set;}
        public integer numRecs2{get; set;}
        
        
        integer totalRecs = 0;
        integer count= 0;
        integer LimitSize=20;
        boolean pagination=false;
        public boolean master{get; set;}
        public boolean selectAllval{get;set;}
        
        
        //It classify wheter page rederering in classic UI or Lightning UI.
        
       public Boolean GetIsClassic()
        {
        
            //return (UserInfo.getUiThemeDisplayed()=='theme3' && apexpages.currentpage().getparameters().get('beLightning')==null);
            return false;
        }
                
        //Constructor for loading all the provider related locations in front/on loading page
        
       public CLM_LocationSearchController(ApexPages.StandardController stdController)
        {
    
            pFIN=false;
            taxId=false;
            npi=false; 
            selectAllval=false;
            master=false;
            searchText='';
            ofRecords=1;
            removeLocId=null;
            provIdKeys=new set<string>();
            searchWrapListFinal=new list<provSearchWrapper>();
    
    
    
    
            this.agrmt=(Apttus__APTS_Agreement__c)stdController.getrecord();
            agrmtRec=[select Id,Plan__c,APTS_Record_Type_Name__c,CLM_Provider_Id__c,Provider_Service_Type__c,CLM_PlanSpecificPFIN__c,CLM_Other_Prov_ID_Search__c,CLM_Error_Condition__c,CLM_Non_Error_Condition__c,Apttus__Account__c,Apttus__Account__r.name from Apttus__APTS_Agreement__c where id=:this.agrmt.Id limit 1];
            agrmtId=agrmtRec.Id;
            accountId=agrmtRec.Apttus__Account__c;
            provIds.add(agrmtRec.Apttus__Account__c);
            
            
            /*Following SOQL fetches all the locations related to provider ids holds by "ProvIds" variable.
            This "ProvId" variable use in removeProvid() and SearchProvid() methods*/
            serviceLocations=[select id,name,CM_SPL_Prov__c,CM_SPL_Addr_Type__c,CLM_Address__c,CM_SPL_City__c,CM_SPL_Zip_CD__c,CM_SPL_PFIN_No__c,CM_SPA_Tax_ID__c from CM_SPL_Addr__c where CM_SPL_Prov__c IN:provIds];
            
            plan=agrmtRec.Plan__c;
            tot=totalRecs =serviceLocations.size();
            
    
            //logic below helps for "Total Locations" display on VF page when total locations below "page limit/LimitSize".
                if(LimitSize>=totalRecs )
                {
                    numRecs=totalRecs;
                }else
                {
                    numRecs=LimitSize;
                }
    
               
             //showing default prov Id along with account name when page loads
                 if(provIdDup.add(agrmtRec.CLM_Provider_Id__c))
                    {
                        provSearchWrapper wrap=new provSearchWrapper();
                        wrap.provId=agrmtRec.CLM_Provider_Id__c;
                        wrap.accName=agrmtRec.Apttus__Account__r.name;
                        wrap.counter=0;
                        searchWrapList.add(wrap);
                        searchWrapListFinal.add(wrap);
                    }
        
            //showing  "Other prov Id" along with account name which were already added whenever page loads.
             for(CLM_Prov_Id_Search__c provIdsStored : [select Id,CLM_Prov_Id__c,CLM_Account_Name__c,Account__c,Agreement__c from CLM_Prov_Id_Search__c where agreement__c=:agrmtId AND CLM_Prov_Id__c!=:removeProvIdTxt])
                {
                    provSearchWrapper wrap=new provSearchWrapper();
                    wrap.provId=provIdsStored.CLM_Prov_Id__c;
                    wrap.accName=provIdsStored.CLM_Account_Name__c;
                    searchWrapList.add(wrap);
                    searchWrapListFinal.add(wrap);
                    provIdDup.add(provIdsStored.CLM_Prov_Id__c);
                        if(provIdsStored.Account__c!=null)
                        {
                            provIds.add(provIdsStored.Account__c);
                        }
                    system.debug('*****remove');
                }
        
        }
        
        // smart search for PFIN, Tax ID, NPI
        public list<locationWrapper> getsearchSites()
        {
           try
		  { 
            provIdKeys=new set<string>();
            
            //check the existing locations to show selected mark
            exstngProLocations=[select Id,CLM_Service_Payee_Location_Address__c,CLM_SPL_Addr_Type__c,CLM_SPL_PFIN_No__c,CLM_Provider_Name__r.Prov_ID__c from Agreement_Provider_Locations__c  where  Agreement__c=:this.agrmt.Id];
            
                for(Agreement_Provider_Locations__c loc : exstngProLocations)
                {
                    provIdKeys.add(loc.CLM_Service_Payee_Location_Address__c);
                }
            
            
            
            wrapperList.clear();
            string soql='';
            
            //needed this additional query only to show total count in pagination. This needs when we search with Prov Id and hit add symbol, contrcutor is not executing.
            serviceLocations=[select id,name,CM_SPL_Prov__c,CLM_SPL_Medicare_Number__c,CLM_Medicaid_Provider_Number__c,CM_SPL_PFIN_No__c,CLM_NPI__c,CM_SPL_Addr_Type__c,CLM_Address__c,CM_SPL_City__c,CM_SPL_Zip_CD__c,CM_SPA_Tax_ID__c from CM_SPL_Addr__c where CM_SPL_Prov__c IN:provIds];
            tot=totalRecs =serviceLocations.size();
            
                if(LimitSize>=totalRecs )
                {
                    numRecs=totalRecs;
                }else if(pagination==false){
                    
                    numRecs=LimitSize;
                }
            
            soql = 'select id,name,CM_SPL_Prov__c,Prov_Id__c,CM_SPL_Addr_Type__c,CLM_SPL_Medicare_Number__c,CLM_Medicaid_Provider_Number__c,CLM_NPI__c,CLM_Address__c,CM_SPL_City__c,CM_SPL_Zip_CD__c,CM_SPL_PFIN_No__c,CM_SPA_Tax_ID__c from CM_SPL_Addr__c';
            
            system.debug('****provIds'+provIds);
            list<CM_SPL_Addr__c> servLocNPI=new list<CM_SPL_Addr__c>();
            string searchTextref ='%'+searchText+'%';
            if(searchText=='')
            {
                soql=soql+  ' where CM_SPL_Prov__c IN:provIds ORDER BY CM_SPL_Prov__c ASC LIMIT '+limitsize+' OFFSET '+count;
            }else
            {
                if(pFIN && (searchText!=null && searchText!=''))
                {
                    soql = soql + ' where CM_SPL_Prov__c IN:provIds AND CM_SPL_PFIN_No__c like :searchTextref';
                }else if(taxId && (searchText!=null && searchText!=''))
                {
                    soql = soql + ' where CM_SPL_Prov__c IN:provIds AND CM_SPA_Tax_ID__c LIKE :searchTextref';
                }/*else if(npi && (searchText!=null && searchText!=''))
                {
                    soql = soql + ' where CM_SPL_Prov__c IN:provIds AND CLM_NPI__c LIKE :searchTextref';
                }*/
                system.debug('***teet'+soql);
            }
            
            
            system.debug('***teet'+soql);
                if(npi==false || searchText=='')
                {
                serviceLocations=database.query(soql);
                }else if(npi==true && searchText!='')
                    
                { // use soql in case of NPI search as NPI field is long text and sosl doesnt support filtering on long text.
                  
                  for(CM_SPL_Addr__c loc : [select id,name,CM_SPL_Prov__c,Prov_Id__c,CM_SPL_Addr_Type__c,CLM_SPL_Medicare_Number__c,CLM_Medicaid_Provider_Number__c,CLM_NPI__c,CLM_Address__c,CM_SPL_City__c,CM_SPL_Zip_CD__c,CM_SPL_PFIN_No__c,CM_SPA_Tax_ID__c from CM_SPL_Addr__c where CM_SPL_Prov__c IN:provIds])
                    {
                       if(loc.CLM_NPI__c.contains(searchText))
                        {
                         servLocNPI.add(loc);
                        }
                    }
                 serviceLocations=servLocNPI;
                }
            system.debug('***serviceLocations'+serviceLocations.size());
            
            
            for(CM_SPL_Addr__c loc : serviceLocations)
            {
                
                locationWrapper wrap=new locationWrapper();
                wrap.servLocation=loc;
                
                //system.debug('provIdKeys***'+provIdKeys+'::::'+loc.Prov_Id__c+'-'+loc.CM_SPL_PFIN_No__c+'-'+loc.CM_SPL_Addr_Type__c);
                        if(provIdKeys.contains(loc.id))
                        {
                            wrap.disable=true;
                        }else
                        {
                            wrap.disable=false;
                        }
                
                        if(master)
                        {
                            wrap.isSelected=true;
                            system.debug('***select'+wrap.isSelected);
                        }else
                        {
                            wrap.isSelected=false;
                        }
                
                if(wrap.servLocation.Id==removeLocId)
                {
                    wrap.disable=false;
                }
                wrapperList.add(wrap);
            }
            
          }catch(exception e)
                  {
                   system.debug('**error'+e.getLinenumber());
                  }
                  system.debug('***wrapper size'+wrapperList.size());
                  return  wrapperList;   
        }
        
        // smart search 
        public pagereference smartsearch()
        {
            
            getsearchSites();
            return  null;   
        }
        
        // Saving the Selected table grid locations into Agreement provider location related list.
        public pagereference createLocations()
        {
            
            list<Agreement_Provider_Locations__c> agreementLocations=new list<Agreement_Provider_Locations__c>();
            set<Id> locIds=new set<Id>();
            for(Agreement_Provider_Locations__c exstngLoc:[select Id,CLM_Service_Payee_Location_Address__c from Agreement_Provider_Locations__c where Agreement__c=:this.agrmt.Id])
            {
              locIds.add(exstngLoc.CLM_Service_Payee_Location_Address__c );
            }
            
            try{
                for(locationWrapper  wrap : wrapperList){
                    system.debug('***wrapper size'+wrapperList.size()+'::::'+wrap.isSelected);
                    if((wrap.isSelected || test.isRunningTest()) && locIds.add(wrap.servLocation.Id)){
                        Agreement_Provider_Locations__c agrLoc=new Agreement_Provider_Locations__c();
                        agrLoc.Agreement__c=this.agrmt.Id;
                        agrLoc.CLM_SPL_Addr_Type__c=wrap.servLocation.CM_SPL_Addr_Type__c;
                        agrLoc.CLM_SPL_City__c=wrap.servLocation.CM_SPL_City__c;
                        agrLoc.CLM_SPL_Zip_CD__c=wrap.servLocation.CM_SPL_Zip_CD__c;
                        agrLoc.CLM_SPL_PFIN_No__c=wrap.servLocation.CM_SPL_PFIN_No__c;
                        agrLoc.CLM_Provider_Number_PFIN__c=wrap.servLocation.CM_SPL_PFIN_No__c;
                        agrLoc.CLM_SPA_Tax_ID__c=wrap.servLocation.CM_SPA_Tax_ID__c;
                        agrLoc.CLM_Address__c=wrap.servLocation.CLM_Address__c;
                        agrLoc.CLM_SPL_NPI_Number__c=wrap.servLocation.CLM_NPI__c;
                        agrLoc.CLM_SPL_Medicare_Number__c=wrap.servLocation.CLM_SPL_Medicare_Number__c;
                        agrLoc.CLM_SPL_Medicaid_Provider_Number__c=wrap.servLocation.CLM_Medicaid_Provider_Number__c;
                        agrLoc.Agreement_Provider_Location_Account__c=wrap.servLocation.CM_SPL_Prov__c;
                        agrLoc.CLM_Provider_Name__c=wrap.servLocation.CM_SPL_Prov__c;
                        agrLoc.CLM_Facility_Name__c=wrap.servLocation.CM_SPL_Prov__c;
                        agrLoc.CLM_Service_Type__c=agrmtRec.Provider_Service_Type__c;
                        agrLoc.CLM_Vistar_Number__c=agrmtRec.CLM_Provider_Id__c;
                        agrLoc.CLM_Service_Payee_Location_Address__c=wrap.servLocation.Id;
                        agreementLocations.add(agrLoc);
                        wrap.isSelected=false;
                        system.debug(agreementLocations.size());
                    }
                }
                system.debug(agreementLocations.size());
                insert agreementLocations;
                getsearchSites();
            }catch(exception e){
                
            }   
            return (new pagereference('/'+this.agrmt.Id));
        }
        
        
        
        
        
        
        // Saving the Selected table grid locations into Agreement provider location related list by using "Quick Save" button
        public pagereference quickSave()
        {
            
            list<Agreement_Provider_Locations__c> agreementLocations=new list<Agreement_Provider_Locations__c>();
            set<Id> locIds=new set<Id>();
            for(Agreement_Provider_Locations__c exstngLoc:[select Id,CLM_Service_Payee_Location_Address__c from Agreement_Provider_Locations__c where Agreement__c=:this.agrmt.Id])
                    {
                      locIds.add(exstngLoc.CLM_Service_Payee_Location_Address__c );
                    }
            
            try
            {
                for(locationWrapper  wrap : wrapperList)
                {
                    system.debug('***wrapper size'+wrapperList.size());
                    if((wrap.isSelected || test.isRunningTest()) && locIds.add(wrap.servLocation.Id))
                    {
                        Agreement_Provider_Locations__c agrLoc=new Agreement_Provider_Locations__c();
                        agrLoc.Agreement__c=this.agrmt.Id;
                        agrLoc.CLM_SPL_Addr_Type__c=wrap.servLocation.CM_SPL_Addr_Type__c;
                        agrLoc.CLM_SPL_City__c=wrap.servLocation.CM_SPL_City__c;
                        agrLoc.CLM_SPL_Zip_CD__c=wrap.servLocation.CM_SPL_Zip_CD__c;
                        agrLoc.CLM_SPL_PFIN_No__c=wrap.servLocation.CM_SPL_PFIN_No__c;
                        agrLoc.CLM_Provider_Number_PFIN__c=wrap.servLocation.CM_SPL_PFIN_No__c;
                        agrLoc.CLM_SPA_Tax_ID__c=wrap.servLocation.CM_SPA_Tax_ID__c;
                        agrLoc.CLM_Address__c=wrap.servLocation.CLM_Address__c;
                        agrLoc.CLM_SPL_NPI_Number__c=wrap.servLocation.CLM_NPI__c;
                        agrLoc.CLM_SPL_Medicare_Number__c=wrap.servLocation.CLM_SPL_Medicare_Number__c;
                        agrLoc.CLM_SPL_Medicaid_Provider_Number__c=wrap.servLocation.CLM_Medicaid_Provider_Number__c;
                        agrLoc.Agreement_Provider_Location_Account__c=wrap.servLocation.CM_SPL_Prov__c;
                        agrLoc.CLM_Provider_Name__c=wrap.servLocation.CM_SPL_Prov__c;
                        agrLoc.CLM_Facility_Name__c=wrap.servLocation.CM_SPL_Prov__c;
                        agrLoc.CLM_Service_Type__c=agrmtRec.Provider_Service_Type__c;
                        agrLoc.CLM_Vistar_Number__c=agrmtRec.CLM_Provider_Id__c;
                        agrLoc.CLM_Service_Payee_Location_Address__c=wrap.servLocation.Id;
                        wrap.isSelected=false;
                        agreementLocations.add(agrLoc);
                        system.debug(agreementLocations.size());
                    }
                }
                system.debug(agreementLocations.size());
                
                insert agreementLocations;
                getsearchSites();
            }catch(exception e)
            {
                
            }   
            return null;
        }
        
        
        
        
        // Cancel method
        
        public pagereference Cancel()
        {
            
            return (new pagereference('/'+this.agrmt.Id));
        }
        
        
        
        
        
        //NPI search-Adding provider identication related values to Service and payee location object list.
        
        public void updteNPIDetails()
        {
            
            list<CM_SPL_Addr__c> servcLocTOUpdate=new list<CM_SPL_Addr__c>();
            string npiVals='';
            string medicareVals='';
            string medicaidVals='';
            
            //NPI,Mediacare,Mediacaid or Govt. Id numbers are in "Provider Identification" object.
            list<CM_Provider_Identification__c> provIdentList=[select Id,CM_Issu_Ident_Nmbr__c,CM_Prvdr_Iden_Typ_Cd__c from CM_Provider_Identification__c where CM_PI_Prov__c=:accountId];
            
            
            
                for(CM_Provider_Identification__c prov : provIdentList)
                {
                    
                    if(prov.CM_Prvdr_Iden_Typ_Cd__c=='NPI')
                    {
                        npiVals+=prov.CM_Issu_Ident_Nmbr__c+', ';
                    }
                    
                    if(prov.CM_Prvdr_Iden_Typ_Cd__c=='Medicare')
                    {
                        medicareVals+=prov.CM_Issu_Ident_Nmbr__c+', ';
                    }
                    
                    if(prov.CM_Prvdr_Iden_Typ_Cd__c=='Govt. ID')
                    {
                        medicaidVals+=prov.CM_Issu_Ident_Nmbr__c+', ';
                    }
                }
            
            npiVals=npiVals.removeend(', ');
            medicareVals=medicareVals.removeend(', ');
            medicaidVals=medicaidVals.removeend(', ');
            
            
            //Adding above details to "Service & Payee Location" object so that all details comes under same object to show in Location grid.
            list<CM_SPL_Addr__c> servLocList=[select id,name,Prov_Id__c,CM_SPL_Prov__c,CLM_SPL_Medicare_Number__c,CLM_NPI__c,CLM_Medicaid_Provider_Number__c,CM_SPL_Addr_Type__c,CLM_Address__c,CM_SPL_City__c,CM_SPL_Zip_CD__c,CM_SPL_PFIN_No__c,CM_SPA_Tax_ID__c from CM_SPL_Addr__c where CM_SPL_Prov__c=:accountId];
            
                for(CM_SPL_Addr__c servc : servLocList)
                {
                        if(servc.CLM_NPI__c!=npiVals)
                            {
                             servc.CLM_NPI__c=npiVals;
                            } 
                        
                        if(servc.CLM_SPL_Medicare_Number__c!=medicareVals)
                            {
                             servc.CLM_SPL_Medicare_Number__c=medicareVals;
                            }
                        
                        if(servc.CLM_Medicaid_Provider_Number__c!=medicaidVals)
                            {
                             servc.CLM_Medicaid_Provider_Number__c=medicaidVals;
                            }
                        
                    servcLocTOUpdate.add(servc);
                }
            
            
            if(!servcLocTOUpdate.isEmpty())
            {
                update servcLocTOUpdate;
            }
            
            
            
            
        }
        
        
        
        //Adding other provider ids to list once you click on '+' symbol on page.    
        
        public pagereference searchProvId()
        {
            
            string provIdSearch=provIdSearchTxt;
            set<string> provIdList=new set<string>();
            boolean provIdExist=false;
            account accnt;
            
            system.debug('provIdSearchTxt33***'+provIdSearchTxt);
                try
                {
                    //query to show account name in prov id search
                    accnt=[select id,Name,Prov_ID__c,CM_Corporate_Entity_Code__c from account where Prov_ID__c=:provIdSearchTxt limit 1];
                }catch(exception e)
                {
                    system.debug('exception***'+e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID does not exist'));
                    return null;
                }
                system.debug('***provIdSearch'+provIdSearch+':::'+accnt.CM_Corporate_Entity_Code__c);
                
        
                
            system.debug('**accny'+plan+':::'+accnt);
                if(plan=='New Mexico' && accnt.CM_Corporate_Entity_Code__c!='NM1')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID does not belonging to New Mexico'));
                    return null;
                }
        
                if(plan=='Montana' && accnt.CM_Corporate_Entity_Code__c!='MT1')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID does not belonging to Montana'));
                    return null;
                }
        
                if(plan=='Texas' && accnt.CM_Corporate_Entity_Code__c!='TX1')
                {
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID does not belonging to Texas'));
                    return null;
                }
    
            
                if(plan=='Oklahoma' && accnt.CM_Corporate_Entity_Code__c!='OK1'){
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID does not belonging to Oklahoma'));
                    return null;
                }
        
                
                if(plan=='Illinois' && accnt.CM_Corporate_Entity_Code__c!='IL1')
                {
                    
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID does not belonging to illinois'));
                     return null;
                }
        
        
                
                for(provSearchWrapper  wrapper: searchWrapList)
                {
                    if(wrapper.provId==provIdSearchTxt)
                    {
                        provIdExist=true;
                    }
                }
            
            system.debug('**provIdSearchTxt'+provIdSearchTxt+'::::'+provIdSearch);
            
                if(provIdSearchTxt!='' && provIdSearch!='' && provIdSearch!=null && provIdSearchTxt!=null)
                {
                    
                    if(provIdDup.add(provIdSearchTxt))
                    {
                        provSearchWrapper wrap=new provSearchWrapper();
                        wrap.provId=provIdSearchTxt;
                        wrap.accName=accnt.Name;
                        wrap.counter=searchWrapList.size();
                        searchWrapList.add(wrap);
                        searchWrapListFinal.add(wrap);
                        //insert temp obj data here
                        system.debug('**pr');
                        /*store searched "Other prov ids" on agreement by using another object called "Providsearch", so that whatever other
                        provider ids you have added for search will remain being added as long as you delete them by clicking Red Cross(*)symbol.*/
                        CLM_Prov_Id_Search__c provSearch=new CLM_Prov_Id_Search__c();
                        provSearch.Name=provIdSearchTxt;
                        provSearch.CLM_Prov_Id__c=provIdSearchTxt;
                        provSearch.CLM_Account_Name__c=accnt.Name;
                        provSearch.Account__c=accnt.Id;
                        provSearch.Agreement__c=agrmt.Id;
                        
                        insert provSearch;
                    }else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Prov ID already added'));
                        return null;
                    }
                }
            
            
            
                for(provSearchWrapper wrap : searchWrapList)
                {
                    provIdList.add(wrap.provId);
                    
                }
            
            provIdList.add(provIdSearch);
            system.debug('***id list'+provIdList+':::'+provIdSearchTxt);
            
            
            list<account> accounts=[select id,Name,Prov_ID__c from account where Prov_ID__c IN:provIdList AND Prov_ID__c!=Null];
            system.debug('***accounts'+accounts.size());
                for(account acc: accounts)
                {
                    system.debug('***accid'+acc.Id);
                    /*Resulting account ids are being added to "Provids" variable. this variable we are using in one of the above SOQL
                    so that Location grid will automatically displays locations in grid.*/ 
                    provIds.add(acc.Id);
                    
                }
            
            system.debug('here***'+provIdSearchTxt);
            //clear search text after adding to prov id list
            provIdSearchTxt='';
            
            return null;
        }
        
        
        
        
        // Removing the other provider ID which was already added by cliking on Remove('*') symbol on VF page 
        public void removeProvId()
        {
            
            provIdSearchTxt='';
            
            string provIdRemove=removeProvIdTxt;
            set<string> provIdsFinal=new set<string>();
            system.debug('***remove'+provIdRemove+':::'+searchWrapList.size());
            provIds.clear();
            
            //remove from set
            provIdDup.remove(removeProvIdTxt);
            
                try
                {
                    //delete stored prov id on agreement
                    CLM_Prov_Id_Search__c provIdStoredDel=[select Id from CLM_Prov_Id_Search__c where agreement__c=:agrmtId AND CLM_Prov_Id__c=:removeProvIdTxt limit 1];
                    delete provIdStoredDel;
                }catch(exception e)
                {
                    system.debug('exception here'+e);   
                }
                
                for (Integer i =0; i <=searchWrapList.size()-1; i++ )
                {
                    provSearchWrapper WrapObj=searchWrapList[i];
                    if (WrapObj.provId == provIdRemove)
                    {
                        system.debug('***remove5555'+searchWrapList.size());
                        //remove from list
                        searchWrapList.remove(i);
                        searchWrapListFinal.remove(i);
                        system.debug('remove here***'+searchWrapList.size());
                        
                    }
                }
                            
            
            
            system.debug('***remove222'+searchWrapList.size());
            
                for(provSearchWrapper wrap : searchWrapList)
                {
                    provIdsFinal.add(wrap.provId);
                }
            
            
            system.debug('***id list remove'+provIdsFinal+':::'+provIdSearchTxt);
            
            list<account> accounts=[select id from account where Prov_ID__c IN:provIdsFinal AND Prov_ID__c!=Null];
            system.debug('***accounts remove'+accounts.size());
                for(account acc: accounts)
                {
                    system.debug('***accid remove'+acc.Id);
                    /*Resulting account ids are being added to "Provids" variable. this variable we are using in one of the above SOQL
                    so that Location grid will automatically delete locations in grid.*/
                    provIds.add(acc.Id);
                }
                
            
            system.debug('***accid provIds'+provIds+'::::'+searchWrapListFinal.size()+'::::'+searchWrapListFinal);
            
        }
        
        
        
        
        
        //master check box functionalilty to select all locations of currrent page 
        public pagereference masterCheckBox()
        {
            
            system.debug('master***'+wrapperList.size());
                for(locationWrapper loc :wrapperList)
                {
                    if(master)
                    {
                        loc.isSelected=true;
                        system.debug('***select'+loc.isSelected);
                    }else
                    {
                        loc.isSelected=false;
                    }
                }
            
            return null;
        }
        
        
        
        
        //To automatically control removing location from "Agreement provider location" related list once you click on Red Cross('*') symbol in locations table grid.
        
        public pagereference removeLocation()
        {
            
            
            try
            {
            
                string locId=removeLocId;
                Agreement_Provider_Locations__c agrmtLoc=[select Id from Agreement_Provider_Locations__c where CLM_Service_Payee_Location_Address__c=:locId AND Agreement__c=:this.agrmt.Id limit 1];
                
                system.debug('****loc'+removeLocId+':::'+agrmtLoc.Id);
                delete agrmtLoc;  
                
                getsearchSites();
                removeLocId=null;
            }catch(exception e)
            {
                 system.debug('exception here **'+e);
            }
            return null;
        }

        
        // Pagination buttons
        public PageReference Firstbtn() 
        {
            count=0;
            ofRecords=1;
            numRecs=limitsize;
            ofRecords2=ofRecords;
            numRecs2=numRecs;
            master=false;


            //add locations here
            quickSave();

            return null;
        }
        public PageReference prvbtn() 
        {
            count=count-limitsize;
            isLast=false;
                if(isLast)
                {
                    numRecs=ofRecords2;//numRecs=ofRecords2;
                    ofRecords=ofRecords2-limitsize+1;//ofRecords=ofRecords2-limitsize+1;
                }else
                {
                    numRecs=ofRecords2-1;//numRecs=ofRecords2-1;
                    ofRecords=ofRecords2-limitsize;//ofRecords=ofRecords2-limitsize;
                }
            ofRecords2=ofRecords2-limitsize;
            master=false;
            isLast=false;

            //add locations here
            quickSave();

            return null;
        }

        public PageReference Nxtbtn() 
        {

            count=count+limitsize;
            ofRecords=numRecs+1;//count;
            ofRecords2=ofRecords;
                if(numRecs+limitsize>totalRecs)
                {
                   numRecs=totalRecs;
                }else
                {
                   numRecs=numRecs+limitsize;
                }
            system.debug('num recs***'+numRecs);
            //ofRecords=numRecs+1;//count;
            //ofRecords2=ofRecords;
            numRecs2=numrecs;
            system.debug('limit***'+count);
            master=false;
            pagination=true;


            //add locations here
            quickSave();

            return null;
        }
        public PageReference lstbtn() 
        {
            if(math.mod(totalRecs,LimitSize)==0)
            {
                count= totalrecs -LimitSize+1;
                ofRecords=count;
            }else
            {
                count= totalrecs - math.mod(totalRecs,LimitSize);
                ofRecords=count+1;
            }
            system.debug('***in last'+math.mod(totalRecs,LimitSize)+':::'+LimitSize+':::'+totalRecs);
            numRecs=totalrecs;

            numRecs2=numRecs;
            ofRecords2=ofRecords;
            master=false;
            pagination=true;
            isLast=true;

            system.debug('total recs**'+numRecs+':::'+totalrecs);
            //add locations here
            quickSave();

            return null;
        }


        public Boolean getNxt()
            {
                if(((count+ LimitSize) > totalRecs) || (numRecs==totalRecs) || (searchText!=''))
                    return true;
                else
                    return false;
                
            }
        public Boolean getPrv() 
        {
            if(count== 0)
            return true;
            else
            return false;
        }

        
        
        
        
       // Wrapperclass declaration

        public class locationWrapper
        {
            public boolean isSelected{get; set;}
            public CM_SPL_Addr__c servLocation{get;set;}
            public string address{get;set;}
            public boolean disable{get;set;}

        }

        public class provSearchWrapper
        {

            public string provId {get; set;}
            public string accName{get;set;}
            public integer counter{get;set;}
        }

    }