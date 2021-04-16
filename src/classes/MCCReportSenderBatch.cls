/**************************************************************************************************
Apex Class Name  : MCCReportSenderBatch
Version          : 1.0  
Functionality    : This job will run for every one hour and pick all records not processed for reporting.
           Reporting will be processed for Network Recruitment, IL Roaster , Mass Cred Status update and
               Mass case closure
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru           10/10/2018           
   Ashok N                    11/27/2018           Please refer the TestDataFactoryclass for the test data 
*/
global class MCCReportSenderBatch implements Database.Batchable<sobject>,Database.Stateful,Schedulable
{
    
    Map<String,List<MCC_Data_Object__c>> fileIldWithNetworkMap        =  new Map<String,List<MCC_Data_Object__c>>();
    Map<String,List<MCC_Data_Object__c>> fileIdWithRosterMap        =  new Map<String,List<MCC_Data_Object__c>>();
    Map<String,List<MCC_Data_Object__c>> fileIdWithCredentialingMap      =  new Map<String,List<MCC_Data_Object__c>>();
    Map<String,List<MCC_Data_Object__c>> fileIdWithMassCloseCaseMap      =  new Map<String,List<MCC_Data_Object__c>>();
    Map<String,List<MCC_Data_Object__c>> fileIdWithMassCRMCloseCaseMap    =  new Map<String,List<MCC_Data_Object__c>>();
    Map<String,List<MCC_Data_Object__c>> fileIdWithMassNetworkLoad          =   new Map<String,List<MCC_Data_Object__c>>();
    // Map<String,Integer> fileIdwithMCCRecCount                =  new Map<String,Integer>();
    Set<String> mccfileNameSet                        =  new Set<String>();
    List<Report> listOfReports                                  =   new List<Report>();
    Map<String,Id>  reportNameAndIdMap                        =   new Map<String,Id>(); 
    Map<String,Set<String>>  fileIdWithPlanIdMap                =  new Map<String,Set<String>>();
    List<MCC_Data_Object__c> mccRecordsProcessedForreporting        =  new List<MCC_Data_Object__c>();
    Map<String,List<String>> reportingUsersByPlanId              =  new Map<String,List<String>>();
    
    String ADCMassReqquest                          =  'ADC Mass Status';
    String crmMassStatusType                        =   'CRM Mass Status';  //PPN-24701
    //String networkRequestType                                            =   'Network Recruitment';
    String networkRequestType                                            =   'Mass CRM Creation';
    
    
    String rosterFile                                                   =   'ILR'; 
    String onBoardingCredRequestType                                     =   'Onboarding Cred Mass Status Update'; //PPN-25417
    Set<String>  reportNames                                                =   new Set<String>{'Recruitment_File_Result','Death_File_Result','Roster_File_Result','Credentialing_cases_mass_update_reportV2', 'CRM_Mass_Case_Closure_Report','Mass_Case_Closure_Report','NetworkLoad_Mass_Status_Template'};
        
    ETLReportingNotification  ReportNotification = new ETLReportingNotification();
    Map<Decimal,String> Map_DestinationOrg= new Map<Decimal,String>();
    
   public MCCReportSenderBatch()
    {
        
     // Mass Reports Map
        listOfReports  =   [Select Id From Report Where DeveloperName IN:reportNames];   
        for( Report reportRec : [Select Id,DeveloperName From Report Where DeveloperName IN:reportNames] )
        {
            reportNameAndIdMap.put(reportRec.DeveloperName, reportRec.Id );
        }
        
        // Mass reporting users map from Custom settings
        for( MCC_Report_Users__c mccreportingUserRecord : MCC_Report_Users__c.getAll().Values() )
        {
            if( reportingUsersByPlanId.containsKey( mccreportingUserRecord.Plan_Id__c ) )
            {
               reportingUsersByPlanId.get( mccreportingUserRecord.Plan_Id__c ).add( mccreportingUserRecord.Email__c ); 
            }else{
              list<String> userEmailList  =   new List<String>();
              userEmailList.add( mccreportingUserRecord.Email__c );
              reportingUsersByPlanId.put( mccreportingUserRecord.Plan_Id__c , userEmailList ); 
            }
            Map_DestinationOrg.put(0,mccreportingUserRecord.Destination_Org__c);
        }
        
    }
    global Database.QueryLocator start( Database.BatchableContext BC ) 
    {
        return DataBase.getQueryLocator([ SELECT Id,Name,RecordType.Name,MCC_Load_Status__c,Processed_for_reporting__c,MCC_File_Type__c,MCC_Prov_ID__c,
                                         MCC_Case_Id__r.Plan_Id__c,MCC_Case_Id__c,MCC_Request_Type__c,MCC_File_Id__c,MCC_Plan_Id__c,mcc_case_status__c,
                                         File_Count__c FROM MCC_Data_Object__c where Processed_for_reporting__c=false] ); 
    }
    
     global void execute( Database.BatchableContext BC,List<MCC_Data_Object__c> mccList ) 
    {
        System.debug('mccList====>>>>'+mccList.size());
        List<Messaging.SingleEmailMessage> messages                 =   new List<Messaging.SingleEmailMessage>();
        Map<Id,MCC_Data_Object__c> Map_CredReportValues = new Map<Id,MCC_Data_Object__c>();
        if( !mccList.isEmpty() )
        {
            for( MCC_Data_Object__c mccRecord : mccList )
            {
                // Set with a file Id with plan ids
                if( fileIdWithPlanIdMap.containsKey( mccRecord.MCC_File_Id__c ) )
                {
                    if( !fileIdWithPlanIdMap.get(mccRecord.MCC_File_Id__c).Contains(mccRecord.MCC_File_Id__c ) )
                        fileIdWithPlanIdMap.get(mccRecord.MCC_File_Id__c).add(mccRecord.MCC_Plan_ID__c);
                }else{
                    Set<String> tempPlanIdSet = new Set<String>();
                    tempPlanIdSet.add(mccRecord.MCC_Plan_ID__c);
                    fileIdWithPlanIdMap.put(mccRecord.MCC_File_Id__c,tempPlanIdSet);
                }
                
                // logic to hold file list of records based on file type/request type
                //if( String.isEmpty( mccRecord.MCC_File_Type__c)  && mccRecord.MCC_Request_Type__c == networkRequestType )
                if(mccRecord.MCC_File_Type__c == 'Mass CRM Creation')
                {
                    if( fileIldWithNetworkMap.containsKey( mccRecord.MCC_File_Id__c ) )
                    {
                        fileIldWithNetworkMap.get(mccRecord.MCC_File_Id__c).add( mccRecord );
                    }else{
                        List<MCC_Data_Object__c> tempNtwrkList  =  new List<MCC_Data_Object__c>();
                        tempNtwrkList.add( mccRecord );
                        fileIldWithNetworkMap.put(mccRecord.MCC_File_Id__c , tempNtwrkList );
                    }  
                }else if( mccRecord.MCC_File_Type__c == rosterFile )
                {
                    if( fileIdWithRosterMap.containsKey( mccRecord.MCC_File_Id__c ) )
                    {
                        fileIdWithRosterMap.get(mccRecord.MCC_File_Id__c).add( mccRecord );
                    }else{
                        List<MCC_Data_Object__c> tempRosterList  =  new List<MCC_Data_Object__c>();
                        tempRosterList.add( mccRecord );
                        fileIdWithRosterMap.put(mccRecord.MCC_File_Id__c , tempRosterList );
                    }    
                }else if(!String.isEmpty( mccRecord.MCC_File_Type__c)  && mccRecord.MCC_File_Type__c == onBoardingCredRequestType )
                {
               
                    /*
                     * 
                     */
                    Map_CredReportValues.put(mccRecord.Id,mccRecord);
                    /*
                     *Commented : Ashok N we are passing the values to different function
                     */
                    /*system.debug('**** inside onBoardingCredRequestType ***');
                    if( fileIdWithCredentialingMap.containsKey( mccRecord.MCC_File_Id__c ) )
                    {
                        fileIdWithCredentialingMap.get(mccRecord.MCC_File_Id__c).add( mccRecord );
                    }else{
                        List<MCC_Data_Object__c> tempCredList  =  new List<MCC_Data_Object__c>();
                        tempCredList.add( mccRecord );
                        fileIdWithCredentialingMap.put(mccRecord.MCC_File_Id__c , tempCredList );
                    }  */                  
                }else if(!String.isEmpty(mccRecord.MCC_File_Type__c)  && mccRecord.MCC_File_Type__c ==  ADCMassReqquest )
                {
                    if( fileIdWithMassCloseCaseMap.containsKey( mccRecord.MCC_File_Id__c ) )
                    {
                        fileIdWithMassCloseCaseMap.get(mccRecord.MCC_File_Id__c).add( mccRecord );
                    }else{
                        List<MCC_Data_Object__c> tempMassCloseList  =  new List<MCC_Data_Object__c>();
                        tempMassCloseList.add( mccRecord );
                        fileIdWithMassCloseCaseMap.put(mccRecord.MCC_File_Id__c , tempMassCloseList );
                    } 
                }else if(!String.isEmpty(mccRecord.MCC_File_Type__c)  && mccRecord.MCC_File_Type__c ==  crmMassStatusType)
                {
                    if( fileIdWithMassCRMCloseCaseMap.containsKey( mccRecord.MCC_File_Id__c ) )
                    {
                        fileIdWithMassCRMCloseCaseMap.get(mccRecord.MCC_File_Id__c).add( mccRecord );
                    }else{
                        List<MCC_Data_Object__c> tempMassCRMCloseList  =  new List<MCC_Data_Object__c>();
                        tempMassCRMCloseList.add( mccRecord );
                        fileIdWithMassCRMCloseCaseMap.put(mccRecord.MCC_File_Id__c , tempMassCRMCloseList );
                    } 
                } 
                
                
                /* PPN-27739
* Author:Ashok N 
* Date : 11/12/2018
* Business Purpouse:Email Notification for the report
* 
*/
                if(mccRecord.MCC_File_Type__c ==  'Network Load Mass Status')
                {
                    system.debug('*** inside Network Load Status **');
                    if(mccRecord.MCC_File_Id__c!=null)
                    {
                        List<MCC_Data_Object__c> tempMassNetworkLoad    =   new List<MCC_Data_Object__c>();  
                        tempMassNetworkLoad.add(mccRecord);
                        fileIdWithMassNetworkLoad.put(mccRecord.MCC_File_Id__c , tempMassNetworkLoad );
                    }
                    
                }
                
            }
           
        }
        system.debug('CredentialingReport===>> '+Map_CredReportValues.size()+'====>> '+Map_CredReportValues);
        if(Map_CredReportValues.size()>0)
        {
            ReportNotification.CredentialingReport(Map_CredReportValues);
        }
        System.debug('fileIdWithPlanIdMap====>>>>'+fileIdWithPlanIdMap); 
        System.debug('fileIldWithNetworkMap====>>>>'+fileIldWithNetworkMap.size());    
        System.debug('End of Execute - fileIdWithCredentialingMap====>>>>'+fileIdWithCredentialingMap.values().size());        
    }
    
    global void finish( Database.BatchableContext BC )
    {
         // Preparing report for Network recruirmenr records 
        System.debug('Inside Finish Methods===>>>>'+fileIldWithNetworkMap.size());
        System.debug('fileIdWithMassCloseCaseMap====>>>>'+fileIdWithMassCloseCaseMap.size());
        System.debug('fileIdWithCredentialingMap====>>>>'+fileIdWithCredentialingMap.values().size());
        System.debug('fileIdWithRosterMap====>>>>'+fileIdWithRosterMap.size());
        
            
        List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
        if(!fileIldWithNetworkMap.isEmpty())
        {
            System.debug('fileIldWithNetworkMap===>>>'+fileIldWithNetworkMap.size());
            for( String fileIdString :  fileIldWithNetworkMap.keySet() )
            {
                 System.debug('Network fileIdString===>>>'+fileIdString);
                
                if( fileIdWithPlanIdMap.containsKey( fileIdString ) 
                   && !fileIdWithPlanIdMap.get( fileIdString ).isEmpty() ){
                      // emailmeasse to be prepare for each file id based on Plan Id
                      for( String planIdStr : fileIdWithPlanIdMap.get( fileIdString ) )
                      {
                              Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
                              message1.toAddresses                    =   new List<String>();
                           System.debug('<<<===planIdStr===>>>'+planIdStr);
                           //System.debug('<<<===reportingUsersByPlanId.get( planIdStr)===>>>'+reportingUsersByPlanId.get( planIdStr));
                           if(!String.isEmpty( planIdStr) && reportingUsersByPlanId.containsKey( planIdStr) && !reportingUsersByPlanId.get( planIdStr).isEmpty())
                           {
                               message1.toAddresses =  reportingUsersByPlanId.get( planIdStr);
                               message1.settoAddresses( message1.toAddresses );
                               System.debug('to In Network ====>>>>'+message1.toAddresses);            
                               message1.subject                          =   'Mass Case Creation: Success & Failure Report';
                               if(!Test.isRunningTest())
                                {
                                    message1.htmlBody                   =   'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                                        +Map_DestinationOrg.get(0) + '/'+reportNameAndIdMap.get('Recruitment_File_Result')+'/'+'view'+'?fv0='+fileIdString+'&fv1='+planIdStr+'<br/><br/> Thanks<br/>Salesforce Support.';
                                    // Map_DestinationOrg.get(0) + '/'+Map_ReportName.get('Credentialing_cases_mass_update_reportV2') +'/'+'view'+'?fv0='+CredStatusFileID+'<br/><br/> Thanks<br/>Salesforce Support.';
                               
                                }
                                else{
                                    message1.htmlBody                   =   'Test Email Body';
                                }
                              messages.add( message1 );
                           }
                      }
                      
                      // set flag to true for the record processed for reporting
                      for( MCC_Data_Object__c networkMCcRecord : fileIldWithNetworkMap.get( fileIdString ) )
                      {
                          MCC_Data_Object__c tempMCCNetworkRec       =  new MCC_Data_Object__c( Id = networkMCcRecord.Id );
                          tempMCCNetworkRec.Processed_for_reporting__c  =  true;
                          mccRecordsProcessedForreporting.add( tempMCCNetworkRec );
                          mccfileNameSet.add( networkMCcRecord.Name );
                      }
                  }
            }
            
        }
        
           // Preparing report for IL Roster records
    if(!fileIdWithRosterMap.isEmpty())
        {
            
            for( String fileIdString :  fileIdWithRosterMap.keySet() )
            {
                if( fileIdWithPlanIdMap.containsKey( fileIdString ) 
                   && !fileIdWithPlanIdMap.get( fileIdString ).isEmpty() 
                  ){
                      // emailmeasse to be prepare for each file id based on Plan Id
                      for( String planIdStr : fileIdWithPlanIdMap.get( fileIdString ) )
                      {
                            Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
                    message1.toAddresses                    =   new List<String>();
                           System.debug('<<<===Inside IL roster planIdStr===>>>'+planIdStr);
                           //System.debug('<<<=== Inside IL roaster reportingUsersByPlanId.get( planIdStr)===>>>'+reportingUsersByPlanId.get( planIdStr));
                           if(!String.isEmpty( planIdStr) && !reportingUsersByPlanId.get( planIdStr).isEmpty())
                           {
                               message1.toAddresses =  reportingUsersByPlanId.get( planIdStr);
                               message1.settoAddresses( message1.toAddresses );
                               System.debug('to'+message1.toAddresses);            
                               message1.subject                          =   'Mass Case Creation: Success & Failure Report';
                               if(!Test.isRunningTest())
                                {
                                    system.debug('**** Inside HTML Email Body**');
                                    message1.htmlBody = 'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                                        +Map_DestinationOrg.get(0) + '/'+reportNameAndIdMap.get('Recruitment_File_Result')+'/'+'view'+'?fv0='+fileIdString+'&fv1='+planIdStr+'<br/><br/> Thanks<br/>Salesforce Support.';
                                      // Map_DestinationOrg.get(0) + '/'+Map_ReportName.get('Credentialing_cases_mass_update_reportV2') +'/'+'view'+'?fv0='+CredStatusFileID+'<br/><br/> Thanks<br/>Salesforce Support.';
                                }
                                else{
                                    message1.htmlBody                   =   'Test Email Body';
                                }
                              messages.add( message1 );
                           }
                      }
                      
                      // set flag to true for the record processed for reporting
                      for( MCC_Data_Object__c roasterkMCcRecord : fileIdWithRosterMap.get( fileIdString ) )
                      {
                          MCC_Data_Object__c tempMCCNetworkRec       =  new MCC_Data_Object__c( Id = roasterkMCcRecord.Id );
                          tempMCCNetworkRec.Processed_for_reporting__c  =  true;
                          mccRecordsProcessedForreporting.add( tempMCCNetworkRec );
                          mccfileNameSet.add( roasterkMCcRecord.Name );
                      }
                      
                  }
            }    
        }
        
       // Preparing report for Credentialing status records
       /* if(!fileIdWithCredentialingMap.isEmpty())
        {
            for( String fileIdString :  fileIdWithCredentialingMap.keySet() )
            {
                if( fileIdWithPlanIdMap.containsKey( fileIdString ) 
                   && !fileIdWithPlanIdMap.get( fileIdString ).isEmpty() ){
                  
                      // emailmeasse to be prepare for each file id based on Plan Id
                      for( String planIdStr : fileIdWithPlanIdMap.get( fileIdString ) )
                      {
                            system.debug('*** inside nested for loop **' + planIdStr);
                            Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
                     message1.toAddresses                    =   new List<String>();
                          if(!String.isEmpty( planIdStr) && !reportingUsersByPlanId.get( planIdStr).IsEmpty())
                          {
                               message1.toAddresses =  reportingUsersByPlanId.get( planIdStr);
                               message1.settoAddresses( message1.toAddresses );
                               System.debug('to'+message1.toAddresses);            
                               message1.subject                          =   'Credentialing Mass Case Update : Success & Failure Report';
                               if(!Test.isRunningTest())
                                {
                                    message1.htmlBody                   =   'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                                        +URL.getSalesforceBaseUrl().toExternalForm() + '/'+reportNameAndIdMap.get('Credentialing_cases_mass_update_reportV2')+'?pv0='+fileIdString+'&pv1='+planIdStr+'<br/><br/> Thanks<br/>Salesforce Support.';
                                }
                                else{
                                    message1.htmlBody                   =   'Test Email Body';
                                }
                              messages.add( message1 );
                          }
                      }
                      
                      // set flag to true for the record processed for reporting
                      for( MCC_Data_Object__c credkMCcRecord : fileIdWithCredentialingMap.get( fileIdString ) )
                      {
                          system.debug('*** inside enabling reporting flag ***');
                          MCC_Data_Object__c tempMCCNetworkRec       =  new MCC_Data_Object__c( Id = credkMCcRecord.Id );
                          tempMCCNetworkRec.Processed_for_reporting__c  =  true;
                          mccRecordsProcessedForreporting.add( tempMCCNetworkRec );
                          mccfileNameSet.add( credkMCcRecord.Name );
                      }
                  }
            }    
        }
*/
      
       // Preparing report for Mass case close status records
        if(!fileIdWithMassCloseCaseMap.isEmpty())
        {
                        
            for( String fileIdString :  fileIdWithMassCloseCaseMap.keySet() )
            {
                System.debug('fileIdWithPlanIdMap.get( fileIdString )===>>>'+fileIdWithPlanIdMap.get( fileIdString ));
                   if( fileIdWithPlanIdMap.containsKey( fileIdString ) 
                      && !fileIdWithPlanIdMap.get( fileIdString ).isEmpty()
                     ){
                      // emailmeasse to be prepare for each file id based on Plan Id
                      for( String planIdStr : fileIdWithPlanIdMap.get( fileIdString ) )
                      {
                            Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
                      message1.toAddresses                    =   new List<String>();
                         
                           if( !String.isEmpty( planIdStr) && !reportingUsersByPlanId.get( planIdStr).isEmpty())
                           {
                               message1.toAddresses =  reportingUsersByPlanId.get( planIdStr);
                               message1.settoAddresses( message1.toAddresses );
                               System.debug('to'+message1.toAddresses);            
                               message1.subject                          =   'Mass Case Closure : Success & Failure Report';
                               if(!Test.isRunningTest())
                                {
                                    message1.htmlBody                   =   'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                                        +Map_DestinationOrg.get(0) + '/'+reportNameAndIdMap.get('Mass_Case_Closure_Report')+'/'+'view'+'?fv0='+fileIdString+'&fv1='+planIdStr+'<br/><br/> Thanks<br/>Salesforce Support.';
                                      // Map_DestinationOrg.get(0) + '/'+Map_ReportName.get('Credentialing_cases_mass_update_reportV2') +'/'+'view'+'?fv0='+CredStatusFileID+'<br/><br/> Thanks<br/>Salesforce Support.';
                                    }
                                else{
                                    message1.htmlBody                   =   'Test Email Body';
                                }
                              messages.add( message1 );  
                           }   
                      }
                      
                      // set flag to true for the record processed for reporting
                      for( MCC_Data_Object__c massCloseMCcRecord : fileIdWithMassCloseCaseMap.get( fileIdString ) )
                      {
                          MCC_Data_Object__c tempMCCNetworkRec       =  new MCC_Data_Object__c( Id = massCloseMCcRecord.Id );
                          tempMCCNetworkRec.Processed_for_reporting__c  =  true;
                          mccRecordsProcessedForreporting.add( tempMCCNetworkRec );
                          mccfileNameSet.add( massCloseMCcRecord.Name );
                      }
                  }
            }    
        }
        
         // Preparing report for CRM Mass case close status records
         // 
         /*
        if(!fileIdWithMassCRMCloseCaseMap.isEmpty())
        {
                        
            for( String fileIdString :  fileIdWithMassCRMCloseCaseMap.keySet() )
            {
                   if( fileIdWithPlanIdMap.containsKey( fileIdString )
                      && !fileIdWithPlanIdMap.get( fileIdString ).isEmpty()
                     ){
                      // emailmeasse to be prepare for each file id based on Plan Id
                      for( String planIdStr : fileIdWithPlanIdMap.get( fileIdString ) )
                      {
                          Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
                          message1.toAddresses                    =   new List<String>();

                           if( !String.isEmpty( planIdStr) && !reportingUsersByPlanId.get( planIdStr).isEmpty())
                           {
                               System.debug('<<<===planIdStr===>>>'+planIdStr);
                               System.debug('<<<===reportingUsersByPlanId.get( planIdStr)===>>>'+reportingUsersByPlanId.get( planIdStr));
                               message1.toAddresses =  reportingUsersByPlanId.get( planIdStr);
                               message1.settoAddresses( reportingUsersByPlanId.get( planIdStr) );
                               System.debug('to'+message1.toAddresses);            
                               message1.subject                          =   'CRM Mass Case Closure : Success & Failure Report';
                               if(!Test.isRunningTest())
                                {
                                    message1.htmlBody                   =   'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                                        + Map_DestinationOrg.get(0) + '/'+reportNameAndIdMap.get('CRM_Mass_Case_Closure_Report')+'?fv0='+fileIdString+'&fv1='+planIdStr+'<br/><br/> Thanks<br/>Salesforce Support.';
                                    //// Map_DestinationOrg.get(0) + '/'+Map_ReportName.get('Credentialing_cases_mass_update_reportV2') +'/'+'view'+'?fv0='+CredStatusFileID+'<br/><br/> Thanks<br/>Salesforce Support.';
                                }
                                else{
                                    message1.htmlBody                   =   'Test Email Body';
                                }
                                messages.add( message1 );
                           }
                      }
                      
                      // set flag to true for the record processed for reporting
                      for( MCC_Data_Object__c massCloseMCcRecord : fileIdWithMassCRMCloseCaseMap.get( fileIdString ) )
                      {
                          MCC_Data_Object__c tempMCCNetworkRec       =  new MCC_Data_Object__c( Id = massCloseMCcRecord.Id );
                          tempMCCNetworkRec.Processed_for_reporting__c  =  true;
                          mccRecordsProcessedForreporting.add( tempMCCNetworkRec );
                          mccfileNameSet.add( massCloseMCcRecord.Name );
                      }
                  }
            }    
        }
*/
        
        /*
* Author : Ashok N
* StoryBoard: PPN-27739
* Date : 11/12/2018
* 
*/
        
        if(!fileIdWithMassNetworkLoad.isEmpty())
        {       
            for( String fileIdString :  fileIdWithMassNetworkLoad.keySet() )
            {
                System.debug('NetworkLoad Status'+fileIdWithPlanIdMap.get( fileIdString ));
                if( fileIdWithPlanIdMap.containsKey( fileIdString ) 
                   && !fileIdWithPlanIdMap.get( fileIdString ).isEmpty()){
                       // emailmeasse to be prepare for each file id based on Plan Id
                       for( String planIdStr : fileIdWithPlanIdMap.get( fileIdString ) )
                       {
                           Messaging.SingleEmailMessage message1   =   new Messaging.SingleEmailMessage();
                           message1.toAddresses                    =   new List<String>();
                           if( !String.isEmpty( planIdStr) && !reportingUsersByPlanId.get( planIdStr).isEmpty())
                           {
                               message1.toAddresses =   reportingUsersByPlanId.get( planIdStr);
                               message1.settoAddresses( message1.toAddresses );
                               System.debug('to'+message1.toAddresses);            
                               message1.subject                         =   'NetworkLoad Mass Status: Success & Failure Report';
                               if(!Test.isRunningTest())
                               {
                                   system.debug('NetworkLoad_Mass_Status_Template===='+fileIdString+' ==='+planIdStr);
                                   message1.htmlBody                   =   'Hello All <br/><br/>Please find the Success & Failure report in the below link. <br/><br/> '
                                       +Map_DestinationOrg.get(0) + '/'+reportNameAndIdMap.get('NetworkLoad_Mass_Status_Template')+'/'+'view'+'?fv0='+fileIdString+'&fv1='+planIdStr+'<br/><br/> Thanks<br/>Salesforce Support.';
                                   // Map_DestinationOrg.get(0) + '/'+Map_ReportName.get('Credentialing_cases_mass_update_reportV2') +'/'+'view'+'?fv0='+CredStatusFileID+'<br/><br/> Thanks<br/>Salesforce Support.';
                               }
                               else
                               {
                                   message1.htmlBody                   =   'Test Email Body';
                               }
                               messages.add( message1 );  
                           }   
                           
                       }
                       //set flag to true for the record processed for reporting by refering to the fileIdString parameters
                       set<String> MCCIDS_fileIdString= new Set<String>();
                       for( MCC_Data_Object__c massCloseMCcRecord : fileIdWithMassNetworkLoad.get( fileIdString ) )
                       {
                           MCCIDS_fileIdString.add(massCloseMCcRecord.MCC_File_Id__c);
                       }
                       //Used to Update the value Processed_for_reporting__c to true once the email is sent based on the fileIdString
                       List<MCC_Data_Object__c> ListQuery_MCC_Data_Object= new List<MCC_Data_Object__c>();
                       Map<Id,MCC_Data_Object__c> UpdateEmailSent_MCC_Data_Object= new Map<Id,MCC_Data_Object__c>();
                       ListQuery_MCC_Data_Object=[select Id,Processed_for_reporting__c from MCC_Data_Object__c where MCC_File_Id__c IN :MCCIDS_fileIdString];
                       for(MCC_Data_Object__c MCC_Data_ObjectUpdate : ListQuery_MCC_Data_Object)
                       {
                           MCC_Data_Object__c tempMCCNetworkRec = new MCC_Data_Object__c();
                           tempMCCNetworkRec.id=MCC_Data_ObjectUpdate.Id;
                           tempMCCNetworkRec.Processed_for_reporting__c=true;
                           mccRecordsProcessedForreporting.add(tempMCCNetworkRec);
                       }
                   }
            }    
        } 
        
        
        
    if(!mccRecordsProcessedForreporting.isEmpty() && mccRecordsProcessedForreporting.size()<= 9500){
            update mccRecordsProcessedForreporting;
        }else {
            if( !mccfileNameSet.isEmpty() )
             Database.executeBatch( new MCCProcessFlagUpdateBatch( mccfileNameSet )); 
        }
        System.debug('What is in messages====>>>>'+messages.size());
       System.debug('What is in messages====>>>>'+messages);
        for(Messaging.SingleEmailMessage msg : messages )
        {
            System.debug('msg===>>>>'+msg);
        }
        if(!messages.isEmpty())
        {
           Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        } 
    }
    
    global void execute(SchedulableContext ctx)
    {
        MCCReportSenderBatch mccRSB = new MCCReportSenderBatch();
        ID batchprocessid = Database.executeBatch( mccRSB , 2000);
   }   
}