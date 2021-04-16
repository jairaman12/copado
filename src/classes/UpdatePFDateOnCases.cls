/**************************************************************************************************
Apex Class Name  : UpdatePFDateOnCases
Version          : 1.0  
Functionality    : Accepts csv file from Provider Finder Team and Updates Provider Finder Close Date 
on Cases by matching on NPI
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              July 12, 2017       Code Logic For PPN-3460
***************************************************************************************************/
Global class UpdatePFDateOnCases implements Messaging.InboundEmailHandler
{
    Boolean processSheet = True;
    string csvbody = ''; 
    string reason = '';
    string allbadrows = '';
    string allnotfoundrows = '';
    string[] splitvalue;
    string[] lineByCsvBody = new String[]{};
        Integer countOfSuccess = 0;
    map<string, string> foundkeys = new map<string, string>();
    list<string> nf = new list<string>();    
    list<String> badrows = new list<String>();
    list<String> notFoundRows = new list<String>();
    list<String> linebycsvdata = new list<String>();
    list <Messaging.SingleEmailMessage> Mail = new list <Messaging.SingleEmailMessage>();
    list <Messaging.SingleEmailMessage> Mails = new list <Messaging.SingleEmailMessage>();
    List <String> sendTo = new List <String>();           
    String body1;
    
    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope)
    {     
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();                     
        Messaging.InboundEmail.textAttachment[] tAttachments = email.TextAttachments;
        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments;
        System.debug(' Binary Attachement from the email. ' + bAttachments);
        
        Messaging.SingleEmailMessage emailNotice = new Messaging.SingleEmailMessage(); 
        sendTo.add(Label.PFEmailNotification);
        emailNotice.setToAddresses(sendTo);
        emailNotice.setReplyTo(Label.PFEmailNotification);
        emailNotice.setSenderDisplayName('Salesforce Admin');
        
        if(tAttachments == null && bAttachments == null){
            result.success = false;
            System.debug('Lax Result '  + result.success);
            emailNotice.setSubject('UAT : Salesforce Case Update based on Provider Finder Info');
            body1 = '<html><body>Hello All,' + '<br>' + '<br>' + 'Attachment is missing with the email. Provider Finder Team needs to resend the email with attachment.' +  '<br>' + '<br>' + '- Salesforce Team.</body></html>';    
            emailNotice.setHtmlBody(body1);
            Mails.add(emailNotice);
            Messaging.sendEmail(Mails);
            return result;            
        }
        
        for(Messaging.InboundEmail.BinaryAttachment ba :bAttachments)
        { 
            if(!(ba.filename.endsWith('.csv')))
            { 
                processSheet = False;
                result.success = false;
                reason = 'badfileformat';
            }
        }
        
        If(bAttachments != Null && bAttachments.size() > 0 && processSheet)
        {
            For(Messaging.InboundEmail.BinaryAttachment ba :bAttachments)
            {
                // As we recieved binary data file, we are converting to String format
                csvBody = ba.body.toString();
                lineByCsvBody = csvBody.split('\n');
                System.debug('CSV BODY'+ csvBody + 'lines' +lineByCsvBody +' size of lineByCsvBody ' + lineByCsvBody.size() + ' This is a Text Attachment from the email parsed. ');
                
                For(Integer j = 0; j < lineByCsvBody.size(); j++)
                {
                    System.debug(' lineByCsvBody data...... ' + lineByCsvBody[j]);
                    If(j==0)
                    { 
                        /*Here I'm splitting and checking the header values*/                                            
                        String[] headervalue = lineByCsvBody[j].split(',');
                        System.debug(' headervalue1 '+ headervalue[0] + ' headervalue2 ' + headervalue[1]);
                        if(!headervalue[0].contains('NPI') || !headervalue[1].contains('Date Available')  || headervalue[0] == null || headervalue[1] == null){
                            system.debug('Issue with headers');
                            processSheet = false;
                            result.success = false;
                            reason = 'badheaders';
                        }
                    }
                    if(j>0)
                    {
                        // Taking csv file rows and adding it to list
                        linebycsvdata.add(lineByCsvBody[j]);                        
                    }
                }
            }
        }        
                
        if( processSheet && linebycsvdata.size() > 0 ) 
        {            
            Try
            {
                
                integer rowCount=0;
                
                Map<String, Date> dateMap = new Map<String, Date>();
                
                
                for(String svalue:linebycsvdata)
                {
                    // Here I'm checking and splitting the values / data contained in the .csv file and verifying the data
                    rowCount++;      
                    if(svalue == null || svalue == ',' || svalue.trim() == '' || svalue.trim().startswith(' ')){
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+' Blank Record');
                        continue;
                    }
                    splitvalue = svalue.split(','); 
                    Case customobject = new Case();
                    if(splitvalue.size() == 0){
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  NPI field value is missing');
                        continue;                                             
                    }
                    if(splitvalue[0] == '' || splitvalue[0].trim().length() < 1 || splitvalue[0] == Null)
                    {
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  NPI field value is missing');
                        continue;
                    }else if(splitvalue[0].length() != 10 || !splitvalue[0].isNumeric()){
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  NPI field value is bad:' + splitvalue[0]);
                        continue;
                    }
                    if(splitvalue.size() == 1){
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  Provider Finder Date value is missing');
                        continue;                                             
                    }
                    if(splitvalue[1] == '' || splitvalue[1].trim().length() < 1 || splitvalue[1] == Null || splitvalue[1].startswith(' '))
                    {
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  Provider Finder Date value is missing');
                        continue;
                    }else if(splitvalue[1].trim().length() != 10){ 
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  Provider Finder Date value is bad:' + splitvalue[1]);
                        continue;
                    }else if(splitvalue[1].trim().substringBefore('-').length() != 4 || splitvalue[1].trim().substringBetween('-').length() != 2 || splitvalue[1].trim().substringAfterLast('-').length() != 2){
                        system.debug('Problem is with Length');
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  Provider Finder Date value is bad:' + splitvalue[1]);
                        continue;
                    }else if(!(splitvalue[1].trim().substringBefore('-').isNumeric()) || !(splitvalue[1].trim().substringBetween('-').isNumeric()) || !(splitvalue[1].trim().substringAfterLast('-').isNumeric())){
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  Provider Finder Date value is bad:' + splitvalue[1]);
                        continue;
                    }else if(!(Integer.valueof(splitvalue[1].trim().substringBefore('-')) > 2016) || !(Integer.valueof(splitvalue[1].trim().substringBetween('-')) <= 12) || !(Integer.valueof(splitvalue[1].trim().substringAfterLast('-')) <= 31)) {
                        badrows.add('Issue with Provider Finder File: row number: '+rowCount+'  Provider Finder Date value is bad:' + splitvalue[1]);
                        continue;
                    }                   
                    dateMap.put(splitvalue[0],Date.valueOf(splitvalue[1])); 
                }
                set<string> recordKeys = new set<string>();
                if(dateMap.size() > 0){
                    recordKeys = dateMap.keySet();                
                    nf.addall(recordkeys);                
                }
                system.debug('recordkeys:' + recordkeys);
                //list<case> finalCases = [select CaseNumber, ClosedDate, Provider_Finder_Close_Date__c, Billing_NPI_Number__c, Rendering_NPI__c from case where (Billing_NPI_Number__c in :recordKeys OR Rendering_NPI__c in :recordKeys) and Provider_Finder_Close_Date__c = null and ((Parentid != null and Status = 'Closed Processed') OR (recordTypeId = '01241000000jexx' and Status = 'Closed')) and ClosedDate = LAST_N_DAYS:4] ; 
                list<case> finalCases = [select CaseNumber, ClosedDate, Provider_Finder_Close_Date__c, Billing_NPI_Number__c, Rendering_NPI__c from case where (Billing_NPI_Number__c in :recordKeys OR Rendering_NPI__c in :recordKeys) and Provider_Finder_Close_Date__c = null and (Parentid != null and Status = 'Closed Processed')  and ClosedDate = LAST_N_DAYS:15] ; 
                system.debug('final cases:' + finalcases);    
                 
                // Retrieving all the Salesforce Cases which match the NPI from Provider Finder
                for(Case c:finalCases){                    
                    system.debug('Inside loop:' + dateMap.get(c.Billing_NPI_Number__c) + ':' + dateMap.get(c.Rendering_NPI__c));
                    boolean flag = false;
                    if(dateMap.get(c.Billing_NPI_Number__c) != null && Date.valueof(c.ClosedDate.format('yyyy-MM-dd','America/Chicago')) > dateMap.get(c.Billing_NPI_Number__c) ){
                         system.debug('Inside loop:' + dateMap.get(c.Billing_NPI_Number__c) + ':' + c.Billing_NPI_Number__c + ':' + dateMap.get(c.Billing_NPI_Number__c));
                        badrows.add('Issue with Provider Finder File: row number: ' +'  Provider Finder Date value is bad:' + c.Billing_NPI_Number__c +  ':' + dateMap.get(c.Billing_NPI_Number__c));                                 
                        flag = true;
                    } 
                    if(dateMap.get(c.Rendering_NPI__c) != null && Date.valueof(c.ClosedDate.format('yyyy-MM-dd','America/Chicago')) > dateMap.get(c.Rendering_NPI__c)){
                         system.debug('Inside2 loop:' + dateMap.get(c.Rendering_NPI__c) + ':' + c.Rendering_NPI__c + ':' + dateMap.get(c.Rendering_NPI__c));
                        badrows.add('Issue with Provider Finder File: row number: ' +'  Provider Finder Date value is bad:' + c.Rendering_NPI__c + ':' + dateMap.get(c.Rendering_NPI__c));                        
                        flag = true;
                    }
                    
                    if(flag == true){
                        if(c.Billing_NPI_Number__c != null && dateMap.get(c.Billing_NPI_Number__c) != null)
                            foundkeys.put(c.Billing_NPI_Number__c, c.Billing_NPI_Number__c);
                        if(c.Rendering_NPI__c != null && dateMap.get(c.Rendering_NPI__c) != null)
                            foundkeys.put(c.Rendering_NPI__c, c.Rendering_NPI__c);   
                        continue;
                    }
                    system.debug('Passed the break');
                    if(dateMap.get(c.Rendering_NPI__c) != null){
                        c.Provider_Finder_Close_Date__c = dateMap.get(c.Rendering_NPI__c);
                        foundkeys.put(c.Rendering_NPI__c, c.Rendering_NPI__c);
                        if(dateMap.get(c.Billing_NPI_Number__c) != null)
                            foundkeys.put(c.Billing_NPI_Number__c, c.Billing_NPI_Number__c);                            
                    }else{
                        c.Provider_Finder_Close_Date__c = dateMap.get(c.Billing_NPI_Number__c);
                        foundkeys.put(c.Billing_NPI_Number__c, c.Billing_NPI_Number__c);
                    }
                }
                
                //Accumulating list of NPI numbers for which match is not found on Salesforce
                for(string s:nf){
                    if(foundkeys.get(s) == null)
                        notfoundrows.add(s);
                }
                
                // Performing updates on Salesforce
                if(finalCases.size() > 0){
                    Database.SaveResult[] srList = Database.update(finalCases, False) ; 
                
                    // Iterate through each returned result
                    for(Integer i=0;i<srList.size();i++){
                        if (srList.get(i).isSuccess()){
                            countOfSuccess = countOfSuccess + 1;           
                        }else if (!srList.get(i).isSuccess()){
                            // DML operation failed                        
                            Database.Error error = srList.get(i).getErrors().get(0);
                            String failedDML = error.getMessage();
                            system.debug('Failed ID'+finalCases.get(i).Id + ':' + finalCases.get(i).Billing_NPI_Number__c);                  
                            System.debug(error.getStatusCode() + ': ' + error.getMessage());
                            System.debug('Fields that affected this error: ' + error.getFields());
                            badrows.add('Issue with Salesforce Update:Error has occurred for record with ID:' + finalCases.get(i).Id + ' / Case Number:' + finalCases.get(i).CaseNumber + ' / NPI:' + finalCases.get(i).Billing_NPI_Number__c + ' StatusCode:' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected this error: ' + error.getFields());
                        }
                        
                    }
                }
                if(notFoundRows.size() == 0)
                    allnotfoundrows = 'None';
                for(string u:notFoundRows)
                {
                    allnotfoundrows += (u + '<br>') ;
                }
                For(string u:badrows)
                {
                    allbadrows += (u + '<br>') ;
                }
                System.debug(' Badrows ' + allbadrows);
                result.success = true;
                System.debug(' Result '  + result.success);         
            }
            catch (Exception e)
            {
                System.debug(' Exception ' + e);
                System.debug(' badrows '  + badrows);
                result.success = false;
                System.debug('Lax Result '  + result.success);
                body1 = '<html><body>Hello All,' + '<br>' + '<br>' + 'Unexpected error has happened on Salesforce end while processing the file. Please take appropriate action.' +  '<br>' + '<br>' + '- Salesforce Team.</body></html>';    
                emailNotice.setHtmlBody(body1);
                Mails.add(emailNotice);
                Messaging.sendEmail(Mails);
                return result;
            }            
        }        
        
        if(!processSheet && reason == 'badfileformat'){
            emailNotice.setSubject('UAT : Salesforce Case Update based on Provider Finder Info :: '+ 'Problem with file format');
            body1 = '<html><body>Hello All,' + '<br>' + '<br>' + 'There is a problem with File format. Please resend the file with correct format ' +  '<br>' + '<br>' + '- Salesforce Team.</body></html>';    
        }else if(!processSheet && reason == 'badheaders'){
            emailNotice.setSubject('UAT : Salesforce Case Update based on Provider Finder Info :: '+ 'Problem with file headers');
            body1 = '<html><body>Hello All,' + '<br>' + '<br>' + 'There is a problem with File headers. Please resend the file with correct headers ' +  '<br>' + '<br>' + '- Salesforce Team.</body></html>';    
        }else{
            emailNotice.setSubject('UAT : Salesforce Case Update based on Provider Finder Info');
            body1 = '<html><body>Hello All,' + '<br>' + 'Find below for summary of Provider Finder File processing on Salesforce' + '<br>' + '<br>' +'<b>' + 'Number of Records that got successfully updated on Salesforce :: ' +  '</b>' + countOfSuccess + '<br>' + '<br>' + '<b>' +'Number of Records that errored during processing :: ' +  '</b>' + badrows.size() + '<br>' + allbadrows + '<br>' + '<b>' + 'We could not find a match on Salesforce Cases for the following NPI numbers:' + '</b>' + '<br>' + allnotfoundrows + '<br>' + '<br>' + '- Salesforce Team.</body></html>';            
        }                             
        
        emailNotice.setHtmlBody(body1);
        Mails.add(emailNotice);
        Messaging.sendEmail(Mails);
        
        //Reset the flag to true to confirm that file is recieved. 
        if(!Test.isRunningTest()){
            GlobalSettings__c flag = [select PFFileRecieved__c from GlobalSettings__c where Name = 'PFFileRecieved'];
            flag.PFFileRecieved__c = true;
            update flag;
        }
        return result;
    }
}