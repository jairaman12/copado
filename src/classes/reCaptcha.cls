public class reCaptcha {

    /* Configuration */

    // The API endpoint for the reCAPTCHA service
    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify'; 

    // The keys you get by signing up for reCAPTCHA for your domain
    private static String privateKey{get;set;}
    
    public String publicKey{get;set;}         
    
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; private set; }
    
    public reCaptcha() {
        this.verified = false;
        Web2Case__c captchaPublicKey = Web2Case__c.getValues('CaptchaPublicKey');
        if(captchaPublicKey != null){
            	publicKey = captchaPublicKey.CaseObjectValues__c; 
             	System.debug('public key = ' + publicKey);
        }
        Web2Case__c captchaPrivateKey = Web2Case__c.getValues('CaptchaPrivateKey');
        if(captchaPrivateKey != null){
            	privateKey = captchaPrivateKey.CaseObjectValues__c; 
            	System.debug('private key = ' + privateKey);
        }        
        
    }
    
    public Boolean verify() {
        System.debug('reCAPTCHA verification attempt');
        
        System.debug('reCAPTCHA response = ' + response);
        // On first page load, form is empty, so no request to make yet
        if ( response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
            return false; 
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'secret=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&response='  + response
        );
        
        if ( r!= null ) {
            String verificationJSON = r.getBody();
            System.debug('r body = ' + verificationJSON);
            Map<String, Object> vj =    (Map<String, Object>)JSON.deserializeUntyped(verificationJSON);
            System.debug(vj.get('success'));
            
            this.verified =  (Boolean)vj.get('success');

        }
        System.debug('verified = ' + this.verified);
        
        if(this.verified) {
            

            return true;
        }
        else {
        
            return false; 
        }
    }

    public PageReference reset() {
        return null; 
    }   

    /* Private helper methods */
    
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
    
     @TestVisible    
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
}