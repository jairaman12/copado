

/*
	This object controls the common behaviors for processing Network objects
*/ 
function commonObject()
{
    
    this.genObj = new genericObject();
    
    
    this.loadBehaviors = function(instanceObject)
    {
        
        $( ".designationCodeContainer, .compGridCodeContainer" ).accordion
        (	
            {
                collapsible: true,
                active: false,
                heightStyle: "content",
                animate: false,
                beforeActivate: function( event, ui )
                {
                    //$(this).hide();
                },
                activate: function( event, ui )
                {
                    var newObj = ui.newHeader;
                    var oldObj = ui.oldHeader;
                    $(newObj).find(".psuedoButton").show();
                    $(oldObj).find(".psuedoButton").hide();
                }
            }
        );				
        
        $("li, .networkContainer, .subContainer").draggable(
            {
                helper: "clone",
                zIndex: 100             
            }
            
        ).disableSelection();
        

        
        $(".selectedNetworks").droppable(
            {
                tolerance: "touch",
                drop: function(event, ui)
                {	
                    
                    (new genericObject()).removeAllErrorMessages();
                    
                    (ui.draggable.context.tagName == "LI" )?
                        (
                        $(this).append(ui.draggable),
                        ui.draggable.click
                        (
                            function()
                            {
                                
                                (new commonObject()).listItemDrop(this);
                            }
                        )						
                    )
                    :false;
                    
                    
                    
                    
                    
                }						
                
            }	
        );
        
        $(".trashCan").droppable(
            {
                tolerance: "touch",		
                iObj: instanceObject,
                
                drop: function(event, ui)
                {		
                    
                    (confirm("Are you sure you want to delete this item?"))?
                        (new commonObject()).deleteItemForTrashCan(ui.draggable, $(this).droppable("option", "iObj") )
                    :false;	
                    
                }
                
            }
        );
        
        $("input[type=date], input[fauxdate=true]").after
        (
            function()
            {
                return (new selectedNetworkData()).genObj.returnDateLink(this);
            }	
        );
        
    }
    
    this.processSubContainerForTrashCan = function(drgable)
    {
        
        ($(drgable).siblings(".subContainer").length == 1)?
            (
            $(drgable).find("input").val("")
        )
        :$(drgable).remove()		
    }
    
    
    this.processNetworkContainerForTrashCan = function(drgable, instanceObject)
    {
        
        var co = (new commonObject());
        
        co.addLiForSelectedNetworks($(drgable).find("li"));
        
        ($(drgable).siblings(".networkContainer").length == 1)?
            (		
            instanceObject.createNetworkInstance(),
            co.loadBehaviors(instanceObject)
        )
        :false;
        
        $(drgable).remove();

    }
    
    this.deleteItemForTrashCan = function(drgable, instanceObject)
    {
        var co = (new commonObject());
        
        (drgable.context.tagName == "LI" )?
            (
            co.addLiForSelectedNetworks(drgable),
            drgable.remove()						
        )
        :
        (
            (drgable.context.className.indexOf("networkContainer") > -1)?
            co.processNetworkContainerForTrashCan(drgable, instanceObject)
            :
            co.processSubContainerForTrashCan(drgable)
        )		
        
    }
    
    this.addLiForSelectedNetworks = function(listItems)
    {
        
        $.each
        (
            listItems,
            function(index, value)
            {
                var li = document.createElement("li");
                li.innerText = value.innerText;
                
                $(li).draggable
                (
                    {
                        helper: "clone",
                        zIndex: 100
                        
                    }										
                ).disableSelection();
                
                $("#fullNetworkList").append(li);
            }	
        );	
        
        $(listItems).parent().parent().parent().find(".codesContainer").hide();	
        
    }
    this.createInputContainerRow = function(dataObj)
    {
        
        var tObj = document.createElement("DIV");
        var genericObject = this.genObj;
        
        $.each
        (
            dataObj, 
            function( index, value ) 
            {				
                var icr = genericObject.createAnElement(dataObj[index]);
                $(tObj).append(icr);
            }
        );		
        
        return tObj;				
    }     
    
    this.addClick = function(clickedObj)
    {
        var tlp = $(clickedObj).parent().parent();
        
        var codes    = $(tlp).find("input[type='text']");
        
        var errorElement = this.processCodeValidation(codes); 
        
        
        ( errorElement == null)?
            (new commonObject()).buildRow(clickedObj, tlp)
        	:
        	(
            	(new genericObject()).createAnErrorMessage(errorElement, "Error: You must enter a value."),
        
 				/*
 				 * Hack for lack of accordion knowledge
 				 */            
                setTimeout
                (
                        function()
                        {
                            $(tlp).accordion('option', 'active', 0)
                        }, 
                        100
                )
            );   
        
        return errorElement;
        
    }
    
    
    this.processCodeValidation = function(codes)
    {
        var errorElement = null; 

        $.each
        (
            codes,
            function(index, value)
            {
                var eDate =  $(value).parent().parent().find("[id^='effectiveDate']");

                	($(value).val() != "" && eDate.val() == "")?
                    errorElement = eDate
                	:true;
                    
            }
        );                   
        
        return errorElement;
        
    }
    
    this.buildRow = function(clickedObj, tlp)
    {
        var newRow = null;
        ($(clickedObj).attr("id") == "d")?
            newRow = (new selectedNetworkData()).generateDesignationCodeRow()
        :newRow = (new selectedNetworkData()).generateCompGridCodeRow();
        
        $(newRow).draggable
        (
            {
                helper: "clone",
                zIndex: 100	
            }										
        ).disableSelection();
        
        $(newRow).find("input[type=date], input[fauxdate=true]").after
        (
            function()
            {
                return (new selectedNetworkData()).genObj.returnDateLink(this);
            }	
        );
        
        $(tlp).find(".accordionRowContainer").append(newRow);
        
        
        $(tlp).accordion
        (
            {
                active: true,
                heightStyle: "content"
            }
        );	
        
        
    }
    this.listItemDrop = function(listItem)
    {
        $.each
        (
            $(listItem).siblings().addBack(),
            function(index, value)
            {
                
                   ($(value).attr("active") == "true")?
                        (
                        $(value).attr("active", false),
                        $(value).data("associatedData", (new selectedNetworkData()).saveAssociatedData(value, true)),
                        $(value).css("color","#16325c")
                    )
                    :false;
            }
        );
        
        $(listItem).parent().find("li").css("background-color","#C0C0C0");
        $(listItem).css("background-color","#005fb2");
        $(listItem).css("color","white");
        $(listItem).attr("active", true);
        $(listItem).parent().parent().parent().parent().find(".codesContainer").show();
        ($(listItem).data("associatedData") != undefined)?
            (new selectedNetworkData()).populateAssociatedData(listItem, $(listItem).data("associatedData"))
        :false;
       
    }    
    
    this.validateRequired = function(elementsToValidate)
    {
        
        var genObj = new genericObject();
        var allowAction = true;
        
        $.each
        (
        	elementsToValidate,
            function(index, value)
            {
                (genObj.validateAnElement(value))?
                    true
                :
                (
                    genObj.createAnErrorMessage(value, "Error: You must enter a value."),
                    allowAction = false
                )
                ;
                
                
            }            
        
        );
        
        return allowAction;
        
    }
    
    
    this.validateDatesBeforeDrop = function()
    {
        
        var allDates = $("#selectedNetworkContainer input[id^='ncEffectiveDate']");
        var genObj = (new genericObject());
        var allowAction = true;
        
        $.each
        (
            allDates,
            function(index, value)
            {
                (genObj.validateAnElement(value))?
                    true
                :
                (
                    genObj.createAnErrorMessage(value, "Error: You must enter a value."),
                    allowAction = false
                )
                ;
                
                
            }
            
            
        );
        
        return allowAction;
    }	   
    
    
    this.validateAddButton = function()
    {
        
        var isValid = true;
        var genObj = (new genericObject());
        var iObj = $.find(".selectedNetworks"); 
        
        $.each
        (
            iObj,
            function(index, value)
            {
                
                ($(value).find("li").length > 0)?
                    true
                :
                (
                    genObj.createAnErrorMessage(value, "Error: Please select a network."),
                    isValid = false
                );                
                
                
            }
            
        );
        
        
        
        return isValid;
        
        
    }
    
    this.buildCodesObjects = function(codeContainerName, h6LabelName, buttonId)
    {
        var gObj = new genericObject();
        var cObj = new commonObject();
        
        var cc = gObj.returnObjectWithClassName("div", codeContainerName);
            
            var h6 = document.createElement("h6");
            h6.innerText = h6LabelName;
            
            
            var pBut = gObj.returnObjectWithClassName("span", "psuedoButton");
            pBut.innerHTML = "Add";
            pBut.id = buttonId;		
            
            $(pBut).click
            (
                function()
                {
                    (new commonObject()).addClick(this);
                }	
            );	
            
            
            
            $(h6).append(pBut);
            
            $(cc).append(h6);
            
            
            /*Goes into designationCodeContainer as sibling to h6*/
            
            var arc = gObj.returnObjectWithClassName("div", "accordionRowContainer");
            $(cc).append(arc);
            
            cObj.buildRow(pBut, $(pBut).parent().parent());
        
            return cc;
    }    
    
    this.d1GreaterThanD2 = function(date1, date2)
    {
    	return (new Date(date1) > new Date(date2));
        
    }
    
    this.validateAllEffectiveAndEndDates = function()
    {
        
        var allDates = $(".accordionRowContainer .subContainer");
        var gObj = (new genericObject());
        var allowAction = true;
        
        $.each
        (
            allDates,
            function(index, value)
            {
                
                var effDate = $(value).find("input[id^='effectiveDate']").val();
                var endDate = $(value).find("input[id^='endDate']").val();
                
                (
                    (new commonObject()).d1GreaterThanD2(effDate, endDate) && endDate != ""             	
                 )?
                (
                    gObj.createAnErrorMessage($(value).find("input[id^='endDate']"), "End Date cannot be prior to Effective Date."),
                    allowAction = false
                )
                 :false;
                
                
            }
            
            
        );
        
        return allowAction;
    }	
    
    
    
    
    
    
}//end of object

