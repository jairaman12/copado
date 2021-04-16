
/*
	This object controls the behaviors for Adding Network Rows
*/

function deleteNetworkObject()
{
    
    this.gObj = (new selectedNetworkData()).genObj;
    this.cObj = (new commonObject());
    this.anObj = new deleteNetworkObjectData();
    
    
    this.init = function()
    {
        
        
        (gHiddenJSON != null && gHiddenJSON != "")?
            this.consumeJSON(gHiddenJSON)
        :this.createNetworkInstance();
        
        this.cObj.loadBehaviors(this);
    }	
    
    this.createNetworkInstance = function()
    {
        this.gObj.removeAllErrorMessages();
        var fnc = this.gObj.returnObjectWithClassName("div", "networkContainer");
        
        var asnb = this.gObj.returnObjectWithClassName("div", "row");
        asnb.id = "allSelectedNetworksBand";
        
        var icr = this.cObj.createInputContainerRow(this.anObj.row);
        
        var fsicr = this.gObj.returnObjectWithClassName("fieldset", "");
        var leg = this.gObj.returnObjectWithClassName("legend", "");
        leg.innerText = "Applies to all selected networks";
        
        $(fsicr).append(leg);
        
        $(fsicr).append(icr);
        
        $(asnb).append(fsicr);
        
        
        /*
			Selected network and code components go into irb
		*/
        var inb = this.gObj.returnObjectWithClassName("fieldset", "row");
        inb.id = "individualNetworksBand";
        
        var legsn = this.gObj.returnObjectWithClassName("legend", "");
        legsn.innerText = "Selected networks";
        
        $(inb).append(legsn);
        
        var clm = this.gObj.returnObjectWithClassName("div", "column");
        
        var ic = this.gObj.returnObjectWithClassName("div", "inputContainer");
        
        var ul = this.gObj.returnObjectWithClassName("ul", "selectedNetworks");
        
        $(ic).append(ul);		
        $(inb).append(ic);
        
        /*
			Add Individual Network band to All Selected Network Band
		*/
        $(asnb).append(inb);
        
        $(fnc).append(asnb);
        
        $("#selectedNetworkContainer").append(fnc);
        
        return fnc;
        
    }	
    
    
    this.harvestJSON = function()
    {
        this.gObj.removeAllErrorMessages();
        
        var outputObj = { "networkGroups" : []};  
         /* Added asterisk to input lookup to support finding
          * dates with IDs added for IE. 
         */
         var tlEffDates = $("input[id^=ncEffectiveDate]");
        
        
        $.each
        (
            tlEffDates,
            function(index, item)
            {
                
                outputObj["networkGroups"][index] = 
                    {
                    "effectiveDate" : item.value,
                    "nwReason": $(item).parents("#allSelectedNetworksBand").find("#nwReason").val(),
                    "comments": $(item).parents("#allSelectedNetworksBand").find("#comments").val()
                };
                
                var selectedNetworks = $(item).parents("#allSelectedNetworksBand").find(".selectedNetworks li");
                (selectedNetworks.length > 0)?
                    selectedNetworks[0].click()
                :(new genericObject()).createAnErrorMessage($(item).parents("#allSelectedNetworksBand").find(".selectedNetworks"), "Please select a network to complete processing.");
                
                
                var len = selectedNetworks.length;
                outputObj["networkGroups"][index]["selectedNetworks"] = new Array();
                var i = 0;
                var snd = new selectedNetworkData();
                
                for(i = 0; i < len; i++)
                {
                    
                    outputObj["networkGroups"][index] ["selectedNetworks"].push(selectedNetworks[i].innerText);
                    
                }
                
            }
        );
        
        
        $("input[id*='hiddenJSON']").val(JSON.stringify(outputObj));
        
        
    }	
    
    this.consumeJSON = function(jObj)
    {
        
        jObj = JSON.parse(jObj);
        var no = (new deleteNetworkObject());
        
        
        $.each
        (
            jObj["networkGroups"],
            function(index, item)
            {
                
                var fnc = no.createNetworkInstance();
                 /* Added asterisk to input lookup to support finding
                  * dates with IDs added for IE. 
                 */                
                $(fnc).find("input[id^=ncEffectiveDate]").val(item.effectiveDate);
                $(fnc).find("#nwReason").val(item.nwReason);
                $(fnc).find("#comments").val(item.comments);
                var listItems = item.selectedNetworks;
                $.each
                (
                    listItems,
                    function(index, value)
                    {
                        
                        $("ul[id*=fullNetworkList] li").
                        filter
                        (
                            function()
                            {
                                return (this.innerText == value)
                            }
                        ).remove();
                        
                        var li = document.createElement("li");
                        li.innerText = value;
                        
                        
                        $(li).data("associatedData", value);
                        
                        
                        $(li).draggable
                        (
                            {
                                helper: "clone",
                                zIndex: 100
                                
                            }										
                        ).disableSelection();
                        
                     
                        
                        $(fnc).find(".selectedNetworks").append(li);
                    }	
                );
                
            }
        );
        
    }
    
    this.processAddButton = function()
    {
        
        (this.cObj.validateAddButton())?
            (			
            this.createNetworkInstance(),
            this.cObj.loadBehaviors(this)
        )
        :false;			
        
    }
    
    
    this.processSaveButton = function()
    {

        (this.cObj.validateAddButton() && this.cObj.validateRequired($(":input[required]")))?
        (
            this.harvestJSON(),
            SaveInfo()
        )
        	:doneSubmitting();       	 
    }
    
    /* 
    * Developer: Travis Self
    * PPN-30828, Used when clicking the back button. Validations do not need to be performed 
    */
    this.processBackButton = function()
    {
        this.harvestJSON();
        saveTempJson();     
    }
    
    /* 
    * Developer: Travis Self
    * PPN-32940
    */
    this.clickAllSelectedRows = function() {
        $("li.ui-draggable.ui-draggable-handle").each(
    		function(index, item) {
        		$(item).click(); 
        	}
		); 
    }
 
}


