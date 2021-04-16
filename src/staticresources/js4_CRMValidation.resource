/*****************************************************************************
* Validations for CRM Case Creation Page
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------                
* Travis Self				06/13/2018				Sprint 12
* Travis Self				06/25/2018				Sprint 13
* Travis Self				07/19/2018				Sprint 15
* Travis Self               08/20/2018              Sprint 17
* Travis Self				09/09/2018				Sprint 19, PPN-24708
* Travis Self				12/10/2018				Sprint 25, PPN-24048
* Josh McGhee				04/17/2019				Sprint 8,  PPN-34485
******************************************************************************/

var saveClicked = false;

// Common validation that occurs whether "Save," "Save & New", or "Save & Clone" is clicked
function commonValidation(buttonName, rerenderEntirePage) {
    
    saveClicked 		= true;
    
    // Items to validate
    var crmTypeSel 				= document.getElementsByClassName('crmReqType')[0];
    var crmItems 				= $(":input[id*='crmTypeBlk']");
    var email					= $('.EmailInput');
    var origin					= $('.OriginInput');
    var corpRecvdDate			= $('input.CorpRecvdDateInput:text');
    var queueDropdowns 			= Array.prototype.slice.call(document.querySelectorAll('[id*="queueDropdown"]'));		//Array of queue dropdown menus where you can choose the Case Owner
    var caseOwnerTypeDropdowns 	= Array.prototype.slice.call(document.querySelectorAll('[id*="picklistSelector"]'));		//Array of queue dropdown menus where you can choose the Case Owner
    var account					= '';
    var entity					= '';
    
    // Error Messages
    var topErrorMessage 	= document.getElementById('topErrorMessage');
    var crmTypeErrorMsg 	= document.getElementById('crmSelectorErrorMsg');
    var errorMessages 		= document.getElementsByClassName('errorMsg');
    var accErrorMsg			= '';
    var entErrorMsg			= '';
    var emailErrorMessage	= $('.emailError');
    var originErrorMessage	= $('.originError');
    var hasErrors 			= false;
    
    // Clear error messages
    for (var i = 0; i < errorMessages.length; i++) {
        errorMessages[i].style.display="none";
    }
    topErrorMessage.style.display = 'none';
    crmTypeErrorMsg.style.display = 'none';
    
    if( $("input.AccountInput:text").val() != null ) {
        account = $("input.AccountInput:text");
        entity 	= $("input.EntityInput:text");
        
        accErrorMsg	= document.getElementById('accErrorMsg').style;
        entErrorMsg	= document.getElementById('entityErrorMsg').style;
        
        accErrorMsg.display  = 'none';
        entErrorMsg.display  = 'none';
        
        if( account.val() == '' && entity.val() == '') {
            accErrorMsg.display = "block";
            entErrorMsg.display = "block";
            hasErrors = true;
        }
        
    }
    
    if(crmTypeSel.value.length == 0) {
        crmTypeErrorMsg.style.display = 'block';
        hasErrors = true;
    }
    
    // Loop through inputs in generated CRM page blocks  
    crmItems.each
    (
        function(index, item)
        {
            var fieldValue 	= item.value;
            var fieldId 	= item.name;
            var fieldTitle	= item.title;
            var fieldOptions	= item.options;
            
            // "Outcome__c" Should NOT be a required field  and the queue dropdown is getting validated later
            if( !fieldId.includes("outcomeField") && !fieldId.includes("queueDropdown") && !fieldId.includes("grievanceField")
               && !fieldTitle.includes("Grievance") && !fieldId.includes("CredentialingNumberId")) {
                
                if(fieldValue.length == 0) {
                    // Appending the Id of this element to its error message in order to find it easily 
                    $( item ).after( "<div id=requiredErrorFor" + fieldId + " class=errorMsg> <strong>Error: </strong> You must enter a value </div>" );
                    hasErrors = true;
                } 
            }
            if(fieldTitle == "Grievance Description - Chosen"){	
                if(fieldOptions.length == 0) {
                    $( item ).after( "<div id=grievanceError class=errorMsg> <strong>Error: </strong> You must enter a value </div>" );
                    hasErrors = true;
                } 
            }
            
        }
    );
    
    // Case Owner Validation 
    for(var i=0; i<queueDropdowns.length; i++) {
        
        var queueDropdownId = queueDropdowns[i].name;
        var queueValue 		= queueDropdowns[i].value;
        var caseOwnerType 	= caseOwnerTypeDropdowns[i];
        
        if(caseOwnerType && caseOwnerType.value == 'Queue' && queueValue == '--None--') {
            // Appending the Id of this element to its error message in order to find it easily 
            $( queueDropdowns[i] ).after( "<div id=requiredErrorFor" + queueDropdownId + " class=errorMsg> <strong>Error: </strong> You must select a value </div>" );
            hasErrors = true;
        }
    }
    
    if( email.val() != '' ) {
        
        emailGood = checkEmail( email.val() );
        
        if(!emailGood) {
            
            $( email ).after( "<div id=requiredErrorFor" + $( email ).attr('name') + " class=errorMsg> <strong>Error: </strong> Invalid Email Address </div>" );
            hasErrors = true;
            
        }
    }
    
    if( origin.val().length == 0 ) {
        $( origin ).after( "<div id=requiredErrorFor" + $( origin ).attr('name') + " class=errorMsg> <strong>Error: </strong> You must enter a value </div>" );
        hasErrors = true;
        
    }
    
    // Corporate Receievd Date validation
    if(undefined != corpRecvdDate.val()) {
        if( corpRecvdDate.val().length == 0 ) {
            
            var dateElement =  $('.dateFormat');
            
            $( dateElement ).after( "<div id=requiredErrorFor" + $( corpRecvdDate ).attr('name') + " class=errorMsg> <strong>Error: </strong> Corporate received date is a required field </div>" );
            hasErrors = true;
            
        }
        
        if(corpRecvdDate.val() != '' ) {
            var dateElement =  $('.dateFormat');
            var dateGood = validCorpRecvdDate(corpRecvdDate.val(), 'Corporate Received Date');
            
            if(!dateGood) {
                $( dateElement ).after( "<div id=requiredErrorFor" + $( corpRecvdDate ).attr('name') + " class=errorMsg> <strong>Error: </strong> Please select only current or past date </div>" );
                hasErrors = true;
            }
        }
    }
    
    if( hasErrors) {
        topErrorMessage.style.display = 'block';
        return false;
    } else if (!hasErrors) {
        if(!rerenderEntirePage) {
            cloneActionFunction();
            return false;
        }
        if(buttonName == 'Save') {
            saveActionFunction(); 
        } else if(buttonName == 'Save & New') {
            saveAndNewActionFunction();
        }
        return false;
    }
}

// This method is called when there is a change on the required fields and/or email field
function onChangeValidation(inputField, fieldLabel) {
    
    // Id and value of input that triggered validation
    var fieldId 				= inputField.name;
    var val 					= inputField.value;
    
    // Items to validate
    var account 				= $("input.AccountInput:text");
    var entity 					= $("input.EntityInput:text");
    
    // Error Messages
    var topErrorMessage 		= document.getElementById('topErrorMessage').style;
    var crmTypeErrorMsg 		= document.getElementById('crmSelectorErrorMsg').style;
    var accErrorMsg				= document.getElementById('accErrorMsg');
    var entErrorMsg				= document.getElementById('entityErrorMsg');
    var commonErrorMsg 			= document.getElementById("requiredErrorFor" + fieldId);
    var clearTopErrorMessage 	= false;
    
    if(fieldLabel == 'CRM Case Type') {
        if ( val.length != 0) {
            
            crmTypeErrorMsg.display = "none";
            clearTopErrorMessage 	= true;
            
        } else if(saveClicked && val.length < 1) {
            
            crmTypeErrorMsg.display = "block";
            
        }
        
    } else if( fieldLabel == 'Case Origin' || fieldLabel == 'Comments' || fieldLabel == 'Priority' || fieldLabel == 'Other Description' || fieldLabel == 'Corporate Received Date' || fieldLabel == 'Case Owner') {
        
        if(commonErrorMsg != null) {
            
            if ( (val != '--None--' || val.length != 0) && commonErrorMsg != null) {
                
                commonErrorMsg.style.display 	= "none";
                clearTopErrorMessage 			= true;
                
            } else if(saveClicked && (val.length < 1 || val == '--None--' ) ) {
                
                commonErrorMsg.style.display = "block";
                
            }
        }  
        
    } else if(fieldLabel == 'Email Address') {
        
        var emailGood = checkEmail(val);
        
        if(commonErrorMsg != null) {
            
            if( emailGood || val.length==0 ) {
                
                commonErrorMsg.style.display 	= "none";
                clearTopErrorMessage 			= true;
                
            } else if( (!emailGood) && saveClicked) {
                
                commonErrorMsg.style.display = "block";
                
            }
        }
    } else if(fieldLabel == 'Account Name' || fieldLabel == 'Case Entity') {
        popPfins();
        
        if(accErrorMsg!=null && entErrorMsg!=null) {
            
            if (  account.val() != '' || entity.val() != '') {
                
                accErrorMsg.style.display 	= "none";
                entErrorMsg.style.display	= "none";
                clearTopErrorMessage 		= true;
                
            } else if(saveClicked && (account.val() == '' && entity.val() == '') ) {
                
                accErrorMsg.style.display = "block";
                entErrorMsg.style.display = "block";
                
            }
        }
    } else if(fieldLabel == 'Picklist Selector' && val == 'User') {
        var x = $(inputField).closest(".caseOwnerSection");
        $(x).find(".errorMsg").hide();
    } else if(fieldLabel == 'Grievance Description - Chosen') {
        var grievanceErrorMsg = document.getElementById("grievanceError");
        for (var i = 0; i < inputField.options.length; i++) {
            if(grievanceErrorMsg != null) {
                if(inputField.options[i].selected) {
                    grievanceErrorMsg.style.display 	= "none";
                    clearTopErrorMessage 		= true;
                    break;
                }
                else if(saveClicked && i == inputField.options.length-1) {
                    grievanceErrorMsg.style.display = "block";
                }
            }
        }	
    }
    
    if( clearTopErrorMessage )
        topErrorMessage.display = 'none';
}


// PPN-39400 Corporate Received Date Validation
function validCorpRecvdDate (val, fieldLabel) {
    
    var dateTimeRegex = /^(0?[1-9]|1[0-2])(\/)(0?[1-9]|[12][0-9]|3[01])(\/)(\d\d\d\d) (00|[0-9]|[0-1][0-2]):([0-9]|[0-5][0-9]) (AM|PM)$/;
    
    if(!dateTimeRegex.test(val)) {
        val.focus;
        return false;
    }
    
    // Get the current Date and convert it to a comparable format with Salesforce
    var currentDateTime = new Date();
    var indexOfLastColon = String(currentDateTime).lastIndexOf(":");
    var strFirstHalfOfDateTime = String(currentDateTime).substring(0, indexOfLastColon);
    var strLastHalfOfDateTime = String(currentDateTime).substring(indexOfLastColon+3, String(currentDateTime).length);
    var strFinalCurrentDateTime = strFirstHalfOfDateTime + ':00' + strLastHalfOfDateTime;
    currentDateTime = new Date(strFinalCurrentDateTime);
    
    // Get the Corporate Received DateTime into comparable format
    var selectedDateTime = new Date(val);
    
    // Check if the selected date in not in the future
    if(selectedDateTime > currentDateTime) {
        console.log('SELECTED DATE > CURRENT DATE');
        console.log('SELECTED DATE: ' + selectedDateTime);
        console.log(' CURRENT DATE: ' + currentDateTime);
        return false;
    }
    
    return true;
}

// Email Validation
function checkEmail(emailToCheck) {
    
    var filter = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    
    if (!filter.test(emailToCheck)) {
        emailToCheck.focus;
        return false;
    }
    return true;
}

function validateKey(field, event) {
    
    var key = window.event ? event.keyCode : event.which;
    
    // Allow only backspace and delete key, clicking either will clear the entire field
    if (event.keyCode == 8 || event.keyCode == 46) {
        $(field).val("");	//Clear the entire field as to not allow user to try submitting shortened input
        return true;
    } else {
        return false;
    }
}