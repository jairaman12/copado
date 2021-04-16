global class ScheduledCredentialingReport implements Schedulable {
    global void execute(SchedulableContext ctx) {
       CredentialingReport cr = new CredentialingReport();
        cr.initFromMetaData('ReportConfig__mdt.Credentialing_Report');
        cr.callReport();
        //cr.sendEmailWithAttachment(cr.callReport());
    }
}