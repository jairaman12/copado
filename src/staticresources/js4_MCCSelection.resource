/*
 * Create an Object, build it up for use in the code.
 * 
 */ 
var vObj = new Object;

/*
 * Booleans for denoting status
 */ 
vObj.hasBillingPFIN = false;
vObj.hasAdministrationPFIN = false;
vObj.hasServicePFIN = false;

/*
 * Object variables 
*/
vObj.wrapList = new Object;
vObj.caseMode ="";


/*
 * Create associative array which contains functions
 */ 
vObj["Billing"] = 
    function()
{
    vObj.checkItem(vObj.returnElement("bil"), true);  
    vObj.hasBillingPFIN = true;        	
}


vObj["Administration"] = 
    function()
{

    vObj.checkItem(vObj.returnElement("adm"), true)
    vObj.hasAdministrationPFIN = true;
}    

vObj["Service"] = 
    function()
{
    vObj.checkItem(vObj.returnElement("phy"), true)
    vObj.hasServicePFIN = true;        
}	


/*
 * This function sets checkbox 'checked' attribute, adds a readonly attribute and 
 * a click handler to reinforce readonly attribute
 */ 
vObj.checkItem = function(element, setAsChecked)
{
    
    element.prop('checked', setAsChecked);  
    element.attr('readonly', 'readonly');
    $(element).click
    (
        function(event)
        {
            return ($(this).attr("readonly") != "readonly" )?
                true
            :false;
        }
        
    ); 
    
}   

/*
 * Displays client-side error messages on page
 */ 
vObj.showErrorMessage = function(element, message)
{
    
    vObj.addAndShowTopOfPageErrorMessage(message);
    vObj.addElementErrorMessage(element);
    
    return false;
    
}    

vObj.addAndShowTopOfPageErrorMessage = function(message)
{
    var tObj = document.createElement("li");	
    tObj.innerHTML = message;
    
    $("#showOptMsgAlt #message").append(tObj);  
    $("#showOptMsgAlt").show();
    
}


vObj.addElementErrorMessage = function(element)
{
    
    var tObj = document.createElement("div");
    tObj.id = "supplementaryMessage";
    tObj.innerText = "Please select this feature on the PFIN selection page.";
    element.siblings().after(tObj);  
    
}


/*
 * Clears existing error messages from page
 */ 
vObj.clearErrorMessages = function()
{
    $("#showOptMsgAlt").hide();
    $("#showOptMsgAlt #message li").remove();
    $("div[id='supplementaryMessage']").remove();
    
} 

vObj.returnElement = function(elementId)
{
    return $("input[id*='" + elementId + "']");
    
}

vObj.validationObjects = function()
{
    return { 
        "validationObjects": [
            {
                "elementId": "adm",
                "messageInput": "<b>administrative</b>",
                "hasPFINObject": vObj.hasAdministrationPFIN
            },
            {
                "elementId": "bil",
                "messageInput": "<b>billing</b>",
                "hasPFINObject": vObj.hasBillingPFIN
            },
            {
                "elementId": "phy",
                "messageInput": "<b>service location</b>",
                "hasPFINObject": vObj.hasServicePFIN
            },
        ]
    }
}

vObj.validateElements = function()
{
    
    var returnVal = true;
    var lObj = (new vObj.validationObjects()).validationObjects;
    var messageBoilerPlate = "Please select {1} address in PFIN selection page to move forward.";
    
    
    for(var i = 0; i < lObj.length; i++){
        
        ($(vObj.returnElement(lObj[i].elementId)).prop('checked') && lObj[i].hasPFINObject == false)?
            returnVal = vObj.showErrorMessage($(vObj.returnElement(lObj[i].elementId)), messageBoilerPlate.replace("{1}", lObj[i].messageInput))
        :false;
        
    }
    
    return returnVal;
    
}


/*
 * Validates business rules for page, if checkbox is checked, it must have a matching PFIN type
 */ 
vObj.validate = function()
{
    
    vObj.clearErrorMessages();
    return vObj.validateElements();
}

/*
 * Page initialization
 */ 
$(
    function() 
    {
        /*
        Set all checkboxes to false, 
        */
        $("input").prop('checked', false);
        
        
        /*
         * For each item in the wrapper list object, if the "selected Addr" property == true, then execute it's 
         * associated Address type function via vObj 
         */ 
        $.each
        (
            vObj.wrapList,
            function(index, value)
            {
                
                (value["selectedAddr"] && vObj[value["servicePayeeAddress"].CM_SPL_Addr_Type__c] != undefined)?
                    vObj[value["servicePayeeAddress"].CM_SPL_Addr_Type__c]()
                :false;
                
            }  
        );  
        
        /*
         * For every checkbox, clear any existing error messages.
         */ 
        $("input:checkbox").click
        (
            function()
            {
                vObj.clearErrorMessages();   
            }    
            
        );  
        
        
        
    }
);    


