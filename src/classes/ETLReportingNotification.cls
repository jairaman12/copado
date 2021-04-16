/**************************************************************************************************
Apex Class Name  : ETLReportingNotification
Version          : 1.0  
Functionality    : To send the report "  Inbound Cred Response "
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*Ashok N           03/27/2019                          PPN-30878

***************************************************************************************************/

public class ETLReportingNotification 
{

    MassCreationDataObjectQuery MassDataQueryObject = new MassCreationDataObjectQuery();
      /*
* Author :Ashok 
* Business Purpose: To send the Cred report to the user who are listed in custom setting
* Date : 03/27/2019
* ver :1.0
* StoryBoardNumber :PPN-30878 
@param  : Dependences class   "MCCReportSenderBatch" and the method is CredentialingReport(Map<Id,MCC_Data_Object__c)
 
*/ 
    
    public void CredentialingReport(Map<Id,MCC_Data_Object__c> MapInputMCCDataObject)
    {
        set<Id> SetMCCDataObjectId= new Set<Id>();
        List<AggregateResult> List_UniqueProviderId= new List<AggregateResult>();
        List_UniqueProviderId=[SELECT COUNT_DISTINCT(Prov_ID__c) FROM Account where Cred_Status__c!=null and Prov_ID__c!=null 
                               and  createddate=this_year ];
        set<String> SetMCC_File_Id = new set<String>();
        set<String> SetMCC_File_Type = new Set<String>();
        SetMCCDataObjectId=MapInputMCCDataObject.keyset();
        List<Decimal> ListSortedFileCount= new List<Decimal>();
        Map<String,List<String>> TotalRecordLoaded_ETL =new Map<String,List<String>>();
        Map<String,List<String>> MapListSuccessMCC_ProvID= new Map<String,List<String>>();
        Map<String,List<String>> MapListFaliure_ProvID= new Map<String,List<String>>();
        Map<String,List<String>> MapTotalRecordsLoaded_ETL= new Map<String,List<String>>();
        Map<String,List<Decimal>> MapFile_Count = new Map<String,List<Decimal>>();
        List<String> List_EmailAddress = new List<String>();
        List<Database.SaveResult> ListDataBaseResult= new List<Database.SaveResult>();
        map<Id,MCC_Data_Object__c> MapProcessedFlagToTrue= new Map<Id,MCC_Data_Object__c>();
        List<Error_Message__c> ListErrorMessage= new List<Error_Message__c>();
       // Map<String,List<String> 
        system.debug('SetMCCDataObjectId=== >>> '+SetMCCDataObjectId);
        
        Map<Id,MCC_Data_Object__c> MapMCCDataObject = new Map<Id,MCC_Data_Object__c>(
           [SELECT Id,Name,RecordType.Name,MCC_Load_Status__c,Processed_for_reporting__c,MCC_File_Type__c,MCC_Prov_ID__c,
            MCC_Case_Id__r.Plan_Id__c,MCC_Case_Id__c,MCC_Request_Type__c,MCC_File_Id__c,MCC_Plan_Id__c,
            mcc_case_status__c,File_Count__c FROM MCC_Data_Object__c where Id IN :SetMCCDataObjectId ORDER BY  File_Count__c DESC]);
     
        for(MCC_Data_Object__c MCCDataObjectValues :MapMCCDataObject.values())  
        {
            if(MCCDataObjectValues.MCC_File_Type__c=='Onboarding Cred Mass Status Update'){
                SetMCC_File_Id.add(MCCDataObjectValues.MCC_File_Id__c);
                SetMCC_File_Type.add(MCCDataObjectValues.MCC_File_Type__c);
                ListSortedFileCount.add(MCCDataObjectValues.File_Count__c);
                if(!MapFile_Count.containsKey(MCCDataObjectValues.MCC_File_Id__c)){
                    MapFile_Count.put(MCCDataObjectValues.MCC_File_Id__c,new List<Double>{MCCDataObjectValues.File_Count__c});
                    MapTotalRecordsLoaded_ETL.put(MCCDataObjectValues.MCC_File_Id__c, new List<String>{MCCDataObjectValues.MCC_Prov_ID__c});
                }
                else{
                    MapFile_Count.get(MCCDataObjectValues.MCC_File_Id__c).add(MCCDataObjectValues.File_Count__c);
                    MapTotalRecordsLoaded_ETL.get(MCCDataObjectValues.MCC_File_Id__c).add(MCCDataObjectValues.MCC_Prov_ID__c);
                }
                //To count get the records where MCC_Load_Status__c=true
                if(MCCDataObjectValues.MCC_Load_Status__c==true)
                {
                   if(!MapListSuccessMCC_ProvID.containskey(MCCDataObjectValues.MCC_File_Id__c)){
                       MapListSuccessMCC_ProvID.put(MCCDataObjectValues.MCC_File_Id__c,
                                                    new List<String>{MCCDataObjectValues.MCC_Prov_ID__c});
                   }
                   else{
                       MapListSuccessMCC_ProvID.get(MCCDataObjectValues.MCC_File_Id__c).add(MCCDataObjectValues.MCC_Prov_ID__c);
                   }
                }
                //To count get the records where MCC_Load_Status__c=false
                else{
                   if(!MapListFaliure_ProvID.containsKey(MCCDataObjectValues.MCC_File_Id__c)){
                       MapListFaliure_ProvID.put(MCCDataObjectValues.MCC_File_Id__c,
                                                 new List<String>{MCCDataObjectValues.MCC_Prov_ID__c});
                   }
                    else{
                      MapListFaliure_ProvID .get(MCCDataObjectValues.MCC_File_Id__c).add(MCCDataObjectValues.MCC_Prov_ID__c);
                   }
                }
                
                
            }
        }
        system.debug('MapFile_Count==== >>> '+MapFile_Count);
        Map<String,List<String>> Final_Map_OfValues = new Map<String,List<String>>();
        Map<Id,Report> getReportValues= MassDataQueryObject.getReportName();
        Map<Integer,Id> Map_Credentialing_cases_Report= new Map<Integer,Id>();
        Map<Integer,Id> Map_NetworkLoadMassStatus_Report= new Map<Integer,Id>();
        Map<String,Id> Map_ReportName= new Map<String,Id>();
        for(Report ReportValues :getReportValues.values())
        {
            Map_ReportName.put(ReportValues.DeveloperName,ReportValues.Id);
        }
        Map<Id,ETL_Report_Config_Data__mdt>  Map_ReportConfigData=  MassDataQueryObject.getETLReprotConfigData(SetMCC_File_Type);
        Map<Decimal,String> Map_DestinationOrg=  new Map<Decimal,String>();
        List<String> List_MCC_PlanId= new List<String>();
        Map<Decimal,Decimal> MapTotalcount_Year= new Map<Decimal,Decimal>();
        for(ETL_Report_Config_Data__mdt ETL_Report_Config_Data :Map_ReportConfigData.values())
        {
            if(ETL_Report_Config_Data.Active_Email__c==true)
            {
                if(ETL_Report_Config_Data.Email_Address__c!=null && ETL_Report_Config_Data.Email_Address__c!='' )
                {
                    List_EmailAddress.add(ETL_Report_Config_Data.Email_Address__c);
                    Map_DestinationOrg.put(0,ETL_Report_Config_Data.Destination_Org__c);
                    List_MCC_PlanId.add(ETL_Report_Config_Data.Plan_Id__c);
                    if(ETL_Report_Config_Data.Total_Accounts__c!=null)
                     MapTotalcount_Year.put(0,ETL_Report_Config_Data.Total_Accounts__c);
                }
                
            }
        }
        List<Messaging.SingleEmailMessage> List_Message_Variable= new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage Message_Variable    =   new Messaging.SingleEmailMessage();
        String htmlEmailBody = '';
        String Report_Link='';
        String Report_Text='';
        Decimal Success_Records= 0;
        Decimal Faliure_Records= 0;
        Decimal Total_Count_Batch=0;
        decimal Difference_count=0;
        Decimal Cred_Account1=0;
        Decimal Cred_Account=0;
        Decimal Final_Cred_Account=0;
        htmlEmailBody = '<html><body>';
        for(String CredStatusFileID : SetMCC_File_Id)
         {
             Cred_Account=(Decimal)List_UniqueProviderId[0].get('expr0');
             Final_Cred_Account=MapTotalcount_Year.get(0)+Cred_Account;
             system.debug('MapFile_Count=== >> '+MapFile_Count.get(CredStatusFileID).get(0));
             system.debug('MapTotalRecordsLoaded_ETL==='+MapTotalRecordsLoaded_ETL.get(CredStatusFileID).size());
             Difference_count=MapFile_Count.get(CredStatusFileID).get(0)-MapTotalRecordsLoaded_ETL.get(CredStatusFileID).size();
             Decimal Integer1=MapTotalRecordsLoaded_ETL.get(CredStatusFileID).size();
             system.debug('Integer1==== >> '+Integer1);
             htmlEmailBody += '<b>Current Batch TimeStamp:    </b>' + system.now() + '<br/>';
             htmlEmailBody += '<b>Total number of providers with credentialing status in Salesforce as of today </b>' 
                 				+Final_Cred_Account+ '<br/>';
             htmlEmailBody += '<table class="tabelle separate" border="1"><tr><th>Description</th><th>Count</th></tr>';
             //htmlEmailBody += '</tr><td class="zelle">' + 'Current Batch TimeStamp' + '</td><td class="zelle">' + system.now() + '</td></tr>'; 
             htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records submitted by ETL/Batch ' + 
                 				'</td><td class="zelle">' +MapFile_Count.get(CredStatusFileID).get(0)+ '</td></tr>';
             htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records loaded successfully by ETL/Batch ' 
                              + '</td><td class="zelle">' + MapTotalRecordsLoaded_ETL.get(CredStatusFileID).size()  + '</td></tr>';
             if(MapListSuccessMCC_ProvID.size()>0){
                 htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records updated successfully in  Salesforce ETL/Batch' 
                     + '</td><td class="zelle">' +MapListSuccessMCC_ProvID.get(CredStatusFileID).size()+ '</td></tr>';
              }
             else{
                 htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records updated successfully in  Salesforce ETL/Batch' 
                     + '</td><td class="zelle">' +0+ '</td></tr>';
             }
             if(MapListFaliure_ProvID.size()>0)
             {
                 htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records not updated in Salesforce ETL/Batch ' 
                     + '</td><td class="zelle">' + MapListFaliure_ProvID.get(CredStatusFileID).size() + '</td></tr>';
             }else{
                 htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records not updated in Salesforce ETL/Batch ' 
                     + '</td><td class="zelle">' + 0 + '</td></tr>';
             }
             htmlEmailBody += '</tr><td class="zelle">' + 'Total number of records not loaded by ETL/Batch ' 
                 				+ '</td><td class="zelle">' +Difference_count+ '</td></tr>';
             htmlEmailBody += '</table>';
             Report_Text='Please find the Success & Failure report in the below link<br><br>';           
             Report_Link = Map_DestinationOrg.get(0) + '/'+Map_ReportName.get('Credentialing_cases_mass_update_reportV2') +
                 				'/'+'view'+'?fv0='+CredStatusFileID+'<br/><br/> Thanks<br/>Salesforce Support.';
             htmlEmailBody+=Report_Text;
             htmlEmailBody+=Report_Link;
         }
       
        htmlEmailBody += '</body></html>';
        Message_Variable.setsubject('Credentialing Mass Case Update : Success & Failure Report');
        Message_Variable.setHTMLBody(htmlEmailBody);
        Message_Variable.setSaveAsActivity(false);
        Message_Variable.toaddresses =List_EmailAddress;
        List_Message_Variable.add(Message_Variable);
        system.debug('List_Message_Variable===>> '+List_Message_Variable);
        
        if(List_Message_Variable.size()>0)
        {
            try
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(List_Message_Variable);
                if (results[0].success) 
                {
                    MCC_Data_Object__c MCC_Data_ObjectUpdate= new MCC_Data_Object__c();
                    for(Id MCC_Records_ID :SetMCCDataObjectId)
                    {
                        MCC_Data_Object__c MCC_Data_Object_Update_ProcessedFlag= new MCC_Data_Object__c();
                        MCC_Data_Object_Update_ProcessedFlag.Id=MCC_Records_ID;
                        MCC_Data_Object_Update_ProcessedFlag.Processed_for_reporting__c=true;
                        MapProcessedFlagToTrue.put(MCC_Records_ID,MCC_Data_Object_Update_ProcessedFlag);
                    }
                }
                else
                {
                    System.debug('The email failed to send: '+ results[0].errors[0].message);
                }
            }
            catch(EmailException e)
            {
                Error_Message__c Insert_Error_Message = new Error_Message__c();
                Insert_Error_Message.Class_Name__c='LogETLReporting';
                Insert_Error_Message.Method_Name__c='sendEmail';
                //Insert_Error_Message.Line_Number__c=e.getLineNumber();
                Insert_Error_Message.Exception_Message__c=e.getMessage();
                Insert_Error_Message.Error_Cause__c=e.getTypeName();
                ListErrorMessage.add(Insert_Error_Message);
            }
            
        } 

        
        if(MapProcessedFlagToTrue.size()>0)
        {
            try{
                ListDataBaseResult= database.update(MapProcessedFlagToTrue.values(), false);  
            }catch(DmlException e)
            {
                
            }
        }
        
        if(ListErrorMessage.size()>0)
        {
            try{
                insert ListErrorMessage;
            }catch(DMLException e)
            {
                system.debug('DMLException=='+e.getMessage()); 
            }
        }
        
    }
    
}