


var reA = /[^a-zA-Z]/g;
var reN = /[^0-9]/g;
function sortAlphaNum(a,b) {
    var aA = a.replace(reA, "");
    var bA = b.replace(reA, "");
    if(aA === bA) {
        var aN = parseInt(a.replace(reN, ""), 10);
        var bN = parseInt(b.replace(reN, ""), 10);
        return aN === bN ? 0 : aN > bN ? 1 : -1;
    } else {
        return aA > bA ? 1 : -1;
    }
}
function validationAndFormattingObject()
{       
    
    
    this.domainSpecialCharacters = ['~', '!','@',"#",'$','%','^','&','*','(',')','+','=','{','}','|',':', ';','[', ']','|','?', ',', '_', '<', '>', '%', '/', '\\', '\'', '\"','`'];
    
    this.tldSpecialCharacters = this.domainSpecialCharacters.concat(['1','2','3','4','5','6','7','8','9','0','-']);
    
    /*	
		PPN-14244		
	The blockSpecialChar function was on the main VF component page.
    I moved it here to align it with the overall JS design structure.
    */     
    
    /* PPN-20007 */
    this.blockSpecialChar = function(e)
    {
        var k;
        document.all ? k = e.keyCode : k = e.which;
        return ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8 || k == 32 );
    }  
    
    
    /*
			Used to hide the "X" associated with calendar controls
			and sets calendar control to = ""
	*/	
    this.deleteAssociated = function(callingObject,objectId){
        $(callingObject).hide();
        $("input[id*='" + objectId + "']")[0].value = "";   
        
    } 
    
    /*	
		PPN-14244		
   			Used to remove the "X" associated with attachment/file controls
			and set associated file input value to = ""
            callingObject = "X" in span
	*/	
    this.deleteAssociatedFile = function(callingObject){
        
        var tObj = $(callingObject).prev();
        $(tObj).val("");
        $(tObj).hide();
        
        var fileInfo = fo.calculateValidFileSize($(callingObject));
        $(callingObject).parent().find("#combinedFileSize").html("Combined file size = " + (fileInfo[0]/(1024*1024)).toFixed(2) + " MB" );  
        
        $(callingObject).next().remove();
        $(callingObject).remove();
        
    } 	
    
    
    /*
		Function for controlling the display and maintenance of the header error display panel
	*/	
    this.errorHeaderAndGlow = function(){
        
        /*
			Display the message at the top of the page.
		*/
        $("#errorMessageContainer").show();
        
        
        
        /*
			Set a glow on the next button for 1 second
		*/
        $("div.buttonContainer .next, div#s1 .sButton").toggleClass("errorGlow", true);
        window.setTimeout(this.undoGlow.bind(null, $("div.buttonContainer .next, div#s1 .sButton"), "errorGlow"), 1000);
        
    }   
    
    /*
		Disable glow on button
	*/	
    this.undoGlow = function(obj, className){
        $(obj).toggleClass(className, false);
    }
    
    this.glow = function(obj, className)
    {
        $(obj).toggleClass(className);
        setTimeout(this.undoGlow.bind(null, $(obj), className ), 1000);
       
        
        
    }    
    /*
		Controls error messages which appear under input labels
	*/	    
    this.populateAnErrorMessageForHeader = function(object, outputMsg, noTitleMsg){
        
        $(object).parent().find(".additionalErrorMessage").remove();
        
        var eMessage = outputMsg.length < 1 ? noTitleMsg : outputMsg;
        
        $(object).before("<div class='additionalErrorMessage'>" + eMessage + "</div>");
        
        
    }	
    
    /*
		Controls error messages which appear under input labels
	*/	    
    this.populateAnErrorMessage = function(object, outputMsg, noTitleMsg){
        
        
        
        var eMessage = outputMsg.length < 1 ? noTitleMsg : outputMsg;
        
        if($(object).is("fieldset")){
            $(object).parent("p").find(".additionalErrorMessage").remove();
            $(object).before("<div class='additionalErrorMessage'>" + eMessage + "</div>");
        }
        else if(object.type == "file"){
            $(object).parent().parent().find(".additionalErrorMessage").remove();
            $(object).parent().parent().find("label").before("<div class='additionalErrorMessage'>" + eMessage + "</div>");			
        }
            else if(object.type == "checkbox"){
                $(object).parent().find(".additionalErrorMessage").remove();
                $(object).parent("label").before("<div class='additionalErrorMessage'>" + eMessage + "</div>");			
            }        
                else{
                    $(object).parent("p").find(".additionalErrorMessage").remove();
                    $(object).siblings("label").before("<div class='additionalErrorMessage'>" + eMessage + "</div>");	
                }
        
        
    }
    
    this.getMailFormat = function(){
        this.mailFormat = /([\w-\.]+)@((?:[\w-]+\.)+)([a-zA-Z]{2,4})/;		
        return this.mailFormat;
    }    
    
    this.checkHours=function(){	
        var hrs=false;
        $("div#h input[type='text']").each(function () {
            if ($(this).val().length > 0) {			
                hrs=true;
            }
        });
        return hrs;
    }
    
    this.calculateAge = function(dateOfBirth) {	 
        var dateToCalculate = new Date();
        var calculateYear = dateToCalculate.getFullYear();
        var calculateMonth = dateToCalculate.getMonth();
        var calculateDay = dateToCalculate.getDate();
        var birthYear = dateOfBirth.getFullYear();
        var birthMonth = dateOfBirth.getMonth();
        var birthDay = dateOfBirth.getDate();
        
        var age = calculateYear - birthYear;
        var ageMonth = calculateMonth - birthMonth;
        var ageDay = calculateDay - birthDay;
        
        if (ageMonth < 0 || (ageMonth == 0 && ageDay < 0)) {
            age = parseInt(age) - 1;
        }
        return age;
    }
    
    
    this.toggleTarget = function(target) {
        $(target).toggle();
    }
    
    this.formatPhone= function(phoneObj) {
        
        
        var s2 = (""+phoneObj.value).replace(/\D/g, '');
        var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
        if(!m){
            vfo.populateAnErrorMessage(phoneObj, phoneObj.title, "Please enter a valid number.");
            return false;
        }
        else{
            phoneObj.value = "(" + m[1] + ") " + m[2] + "-" + m[3];            
            return true;
        }
        
        
        
    }
    
    this.resetErrorText = function(){
        /*
				remove all the red text error messages 
			*/
        $(".additionalErrorMessage").remove();             
    }       
    
    this.resetErrorDisplay = function(){                
        $("#errorMessageContainer").hide();          
    }    
    
    this.resetAllErrors = function(){
        this.resetErrorDisplay();
        this.resetErrorText();
        
    }    
    
    this.nonBusinessRulesValidation = function(parentDiv){
        
        var validationIsGood = true;                                                           
        var firstPageValidation = true;
        var allEmailGood = true;
        
        /*
          	fieldsets with no inline styles are the gimick I use to consider their
            inputs as required.
          */
        parentDiv.find("fieldset:not([style*='border'])").each(
            /* for each fieldset check to make sure at least one item is checked*/
            function(index, element){
                if($(element).find(":checked").length == 0){
                    /*
                        	Change this alert message to a more user friendly lookup
                        */
                    vfo.populateAnErrorMessage(element, $(element).find(":input")[0].title, "Please select a value" ); 
                    validationIsGood = false;
                    
                    
                }
            }                               
        );    
        
        /*
          	Get all inputs from the div section parent for the calling button          
            and process validations
          */          
        parentDiv.find(":input", "textarea", "select").each(
            function( index, element ) {
                
                /*
						the checkValidity() method checks the following:
						
						customError	Set to true, if a custom validity message is set.
						patternMismatch	Set to true, if an element's value does not match its pattern attribute.
						rangeOverflow	Set to true, if an element's value is greater than its max attribute.
						rangeUnderflow	Set to true, if an element's value is less than its min attribute.
						stepMismatch	Set to true, if an element's value is invalid per its step attribute.
						tooLong	Set to true, if an element's value exceeds its maxLength attribute.
						typeMismatch	Set to true, if an element's value is invalid per its type attribute.
						valueMissing	Set to true, if an element (with a required attribute) has no value.
						valid	Set to true, if an element's value is valid.
						
						If any one of the checks above returns true, the value will issue an error
						(this may be overkill since we are only really interested in patterns and required fields)
						
						The error message displayed is first looked for in the title attribute of the reporting field,
						if there is no title attribute, the default message is displayed.
					
					*/
                
                if(!(element.checkValidity())){
                    vfo.populateAnErrorMessage( element,  element.title, "Please make sure valid data has been entered.");  
                    validationIsGood = false;                        
                }
            }
        );   
        /*
			The faux-required attribute is used because if we set required="true" on any page other than the 
            first page, the controller will error
		 */
        parentDiv.find("input[fauxrequired='true']").each(
            
            function( index, element ) {
                
                if((element.value < 1)){
                    vfo.populateAnErrorMessage(element, element.title,  "Please complete the required field.");  
                    validationIsGood = false;                        
                }
            }              
            
        );
        
        /*
			Make sure all email fields are properly formatted for the current section
		 */
        parentDiv.find("input[fieldtype='email']").each(
            
            function( index, element ) {				
                if(element.value.length > 0 && vfo.validateEmail(element) == false){
                    allEmailGood = false;
                }                        											                   
            }                            
        );		  
        
        
        
        if(parentDiv[0].id == "p1"){
            firstPageValidation = this.firstPageRules();   
        }    
        
        
        return (validationIsGood && allEmailGood && firstPageValidation);
    }    
    
    this.firstPageRules = function(){
        
        return (vfo.validateEmail($("input[id*='emailSubId']")[0]) && vfo.formatPhone($("input[id*='telsubId']")[0]));
        
    }    
    
    this.compareNewAndCurrent = function(parentDiv){
        
        var validationIsGood = true;
        
        /*
          	Make sure every new data element has a corresponding
            current data element
          */
        var currentList = $(parentDiv).find("input[compare='current']");
        var newList = $(parentDiv).find("input[compare='new']");
        
        currentList.sort();
        newList.sort();
        
        newList.each(
            function(index) {
                
                if(this.value.length > 0 && currentList[index].value.length < 1){
                    vfo.populateAnErrorMessageForHeader($(parentDiv).find("h3").before()[0], "Please complete your current information", "Alert" );
                    validationIsGood = false;
                }
            }
        );          
        
        
        return validationIsGood;
        
    }
    
    this.businessRulesValidation = function(parentDiv){
        
        
        
        var pageSpecificValidationIsGood = true;   
        var newMatchesCurrent = true; 
        
        if(parentDiv[0].id == "p1"){
            pageSpecificValidationIsGood = bo.firstPageRules();   
        }              
        else if(parentDiv[0].id == "p2"){
            pageSpecificValidationIsGood = bo.secondPageRules();   
        }    
            else if(parentDiv[0].id == "p3"){
                pageSpecificValidationIsGood = bo.nameChangeRules();              
            }  
                else if(parentDiv[0].id == "p4"){
                    pageSpecificValidationIsGood = bo.npiAndTaxIdRules();
                }    
                    else if(parentDiv[0].id == "p5"){
                        pageSpecificValidationIsGood = bo.officeAndAddressRules();   
                    }              
                        else if(parentDiv[0].id == "p9"){
                            pageSpecificValidationIsGood = bo.otherRules();   
                        }              
                            else if(parentDiv[0].id == "p10"){
                                pageSpecificValidationIsGood = bo.removeProviderRules();   
                            }                        
        
        /*
          * Commented out for PPN-21893
          * Do not require current input when new input is provided
          */
        //newMatchesCurrent = this.compareNewAndCurrent(parentDiv);
        
        
        return (pageSpecificValidationIsGood && newMatchesCurrent);
        
    }    
    
    this.validateAndSubmitAllNoCaptcha = function(){
        /*
			Get the value of the last section from no.getVPage(), use it to determine which section (div with id="p*") the 
			button was called from and find the back button in that section. This value will be passed to the 
			validateAndMove function to determine the parent div of the calling object
		*/
        no.blockme();		        
        if(this.validateAndMove($("#" + no.getVPage()[no.getCPI()]).find("button[type='button'].back"))){
            return true;
        }
        else{
            $.unblockUI(); 
            return false;
        }
    }           
    
    
    this.validateAndSubmitAllForm = function(){
        /*
			Get the value of the last section from no.getVPage(), use it to determine which section (div with id="p*") the 
			button was called from and find the back button in that section. This value will be passed to the 
			validateAndMove function to determine the parent div of the calling object
		*/
          
          this.validateAndMove($("#" + no.getVPage()[no.getCPI()]).find("button[type='button'].back"));
          return false;
          
          
      }       
      
      /*
	Main validation entry point
	1. Get parent div from calling button
	2. Validate non-business rules (formatting, required, etc...)
	3. Validate business rules
	4. If valid data for section, process for continue
	5. If not valid business rules, call errorHeaderAndGlow method to display errors to user

*/            
      this.validateAndMove = function(callingButton){     
          var nonBusinessValidationIsGood = true; 
          var businessValidationIsGood = true;
          
          this.resetAllErrors();   
          var parentDiv = $(callingButton).parentsUntil("div[id*='p']").parent("div.success");
          
          nonBusinessvalidationIsGood = this.nonBusinessRulesValidation(parentDiv);   
          businessValidationIsGood = this.businessRulesValidation(parentDiv); 
          
          if(nonBusinessvalidationIsGood && businessValidationIsGood){
              this.resetAllErrors();
              if(parentDiv[0].id == "p1"){
                  no.hideShowSection('p1', 'p2');     
              }
              else if(parentDiv[0].id == "p2"){
                  no.navSel();   
              }
              /* This is the last div to process */
                  else if(parentDiv[0].id == (no.getVPage())[(no.getVPage()).length - 1]){
                      /*
				  * Check if captcha container exists, maybe using captcha bypass
				  */                  
                      ($("#captchaContainer").length > 0)? $("#captchaContainer").show(): "";
                  }    
              /* More divs to process */
                      else{                       
                          $(parentDiv[0]).hide();
                          no.multiSelect("p" + (no.getCPI() + 1));
                      }    
          }
          else if((!businessValidationIsGood || !nonBusinessValidationIsGood) && parentDiv[0].id != "p2" ){
              vfo.errorHeaderAndGlow();
          }    
          
          
          return (nonBusinessvalidationIsGood && businessValidationIsGood);
          
      }   
      
      /*******************************************************************************************************/            
      
      
      
      this.validateOtherProvChg = function(){
          
          blockme();
      }
      
      this.checkForCharacters = function(input, charString){
          
          var noSpecialCharacter = true;
          
          $( charString).each(function( index, element ) {
              if(input.indexOf(element) > -1){
                  noSpecialCharacter = false;
              }
          });
          
          
          return noSpecialCharacter;
      }
      
      
      
      
      this.validateEmail = function(inputObject){
          
          /*
           * Do basic email validation
           */ 
          var isEmailValid = inputObject.value.match(this.getMailFormat());
          
          isEmailValid == null ? isEmailValid = false: isEmailValid = true;
          
          var isDomainValid = true;
          var isTLDValid = true;
          var isGoodAtSymbolCount = true;
          var endsInAlpha = true;
          
          /*
           * See if there are multiple "@" in the address
           */           
          if(inputObject.value.split("@").length != 2){
              isGoodAtSymbolCount = false;
          }
          
          
          /*
           * Split address into component parts <local-part>@<domain>.<top-level domain>
           * Check for domain special characters in the domain
           * Check for top level domain special characters (domain spec. chars + numbers)
           */           
          if(isEmailValid && isGoodAtSymbolCount){
              var afterAtSign = inputObject.value.split("@")[1];                                       
              var domainName = afterAtSign.slice(0, afterAtSign.lastIndexOf("."));
              var tld = afterAtSign.slice(afterAtSign.lastIndexOf(".") + 1, afterAtSign.length);
              
              /*
           * Check to see if last character in address is an alpha
           */                       
              if(isEmailValid){
                  isDomainValid = vfo.checkForCharacters(domainName, vfo.domainSpecialCharacters );
                  isTLDValid = vfo.checkForCharacters(tld, vfo.tldSpecialCharacters);              
              }
              
              if(isEmailValid && isDomainValid && isTLDValid){
                  endsInAlpha = /^[a-zA-Z]+$/.test(afterAtSign.slice(-1));
                  
              }  
              
              
          }
          
          if(!isEmailValid || !isDomainValid || !isTLDValid || !isGoodAtSymbolCount || !endsInAlpha){
              vfo.populateAnErrorMessage(inputObject, "Please check the format of your email address.", "Alert");            
          }          
          
          return isEmailValid & isDomainValid & isTLDValid & isGoodAtSymbolCount;
          
      } 
      
      this.setDatePickerMaxDate = function(partialId, valuePeriodPair){
          
          $("input[id*='" + partialId + "']").datepicker
          ( 
              "option", "maxDate", 
              valuePeriodPair
          )                            	                   
      }
}     

/*	
		PPN-14244		
		File object for attachments
         */ 
function fileObject()
{
    
    //this.maxFileSize = 5242880;      //This is the max file size in bytes (5MB)
    this.maxFileSize = 26214400;		//This is the max combined files size (per request type, 25MB)
    this.fileTypes=['GIF', 'JPG', 'PNG', 'JPEG', 'PDF','DOC','DOCX','XLS','XLSX','TXT','BMP','ZIP','gif', 'jpg', 'png', 'jpeg', 'pdf','doc','docx','xls','xlsx','txt','bmp','zip'];
    this.sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    
    this.initialize = function(){                                 
    }    
    
    this.getSizes = function(){
        return this.sizes;   
    }    
    
    this.getMaxFileSize = function(){
        return this.maxFileSize;  
    }
    
    this.getFileTypes = function(){
        return this.fileTypes;            
    } 
    
    this.getBlockMeImage = function(){
        
        return blockMeImagePath;
    }
    
    this.getCalendarButtonImage = function(){
        
        return calendarImagePath;
        
    }
    
    this.bytesToSize = function(bytes) {         
        if (bytes == 0) return '0 Byte';
        var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));       
        return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + (this.getSizes())[i];
    }
    
    
    /*	
		PPN-14244		
		Calculate the size of the triggering input and combined file sizes for request type
         */    
    this.calculateValidFileSize = function(obj)
    {
        
        var returnArray = new Array();
        var requestTypeFileInputs = $(obj).parent().find("input:file");
        var requestTypeCombinedFilesSize = 0;
        var tcfs = 0;
        for(var i=0; i < requestTypeFileInputs.length; i++)
        {                
            if(requestTypeFileInputs[i].files[0] != undefined)
            {
                tcfs = tcfs + requestTypeFileInputs[i].files[0].size;
                if(tcfs < this.getMaxFileSize())
                {
                    requestTypeCombinedFilesSize += requestTypeFileInputs[i].files[0].size;
                }
            }                             
        }
        
        returnArray.push(requestTypeCombinedFilesSize, tcfs);
        
        return returnArray;
        
    }
    
    this.uploadFile = function(obj) {
        
        var validationIsGood = true;
        vfo.resetErrorText();
        
        var path = obj.value;  
        
        /*
           * Check accepted file types for calling object
           */
        var fileTypes = "";
        $(obj).siblings(".fileFormatText:contains('docx')").length == 0 ? 	
            fileTypes = [".xls", ".xlsx", ".XLS", ".XLSX"] 
        : fileTypes = this.getFileTypes();
        
        
        var ext = path.substring(path.lastIndexOf('.') + 1);    
        
        var fileInfo = this.calculateValidFileSize(obj);
        
        if(fileTypes.join(".").indexOf(ext) == -1){    
            
            obj.value = "";
            vfo.populateAnErrorMessage(obj, "Please upload files types ending with : \n\n " + fileTypes,'Alert');
            
            
            validationIsGood = false;
        }
        else if (fileInfo[1] > this.getMaxFileSize())
        {
            
            obj.value = "";
            vfo.populateAnErrorMessage(obj, 'Combined file sizes are over 25MB for this request type. Please upload a combined attachment file size of less than 25MB.','Alert');
            
            validationIsGood = false;
        }    			 			 
        
        
        if(!validationIsGood){
            vfo.errorHeaderAndGlow();
            fo.paintFileData(obj, false);
        }
        
        return validationIsGood;
    }   
    
    this.showNextHidden = function(trigger)
    {
        var allInputsHaveFileNames = true;
        var tObj = $(trigger).closest(".uploadFile").find("input:hidden")[0];
        $(trigger).closest(".uploadFile").find("input:visible")
        .each
        (
            function(index)
            {
                if(this.files[0] == undefined)
                {
                    allInputsHaveFileNames = false;
                }
            }
        );
        (allInputsHaveFileNames)?
        (
            $(tObj).show(),
        	vfo.glow(tObj, "highlightGlow")
        )
        :vfo.populateAnErrorMessage(tObj, 'Please attach a file using the available \'Choose File\' button.');
    }
    
    this.paintFileData = function(obj, passedValidation)
    {
        var fileInfo = this.calculateValidFileSize(obj);                    
        $(obj).next("#deleteAssociated").next(".fileFormatText").remove();
        $(obj).next("#deleteAssociated").remove();
        
        var htmlForDisplay = ($(obj)[0].files[0] != undefined)?
            (
                "<span id='deleteAssociated' onclick=vfo.deleteAssociatedFile(this);>X</span>" +
                "<div class='fileFormatText'>file size: " + ($(obj)[0].files[0].size/(1024*1024)).toFixed(2) + " MB</div>"            
            )
        : '' ;        
        
        $(obj).after
        (
            htmlForDisplay
        );   
      
        
        (passedValidation)?
        vfo.resetAllErrors()
        :false;
        
        $(obj).parent().find("#combinedFileSize").html("Combined file size = " + (fileInfo[0]/(1024*1024)).toFixed(2) + " MB");
    }
    
    
    this.initialize();    
}





function navigationObject()
{
    
    /*
		This is the object which hold the navigation array which is populated by the 
		checkbox selections on the second page
	*/				
    this.vPage = null;
    this.currentPageIndex = 0;
    
    this.blockme = function() {
        
        $.blockUI({message: "<img src=" + fo.getBlockMeImage() + ">"});    		   
    }        
    
    this.initialize = function(){
        this.vPage = new Array();                    
    }    
    
    this.getVPage = function(){
        
        return this.vPage;   
        
    }   
    
    this.setVPage = function(newVPageArray){
        
        this.vPage   = newVPageArray;
        
    }    
    
    /*
		If the user backs up and selects different items from the checkbox selections
		on the second page. This method will do any requested removals
	*/					
    this.removeFromVPage = function(itemToRemove){
        
        
        this.setVPage(
            this.vPage.filter(
                function(elem){
                    return elem != itemToRemove; 
                }
            )
        );                                                                            
    }    
    
    /*
		Tracks the current page index, i.e. which section the user is currently on
	*/						
    this.getCPI = function(){
        return this.currentPageIndex;
    }
    
    /*
		Manipulates the current page index, up or down based on boolean value argument
	*/							
    this.bumpCPI = function(upOrDown){
        upOrDown ? this.currentPageIndex++ : this.currentPageIndex--;                    
    }    
    
    /*
		Manipulates the current page index, based on value argument
	*/								
    this.setCPI = function(value){
        this.currentPageIndex = value;
    }  
    
    
    this.hideShowSection = function(hideval, showval){  
        vfo.resetAllErrors();
        $("#"+hideval).hide(0);
        $("#"+showval).show(0);            
    }
    
    /*
		Used to navigate from the checkbox page to the next page user has selected.
		If the user has only one selection, show the submit button, instead of the next button
		
	*/								
     this.navSel = function(){   
         vfo.resetAllErrors(); 
         
         if (this.vPage.length==1){  
             n=this.vPage[0];             
             var res = n.replace('p','n');              
             this.hideShowSection(res, 's1');
         }
         this.hideShowSection('p2', this.vPage[0]);
         this.setCPI(0);
     }     
     
     /*
		Used to navigate from the checkbox page to the next page when the user has selected to navigate
		multiple pages on checkbox page
		
	*/								   
    this.multiSelect= function(pVal){     
        this.bumpCPI(true);     
        this.hideShowSection(pVal, this.vPage[this.getCPI()]);
        if ((this.getCPI()+1)==this.vPage.length){  
            /* 
				If we are at the end, show the submit button
			*/
            n=this.vPage[this.getCPI()];
            var res = n.replace('p','n');       
            this.hideShowSection(res, 's1');
        }
    }
    
    /*
		Used to navigate back through the users page selections		
	*/						
    this.multiSelBack = function(){
        
        var pVal = no.getVPage()[no.getCPI()];
        
        if (this.vPage.length==1){  
            n=this.vPage[this.getCPI()];
            var res = n.replace('p','n');              
            this.hideShowSection('s1', res);
        }
        if ((this.getCPI()+1)==this.vPage.length){  
            n=this.vPage[this.getCPI()];
            var res = n.replace('p','n'); 
            this.hideShowSection('s1', res);
        }
        this.bumpCPI(false);        
        if (this.getCPI()==-1){           
            this.hideShowSection(pVal,'p2');            
        }       
        this.hideShowSection(pVal, this.vPage[this.getCPI()]);
    }                
    
    
    
    this.initialize();
    
}

/********************Code to support back button and refresh*****************************
****************************/
function getlocation(){
    var hostName = window.location.hostname; 
    var loc = $("input[id*='pId']").val();
    
    if(!loc){
        loc='IL1';
    }
    
    var planId=loc.replace(1,"").trim();  
    location.replace("https://" + hostName + "/" + planId + "DemographUpdate");
}  

/*
 * This is a hack to get the confirm page to refresh to the initial data entry page.
 * There is probably a better way to handle this.
 */ 

$().ready(  
    function(){
        
        (
            function(window, location) 
            {
                var hostName = window.location.hostname; 
                var loc = $("input[id*='pId']").val();        
                var planId=loc.replace(1,"").trim(); 
                
                /*
                 * Allow the confirm page to refresh with parameters intact.
                 */
                if(location.href.indexOf("confirm") > 0){
                    history.replaceState(null, document.title, "https://" + hostName + "/" + planId + "DemographUpdate");
                    history.pushState(null, document.title, location.pathname);   
                }
                else{
                    history.replaceState(null, document.title, location.pathname+"#!/provider");
                    history.pushState(null, document.title, location.pathname);            
                }
                
                window.addEventListener
                (
                    "popstate", 
                    function() 
                    {
                        if(location.hash === "#!/provider") {
                            history.replaceState(null, document.title, location.pathname);
                            
                            setTimeout
                            (
                                function()
                                {
                                    getlocation();         
                                }
                                ,0
                            );
                        }
                    }, false
                );
            }(window, location)
        );
    }
);
/*************************************************
****************************/