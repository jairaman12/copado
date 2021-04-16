
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
                    onSelect: function ()
                        {
                                this.focus();
                        },
                    onClose: function()
                        {
                        		if(this.value.length > 0){
                                    if($(this).next("span").length > 0){
                                        $(this).next("span").hide();
                                    }
                                    $(this).after("<span id='deleteAssociated' onclick=vfo.deleteAssociated(this,'" + this.id + "');>X</span>");   
                                    
                                }    
                        },   
                    buttonImage: fo.getCalendarButtonImage(),
                    buttonText: "Calendar",
                    showOn: "both"            
                    }
           );     
			

		
		
		/**	$("h1").click(
			
				function(){
				
					$("div#p1 :input").val("9999999999");
					$("div#p1 input[id*='emailSubId']").val("9999999999@co.com");
					$("div#p1 input[id*='nmPrvGrpId']").val("999999999");
															
				}
			
			);**/
		
		
			
			/*	
				Add file type content to all inputs of type=file
			*/
			$("input[type='file']")
			.after(
				"<span class='fileFormatText'>File cannot exceed 5MB. File formats accepted: .bmp, .doc, .docx, .gif, .jpeg, .jpg," +  
				   ".zip, .pdf, .png, .txt, .xls, .xslx.</span>"
			)
			.change(
                	function () {
						$(this).parent().find("#uploadFile")[0].value = this.value.replace("C:\\fakepath\\", "");
					}
				);

			/*	
				Associate time inputs with timepicker interface
			*/
			$("div#h input[type='text']")
			.timepicker(
				{
					'timeFormat' : 'h:i A',
					'disableTextInput': true,
					 'change': function()
						{
								if(this.value.length > 0){
									if($(this).next("span").length > 0){
										$(this).next("span").hide();
									}
									$(this).after("<span id='deleteAssociated' onclick=vfo.deleteAssociated(this,'" + this.id + "');>X</span>");   
									
								}    
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
			$("input, textarea").change( 
			   function(){
				   
				   if(this.type == "radio"){
					   
					   $(this).parentsUntil("fieldset").parent().parent().find(".additionalErrorMessage").css("display", "none");
					   
					}						
				   
				   /*add check if validity fails */
				   else if(!this.checkValidity()){
						vfo.populateAnErrorMessage(this, this.title,  "Alert");									
					}					
				   else if(this.checkValidity()){
						$(this).parent().find(".additionalErrorMessage").css("display", "none");
					/*moved background change to true case for validity check */
						$(this).css("background-color", "#fff");
					}
					
				 /*removed unconditional background change */
				   
				}
			 );        
			
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
								no.getVPage().sort();
								
							}
						} 
						else{
						   no.removeFromVPage($(this).attr("associated"));
						}
					
					}
			   );
			  
			
	  
		   
	 
		$(".allow_numeric").
			/*changed from "input" to "keypress" event */
			keypress(
				function(evt) 
				{
					var self = $(this);
					self.val(self.val().replace(/[^\d].+/, ""));
					if ((evt.which < 48 || evt.which > 57)) {
						evt.preventDefault();
					}
				}
			);    
	
    }//end ready function brace          
                                             
); //end ready function parenthesis 
 
function validationAndFormattingObject()
{       

	
	/*
			Used to hide the "X" associated with calendar controls
			and sets calendar control to = ""
	*/	
    this.deleteAssociated = function(callingObject,objectId){
        $(callingObject).hide();
     	$("input[id*='" + objectId + "']")[0].value = "";   
        
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
			Change all background colors back to white
		*/			
		vfo.resetInputs();		
		

		/*
			Set a glow on the next button for 1 second
		*/
		$("div.buttonContainer .next, div#s1 .sButton").toggleClass("errorGlow", true);
		window.setTimeout(this.undoGlow, 1000);
										      
    }   

	/*
		Disable glow on button
	*/	
	this.undoGlow = function(){
		    $("div.buttonContainer .next, div#s1 .sButton").toggleClass("errorGlow", false);
	}
    
	/*
		Controls error messages which appear under input labels
	*/	    
    this.populateAnErrorMessage = function(object, outputMsg, noTitleMsg){
		
		$(object).parent("p").find(".additionalErrorMessage").remove();
                     
        var eMessage = outputMsg.length < 1 ? noTitleMsg : outputMsg;
      
        $(object).before("<div class='additionalErrorMessage'>" + eMessage + "</div>");

    }
     
     this.getMailFormat = function(){
        this.mailFormat = /([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/;		
        return this.mailFormat;
     }    
     
      this.formatDate = function(fdate){  
         var match   =   fdate.match(/^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/);         
         str=fdate.value.split('/'); 
         dte=new Date(str[1]+'/'+str[0]+'/'+str[2]); 
         mStr=''+(dte.getMonth()+1); 
         mStr=(mStr<10)?'0'+mStr:mStr; 
         if(mStr!=str[1]||isNaN(dte)){ 
		 
			/*
				Passing in a null for the element
			*/
          	vfo.populateAnErrorMessage(null, "Invalid date. Please enter date in MM/DD/YYY format.","Alert");  
			
          }   
                
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
      
      
      this.showMe = function() {
          $("input[id*='open24Id']")[0].checked ? $("#h").hide() : $("#h").show();
      }
      
      this.formatPhone= function(phoneObj) {
          

  		var s2 = (""+phoneObj.value).replace(/\D/g, '');
  		var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
  		if(!m){
            vfo.populateAnErrorMessage(phoneObj, "Please enter a valid phone number.", "Alert");
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
      
      this.resetInputs = function(){
          $("input, textarea").css("background-color", "#fff");    
		  $("div#p2 ul").css("background-color", "#fff");		  
      }    
      
      this.resetErrorDisplay = function(){                
          $("#errorMessageContainer").hide();          
      }    
      
      this.resetAllErrors = function(){
       	this.resetInputs();
        this.resetErrorDisplay();
        this.resetErrorText();
          
      }    
      
      this.nonBusinessRulesValidation = function(parentDiv){
          
		var validationIsGood = true;                                                           
		var firstPageValidation = true;
		var allRequiredValidation = true;

          /*
          	fieldsets with no inline styles are the gimick I use to consider their
            inputs as required.
          */
          var fieldSets = parentDiv.find("fieldset:not([style*='border'])").each(
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
           parentDiv.find(":input", "textarea").each(
               function( index, element ) {
                
                    if(!(element.checkValidity())){
                        vfo.populateAnErrorMessage( element,  element.title, "Please make sure valid data has been entered.");  
                        validationIsGood = false;                        
                    }
               }
           );   
          /*
			Make sure all required fields are filled out for the current section
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
					if(element.value.length > 0){					
							allRequiredValidation = vfo.validateEmail(element);                        						
					}
               }                            
          );		  
		  
		  
		  		
		if(parentDiv[0].id == "p1"){
         	firstPageValidation = this.firstPageRules();   
        }    
		
                                                     
          return (validationIsGood && allRequiredValidation && firstPageValidation);
      }    
      
      
      
      

      this.firstPageRules = function(){
          
         	return (vfo.validateEmail($("input[id*='emailSubId']")[0]) && vfo.formatPhone($("input[id*='telsubId']")[0]));
				
      }    
      
      
      this.secondPageRules = function(){
          
         /*
            Processing check boxes going to next page

            If there are no checkboxes selected
         */
          if( $("div#p2.success input:checkbox:checked").length < 1){              
			  vfo.populateAnErrorMessage($("div#p2 ul"), 'Please select at least one type of change.', 'Alert' );
              return false;
          }
          else{
              return true;
          }
          
				
      }    
                                                 
      this.nameChangeRules = function(){
          
         	if($("input[type='radio'][id*='typProvId:2']")[0].checked == true &&
              $("input[type='file'][id*='nmAttachId']")[0].value.length < 1){                
                vfo.populateAnErrorMessage($("input[type='file'][id*='nmAttachId']"), "If you have selected provider type Group/Clinic, you must include a W-9 form when making a name change.", "Alert" );
            	return false;
          	 }
          else{
              	return true;
          }                    
      }    
      
      this.npiAndTaxIdRules = function(){
               
        
          /** if($("input[type='text'][id*='taxCurId']")[0].value.length > 0 &&
              $("input[type='file'][id*='npiAttachId']")[0].value.length < 1) {               
                vfo.populateAnErrorMessage($("input[type='file'][id*='npiAttachId']"), "You must include a W-9 form when making a Tax ID change.", "Alert" );
            	return false;                                               
            }
          else **/
		  if($("input[type='text'][id*='taxNewId']")[0].value.length > 0 &&
              $("input[type='file'][id*='npiAttachId']")[0].value.length < 1){
                vfo.populateAnErrorMessage($("input[type='file'][id*='npiAttachId']"), "You must include a W-9 form when making a Tax ID change.", "Alert" );
            	return false;                                                            
          }    
          else{
              return true;
          }         
              
                    
       }  
      
      this.officeAndAddressRules = function(){		  
				  
			if ( (vfo.checkHours() || $("input[id*='open24Id']")[0].checked) && $("input[type='text'][id*='addrPhy']")[0].value.length < 1){
                 vfo.populateAnErrorMessage($("input[type='text'][id*='addrPhy']"),"If adding Hours of Operation, please include a physical address.", "Alert" );   				          
				 return false;  
           }else if(($("input[type='text'][id*='addrPhy']")[0].value.length > 1 || $("input[type='text'][id*='addrPhy']")[0].value.length > 1) && ($("input[type='radio'][id*='prLocId:0']")[0].checked == false && $("input[type='radio'][id*='prLocId:1']")[0].checked == false)){
                 vfo.populateAnErrorMessage($("input[type='radio'][id*='prLocId:0']"),"Please select a primary location.", "Alert" );
                 return false;
           }else{			   
			   return true;
		   }          
            
          
       }   
      
      this.otherRules = function(){
                    
          if($('[id$=dobId]').val().length > 0){
          
                var dob = new Date($('[id$=dobId]').val());	

                var age = vfo.getAge(dob);
				
				if (age < 18)
				{
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }else if(age > 100){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }else{
                     
                    return true;
                }				
				
                /**var currentDate = new Date();
                var eighteenYearsAgo = new Date((new Date()).setDate(-18 * 365));
          		var oneHundredYearsAgo = new Date((new Date()).setDate(-100 * 365));
          
          		if(dob >= currentDate){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Date of birth must be less than the current date.", "Alert");
                    return false;                                               
                }
          		else if(dob > eighteenYearsAgo){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }
          		else if(dob < oneHundredYearsAgo){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }else{
                     
                    return true;
                }**/                 	          
   			}   
      
          return true;
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
				
		    $(this).parent().find("label");
                    vfo.populateAnErrorMessage(currentList[index], "Please complete your current information", "Alert" );
                    validationIsGood = false;
                }
              }
          );          
   
   
		return validationIsGood;
   
   }
      
      this.businessRulesValidation = function(parentDiv){
      
      
      	 
        var pageSpecificValidationIsGood = true;   
		var newMatchesCurrent = true; 
		
		if(parentDiv[0].id == "p2"){
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
        
		newMatchesCurrent = this.compareNewAndCurrent(parentDiv);
		
		
       return (pageSpecificValidationIsGood && newMatchesCurrent);
          
      }    
      
	this.validateAndSubmitAllForm = function(){
		/*
			Get the value of the last section from no.getVPage(), use it to determine which section (div with id="p*") the 
			button was called from and find the back button in that section. This value will be passed to the 
			validateAndMove function to determine the parent div of the calling object
		*/
		return this.validateAndMove($("#" + no.getVPage()[no.getCPI()]).find("button[type='button'].back"));
        
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
                 no.blockme();
              }    
              /* More divs to process */
              else{                       
                  $(parentDiv[0]).hide();
               	  no.multiSelect("p" + (no.getCPI() + 1));
              }    
          }
          else if(!businessValidationIsGood || !nonBusinessValidationIsGood){
			vfo.errorHeaderAndGlow();
          }    
          
          return (nonBusinessvalidationIsGood && businessValidationIsGood);

      }   
      
/*******************************************************************************************************/            
   
 
     
     this.validateOtherProvChg = function(){
     
         blockme();
     }
	 
      this.validateEmail = function(inputObject){    
        if(inputObject.value.match(this.getMailFormat())){                
            return true;
        }
        else{                  
            vfo.populateAnErrorMessage(inputObject, "Please check the format of your email address.", "Alert");            
            return false;
        }
      }                  
 }     
 
     
 function fileObject()
 {
                                                            
     this.maxFileSize = 5242880;      //This is the max file size in bytes
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
                   
      this.uploadFile = function(obj) {
	  
			var validationIsGood = true;
	  
           var path = obj.value;  
           var fSize = obj.files[0].size;          
              
              if (fSize >= this.getMaxFileSize()){
				  vfo.populateAnErrorMessage(obj, 'Attached file size is '+this.bytesToSize(fSize)+', Please upload an attachment with size less than 5 MB.','Alert');
				  obj.value = null;
				  validationIsGood = false;
              }    
         
          var ext = path.substring(path.lastIndexOf('.') + 1);    
          if(this.getFileTypes().join(".").indexOf(ext) != -1){              
          }
          else
          {
           obj.value = null;
           vfo.populateAnErrorMessage(obj, "Please upload files types ending with : \n\n bmp, doc, docx, gif, jpeg, jpg, pdf, png, txt, xls, xlsx, zip.",'Alert');   
		   validationIsGood = false;
          }
		  
		  if(!validationIsGood){
			vfo.errorHeaderAndGlow();
		  }
		  
		  return validationIsGood;
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
	this.multiSelBack = function(pVal){          
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
     	var loc = $('[id$=pId]').val();
    
    	if(!loc){
        	loc='IL1';
        }
   
     	var planId=loc.replace(1,"").trim();  
     	location.replace("https://" + hostName + "/" + planId + "DemographUpdate");
 }  
 
(
    function(window, location) 
    {
        history.replaceState(null, document.title, location.pathname+"#!/provider");
        history.pushState(null, document.title, location.pathname);
        
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
/*************************************************
****************************/