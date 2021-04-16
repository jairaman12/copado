public class CredentialingReport 
{
    
    List<String> recordTypeNames    =   new List<String>{};        
    List<String> recordTypeNames2   =   new List<String>{};
    List <Case> updCase             =   new List<Case>(); 
    List<String> caseStatusValues   =   new List<String> {};
    List<String> caseNumbersList        =   new List<String>();
        
    String mainQuery                    {get;set;}  
    String mainQuery2                   {get;set;}   
    String header                       {get;set;}    
    String fileName                     {get;set;}    
    String body                         {get;set;}    
    String subject                      {get;set;}    
    String emailList                    {get;set;}
    String failuresReportemailList      {get;set;}
    
    Integer priorCount = 0;
    Integer todaysCount = 0;
    
    String htmlEmailBody = '';
          
    public void initFromMetaData( String mdName )
    {
        Date d          =   Date.Today() ;
        system.debug('Raw Date used -->' + d);
        String tDay     =   d.format() ;
        
        system.debug('String Date used -->' + tDay);        
        
        // List fullnames of components we want to retrieve
        List<String> componentNameList                  =   new List<String>{mdName};            
            
       // Retrieve components that are records of custom metadata types based on name       
        List<Metadata.Metadata> components              =   Metadata.Operations.retrieve(
                                             Metadata.MetadataType.CustomMetadata, componentNameList);
        Metadata.CustomMetadata customMetadataRecord    = (Metadata.CustomMetadata) components.get(0);
        
        // Check fields of retrieved component
        List<Metadata.CustomMetadataValue> values       =   customMetadataRecord.values;
        for (integer i = 0; i < values.size(); i++) 
        {
            if (values.get(i).field == 'body__c') 
            {
                body = (String)values.get(i).value;
            }
            else if (values.get(i).field == 'EmailSubject__c') 
            {
                subject = (String)values.get(i).value + ' ' + tDay ;
            }
            else if (values.get(i).field == 'FileName__c') 
            {
                filename = (String)values.get(i).value + ' ' + tDay + '.csv' ;
            }
            else if (values.get(i).field == 'HeaderListing__c') 
            {
                header = (String)values.get(i).value + '\n';
            }
            else if (values.get(i).field == 'MainQuery__c') 
            {
                mainQuery = (String)values.get(i).value;
            }
            else if (values.get(i).field == 'MainQuery2__c') 
            {
                mainQuery2 = (String)values.get(i).value;
            }
            else if (values.get(i).field == 'RecipientEmailList__c') 
            {
                emailList = (String)values.get(i).value;
            }
            else if (values.get(i).field == 'Record_types__c') 
            {
                recordTypeNames = ((String)values.get(i).value).split(';');
            }
            else if (values.get(i).field == 'Record_types2__c') 
            {
                recordTypeNames2 = ((String)values.get(i).value).split(';');
            }
            else if (values.get(i).field == 'CaseStatusValues__c') 
            {
                caseStatusValues = ((String)values.get(i).value).split(';');
            }
            else if (values.get(i).field == 'Failures_Report_Recipents__c') 
            {
                failuresReportemailList = (String)values.get(i).value;
            }      
        }
        System.debug('End of loop =====>>>>');
    }
    
    
    public void callReport()
    {
        System.debug('<=========== Debugging starts ==============>');
        
        priorCount = [select count() from Case where Cred_Case_Reported__c = true and status != 'Prod Verification'];        
        
        // Query to pull provider networks associated with individual Cases. 
        // if a case doesn't have a provider network then that case not considered for reporting
        List<Provider_Networks__C> pnList   =   Database.query( mainQuery ); 
        
        // Group credential cases
        List<Case> caseList                 =   Database.query( mainQuery2 ); 
        
        Map<String,string> findDupes        =   new Map<String,String>();
        String dataString                   =   header;
        String str                          =   ''; 
        Map<id,id> added                    =   new Map<Id,Id>();
        Set<id> provid                      =   new Set<Id>();
        
        
        System.debug('record type names ->' + recordTypeNames);
        System.debug('record type names2 ->' + recordTypeNames2);
        System.debug('Case Status values ->' + caseStatusValues);
        System.debug('main query->' + mainQuery );
        System.debug('main query->' + mainQuery2 );
        system.debug('pnlist size' + pnList.size());
        system.debug('caselist size' + caseList.size());
        
        
        for( Provider_Networks__c obj : pnList  )
        {
            //Why are getting the accountId , we can directly get the credentialing_case__c Id from the recordtype and we can also get the accountId
            if( obj.credentialing_case__r.accountid != null )
                provid.add(obj.credentialing_case__r.accountid);
        }
        for(Case obj:caseList)
        {
            if(obj.accountid != null)
                provid.add(obj.accountid);
        }
        system.debug('provid:' + provid);
        if( provid.size() > 0 )
        {
            list<account> accList           =   new list<account>();
            map<Id,string> provIdName       =   new map<Id,string>();           
            accList                         =   [select Name,Id from account where Id in :provid];
            system.debug('accList===>>>:' + accList);
            system.debug('provid===>>>:' + provid);
            
            for(account a : accList )
            {
                provIdName.put( a.Id , a.Name.remove(',') );
            }
            
            system.debug('provIdName:' + provIdName);
            /*****************************************************************
             * Below code to find individual cases to be included in the report.
             * If a individual case done have a network record then the case 
             * record is not considered for reporting
             *****************************************************************/
            for(Provider_Networks__c obj:pnList)
            {
                boolean flag = false;
                String[] networkNameArray   =   new String[]{''}; 
                string tempProvName         =   '';
                string tempProvId           =   string.isblank(obj.prov_id__c)?'':obj.prov_id__c;
                
                system.debug('obj.Credentialing_Case__r.account.Name:' + obj.Credentialing_Case__r.accountid);
                if(obj.Credentialing_Case__r.accountid != null)
                    tempProvName = provIdName.get(obj.Credentialing_Case__r.accountid);
                if (string.isblank(obj.Network_Code_Name_Detail__c))
                {    
                    system.debug('skipped case number:1:' + obj.createddate + ':' + obj.Credentialing_Case__r.casenumber );
                    continue;
                }else{                    
                    networkNameArray = obj.Network_Code_Name_Detail__c.split('\n');
                }   
                system.debug('tempProvId1:' + tempProvId);
                system.debug('tempProvName1:' + tempProvName);
                if(tempProvId == '' || tempProvName == '')
                {
                    system.debug('skipped case number:2:' + obj.createddate + ':' + obj.Credentialing_Case__r.casenumber );
                    continue;   
                }
                
                for(String nName : networkNameArray)
                { 
                    string temp = nName.replaceAll('(\\r|\\n)+', '').trim();
                    if(findDupes.get(obj.Credentialing_Case__r.casenumber + tempProvId + temp) != null)
                    {
                        system.debug('skipped case number:3:' + obj.createddate + ':' + obj.Credentialing_Case__r.casenumber );
                        flag = true;
                        continue;
                    }else{
                        findDupes.put(obj.Credentialing_Case__r.casenumber + tempProvId + temp,obj.Credentialing_Case__r.casenumber + tempProvId + temp);
                    } 
                    system.debug('data:' + temp + ':' + obj.Credentialing_Case__r.casenumber);               
                    str +=  obj.Credentialing_Case__r.casenumber + ',' +
                        tempProvId + ',' +
                        tempProvName + ',' +
                        temp + ',' +
                        obj.Credentialing_Case__r.CreatedDate + ',' +
                        obj.Credentialing_Case__r.status +'\n' ;                    
                }
                if(!added.containsKey(obj.Credentialing_Case__r.Id) && !flag)
                {
                    case tempCase   = new Case();
                    tempCase.id     = obj.Credentialing_Case__r.Id;
                    tempcase.Cred_Case_Reported__c = true;
                    updCase.add(tempCase);
                    caseNumbersList.add( obj.Credentialing_Case__r.CaseNumber );
                    added.put(obj.Credentialing_Case__r.Id,obj.Credentialing_Case__r.Id);
                }            
            }
            
            for( Case obj : caseList )
            {
                boolean groupflag = false;
                sYSTEM.debug('obj===>>>>'+obj.CaseNumber);
                String[] networkNameArray = new String[]{''};
                 if (string.isblank(obj.Network_Name__c))
                {    
                    system.debug('skipped case number:4:' + obj.createddate + ':' + obj.casenumber );
                    continue;
                }else{
                    networkNameArray = obj.Network_Name__c.split(';');
                }
                for(String nName : networkNameArray)
                { 
                    string temp = nName.replaceAll('(\\r|\\n)+', '').trim();                
                    string tempProvName = '';
                    //if(obj.account.Name != null && obj.account.Name != '')
                    //    tempProvName = obj.account.Name.remove(',');
                    if(findDupes.get(obj.casenumber + temp) != null){
                        system.debug('skipped case number:5:' + obj.createddate + ':' + obj.casenumber );
                        groupflag = true;
                        continue;
                    }else{
                        findDupes.put(obj.casenumber + temp,obj.casenumber + temp);
                    }
                    string tempProvId = string.isblank(obj.Contract_ProvID__c)?'':obj.Contract_ProvID__c;
                    if(obj.accountid != null)
                        tempProvName = provIdName.get(obj.accountid);
                    
                    system.debug('data:6' + temp + ':');
                    system.debug('tempProvId2:' + tempProvId);
                    system.debug('tempProvName2:' + tempProvName);
                    if(tempProvId == '' || tempProvName == ''){
                        system.debug('skipped case number:7:' + obj.createddate + ':' + obj.casenumber );
                        groupflag = true;
                        continue;   
                    }                
                    str += 
                        obj.casenumber + ',' +
                        tempProvId + ',' +
                        tempProvName + ',' +
                        temp + ',' +
                        obj.CreatedDate + ',' +
                        obj.status +'\n';                    
                }
                if(!added.containsKey(obj.Id) && !groupflag){
                    case tempCase                   =   new Case();
                    tempCase.id                     =   obj.Id;
                    tempcase.Cred_Case_Reported__c  =   true;
                    updCase.add( tempCase );
                    caseNumbersList.add( obj.CaseNumber );
                    added.put( obj.Id,obj.Id );
                }
            }
            dataString                              = dataString+str;  
            system.debug('str===>>>' + str);
            system.debug('updCase===>>>' + updCase.size());  
           // update updCase;
        }
        System.debug('<=========== Debugging Ends ==============>');
        
        if( !String.isEmpty( dataString ) && !updCase.isEmpty() && !caseNumbersList.isEmpty())
        {
            sendEmailWithAttachment( dataString , updCase ,caseNumbersList );
        }
    }
    
    public void sendEmailWithAttachment(String dString , List<Case> casesToBeUpdated ,List<String> caseNumbersList )
    {  
       ID jobID = System.enqueueJob(new updateCredCases(dString,casesToBeUpdated,caseNumbersList,priorCount,htmlEmailBody,fileName,subject,emailList,body,failuresReportemailList));
    }    
}