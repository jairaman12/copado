
/*
	This object controls the behaviors for Adding Network Rows
*/

function networkObject()
{
    this.snObj = (new selectedNetworkData());
    this.gObj = this.snObj.genObj;
    this.cObj = (new commonObject());
    this.anObj = new addNetworkObjectData();
    this.anDC = new addNetworkDesignationCodeData();
    this.anCGC = new addNetworkCompGridCodeData();	
    this.rpCD = new roleAndPanelCodeData();
    
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
			Role and panel codes
		*/		
        
        var cc = this.gObj.returnObjectWithClassName("div", "column codesContainer");
        
        var r = this.gObj.returnObjectWithClassName("div", "row");
        
        var icr = this.cObj.createInputContainerRow(this.rpCD.row);
        
        $(r).append(icr);
        
        $(cc).append(r);		
        
        /*
			Designation code container
		cc	
			row
			row	
				dcc	
					h6
					arc
						sub
							input
		*/				
        var r2 = this.gObj.returnObjectWithClassName("div", "row");
        
        var dcc = this.cObj.buildCodesObjects("designationCodeContainer", "Designation Code", "d");
		var cgc = this.cObj.buildCodesObjects("compGridCodeContainer", "Comp Grid Code", "cg");       
        
        
        $(r2).append(dcc);
        
        $(r2).append(cgc);
        
        /*
			Put all the codes stuff in the codes container
		*/
        $(cc).append(r2);
        
        $(inb).append(cc);
        
        
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
        var noErrors = true;
        
        
        $.each
        (
            tlEffDates,
            function(index, item)
            {
                
                outputObj["networkGroups"][index] = 
                    {
                    "effectiveDate" : item.value,
                    "comments": $(item).parents("#allSelectedNetworksBand").find("#comments").val()
                };
                
                var selectedNetworks = $(item).parents("#allSelectedNetworksBand").find(".selectedNetworks li"); 
                (selectedNetworks.length > 0)?
                    selectedNetworks[0].click()
                :noErrors = false;
                
                (!noErrors)?
                    (new genericObject()).createAnErrorMessage($(item).parents("#allSelectedNetworksBand").find(".selectedNetworks"), "Please select a network to complete processing.")
                :outputObj = (new networkObject()).continueHarvest(selectedNetworks, outputObj, index);
                
            }
        );		
        
        $("input[id*='hiddenJSON']").val(JSON.stringify(outputObj));
        
        return noErrors;
    }	
    
    this.continueHarvest = function(selectedNetworks, outputObj, index)
    {
        
        var len = selectedNetworks.length;
        outputObj["networkGroups"][index]["selectedNetworks"] = new Array();
        var i = 0;
        var snd = new selectedNetworkData();
        
        for(i = 0; i < len; i++)
        {
            var li = selectedNetworks[i];
            var existingData = $(li).data("associatedData");
            
            (existingData == undefined)?
                $(li).data("associatedData", snd.saveAssociatedData(li,false))
            :false;
            
            var dataObj = $(selectedNetworks[i]).data("associatedData");
            outputObj["networkGroups"][index] ["selectedNetworks"].push(dataObj);
            
        }
        
        return outputObj;
        
    }
    
    this.consumeJSON = function(jObj)
    {
        jObj = JSON.parse(jObj);
        var no = (new networkObject());
        var snd = (new selectedNetworkData());
        
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
                $(fnc).find("#comments").val(item.comments);
                var listItems = item.selectedNetworks;
                
                (listItems == undefined)?
                    true
                :(new networkObject()).continueConsume(listItems, fnc);
                
                
                
            }
        );
        
        ($.find(".selectedNetworks li").length > 0)?
            $.find(".selectedNetworks li")[0].click()
        :false;
        
    }	
    
    
    this.continueConsume = function(listItems, fnc)
    {
        
        $.each
        (
            listItems,
            function(index, value)
            {
                /*
							 * 	If the network name is in the full network list
							 *  remove it
							 */ 
                $("ul[id*=fullNetworkList] li").
                filter
                (
                    function()
                    {
                        return (this.innerText == value.networkName)
                    }
                ).remove();
                
                var li = document.createElement("li");
                li.innerText = value.networkName;
                
                $(li).data("associatedData", value);
                
                
                $(li).draggable
                (
                    {
                        helper: "clone",
                        zIndex: 100
                        
                    }										
                ).disableSelection();
                
                
                $(li).click
                (
                    function()
                    {
                        
                        (new commonObject()).listItemDrop(this);
                    }
                )
                
                
                $(fnc).find(".selectedNetworks").append(li);
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

        (this.cObj.validateAddButton() && this.cObj.validateRequired($(":input[required]")) 
         && this.cObj.validateAllEffectiveAndEndDates() && this.harvestJSON() )?
            SaveInfo()
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


