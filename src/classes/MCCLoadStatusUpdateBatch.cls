/**************************************************************************************************
Apex Class Name  : MCCLoadStatusUpdateBatch
Version          : 1.0  
Functionality    : To update the success status on MCC Data object when cases gets created for that record
           Alos, hooking the caseId on to MCC record
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru           05/17/2018              PPN-16123,PPN-16127,PPN-16130  
* Saravana Bharathi           05/29/2018              PPN-17928,PPN-17974
* Travis Self                 09/05/2018              PPN-23099
* Sreekanth Kalluru           09/18/2018              PPN-25417
* Nagendra                    09/18/2018              PPN-25549,22986
* Travis Self                 10/25/2018              PPN-27401
***************************************************************************************************/
global class MCCLoadStatusUpdateBatch implements Database.Batchable<sobject>,Database.Stateful
{
    private String onBoardingCredRequestType    =   'Onboarding Cred Mass Status Update'; //PPN-25417
    Set<String> massCloseRequestTypes        =   new Set<String>{'ADC Mass Status','CRM Mass Status'}; //PPN-22986, PPN-27401
    Set<String>  reportNames                    =   new Set<String>{'Recruitment_File_Result','Death_File_Result','Roster_File_Result','Credentialing_cases_mass_update_report','Mass_Case_Closure_Report', 'CRM_Case_Closure_Report'};
    Map<String,Id> mccrNameWithCaseIdMap        =   new Map<String,Id>();
    Map<String,Case> mccNamaWithCaseMap         =   new Map<String,Case>(); 
/** PPN - 17928, 17974 Code Start **/
    Set<String> setOfNetworkFileIds             =   new Set<String>();
    Set<String> setOfDeathFileIds               =   new Set<String>();
    Set<String> setOfRosterFileIds              =   new Set<String>();
    Set<String> setOfCredFieldIds               =   new Set<String>();  
/** PPN - 17928, 17974 Code End **/

/** PPN - 22986 Code Start **/
    Set<String> massCloseFieldIds               =   new Set<String>(); 
    private string planId='';
/** PPN - 17928, 17974 Code End **/
    
    private String planIdOfEmailRecipients          =   '';
    private Map<String,String> fileIdWithPlanIdMap  =   new Map<String,String>();
    private map<String,String> fileIdWithPlanIdMapForADC =  new map<String,String>();
    
    public MCCLoadStatusUpdateBatch( List<Case> caseList )
    {
         System.debug('caseList ====>>>>'+caseList.Size() );
        
        system.debug('planId--'+planId);
        for( Case caseRecord :caseList ) 
        {
            System.debug('caseRecord.MCC_Record_Name__c ====>>>>'+caseRecord.MCC_Record_Name__c );
            mccrNameWithCaseIdMap.put( caseRecord.MCC_Record_Name__c , caseRecord.Id );
            mccNamaWithCaseMap.put( caseRecord.MCC_Record_Name__c, caseRecord   );
            System.debug('MCC_Record_Name__c====>>>>'+caseRecord.MCC_Record_Name__c);
        }
        
        System.debug('MCC_Record_Name__c====>>>>'+mccNamaWithCaseMap);
    }
    
    global Database.QueryLocator start( Database.BatchableContext BC ) 
    {
        System.debug('mccrNameWithCaseIdMap.keySet()===>>>'+mccrNameWithCaseIdMap.keySet());
        return DataBase.getQueryLocator( [ SELECT Id,Name,RecordType.Name,MCC_Load_Status__c,MCC_File_Type__c,MCC_Case_Id__r.Plan_Id__c,
                                          MCC_Case_Id__c,MCC_File_Id__c, MCC_Plan_Id__c,mcc_case_status__c FROM MCC_Data_Object__c 
                                          WHERE Name IN : mccrNameWithCaseIdMap.keySet() ] ); 
    }
    
    global void execute( Database.BatchableContext BC,List<MCC_Data_Object__c> mccList ) 
    {
        System.debug('mccList====>>>>'+mccList);
        List<MCC_Data_Object__c> mccRecordsForUpdate  =  new List<MCC_Data_Object__c>();
        
        for( MCC_Data_Object__c mccRecord : mccList )
        {
            // Report notification will be sent to recipients based on the plan id of the mass case creation object.
                if(mccList[0].MCC_Plan_Id__c != null) 
                {  
                    planIdOfEmailRecipients = mccList[0].MCC_Plan_Id__c;
                }
                else{
                  planIdOfEmailRecipients=[select id,Plan_ID__c from case where id=:mccList[0].MCC_Case_Id__c].plan_id__C;
                }
                
                //PPN-22986
            
            if( mccrNameWithCaseIdMap !=NULL 
               && mccrNameWithCaseIdMap.containsKey( mccRecord.Name )  
               && mccRecord.MCC_File_Type__c!= onBoardingCredRequestType 
               && !massCloseRequestTypes.contains(mccRecord.mcc_file_type__c)
              )
            {
                System.debug(mccrNameWithCaseIdMap.get( mccRecord.Name )+'mccRecord.Name====>>>>'+mccRecord.Name);
                MCC_Data_Object__c rec   =  new MCC_Data_Object__c( Id = mccRecord.Id );
                if(mccrNameWithCaseIdMap.get(mccRecord.Name) !=NULL)
                {
                    rec.MCC_Case_Id__c    =  mccrNameWithCaseIdMap.get( mccRecord.Name );
                    rec.MCC_Load_Status__c  =  true;
                    
                 }
                
                else
                {
                    rec.MCC_Load_Status__c = false;
                }
                /** PPN - 17928, 17974 Code Start **/
                if(mccRecord.RecordType.Name=='Network Recruitment')
                {
                    setOfNetworkFileIds.add(mccRecord.MCC_File_Id__c);
                }
                else if(mccRecord.RecordType.Name=='Death File')
                {
                    setOfDeathFileIds.add(mccRecord.MCC_File_Id__c);
                }
                else 
                {
                    setOfRosterFileIds.add(mccRecord.MCC_File_Id__c);
                }
                /** PPN - 17928, 17974 Code End **/ 
                mccRecordsForUpdate.add( rec );
            }else if(!mccrNameWithCaseIdMap.isEmpty()
               && mccrNameWithCaseIdMap.containsKey( mccRecord.Name )  
               && mccRecord.MCC_File_Type__c == onBoardingCredRequestType)
            {
                planIdOfEmailRecipients = mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c;
                fileIdWithPlanIdMap.put(mccRecord.MCC_File_Id__c,mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c);
                
                if( mccNamaWithCaseMap.containsKey(mccRecord.Name) 
                   && mccNamaWithCaseMap.get(mccRecord.Name).Status == mccRecord.MCC_Case_Status__c )
                {
                    MCC_Data_Object__c rec      =  new MCC_Data_Object__c( Id = mccRecord.Id ); 
                    rec.MCC_Load_Status__c      =  true;
                    rec.MCC_Plan_ID__c          =   mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c;
                    mccRecordsForUpdate.add( rec );
                }else If( mccNamaWithCaseMap.containsKey(mccRecord.Name) 
                   && mccNamaWithCaseMap.get(mccRecord.Name).Status != mccRecord.MCC_Case_Status__c )
                    
                {
                    MCC_Data_Object__c rec      =  new MCC_Data_Object__c( Id = mccRecord.Id ); 
                    rec.MCC_Load_Status__c      =  false;
                    rec.MCC_Plan_ID__c          =   mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c;
                    
                      mccRecordsForUpdate.add( rec );
                      
                }
            }else if( !mccrNameWithCaseIdMap.isEmpty()
               && mccrNameWithCaseIdMap.containsKey( mccRecord.Name )  
               && massCloseRequestTypes.contains(mccRecord.MCC_File_Type__c) )
            {
                 planIdOfEmailRecipients = mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c;
                 fileIdWithPlanIdMapForADC.put(mccRecord.MCC_File_Id__c,mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c);
                massCloseFieldIds.add(mccRecord.MCC_File_Id__c);
                if( mccNamaWithCaseMap.containsKey(mccRecord.Name) 
                   && mccNamaWithCaseMap.get(mccRecord.Name).Status == mccRecord.MCC_Case_Status__c )
                {
                    MCC_Data_Object__c rec      =  new MCC_Data_Object__c( Id = mccRecord.Id ); 
                    rec.MCC_Load_Status__c      =  true;
                    rec.MCC_Plan_ID__c         =   mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c;
                     mccRecordsForUpdate.add( rec );
                }else If( mccNamaWithCaseMap.containsKey(mccRecord.Name) 
                   && mccNamaWithCaseMap.get(mccRecord.Name).Status != mccRecord.MCC_Case_Status__c )
                    
                {
                    MCC_Data_Object__c rec      =  new MCC_Data_Object__c( Id = mccRecord.Id ); 
                    rec.MCC_Load_Status__c      =  false;
                    rec.MCC_Plan_ID__c          =   mccNamaWithCaseMap.get(mccRecord.Name).Plan_Id__c;
                    mccRecordsForUpdate.add( rec );
                      
                }
            }  
        } 
        System.debug('mccRecordsForUpdate===>>>>'+mccRecordsForUpdate);
        if( !mccRecordsForUpdate.isEmpty())
        {
            update mccRecordsForUpdate;
        }
    }
    
    global void finish( Database.BatchableContext BC )
    {
        /** PPN-17928, 17974 Code Start**/
        //listOfReports = [Select Id From Report Where DeveloperName='Recruitment_File_Result'];
        // listOfReports = [Select Id From Report Where DeveloperName='Death_File_Result'];
        //listOfReports = [Select Id From Report Where DeveloperName='Roster_File_Result']; 
        
      /*  List<Report> listOfReports                  =   new List<Report>();
        List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
        Map<String,Id>  reportNameAndIdMap          =   new Map<String,Id>();    
        listOfReports                               =   [Select Id From Report Where DeveloperName IN:reportNames];   
        System.debug('Coming insidemass close send email function'+planIdOfEmailRecipients);
        for( Report reportRec : [Select Id,DeveloperName From Report Where DeveloperName IN:reportNames] )
        {
            reportNameAndIdMap.put(reportRec.DeveloperName, reportRec.Id );
        } */
        
        /* for(String recruitmentFileId:setOfNetworkFileIds)
        {
            System.debug('Coming inside send email function');
            Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
            message1.toAddresses                    =   new List<String>();
            for( MCC_Report_Users__c mru : [SELECT Email__c from MCC_Report_Users__c WHERE Plan_Id__c=: planIdOfEmailRecipients] ) 
            {
                message1.toAddresses.add(mru.Email__c);
            }
            
            message1.settoAddresses( message1.toAddresses );
            System.debug('to'+message1.toAddresses);            
            message1.subject                        =   'Mass Case Creation: Success & Failure Report';
            
            if(!Test.isRunningTest())
            {
                message1.htmlBody                   =   'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                    +URL.getSalesforceBaseUrl().toExternalForm() + '/'+reportNameAndIdMap.get('Recruitment_File_Result')+'?pv0='+recruitmentFileId+'<br/><br/> Thanks<br/>Salesforce Support.';
            }
            else{
                message1.htmlBody                   =   'Test Email Body';
            }
            messages.add(message1);            
        } */
       
       /* for(String deathFileId:setOfDeathFileIds)
        {
            System.debug('Coming inside send email function');
            Messaging.SingleEmailMessage message    =   new Messaging.SingleEmailMessage();
            message.toAddresses                     =   new List<String>();
            for( MCC_Report_Users__c mru : [SELECT Email__c from MCC_Report_Users__c WHERE Plan_Id__c=: planIdOfEmailRecipients] ) 
            {
                message.toAddresses.add(mru.Email__c);
            }
            
            message.settoAddresses( message.toAddresses );
            message.subject = 'Mass Case Creation: Success & Failure Report';
            
            if(!Test.isRunningTest())
            {
                message.htmlBody = 'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                    +URL.getSalesforceBaseUrl().toExternalForm() + '/'+reportNameAndIdMap.get('Death_File_Result')+'?pv0='+deathFileId+'<br/><br/> Thanks<br/>Salesforce Support.';
            }
            else{
                message.htmlBody = 'Test Email Body';
            }
            messages.add(message);              
        }
               
        for(String rosterFileId:setOfRosterFileIds)
        {
            System.debug('Coming inside send email function');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<String> ();
            for( MCC_Report_Users__c mru : [SELECT Email__c from MCC_Report_Users__c WHERE Plan_Id__c=: planIdOfEmailRecipients] ) 
            {
                message.toAddresses.add(mru.Email__c);
            }
            message.settoAddresses( message.toAddresses );
            message.subject = 'Mass Case Creation: Success & Failure Report';
            if(!Test.isRunningTest()){
                system.debug('**** Inside HTML Email Body**');
                message.htmlBody = 'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                    +URL.getSalesforceBaseUrl().toExternalForm() + '/'+reportNameAndIdMap.get('Roster_File_Result')+'?pv0='+rosterFileId+'<br/><br/> Thanks<br/>Salesforce Support.';
            }
            else{
                message.htmlBody = 'Test Email Body';
            }
            messages.add(message);           
        }
        
        //PPN-25417 code changes
         for(String credFileId:fileIdWithPlanIdMap.keySet())
        {
            System.debug('Coming inside Credentialing send email function');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<String> ();
            for( MCC_Report_Users__c mru : [SELECT Email__c from MCC_Report_Users__c WHERE Plan_Id__c=: planIdOfEmailRecipients] ) 
            {
                message.toAddresses.add(mru.Email__c);
            }
            message.settoAddresses( message.toAddresses );
            message.subject = 'Credentialing Mass Case Update : Success & Failure Report';
            if(!Test.isRunningTest()){
                system.debug('**** Inside HTML Email Body**');
                message.htmlBody = 'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                    +URL.getSalesforceBaseUrl().toExternalForm() + '/'+reportNameAndIdMap.get('Credentialing_cases_mass_update_report')+'?pv0='+credFileId+'&pv1='+fileIdWithPlanIdMap.get(credFileId)+'<br/><br/> Thanks<br/>Salesforce Support.';
            }
            else{
                message.htmlBody = 'Test Email Body';
            }
            messages.add(message);           
        }        
        //PPN-22549
        
        system.debug('massclose --'+massCloseFieldIds);
        System.debug('fileIdWithPlanIdMapForADC===>>>'+fileIdWithPlanIdMapForADC);
        for(String masscloseFileId:fileIdWithPlanIdMapForADC.keySet())
        {
            System.debug('Coming insidemass close send email function'+planIdOfEmailRecipients);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<String> ();
            for( MCC_Report_Users__c mru : [SELECT Email__c from MCC_Report_Users__c WHERE Plan_Id__c=: planIdOfEmailRecipients] ) 
            {
                message.toAddresses.add(mru.Email__c);
            }
            message.settoAddresses( message.toAddresses );
            message.subject = 'Mass Case Closure : Success & Failure Report';
            if(!Test.isRunningTest()){
                system.debug('**** Inside HTML Email Body**');
                message.htmlBody = 'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                    +URL.getSalesforceBaseUrl().toExternalForm() + '/'+reportNameAndIdMap.get('Mass_Case_Closure_Report')+'?pv0='+masscloseFileId+'&pv1='+fileIdWithPlanIdMapForADC.get(masscloseFileId)+'<br/><br/> Thanks<br/>Salesforce Support.';
            }
            else{
                message.htmlBody = 'Test Email Body';
            }
            messages.add(message);           
        }
        
        System.debug('What is in messages '+messages);
System.debug('==='+Limits.getLimitEmailInvocations());
System.debug('==='+Limits.getEmailInvocations());        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
        System.debug('==='+Limits.getLimitEmailInvocations());
System.debug('==='+Limits.getEmailInvocations()); */
        /**PPN-17928, 17974 Code Ends**/       
    } 
}