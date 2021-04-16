
/*
	This object controls the generic behaviors for processing JSON objects
*/ 
 function genericObject()
 {
                	
	this.createAnElement = function(fElement) {
				
		
		var type = fElement["inputType"];
		var labelValue = fElement["label"];
		var required = fElement["required"];
		var id = fElement["id"];
		var className = fElement["class"];
        
		
		var ic = this.returnObjectWithClassName("div","inputContainer");
		
		var lbl = this.returnObjectWithClassName("div","");
			lbl.innerHTML = labelValue;
			lbl.className = (required)? "required":"";
			
		$(ic).append(lbl);
			
				
		var formElements = 
		{

			"date": function()
			{
				
				var dateElement = document.createElement("input");
				dateElement.id = id ;
				dateElement.required = required;
				/*
					Hack for IE's lack of HTML5 input type=date support
                    and need for date formatting in mm/dd/yy
                    means all dates are now not date objects, they are text fields
                    supported by date picker.
				*/
					dateElement.type = "text";
                    dateElement.id = id  + Math.random();
					$(dateElement).attr("fauxdate", true);
                    
					$(dateElement).datepicker
					(
						{
								changeMonth: true,
								changeYear: true,
                            	dateFormat: "mm/dd/yy"
						}	
					);
                    
                   
                    
				/*	
				};
				*/
					
				$(ic).append(dateElement);
				return ic;											
			},
			"ul": function()
			{
				
				var uListElement = document.createElement("ul");
					uListElement.className = className;
					uListElement.required = required;
				
				$(ic).append(uListElement);
				return ic;
					
				
				
			},
			"textarea": function()
			{
				
				var taElement = document.createElement("textarea");
					taElement.className = className;
					taElement.id = id;
					taElement.required = required;
					taElement.placeholder = fElement["placeholder"];
					taElement.cols = fElement["cols"];
					taElement.rows = fElement["rows"];
				
				$(ic).append(taElement);
				return ic;										
			},
			"text": function()
			{
				
				var tElement = document.createElement("input");
					tElement.type = "text";
					tElement.size = 5;
					tElement.className = className;
					tElement.required = required;
                	tElement.id = id;
				
				$(ic).append(tElement);
				return ic;										
			},
			"select": function()
			{							
				var data = fElement["data"];
				var errorMessage = fElement["errormessage"];
                
				var selectElement = document.createElement("select");
				    selectElement.id = id;
					selectElement.required = required;
                
                	(errorMessage == undefined)?
                        true
                    	:selectElement.setAttribute("errormessage",errorMessage);
				
				var noneOption = document.createElement("option");
				
				noneOption.value = "none";
				noneOption.textContent = "---None---";
				selectElement.appendChild(noneOption);
								
                var len = data.length; 
				for(i=0; i<len; i++)
				{
					var dataOption = document.createElement("option");
					dataOption.value = data[i];
					dataOption.textContent = data[i];
					selectElement.appendChild(dataOption);
					 					
				}
						
				$(ic).append(selectElement);
				return ic;
				
				
			}				

		};
		return formElements[type]();
	}       
	
	
	this.validateAnElement = function(fElement) {
				
		var type = fElement.type;
	
		
		var typeCheck = 
		{
			
			"select-one": function()
			{													
				return ($(fElement).val() != "none")?
				true:false
				
								
			},		
			"date": function()
			{													
				return ($(fElement).val() != "")?
				true:false
								
			},		
			"text": function()
			{													
				
				return ($(fElement).val() != "")?
				true:false
								
			}					

		};
		return (fElement.required == true)?typeCheck[type]():true;
	} 
	
	this.createAnErrorMessage = function(element, message)
	{
        
        var errorMessage = $(element).prop("errormessage");
                        
        (errorMessage == undefined)?
            true
        	:message = errorMessage;
        
		$(element).parent().find(".errorMessage").remove();
		var mess = document.createElement("div");
		(message == "" || message == null)?
		message = "You must enter a value"
		:true
		mess.innerHTML = message;
		mess.className = "errorMessage";
		$(element).after(mess);
		$("#topOfPageErrorMessage").show();
		this.removeMessageOnClick(element);
				
	}

	this.returnObjectWithClassName = function(objectType, cName)
	{
		var newObj = document.createElement(objectType);	
		(cName != "")?
		newObj.className = cName
		:false;
		return newObj;
			
	}

    this.removeMessageOnClick = function(element){
		
		$(element).change(
			function()
			{
			
				($(element).val() != "")?
				(
					$(element).siblings(".errorMessage").hide()
				)	
				:false;
				
				$("#topOfPageErrorMessage").hide();
				
			}
		);	
					
	}
	
	this.removeAllErrorMessages = function()
	{
		$("#topOfPageErrorMessage").hide();
		$(".errorMessage").hide();
		
		
		
	}
	
	this.sortSelectOptions = function(selectElement) {
		var options = $(selectElement + " option");

		options.sort(function(a,b) {
			if (a.text.toUpperCase() > b.text.toUpperCase()) return 1;
			else if (a.text.toUpperCase() < b.text.toUpperCase()) return -1;
			else return 0;
		});

		$(selectElement).empty().append( options );
	}	
	
	this.returnDateLink = function(element)
	{
		$(element).parent().find(".stringDate").remove();
		var cDate = new Date();
		var y = cDate.getFullYear();
		var m = ((cDate.getMonth() + 1).toString().length == 1)? "0" + (cDate.getMonth()+1): cDate.getMonth()+1;
		var d = (cDate.getDate().toString().length == 1)? "0" + cDate.getDate(): cDate.getDate();
		//var dateConsume = y + "-" + m + "-" + d; 
		var dateShow =  m + "/" + d + "/" + y; 
		var d  = document.createElement("div");
			d.className = "stringDate";
		var a = document.createElement("a");
			a.innerText = dateShow;
		$(a).click
		(
			function()
			{
				(new genericObject()).removeAllErrorMessages();
				$(this).parent().parent().find(element).val(dateShow);
			}
		);
		$(d).append(a);
		return d;	
	}	
		
	
	
 }