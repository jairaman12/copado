

function selectedNetworkData()
{
	
	this.genObj = new genericObject();
	this.dCode = new addNetworkDesignationCodeData();
	this.cgCode = new addNetworkCompGridCodeData();
	
	
	this.codeRow = function(code,eff, end)
	{
		this.code = code;
		this.effectivedate = eff;
		this.enddate = end;
	
	};
	
	this.selNetRow = function(networkName,role, panel, dCode, cgCode)
	{
		this.networkName = networkName;
		this.role = role;
		this.panel = panel;
		this.designationcode = dCode;
		this.compgridcode = cgCode;

	};
	
	
	this.saveAssociatedData = function(listItem, resetSwitch)
	{
		var pObj = $(listItem).parent().parent().parent();
		var tdcr = this.populateCodes($(pObj).find(".designationCodeContainer input"));
		var tcgcr = this.populateCodes($(pObj).find(".compGridCodeContainer input"));
		var tsnr = new this.selNetRow(listItem.innerText, $(pObj).find("#roleCode").val(), $(pObj).find("#panelCode").val(), tdcr, tcgcr);		
		(resetSwitch)?this.resetCodesValues(pObj):false;
		return tsnr;
	};	
	
	this.populateCodes = function(inputs)
	{
		
		var i = 0;
		var output = new Array();
            
		
		for (i = 0; i < inputs.length / 3; i++) {
			output.push(new this.codeRow($(inputs[(i * 3)]).val(), $(inputs[(i * 3) + 1]).val(), $(inputs[(i * 3) + 2]).val()));
		}
		
		return output;
	}
	
	this.populateSavedRow = function(target, dataObj, dataDefinition)
	{		
		var i = 0;
		var row = null;
		
		$(target).children().remove();	
		
		for (i = 0; i < dataObj.length; i++) {
			var tRow = this.createSubContainerRow(dataDefinition);
			$(tRow).find("input[type='date'], input[fauxdate='true']").after
			(
				function()
				{
					return (new selectedNetworkData()).genObj.returnDateLink(this);
				}	
			);
			
			$(tRow).draggable(
				{
					helper: "clone",
					zIndex: 100
					
				}
			
			).disableSelection();
			var inputs = $(tRow).find("input");
			inputs[0].value = dataObj[i].code;
			inputs[1].value = dataObj[i].effectivedate;
			inputs[2].value = dataObj[i].enddate;
			$(target).append(tRow);
		}		
		
		
	}	
	
	
	
	this.populateAssociatedData = function(listItem, dataObj)
	{
		
		var pObj = $(listItem).parent().parent().parent();
		this.populateSavedRow($(pObj).find(".designationCodeContainer .accordionRowContainer"), dataObj.designationcode, this.dCode.row);
		this.populateSavedRow($(pObj).find(".compGridCodeContainer .accordionRowContainer"), dataObj.compgridcode, this.cgCode.row);
		

		$(pObj).find("#roleCode").val(dataObj.role);
		$(pObj).find("#panelCode").val(dataObj.panel);
	};	
	
	this.resetRemoveAndRemake= function(target, dataDefinition)
	{
		
		$(target).children().remove();
		$(target).append(this.createSubContainerRow(dataDefinition));
		
	$(target).find("input[type='date'], input[fauxdate='true']").after
		(
			function()
			{
				return (new selectedNetworkData()).genObj.returnDateLink(this);
			}	
		);
		
	}	
	
	this.resetCodesValues = function(pObj)
	{
		
		this.resetRemoveAndRemake($(pObj).find(".designationCodeContainer .accordionRowContainer"), this.dCode.row);
		this.resetRemoveAndRemake($(pObj).find(".compGridCodeContainer .accordionRowContainer"), this.cgCode.row);
		
		$(pObj).find("#roleCode").val("none");
		$(pObj).find("#panelCode").val("none");
		
			
	}	
	
	this.generateCodeRow = function(dataDefinition)
	{
		return this.createSubContainerRow(dataDefinition);
	}	

	this.generateDesignationCodeRow = function()
	{		
		return this.createSubContainerRow(this.dCode.row);
	}
	
	this.generateCompGridCodeRow = function()
	{								
		return this.createSubContainerRow(this.cgCode.row);
	}
	
	this.createSubContainerRow = function(dataObj)
	{
		var gObj = this.genObj;
        var cObj = (new commonObject());
		var subCon = gObj.returnObjectWithClassName("div", "subContainer");
		
		
		$.each
		(
			dataObj, 
			function( index, value ) 
			{					
				$(subCon).append(gObj.createAnElement(dataObj[index]));								
			}
		);	
        
        $(subCon).find("input[id^='endDate']").change
        (
            function()
            {
                var effDate = $(subCon).find("input[id^='effectiveDate']").val();

                (this.value != "" && cObj.d1GreaterThanD2(effDate, this.value))?
                    gObj.createAnErrorMessage(this, "End Date cannot be prior to Effective Date.")
                :false;
              
            }

		);
        
        $(subCon).find("input[id='code']").change
        (
            
            function()
            {
                var pObj = $(this).parent().parent();
				var datevalue=$(pObj).parentsUntil("#allSelectedNetworksBand").last().parent().find("[id^='ncEffectiveDate']").val();
                var tObj = $(pObj).find("[id^='effectiveDate']").val(datevalue); 
                
                ($(this).val() != "")?
                    (
            			$(tObj).attr("required", "true"),
                    	$(tObj).siblings().first().addClass("required")
                    )
                :(
                    	$(tObj).attr("required","false"),
                    	$(tObj).siblings().first().removeClass("required")
                
                 );
                
            }
        
        
        );
        
		return subCon;				
	}
	
}	