/**************************************************************************************************
Apex Class Name  : DummyClass
Version          : 1.0  
Functionality    : This is a dummy class to help create email id for inbound email handler
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              July 21, 2017       Pre Step For PPN-3460
***************************************************************************************************/
Global class DummyClass implements Messaging.InboundEmailHandler
{
    string csvbody = ''; 
    Boolean processSheet = True;
    string[] lineByCsvBody = new String[]{};
      
    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope)
    {     
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();                     
        Messaging.InboundEmail.textAttachment[] tAttachments = email.TextAttachments;
        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments;
        System.debug(' Binary Attachement from the email. ' + bAttachments);        
        
        for(Messaging.InboundEmail.BinaryAttachment ba :bAttachments)
        { 
            if(!(ba.filename.endsWith('.csv')))
            { 
                processSheet = False;
                result.success = false;
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
                result.success = true;
            }   
        }
        return result;
    }
}