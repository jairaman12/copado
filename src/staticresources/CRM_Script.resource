var caseId;
var caseNum;

// Hides the label of fields if they are disabled.
function hideDisabledElements() {
    $( "select:disabled" ).each
    (
        function(index, item)
        {
            $('label[for="' + item.name + '"]').css('display', 'none');
        }
    );
}

// Used to narrow the table down based on search value
function searchPfinTable(searchValue, calledFromOnload) {
    
    var val;
    
    if(calledFromOnload) {
        val = $(searchValue).val();
    } else {
        val = searchValue.value;
    }
    
    var matchingValues = document.getElementsByClassName( 'pfinCheckbox' );
    
    var matchingClassName = val + ' pfinCheckbox';
    
    for(var i=0; i<matchingValues.length; i++) {
        
        var className = matchingValues[i].className.toUpperCase();
        
        if( className.indexOf(val.toUpperCase()) == 0 ) {
            
            $(matchingValues[i]).parent().parent().show();
            if(calledFromOnload) {
                $("." +  val + ".pfinCheckbox").prop('checked', true);
                makeSelect($("." +  val + ".pfinCheckbox"), true);
            }
            
        } else {
             $(matchingValues[i]).parent().parent().hide();
            
        } 
    }
    setScrollBarHeight();
}

function makeSelect(item, calledFromOnload) {
    
    var itemRow  = $(item).parent().parent();
    
    if( item.checked == true || calledFromOnload) {
        
        numberOfSelectedPfins++;
        
        $( itemRow ).addClass('selectedRow');
        
    } else {
        
        numberOfSelectedPfins--;
        
        $( itemRow ).removeClass('selectedRow');
        
    }
    
    checkNumberOfSelected();
}

// Select all pfins
function selectAll(item) {
    
    var pfinCheckboxes = document.getElementsByClassName( 'pfinCheckbox' );
    
    for(var i=0; i<pfinCheckboxes.length; i++) {
        
        var row 	 = $(pfinCheckboxes[i]).parent().parent();
        var rowClass = $(row).attr('class');
        
        
        $( row ).show();
        
        if(item.checked == true) {
            
            if(!rowClass.includes('selectedRow')) {
                
            	$( row ).addClass('selectedRow');
            }
            
            $( pfinCheckboxes[i] ).prop('checked', true);
            
        } else {
            
            if(rowClass.includes('selectedRow')) {
                
            	 $( row ).removeClass('selectedRow');
            }
            
            
            $( pfinCheckboxes[i] ).prop('checked', false);
            
        }
    }
    
    if(item.checked == true) {
        numberOfSelectedPfins = totalNumberOfOptions;
    } else {
        numberOfSelectedPfins = 0;
    }
}

//See how many pfins have been selected
function checkNumberOfSelected() {
    
    disableInputs();
    
    var selectAllCheckbox = document.getElementsByClassName( 'selectAllPfinsCheckbox' );
    
    if(numberOfSelectedPfins == totalNumberOfOptions) {
        
        $( selectAllCheckbox[0] ).prop('checked', true);
        
    } else {
        
        $( selectAllCheckbox[0] ).prop('checked', false);
        
    }
    
}

function setScrollBarHeight() {
    
    if($('.pfinTable').length ) {
    	var scrollHeight1 = $('.pfinTable').height();
    
        // Set height of scrollbars based on table
        if( scrollHeight1 > 200 ) {
            $( ".tableWrapper" ).css('height', 200);
        } else {
            $( ".tableWrapper" ).css('height', scrollHeight1);
        }
    }
    
}

// Used to navigate to newly created case
function openCreatedParentCase(parentCaseId, parentCaseNumber) {
    
    caseId	 = parentCaseId;
    caseNum	 = parentCaseNumber;
    
    //console.log('PARENT CASE ID    : ' + caseId);
    //console.log('PARENT CASE NUMBER: ' + caseNum);
    
    sforce.console.getEnclosingPrimaryTabId(openSubtab);
    
}
    
var openSubtab = function openSubtab(result) {
    //Now that we have the primary tab ID, we can open a new subtab in it
    var primaryTabId = result.id;
    
    sforce.console.openSubtab(primaryTabId , '/' + caseId, true, caseNum, null, openSuccess, caseNum);
};

var openSuccess = function openSuccess(result) {
    //Report whether we succeeded in opening the subtab
    if (result.success == true) {
        console.log('subtab successfully opened');
    } else {
        console.log('subtab cannot be opened');
    }
};

/*
 * This method is used to show/hide the case owner drop down based on where "User" or "Queue" is selected.
 */
function toggleCaseOwnerPicklist(caseOwnerType) {
    var fieldClassName = caseOwnerType.className;
    var caseType = fieldClassName.substring(0,fieldClassName.indexOf('_'));
    var userPicklist = document.getElementsByClassName(caseType + "_userPicklist");
    var queuePicklist = document.getElementsByClassName(caseType + "_queuePicklist");
    
    if(caseOwnerType.value == 'User') {
        $(userPicklist).show();
    	$(queuePicklist).hide();
    } else {
    	$(userPicklist).hide();
        $(queuePicklist).show();
    }
    
    onChangeValidation(caseOwnerType, 'Picklist Selector');
}

