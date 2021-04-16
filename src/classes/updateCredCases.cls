/**************************************************************************************************
Apex Class Name  : updateCredCases
Version          : 1.0  
Functionality    : Update Cred Cases
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Apr 18,2019             To optimize code for CredentialingReport class
***************************************************************************************************/
public class updateCredCases implements Queueable {
    list<case> casesToBeUpdated = new list<case>();
    String dString = '';
    List<String> caseNumbersList = new List<String>();
    Integer unreportedCount = 0;
    Integer priorCount = 0;
    Integer todaysCount = 0;    
    String htmlEmailBody = '';
    String filename = '';
    String subject = '';
    String emailList = '';
    String body = '';
    String failuresReportemailList = '';
    public updateCredCases (String dString,List<Case> casesToBeUpdated,List<String> caseNumbersList,Integer priorCount,String htmlEmailBody,String fileName,String subject,String emailList,String body,String failuresReportemailList) {      
        this.casesToBeUpdated = casesToBeUpdated;
        this.dString     = dString;
        this.caseNumbersList     = caseNumbersList;
        this.htmlEmailBody     = htmlEmailBody;
        this.priorCount     = priorCount;
        this.filename     = filename; 
        this.subject = subject;
        this.emailList = emailList;
        this.body = body;
        this.failuresReportemailList = failuresReportemailList;
        this.todayscount = casesToBeUpdated.size();
    }
    
    public void execute(QueueableContext qc) {
        List<Database.SaveResult> caseResults = new List<Database.SaveResult>();
        if(casesToBeUpdated.size() > 0)
            caseResults     =   Database.update( casesToBeUpdated, false ); 
        unreportedCount = [select count() from case where status in ('New','Inprogress') and Cred_Case_Reported__c = false 
                           and recordtype.developername in ('Provider_Group_On_boarding_Credentialling','Provider_Manual_Group_On_boarding_Credentialling','Provider_On_boarding_Credentialing')]; 
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        blob csv = blob.valueOf(dString);        
        attach.setBody(csv);        
        attach.contentType = 'text/csv';        
        attach.setFileName(fileName);   
        htmlEmailBody += '<html><body>';
        htmlEmailBody += '<b>Current Batch TimeStamp:    </b>' + system.now() + '<br/>';
        htmlEmailBody += '<table class="tabelle separate" border="1"><tr><th>Description</th><th>Count</th></tr>';
        //htmlEmailBody += '</tr><td class="zelle">' + 'Current Batch TimeStamp' + '</td><td class="zelle">' + system.now() + '</td></tr>'; 
        htmlEmailBody += '</tr><td class="zelle">' + 'Total number of cred cases submitted to VISTAR as of yesterday' + '</td><td class="zelle">' + priorCount + '</td></tr>';
        htmlEmailBody += '</tr><td class="zelle">' + 'Number of cred cases submitted to VISTAR only today in the attached report' + '</td><td class="zelle">' + todaysCount  + '</td></tr>';
        htmlEmailBody += '</tr><td class="zelle">' + 'Total number of cred case not reported as of today' + '</td><td class="zelle">' + unreportedCount + '</td></tr>';
        htmlEmailBody += '</table>';
        htmlEmailBody += '</body></html>';
        Messaging.singleEmailMessage EmailWithAttachment = new Messaging.singleEmailMessage();        
        EmailWithAttachment.setSubject(subject);        
        EmailWithAttachment.setToaddresses(emailList.split(';'));        
        EmailWithAttachment.setPlainTextBody(body);         
        EmailWithAttachment.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        EmailWithAttachment.setHTMLBody(htmlEmailBody);
        // Sends the email   
        try{     
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailWithAttachment});
        }catch(Exception EmailException){
            
        }
        
        //caseResults     =   Database.update( casesToBeUpdated, false );   
        System.debug('caseResults===>>>>'+caseResults);
        // failed cases email
        If(!caseResults.isEmpty())
        {
            String failedRecords    =   '';
            failedRecords           =   failedRecords+'<center><table style="border: 1px solid black;">'
                + '<tr>'
                +'<th style="border: 1px solid black;">Case Number</th>'
                +'<th style="border: 1px solid black;">Error Meaasge</th>'
                +'</tr>';
            boolean errorFlag = false;
            for(Integer i=0;i<caseResults.size();i++)
            {
                if (caseResults.get(i).isSuccess())
                {
                    caseResults.get(i).getId();
                    
                }else if (!caseResults.get(i).isSuccess())
                {
                    // DML operation failed
                    Database.Error error = caseResults.get(i).getErrors().get(0);
                    String failedDML        = error.getMessage();
                    System.debug('failedDML===>>>>'+failedDML);
                    system.debug('Failed ID===>>>'+casesToBeUpdated.get(i).CaseNumber);
                    failedRecords   =   failedRecords+'<tr>'
                        +'<td style="border: 1px solid black;">'+caseNumbersList.get(i)+'</td>'
                        +'<td style="border: 1px solid black;">'+failedDML+'</td>'
                        +'</tr>';
                    errorFlag = true;
                }
            }
            
            if(!String.isEmpty(failedRecords) && errorFlag)
            {
                failedRecords= failedRecords+'</table></center>'; 
                System.debug('failedRecords====>>>'+failedRecords);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(failuresReportemailList.split(';'));
                mail.setSubject('Error in updating cred report processed flag');
                mail.setHtmlBody('<html><body>Hello All,' + '<br>' + '<br>'
                                 +'<b>'+'Unexpected error has happened on Salesforce while updating the cred procseed flag on following credentialing cases :'
                                 +'</b>'+ '<br>' + failedRecords 
                                 + '<br>' + '<br>'+'Please take appropriate action.' + '<br>' + '- Salesforce Team.</body></html>'
                                );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    
}