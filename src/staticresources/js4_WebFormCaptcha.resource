/*

	This method is a callback for the Captcha feature.
	It is called after the Captcha challenge has completed.
*/

function completeTransaction(){
		$("#captchaContainer").hide();   
    /*
    	Get the response from the captcha process and put it in a Salesforce 
        naming standard compliant field.
    */
		if($("#g-recaptcha-response").val().length > 0){
			$("input[id*='captchaResponse']").val($("#g-recaptcha-response").val());    
			$("a[id*='postCaptchaSubmit']")[0].click();			
			no.blockme();			  			
		}
		else{
			vfo.populateAnErrorMessage($("div#s1 button.sButton"), "Submit did not complete", "Please resubmit.");
			$("#g-recaptcha-response").val("");
			
		}
} 

$().ready(  
    function(){
		$("#closeCaptcha").click(
		
			function(){
							
				$("#captchaContainer").hide();
				$("#g-recaptcha-response").val("");
				grecaptcha.reset();
				
								
			}
		);	  
		
		$("#resetCaptcha").click(
		
			function(){
											
				$("#g-recaptcha-response").val("");
				grecaptcha.reset();
				
								
			}
		);	  		
	}
);