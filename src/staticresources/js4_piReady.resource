
var no = null;
var fo = null;
var vfo = null;
var bo = null; /*Generic instance of the business object. This will be populated with a state specific object */

$().ready(  
    function(){
        
        /*
			 Instantiate objects.
			 */
        no = new navigationObject();
        fo = new fileObject();
        vfo = new validationAndFormattingObject();
        bo = new businessObject(); /*Generic instance of the business object. This will be populated with a state specific object */
        
        $("input[fauxtype='date']").datepicker
        (
            {
                changeMonth: true,
                changeYear: true,
                dateFormat: "mm/dd/yy",
                yearRange: "-100:+4",
                maxDate: "+4y",
                minDate: "-100y",
                onClose: function()
                {
                    if(this.value.length > 0){
                        if($(this).next("span").length > 0){
                            $(this).next("span").hide();
                        }
                        $(this).after("<span id='calendarDeleteAssociated' onclick=vfo.deleteAssociated(this,'" + this.id + "');>X</span>");   
                        
                    }    
                },   
                buttonImage: fo.getCalendarButtonImage(),
                buttonText: "Calendar",
                showOn: "both"            
            }
        ); 
        
        /*	
				
                Add onchange processing for all input type="file"
                PPN-14244 
			*/
        $("input[type='file']")
        .change(			
            function () {
        /*	
				
                If the file passes validation:
                	1.) remove file size
                    2.) "X" for delete
                    3.) Write a new "X" for delete
                    4.) Remove any existing error messages 
                    
                PPN-14244 
			*/                
                if(fo.uploadFile(this)){
                    
					fo.paintFileData(this, true);
                    
                }
                
            }
        );
        
        /*
         * PPN-14244
         * Initialize control to only show first file input
         */ 
        $(".uploadFile")
        .each
        (
            function(){
            	$(this).find("input[type='file']").slice(1).hide();
            }
        );
        
        $(".addAFile")
        .click
        (
            function()
            {
                fo.showNextHidden(this);
            }
        );
        
        
        /*	
				Associate time inputs with timepicker interface
			*/
        $("div#h input[type='text']")
        .timepicker(
            {
                'timeFormat' : 'h:i A',
                'disableTextInput': true
            }    
        )
        .change(
            function()
            {
                if(this.value.length > 0){
                    $(this).siblings().remove();
                    $(this).after("<span id='deleteAssociated' onclick=vfo.deleteAssociated(this,'" + this.id + "');>X</span>");   
                    
                }    
            }				
            
        );       
        
        
        /*	
				Associate Next buttons with validateAndMove function
			*/        
        $("button[type='button'].next").click(
            
            function(){
                var currentButton = this;  	   
                vfo.validateAndMove(currentButton);
                
            }   
            
        ); 
        
        /*	
				Associate inputs and textareas with change event
			*/           
        /* changed from ":input" to "input" */
        $("input, textarea, select").change( 
            function(){
                
                
                
                /*
                    * Sometimes radio button error messages are not directly associated with the fieldset of the initiating radio button.
                    * In this case, look up the home table associated with the error message for the radio button
                    */ 
                   if(this.type == "radio"){	
                       isRemote = ($(this).parentsUntil("fieldset").parent("table[remote='true']").length == 1)? true: false;
                       if(isRemote){
                           /*Remote lookup
                            */
                           $(this).parentsUntil("div.success").parent("div.success").find("table[home='true']").parentsUntil("div.section").parent().find(".additionalErrorMessage").css("display", "none");
                           /*Local lookup
                            */                           
                           $(this).parentsUntil("fieldset").parent().parent().find(".additionalErrorMessage").css("display", "none");					   
                       }
                       else{		   	
                           $(this).parentsUntil("fieldset").parent().parent().find(".additionalErrorMessage").css("display", "none");					   
                       }
                   }	
                   else if(this.type == "select"){
                       $(this).parent().find(".additionalErrorMessage").css("display", "none");                       
                   }
                       else if(this.type == "checkbox"){
                           $(this).parent().parent().find(".additionalErrorMessage").css("display", "none");                       
                       }                   
                   
                   /*				   
						add check to see if data matches pattern definition from input field
						patternMismatch = true if the data does not match the expected pattern
				   				  				 
				   */
                       else if(this.validity.patternMismatch){
                           vfo.populateAnErrorMessage(this, this.title,  "Alert");									
                       }					
                           else if(!this.validity.patternMismatch){
                               $(this).parent().find(".additionalErrorMessage").css("display", "none");
                               
                           }
                   
               }
            )
            .blur(			 
                function(){
                    
                    if(!this.validity.patternMismatch){
                        $(this).parent().find(".additionalErrorMessage").css("display", "none");	
                    }
                }	
                
            );    
        
        
        /*	
				Associate change event for inputs with fieldtype attribute = "current"
		
			$("input[compare='current']").change(
				
			   function(){
					var currentInput = this;
					if(this.value.length > 0){
						vfo.resetAllErrors(); 	
						
					}
					
				   
			   }    
				
			 );
			 */
        
        /*	
				Associate change event for inputs with fieldtype attribute = "tel"
			*/   		
        $("input[fieldtype='tel']").change(
            
            function(){
                var currentInput = this;
                vfo.formatPhone(currentInput);
                
            }    
            
        );   
        
        /*	
				Associate change event for inputs with fieldtype attribute = "email"
			*/   		
        $("input[fieldtype='email']").change(
            
            function(){
                var currentInput = this;
                vfo.validateEmail(currentInput);
                
            }    
            
        ).
        blur(
            function(){
                
                if(this.value.length > 0){
                    var currentInput = this;
                    vfo.validateEmail(currentInput);																		
                }
            }			 					
        ); 
        
        /*	
				Associate change event for inputs with id attribute like "p*"
				
			*/   		        
        /*Added more specific selector for checkbox event handler*/
        $("input[associated*='p']").
        click(
            function() {
                if(this.checked && this.type == "checkbox") {
                    if($(this).attr("associated") != ""){
                        
                        no.getVPage().push($(this).attr("associated"));                            
                        no.getVPage().sort(sortAlphaNum);                                
                        
                    }
                } 
                else{
                    no.removeFromVPage($(this).attr("associated"));
                }
                
            }
        );
        
        
        
        
        
        $(".allow_numeric").
        
        /*
				trap for numbers (48 - 57),  
				         backspace key (8) and
						 Tab key (This key value varied across browsers, so I used the originalEvent.code = "Tab" value)
			*/			
        keypress(
            function(evt) 
            {
                if ((evt.which > 47 && evt.which < 58)  || 
                    evt.which == 8 ||
                    evt.originalEvent.code == "Tab"
                   ) {
                    
                }
                else{
                    evt.preventDefault();
                }
            }
        ); 
        
        /*	
		PPN-14244		
		For every instance of the "uploadFile" class, 
        insert a file format message span after it.
         
		*/              
        $(".uploadFile").
        prepend
        (
            "<span class='fileFormatText'>Note: combined file sizes cannot exceed 25MB." +
            " File formats accepted: .bmp, .doc, .docx, .gif, .jpeg, .jpg, " +  
            ".zip, .pdf, .png, .txt, .xls, .xlsx. User can select only up to 5 total files per request type.</span>"
        );
        
        /*	
		PPN-14244		
		The Remove Group request type has a requirement to only accpet Excel spreadsheets.
      		             
         * Overwrite the message for the Remove Group screen
         */ 
        $("input[id*='removeGrpAttachId1']").parent().find(".fileFormatText:first-of-type").html
        (
            
            "Note: combined file sizes cannot exceed 25MB." +
            " File formats accepted: .xls, .xlsx. User can select only up to 5 total files per request type."
            
        );

         /*	
		PPN-14244		
		Moved onkeypress event for first/last name to external JS
        which aligns it with the rest of the code base.
         */        
        $("input[id*='firstnameSubId'], input[id*='lastnameSubId']").
        keypress(
            function(event){
                (vfo.blockSpecialChar(event))?true:event.preventDefault();					                  
            }
            
        );
        
        /*
         * Because adding required="true" to a check box element, does not 
         * give the expected results.
         */ 
        $("input[id*='attProvGrpId']").attr('required', '');
        
        /*
         * Behaviors for Remove Provider checkboxes
         */ 
        $("input[id*='remFrmAllLocId']").
        click(
            function(){
                vfo.toggleTarget($(this).attr('target'));
                
                if($("input[id*='strAddProvGrp1Id']").val() != ""){
                    $("input[id*='addLocPrvGrpId']").prop('checked', true);                               
                }
                else{
                    $("input[id*='addLocPrvGrpId']").prop('checked', false);      
                    $("#add2").hide();
                }
            }        
        );        
        
        /*
		 * Toggles for 24 hour and add a Remove Provider Address
		 */ 
        $("input[id*='open24Id'], input[id*='addLocPrvGrpId']").click(
            function(){
                vfo.toggleTarget($(this).attr('target'));
            }
        );     
        
        /*
		 * Initialize all non-inlineSkip id'ed back buttons
		 */         
        $(".buttonContainer .back:not(#inlineSkip)").click(
            function(){
                
                no.multiSelBack();                
                
            }
            
        );
        
        /*
         * --Comment out for PPN-16624
         *        
         * Associate the change event of all data entry elements in the current column,
         * i.e. current Billing NPI, current Tax Id, etc....
         * to clear the "Please complete your current information" error message
         *        
        $("input[compare='current']").change(
            function(){
                $(this).parentsUntil(".column").parent().find(".additionalErrorMessage").css("display", "none");					   
                
            }
        
        );
		*/
        /*
         * Associate the change event of the New Tax Id data entry field on the NPI/Tax page,
         * to clear the "W-9" error message
         */                 
        $("input[id*='taxNewId']").change(
            function(){
                $("input[id*='npiAttachId']").parentsUntil(".column").parent().find(".additionalErrorMessage").css("display", "none");					   
                
            }
            
        );       
        
        /*
         * If the user selects the Deceased option for any of the 
         * Reason for Leaving drop downs on the Remove Provider page,
         * make sure the associated Effective Date of Change does not
         * allow dates past today's date.
         */                 
        $("select[id*='reasonleavgrpAllId']").change(
            
            function(){
                $(this).val() == "Deceased" ? vfo.setDatePickerMaxDate("effDateofTrmProvGrpAllId", "+0d") : vfo.setDatePickerMaxDate("effDateofTrmProvGrpAllId", "+4y");                
            }                                 
        );     
        
        $("select[id*='reasonleavgrpId']").change(
            function(){
                $(this).val() == "Deceased" ? vfo.setDatePickerMaxDate("effDateofTrmId", "+0d") : vfo.setDatePickerMaxDate("effDateofTrmId", "+4y");            
            }                     
            
        );             
        
        $("select[id*='reasonleavgrp1']").change(
            function(){
                $(this).val() == "Deceased" ? vfo.setDatePickerMaxDate("effDateofTrm1Id", "+0d") : vfo.setDatePickerMaxDate("effDateofTrm1Id", "+4y");                
            }                  
        );            
        
        /*
         * Add an on-change handler to the yes/no radio button on the Office Physical Address page.
         */ 
        $("input[id*='acordnceWithADA']").change(
            function()
            {
                $("#p5 .additionalErrorMessage").remove();
                $(this).val() == "Yes" ?
                    (
                    $("#p5 .greyedOut input").removeAttr("readonly"),
                    $("#p5 .greyedOut input").parents(".greyedOut").removeClass("greyedOut").addClass("revertToGrey")
                )
                : 
                (
                    $("#p5 .revertToGrey input:checked").prop("checked", false),
                    $("#p5 .revertToGrey input").attr("readonly", "readonly"),
                    $("#p5 .revertToGrey input").parents(".revertToGrey").removeClass("revertToGrey").addClass("greyedOut")
                )
            }                  
        );   
        
        $("#p5 .greyedOut input").attr("readonly", "readonly");
        $("#p5 .greyedOut input, #p5 .revertToGrey input").click
        (
            function(event)
            {
                return ($(this).attr("readonly") != "readonly" )?
                    true
                :false;
            }
            
        );        
        
        
        
    }//end ready function brace          
    
); //end ready function parenthesis 
